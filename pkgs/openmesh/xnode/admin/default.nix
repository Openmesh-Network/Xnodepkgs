{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.8";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "54ebe7a06e2f1237569cd418f7e5a0062133e5f4";
    sha256 = "1wbnk9y7grl39kwcbl4d91z0xl5cc34pxj2gwjmd3v5ayhw92s24";
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
