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

| Component        | Description    |
|------------------|----------------|
| `alu.v`          | ALU supporting the arithmetic and logic ops |
| `regfile.v`      | 32 general purpose registers, x0 hardwired to 0 |
| `control_unit.v` | Instruction decoder, provides the control signals |
| `imm_gen.v`      | Immediate generator unit |
| `instr_memory.v` | Single read port 32x1024 ROM |
| `data_memory.v`  | 32x1024 data memory |
| `pc.v`           | outputs current PC and updates to next PC synchronously |
| `rv32I_top.v`    | Top level module connecting the datapath and control unit |

All the modules include unit testbenches for extensive verification of operation.

---

## Single-Cycle Design

This processot uses a **single-cycle microarchitecture**, meaning:

- Each instruction completes in one clock cycle
- Control logic is centralized and straightforward
- Not cycle/resource efficient: the cycle time is limited to the slowest instruction and the memory unit is replicated as the data memory and the instruction memory have to be separate.

## Reasons for targeting a single-cycle implementation first

- Full visibility of the entire datapath in each stage, therefore easier debugging and understanding the architecture
- A solid base to later compare performance with the **multi-cycle** and **pipelined** versions
  
---

## FPGA Implementation

- **Platform**: Basys 3 FPGA Board (Xilinx Artix-7)
- **Toolchain**: Xilinx Vivado
- **Testing**: On-board LED for result observation and buttons for interaction

The processor was tested on hardware with a suite of manually written RISC-V test programs converted from .asm to .mem(hex format), loaded into memory during synthesis.

---

## Performance Plans

This is part of a larger experimental effort. Future stages will include:
- Timing comparison between
    - Single-cycle (this project)
    - Multi-cycle
    - 5 stage pipelined version with forwarding/harzard units
- Synthesis and timing reports using Vivado to measure the clock frequency and resource utilization
- Real-world performance evaluation using hand assembled RISC-V programs and benchmarks

---

## Future Work

- Multicycle unit and instruction stepper
- Pipelined architecture with data/branch hazard handling
- Integration with memory mapped I/O for peripherals
- Support of extended RISC-V : -M and -C
- External memory interface for larger programs

---

## How to Use

1. Clone the repo
2. Open Vivado and run synthesis
3. Load the bitstream to Basys 3
4. Observe program execution via LEDs, UART, or simulation output

---
 
### License

This project is licensed under the MIT License. Free to use, modify and share for educational and experimental purposes.

---

### Author

Maxwell Mlewa

*"If you can build it from transistors and truth tables, you understand it!"*

## Acknowledgements

- [RISC-V International](https://riscv.org/) - for publishing the open ISA
- [Xilinx Vivado](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html) - for enabling FPGA development, simulation and sysnthesis
- [Basys 3 Board](https://digilent.com/reference/programmable-logic/basys-3/start?srsltid=AfmBOorltsrvuxpcMiQ5CMp9w_vQZtCauOOFsvAuoSpoNS0v0GisPOxF) - the gateway to the Xilinx Vivado development suite
- [Luplab RISC-V Instruction Encoder/Decoder](https://luplab.gitlab.io/rvcodecjs/#q=bne+x1,+x2,+8&abi=false&isa=AUTO) - RISC-V RV32I decoder
- [Cornell RISC-V Interpreter](https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter/) - for enabling manual verification through observing the architectural state
- Digital Design and Computer Architecture, RISC-V Edition: Harris and Harris
