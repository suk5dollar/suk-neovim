#! /bin/sh -e

MAINDIR="$HOME/suk-setup"
INSTALLDIR="$MAINDIR/suk-neovim"
BACKUPDIR="$INSTALLDIR/backup"
BACKUPCONFIGDIR="$BACKUPDIR/config/nvim"
BACKUPLOCALDIR="$BACKUPDIR/local/share/nvim"
BACKUPCACHEDIR="$BACKUPDIR/cache/nvim"
NVIMCONFIGDIR="$HOME/.config/nvim"
NVIMLOCALDIR="$HOME/.local/share/nvim"
NVIMCACHEDIR="$HOME/.cache/nvim"
KICKSTARTDIR="$INSTALLDIR/suk-kickstart"
GITURL="https://github.com/suk5dollar/suk-neovim.git"
GITCMD="git clone $GITURL $INSTALLDIR"

# Create main install directory used for all setups
echo "Creating main setup/install directory"
mkdir -vp "$MAINDIR"

if [ ! -d "$INSTALLDIR" ]; then
    echo "Cloning repo into $INSTALLDIR"
    if [ ! "$($GITCMD)" ]; then
        echo "Successfully cloned repo"
    else
        echo "Failed to clone repo"
        exit 1
    fi
fi

cd "$INSTALLDIR"

echo "Creating backup directories"
mkdir -vp "$BACKUPCONFIGDIR"
mkdir -vp "$BACKUPLOCALDIR"
mkdir -vp "$BACKUPCACHEDIR"

# Backup any existing install config files (if already a link will only save the 
# link not the target)
ARCHIVEDATE="$(date '+%Y-%m-%d_%H:%M:%S')"
if [ -d "$NVIMCONFIGDIR" ]; then
    echo "Backing up: $NVIMCONFIGDIR"
    ARCHIVE="$BACKUPCONFIGDIR/$ARCHIVEDATE.tar.gz"
    tar -czf "$ARCHIVE" "$NVIMCONFIGDIR"                # REMOVED -v flag bcs spams like fck
    echo "Backed up existing .config/nvim files: $ARCHIVE"
fi
 if [ -d "$NVIMLOCALDIR" ]; then
    echo "Backing up $NVIMLOCALDIR"
    ARCHIVE="$BACKUPLOCALDIR/$ARCHIVEDATE"
    tar -czf "$ARCHIVE.tar.gz" "$NVIMLOCALDIR"
    echo "Backed up existing .local/share/nvim files: $ARCHIVE"
fi
if [ -d "$NVIMCACHEDIR" ]; then
    echo "Backing up $NVIMCACHEDIR"
    ARCHIVE="$BACKUPCACHEDIR/$ARCHIVEDATE.tar.gz"
    tar -czf "$ARCHIVE" "$NVIMCACHEDIR"
    echo "Backed up existing .cache/nvim files: $ARCHIVE"
fi

# Remove any existing install config file
echo "Removing previous install files"
rm -rf "$NVIMCONFIGDIR"
rm -rf "$NVIMLOCALDIR"
rm -rf "$NVIMCACHEDIR"

# link .config/nvim to suk-kickstart in setup directory
echo "Creating link to new install/config directory"
ln -s "$KICKSTARTDIR" "$NVIMCONFIGDIR"


# Check for required package mananger
PKMGRS="apt packman"
PKMGR=""
for opt in $PKMGRS; do
    cmd="command -v $opt > /dev/null 2>&1"
    if [ "$($cmd)" ]; then
        PKMGR=$opt
        break
    fi
done

# install dependencies
echo "Install required depedencies"
# will need to swap out xclip for wl-clipboard if ever swap to Wayland or do some checks
if [ "$PKMGR" = "apt" ]; then       # is fzf still problem on debian?
    sudo apt install neovim ripgrep fd_find python-virtualenv luarocks go shellcheck xclip
elif [ "$PKMGR" = "pacman" ]; then
    sudo pacman -S neovim ripgrep fzf python-virtualenv luarocks go shellshock xclip
else
    echo "No supported package manager found"
fi


echo "Done.."








