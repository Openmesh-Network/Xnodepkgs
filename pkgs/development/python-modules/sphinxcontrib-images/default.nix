{ lib, python3Packages, fetchurl, fetchFromGitHub, sphinx }:

python3Packages.buildPythonPackage rec {
  pname = "sphinxcontrib-images";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "images";
    rev = "refs/tags/${version}";
    sha256 = "0xmr202yz1a53m65ssmb0kbp3v6xg97ajql9jsikvwy1sc7zwlf6";
  };

  lightboxCSS = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/lightbox2@2.11.3/dist/css/lightbox.css";
    sha256 = "11nnihqkv9m1vafnqx6bk71lqfskfay6qd2lgbbmyvp9dkmwm0rb";
  };

  lightboxJS = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/lightbox2@2.11.3/dist/js/lightbox.js";
    sha256 = "01p4kcf1k04isjizlilxzq315phgqf26c7vzz9ikdj9ib0fmkwh9";
  };

  preCheck = ''
    rm tox.ini
  '';

  nativeBuildInputs = with python3Packages; [ 
    pip 
    sphinx
  ];

  dontCheckRuntimeDeps = true;
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [ 
    requests 
    sphinx
  ];

  postPatch = ''
    mkdir -p sphinxcontrib_images_lightbox2/lightbox2/css
    cp ${lightboxCSS} sphinxcontrib_images_lightbox2/lightbox2/css/lightbox.css
    mkdir -p sphinxcontrib_images_lightbox2/lightbox2/js
    cp ${lightboxJS} sphinxcontrib_images_lightbox2/lightbox2/js/lightbox.js
  '';

  meta = with lib; {
    description = "Sphinx extension for including images in documentation";
    homepage = "https://github.com/sphinx-contrib/images";
    license = licenses.asl20;
  };
}
