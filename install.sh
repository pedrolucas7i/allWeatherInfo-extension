#!/bin/sh
echo "**********************************************"
echo "*                                            *"
echo "*  Installing zorinOSWeather-extension       *"
echo "*                                            *"
echo "**********************************************"

# Função para instalar pacote com base no sistema
install_package() {
    if command -v apt >/dev/null; then
        echo "[✓] Detected apt (Debian/Ubuntu/Zorin)"
        sudo apt update
        sudo apt install -y gnome-shell-extension-prefs
    elif command -v dnf >/dev/null; then
        echo "[✓] Detected dnf (Fedora)"
        sudo dnf install -y gnome-extensions-app
    elif command -v pacman >/dev/null; then
        echo "[✓] Detected pacman (Arch/Manjaro)"
        sudo pacman -Sy --noconfirm gnome-extensions
    elif command -v zypper >/dev/null; then
        echo "[✓] Detected zypper (openSUSE)"
        sudo zypper install -y gnome-extensions
    else
        echo "❌ Package manager not recognized. Please install 'gnome-shell-extension-prefs' manually."
    fi
}

# Instalar a ferramenta de extensões GNOME
echo "[...] Installing GNOME Shell extension manager..."
install_package

# Define o diretório da extensão
EXT_DIR="$HOME/.local/share/gnome-shell/extensions/zorinOSWeather-extension@zorin-custom"

# Cria o diretório da extensão
mkdir -p "$EXT_DIR"

# Copia os ficheiros da extensão
cp -r ./src/* "$EXT_DIR"

echo "[✓] Files copied to $EXT_DIR"

# Instala dependências Python
echo "[✓] Installing required Python modules..."
pip install --user requests

# Ativa a extensão (ignora erros silenciosamente se não der)
echo "[✓] Trying to activate the extension..."
gnome-extensions enable zorinOSWeather-extension@zorin-custom 2>/dev/null

echo "**********************************************"
echo "*              Installation Done            *"
echo "**********************************************"

# Detectar se é Wayland
SESSION_TYPE=$(echo $XDG_SESSION_TYPE)

if [ "$SESSION_TYPE" = "wayland" ]; then
    echo "⚠️  Detected Wayland session"
    echo "🔁 Please logout and login again to apply the extension!"
else
    echo "➡️  Restart GNOME Shell with: Alt+F2 → type 'r' → Enter"
fi

echo "✅ Then open the 'Extensions' app to manage or toggle the extension if needed."
