#!/bin/bash

set -e
set -o pipefail

restic="${RESTIC_BIN:-$(which restic)}"

current_version=""
if [[ -x "${restic}" ]]
then
  current_version="v$(command "$restic" version | awk '{print $2}')"
fi

newest_version="$(curl --compressed -sfL https://api.github.com/repos/restic/restic/releases/latest | jq -r .tag_name)"

if [[ "$current_version" = "$newest_version" ]]
then
  echo "$restic is already at newest version $newest_version" >&2
else
  arch_raw="$(uname -m)"
  arch="$arch_raw"
  case "$arch_raw" in
    x86_64)
      arch=amd64
      ;;
  esac
  download_url="$(curl  --compressed -sfL https://api.github.com/repos/restic/restic/releases/latest | jq -r '.assets | map(select(.name | match("restic_([\\d\\.]+)_linux_'"$arch"'.bz2$")) | .browser_download_url) | first')"
  tmpd="$(mktemp -d)"
  curl -fsL "${download_url}" -o "${tmpd}/restic.bz2"
  bunzip2 "${tmpd}/restic.bz2"
  chmod +x "${tmpd}/restic"
  mv "${tmpd}/restic" "${restic}"
  echo "Updated ${restic} to ${newest_version}"
  rm -rf "${tmpd}"
fi
