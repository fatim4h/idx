{ pkgs, authToken ? "", ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.jq
    pkgs.j2cli
    pkgs.nixfmt
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    mkdir "$WS_NAME/.idx/"
    authToken=${authToken} j2 ${./devNix.j2} -o "$WS_NAME/.idx/dev.nix"
    nixfmt "$WS_NAME/.idx/dev.nix"
    cp -r ${./oem/} "$WS_NAME/oem"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"
  '';
}
