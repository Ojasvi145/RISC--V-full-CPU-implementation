# RISC--V-full-CPU-implementation

# CS F342 – Lab 1
## Verilog Modeling Styles and Hierarchical Design

---

## 1. Objective

The objective of **Lab 1** is to introduce you to **hands-on Verilog HDL design and simulation**, building on your background in digital logic design.

In this lab, you will:

- Implement the same hardware function using different Verilog modeling styles
- Understand the relationship between structural, dataflow, and behavioral (RTL) descriptions
- Learn how hierarchical designs are built using reusable modules
- Use a Codespaces-based workflow with VS Code
- Develop good verification discipline using testbenches

This lab forms the foundation for all subsequent labs in the course.

---

## 2. Background: Verilog Essentials (Recap)

This section briefly reviews the Verilog concepts required for this lab. You are expected to refer to lecture notes and the recommended textbook sections for deeper understanding.

### 2.1 Modules

A **module** is the basic building block in Verilog. It represents a hardware block with inputs and outputs.

Example:
```
module dut (
  input  wire a,
  input  wire b,
  input  wire cin,
  output wire sum,
  output wire cout
);
  // internal logic
endmodule
```

In this lab:
- Every design you write will be inside a module named `dut`
- The module interface represents the hardware pins of the circuit

Note: **DUT (Design Under Test)** refers to the hardware module being verified by the testbench. In this lab, your top-level module must be named `dut` so that the same testbench can be reused across different implementations (see the Testbench section below).

---

### 2.2 Ports, Nets, and Variables

- **Ports**: Inputs and outputs of a module
- **wire**: Used to model combinational connections
- **reg**: Used inside procedural blocks (`always`) to hold values

Rule of thumb:
- Use `wire` for continuous assignments
- Use `reg` for signals assigned inside `always` blocks

---

### 2.3 Modeling Styles in Verilog

Verilog supports multiple ways of describing the same hardware:

1. **Structural modeling**
   - Uses gate primitives and explicit wiring
   - Closest to schematic-level design

2. **Dataflow modeling**
   - Uses Boolean expressions and `assign` statements
   - More compact and readable

3. **Behavioral / RTL modeling**
   - Uses `always @(*)` blocks
   - Describes behavior rather than structure

In this lab, you will implement the *same circuit* using all three styles.

---

### 2.4 Testbenches

A **testbench** is a Verilog module used to:
- Apply inputs to the design under test (DUT)
- Observe outputs
- Check correctness

Key properties of testbenches:
- They have **no inputs or outputs**
- They instantiate the DUT
- They are used only for simulation, not synthesis

Example structure:
```
module tb;
  reg a, b, cin;
  wire sum, cout;

  dut uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
  );

  initial begin
    // apply test vectors
  end
endmodule
```

---

### 2.5 Simulation and Waveforms

During simulation:
- Signal values over time can be dumped into a **VCD (Value Change Dump)** file (see the testbench, and Google 'verilog dumpvars' to learn more about the syntax).
- Waveforms can be viewed using **VaporView** inside VS Code.

Waveforms are used for **debugging and understanding behavior**.

---

## 3. Directory Structure (Lab 1)

```
labs/lab1/
├── task0/
│   └── dut.v
├── task1/
│   └── dut.v
├── task2/
│   └── dut.v
├── task3/
│   └── dut.v
├── task4/
│   └── dut.v
├── task5/
│   └── dut.v        (homework)
├── tb/
│   ├── tb_mux.v
│   ├── tb_fa.v
│   ├── tb_adder4.v
│   └── tb_adder4_sub.v
├── shared/
│   └── module.v
└── README.md
```

Additional folders:
- `shared/` – reusable modules (always included during compilation)
- `artefacts/` – simulation outputs (lab-wise)

---

## 4. Toolchain and Workflow

You will work entirely inside **GitHub Codespaces**.

Tools used (these are already set up in the codespace for you to use):
- Icarus Verilog – compilation and simulation
- VS Code Tasks – running compile and simulation commands
- VaporView – waveform viewing (debugging only)

No local installation is required.

---

## 5. Task 0 – Toolchain Familiarization (Warm-up)

**Objective:**  
Understand the build, simulation, and waveform-viewing workflow.

### Description
In this task, you will **not write any code**. Instead, you will:
- Compile and simulate a provided **2-to-1 multiplexer**
- Learn how to run VS Code tasks
- Learn how to open waveforms in VaporView

### Files
- Design:
  ```
  labs/lab1/task0/dut.v
  ```
- Testbench:
  ```
  labs/lab1/tb/tb_mux.v
  ```

### Steps
1. Run **Compile (lab + task + testbench)** with:
   - lab: `lab1`
   - task: `task0`
   - testbench: `tb_mux.v`  
   For this, press `ctrl + shift + b`, then enter the above in the prompts.  
   You should see `compiled to artifact ...` in the terminal at the bottom.  
   Resulting `.sim` file will be generated in the `artefacts` folder.
2. Run **Run (generate VCD)**  
   For this, press `ctrl + shift + p`, then type `test`, then select `Tasks: Run Test Task`.  
   Respond to the prompts.  
   Resulting `.vcd` file will be generated in `artefacts` folder.
3. Open the generated VCD file in VaporView (double-click).
4. Observe how input changes affect the output (you will have to `add signals from Netlist view`).

---

## 6. How to Compile and Simulate (General)

When running a simulation, you must specify:
1. Lab (e.g. lab01)
2. Task (e.g. task2)
3. Testbench (e.g. tb_fa.v)

Simulation outputs are generated in:
```
artefacts/lab1/
```

### Upon completion
Once you verify that the output is correct:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task0`
3. Push the commit to GitHub (press the `sync` button)

---

## 7. Lab Tasks

Task 1 – Structural Modeling (Gate-Level)  
Objective:
Implement a 1-bit full adder using structural (gate-level) Verilog.

Requirements:
- Use gate primitives (and, or, xor, not)
- No assign statements
- No always blocks

File:
labs/lab01/task1/dut.v

Testbench:
tb_fa.v

Open this file and understand how the testbench works by reading through all the comments carefully. _Next lab onwards you will write your own test benches._

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task1`
3. Push the commit to GitHub

---

Task 2 – Dataflow Modeling  
Objective:
Implement the same full adder using dataflow modeling.

Requirements:
- Use continuous assignments (assign)
- Express logic as Boolean equations
- No gate primitives
- No always blocks

File:
labs/lab01/task2/dut.v

Testbench:
tb_fa.v

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task2`
3. Push the commit to GitHub

---

Task 3 – Behavioral / RTL Modeling  
Objective:
Implement the same full adder using behavioral modeling.

Requirements:
- Use always @(*)

File:
labs/lab01/task3/dut.v

Testbench:
tb_fa.v

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task3`
3. Push the commit to GitHub

---

Task 4 – Hierarchical Design (4-bit Adder)  
Objective:
Build a 4-bit ripple-carry adder using reusable 1-bit full adders.

Requirements:
- Use module instantiation
- You already built a full adder in task 3. Now copy the file into task 4 directory and rename it as `fa.v`.
- Also rename the module as `fa` instead of `dut`.
- Create another file inside task 4 folder named `dut.v`.
- In this file, instantiate the `fa` module and use it to build a 4-bit adder.

File:
labs/lab01/task4/dut.v
labs/lab01/task4/fa.v

Testbench:
tb_4bit.v

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task4`
3. Push the commit to GitHub

---

Task 5 – Practice at home: 4-bit Adder–Subtractor  
Objective:
Extend the 4-bit adder to support subtraction.

Requirements:
- sub = 0 → addition
- sub = 1 → subtraction
- Use two’s complement logic
- Reuse existing 4-bit adder module by copying over the files from task 4 folder.

File:
labs/lab01/task5/dut.v
labs/lab01/task5/fa.v
labs/lab01/task5/adder4bit.v

Testbench:
tb_4bit_addsub.v

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task5`
3. Push the commit to GitHub

---

## 8. Verification Expectations

Required:
- Clean compilation
- Correct simulation behavior
- All test cases pass

---

## 10. Learning Outcome

By completing Lab 1, you should be comfortable:
- Writing Verilog at multiple abstraction levels
- Simulating and verifying combinational logic
- Understanding testbenches and waveforms
- Working with a structured HDL workflow

---

# CS F342 – Computer Architecture
## Lab 2: Sequential Verilog Foundations

---

## 1. Objective

The objective of **Lab 2** is to introduce **state, time, and control** in digital systems using Verilog.

In this lab, you will:

- Understand how **hardware stores state**
- Correctly write **clocked (sequential) Verilog**
- Distinguish clearly between:
  - combinational logic
  - sequential (state-holding) logic
- Learn the role of:
  - clocks
  - resets
  - registers
- Observe and reason about the difference between:
  - blocking assignments (`=`)
  - non-blocking assignments (`<=`)
- Design and reason about **finite state machines (FSMs)**

This lab marks a conceptual shift from:

> “logic that computes”  
to  
> “hardware that remembers and reacts over time”.

---

