#!/bin/bash

# Check if at least the repository URL is provided
if [ $# -lt 1 ]; then

  echo "Usage: $0 <repository-url> [--folder FOLDER]"
  exit 1
fi

# Default variables
REPO_URL="$1"
CUSTOM_FOLDER=""

# Parse arguments
shift
while [[ $# -gt 0 ]]; do
  case "$1" in
  --folder)
    CUSTOM_FOLDER="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

# Extract repository name
REPO_NAME=$(basename "$REPO_URL" .git)

# Determine clone path
if [ -n "$CUSTOM_FOLDER" ]; then

  CLONE_PATH="$HOME/$CUSTOM_FOLDER/$REPO_NAME"
else
  CLONE_PATH="$HOME/$REPO_NAME"
fi

# Create parent directory if it doesn't exist
mkdir -p "$(dirname "$CLONE_PATH")"

# Clone the repository
echo "Cloning repository to $CLONE_PATH..."
git clone "$REPO_URL" "$CLONE_PATH"

# Check if clone was successful
if [ $? -ne 0 ]; then
  echo "Failed to clone repository"

  exit 1
fi

# Change to the cloned directory
cd "$CLONE_PATH"

# Create and attach to tmux session
SESSION_NAME=$(basename "$CLONE_PATH")
tmux new-session -d -s "$SESSION_NAME"
tmux send-keys -t "$SESSION_NAME" "cd $CLONE_PATH && nvim ." Enter
tmux attach-session -t "$SESSION_NAME"
tmux switch-client -t "$SESSION_NAME"
