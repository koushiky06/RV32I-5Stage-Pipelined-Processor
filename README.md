# 32-Bit 5-Stage Pipelined RISC-V (RV32I) Processor Core

## Overview
This repository contains a functional 32-bit 5-stage pipelined processor core implementing a subset of the **RISC-V (RV32I)** Instruction Set Architecture (ISA). Designed and verified in Verilog HDL using AMD Xilinx Vivado, the processor features full data hazard handling via forwarding mechanisms and control logic.

---

## Datapath Architecture

The processor follows the classic 5-stage RISC-V pipelined architecture:
```mermaid
graph LR
    %% Pipeline Stages
    subgraph IF["1. FETCH (IF)"]
        direction TB
        PC["Program Counter"]
        IM["Instruction Memory"]
        PCA["PC Adder (+4)"]
    end

    subgraph ID["2. DECODE (ID)"]
        direction TB
        RF["Register File"]
        MD["Main Decoder"]
        SE["Sign Extension"]
    end

    subgraph EX["3. EXECUTE (EX)"]
        direction TB
        ALU["ALU"]
        AD["ALU Decoder"]
        BA["Branch Adder"]
    end

    subgraph MEM["4. MEMORY (MEM)"]
        direction TB
        DM["Data Memory"]
    end

    subgraph WB["5. WRITEBACK (WB)"]
        direction TB
        MUX["Result Mux"]
    end

    %% Pipeline Flow
    IF --> ID --> EX --> MEM --> WB

    %% Hazard/Forwarding Unit
    HU["HAZARD / FORWARDING UNIT"]
    EX -. ForwardA / ForwardB .-> HU
    MEM -. Forwarding Path .-> EX
    WB -. Forwarding Path .-> EX
```

### Pipeline Stages Breakdown

1. **Instruction Fetch (IF):**
   * **Program Counter (`pc.v`):** Maintains the current instruction address on `posedge clk`.
   * **Instruction Memory (`instruction_mem.v`):** Asynchronously fetches 32-bit RISC-V instructions from `memfile.hex` mapped to word addresses (`A[6:2]`).
   * **PC Adder (`PC_Adder.v`):** Computes sequential next-instruction addresses (`PC + 4`).

2. **Instruction Decode (ID):**
   * **Register File (`register_file.v`):** Dual-read, single-write 32x32-bit register array with asynchronous read and synchronous write capabilities. Register `x0` is hardwired to `32'b0`.
   * **Main Decoder (`main_decoder.v`) & ALU Decoder (`ALU_decoder.v`):** Decodes 7-bit opcodes (`InstrD[6:0]`), `funct3`, and `funct7` to generate control signals (`RegWrite`, `ALUSrc`, `MemWrite`, `ResultSrc`, `Branch`, `ALUControl`).
   * **Sign Extension (`immediate_gen.v`):** Generates sign-extended 32-bit immediates for I-type and S-type instructions.

3. **Execute (EX):**
   * **Arithmetic Logic Unit (`alu.v`):** Performs arithmetic and bitwise operations (ADD, SUB, AND, OR, XOR, SLT, SLL, SRL).
   * **Forwarding Muxes (`Mux.v`):** Selects between register outputs, EX/MEM forwarded results, or MEM/WB forwarded results to resolve data hazards dynamically.
   * **Branch Adder (`PC_Adder.v`):** Calculates branch target addresses (`PCE + Imm_Ext_E`).

4. **Memory Access (MEM):**
   * **Data Memory (`data_mem.v`):** Handles synchronous memory writes (`MemWrite`) and asynchronous reads for load instructions (`lw`, `sw`).

5. **Writeback (WB):**
   * **Result Mux (`writeback_cycle.v`):** Selects between ALU execution results and Data Memory outputs to write back into the Register File.

---

## Hazard Handling & Forwarding Logic

The **Hazard Unit (`hazard_unit.v`)** actively monitors register destinations (`RD_M`, `RD_W`) against source registers (`Rs1_E`, `Rs2_E`) to eliminate EX-to-EX and MEM-to-EX execution stalls without sacrificing performance:

* **Forwarding Condition 1 (EX-to-EX):** Forwarded from Memory Stage (`ALU_ResultM`) when `RegWriteM` is active and source register matches `RD_M`.
* **Forwarding Condition 2 (MEM-to-EX):** Forwarded from Writeback Stage (`ResultW`) when `RegWriteW` is active and source register matches `RD_W`.

---

## Supported Instruction Set Subset

* **R-Type:** `add`, `sub`, `and`, `or`, `xor`, `slt`, `sll`, `srl`
* **I-Type:** `addi`, `lw`
* **S-Type:** `sw`
* **B-Type:** `beq`

---

## Repository Structure
├── alu.v                # Arithmetic Logic Unit
├── ALU_decoder.v        # Decodes funct3/funct7 into 3-bit ALU controls
├── control_unit_top.v   # Top control unit wrapping Main & ALU decoders
├── data_mem.v           # Data Memory module
├── dm_wb.v              # MEM/WB pipeline register
├── ex_dm.v              # EX/MEM pipeline register
├── hazard_unit.v        # Data hazard detection & forwarding unit
├── id_ex.v              # ID/EX pipeline register
├── if_id.v              # IF/ID pipeline register
├── immediate_gen.v      # Immediate Sign Extension generator
├── instruction_mem.v   # Instruction ROM memory module
├── main_decoder.v       # Decodes 7-bit opcode to control signals
├── Mux.v                # 2-to-1 and 3-to-1 Multiplexers
├── pc.v                 # Program Counter register module
├── PC_Adder.v           # 32-bit Adder module
├── pipeline_top.v       # Processor top-level wrapper module
├── register_file.v      # 32 x 32-bit Register File
├── writeback_cycle.v    # Writeback stage logic
├── pipeline_2_tb.v      # Simulation Testbench
├── memfile.hex          # RISC-V machine code hex file
└── README.md            # Project documentation
