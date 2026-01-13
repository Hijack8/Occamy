# Switch Core Implementation

## Overview

This project contains the implementation of `switch_core_v2`, a high-performance shared-memory packet switch logic designed in Verilog HDL. The design features dynamic buffer management via a linked-list architecture, QoS scheduling, and advanced congestion control mechanisms including head-drop and dynamic thresholds.

## Directory Structure

The project is organized as follows:

```text
switch_core_impl/
├── README.md           # Project documentation
├── src/                # Verilog source codes (RTL)
├── ip/                 # Xilinx Vivado IP Core configurations (.xci)
└── sim/                # Simulation testbenches

```

### 1. Source Code (`src/`)

This directory contains the primary RTL files. The logic is divided into pipeline stages and control modules:

* **`switch_core_v2.v`**: The main core module that integrates admission, memory control, and egress logic.


* **`switch_top.v`**: A wrapper module for the switch core.

* **`admission.v`**: Handles packet ingress. It performs packet segmentation, writes data to shared memory, and requests pointers from the free queue.

* **`cell_read_v2.v`**: Handles packet egress. It performs arbitration (scheduling), reads cells from memory, reassembles packets, and manages the return of pointers to the free queue.

* **`cell_pointer_memory_control.v`**: Manages the "Free Queue" (FQ) using a linked-list structure. It initializes the pointer memory and handles allocation/deallocation requests.

* **`pd_memory_control_FIFO.v`**: Manages Packet Descriptors (PD) using per-port FIFOs to store metadata for queued packets.

* **`statistics_v2.v`**: Monitors queue lengths per port and calculates congestion bitmaps using dynamic thresholds to trigger tail-dropping.

* **`headdrop_v5.v`**: Implements a proactive head-drop mechanism to discard packets from the front of the queue during severe congestion.


* **`ppe_8_func.v`**, **`priority_encoder_*.v`**, **`tothermo8.v`**: Logic components for the Programmable Priority Encoder (PPE) used in the scheduling algorithms (Strict Priority or Deficit Round Robin).

### 2. IP Cores (`ip/`)

This directory contains Xilinx IP core configurations required for on-chip storage. These must be generated in Vivado before synthesis or simulation.

### 3. Simulation (`sim/`)

* **`tb_switch_top.v`**: The testbench for verifying the top-level functionality of the switch.

## Key Parameters

The design is parameterized in `switch_core_v2.v` with the following defaults:

* **`TOP_DATA_WIDTH`**: 512 bits (Data path width).
* **`TOP_PORT_NUM`**: 8 (Number of Ingress/Egress ports).
* **`TOP_BUFFER_SIZE`**: 2048 (Total number of cells in shared memory).
* **`TOP_USE_DRR`**: 1 (Enable Deficit Round Robin scheduling).

## Getting Started

1. Add all files in `src/` to your Vivado project.
2. Add the `.xci` files from `ip/` to the project and generate the output products.
3. Set `switch_core_v2.v` (or `switch_top.v`) as the top module.
4. Run the simulation using `sim/tb_switch_top.v`.