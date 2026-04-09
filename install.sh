#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_SRC="$SCRIPT_DIR/plugin"
PLUGIN_DEST="$HOME/.codex/plugins/twelvelabs"
MARKETPLACE="$HOME/.agents/plugins/marketplace.json"

# Check API key
if [ -z "${TWELVELABS_API_KEY:-}" ]; then
  echo "Warning: TWELVELABS_API_KEY is not set. Set it before launching Codex:"
  echo "  export TWELVELABS_API_KEY=\"tlk_YOUR_KEY_HERE\""
  echo ""
fi

# Copy plugin
mkdir -p "$(dirname "$PLUGIN_DEST")"
rm -rf "$PLUGIN_DEST"
cp -r "$PLUGIN_SRC" "$PLUGIN_DEST"
echo "Copied plugin to $PLUGIN_DEST"

# Add marketplace entry
ENTRY='{
  "name": "twelvelabs",
  "source": { "source": "local", "path": "./.codex/plugins/twelvelabs" },
  "policy": { "installation": "AVAILABLE", "authentication": "ON_INSTALL" },
  "category": "Coding"
}'

mkdir -p "$(dirname "$MARKETPLACE")"
if [ -f "$MARKETPLACE" ]; then
  # Remove existing twelvelabs entry if present, then add new one
  python3 -c "
import json, sys
with open('$MARKETPLACE') as f:
    m = json.load(f)
m['plugins'] = [p for p in m.get('plugins', []) if p.get('name') != 'twelvelabs']
m['plugins'].append(json.loads('''$ENTRY'''))
with open('$MARKETPLACE', 'w') as f:
    json.dump(m, f, indent=2)
"
  echo "Added twelvelabs to existing $MARKETPLACE"
else
  cat > "$MARKETPLACE" << EOF
{
  "name": "twelvelabs-marketplace",
  "interface": { "displayName": "Twelve Labs" },
  "plugins": [
    $ENTRY
  ]
}
EOF
  echo "Created $MARKETPLACE"
fi

echo ""
echo "Done. Launch codex, type /plugins, and install Twelve Labs."
