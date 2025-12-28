{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  pkgs,
  makeWrapper,
  ...
}:

stdenv.mkDerivation rec {
  pname = "tomu";
  version = "unstable-2025-12-27";

  dontFixup = true;

  src = fetchFromGitHub {
    owner = "6z7y";
    repo = "tomu";
    rev = "d6bed3a358ea0dfdbccacc1c0deaed9fc88671c6";
    hash = "sha256-3T4JjfDfoMAHpaVwe4D7/8/Zosx2X5sxA7+WlOPjv5o=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    ffmpeg
    pkgs.alsa-lib
    pkgs.pulseaudio
  ];

  postPatch = ''
    sed -i 's/-lpthread/-lpthread -lpulse/g' Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 tomu $out/bin/.tomu-wrapped
        cat << EOF > $out/bin/tomu
    #! $SHELL
    export AUDIODEV=pulse
    exec $out/bin/.tomu-wrapped "\$@"
    EOF
      chmod +x $out/bin/tomu
  '';

  meta = {
    description = "Is just a Music player";
    homepage = "https://github.com/6z7y/tomu";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "tomu";
    platforms = lib.platforms.all;
  };
}
