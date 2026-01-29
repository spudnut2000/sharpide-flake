{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, libGL
, xorg
, alsa-lib
, libxkbcommon
, fontconfig
, lttng-ust
, openssl
, zlib
, icu
, wayland
, dotnetCorePackages
}:

let
  dotnet-sdk = with dotnetCorePackages; combinePackages [
    sdk_8_0
    sdk_9_0
  ];
in
stdenv.mkDerivation rec {
  pname = "sharpide-bin";
  version = "0.1.19";

  src = fetchurl {
    url = "https://github.com/MattParkerDev/SharpIDE/releases/download/v${version}/sharpide-linux-x64-${version}.tar.gz";
    sha256 = "0mfyczzanqm3aznb7mg4b7jgh2ahj2fx0xdjy7fp5bq0qv7llsg8";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    lttng-ust
    openssl
    zlib
    icu
    libGL
    wayland
    alsa-lib
    libxkbcommon
    fontconfig
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXi
    xorg.libXext
    xorg.libXrender
    dotnet-sdk
  ];

  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sharpide
    cp -r * $out/share/sharpide/
    
    find $out/share/sharpide -maxdepth 1 -type f -name "*.x86_64" -exec chmod +x {} \;
    EXE=$(find $out/share/sharpide -maxdepth 1 -type f -name "*.x86_64" -print -quit)
    
    mkdir -p $out/bin
    
    makeWrapper "$EXE" $out/bin/sharpide \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --prefix PATH : "${lib.makeBinPath [ dotnet-sdk ]}" \
      --set DOTNET_ROOT "${dotnet-sdk}/share/dotnet" \
      --set DOTNET_BUNDLE_EXTRACT_BASE_DIR "$HOME/.cache/sharpide-dotnet"
      
    runHook postInstall
  '';

  meta = with lib; {
    description = "SharpIDE";
    homepage = "https://github.com/MattParkerDev/SharpIDE";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
