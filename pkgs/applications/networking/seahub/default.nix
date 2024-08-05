{ lib
, fetchFromGitHub
, fetchpatch
, python3
, makeWrapper
, nixosTests
}:
python3.pkgs.buildPythonApplication rec {
  pname = "seahub";
  version = "11.0.10";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "79bae3cb0942a757c7edee0961198cc08c8d7979"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "1s61gxlb48x3aw6xwmvkx57jl8nbgij222zp5797jmniv83dra86";
  };

  dontBuild = true;

  doCheck = false; # disabled because it requires a ccnet environment

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = with python3.pkgs; [
    django
    future
    django-compressor
    django-statici18n
    django-webpack-loader
    django-simple-captcha
    django-picklefield
    django-formtools
    mysqlclient
    pillow
    python-dateutil
    djangorestframework
    openpyxl
    requests
    requests-oauthlib
    chardet
    pyjwt
    pycryptodome
    qrcode
    pysearpc
    seaserv
    gunicorn
    markdown
    bleach
  ];

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:"
  '';

  passthru = {
    inherit python3;
    pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;
    tests = {
      inherit (nixosTests) seafile;
    };
  };

  meta = with lib; {
    description = "Web end of seafile server";
    homepage = "https://github.com/haiwen/seahub";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh schmittlauch ];
    platforms = platforms.linux;
  };
}