# Install necessary packages
echo "Installing necessary packages..."
sudo apt update && sudo apt install -y vim git curl zsh # Add more packages as needed

# Clone the dotfiles repo if not already present
DOTFILES_DIR=~/dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/mikecarr/simple-config.git "$DOTFILES_DIR"
fi

# Backup existing dotfiles and create symlinks
backup_and_link() {
  if [ -f "$HOME/$1" ]; then
    echo "Backing up existing $1 to $1.bak"
    mv "$HOME/$1" "$HOME/$1.bak"
  fi
  echo "Creating symlink for $1"
  ln -s "$DOTFILES_DIR/$1" "$HOME/$1"
}

# List of dotfiles to link
DOTFILES=(.bashrc .vimrc .gitconfig .zshrc)

for file in "${DOTFILES[@]}"; do
  backup_and_link "$file"
done

# Set zsh as the default shell if installed
if [ -x "$(command -v zsh)" ]; then
  echo "Setting Zsh as the default shell..."
  chsh -s $(which zsh)
fi

echo "Setup complete!"