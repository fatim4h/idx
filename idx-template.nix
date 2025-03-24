{ pkgs, authToken ? "", ... }: {
  packages = [
    pkgs.jq
    pkgs.j2cli
    pkgs.nixfmt
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    mkdir "$WS_NAME/.idx/"
    authToken=${authToken} j2 ${./devNix.j2} -o "$WS_NAME/.idx/dev.nix"
    nixfmt "$WS_NAME/.idx/dev.nix"
    cp -r ${./oem} "$WS_NAME/oem"
    cp ${./README.j2} "$WS_NAME/README.md"
    chmod -R +w "$WS_NAME"
    sed -i 's/__AUTH__KEY__/${authToken}/g' "$WS_NAME/oem/tailscale.ps1"
    sed -i "s/__WEB__HOST__/8006-$WEB_HOST/g" "$WS_NAME/README.md"
    sed -i "s/__ENV__/$ENV/g" "$WS_NAME/README.md"
    mv "$WS_NAME" "$out"
  '';
}