## 2. Background: Sequential Logic in Verilog

### 2.1 What makes logic sequential?

A circuit is **sequential** if:
- its outputs depend on **past inputs**
- it contains **storage elements** such as flip-flops or registers

In Verilog, state is modeled using:
- `reg` variables
- updated inside **clocked `always` blocks**

---

### 2.2 Clocked always blocks

A typical sequential block looks like:

```verilog
always @(posedge clk) begin
  q <= d;
end
```

Key points:
- The block executes **only on the rising edge of the clock**
- The value of `q` updates **only at the clock edge**
- `<=` (non-blocking assignment) is required for sequential logic

---

### 2.3 Reset behavior

A reset initializes hardware to a known state.

Two common styles:
- **Synchronous reset**: reset is checked inside the clocked block, and thus, reset occurs at the next rising edge
- **Asynchronous reset**: reset is included in the sensitivity list, and thus it occurs immediately when the reset signal itself switches

You will implement and compare both.

---

### 2.4 Blocking vs non-blocking assignments

- Blocking assignment (`=`):
  - Executes immediately
  - Suitable for combinational logic
- Non-blocking assignment (`<=`):
  - Updates occur together at the clock edge
  - Required for sequential logic

Using blocking assignments incorrectly in sequential logic leads to subtle bugs.
You will observe this directly in Task 3.

---

## 3. Lab Structure

```
labs/lab02/
├── manual.md
├── task1/
│   └── dut.v
├── task2/
│   └── dut.v
├── task3/
│   └── dut.v
├── task4/
│   └── dut.v
├── task5/
│   └── dut.v
├── tb/
│   ├── tb_dff.v
│   ├── tb_register.v
│   ├── tb_shiftreg.v
│   ├── tb_counter.v
│   └── tb_fsm.v
```

Rules:
- Each task has exactly **one top-level module named `dut`**
- Testbenches are provided and must **not** be modified
- Generated files go into `artefacts/lab02/`

---

## Task 1: D Flip-Flop with Active Low Reset (Starter)

### Objective
Implement a **positive-edge-triggered D flip-flop (DFF)**, and study reset behavior.

### What is provided
- Starter code for a D flip-flop **without reset**
- test bench for task 1 `tb_task1.v`

### What you must do
1. Add a **synchronous _active low_ reset in task1.1**
2. Add an **asynchronous _active low_ reset in task 1.2**
3. Simulate both versions using the same testbench
4. Compare waveforms  
   1. Open both VCD files simultaneously one above the other to compare.  
   2. You should be able to explain everything that you observe in both waveforms.  
   3. Take a screenshot and annotate the key difference, and save it at `artefacts/lab02/task1.png`

### Concepts reinforced
- Clock edges
- Reset semantics
- Timing of state updates

---

## Task 2: Register (Structural Design)

### Objective
Build an **8-register** by **structurally composing** the D flip-flops from Task 1.

### Requirements
- Repeat the following for sync and async reset (task2.1 and 2.2 respectively)
- Do not rewrite flip-flop logic
- Instantiate multiple DFF modules (copy the modules from task 1 into task 2 folder and name the modules _and_ files dff)
- Use vector signals at the top level (i.e. `input[7:0] d`, `output[7:0] q`) instead of defining individual bits.

---

## Task 3: Shift Register (Blocking vs Non-blocking)

### Objective
Implement a **shift register** from scratch using **behavioral modeling** and observe the effect of:
- blocking assignments (`=`)
- non-blocking assignments (`<=`)

### What is provided
- Starter code for shift register is provided in task3.1
- Test bench file `tb_task3.v`

### What you must do
1. Compile and run task3.1 with the appropriate test bench
2. Observe the waveforms and identify what is wrong in the functionality of the shift register
3. The same code is provided in task3.2. Modify this code to correct the error from 3.1 by using non-blocking assignments. **Do not modify task3.1 code**.
4. Compile and run 3.2.  
Open the waveforms of 3.1 and 3.2 one below another.  
Take a screenshot showing how the error is fixed and correct behavior is observed.  
Annotate the region and add at `artefacts/lab02/task3.png`
5. Optional: does changing the sequence of blocking statements (3.1) change the results? Find a sequence of blocking statements that will give correct behavior (although it is a WRONG implementation).

---

## Task 4: Counter 

### Objective
Design a **simple 8-bit up-counter**.

### Requirements
- Increment by 1 on every positive clock edge
- Include reset
- Purely sequential design
- task4.1: using the DFFs from task1.1 (sync reset)
- task4.2: using the DFFs from task1.2 (async reset)
- Compare the resulting waveforms and make sure you understand everything that you observe

---

## Task 5 (Homework, evaluative): FSM for a sequential adder / subtractor

### Objective
Design an FSM-controlled system integrating registers, arithmetic, and user-driven control.

### Datapath
- Two 8-bit registers: R0 and R1 (use one of the modules you wrote in task2)
- Arithmetic: add and subtract (use the adder-subtractor module from lab01/task5)
- Write-back to either register

### Control Inputs

Operation buttons `op[1:0]`:

| op | Meaning |
|----|--------|
| 00 | No-op |
| 01 | Add |
| 10 | Subtract |
| 11 | Toggle halt/run |

Destination select button `dest`:
- 0 → write to R0
- 1 → write to R1

Buttons are **level-sensitive** ie button levels are read during clock transition to decide actions; button level changes do not trigger anything.

---

### FSM States

1. RUN_WAIT  
2. RUN_RESULT_READY  
3. HALTED  

FSM must be implemented **behaviorally using `case(state)` only**.

---

### Reset Behavior
- Reset places FSM in RUN_WAIT
- Registers must be initialized to known values on reset

---

## Submission

**After every task**
- commit `dut.v` and `vcd` files with specific commit message, `lab02 taskx`

**Task 5**
- commit `dut.v` with the **exact commit message** `lab02-eval`
Any commit with this name will run through the autograder, so if there is a correction, you can make it and recommit with the same message.

---

## 11. Learning Outcomes

After Lab 2, you should be able to:
- Write correct sequential Verilog
- Reason about clocked behavior
- Debug timing-related bugs
- Design simple FSMs

---

# CS F342 – Computer Architecture
## Lab 3: RISC-V Assembly Programming, Encoding, and Decoding of Instructions


## Objective

The objective of **Lab 3** is to understand the **Instruction Set Architecture (ISA)** from both the **programmer's** and the **hardware designer's** perspective.

In this lab, you will:

- Write **non-trivial RISC-V assembly programs**
- Understand how assembly instructions are **encoded into machine code**
- Manually **decode machine code** back into assembly
- Observe how instructions are **decoded and executed** in hardware
- Relate instruction fields to:
  - register file access
  - immediate generation
  - PC update logic
  - control flow

This lab explicitly bridges **ISA semantics** with **datapath and control concepts** discussed in the lectures.

---

## Tool

You will use a web-based RISC-V simulator:

https://riscv-simulator-five.vercel.app/

You are expected to:
- assemble code
- step through execution instruction-by-instruction
- inspect PC, registers, and datapath signals

using this tool.

## Using the Simulator
- The left panel is for writing assembly code.
- Press **Assemble** to convert your code into machine instructions.
- Use **Step** or **Run** to observe execution.
- The right panel displays:
  - **Program Counter (PC)**
  - **Register values**
  - **Immediate generation**
  - **Control and datapath signals**

- You are encouraged to **step through one instruction at a time** to understand how each instruction affects the registers and PC.
- You can also look at the actual datapath by switching to the `datapath` tab on the top. As you step through your code, you can see how the signals propagate through the datapath and register values change.
- The memory tab shows the different memory contents
   - data: data memory
   - text: program / instruction memory
---

## Submission

- Add this lab folder to your GitHub codespace.
- Treat this file as a worksheet and fill in the appropriate places indicated below (empty code blocks and tables).
- Commit after finishing all tasks with the message exactly: `lab03 eval`.
- You can commit at intermediate steps with other messages if you wish.

---

## Task 1: Basic Assembly Programs

### Objective
Become fluent with basic RISC-V assembly instructions and understand **register-level effects**.

---

### Task 1A: Register–Register Arithmetic

**Write an assembly program that:**

- Loads two constants into registers
- Performs:
  - addition  
     ```
     addi x5,x0,2
     addi x6,x0,3
     add  x7,x6,x5

     ```
  - bitwise AND  
     ```
     and x7,x6,x5

     ```

**Constraints**
- Use only: `addi`, `add`, `and`
- Use registers: `x5`, `x6`, `x7` and `x0` only

**Report** (fill the table below)  
1. Execute the assembly program in the tool linked above.
2. After execution, fill the following table:

| Instruction | Destination Register | Value Written |
|------------|----------------------|---------------|
| add        |          t2            |  0x00000005     |
| and        |         t2             |  0x00000002             |

---

### Task 1B: Immediate Arithmetic

**Write an assembly program that:**

- Initializes a register with a constant
- Modifies it using **at least three immediate type arithmetic instructions**
- Includes **at least one negative immediate**
   ```

   addi x6,x0,2
   addi x6,x6,3
   addi x6,x6,-2
   addi x6,x6,13

   ```


