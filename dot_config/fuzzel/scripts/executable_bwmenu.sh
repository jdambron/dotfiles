#!/usr/bin/env bash
# Fuzzel extension for BitWarden-cli
NAME="$(basename "$0")"
DEFAULT_CLEAR=5
BW_HASH=

# Options
CLEAR=$DEFAULT_CLEAR # Clear password after N seconds (0 to disable)
SHOW_PASSWORD=no     # Show part of the password in the notification
AUTO_LOCK=900        # 15 minutes, default for bitwarden apps

# Holds the available items in memory
ITEMS=

# Stores which command will be used to emulate keyboard type
AUTOTYPE_MODE=xdotool

# Stores which command will be used to deal with clipboards
CLIPBOARD_MODE=wayland

# Specify what happens when pressing Enter on an item.
# Defaults to copy_password, can be changed to (auto_type all) or (auto_type password)
# ENTER_CMD=copy_password
ENTER_CMD=select_field

# Item type classification
TYPE_LOGIN=1
TYPE_NOTE=2
TYPE_CARD=3
TYPE_IDENTITY=4

# Populated in parse_cli_arguments
FUZZEL_OPTIONS=()
DEDUP_MARK="(+)"

ASK_PASSWORD_COMMAND="fuzzel -d -l 0 --password -p \"Master  Password > \" < /etc/fstab"
SEARCH_COMMAND="fuzzel -d -p \"Name > \""

# Helper functions

# Extract item or items matching .name, including deduplication
# $1: item name, prepended or not with deduplication mark
array_from_name() {
  item_name="$(echo "$1" | sed "s/$DEDUP_MARK //")"
  echo "$ITEMS" | jq -r ". | map(select((.name == \"$item_name\") and (.type == $TYPE_LOGIN)))"
}

# Extract item matching .id
# $1: string starting with ".id:"
array_from_id() {
  echo "$ITEMS" | jq -r ". | map(select(.id == \"$1\"))"
}

# Count the number of items in an array. Return true if more than 1 or none
# $1: Array of items
not_unique() {
  item_count=$(echo "$1" | jq -r '. | length')
  ! [[ $item_count -eq 1 ]]
}

# Pipe a document and deduplicate lines.
# Mark those duplicated by prepending $DEDUP_MARK
dedup_lines() {
  sort | uniq -c |
    sed "s/^\s*1 //" |
    sed -r "s/^\s*[0-9]+ /$DEDUP_MARK /"
}

ask_password() {
  mpw=$(printf '' | eval "$ASK_PASSWORD_COMMAND") || exit $?
  echo "$mpw" | bw unlock 2>/dev/null | grep 'export' | sed -E 's/.*export BW_SESSION="(.*==)"$/\1/' || exit_error $? "Could not unlock vault"
}

get_session_key() {
  if [ $AUTO_LOCK -eq 0 ]; then
    keyctl purge user bw_session &>/dev/null
    BW_HASH=$(ask_password)
  else
    if ! key_id=$(keyctl request user bw_session 2>/dev/null); then
      session=$(ask_password)
      [[ -z "$session" ]] && exit_error 1 "Could not unlock vault"
      key_id=$(echo "$session" | keyctl padd user bw_session @u)
    fi

    if [ $AUTO_LOCK -gt 0 ]; then
      keyctl timeout "$key_id" $AUTO_LOCK
    fi
    BW_HASH=$(keyctl pipe "$key_id")
  fi
}

# source the hash file to gain access to the BitWarden CLI
# Pre-fetch all the items
load_items() {
  if ! ITEMS=$(bw list items --session "$BW_HASH" 2>/dev/null); then
    exit_error $? "Could not load items"
  fi
}

exit_error() {
  local code="$1"
  local message="$2"

  notify-send "Bwmenu error occurred" "$message"

  exit "$code"
}

# Show the menu with options
# Reads items from stdin
menu() {
  eval "$SEARCH_COMMAND"
}

# Show items in a fuzzel menu by name of the item
show_items() {
  if item=$(
    echo "$ITEMS" |
      jq -r ".[] | select( has( \"login\" ) ) | \"\\(.name)\"" |
      dedup_lines |
      menu
  ); then
    item_array="$(array_from_name "$item")"
    "${ENTER_CMD[@]}" "$item_array"
  else
    fuzzel_exit_code=$?
    item_array="$(array_from_name "$item")"
  fi
}

# Similar to show_items() but using the item's ID for deduplication
show_full_items() {
  if item=$(
    echo "$ITEMS" |
      jq -r ".[] | select( has( \"login\" )) | \"\\(.id): name: \\(.name), username: \\(.login.username)\"" |
      menu
  ); then
    item_id="$(echo "$item" | cut -d ':' -f 1)"
    item_array="$(array_from_id "$item_id")"
    "${ENTER_CMD[@]}" "$item_array"
  else
    fuzzel_exit_code=$?
    item_id="$(echo "$item" | cut -d ':' -f 1)"
    item_array="$(array_from_id "$item_id")"
  fi
}

