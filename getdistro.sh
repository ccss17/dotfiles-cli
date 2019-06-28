#!/bin/bash

distro_shorthand="off"

trim_quotes() {
    trim_output="${1//\'}"
    trim_output="${trim_output//\"}"
    printf "%s" "$trim_output"
}

trim() {
    set -f
    # shellcheck disable=2048,2086
    set -- $*
    printf '%s\n' "${*//[[:space:]]/}"
    set +f
}

get_distro() {
    if type -p lsb_release >/dev/null; then
        case "$distro_shorthand" in
            "on")   lsb_flags="-sir" ;;
            "tiny") lsb_flags="-si" ;;
            *)      lsb_flags="-sd" ;;
        esac
        distro="$(lsb_release "$lsb_flags")"

    elif [[ -f /etc/lsb-release && "$(< /etc/lsb-release)" == *CHROMEOS* ]]; then
        distro="$(awk -F '=' '/NAME|VERSION/ {printf $2 " "}' /etc/lsb-release)"

    elif [[ -f "/etc/os-release" || \
            -f "/usr/lib/os-release" || \
            -f "/etc/openwrt_release" ]]; then
        files=("/etc/os-release" "/usr/lib/os-release" "/etc/openwrt_release")

        # Source the os-release file
        for file in "${files[@]}"; do
            source "$file" && break
        done

        # Format the distro name.
        case "$distro_shorthand" in
            "on")   distro="${NAME:-${DISTRIB_ID}} ${VERSION_ID:-${DISTRIB_RELEASE}}" ;;
            "tiny") distro="${NAME:-${DISTRIB_ID:-${TAILS_PRODUCT_NAME}}}" ;;
            "off")  distro="${PRETTY_NAME:-${DISTRIB_DESCRIPTION}} ${UBUNTU_CODENAME}" ;;
        esac
    else
        for release_file in /etc/*-release; do
            distro+="$(< "$release_file")"
        done
    fi

    distro="$(trim_quotes "$distro")"
    distro="${distro/NAME=}"

    distro="${distro//Enterprise Server}"

    [[ -z "$distro" ]] && distro="$os (Unknown)"

    [[ "${ascii_distro:-auto}" == "auto" ]] && \
        ascii_distro="$(trim "$distro")"
}

get_distro
echo $ascii_distro
