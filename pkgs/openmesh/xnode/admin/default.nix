{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.4";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "61471fd7efd6c4d4b9fdbff8cee06f157bb5ceac";
    sha256 = "sha256-6LmMhGX1N7KslrPZSGmFN9DB4ULHkCNEmOrIbLBkNPQ=";
  };

  nativeBuildInputs = [
    pkgs.python3Packages.hatchling
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    gitpython
    psutil
    requests
  ];

  meta = with lib; {
    homepage = "https://openmesh.network/";
    description = "Agent service for Xnode reconfiguration and management";
    mainProgram = "openmesh-xnode-admin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ harrys522 j-openmesh ];
  };
}
