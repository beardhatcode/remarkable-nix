{
  description = "A flake for easing the use of a remarkable";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      # Notice the reference to nixpkgs here.
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "rmUtils";
        src = self;
        buildPhase = "true";
        nativeBuildInputs = with nixpkgs; [ makeWrapper ];
        installPhase = ''
          mkdir -p $out/bin; install -t $out/bin re*
          wrapProgram "$out/bin/reFind" --prefix PATH : "${lib.makeBinPath [ fzf jq ]}"
          wrapProgram "$out/bin/rePush" --prefix PATH : "${lib.makeBinPath [ pandoc bash ]}"
          wrapProgram "$out/bin/reSnap" --prefix PATH : "${lib.makeBinPath [ ffmpeg lz4 wl-clipboard bash ]}"
          wrapProgram "$out/bin/reTmp" --prefix PATH : "${lib.makeBinPath [ pandoc bash ]}"
        '';
      };

  };
}
