#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  TMUX DEV ENVIRONMENT SETUP (Config-Driven)
#
#  Run once:  chmod +x tmux-setup-docker.sh && ./tmux-setup-docker.sh
#  Then:      source ~/.zshrc
#  Edit:      tm edit    (opens your session config)
#  Go:        tm up      (starts everything)
#  Uses `docker` commands throughout — works natively with
#  Docker or with Podman via alias docker="podman".
# ═══════════════════════════════════════════════════════════════

set -e

DOCKER_PATH=$(which docker 2>/dev/null || echo "/usr/local/bin/docker")

# ── 1. Create ~/.tmux.conf ──────────────────────────────────

cat > ~/.tmux.conf << 'TMUXCONF'
# ── Prefix ──────────────────────────────────
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

# ── Intuitive splits ────────────────────────
bind | split-window -h
bind \\ split-window -h
bind - split-window -v
unbind %
unbind '"'

# ── Kill without confirmation ────────────────
bind x kill-pane
bind & kill-window

# ── Status bar ──────────────────────────────
set -g status-style 'bg=#1a1a2e,fg=#e0e0e0'
set -g window-status-current-style 'bg=#16213e,fg=#00d4ff,bold'
set -g window-status-current-format ' #I:#W '
set -g window-status-style 'fg=#666666'
set -g window-status-format ' #I:#W '
set -g status-left '#[fg=#1a1a2e,bg=#00d4ff,bold]  #S #[default] '
set -g status-left-length 30
TMUXCONF

cat >> ~/.tmux.conf << TMUXCONF_DYNAMIC
set -g status-right-length 60
set -g status-right '#[fg=#00d4ff] #(${DOCKER_PATH} ps -q 2>/dev/null | wc -l | tr -d " ") containers  %H:%M '
set -g status-interval 5
TMUXCONF_DYNAMIC

cat >> ~/.tmux.conf << 'TMUXCONF'

# ── Pane borders ────────────────────────────
set -g pane-border-style 'fg=#333333'
set -g pane-active-border-style 'fg=#00d4ff'

# ── Sensible defaults ───────────────────────
set -g mouse on
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on
set -g history-limit 50000
TMUXCONF

echo "✓ ~/.tmux.conf"

# ── 2. Create ~/.tmux-dev.json (only if it doesn't exist) ──

if [ ! -f ~/.tmux-dev.json ]; then
cat > ~/.tmux-dev.json << 'JSONCONFIG'
{
  "sessions": [
    {
      "name": "infra",
      "windows": [
        {
          "name": "infra",
          "path": "~/projects/infra",
          "commands": [
            "docker compose -f docker-compose.infra.yml up -d"
          ]
        },
        {
          "name": "gateway",
          "path": "~/projects/infra",
          "commands": [
            "docker compose -f docker-compose.infra.yml restart my-gateway",
            "docker logs -f my-gateway"
          ]
        }
      ]
    },
    {
      "name": "svc",
      "windows": [
        {
          "name": "api",
          "path": "~/projects/my-service/src/Api",
          "commands": [
            "dotnet run --project Api.csproj"
          ]
        },
        {
          "name": "worker",
          "path": "~/projects/my-service/src/Worker",
          "commands": [
            "dotnet run --project Worker.csproj"
          ]
        },
        {
          "name": "blazor",
          "path": "~/projects/my-service/src/Blazor",
          "commands": [
            "dotnet run --project Blazor.csproj"
          ]
        }
      ]
    },
    {
      "name": "clnt",
      "windows": [
        {
          "name": "mfe",
          "path": "~/projects/client/mfe",
          "commands": [
            "ng build",
            "node ./scripts/generate-version.js",
            "docker compose -f docker-compose.mfe.yml up -d"
          ]
        },
        {
          "name": "host",
          "path": "~/projects/client/host",
          "commands": [
            "pnpm start"
          ]
        }
      ]
    },
    {
      "name": "dash",
      "windows": [
        {
          "name": "containers",
          "commands": [
            "watch -n 5 \"docker ps --format 'table {{.Names}}\\t{{.Status}}\\t{{.Ports}}' | sort\""
          ]
        },
        {
          "name": "resources",
          "commands": [
            "htop"
          ]
        }
      ]
    }
  ]
}
JSONCONFIG
echo "✓ ~/.tmux-dev.json (created — edit your paths!)"
else
echo "○ ~/.tmux-dev.json (already exists, not overwritten)"
fi

