`timescale 1ns / 1ps

module riscv_core #(
  parameter DATA_WIDTH = 32,
  parameter INST_MEM_ADDR_WIDTH = 12,
  parameter DATA_MEM_ADDR_WIDTH = 12
) (
  input logic i_clk,
  input logic i_rst_n,

  // instruction memory ports [2] (IF2)
  input  logic [DATA_WIDTH-1:0] i_rdata_inst,
  output logic [ADDR_WIDTH-1:0] o_addr_inst,

  // data memory ports [5] (MEM)
  input  logic [DATA_WIDTH-1:0] i_rdata_mem,
  output logic [DATA_WIDTH-1:0] o_wrdata_mem,
  output logic [ADDR_WIDTH-1:0] o_addr_mem,
  output logic                  o_we_mem
);


  // ===============================================
  // pipeline (IF1 ->  IF2 -> ID -> EX -> MEM -> WB)
  // ===============================================
  

  logic [DATA_WIDTH-1:0] IF1_pc_w;
  
  // [1] Instruction Fetch Stage (IF1)
  IF_stage #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_if_stage (
    .clk(i_clk),
    .rst_n(i_rst_n),
    .pc_we(1'b1),
    .pc_o(IF1_pc_w)
  );

  assign o_addr_inst = IF1_pc_w[INST_MEM_ADDR_WIDTH-1:2];

  IF2ID_reg u_if2id_reg (

  );

  // [3] Instruction Decode Stage
  ID_stage u_id_stage (

  );

  ID2EX_reg u_id2ex_reg (

  );

  // [4] Execute Stage
  

  // [6] Writer Back Stage

endmodule