# Show items in a fuzzel menu by url of the item
# if url occurs in multiple items, show the menu again with those items only
show_urls() {
  if url=$(
    echo "$ITEMS" |
      jq -r '.[] | select(has("login")) | .login | select(has("uris")).uris | .[].uri' |
      menu
  ); then
    item_array="$(bw list items --url "$url" --session "$BW_HASH")"
    "${ENTER_CMD[@]}" "$item_array"
  else
    fuzzel_exit_code="$?"
    item_array="$(bw list items --url "$url" --session "$BW_HASH")"
  fi
}

show_folders() {
  folders=$(bw list folders --session "$BW_HASH")
  if folder=$(echo "$folders" | jq -r '.[] | .name' | menu); then

    folder_id=$(echo "$folders" | jq -r ".[] | select(.name == \"$folder\").id")

    ITEMS=$(bw list items --folderid "$folder_id" --session "$BW_HASH")
    show_items
  else
    fuzzel_exit_code="$?"
    folder_id=$(echo "$folders" | jq -r ".[] | select(.name == \"$folder\").id")
    item_array=$(bw list items --folderid "$folder_id" --session "$BW_HASH")
  fi
}

# re-sync the BitWarden items with the server
sync_bitwarden() {
  bw sync --session "$BW_HASH" &>/dev/null || exit_error 1 "Failed to sync bitwarden"

  load_items
  show_items
}

# Auto type using xdotool/ydotool
# $1: what to type; all, username, password
# $2: item array
auto_type() {
  if not_unique "$2"; then
    ITEMS="$2"
    show_full_items
  else
    sleep 0.3
    case "$1" in
    all)
      type_word "$(echo "$2" | jq -r '.[0].login.username')"
      type_tab
      type_word "$(echo "$2" | jq -r '.[0].login.password')"
      ;;
    username)
      type_word "$(echo "$2" | jq -r '.[0].login.username')"
      ;;
    password)
      type_word "$(echo "$2" | jq -r '.[0].login.password')"
      ;;
    esac
  fi

}

type_word() {
  "${AUTOTYPE_MODE[@]}" type "$1"
}

type_tab() {
  "${AUTOTYPE_MODE[@]}" key Tab
}

clipboard-set() {
  clipboard-${CLIPBOARD_MODE}-set
}

clipboard-get() {
  clipboard-${CLIPBOARD_MODE}-get
}

clipboard-clear() {
  clipboard-${CLIPBOARD_MODE}-clear
}

clipboard-wayland-set() {
  wl-copy
}

clipboard-wayland-get() {
  wl-paste
}

clipboard-wayland-clear() {
  wl-copy --clear
}

# Copy the password
# copy to clipboard and give the user feedback that the password is copied
# $1: json array of items
copy_password() {
  if not_unique "$1"; then
    ITEMS="$1"
    show_full_items
  else
    pass="$(echo "$1" | jq -r '.[0].login.password')"

    show_copy_notification "$(echo "$1" | jq -r '.[0]')" "Password"
    echo -n "$pass" | clipboard-set

    if [[ $CLEAR -gt 0 ]]; then
      sleep "$CLEAR"
      if [[ "$(clipboard-get)" == "$pass" ]]; then
        clipboard-clear
      fi
    fi
  fi
}

# Copy the password
# copy to clipboard and give the user feedback that the password is copied
# $1: json array of items
copy_username() {
  if not_unique "$1"; then
    ITEMS="$1"
    show_full_items
  else
    pass="$(echo "$1" | jq -r '.[0].login.username')"

    show_copy_notification "$(echo "$1" | jq -r '.[0]')" "Username"
    echo -n "$pass" | clipboard-set

    if [[ $CLEAR -gt 0 ]]; then
      sleep "$CLEAR"
      if [[ "$(clipboard-get)" == "$pass" ]]; then
        clipboard-clear
      fi
    fi
  fi
}

# Copy the selected field
# copy to clipboard and give the user feedback that the selected field is copied
# $1: json array of items
select_field() {
  extra_fields=""
  totp="$(echo $1 | jq -r '.[0].login.totp')"
  username="$(echo $1 | jq -r '.[0].login.username')"
  password="$(echo $1 | jq -r '.[0].login.password')"

  if [[ $totp != "null" ]]; then
    extra_fields="TOTP\n$extra_fields"
  fi
  if [[ $username != "null" ]]; then
    extra_fields="Username\n$extra_fields"
  fi
  if [[ $password != "null" ]]; then
    extra_fields="Password\n$extra_fields"
  fi

  if not_unique "$1"; then
    ITEMS="$1"
    show_full_items
  else

    if item=$(
      printf "$extra_fields$(echo "$1" | jq -r '.[0].fields | .[] .name')" |
        menu
    ); then
      copy_field "$1" "$item"
    fi
  fi
}