# ── 3. Create ~/.tmux-functions.zsh ─────────────────────────

cat > ~/.tmux-functions.zsh << 'ZSHFUNCS'
# ═══════════════════════════════════════════════════════════════
#  TMUX DEV ENVIRONMENT — Config-Driven
#  Config:    ~/.tmux-dev.json
#  Commands:  tm up | tm down | tm <session> | tm ls | tm edit
# ═══════════════════════════════════════════════════════════════

TMUX_DEV_CONFIG="$HOME/.tmux-dev.json"

# ── The engine: parse JSON → tmux commands ──────────────────

__tmux_start_session() {
  local target="$1"
  local attach="${2:-yes}"

  # Already running? Just attach.
  if tmux has-session -t "$target" 2>/dev/null; then
    [ "$attach" = "yes" ] && tmux attach -t "$target"
    return 0
  fi

  # Parse config and build the session
  python3 << PYEOF
import json, os, subprocess, time

config_path = os.path.expanduser("$TMUX_DEV_CONFIG")
with open(config_path) as f:
    config = json.load(f)

target = "$target"
session = next((s for s in config["sessions"] if s["name"] == target), None)
if not session:
    print(f"Session '{target}' not found in config")
    exit(1)

def tmux(*args):
    subprocess.run(["tmux"] + list(args), check=True)

first = True
for window in session.get("windows", []):
    win_name = window["name"]
    win_path = os.path.expanduser(window.get("path", "~"))

    if first:
        tmux("new-session", "-d", "-s", target, "-n", win_name, "-c", win_path)
        first = False
    else:
        tmux("new-window", "-t", target, "-n", win_name, "-c", win_path)

    for cmd in window.get("commands", []):
        time.sleep(0.1)
        tmux("send-keys", "-t", f"{target}:{win_name}", cmd, "Enter")

# Select first window
tmux("select-window", "-t", f"{target}:1")
PYEOF

  [ "$attach" = "yes" ] && tmux attach -t "$target"
}

__tmux_list_configured() {
  python3 << PYEOF
import json, os
config_path = os.path.expanduser("$TMUX_DEV_CONFIG")
with open(config_path) as f:
    config = json.load(f)
for s in config.get("sessions", []):
    windows = ", ".join(w["name"] for w in s.get("windows", []))
    print(f"{s['name']}:{windows}")
PYEOF
}

# ── The main command ────────────────────────────────────────