**Report**
- Initial register value (init row below)
- Register value after each instruction
- Explanation of how **sign extension** affects execution : As we know addi uses 12-bit immediate because it maximises useful constant range while preserving RISC-V's 32-bit instruction format and simple hardware decoding.

| Step | Instruction | Immediate (decimal) | Immediate (binary)         | Register Value After Execution(hexadecimal) |
|------|------------|---------------------|-----------------------------|--------------------------------|
| Init |0x00200313            |       2              |      000000000010                       |      0x00000002                          |
| 1    |  0x00330313          |       3              |       000000000011                         |      0x00000005                          |
| 2    |0xffe30313            |       -2              |       111111111110                         |      0x00000003                          |
| 3    |0x00d30313            |        13             |   000000001101                          |     0x00000010                           |




---

## Task 2: Control Flow – Branches, Loops, and Jumps

### Objective
Understand **PC-relative control flow**.

---

### Program Specification

Write a program that:

- Initializes a counter to **10**
- Decrements it inside a loop
- Exits when the counter reaches zero
- Stores the **number of loop iterations executed** in a register

**Must use**
- `beq` or `bne`
- At least one `jal`

---
```

# Register Mapping:
# x5 (t0): Loop Counter (starts at 10)
# x6 (t1): Iteration Tracker (starts at 0)

        li   x5, 10          # Initialize counter to 10
        li   x6, 0           # Initialize iteration tracker to 0

loop:
        jal  x1, increment   # Jump and link to increment logic
        addi x5, x5, -1      # Decrement the counter
        bne  x5, x0, loop    # If x5 != 0, branch back to 'loop'
        
        j    exit            # Jump to end of program

increment:
        addi x6, x6, 1       # Increment iteration tracker
        jr   x1              # Jump back to the instruction after 'jal'

exit:
        # Final result: x6 contains the number of iterations (10)
        nop                  # Program ends here


```

### Report

For **one conditional branch** and **one jump**, fill the table __*before stepping*__:

| Instruction | PC (hex) | Immediate | Predicted Next PC | Actual Next PC |
|------------|----------|-----------|-------------------|----------------|
| jal x1, 0x00000018  | 0x00000008  | +16 (or 0x10)  | 0x00000018  |  0x00000018 |
|bne x5, x0, loop   |  0x00000010 | -8  | 0x00000014  | 0x00000008  |
|   |   |   |   |   |

---

## Task 3: Manual Instruction Encoding

### Objective
Understand how assembly instructions map to **32-bit machine code**.

---

### Instructions to Encode

Manually encode the following instructions:

1. `add x7, x5, x6`
2. `addi x6, x6, -4`
3. `beq x5, x0, label`
4. `jal x1, label`

For **each instruction**, fill the table below:

| Field |  Value | | | |
|------|-------|------|-------|------|
| Instruction | add | addi | beq | jal |
| Instruction format (R/I/B/J) |R | I|B | J|
| Opcode |0110011 | 0010011|1100011 |1101111 |
| rs1 |00101 (x5) |00110 (x6) |00101 (x5) |X |
| rs2 |00110 (x6) | X|00000 (x0) |X |
| rd |00111 (x7) |00110 (x6) | X| 00001 (x1)|
| Immediate (binary, sign-extended) |X |111111111100 (-4) |000000001000 (+8) |0000000000010000 (+16) |
| Final 32-bit encoding (hex) | 0x006283b3| 0xffc30313|0x00028463 |0x010000ef |

Verify each encoding using the simulator assembler.

---

## Task 4: Manual Instruction Decoding (Prediction Task)

### Objective
Practice **decode as hardware would do**, without executing first.

---

### Given Machine Code Sequence

```
0x00500293
0x00100313
0x00628463
0xFFF30313
0xFE000AE3
0x0000006F
```

---

### Task 4A: Decode Table

Fill the following table as if you were the processor, and you are working through the instructions one line at a time. Assume you start with PC = 0 on the first line.

| PC | Instruction (hex) | Type | rs1 | rs2 | rd | Immediate | Meaning | Assembly |
|----|------------------|------|-----|-----|----|-----------|---------|----------|
| 0x0   |   0x00500293  |  I    | x0    |_     |x5    |5           | Set x5 to 5        | li x5, 5         <br> |
| 0x4   |  0x00100313   |   I   |  x0   |   _  |x6    |      1     |Set x6 to 1         | li x6, 1         <br> |
| 0x8   |  0x00628463   |    B  | x5    | x6    | _   |  +8         |  If x5 == x6, jump to PC+8       |beq x5, x6, 8          <br> |
| 0xC   |  0xFFF30313   |     I |  x6   |   _  |  x6  |         -1  |Decrement x6 by 1         |addi x6, x6, -1          <br> |
| 0x10  | 0xFE000AE3    |      B|  x0   | x0    |   _ |     -12      |Unconditional loop to PC-12         |beq x0, x0, -12          <br> |
| 0x14  |  0x0000006F   |    J  |  _   |   _  |  x0  |   +0        |Infinite loop at current PC         | j 0         <br> |



Include:
- sign-extended immediates
- PC-relative offsets in **bytes**

---

### Task 4B: Register & PC Prediction

Assume initial state:

```
x5 = 0
x6 = 0
x7 = 0
```

Fill **predicted values**:

| PC | x5 | x6 | x7 | Next PC |
|----|----|----|----|---------|
|0x0    |0    | 0   | 0   | x5 becomes 5    <br>|
|0x4    | 5   |  0  |  0  |x6 becomes 1     <br>|
|   0x8 |  5  | 1   |   0 | x5 (5) != x6 (1), so branch not taken    <br>|
| 0xC   |   5 | 1   | 0   | x6 becomes 0    <br>|
| 0x10   |   5 | 0   | 0   |x0 == x0 is always true; branch taken to 0x10 - 12 = 0x4     <br>|
|0x4    |   5 | 0   |   0 | Second pass: x6 becomes 1 again    <br>|

---

## 8. Task 5: Decode Verification via Execution

### Objective
Verify decode reasoning using actual execution.

---

### Steps

1. Load the same assembly code you obtained above into the simulator
2. Step instruction-by-instruction
3. Observe and verify with your prediction above:
   - PC updates
   - Register writes

---

### Report

For **each mismatch** between prediction and observation:
- identify the incorrect assumption
- explain the architectural reason
in the space below
```
PC Updates: During execution, I observed that the PC always increments by 4 bytes (e.g., from 0x00 to 0x04) because RISC-V instructions are 32 bits wide. If I had predicted an increment of 1, the mismatch is due to the architectural requirement of byte-addressing for memory.

Branching Logic: At address 0x10, the instruction 0xFE000AE3 resulted in a jump back to 0x04. This confirms that branches use PC-relative addressing, where the immediate value is a signed offset added to the current PC rather than an absolute address.

Register Writes: I verified that writes to x5 and x6 updated immediately in the register file. Any prediction involving x0 changing would be a mismatch because register x0 is hardwired to zero at the hardware level; any data written to it is discarded.

```

---

## 9. Take-Home (Evaluative): Reverse Engineering with Errors

### Given Machine Code Program

```
0x00000293
0x00100313
0x00600393
0x00038A63
0x00628433
0x00030393
0x00040393
0xFFE38393
0x00C0006F
0x0000006F
0x00000393
```

The program contains **exactly three errors**:

1. Immediate encoding error
2. Jump address related error
3. Semantic (algorithmic) register-update error

---

### Student Tasks

1. Decode the program into assembly

   

| Machine Code | Assembly Instruction | Functional Meaning |
|-------------|----------------------|--------------------|
| 0x00000293  | li x5, 0             | Load immediate 0 into x5 (Accumulator). |
| 0x00100313  | li x6, 1             | Load immediate 1 into x6 (Increment value). |
| 0x00600393  | li x7, 6             | Load immediate 6 into x7 (Loop limit). |
| 0x00038A63  | beq x7, x0, 20       | If x7 == 0, jump forward 20 bytes (to 0x20). |
| 0x00628433  | add x8, x5, x6       | Add x5 and x6, store result in x8 (Target error). |
| 0x00030393  | addi x7, x6, 0       | Set x7 equal to x6 (1). |
| 0x00040393  | li x8, 0             | Set x8 to 0. |
| 0xFFE38393  | addi x7, x7, -2      | Subtract 2 from x7. |
| 0x00C0006F  | jal x0, 12           | Jump forward 12 bytes. |
| 0x0000006F  | jal x0, 0            | Infinite loop at current address. |
| 0x00000393  | li x7, 0             | Load immediate 0 into x7. |

  
2. Explain the **intended algorithm** (what does it do?)
   ```
   The program is intended to be a Summation Loop. It aims to initialize a counter to zero and repeatedly add an increment value (x6) to an accumulator (x5) until a target limit (x7) is reached. In high-level logic, it should perform: while (accumulator < limit) { accumulator += increment; }

   ```
