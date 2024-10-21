{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.4";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "a0aaed994294f84ba6175d85af5eac9eb2910718";
    sha256 = "5x16/Jl7pwQ+U8za5krpwJ4iqZeLE8QTAtIUyW8T8Sc=";
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
