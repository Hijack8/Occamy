# Occamy Switch DC Synthesis Flow

A modular and automated environment for **Synopsys Design Compiler (DC)**, optimized for Occamy Switch components (PPE/Hierarchical PPE) with support for parameterized elaboration.

## 1. Directory Structure

```text
├── rtl/        # Verilog/SystemVerilog source files(You can copy the src/verilog/*.v here)
├── script/     # Core TCL scripts
├── library/    # Technology libraries (.db files)
├── work/       # DC temporary workspace
├── report/     # Timing, area, and power reports
└── mapped/     # Synthesized netlists and SDC constraints

```

## 2. Key Components

| Script | Role |
| --- | --- |
| **`synopsys.sh`** | **Entry Point**: Handles environment setup and parameter passing. |
| **`main.tcl`** | **Orchestrator**: Coordinates the full synthesis flow. |
| **`read_design.tcl`** | **Elaboration**: Analyzes RTL and applies parameters. |
| **`set_constraints.tcl`** | **Constraints**: Sets timing (default  clock). |
| **`synthesis.tcl`** | **Engine**: Runs `compile_ultra` for high-performance optimization. |
| **`common_functions.tcl`** | **Helpers**: Recursive file search and Black-Box modeling. |

## 3. Usage

### Run Synthesis

Execute the flow by providing the top module, DC path, and design parameters:

```bash
# Usage: ./synopsys.sh --run [TopModule] [DCPath] [Width] [PARAMS...]
./synopsys.sh --run ppe_h_p /path/to/synopsys/bin WIDTH=16 LOG_W=4
```

### Clean Environment

Remove all logs, reports, and temporary work files:

```bash
./synopsys.sh --clean
```