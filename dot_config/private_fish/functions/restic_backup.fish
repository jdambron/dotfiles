function restic_backup --description 'Perform restic backup' --argument-names 'password' 'source' 'repo' 'keep_options'
  # Set default values for the arguments
  set password $argv[1]
  set source $argv[2]
  set repo $argv[3]
  set keep_options $argv[4]

  if test -z $password
    set password $RESTIC_PASSWORD
  end
  if test -z $password
    echo "Error: No password provided and RESTIC_PASSWORD environment variable is not set."
    return 1
  end
  if test -z $source
    set source ~
  end
  if test -z $repo
    set repo "/run/media/julien/Maxtor/restic-repo"
  end
  if test -z $keep_options
   set keep_options \
    --keep-daily 6 \
    --keep-weekly 3 \
    --keep-monthly 12 \
    --keep-yearly 3
  end

  # Set excludes
  set excludes \
    --exclude target \
    --exclude node_modules \
    --exclude ~/.mozilla \
    --exclude ~/.cache \
    --exclude ~/.local/share \
    --exclude ~/.npm \
    --exclude ~/.esd_auth \
    --exclude ~/.dmenu_cache \
    --exclude ~/.xsession-errors \
    --exclude ~/.bash_history \
    --exclude ~/.gnome \
    --exclude ~/.hplip \
    --exclude ~/.node-gyp \
    --exclude ~/.config \
    --exclude ~/.cargo \
    --exclude ~/.rustup \
    --exclude ~/.vim \
    --exclude ~/.bun \
    --exclude ~/keybase \
    --exclude ~/workspace \
    --exclude ~/Téléchargements \
    --exclude ~/.logseq \
    --exclude ~/.thumbnails \
    --exclude ".trashed-*.jpg"

  # Check if the restic command is present
  if not type -q restic
    echo "Error: The restic command is not installed or not available in the current environment."
    return 1
  end

  # Perform Restic unlock and capture output
  restic -r $repo unlock

  # Perform Restic backup
  restic -r $repo backup $source $excludes 

  ## Perform Restic forget
  restic -r $repo forget $keep_options --prune --cleanup-cache

  ## Perform Restic check
  restic -r $repo check
end
