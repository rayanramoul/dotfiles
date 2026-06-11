#!/usr/bin/env bash
# Build and install llama.cpp server from source with CUDA support
set -euo pipefail

LLAMA_DIR="${HOME}/.local/llama-cpp"
LLAMA_REPO="${HOME}/code/llama.cpp"

if [ -x "${LLAMA_DIR}/llama-server" ]; then
    echo "llama-server already installed at ${LLAMA_DIR}"
    exit 0
fi

echo "Building llama.cpp with CUDA support..."

mkdir -p "$(dirname "${LLAMA_REPO}")"
if [ ! -d "${LLAMA_REPO}/.git" ]; then
    git clone https://github.com/ggml-org/llama.cpp.git "${LLAMA_REPO}"
fi

cd "${LLAMA_REPO}"
git pull

rm -rf build
mkdir build && cd build

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLAMA_CUBLAS=ON \
    -DCMAKE_CUDA_ARCHITECTURES=86

cmake --build . --config Release -- -j$(nproc)

mkdir -p "${LLAMA_DIR}"
cp bin/release/llama-server "${LLAMA_DIR}/"

echo "✓ Installed llama-server to ${LLAMA_DIR}"
