#!/usr/bin/env bash
# Download LLM models from HuggingFace
set -euo pipefail

MODEL_DIR="${HOME}/.local/share/llama-models"
mkdir -p "${MODEL_DIR}"

download_model() {
    local repo="$1"
    local filename="$2"
    local symlink="$3"

    echo "Downloading ${filename}..."
    hf download "${repo}" --filename "${filename}" -o "${HOME}/.cache/huggingface/hub"

    if [ -L "${MODEL_DIR}/${symlink}" ]; then
        rm "${MODEL_DIR}/${symlink}"
    elif [ -e "${MODEL_DIR}/${symlink}" ]; then
        echo "Error: ${MODEL_DIR}/${symlink} exists and is not a symlink"
        exit 1
    fi
    ln -sf "${HOME}/.cache/huggingface/hub/$(echo "${repo}" | sed 's|/|--|g')/snapshots/*/${filename}" "${MODEL_DIR}/${symlink}"
    echo "✓ Linked ${symlink} -> ${filename}"
}

# Qwen3.6-35B (18 GB IQ4_XS)
download_model \
    "mradermacher/Qwen3.6-35B-Instruct-GGUF" \
    "qwen3.6-35b-iq4_xs.gguf" \
    "qwen3.6-35b-iq4_xs.gguf"

echo ""
echo "Models installed:"
ls -la "${MODEL_DIR}"
