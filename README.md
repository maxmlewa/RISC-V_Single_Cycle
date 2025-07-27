# RISC-V RV32I Processor - Verilog (Single-Cycle, Basys 3 FPGA)

## Overview

This project entails a fully functional, "from scratch" implementation of the **RISC-V RV32I** instruction set architecture in **Verilog**, tested on real hardware using the **Xilinx Vivado toolchain** and deployed on a **Basys 3 FPGA board**.

It is designed as a **single-cycle processor** with modular components and a strong focus on clarity and experimentation. The entire RV32I instruction set is supported (save for the environment call instructions), and each module includes corresponding testbenches for unit tests and verification.

---

## Features

- Implements the "complete" **RV32I Base Integer ISA**
- Designed using **Verilog HDL** for clarity and modularity with experimentation in mind
- **Single-cycle microarchitecture** for simple control and timing analysis
- Fully synthesizable RTL
- Comprehensive module level and system level testbenches

---

### Why I Built This

My efforts to build this processor from the ground up were motivated by the desire to understand computing at the most fundamental level (well, not the most fundamental, but a few levels of abstraction above the most fundamental, atoms and molecules).

I chose RISC-V because of the extensive support in terms of documentation, a simple instruction set, and the compatibility it provides for future extensions. Being an early project, I wanted to avoid black-box designs that would completely abstract functionality, while at the same time accomodating intent debugging, optimizations and of course, learning with experimentation.

Using the **Basys 3 FPGA** allowed me to  move beyond simulation and bring the processor to life in real silicon. Watching the instructions execute in hardware throught the on-board LEDs and interacting with the system using buttons brings a whole new level of satisfaction, which further motivated me to start contemplating about more advanced and dedicated hardware as opposed to the simple general purpose processor.

---

## Project Highlights

