{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.2";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "ef36685eb1f40644e044a70755728f0a25b5f45f";
    sha256 = "1vq390nk0lkhsnmd4rm88xx63v7q2xn5znvyryr20yl66m46gxsp";
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