tm() {
  case "${1:-help}" in

    up)
      echo "Starting all sessions..."
      __tmux_list_configured | while IFS=: read -r name windows; do
        if tmux has-session -t "$name" 2>/dev/null; then
          echo "  ○ $name (already running)"
        else
          __tmux_start_session "$name" "no"
          echo "  ✓ $name  [$windows]"
        fi
      done
      echo ""
      echo "All sessions ready. Use:"
      echo "  tm <n>        attach to a session"
      echo "  Ctrl+Space s     switch sessions (inside tmux)"
      ;;

    down)
      echo "Killing sessions..."
      __tmux_list_configured | while IFS=: read -r name _; do
        if tmux kill-session -t "$name" 2>/dev/null; then
          echo "  ✗ $name"
        else
          echo "  ○ $name (not running)"
        fi
      done
      echo "Done."
      ;;

    ls)
      echo "─── Configured Sessions ───"
      __tmux_list_configured | while IFS=: read -r name windows; do
        if tmux has-session -t "$name" 2>/dev/null; then
          echo "  ● $name  [$windows]"
        else
          echo "  ○ $name  [$windows]"
        fi
      done

      # Show ad-hoc sessions not in config
      local configured=$(__tmux_list_configured | cut -d: -f1)
      local has_adhoc=false
      while IFS= read -r running; do
        if ! echo "$configured" | grep -qx "$running"; then
          if [ "$has_adhoc" = false ]; then
            echo ""
            echo "─── Ad-hoc Sessions ───"
            has_adhoc=true
          fi
          echo "  ● $running"
        fi
      done < <(tmux ls -F '#{session_name}' 2>/dev/null)
      ;;

    edit)
      ${EDITOR:-vim} "$TMUX_DEV_CONFIG"
      ;;

    restart)
      local target="$2"
      if [ -z "$target" ]; then
        echo "Usage: tm restart <session-name>"
        return 1
      fi
      echo "Restarting $target..."
      tmux kill-session -t "$target" 2>/dev/null
      __tmux_start_session "$target" "yes"
      ;;

    validate)
      python3 << PYEOF
import json, os
config_path = os.path.expanduser("$TMUX_DEV_CONFIG")
try:
    with open(config_path) as f:
        config = json.load(f)
    sessions = config.get("sessions", [])
    print(f"✓ Valid JSON — {len(sessions)} session(s) configured:")
    for s in sessions:
        wins = len(s.get("windows", []))
        cmds = sum(len(w.get("commands", [])) for w in s.get("windows", []))
        print(f"  {s['name']}: {wins} window(s), {cmds} command(s)")

    # Check for missing paths
    warnings = []
    for s in sessions:
        for w in s.get("windows", []):
            p = os.path.expanduser(w.get("path", "~"))
            if not os.path.isdir(p):
                warnings.append(f"  ⚠  {s['name']}:{w['name']} — path not found: {w.get('path')}")
    if warnings:
        print("")
        print("Warnings:")
        for w in warnings:
            print(w)
except json.JSONDecodeError as e:
    print(f"✗ Invalid JSON: {e}")
except FileNotFoundError:
    print(f"✗ Config not found: {config_path}")
PYEOF
      ;;

    help|--help|-h)
      cat << 'EOF'

  tm <session>        start or attach to a configured session
  tm up               start ALL sessions in background
  tm down             kill ALL configured sessions
  tm ls               show configured vs running sessions
  tm restart <s>      kill and restart a session
  tm edit             open ~/.tmux-dev.json in your editor
  tm validate         check config for errors and missing paths

EOF
      ;;

    *)
      # Check if it's a configured session name
      if __tmux_list_configured | grep -q "^${1}:"; then
        if tmux has-session -t "$1" 2>/dev/null; then
          echo "● $1 — attaching..."
          tmux attach -t "$1"
        else
          echo "Starting $1..."
          __tmux_start_session "$1" "yes"
        fi
      else
        echo "Unknown session: $1"
        echo ""
        echo "Configured:"
        __tmux_list_configured | while IFS=: read -r name windows; do
          echo "  $name  [$windows]"
        done
        echo ""
        echo "Use 'to $1' for an ad-hoc session."
        return 1
      fi
      ;;
  esac
}

# ── Standalone utilities ────────────────────────────────────

# Ad-hoc session — git-aware default name
to() {
  local SESSION="${1:-$(basename $(git rev-parse --show-toplevel 2>/dev/null || echo scratch))}"
  tmux has-session -t $SESSION 2>/dev/null \
    && tmux attach -t $SESSION \
    || tmux new-session -s $SESSION
}

# Fuzzy log viewer (requires: brew install fzf)
logs() {
  local container=$(docker ps --format '{{.Names}}' 2>/dev/null | fzf --prompt="logs> " --height=40%)
  [ -z "$container" ] && return
  if [ -n "$TMUX" ]; then
    tmux split-window -h "docker logs -f $container"
  else
    docker logs -f "$container"
  fi
}

