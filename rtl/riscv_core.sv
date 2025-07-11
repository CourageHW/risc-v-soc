`timescale 1ns / 1ps

module riscv_core #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 12
) (
  input logic i_clk,
  input logic i_rst_n,

  // instruction memory ports
  input  logic [DATA_WIDTH-1:0] i_rdata_inst,
  output logic [ADDR_WIDTH-1:0] o_addr_inst,

  // data memory ports
  input  logic [DATA_WIDTH-1:0] i_rdata_mem,
  output logic [DATA_WIDTH-1:0] o_wrdata_mem,
  output logic [ADDR_WIDTH-1:0] o_addr_mem,
  output logic                  o_we_mem
);


  // ==============================================
  // 5 stage pipeline (IF -> ID -> EX -> MEM -> WB)
  // ==============================================
  
  // [1] Instruction Fetch Stage
  IF_stage u_if_stage (

  );

  IF2ID_reg u_if2id_reg (

  );

  // [2] Instruction Decode Stage
  ID_stage u_id_stage (

  );

  ID2EX_reg u_id2ex_reg (

  );

endmodule
