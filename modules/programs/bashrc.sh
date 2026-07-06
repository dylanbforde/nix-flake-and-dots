if command -v carapace >/dev/null 2>&1; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  source <(carapace _carapace bash)
fi

db-cuda() {
  local name="cuda-$(basename "$PWD")"
  if ! distrobox list | grep -q "$name"; then
    echo "Creating CUDA container: $name"
    distrobox create -Y -n "$name" --image nvidia/cuda:12.4.1-devel-ubuntu22.04 --nvidia --home "$PWD"
  fi
  distrobox enter "$name"
}

db-dev() {
  if ! distrobox list | grep -q "devbox"; then
    echo "Starting devbox..."
    distrobox create -n devbox --image ubuntu:22.04
  fi
  distrobox enter devbox
}
