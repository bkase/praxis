{ pkgs, config, lib, ... }:
let
  tuistPkg = pkgs.tuist or null;
  basePkgs = with pkgs; [ jq git fd ripgrep cargo-nextest swiftlint xcbeautify ];
  commonPkgs = basePkgs ++ lib.optional (tuistPkg != null) tuistPkg;
  sanitizeEnv = "env -u CC -u CXX -u OBJC -u OBJCXX -u SDKROOT -u CPATH -u LIBRARY_PATH -u NIX_CFLAGS_COMPILE -u NIX_LDFLAGS -u NIX_CFLAGS_LINK -u NIX_CC -u CFLAGS -u CXXFLAGS -u OBJCFLAGS -u LDFLAGS -u CPPFLAGS -u DYLD_LIBRARY_PATH -u LD -u LDPLUSPLUS";
  xcodeDeveloperDir = "/Applications/Xcode.app/Contents/Developer";
  xcodePath = "${xcodeDeveloperDir}/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin";
  runMomentum = command: ''
      bash -lc '
        set -euo pipefail
        cd apps/momentum
        ${sanitizeEnv} DEVELOPER_DIR=${xcodeDeveloperDir} tuist generate
        ${sanitizeEnv} PATH="${xcodePath}:$PATH" DEVELOPER_DIR=${xcodeDeveloperDir} ${command}
      '
    '';
in {
  apple.sdk = null;

  packages = commonPkgs;

  languages.rust = {
    enable = true;
    channel = "stable";
    version = "latest";
    components = [ "rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" ];
  };

  git-hooks.enable = false;

  tasks."build:aethel".exec = "cargo build --workspace --manifest-path core/aethel/Cargo.toml";
  tasks."test:aethel".exec  = "cargo nextest run --manifest-path core/aethel/Cargo.toml";
  tasks."lint:aethel".exec  = "cargo clippy --manifest-path core/aethel/Cargo.toml --all-targets --all-features -- -D warnings";

  tasks."build:momentum".exec = runMomentum ''
    xcodebuild -workspace Momentum.xcworkspace \
      -scheme MomentumApp \
      -configuration Debug \
      build \
      -skipMacroValidation \
      -quiet
  '';
  tasks."test:momentum".exec = runMomentum ''
    xcodebuild -workspace Momentum.xcworkspace \
      -scheme MomentumApp \
      -configuration Debug \
      test \
      -skipMacroValidation \
      -quiet
  '';
  tasks."lint:momentum".exec = runMomentum ''
    bash -c "set -euo pipefail; ./scripts/run-swift-format.sh lint --recursive --configuration \"$PWD/.swift-format\" \"$PWD\"; swiftlint --strict --path \"$PWD\" || true"
  '';
}
