#!/bin/sh
# Make Neovim (in a Ghostty window) the default app for text and code files.
# Run once per machine: ~/.config/nvim/extras/install.sh
set -e

here=$(dirname -- "$(realpath -- "$0")")
apps=$HOME/.local/share/applications

install -Dm755 "$here/nvim-gui" "$HOME/.local/bin/nvim-gui"
mkdir -p "$apps"
sed "s|@HOME@|$HOME|" "$here/nvim-ghostty.desktop" >"$apps/nvim-ghostty.desktop"
update-desktop-database "$apps" 2>/dev/null || true

# Set as default for every listed type except HTML, which stays with the browser
types=$(sed -n 's/^MimeType=//p' "$here/nvim-ghostty.desktop" | tr ';' ' ' | sed 's|text/html ||')
# shellcheck disable=SC2086
xdg-mime default nvim-ghostty.desktop $types

# EDITOR/VISUAL for apps started outside a shell (applies after next login)
install -Dm644 "$here/editor.conf" "$HOME/.config/environment.d/50-editor.conf"

echo "Done: text files now open in nvim via Ghostty. Log out and back in for EDITOR to reach GUI apps."
