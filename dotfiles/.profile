# Add ~/.bin to the path if it exists
if [ -d "$HOME/.bin" ]; then
    export PATH=$PATH:$HOME/.bin
fi

# Add ~/.cargo/bin to the path if it exists
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH=$PATH:$HOME/.cargo/bin
fi

# Add ~/.templates to the path if it exists
if [ -d "$HOME/.templates" ]; then
    export PATH=$PATH:$HOME/.templates
fi

# Add ~/go/bin to the path if it exists
if [ -d "$HOME/go/bin" ]; then
    export PATH=$PATH:$HOME/go/bin
fi