copy_field() {
  if [[ "$2" == "Password" ]]; then
    copy_password "$1"
    return
  elif [[ "$2" == "Username" ]]; then
    copy_username "$1"
    return
  elif [[ "$2" == "TOTP" ]]; then
    copy_totp "$1"
    return
  fi

  # er_id=$(echo "$folders" | jq -r ".[] | select(.name == \"$folder\").id")
  field=$(echo "$1" | jq -r ".[0].fields | .[] | select(.name==\"$2\").value")
  echo $2

  show_copy_notification "$(echo "$1" | jq -r '.[0]')" "$2"
  echo -n "$field" | clipboard-set

  if [[ $CLEAR -gt 0 ]]; then
    sleep "$CLEAR"
    if [[ "$(clipboard-get)" == "$pass" ]]; then
      clipboard-clear
    fi
  fi
}

# Copy the TOTP
# $1: item array
copy_totp() {
  if not_unique "$1"; then
    ITEMS="$item_array"
    show_full_items
  else
    id=$(echo "$1" | jq -r ".[0].id")

    if ! totp=$(bw --session "$BW_HASH" get totp "$id"); then
      exit_error 1 "$totp"
    fi

    show_copy_notification "$(echo "$1" | jq -r '.[0]')" "TOTP"
    echo -n "$totp" | clipboard-set

    if [[ $CLEAR -gt 0 ]]; then
      sleep "$CLEAR"
      if [[ "$(clipboard-get)" == "$pass" ]]; then
        clipboard-clear
      fi
    fi

  fi
}

# Lock the vault by purging the key used to store the session hash
lock_vault() {
  keyctl purge user bw_session &>/dev/null
}

# Show notification about the password being copied.
# $1: json item
show_copy_notification() {
  local title
  local body=""
  local extra_options=()

  title="${2} for $(echo "$1" | jq -r '.name') copied"

  if [[ $SHOW_PASSWORD == "yes" ]]; then
    pass=$(echo "$1" | jq -r '.login.password')
    body="${pass:0:4}****"
  fi

  if [[ $CLEAR -gt 0 ]]; then
    body="$body\nWill be cleared in ${CLEAR} seconds."
    # Keep notification visible while the clipboard contents are active.
    extra_options+=("-t" "$((CLEAR * 1000))")
  fi
  # not sure if icon will be present everywhere, /usr/share/icons is default icon location
  notify-send "$title" "$body" "${extra_options[@]}"
}

parse_cli_arguments() {
  # Use GNU getopt to parse command line arguments
  if ! ARGUMENTS=$(getopt -o c:Cpui: -l auto-lock:,ask-password-command:,error-command:,search-command:,clear:,no-clear,show-password,password,user,help -- "$@"); then
    exit_error 1 "Failed to parse command-line arguments"
  fi
  eval set -- "$ARGUMENTS"

  while true; do
    case "$1" in
    --help)
      cat <<-USAGE
				$NAME $VERSION

				Usage:
				  $NAME [options] -- [fuzzel options]

				Options:
				  --help
				      Show this help text and exit.

				  --auto-lock <SECONDS>
				      Automatically lock the Vault <SECONDS> seconds after last unlock.
				      Use 0 to lock immediatly.
				      Use -1 to disable.
				      Default: 900 (15 minutes)

				  -c <SECONDS>, --clear <SECONDS>
				      Clear password from clipboard after this many seconds.
				      Defaults: ${DEFAULT_CLEAR} seconds.

				  -C, --no-clear
				      Don't automatically clear the password from the clipboard. This disables
				      the default --clear option.

				  --show-password
				      Show the first 4 characters of the copied password in the notification.

				  -p, --password
				      Work with password field.

				  -u, --user
				      Work with username field.

				  --ask-password-command <COMMAND>
				      Ask pasword command. By default it is fuzzel

				  --search-command <COMMAND>
				      Search command. By default it is fuzzel
			USAGE
      shift
      exit 0
      ;;
    --auto-lock)
      AUTO_LOCK=$2
      shift 2
      ;;
    -c | --clear)
      CLEAR="$2"
      shift 2
      ;;
    -C | --no-clear)
      CLEAR=0
      shift
      ;;
    -p | --password)
      ENTER_CMD=copy_password
      shift
      ;;
    -u | --user)
      ENTER_CMD=copy_username
      shift
      ;;
    --show-password)
      SHOW_PASSWORD=yes
      shift
      ;;
    --ask-password-command)
      ASK_PASSWORD_COMMAND=$2
      shift 2
      ;;
    --search-command)
      SEARCH_COMMAND=$2
      shift 2
      ;;
    --)
      shift
      FUZZEL_OPTIONS=("$@")
      break
      ;;
    *)
      exit_error 1 "Unknown option $1"
      ;;
    esac
  done
}

parse_cli_arguments "$@"

get_session_key
select_autotype_command
select_copy_command
load_items
show_items
