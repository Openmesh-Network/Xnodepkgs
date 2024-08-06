{ python3Packages, fetchurl, lib }:

python3Packages.buildPythonPackage rec {
  pname = "sphinx";
  version = "3.5.4";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/ad/2b/8289bccca4ef5f2981a3182808a27e9d75e1bda4fc5fbb725abf09fcc021/Sphinx-3.5.4.tar.gz";
    sha256 = "1c9c93mvxmv4prrw499wmycgg01srnmb41g1lrb7gp50kxxhn08r"; 
  };

  nativeBuildInputs = [ python3Packages.pip ];

  # Skip all test phases
  doCheck = false;
  checkPhase = "true";

  meta = with lib; {
    description = "Python documentation generator";
    homepage = "https://www.sphinx-doc.org/";
    license = licenses.bsd3;
  };
}
