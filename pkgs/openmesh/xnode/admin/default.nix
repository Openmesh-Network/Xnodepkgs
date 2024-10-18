{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.4";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "ad6555529ceef81321dd726daaf4e8a9c35d95ab";
    sha256 = "LdgWP/v/qPSmJELSNsGI1G0xS5TTFMWFTUX1XsCMoq8=";
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