# Quick status
recap() {
  echo "─── Sessions ───"
  tmux ls 2>/dev/null || echo "  none"
  echo ""
  echo "─── Containers ──"
  docker ps --format "  {{.Names}}: {{.Status}}" 2>/dev/null | sort || echo "  none"
  echo ""
  echo "─── Ports ───────"
  docker ps --format "  {{.Names}}: {{.Ports}}" 2>/dev/null | grep -v ": $" | sort -u || echo "  none"
}

# Cheat sheet
tmuxhelp() {
cat << 'EOF'
═══════════════════════════════════════════════════════════════
                    TMUX CHEAT SHEET
              Prefix = Ctrl+Space (then next key)
═══════════════════════════════════════════════════════════════

─── TM COMMANDS (config-driven) ──────────────────────────────
  tm up / tm down     start/kill all configured sessions
  tm <session>        start or attach to a session
  tm ls               show configured vs running
  tm restart <s>      kill and restart a session
  tm edit             open ~/.tmux-dev.json
  tm validate         check config for errors

─── UTILITIES ────────────────────────────────────────────────
  to [name]           ad-hoc session (git-aware default)
  logs                fuzzy-pick container → tail logs
  recap               quick status: sessions + containers
  tmuxhelp            this cheat sheet

─── SESSIONS ─────────────────────────────────────────────────
  ts <n>           create session        (oh-my-zsh)
  ta <n>           attach                (oh-my-zsh)
  tl                  list sessions         (oh-my-zsh)
  tkss <n>         kill session          (oh-my-zsh)
  Prefix d            detach
  Prefix s            switch between sessions
  Prefix ( / )        prev / next session

─── WINDOWS (tabs) ───────────────────────────────────────────
  Prefix c            new window
  Prefix ,            rename window
  Prefix n / p        next / previous window
  Prefix 1-9          jump to window by number
  Prefix &            kill window

─── PANES (splits) ───────────────────────────────────────────
  Prefix |            split vertical   (side by side)
  Prefix -            split horizontal (top/bottom)
  Prefix ←↑↓→        move between panes
  Prefix z            ZOOM toggle
  Prefix x            kill pane

─── SCROLLING ────────────────────────────────────────────────
  Prefix [            enter scroll mode (↑↓ PgUp PgDn)
  q                   exit scroll mode
═══════════════════════════════════════════════════════════════
EOF
}
ZSHFUNCS

echo "✓ ~/.tmux-functions.zsh"

# ── 4. Wire into .zshrc ─────────────────────────────────────

ZSHRC_LINE='[ -f ~/.tmux-functions.zsh ] && source ~/.tmux-functions.zsh'

if ! grep -qF "tmux-functions.zsh" ~/.zshrc 2>/dev/null; then
  echo "" >> ~/.zshrc
  echo "# Tmux dev environment functions" >> ~/.zshrc
  echo "$ZSHRC_LINE" >> ~/.zshrc
  echo "✓ Added source line to ~/.zshrc"
else
  echo "○ ~/.zshrc already sources tmux-functions.zsh"
fi

# ── Done ────────────────────────────────────────────────────

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  Setup complete! Three files created:"
echo ""
echo "  ~/.tmux.conf            keybindings + styling"
echo "  ~/.tmux-dev.json        session/window/command config"
echo "  ~/.tmux-functions.zsh   tm command + utilities"
echo ""
echo "  Next steps:"
echo "  1. source ~/.zshrc"
echo "  2. tm edit              ← set your real paths"
echo "  3. tm validate          ← check for errors"
echo "  4. tm up                ← start everything"
echo "  5. tmuxhelp             ← cheat sheet"
echo ""
echo "  Optional: brew install fzf  (for the logs command)"
echo "═══════════════════════════════════════════════════════"
