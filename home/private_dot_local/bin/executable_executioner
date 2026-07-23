#/bin/bash
# Change to the root of the project directory
cd "$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"

# Function to run bash, python scripts based on existence
run_project() {
    if [ -f "run.sh" ] || [ -f "start.sh" ]; then
        bash run.sh || bash start.sh
    elif [ -f "main.py" ] || [ -f "run.py" ] || [ -f "app.py" ] || [ -f "start.py" ]; then
        python main.py || python run.py || python app.py || python start.py

    else
        echo "No recognized run script found in the project directory."
    fi
    # Keep the tmux pane open after the command has finished
}

run_tests() {
    if [ -f "test.sh" ]; then
        bash test.sh
    # check if there is a tests folder if so pytest it
    elif [ -d "tests" ]; then
        pytest tests
    else
        echo "No recognized test script found in the project directory."
    fi
    # Keep the tmux pane open after the command has finished
}
# check for presence of -t flag
if [ "$1" == "-t" ]; then
    run_tests
else
    run_project
fi

read -n 1 -s -r -p "Press any key to exit."