3. Identify and explain **each error**
   ```
   - Error 1: Immediate Encoding Error (beq x7, x0, 20) The branch instruction uses an immediate offset that points to an incorrect logical location. Instead of exiting the loop cleanly, it jumps to a jal instruction that skips over the intended termination sequence.
   - Error 2: Jump Address Related Error (jal x0, 12) The jump at 0x20 is mathematically misplaced. It jumps forward 12 bytes, landing the Program Counter on a li x7, 0 instruction that should be dead code. This breaks the flow of the loop and prevents it from ever returning to the addition logic.
   - Error 3: Semantic (Algorithmic) Register-Update Error (add x8, x5, x6) This is a destination register error. The addition result is stored in x8, but the loop depends on x5 to track the progress. Because x5 never changes, the loop condition will never be satisfied, resulting in a logical failure.
   ```
4. Correct the machine code  
   Create a new file, `artefacts/lab03/assembly.asm` and add the final correct code there.
5. Verify corrected behavior in the simulator
6. Did you notice anything stragne? How does the CPU know when to stop executing instructions / when the program has ended?

```
Strange Observation: The CPU does not inherently know when a program is "finished." It simply follows the Fetch-Decode-Execute cycle indefinitely.

How it knows when to stop:

Software Traps: Instructions like ebreak or ecall signal the environment (the simulator or OS) to stop execution.

Infinite Loops: Programmers often use j . (jump to current PC) to trap the CPU in a single spot once the work is done.

Hardware Exceptions: If the CPU "slides" past your code into unwritten memory, it will eventually attempt to decode an invalid instruction, causing a hardware exception/crash.

```

_Hint: you can examine the behavior of the machine code by copying it into the text memory in the simulator and stepping through. I am not sure if that will work, but you can try._

---

## 11. Learning Outcomes

After Lab 3, you should be able to:

- Write and read non-trivial RISC-V assembly
- Encode and decode instructions manually
- Reason about PC-relative control flow
- Relate ISA semantics to datapath behavior

---

**End of Lab 3 Manual**



## Important Note on Halt

The base RISC-V ISA does **not** include a HALT instruction.

In this lab, a **self-looping jump** is used to represent a halted processor:

```asm
end:
  jal x0, end
```

This is a standard bare-metal technique and should be treated as an explicit halt.

---

# CS F342 – Computer Architecture
## Lab 4: Structural Design of a 32-bit ALU

## Submission

Submit:
- Add all tasks to your codespace. Submit take-home part by committing and pushing with the exact message `lab04-eval`
- **Ensure all tasks are placed in the correct folder.** Especially the evaluative code. Otherwise it will not be graded. We are not responsible for missed marks due to incorrect file organization.

---


## Objective

The objective of **Lab 4** is to design a **structural, timing-aware Arithmetic Logic Unit (ALU)**.

This lab emphasizes:
- **Structural (datapath-level) RTL design**
- **Timing awareness** through canonical delay annotation
- Understanding how **critical paths** arise in processor datapaths
- Deep reasoning about **two’s complement arithmetic** and **interpretation vs operation**
- **Writing your own testbenches**

---

## Background

### 1. Why Timing Matters in Architecture

In a synchronous processor:

```
Register → Combinational Logic → Register
```

The **longest combinational delay** between two registers determines:
- the **minimum clock period**
- the **maximum clock frequency**

From this lab onward, *all designs are expected to be timing-aware*.

### 2. Important architectural points:

- The ALU **does not decode instructions**
- The ALU **does not see opcodes, funct3, or funct7**
- Instruction decoding produces a **final ALU control signal**
- The same ALU hardware is reused for:
  - arithmetic instructions
  - logical instructions
  - address calculation
  - branch comparison

In this lab, instruction decoding is assumed to be already done.

---

## Design Philosophy and Constraints

### 1. Structural Design Requirement

You must design the ALU **structurally**, by composing it from smaller submodules.

❌ A single behavioral `case` statement that directly computes all operations is **not allowed**.

✔ Behavioral code *inside submodules* is allowed.

### 2. Datapath Reuse

You are expected to reuse hardware wherever possible:

- A single **adder/subtractor** must support:
  - ADD
  - SUB
  - SLT (signed)
- A single **shifter** must support:
  - SLL
  - SRL
- Comparison operations must reuse arithmetic results

### 3. Timing-Aware RTL Requirement

All **combinational submodules** must include **explicit delay annotations** (`#`) that represent **relative logic depth**, not physical silicon delay. The delays you will use are indicated below.

### 4. Canonical Delay Budget

Use the following canonical delay budget consistently:

| Component | Canonical Delay |
|---------|-----------------|
| 32-bit Adder/Subtractor | `#3` |
| Comparator logic (in addition to adder/subtractor) | `#1` |
| Logic unit (AND / OR) | `#1` |
| Shifter (SLL / SRL) | `#2` |
| Multiplexer | `#1` |
| Register clk→Q | `#1` |
| Register setup time | `#1` |

These values are abstract and technology-independent. Delays are provided at the timescale of 1 ns. Include this line to make it explicit in your code: ```
`timescale 1ns/1ps```. The syntax is ```
`timescale <time_unit> / <time_precision>```.

---

## ALU Interface Specification

Your ALU must implement the following interface:

```verilog
input  signed [31:0] A,
input  signed [31:0] B,
input  [2:0]         alu_ctrl,
output signed [31:0] Y,
output               zero
```

### Signal meanings

- `A`, `B`: 32-bit signed operands
- `alu_ctrl`: final ALU control signal (generated elsewhere)
- `Y`: 32-bit ALU result
- `zero`: asserted when `Y == 0`

For shift operations, the shift amount must be taken from `B[4:0]`.

---

## Supported Operations

Your ALU must support the following operations:

| alu_ctrl | Operation | Description |
|---------|-----------|-------------|
| 000 | SUB | Signed subtraction |
| 001 | ADD | Signed addition |
| 010 | AND | Bitwise AND |
| 011 | OR  | Bitwise OR |
| 100 | SLL | Logical left shift |
| 101 | SRL | Logical right shift |
| 110 | SLT | Set-less-than (signed) |
| 111 | Reserved | Output zero |
---
### General Guide to Writing a Verilog Testbench
---


A testbench is a standalone module with **no input or output ports**.  
It simply wraps and drives the Design Under Test (DUT).

**Read the comments below carefully to learn about writing testbenches and practical tips.**

```verilog
module tb;
reg  [31:0] A, B;             // input of the DUT are declared as reg
reg  [2:0]  alu_ctrl;         // outputs are declared as wires
wire [31:0] Y;                // in a test bench
wire        zero;             

alu dut (                     // the module that needs to simulated 
    .A(A),                    // is instantiated under an instance name
    .B(B),                    // i.e., "dut" in this case
    .alu_ctrl(alu_ctrl),
    .Y(Y),
    .zero(zero)
);

// ----------------------------------------------------------------------------------------------
// ENSURE YOU INCLUDE THIS BLOCK FOR COMPILATION TO WORK CORRECTLY!!!!!!!!!!!!!
// Waveform dump configuration
// ----------------------------------------------------------------------------------------------
// This string will store the VCD file name passed from the command line.
string vcd_file;

// This initial block runs once at the start of simulation.
initial begin
   // Check if a VCD file name was passed using +vcd=<filename>
   if ($value$plusargs("vcd=%s", vcd_file))
   // If provided, dump waveforms to that file
   $dumpfile(vcd_file);
   else
   // Otherwise, use a default file name
   $dumpfile("fa.vcd");

   // Dump all signals inside the DUT hierarchy
   $dumpvars(0, DUT);
end

// ----------------------------------------------------------------------------------------------
// Test logic
// This will generate waveforms that you can test manually
// You can also print 'test results' directly by comparing to expected outputs
// See https://github.com/csf342/csf342-p2-labs-csf342-labs/blob/main/labs/lab01/tb/tb_fa.v for reference.
// ----------------------------------------------------------------------------------------------

initial begin                 // Stimulus generation
    // Test case 1
    A = 10; B = 5; alu_ctrl = 3'b000;   // ADD
    #10;

    // Test case 2
    A = -4; B = 7; alu_ctrl = 3'b001;   // SUB
    #10;

    $finish;
end


endmodule
```
---

## In-Lab Tasks

* For each task, create the actual module in the `../../shared` folder, which should already exist.  
* In the task folder, such as `task0`, create a wrapper module named `dut`, which uses the actual module from `shared`.  
* This will allow you to reuse your modules for later tasks and labs.
* The module names to be used in the `shared` folder are specified. Make sure you use exactly that name without **any** change.

### Task 1: Timing-Aware 32-bit Adder / Subtractor

**Objective:**  
Design a 32-bit signed adder/subtractor module.  
Module name: `aluaddsub`

**Requirements:**
- One module must support both addition and subtraction
- Subtraction must be implemented using **two’s complement**
- You may use Verilog `+` internally
- Output must be 32-bit signed
- Negative overflow flag and positive overflow flag
   - Incoming carry into MSB is 1 and outgoing carry is 0 -- positive overflow
   - Incoming carry into MSB is 0 and outgoing carry is 1 -- negative overflow


