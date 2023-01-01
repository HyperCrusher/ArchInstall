confirm() {
  clear
  local _prompt _default _response
 
  if [ "$1" ]; then _prompt="$1"; else _prompt="Are you sure"; fi
  _prompt="$_prompt [y/n] ?"
  while true; do
    read -r -p "$_prompt " _response
    case "$_response" in
      [Yy][Ee][Ss]|[Yy])
        return 0
        ;;
      [Nn][Oo]|[Nn]) 
        return 1
        ;;
      *) 
        ;;
    esac
  done
}
