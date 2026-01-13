# Occamy Switch Verification & Simulation Guide

This repository supports two primary methods for verifying the switch core logic: **Behavioral Simulation** (using Verilog RTL) and **Hardware-in-the-loop Validation** (using FPGA boards like Z104).

## 1. Verification Methods

### Method A: Behavioral RTL Simulation

This is the quickest way to reproduce logic results and analyze queue behavior. The provided `tb_switch_top.v`(in `src/verilog/sim`) instantiates four different configurations of the `switch_core_v2` to compare their performance under identical input stimulus.


Execution Steps:

- GUI: Right-click `tb_switch_top.v` in the Sources panel, select Set as Top, and click Run Behavioral Simulation.

- Tcl Console: Run the command launch_simulation.

* **Output:** The testbench monitors queue lengths (`qlen`), dequeue signals (`out_signal`), and drop events (`headdrop_out`), logging them into `qlen_output.txt` for post-simulation analysis.

### Method B: Hardware Board Validation (Z104/Zynq)

For real-time performance metrics and hardware-accurate results, the design can be deployed on a Z104 or similar FPGA development board.

* **Block Design Construction:** Integrate the `switch_core_v2` IP into a Vivado Block Design (BD).
* **Monitoring:** Use **System ILA (Integrated Logic Analyzer)** or an **AXI Traffic Generator** to feed the `i_cell_ptr_fifo` inputs.
* **Data Capture:** Map the output ports (qlen, out_signal, headdrop_out) to AXI-Lite registers or trace buffers to extract the same hexadecimal data seen in the behavioral simulation.

Steps:

1. **IP Integration:** Package the `switch_core_v2` logic as a Vivado IP and add it to your **Block Design (BD)**.
2. **Clock & Reset:** Connect the `FCLK_CLK0` from the Zynq PS to the switch core. Ensure the active-high/low reset logic matches your board constraints.
3. **I/O Mapping:**
* Connect input stimulus (e.g., AXI Traffic Generator) to the input FIFOs.
* Attach a **System ILA** to the `qlen` and `out_signal` ports for real-time waveform monitoring.


4. **Bitstream & Run:** * Generate the Bitstream and program the FPGA.
* Use the **Vivado Hardware Manager** to trigger data capture.
* Export the captured ILA data as a `.csv` file to verify that the hardware behavior matches the RTL simulation results.