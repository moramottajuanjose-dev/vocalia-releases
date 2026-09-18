#!/usr/bin/env bash
# Instala Vocalia sin pelearse con el aviso de "Apple no pudo verificar...".
#
# Ese aviso sale porque Vocalia se firma con un certificado propio, no con
# uno de Apple, mientras no se pague la notarización oficial. Este script
# quita la marca que dispara el aviso y hace la instalación.
#
# OJO, esto es un parche, no un arreglo permanente: en las versiones más
# nuevas de macOS, Apple cambió la marca de "descargado de internet"
# (com.apple.quarantine, que este script sí puede quitar) por una nueva
# (com.apple.provenance) que un script normal, sin ser administrador, no
# puede tocar. Si tu Mac ya tiene esa versión, este script te lo va a decir
# y te muestra el paso manual en vez de fingir que funcionó.
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/moramottajuanjose-dev/vocalia-releases/main/instalar-mac.sh | bash
#
# O, si ya descargaste el .dmg tú mismo:
#   bash instalar-mac.sh ~/Downloads/Vocalia-X.Y.Z.dmg
set -euo pipefail

REPO="moramottajuanjose-dev/vocalia-releases"
APP_NAME="Vocalia.app"

# Pregunta cuál es la última versión publicada en vez de llevarla escrita:
# GitHub redirige /releases/latest a /releases/tag/<etiqueta>, y de esa
# etiqueta sale el nombre del archivo. Así el script no se queda bajando una
# versión vieja cada vez que se publica una nueva.
latest_dmg_url() {
  local final tag
  final="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest")"
  tag="${final##*/}"
  echo "https://github.com/$REPO/releases/download/$tag/Vocalia-${tag#v}.dmg"
}

manual_steps() {
  cat <<'EOF'

Tu Mac ya tiene una versión donde este atajo no funciona. No es un error
tuyo, ni del archivo: es que Apple cerró ese hueco. Se instala igual, con
un paso más:

  1. Abre el .dmg que se descargó (doble clic).
  2. Arrastra Vocalia a Aplicaciones.
  3. En Aplicaciones, clic DERECHO sobre Vocalia → Abrir.
  4. Sale un segundo aviso, distinto al primero. Ese sí trae el botón Abrir.

Si el clic derecho no ofrece "Abrir": Ajustes del Sistema → Privacidad y
seguridad → baja hasta el final → botón "Abrir de todos modos".

Después de esa primera vez, se abre normal, con doble clic.
EOF
}

echo "Vocalia — instalación"
echo

if [ "${1:-}" != "" ]; then
  DMG="$1"
  if [ ! -f "$DMG" ]; then
    echo "No encuentro el archivo: $DMG"
    exit 1
  fi
  echo "Usando: $DMG"
else
  DMG="$(mktemp -d)/Vocalia.dmg"
  URL="$(latest_dmg_url)"
  echo "Descargando ${URL##*/}..."
  curl -fsSL -o "$DMG" "$URL"
fi

# Quita cualquier marca que dispare el aviso. `-c` limpia lo que se puede;
# el intento explícito de provenance es para no depender de que `-c` la
# alcance a tocar según la versión de xattr.
xattr -cr "$DMG" 2>/dev/null || true
xattr -d com.apple.provenance "$DMG" 2>/dev/null || true

# Se comprueba de verdad, no se asume: es la misma pregunta que se hace
# Gatekeeper al abrir el archivo.
if ! spctl -a -t open --context context:primary-signature "$DMG" 2>/dev/null; then
  echo "El archivo sigue marcado."
  manual_steps
  open "$DMG" 2>/dev/null || true
  exit 0
fi

echo "Listo, sin marca. Instalando..."

MOUNT_DIR="$(mktemp -d)"
hdiutil attach -nobrowse -quiet -mountpoint "$MOUNT_DIR" "$DMG"
trap 'hdiutil detach -quiet "$MOUNT_DIR" 2>/dev/null || true' EXIT

if [ -d "/Applications/$APP_NAME" ]; then
  rm -rf "/Applications/$APP_NAME"
fi
cp -R "$MOUNT_DIR/$APP_NAME" /Applications/
xattr -cr "/Applications/$APP_NAME" 2>/dev/null || true

echo "Vocalia quedó instalada en Aplicaciones."
echo "Abriéndola..."
open "/Applications/$APP_NAME"
