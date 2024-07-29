{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.10";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "f73595bca8b944e10f226da3e6bb51cf3bf74b32";
    sha256 = "0hyz4229p4s52g038kw6l2r77wnnvj58snvbc7s2khw1dj298l8s";
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
    #license = with licenses; [ x ];
    maintainers = with maintainers; [ harrys522 j-openmesh ];
  };
}
