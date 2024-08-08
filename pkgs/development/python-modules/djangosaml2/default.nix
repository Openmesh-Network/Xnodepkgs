{
  stdenv,
  lib,
  isPyPy ? false,
  fetchFromGitHub,
  doCheck ? true,
  python,
  python3Packages,
  python312Packages,
  sphinxcontrib-images
}:

python3Packages.buildPythonPackage rec {
  pname = "djangosaml2";
  version = "v1.9.3";
  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = "djangosaml2";
    rev = "refs/tags/${version}";
    sha256 = "1r89q107k7q2g2d0fic8knzzq6qp16amski1lhrhm6mnw4k89fdd";
  };

  nativeBuildInputs = with python3Packages; [
    sphinx-rtd-theme
    recommonmark
    sphinxcontrib-images
    pyopenssl
  ];

  checkInputs = with python3Packages; [
    pytest
    pytest-django
    pytestCheckHook
  ] ++ lib.optionals isPyPy [ codecov ];

  doCheck = false;

  preCheck = ''
    rm tox.ini
  '';

  passthru = {
    doc = python3Packages.buildPythonPackage {
      pname = "${pname}-doc";
      version = "${version}";

      src = ./.;

      nativeBuildInputs = with python3Packages; [
        sphinx-rtd-theme
        sphinxcontrib-images
        recommonmark
      ];

      preBuild = ''
        mkdir -p doc/source
        echo "${pname} documentation" > doc/source/index.rst
      '';

      buildInputs = [ ];

      doCheck = false;

      meta = with lib; {
        description = "Documentation for ${pname}";
        license = licenses.asl20;
      };
    };
  };

  meta = with lib; {
    description = "Django library for PySAML2 SSO support.";
    homepage = "https://github.com/IdentityPython/djangosaml2";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}