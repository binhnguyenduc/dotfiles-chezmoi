#!/usr/bin/env bash
# Nix / nix-darwin cleanup script
# Run each section manually and verify before proceeding to the next.
# All steps requiring elevated privileges are prefixed with sudo.

set -euo pipefail

echo "=== Nix Cleanup Script ==="
echo "Run sections individually. Do NOT source this file — execute steps one at a time."
echo ""

# ---------------------------------------------------------------------------
# STEP 1: Unload and remove LaunchDaemons
# ---------------------------------------------------------------------------
# The darwin-store daemon is what mounts /nix on every boot.
# Unload first (safe even if already unloaded), then delete the plist files.

sudo launchctl bootout system /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
sudo launchctl bootout system /Library/LaunchDaemons/org.nixos.darwin-store.plist 2>/dev/null || true

sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm -f /Library/LaunchDaemons/org.nixos.darwin-store.plist

echo "[1] LaunchDaemons removed."

# ---------------------------------------------------------------------------
# STEP 2: Unmount and delete the Nix APFS volume (reclaims ~43.2 GB)
# ---------------------------------------------------------------------------
# Confirm the volume identifier first:
#   diskutil list | grep -i nix
# The UUID found was 3CA90DA0-DA78-49B7-8CE5-38F1D89BB8A1, device disk3s7.
# Adjust disk3s7 if your device identifier differs.

sudo diskutil unmount force /nix
sudo diskutil apfs deleteVolume disk3s7

echo "[2] Nix APFS volume deleted."

# ---------------------------------------------------------------------------
# STEP 3: Remove the /nix mount point and /etc/nix config
# ---------------------------------------------------------------------------

sudo rmdir /nix 2>/dev/null || echo "  /nix not empty or already gone — skipping rmdir"
sudo rm -rf /etc/nix

echo "[3] /nix mount point and /etc/nix removed."

# ---------------------------------------------------------------------------
# STEP 4: Remove user-level Nix artifacts
# ---------------------------------------------------------------------------

rm -f  ~/.nix-profile
rm -f  ~/.nix-channels
rm -rf ~/.nix-defexpr
rm -rf ~/.local/state/nix

echo "[4] User-level Nix artifacts removed."

# ---------------------------------------------------------------------------
# STEP 5: Remove the 32 nixbld build users
# ---------------------------------------------------------------------------

for i in $(seq 1 32); do
  sudo dscl . -delete /Users/_nixbld${i} 2>/dev/null && echo "  Deleted _nixbld${i}" || echo "  _nixbld${i} not found — skipping"
done

echo "[5] nixbld build users removed."

# ---------------------------------------------------------------------------
# STEP 6: Remove the nixbld group
# ---------------------------------------------------------------------------

sudo dscl . -delete /Groups/nixbld 2>/dev/null || echo "  nixbld group not found — skipping"

echo "[6] nixbld group removed."

# ---------------------------------------------------------------------------
# STEP 7: Verify nothing remains
# ---------------------------------------------------------------------------

echo ""
echo "=== Verification ==="
echo "--- /nix mount ---"
mount | grep nix || echo "  (none)"

echo "--- LaunchDaemons ---"
ls /Library/LaunchDaemons/ | grep nix || echo "  (none)"

echo "--- /etc/nix ---"
ls /etc/nix 2>/dev/null || echo "  (none)"

echo "--- ~/.nix-* ---"
ls ~/.nix-profile ~/.nix-channels ~/.nix-defexpr 2>/dev/null || echo "  (none)"

echo "--- ~/.local/state/nix ---"
ls ~/.local/state/nix 2>/dev/null || echo "  (none)"

echo "--- nixbld users ---"
dscl . -list /Users | grep nixbld || echo "  (none)"

echo "--- nixbld group ---"
dscl . -list /Groups | grep nixbld || echo "  (none)"

echo ""
echo "=== Cleanup complete ==="
