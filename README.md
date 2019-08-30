# Abstract:

Developing a Single cycle 32-bit RISC-V core to be used as a building block to implement a pipelined version. All the instructions in the RV32I base instruction set of RISC-V has been implemented except the instructions that help in OS execution like FENCE and EBREAK. These missed out instructions will be implemented when hardware emulation(FPGA implemntation) of the core is carried out.

Control signals are generated using hardwired control unit using a part of 32-bit instruction as input. Two separate memories for instruction and data is used to achieve single cycle execution.