**What to test:**
- positive + positive
- positive + negative
- subtraction resulting in negative values

**For each of the above, report the delay in `ns` between application of input to stabilization of output** in the box below. Use the waveform viewer for this.
```
3ns

```

---

### Task 2: Logic Unit

**Objective:**  
Design a logic unit that computes bitwise operations.
Module name: `alulogic`

**Requirements:**
- Support AND and OR
- Operands must be 32-bit
- Output must be combinational

**What to test:**
- random bit patterns
- edge cases (all zeros, all ones)

**For each of the above, report the delay between application of input to stabilization of output** in the box below. Use the waveform viewer for this.
```
1ns


```

---

### Task 3: Shifter

**Objective:**  
Design a logical shifter module.
Module name: `alushift`

**Requirements:**
- Support SLL and SRL
- Shift amount must be `B[4:0]`
- Shifts must be logical (no sign extension)

**What to test:**
- shift by 0
- shift by 1
- shift by -1 (what do you expect? Is the behavior consistent with your intuition?)

**For each of the above, report the delay between application of input to stabilization of output** in the box below. Use the waveform viewer for this.
```
2ns

```

---

### Task 4: Signed Comparator (SLT)

**Objective:**  
Implement signed comparison using existing arithmetic hardware (you can import and reuse the adder/subtractor module from task 1, `aluaddsub`).
Module name: `alucomp`

**Requirements:**
- Output `32'b1` if `A < B`, else `32'b0`
- Must reuse subtraction result
- Must handle overflow correctly

**Hint:**  
Signed comparison is not simply checking the sign bit when overflow occurs.

**For each of the above, report the delay between application of input to stabilization of output** in the box below. Use the waveform viewer for this.
```
4ns,1ns


```

**Side Exercise:** <br>
Go through the ALU Control signal and check whether it's synthesizable on microarchitectural level if we used 000 for ADD and 001 for SUB. <br>
(hint : Subtractor and SLT use the same operation, so they can use single control bit to select both of the operations). Comment below:
```
Yes, this mapping is highly efficient for microarchitectural synthesis. Using the least significant bit (alu_ctrl(0)) as the toggle between addition and subtraction allows for a simplified hardware implementation:Hardware Reuse: The same arithmetic unit can perform both operations by using alu_ctrl(0) to control the XOR gates for B's inversion and as the carry-in for the adder.Unified SLT Logic: Since SLT also requires a subtraction, a single control bit can trigger the subtraction mode for both the SUB instruction and the SLT instruction. This reduces the complexity of the decoder logic, saving area and power on the chip.

```

---

### Task 5: Integrated Structural ALU

**Objective:**  
Integrate all submodules into a single structural ALU.
Module name: `rv32ialu`

**Requirements:**
- All submodules compute in parallel
- A multiplexer selects final output based on `alu_ctrl`
- `zero` flag is derived from final output only
- No instruction decoding logic allowed inside the ALU

**Tming analysis:** based on the observations above, which operation is the slowest for the ALU you designed?
```
SLT (Signed Set Less Than)

```

---

## Testing Expectations

You are expected to:
- Write systematic test cases on your own test bench  
**Follow the same convention as before**:
   - Top level module to be tested should be named `dut`
   - Test benches should live in the `tb` folder under `lab04` with appropriate names (`taskx` works best)
   - Each task should live in its own folder
   - But the actual module should be in `../../shared`
- Test boundary conditions
- Use waveforms for debugging

---

## Take-Home Evaluative Component  
## Signed vs Unsigned Interpretation in ALU Design

---

### Part A: Two’s Complement and Overflow (Conceptual)

Answer the following in the space provided below:

1. Explain how signed overflow occurs in two’s complement addition.
   ```
   Signed overflow happens when the magnitude of the mathematical sum exceeds the representable range of a 32-bit signed integer ([-2^31, 2^31-1]). Architecturally, this is detected by observing the operand signs. If you add two numbers with the same sign (both positive or both negative) but the result sign is different, overflow has occurred.Example: Adding two large positive numbers (sign bits are 0) results in a sum that "wraps around" into the negative range (result sign is 1).

   ```

2. Why does carry-out fail to indicate signed overflow?
   ```
   The carry-out (the 33rd bit) only indicates that the result exceeded the unsigned range (0, 2^32-1). In signed arithmetic, a carry-out is often a normal part of the calculation and does not imply an error.Example: Adding -1 (0xFFFFFFFF) and -1 (0xFFFFFFFF) produces a carry-out of 1, but the 32-bit result is -2 (0xFFFFFFFE), which is perfectly correct. Conversely, adding 2^(30) + 2^(30) produces a signed overflow but results in a carry-out of 0.

   ```

3. Why does RISC-V avoid exposing overflow flags in the ISA?
   ```
   Hardware Efficiency: Maintaining a dedicated "Flags" or "Condition Code" register creates a bottleneck in out-of-order execution and pipelining.Software Flexibility: Most high-level languages (like C) do not require overflow detection. In cases where it is needed (like secure math libraries), RISC-V allows the programmer to check for overflow using a simple branch comparison after the addition (e.g., checking if the sum is less than an operand), which keeps the hardware critical path lean.

   ```

Your explanation must refer to:
- sign bits
- operand signs
- result sign

---

### Part B: Same Hardware, Different Meaning

For each case below, fill the table and explain your reasoning.

| A (hex) | B (hex) | Operation | Result (hex) | Signed Meaning | Unsigned Meaning |
|--------|---------|-----------|--------------|----------------|------------------|
| 0x80000000 | 0x00000001 | A + B |0x80000001 |-2,147,483,648 + 1 = -2,147,483,647 | 2,147,483,648 + 1 = 2,147,483,649|
| 0xFFFFFFFF | 0x00000001 | A + B |0x00000000 | -1 + 1 = 0|4,294,967,295 + 1 = 0 (Wrap) |
| 0x00000001 | 0xFFFFFFFF | A < B |0x0000000X*(X can be 0 or 1) |1 < -1 is False (0) |1 < 4.29 B is True (1) |

Explain:
- what the ALU computes

  The ALU performs a raw 32-bit addition or subtraction. It has no internal concept of "negative" numbers; it just moves electrons through logic gates.
- how interpretation changes the meaning

  Interpretation: The difference is "in the eye of the beholder" (the software). Signed interpretation treats the MSB as a weight of -2^{31}, while unsigned interpretation treats the MSB as a weight of +2^{31}.

---

### Part C: Signed vs Unsigned Comparison (Conceptual)

1. Explain how `SLT` (signed) can be implemented using subtraction.
   ```
   A < B is true if A - B < 0. We perform the subtraction and check the result sign bit. However, if a signed overflow occurs, the sign bit will be wrong. Therefore, SLT =xor(Result_Sign,Overflow).

   ```

2. Explain why `SLTU` (unsigned set less than) cannot rely on the sign bit.
   ```
   In unsigned math, the MSB is not a sign; it represents 2^{31}. A 1 in the MSB makes the number very large, not negative. Checking the sign bit for SLTU would incorrectly suggest that 0xFFFFFFFF (a massive number) is smaller than 0x00000001.

   ```

3. Explain what role carry / borrow plays in unsigned comparison.
   ```
   In unsigned subtraction (A - B), a borrow is required if A is smaller than B. In a 32nd-bit adder, a "borrow" is effectively indicated by the carry-out being 0. Thus, SLTU =negation(Carry_Out). 

   ```

---

### Part D: Design Extension – SLTU Support

Extend your ALU to support:

```
SLTU: rd = (A < B) ? 1 : 0   // unsigned comparison
```

**Constraints:**
- Do NOT add a second subtractor
- Do NOT use Verilog’s `<` operator for unsigned comparison
- Reuse existing arithmetic hardware

**What to submit:**
1. Block-level explanation of how SLTU is implemented
   ```
   To implement SLTU, we reuse the existing 32-bit subtractor from Task 1. We ignore the overflow and sign bits. Instead, we capture the Carry-Out of the operation A + negation(B) + 1. If the Carry-Out is 0, it indicates that the subtraction required a "borrow" from an imaginary 33rd bit, meaning A < B in unsigned terms.

   ```
   
2. Implementation file (under `lab04/task6`)
3. Explanation of why SLT and SLTU differ despite identical hardware
   ```
   Even though the subtraction hardware is identical, SLT must adjust its answer if the value "wraps around" the signed range (overflow). SLTU is simpler; it only cares if the subtraction required a borrow, treating the entire 32-bit value as a pure magnitude.

   ```

---

### Part E: Reflection

In **5–7 lines**, answer:

> What is the most important architectural insight you gained from implementing SLTU?
   ```
   The most important architectural insight I gained is that the ALU is functionally "type-blind." It performs the same binary arithmetic regardless of whether the programmer intends the numbers to be signed or unsigned. As a designer, my role is to provide different "status bits" (like Carry, Overflow, and Sign) that allow the processor to interpret that same raw result in different ways. Implementing SLTU specifically showed me how hardware reuse (using the same subtractor for SLT and SLTU) minimizes the circuit area, which is a core principle of RISC architectures.

   ```

