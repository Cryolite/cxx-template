# This Bash file is not designed to be called directly, but rather is read by
# `source` Bash builtin command in the very beginning of another Bash script.

CXX_TEMPLATE_ROOT_DIR="$(readlink -e "${BASH_SOURCE[0]}")"
CXX_TEMPLATE_ROOT_DIR="$(dirname "$CXX_TEMPLATE_ROOT_DIR")"
CXX_TEMPLATE_ROOT_DIR="$(readlink -e "$CXX_TEMPLATE_ROOT_DIR/..")"

PS4='+${BASH_SOURCE[0]}:$LINENO: '
if [[ -t 1 ]] && type -t tput >/dev/null; then
  if (( "$(tput colors)" == 256 )); then
    PS4='$(tput setaf 10)'$PS4'$(tput sgr0)'
  else
    PS4='$(tput setaf 2)'$PS4'$(tput sgr0)'
  fi
fi

__new_args=()
while (( $# > 0 )); do
  arg="$1"
  shift
  case "$arg" in
  --debug)
    __debug=yes
    __new_args+=("$@")
    break
    ;;
  --)
    __new_args+=(-- "$@")
    break
    ;;
  *)
    __new_args+=("$arg")
    ;;
  esac
done
set -- ${__new_args[@]+"${__new_args[@]}"}
unset __new_args
if [[ ${__debug-no} == yes || -v VERBOSE ]]; then
  set -x
fi
unset __debug

function print_error_message ()
{
  if [[ -t 2 ]] && type -t tput >/dev/null; then
    if (( "$(tput colors)" == 256 )); then
      echo "$(tput setaf 9)$1$(tput sgr0)" >&2
    else
      echo "$(tput setaf 1)$1$(tput sgr0)" >&2
    fi
  else
    echo "$1" >&2
  fi
}

function die_with_logic_error ()
{
  set +x
  print_error_message "$1: error: A logic error."
  exit 1
}

function die_with_user_error ()
{
  set +x
  print_error_message "$1: error: $2"
  print_error_message "Try \`$1 --help' for more information."
  exit 1
}

function die_with_runtime_error ()
{
  set +x
  print_error_message "$1: error: $2"
  exit 1
}

__rollback_stack=()

function push_rollback_command ()
{
  __rollback_stack+=("$1")
}

function rollback ()
{
  for (( i = ${#__rollback_stack[@]} - 1; i >= 0; --i )); do
    eval "${__rollback_stack[$i]}"
  done
  __rollback_stack=()
}

trap rollback EXIT
