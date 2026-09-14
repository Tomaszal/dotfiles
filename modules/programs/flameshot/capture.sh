mode="${1:-number}"
args=$(jq -cn --arg mode "$mode" '{mode: $mode}')

if target=$(gnome-shell-rpc flameshot-target "$args" 2>/dev/null) &&
  parsed=$(jq -er '[.screen, .region // ""] | @tsv' <<< "$target"); then
  IFS=$'\t' read -r screen region <<< "$parsed"

  case "$mode" in
    number)
      if [[ $screen =~ ^[0-9]+$ ]]; then
        exec flameshot screen --edit --number "$screen"
      fi
      ;;
    screen | window)
      if [[ $screen =~ ^[0-9]+$ ]] &&
        [[ $region =~ ^[0-9]+x[0-9]+[+-][0-9]+[+-][0-9]+$ ]]; then
        exec flameshot screen --edit --number "$screen" --region "$region"
      fi
      ;;
  esac
fi

exec flameshot screen --edit
