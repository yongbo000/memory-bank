#!/bin/bash
# Install memory-bank skill for OpenCode / Claude Code
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/<user>/memory-bank/main/install.sh | bash
#
# Options (via env vars):
#   INSTALL_TARGET=opencode   Install only to OpenCode
#   INSTALL_TARGET=claude     Install only to Claude Code
#   INSTALL_TARGET=all        Install to both (default)

set -e

REPO_URL="https://github.com/<user>/memory-bank"
SKILL_NAME="memory-bank"
INSTALL_TARGET="${INSTALL_TARGET:-all}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}[memory-bank]${NC} $1"; }
ok()    { echo -e "${GREEN}[memory-bank]${NC} $1"; }
warn()  { echo -e "${YELLOW}[memory-bank]${NC} $1"; }
error() { echo -e "${RED}[memory-bank]${NC} $1"; exit 1; }

# Determine install paths
OPENCODE_SKILL_DIR="${HOME}/.config/opencode/skills/${SKILL_NAME}"
CLAUDE_SKILL_DIR="${HOME}/.claude/skills/${SKILL_NAME}"

# Files to install (relative to repo root)
SKILL_FILES=(
    "SKILL.md"
    "reference.md"
    "templates/index.md"
    "templates/entry.md"
    "templates/decision.md"
    "scripts/init-memory.sh"
    "scripts/search-memory.sh"
    "scripts/memory-stats.sh"
)

install_to_dir() {
    local target_dir="$1"
    local label="$2"

    info "Installing to ${label}: ${target_dir}"

    # Create directory structure
    mkdir -p "${target_dir}/templates"
    mkdir -p "${target_dir}/scripts"

    # Check if we're running from a cloned repo or via curl
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null || echo ".")" && pwd)"

    if [ -f "${SCRIPT_DIR}/SKILL.md" ]; then
        # Local install from cloned repo
        info "Installing from local directory: ${SCRIPT_DIR}"
        for file in "${SKILL_FILES[@]}"; do
            cp "${SCRIPT_DIR}/${file}" "${target_dir}/${file}"
        done
    else
        # Remote install via curl
        local raw_base="https://raw.githubusercontent.com/<user>/memory-bank/main"
        info "Downloading from GitHub..."
        for file in "${SKILL_FILES[@]}"; do
            local target_file="${target_dir}/${file}"
            mkdir -p "$(dirname "${target_file}")"
            if command -v curl &>/dev/null; then
                curl -fsSL "${raw_base}/${file}" -o "${target_file}"
            elif command -v wget &>/dev/null; then
                wget -q "${raw_base}/${file}" -O "${target_file}"
            else
                error "Neither curl nor wget found. Please install one of them."
            fi
        done
    fi

    # Make scripts executable
    chmod +x "${target_dir}/scripts/"*.sh 2>/dev/null || true

    ok "Installed to ${label}"
}

echo ""
echo "========================================"
echo "  memory-bank skill installer"
echo "========================================"
echo ""

installed=0

if [ "${INSTALL_TARGET}" = "all" ] || [ "${INSTALL_TARGET}" = "opencode" ]; then
    install_to_dir "${OPENCODE_SKILL_DIR}" "OpenCode"
    installed=$((installed + 1))
fi

if [ "${INSTALL_TARGET}" = "all" ] || [ "${INSTALL_TARGET}" = "claude" ]; then
    install_to_dir "${CLAUDE_SKILL_DIR}" "Claude Code"
    installed=$((installed + 1))
fi

if [ "${installed}" -eq 0 ]; then
    error "Invalid INSTALL_TARGET: ${INSTALL_TARGET}. Use 'all', 'opencode', or 'claude'."
fi

echo ""
ok "Installation complete!"
echo ""
info "The memory-bank skill is now available in your agent."
info "Usage:"
info "  - Type /memory-bank in your agent to get started"
info "  - Use /memory-bank init to initialize a project's memory bank"
info "  - Use /memory-bank save <category/title> to save knowledge"
info "  - Use /memory-bank recall <query> to search memories"
echo ""
info "For more information, see: ${REPO_URL}"
echo ""