---

# CS F342 – Computer Architecture
## Lab 5: Structural Register File and ALU Control; Single R-Type Instruction Execution

---

## Objective

The objective of this lab is to design and understand the **core execution machinery** for RISC-V R-type instructions, with emphasis on:

- **Structural Design:** Building a register file from discrete 32-bit registers.
- **Control Logic:** Generating ALU control signals based on hierarchical instruction fields.
- **Timing:** Analyzing signal propagation delays by calculating and verifying theoretical vs. simulation values.

---

## Timing Model and Global Rules

All designs must utilize a consistent timescale to ensure simulation accuracy:
`timescale 1ns/1ps`

All delays (`#`) are abstract and represent nanoseconds.

### Primitive Canonical Delays
To simulate physical gate delays, use the following primitive delays in your code. Even if using behavioral syntax (like `assign` or `always`), you must annotate these delays to enforce the timing model.

| Primitive Hardware Element | Delay Constant |
| :--- | :--- |
| Basic Logic (AND / OR / XOR / NOT) | `#1` |
| Multiplexer (Read Access) | `#1` |
| Decoder (Write Select) | `#1` |
| Register clk→Q (Propagation delay) | `#1` |

All other delays must emerge from structural composition of these primitives.

---

## Design Philosophy

Your Verilog code must explicitly reflect the hardware structure. You are building a circuit, not writing a software program.

### Code Constraints
- Structural Only: Connect modules explicitly via wires.
- Traceable Paths: By looking at the code, you should be able to draw the corresponding datapath.
- Sequential Updates: Only occur on positive clock edges.

   ✔ Allowed:
   ```
   wire [31:0] rdata1;

    mux32to1 u_mux1 (
    .sel(rs1),
    .in(reg_outs),
    .out(rdata1)
    );
   ```  
   ❌ Not allowed:
   ```
   always @(*) begin
     rdata1 = regs[rs1];
     rdata2 = regs[rs2];
   end

  ---------------OR-----------------

   reg [31:0] regs[31:0];

   always @(posedge clk)
     if (we) regs[rd] <= wd;
   ```

---

## Task 1: Register File Design (Structural)

### Task 1A: 32-bit Register Module
**Module Name:** `reg32`

Design a reusable 32-bit register module (behavioral).
* **Inputs:** `clk`, `reset` (Active High, Synchronous), `we` (Write Enable), `d [31:0]`
* **Outputs:** `q [31:0]`
* **Timing constraint:** An explicit clk→Q delay of `#1` must be applied to the output.

---

### Task 1B: Register Array Construction
**Module Name:** `reg_file` (Partial Implementation)

Instantiate 32 copies of `reg32` inside your top-level register file module to form the storage array.
* **The `x0` Rule:** Register 0 must be hard-wired to `0`. It should effectively ignore writes and always output `32'b0`.
  
### Note: 

A 32 bit wide 32X1 MUX can be generated using `generate` block in verilog without instantiating 1 bit 32x1 MUX 32 times. A brief explanation is given below on how to use it.
``` verilog  
module bit32_32to1mux(
  reg_read,
  reg_num,
);
  reg [31:0]reg_file[0:31]; // the register file you have created to be used here
  output [31:0]reg_read;
  input [4:0]reg_num;
  genvar j;
  //this is the variable that is be used in the generate block
  generate for (j=0; j<32; j=j+1) begin: mux_loop
    //mux_loop is the name of the loop
    mux32to1 m1(reg_read[j], reg_num, reg_file[j]);
      //mux32to1 is instantiated every time it is called
    end
  endgenerate
endmodule
```
Similarly, `generate` can be used to instantiate the 32 registers in the RegFile instead of doing it manually.

---
### Task 1C: Read Path Implementation
**Module Name:** `reg_file` (Read Logic Integration)

Implement the two read ports inside the `reg_file` module.
* **Simplification:** You may use **behavioral modeling** for the multiplexers (e.g., array indexing or case statements), provided you strictly annotate the canonical delay.
* **Constraint:** The read path must mimic a hardware multiplexer delay.
    * `assign #1 rdata1 = ...`
* **Timing Verification:**
    1.  Draw the timing path: `clock edge` → `Reg clk→Q` → `Read Logic` → `Data Valid`.
    2.  **Calculate:** Based on the canonical delays, what is the expected total time from the clock edge to valid read data?
    3.  **Verify:** Simulate and check if the waveform matches your calculation.

> **Verification Step:** Do not proceed until you have verified Task 1C. Create a test bench `tb_reg_read.v` to confirm you can read initial values from the registers.
  
---

## Task 2: Write Path and Decoder Design

### Task 2A: Write Enable Decoder
**Module Name:** `decoder5to32`

Design a decoder to select the correct register for writing.
* **Input:** `rd` (5-bit Destination Register Index), `reg_write_en` (Global Write Enable).
* **Output:** `dec_out [31:0]` (32 individual one-hot enable signals).
* **Simplification:** You may use behavioral coding such as  
    ```verilog
    assign #1 dec_out = (reg_write_en) ? (32'b1 << rd) : 32'b0;
    ```
    provided:
* **Timing:** You must annotate a `#1` delay to the output.
---

### Task 2B: Write Path Integration
**Module Name:** `reg_file` (Final / Complete)

Connect the `decoder5to32` module inside your `reg_file` to finalize the design.
* Connect `rd` to the decoder input.
* Connect the `dec_out` lines to the `we` (write enable) ports of the 32 individual `reg32` instances.
* **Constraint:** Ensure `x0` is never written to.
---

### Task 2C: RF Write Timing Evaluation
Analyze the write timing path.
1.  **Trace:** `rd (stable)` → `Decoder` → `Register .we port` → `Positive Clock Edge` → `Register Update`.
2.  **Report:** Calculate the setup time requirement relative to the clock edge.

> **Verification Step:** Create a separate test bench `tb_reg_full.v`. Verify that writing to register $N$ and reading from register $N$ works correctly, and that writing to `x0` has no effect.

---
## Task 3: ALU Control Logic (R-Type Only)
**Module Name:** `alu_ctrl`

Design the combinational logic that generates the `alu_ctrl` signal based on RISC-V fields.
* **Inputs:** `funct3 [2:0]`, `funct7 [6:0]`
* **Output:** `alu_ctrl [2:0]`
* **Timing:** Assign `#1` delay per level of logic used.

| Instruction | funct7[5] | funct3 | alu_ctrl | Operation |
| :--- | :---: | :---: | :---: | :--- |
| ADD | 0 | 000 | 001 | Addition |
| SUB | 1 | 000 | 000 | Subtraction |
| AND | 0 | 111 | 010 | Bitwise AND |
| OR | 0 | 110 | 011 | Bitwise OR |
| SLL | 0 | 001 | 100 | Shift Left Logical |
| SLT | 0 | 010 | 110 | Set Less Than |
---
## Testbench format

Here is a testbench format which will serve as the guide for your r-type instruction implementation.


```verilog
`timescale 1ns/1ps

module tb_lab05;
    reg clk, reset;
    reg [31:0] instruction;
    wire [31:0] rd_val;

    dut (clk, reset, instruction, rd_val); // Top module name to be included here.

    // ---------------------------------------------------------
    // Waveform dump configuration
    // ---------------------------------------------------------
    // This string will store the VCD file name passed from the command line.
    string vcd_file;

    // This initial block runs once at the start of simulation.
    initial begin
      // Check if a VCD file name was passed using +vcd=<filename>
      if ($value$plusargs("vcd=%s", vcd_file))
        // If provided, dump waveforms to that file
        $dumpfile(vcd_file);
      else
        // Otherwise, use a default file name
        $dumpfile("fa.vcd");

      // Dump all signals inside the DUT hierarchy
      $dumpvars(0, DUT);
    end

    initial begin
      // your test bench code...
    end
