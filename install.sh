#!/bin/bash
echo "**********************************************"
echo "*                                            *"
echo "*  Installing allWeatherInfo-extension       *"
echo "*  by pedrolucas7i (Pedro Lucas)             *"
echo "*                                            *"
echo "**********************************************"

# Function to install package based on the system
install_package() {
    if command -v apt >/dev/null; then
        echo "[✓] Detected apt (Debian/Ubuntu/Zorin)"
        sudo apt update
        sudo apt install -y gnome-shell-extension-prefs python3-pip
    elif command -v dnf >/dev/null; then
        echo "[✓] Detected dnf (Fedora)"
        sudo dnf install -y gnome-extensions-app python3-pip
    elif command -v pacman >/dev/null; then
        echo "[✓] Detected pacman (Arch/Manjaro)"
        sudo pacman -Sy --noconfirm gnome-extensions python-pip
    elif command -v zypper >/dev/null; then
        echo "[✓] Detected zypper (openSUSE)"
        sudo zypper install -y gnome-extensions python3-pip
    else
        echo "❌ Package manager not recognized. Please install 'gnome-shell-extension-prefs' and 'python3-pip' manually."
        exit 1
    fi
}

# Install GNOME Shell extension manager and Python3 pip
echo "[...] Installing GNOME Shell extension manager and Python dependencies..."
install_package

# Define the extension directory
EXT_DIR="$HOME/.local/share/gnome-shell/extensions/allWeatherInfo-extension@pedrolucas7i"

# Create the extension directory
mkdir -p "$EXT_DIR"

# Ensure the Python script has execute permission
chmod +x ./src/app.py

# Copy the extension files
cp -r ./src/* "$EXT_DIR"

echo "[✓] Files copied to $EXT_DIR"

# Install required Python modules
echo "[✓] Installing required Python modules..."
pip3 install requests

# Try to activate the extension silently (ignore errors)
echo "[✓] Trying to activate the extension..."
gnome-extensions enable allWeatherInfo-extension@pedrolucas7i 2>/dev/null

echo "**********************************************"
echo "*              Installation Done             *"
echo "**********************************************"

# Detect if Wayland session
SESSION_TYPE=$(echo $XDG_SESSION_TYPE)

if [ "$SESSION_TYPE" = "wayland" ]; then
    echo "⚠️  Detected Wayland session"
    echo "🔁 Please logout and log back in to apply the extension!"
else
    echo "➡️  Restart GNOME Shell with: Alt+F2 → type 'r' → Enter"
fi

echo "✅ Then open the 'Extensions' app to manage or toggle the extension if needed."
