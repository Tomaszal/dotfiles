usage() {
  echo "usage: gnome-shell-rpc <script> [json-args]" >&2
  echo "       gnome-shell-rpc --list" >&2
}

# busctl over gdbus purely for `--json`; parsing GVariant text is worse.
call() {
  busctl --user --json=short call \
    org.gnome.Shell @objectPath@ @interface@ "$@"
}

case "${1-}" in
  -h | --help)
    [[ $# -eq 1 ]] || { usage; exit 1; }
    usage
    exit 0
    ;;
  -l | --list)
    [[ $# -eq 1 ]] || { usage; exit 1; }
    call List | jq -r '.data[0] | fromjson | to_entries[] | "\(.key)\t\(.value)"'
    ;;
  "")
    usage
    exit 1
    ;;
  *)
    [[ $# -le 2 ]] || { usage; exit 1; }
    # `-r` prints string results unquoted, `-c` keeps structured ones on
    # one line, and `select` drops the `null` a script returning nothing
    # produces.
    call Run ss "$1" "${2-}" | jq -rc '.data[0] | fromjson | select(. != null)'
    ;;
esac
