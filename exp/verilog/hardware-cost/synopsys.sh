#!/bin/bash

# ==============================================================================
# Synopsys Design Compiler Automated Script (Flexible Parameter Version)
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function setup_env() {
    # 1. Detect dc_shell
    if [ -z "$DC_PATH" ]; then
        local dc_bin=$(which dc_shell 2>/dev/null)
        if [ -n "$dc_bin" ]; then
            export DC_PATH=$(dirname "$dc_bin")
        else
            echo -e "${RED}ERROR: dc_shell not found in PATH. Please set DC_PATH or ensure it is in your PATH.${NC}"
            exit 1
        fi
    fi

    # 2. Paths
    export TOP_MODULE="$1"
    export SYN_ROOT_PATH=$(pwd)
    export WORK_PATH="$SYN_ROOT_PATH/work"
    export SCRIPT_PATH="$SYN_ROOT_PATH/script"
    export MAPPED_PATH="$SYN_ROOT_PATH/mapped"
    export REPORT_PATH="$SYN_ROOT_PATH/report"

    # Create dirs
    mkdir -p "$WORK_PATH" "$MAPPED_PATH" "$REPORT_PATH"
}

function run_synthesis() {
    local top="$1"
    shift # Remove top module from arguments
    
    setup_env "$top"

    # --- Flexible Parameter Handling ---
    # Everything left in $@ is treated as a parameter (e.g., WIDTH=16)
    if [ $# -gt 0 ]; then
        # Join arguments with commas for TCL elaborate command
        # Result: "WIDTH=16,LOG_W=4,DEPTH=32"
        export ELAB_PARAMS=$(echo "$@" | tr ' ' ',')
    else
        export ELAB_PARAMS=""
    fi

    if [ ! -f "$SCRIPT_PATH/main.tcl" ]; then
        echo -e "${RED}ERROR: main.tcl not found in $SCRIPT_PATH${NC}"
        exit 1
    fi

    echo "------------------- Synthesis Starting -------------------"
    echo "Top Module : $TOP_MODULE"
    echo "Parameters : ${ELAB_PARAMS:-None}"
    echo "----------------------------------------------------------"
    
    cd "$WORK_PATH" || exit 1
    dc_shell -f "$SCRIPT_PATH/main.tcl" | tee "$SYN_ROOT_PATH/execute.log"
    
    cd "$SYN_ROOT_PATH"
    echo "------------------- Synthesis Finished -------------------"
}

function clean_env() {
    echo -e "${RED}Cleaning environment...${NC}"
    rm -f execute.log
    rm -rf report/* mapped/*
    [ -d work ] && find work -type f ! -name ".*" -delete
    echo "Clean complete."
}

# -------------------------------------------- Main Logic --------------------------------------------

case "$1" in
    --run | -r)
        shift
        if [ -z "$1" ]; then
            echo -e "${RED}ERROR: Top module name required.${NC}"
            echo "Usage: $0 --run [TopModule] [PARAM1=VAL1 PARAM2=VAL2 ...]"
            exit 1
        fi
        run_synthesis "$@"
        ;;
    --clean | -c)
        clean_env
        ;;
    --help | -h | *)
        echo "Usage: $0 {--run|--clean} [TopModule] [PARAMS...]"
        echo "Example 1 (No params):  $0 --run my_design"
        echo "Example 2 (Flexible):   $0 --run ppe_h_p WIDTH=16 LOG_W=4 SPEED=high"
        ;;
esac