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