endmodule
```

**Follow the same convention as before**:
   - Top level module to be tested should be named `dut`
   - Test benches should live in the `tb` folder under `lab05` with appropriate names (`taskx` works best)
   - Each task should live in its own folder

---


## Take-Home Evaluative Component  
**End-to-End R-Type Instruction Execution**

This assignment requires you to first assemble the datapath and then verify it with a specific instruction.

### Part 1: System Integration
**Module Name:** `fragment_r_type`

Create a top-level module that connects your sub-components to form a complete R-type execution engine.
1.  **Field Extraction:** Slice the 32-bit `inst` input into `rs1`, `rs2`, `rd`, `funct3`, and `funct7`.
2.  **Register File:** Instantiate `reg_file`. Connect `rs1`/`rs2` to read inputs and `rd` to the write input.
3.  **ALU Control:** Instantiate `alu_ctrl`. Connect the funct fields.
4.  **ALU:** Instantiate your **Lab 4 ALU**. Connect the Register read outputs to the ALU inputs, and the ALU Control output to the ALU select.
5.  **Write Back:** Connect the ALU Result back to the Register File write data port.

### Part 2: Execution Trace
Choose one R-type instruction (e.g., `sub x5, x3, x4`) and trace its execution.

**1. Instruction Details**
* **Assembly:** `sub x5, x3, x4`
* **Hex Code:** `0x404182B3`

**2. Field Extraction**
Decode your instruction manually:
| Field | Binary Value |
|-------|--------------|
| rs1   | `00011`      |
| rs2   | `00100`      |
| rd    | `00101`      |
| funct3| `000`      |
| funct7| `0100000`      |

**3. Execution Trace**
* **Register Read:**
    * Value at `rs1`: `0x0000000A`
    * Value at `rs2`: `0x00000003`
* **Control Generation:**
    * Calculated `alu_ctrl`: `000` (binary)
* **ALU Result:**
    * Output: `0x00000007`

**4. Write-Back Confirmation**
* **Value written to `rd`:** `0x00000007`
* **Total Latency:** Calculate the time from Instruction Valid → ALU Result Valid.
    * **Calculated:** `6 ns`
    * **Simulated:** `6 ns`

---
### Submission

Commit this completed take-home assignment into your codespace and push with the exact message:

```
lab05-eval
```
---

# Learning Outcomes

After this lab, you should be able to:

- Build a structural register file
- Implement a decoder and analyze its delay
- Translate instruction fields into ALU control
- Trace execution of a binary instruction
- Calculate and verify propagation delays structurally

---

# CS F342 – Computer Architecture
## Lab 6: ImmGen, Memory and RV32I subset
**Objective:** To design and implement the critical sub-systems of a 32-bit RISC-V CPU and integrate them into a functioning single-cycle processor.

---

## Overview
In this lab, you will implement 
- the **Immediate Generator**
- the **PC Incrementer**
- **Banked Memory** systems

Finally, you will integrate these with a **Control Unit** and your **Register File** to execute a basic instruction set (R-type, I-type, Load, and Store).

---

### Instruction Set Support
---
Your CPU must support the following at the end of this lab:
* **R-type:** `add`, `sub`, `and`, `or`
* **I-type:** `addi`, `andi`
* **Load/Store:** `lw`, `sw`

---

## Task 1: Schematics & Design (Pre-Implementation)
*Before writing any Verilog code, you must present the following schematics to your lab instructor for approval.*

### Task 1A : Immediate Generator (ImmGen)
Design a module that extracts the immediate value from a 32-bit instruction.

You can use this table for reference.

| **Instruction Type**              | **Immediate Value Bits (Before Sign Extension)**       |
| --------------------------------- | ------------------------------------------------------ |
| **I-Type** (`addi`, `andi`, `lw`) | `inst[31:20]`                                          |
| **S-Type** (`sw`)                 | `{ inst[31:25], inst[11:7] }`                          |
| **B-Type** (`branches`)           | `{ inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 }` |
---

1. **Block Diagram:** In your circuit, show individual sub-blocks for I-type, S-type, and B-type format generators that take `inst` as input and output a 32-bit binary number. These blocks should feed into a central Multiplexer controlled by `immSel`, so that the correct immediate type is output.
2. **Wiring Logic:** Now, inside each sub-block, show how specific bits from the instruction (e.g., `inst[31:20]`) are wired and sign-extended to form a 32-bit output.

### Task 1B : Banked Memory System
Assume you are provided with a byte-addressable memory module, which means each address applied to the module will return 1 byte (8 bits) of data. However, our CPU operates on 32-bit words. This is how all memories work! So how do we use a byte-addressable memory with a word-addressing procesor to get 4 bytes in a single clock cycle?  

Answer: You use 4 byte addressable memories (called a memory bank), called `bank 0`, `bank 1`, `bank 2` and `bank 3`. `bank 0` will provide the lowest 8 bits, `bank 1` the next 8 bits and so on. The 8-bit outputs of each bank are concatenated to get the full 32-bit word simultaneously (in a single cycle)!  

Note that you have to be careful about the address that you provide to each bank!

1. **Circuit Diagram:** Design a banking system using four 8-bit memory banks. Show how the address bus from the CPU is correctly routed internally inside the bank to the 4 memories. You can assume that the CPU will always output **a word-aligned address** on the address bus.

---
>>>>>**Get these checked from the lab instructor before proceeding!**
---

## Task 2: Module Implementation
Once your schematics are signed off, implement the corresponding modules in Verilog:

## Task 2A : Immediate Generator

### Module Name: `immGen`

**Requirements**: Design an immediate generator which handles I-type, S-type and B-type instructions and generates a sign extended 32 bit operand.

**Inputs**
- 2 bit `immSel`.
- 32 bit `instruction`.

**Output**
- 32 bit sign extended `immOut`.

**Constraint:** Use structural Verilog or continuous assignments (`assign`) to mimic the wiring and MUX logic from your schematic.

**Restriction:** No `always` blocks with behavioral logic for the construction itself.

## Task 2B :  PC Incrementer

### Module Name: `PCInc`

**Logic**: Create a module that takes the current `PC` and outputs `PC + 4`, this modified `PC` is written into the **PC register** on the rising edge of the clock.

**Inputs**
- 32 bit `oldPC`
- `clk`

**Output**
- 32 bit `newPC`

**Requirement:** Reuse the **Adder** module you developed in the previous labs.

## Task 2C : Banked Memory (IMEM & DMEM)

In this task, you will implement a banked 32-bit memory system using four 8-bit memory banks. The memory is divided into:

- Instruction Memory (IMEM) — read-only, asynchronous read

- Data Memory (DMEM) — read/write, asynchronous read, synchronous write

Both memories must fetch or store a full 32-bit word using word-aligned addresses, constructed from four byte-wide memory banks (`bank0`–`bank3`).

8-bit memory banks can be created simply with a register array as follows:
```verilog
    reg [7:0] b0 [0:1023];
    reg [7:0] b1 [0:1023];
    reg [7:0] b2 [0:1023];
    reg [7:0] b3 [0:1023];
```
- Each bank has 1024 lines, which means in total you can address 1024 locations in the memory.  
- How many bits do you need in the address?  
- We are not using the full 32-bit addresses because that will make the memory too large, and cause simulation problems.  
- Accordingly, your circuit should ensure that it ignores part of the input address and only uses the relevant bits to return or write to the correct locations in the memory.

### Module Name: `BankedMEM`

**Inputs**

- `clk` – clock signal

- `writeEn` – enables writing into memory (sw)

- `address` – 32-bit word-aligned address

- `writeData` – 32-bit data to be written

**Outputs**

- `readData` – 32-bit loaded value (lw)

**Constraints**

- Must use four 8-bit memory banks
  
- Reads are asynchronous
  
- Writes occur on posedge clk


## Task 2D : Control Unit

### Module Name: `ControlUnit`

**Logic**: Use a `case` statement based on the instruction `opcode` (behavioral implementation) and `funct3` / `funct7` fields.

**Inputs**
- `instruction`: 32-bit instruction.

**Outputs**
- `RegWrite`: Enables writing to the register file.
- `ALUSrc`: Selects between Register output or Immediate value for ALU input.
- `MemWrite`: Enables writing to data memory.
- `MemRead`: Enables reading from data memory.
- `ALUOp`: 3-bit signal to define the ALU operation (see `lab04` for ALUOp codes).
- `ImmSel`: Control signal for the Immediate Generator.

---

## Task 3: Capstone - CPU Integration
Connect your modules together to form the Single-Cycle CPU.

### Module Name: `cpu_sc_part`

**Inputs**
- None!

**Outputs**
- None!

### Integration Checklist:

1.  **Instruction Fetch:**
    1. Instantiate a `BankedMEM` named `IMEM` and hardwire its `WriteEn` to 0
    2. Connect the `PC` to `IMEM` input
    3. Connect `PC + 4` back to `PC` input.
2.  **Decoding:** Route the instruction to the Control Unit, Register File, and ImmGen after instantiating these three modules.
3.  **Execution:** Instantiate and connect the ALU (from previous lab) with the correct MUX for `ALUSrc`. Connect correct control signals from `ControlUnit` to `ALU` inputs.
4.  **Memory Access:** Instantiate another `BankedMEM` named `DMEM` and connect it appropriately for Load/Store instructions.
5.  **Write Back:** Ensure the Write Back MUX selects between ALU results and Memory results.

---

## Verification (Sample Code)
1. Assemble the following snippet into machine code.
2. Create a test bench and instantiate the `cpu_sc_part` module.
2. In the testbench initial setup, load the machine code into the IMEM of the module.
3. Run the module and verify the register values at the end of the execution:

```assembly
addi x1, x0, 10    # x1 = 10
addi x2, x0, 20    # x2 = 20
add  x3, x1, x2    # x3 = 30
sw   x3, 0(x0)     # Store 30 at memory address 0
lw   x4, 0(x0)     # Load value from address 0 into x4
sub  x5, x4, x1    # x5 = 30 - 10 = 20
```

## Appendix

### Previous modules

If you were unable to complete the previous labs, or do not have confidence in your own modules from previous labs, you can use copy the modules from [here](link).

# CS F342 – Computer Architecture Lab 7

## Objective
Extend the processor to support control flow, integrate into a single-cycle design, and transition toward pipelined execution with hazard analysis and mitigation.

---

## Task 1: Add Control Instructions

### Instructions to implement
- beq rs1, rs2, imm
- bne rs1, rs2, imm
- jal rd, imm

### Expected design additions
- Branch comparator (rs1 == rs2, rs1 != rs2)
- PC update logic:
  - PC + 4 (default)
  - PC + imm (branch/jump target)
- Control signals:
  - Branch
  - Jump
  - PCSrc

### Notes
For jal:
- rd ← PC + 4
- PC ← PC + imm

---

## Task 2: Single-Cycle Integration

### Requirements
- Keep control logic behavioral (use the `switch` statement)
- Integrate:
  - ALU
  - Register file
  - Data memory
  - Instruction memory
  - Immediate generator
  - Control unit

### Deliverables
- Top-level module named `cpu_SC.dut`

---

## Task 3: Run Example Programs
Assemble these using the online assembler to convert to machine code.  
Manually load the machine code into the IMEM in your testbench.  
Execute and note outputs.  
Complete the table after each program.  
Write the program test benches so that they will output the table below automatically.

### Program 1 (test bench name `tb1.v`)

```
addi x1, x0, 10
addi x2, x0, 20
addi x4, x0, 5
xori x3, x1, 0xFF
addi x3, x3, 1
sub  x5, x4, x1
add  x6, x2, x4
add  x7, x3, x2
```

| Register | Expected Value | Observed Value |
|----------|--------------|----------------|
| x1 |10  | 10  |
| x2 | 20 | 20  |
| x3 |246  |246   |
| x4 |5  | 5  |
| x5 | -5 | 4294967291  |
| x6 |25  | 25  |
| x7 |266  |266   |

---

### Program 2 (test bench name `tb2.v`)

```
addi x1, x0, 10
addi x2, x0, 5
add  x3, x1, x2
sub  x4, x3, x2
lw   x5, 0(x3)
add  x6, x5, x1
sw   x6, 0(x2)
```

| Register | Expected Value | Observed Value |
|----------|--------------|----------------|
| x1 |10  | 10  |
| x2 | 5 |  5 |
| x3 |15  | 15  |
| x4 | 10 |10   |
| x5 | 100 | 100  |
| x6 |110  |  110 |
| x7 | 0 |  0 |

---

### Program 3: Fibonacci (test bench name `tb3.v`)

```
addi x1, x0, 0
addi x2, x0, 1
addi x3, x0, 10

