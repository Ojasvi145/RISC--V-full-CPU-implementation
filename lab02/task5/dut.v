`timescale 1ns/1ps

module dut (
  input wire clk,
  input reset,
  input [1:0] op,
  input dest,
  output wire [7:0] R0,
  output wire [7:0] R1
);

  // FSM States
  localparam RUN_WAIT = 2'b00;
  localparam RUN_RESULT_READY = 2'b01;
  localparam HALTED = 2'b10;

  reg [1:0] state, next_state;
  wire [7:0] alu_result;
  wire [7:0] r0_next, r1_next;
  reg r0_enable, r1_enable;

  // Instantiate 8-bit registers
  register8 reg0 (.clk(clk), .d(r0_next), .reset(reset), .enable(r0_enable), .q(R0));
  register8 reg1 (.clk(clk), .d(r1_next), .reset(reset), .enable(r1_enable), .q(R1));

  // 8-bit adder/subtractor
  // op[1] = 0: addition, op[1] = 1: subtraction
  adder8 alu (.a(R0), .b(R1), .cin(1'b0), .sum(alu_result), .cout());

  // Mux for subtraction (2's complement by inverting b and setting cin)
  wire [7:0] b_operand = (op[1] == 1) ? ~R1 : R1;
  adder8 alu_full (.a(R0), .b(b_operand), .cin(op[1]), .sum(alu_result), .cout());

  // Select which register gets written
  assign r0_next = (dest == 0) ? alu_result : R0;
  assign r1_next = (dest == 1) ? alu_result : R1;

  // FSM State Update (Sequential Logic)
  always @(posedge clk or negedge reset) begin
    if (!reset)
      state <= RUN_WAIT;
    else
      state <= next_state;
  end

  // FSM Next State and Register Enable Logic (Combinational)
  always @(*) begin
    next_state = state;
    r0_enable = 0;
    r1_enable = 0;

    case (state)
      RUN_WAIT: begin
        if (op == 2'b00) begin
          // No-op: stay in RUN_WAIT
          next_state = RUN_WAIT;
        end else if (op == 2'b01 || op == 2'b10) begin
          // Add or Subtract: move to RUN_RESULT_READY
          next_state = RUN_RESULT_READY;
        end else if (op == 2'b11) begin
          // Toggle halt/run: move to HALTED
          next_state = HALTED;
        end
      end

      RUN_RESULT_READY: begin
        // Write the result back to the selected register
        if (dest == 0)
          r0_enable = 1;
        else
          r1_enable = 1;
        
        // Return to RUN_WAIT
        next_state = RUN_WAIT;
      end

      HALTED: begin
        if (op == 2'b11) begin
          // Toggle halt/run: move back to RUN_WAIT
          next_state = RUN_WAIT;
        end else begin
          // Stay in HALTED
          next_state = HALTED;
        end
      end

      default: next_state = RUN_WAIT;
    endcase
  end

endmodule