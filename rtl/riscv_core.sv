`timescale 1ns / 1ps

module riscv_core #(
  parameter DATA_WIDTH = 32,
  parameter REG_MEM_ADDR_WIDTH = 5,
  parameter INST_MEM_ADDR_WIDTH = 12,
  parameter DATA_MEM_ADDR_WIDTH = 12
) (
  input logic i_clk,
  input logic i_rst_n,

  // instruction memory ports [2] (IF2)
  input  logic [DATA_WIDTH-1:0]          i_rdata_inst,
  output logic [INST_MEM_ADDR_WIDTH-1:0] o_addr_inst,

  // data memory ports [5] (MEM)
  input  logic [DATA_WIDTH-1:0]          i_rdata_mem,
  output logic [DATA_WIDTH-1:0]          o_wrdata_mem,
  output logic [DATA_MEM_ADDR_WIDTH-1:0] o_addr_mem,
  output logic                           o_we_mem
);


  // ===============================================
  // pipeline (IF1 ->  IF2 -> ID -> EX -> MEM -> WB)
  // ===============================================
  

  logic [DATA_WIDTH-1:0] IF1_pc_w, IF2_pc_w, ID_pc_w;
  logic [DATA_WIDTH-1:0] IF1_pc_plus4_w, IF2_pc_plus4_w, 
                         ID_pc_plus4_w;
  logic [DATA_WIDTH-1:0] IF2_instruction_w, ID_instruction_w;
  
  // [1] Instruction Fetch Stage (IF1)
  if_stage #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_if_stage (
    .clk(i_clk),
    .rst_n(i_rst_n),
    .pc_we(1'b1),
    .pc_o(IF1_pc_w),
    .pc_plus4_o(IF1_pc_plus4_w)
  );

  assign o_addr_inst = IF1_pc_w[INST_MEM_ADDR_WIDTH-1:2];

  // [2] Instruction Fetch Stage (IF2)
  // for instruction memory delay
  if_stage2 #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_if_stage2 (
    .clk(i_clk),
    .rst_n(i_rst_n),
    .pc_i(IF1_pc_w),
    .pc_plus4_i(IF1_pc_plus4_w),
    .pc_o(IF2_pc_w),
    .pc_plus4_o(IF2_pc_plus4_w)
  );

  if2id_reg #(
    .DATA_WIDTH(DATA_WIDTH)
  ) if2id_inst (
    .clk(i_clk),
    .rst_n(i_rst_n),
    .pc_i(IF2_pc_w),
    .pc_plus4_i(IF2_pc_plus4_w),
    .instruction_i(IF2_instruction_w),
    .pc_o(ID_pc_w),
    .pc_plus4_o(ID_pc_plus4_w),
    .instruction_o(ID_instruction_w)
  );

  id_stage #(
    .DATA_WIDTH(DATA_WIDTH),
    .REG_MEM_ADDR_WIDTH(REG_MEM_ADDR_WIDTH)
  ) u_id_inst (
    .pc_i(ID_pc_w),
    .pc_plus4_i(ID_pc_plus4_w),
    .instruction_i(ID_instruction_w)
  );
endmodule