loop:
add  x4, x1, x2
add  x1, x2, x0
add  x2, x4, x0
addi x3, x3, -1
bne  x3, x0, loop
```

| Register | Expected Value | Observed Value |
|----------|--------------|--------------|
| x1 |55  | 55 |
| x2 |89  |89  |
| x3 |0  | 0 |
| x4 |89  | 89 |

---

## Task 4: Add Pipeline Registers

### IF/ID
- Instruction
- PC

### ID/EX
- PC
- rs1_val, rs2_val
- Immediate
- Destination register
- Control signals:
  - ALUOp
  - ALUSrc
  - MemRead
  - MemWrite
  - RegWrite
  - MemToReg

### EX/MEM
- ALU result
- Store data
- Destination register
- Control signals:
  - MemRead
  - MemWrite
  - RegWrite
  - MemToReg

### MEM/WB
- Memory data
- ALU result
- Destination register
- Control signals:
  - RegWrite
  - MemToReg
  

### Deliverables
- Top-level module named `cpu_pip.dut`

---

## Task 5: Run Programs on Pipelined version
Use the same test benches that you wrote above. Only run with the new cpu module.  
Note the expected and actual outcomes and comment on them.
  
## Task 5: Run Programs on Pipelined CPU

Use the same test benches from Task 3, but execute them on the pipelined CPU (`cpu_pip`).  
Compare the observed outputs with the expected outputs from the single-cycle CPU.

---

### Observations

The programs were executed on the pipelined CPU.  
The observed register values differ from the expected values obtained from the single-cycle CPU.  
This indicates incorrect execution in the pipelined design.

---

### Program 1

| Register | Expected Value | Observed Value |
|----------|--------------|----------------|
| x1 | 10 | 10 |
| x2 | 20 | 20 |
| x3 | 246 | 1 ❌ |
| x4 | 5 | 5 |
| x5 | -5 | 4294967286 ❌ |
| x6 | 25 | 25 |
| x7 | 266 | 275 ❌ |

---

### Program 2

| Register | Expected Value | Observed Value |
|----------|--------------|----------------|
| x1 | 10 | 10 |
| x2 | 5 | 5 |
| x3 | 15 | 15 |
| x4 | 10 | 10 |
| x5 | 100 | 0 ❌ |
| x6 | 110 | 10 ❌ |
| x7 | 0 | 0 |

---

### Program 3: Fibonacci

| Register | Expected Value | Observed Value |
|----------|--------------|----------------|
| x1 | 55 | incorrect ❌ |
| x2 | 89 | incorrect ❌ |
| x3 | 0 | incorrect ❌ |
| x4 | 89 | incorrect ❌ |

---

### Analysis

The incorrect outputs occur due to **data hazards and control hazards** in the pipelined processor.  
Dependent instructions read register values before they are written back, leading to incorrect results.  
Additionally, branch instructions are not handled properly, causing further errors.

---

### Conclusion

Since no hazard detection, forwarding, or stalling mechanisms are implemented, the pipelined CPU produces incorrect outputs.

---

## Task 6: Fix the pipelined CPU
Modify the **assembly programs only without changing the hardware** to fix the issues you observe above.

Program 1:
```
addi x1, x0, 10
addi x2, x0, 20
addi x4, x0, 5

xori x3, x1, 0xFF
nop
nop
addi x3, x3, 1

sub x5, x4, x1
nop
nop

add x6, x2, x4

add x7, x3, x2
nop
nop
```

Program 2:
```
addi x1, x0, 10
addi x2, x0, 5

add x3, x1, x2
nop
nop

sub x4, x3, x2
nop
nop

lw x5, 0(x3)
nop
nop

add x6, x5, x1
nop
nop

sw x6, 0(x2)
```

Program 3:
```
addi x1, x0, 0
addi x2, x0, 1
addi x3, x0, 10

loop:
add x4, x1, x2
nop
nop

add x1, x2, x0
nop
nop

add x2, x4, x0
nop
nop

addi x3, x3, -1
nop

bne x3, x0, loop
nop
nop
```

### Outputs

# CS F342 – Computer Architecture Lab 8

## Objective

In this lab, you will implement the control circuit and the microcoded ROM for the multicycle bus-based RISC-V CPU design that we discussed in the class.

---
## Task 1

You are provided with the Verilog implementation for the datapath shown below. The details of the CPU design can be found [here](https://github.com/gsaurabhr-teaching/csf342-material/blob/main/RISC-V%20microcode.pdf).

![alt text](image.png)

Write a behavioral control module to work with this datapath (`mult_ctrl.v` with module name `mult_ctrl`). You can follow the discussion from class for implementing the control:  
1. What are the inputs to the control module?
   ```
   uPC

   ```

2. What are the outputs of the control module? i.e. what control signals are generated?
   ```
   IRLd, RegWr, RegEn, ALd, BLd, ALUEn, MALd, MemWr, MemEn, ImmEn,RegSel, ALUOp, ImmSel

   ```

3. Implement the control as a ROM. In task 3, you will fill the ROM with different microinstructions to execute different instructions.

## Task 2

Write a microsequencer that will enable the execution of the microinstructions (`mult_seq.v` with module name `mult_seq`).

1. What does the microsequencer do?
   ```
   The sequencer determines the next uPC. It handles sequential execution, instruction dispatching (jumping to the right microcode start point), and branching.If at the end of Fetch (uPC == 2), jump to a dispatch table based on opcode. Otherwise, increment uPC.

   ```

2. What are the inputs to the microsequencer?
   ```
   opcode, funct3, funct7, zero, clk, rst

   ```

3. Depending on the inputs, the microsequencer will determine the next $\mu PC$. Write the behavioral module accordingly.

## Task 3

Write the microcode for:  
1. Instruction fetch
2. `add` execution
3. `addi` execution
4. `sub` execution
5. `xori` execution
6. `lw` execution
7. `sw` execution
8. `bne` execution

This microcode should be written to the ROM you designed in `Task 1`.

## Task 4

Connect all the above components (datapath components that are given to you already, the control ROM and the microsequencer) to build the final CPU (`mult_cpu.v` with module `mult_cpu`).

## Task 5

Testing your multi-cycle CPU.

Use the same programs that you wrote and assembled in the previous lab (program 1, 2 and 3). Create three test benches like in the previous lab. In each test bench, load the respective machine code into the memory and then start the CPU. Verify the output (i.e. register and memory values) at the end of the programs.

