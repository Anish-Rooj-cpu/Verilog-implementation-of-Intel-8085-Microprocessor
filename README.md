# Verilog-implementation-of-Intel-8085-Microprocessor
A Work-in-Progress Verilog Implementation of the Intel 8085 8-bit Microprocessor
## Architecture
The processor follows a modified Von Neumann architecture featuring an 8-bit internal data path and a 16-bit address space. Control logic is implemented via a synchronous Finite State Machine (FSM) that orchestrates data movement between the following subsystems:
<img width="1536" height="1024" alt="8085_mod_Arch" src="https://github.com/user-attachments/assets/b957f2f6-622e-49c3-b2df-aee79da88b3d" />
# 8085 Processor Supported Instruction Set
## 1. Data Transfer Instructions
These instructions move data between registers or from memory to registers.

| Mnemonic | Opcode (Hex) | Description |
| :--- | :--- | :--- |
| **MOV r1, r2** | `40 - 7F` | Move register `r2` to `r1`. (Excludes `76h`) |
| **MVI r, data**| `06, 0E, 16, 1E, 26, 2E, 3E` | Move immediate 8-bit data to register `r`. |
| **NOP** | `00` | No Operation. |
| **HLT** | `76` | Halt the processor. |

## 2. Arithmetic Instructions
All arithmetic results (except INR/DCR) are stored in the **Accumulator (A)**.

| Mnemonic | Opcode (Hex) | Description |
| :--- | :--- | :--- |
| **ADD r** | `80 - 87` | Add register `r` to Accumulator. |
| **ADC r** | `88 - 8F` | Add register `r` and Carry flag to Accumulator. |
| **SUB r** | `90 - 97` | Subtract register `r` from Accumulator. |
| **SBB r** | `98 - 9F` | Subtract register `r` and Borrow (Carry) from Accumulator. |
| **INR r** | `04, 0C, 14, 1C, 24, 2C, 3C` | Increment register `r` by 1. |
| **DCR r** | `05, 0D, 15, 1D, 25, 2D, 3D` | Decrement register `r` by 1. |

## 3. Logical Instructions
Logical operations are performed bitwise against the Accumulator.

| Mnemonic | Opcode (Hex) | Description |
| :--- | :--- | :--- |
| **ANA r** | `A0 - A7` | Logical AND register `r` with Accumulator. |
| **XRA r** | `A8 - AF` | Logical XOR register `r` with Accumulator. |
| **ORA r** | `B0 - B7` | Logical OR register `r` with Accumulator. |
| **CMP r** | `B8 - BF` | Compare register `r` with Accumulator (Updates flags only). |
| **CMA** | `2F`      | Complement Accumulator (1's complement). |

## 4. Control & Branching (Basic Support)
*Note: These require the CU to manage multi-cycle PC loads.*

| Mnemonic | Opcode (Hex) | Description |
| :--- | :--- | :--- |
| **JMP addr**| `C3` | Unconditional jump to 16-bit address. |

---

## Technical Hardware Mapping
* **Destination Control:** For all ALU operations (ADD, SUB, etc.), the hardware automatically forces the destination to Register A (`3'b111`).
* **Source Control:** For `INR` and `DCR`, the `alu_src` logic routes the destination register to the ALU input to allow in-place modification.
* **Flag Logic:** The `flag_register` captures Zero (Z), Sign (S), Parity (P), and Carry (CY) based on the ALU output.
