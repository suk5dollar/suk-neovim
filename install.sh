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


# Check running Platform
echo "Checking running platform"
cmd="command uname -n"
if [ ! "$($cmd)" = "archlinix" ]; then
    echo "Not running on Arch"
    exit 1
fi

# Check for package manager (not really required as already check for archlinux)
echo "Checking required package manager is installed"
cmd="command -v pacman > /dev/null 2>&1"
if [ ! "$($cmd)" ]; then
    echo "Pacman is not on this system"
    exit 1
fi

# Check for git
echo "Checking for git installation"
cmd="command git -v > /dev/null 2>&1"
if [ ! "$($cmd)" ]; then
    echo "Git not found on this system"
    exit 1
fi
 

# Create main install directory used for all setups
echo "Creating main setup/install directory"
mkdir -vp "$MAINDIR"


# Clone repo
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


# Install dependecies
# will need to swap out xclip for wl-clipboard if ever swap to Wayland or do some checks
sudo pacman -S neovim ripgrep fzf python-virtualenv luarocks go shellshock xclip


echo "Done.."








