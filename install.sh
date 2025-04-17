#!/bin/sh
echo "**********************************************"
echo "*                                            *"
echo "*  Installing zorinOSWeather-extension       *"
echo "*                                            *"
echo "**********************************************"


EXT_DIR="$HOME/.local/share/gnome-shell/extensions/zorinOSWeather-extension@zorin-custom"

# Cria a pasta do GNOME Shell extension
mkdir -p "$EXT_DIR"

# Copia todos os arquivos da src para a pasta da extensão
cp -r ./src/* "$EXT_DIR"

echo "[✓] Files copied to $EXT_DIR"

# Instala dependências Python localmente para o usuário
echo "[✓] Installing required Python modules..."
pip install --user requests

echo "[✓] Installation complete."
echo "➡️  Restart GNOME Shell with: Alt+F2 → type 'r' → Enter"
echo "➡️  Then enable the extension in the GNOME Extensions app."
