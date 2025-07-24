`timescale 1ns / 1ps

import core_pkg::*;

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
  

  // program counter
  logic [DATA_WIDTH-1:0] IF1_pc_w;
  logic [DATA_WIDTH-1:0] IF2_pc_w;
  logic [DATA_WIDTH-1:0] ID_pc_w;
  logic [DATA_WIDTH-1:0] EX_pc_w;

  // program counter + 4
  logic [DATA_WIDTH-1:0] IF1_pc_plus4_w;
  logic [DATA_WIDTH-1:0] IF2_pc_plus4_w; 
  logic [DATA_WIDTH-1:0] ID_pc_plus4_w;
  logic [DATA_WIDTH-1:0] EX_pc_plus4_w;

  // instruction from instruction memory
  logic [DATA_WIDTH-1:0] IF2_instruction_w;
  logic [DATA_WIDTH-1:0] ID_instruction_w;
  logic [DATA_WIDTH-1:0] EX_instruction_w;

  // read data from register file
  logic [DATA_WIDTH-1:0] ID_rd_data1_w, ID_rd_data2_w;
  logic [DATA_WIDTH-1:0] EX_rd_data1_w, EX_rd_data2_w;

  // immediate
  logic [DATA_WIDTH-1:0] ID_immediate_w;
  logic [DATA_WIDTH-1:0] EX_immediate_w;

  // ALUSrc from main control unit
  logic ID_ALUSrcA_w, ID_ALUSrcB_w;
  logic EX_ALUSrcA_w, EX_ALUSrcB_w;

  // Branch and Jump signals from main control unit
  logic ID_Branch_w, ID_Jump_w;
  logic EX_Branch_w, EX_Jump_w;

  // Memory Wrtie and Read Signals from main control unit to Data Memory
  logic ID_MemWrite_w, ID_MemRead_w;
  logic EX_MemWrite_w, EX_MemRead_w;
  
  // Register Wrtie signal from main control unit to register file
  logic ID_RegWrite_w;
  logic EX_RegWrite_w;

  // Write Back Select signal from main control unit
  wb_sel_e ID_WBSel_w;
  wb_sel_e EX_WBSel_w;

  
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

  // instruction memory read address
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
    .clk(clk),
    .instruction_i(ID_instruction_w),
    .wr_addr_i('0),
    .wr_data_i('0),
    .wr_en_i(0),
    .rd_data1_o(ID_rd_data1_w),
    .rd_data2_o(ID_rd_data2_w),
    .immediate_o(ID_immediate_w),
    .ALUSrcA_o(ID_ALUSrcA_w),
    .ALUSrcB_o(ID_ALUSrcB_w),
    .Branch_o(ID_Branch_w),
    .Jump_o(ID_Jump_w),
    .MemWrite_o(ID_MemWrite_w),
    .MemRead_o(ID_MemRead_w),
    .RegWrite_o(ID_RegWrite_w),
    .WBSel_o(ID_WBSel_w)
  );

  id2ex_reg #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_id2ex_inst (
    .clk(clk),
    .rst_n(rst_n),
    .pc_i(ID_pc_w),
    .pc_plus4_i(ID_pc_plus4_w),
    .instruction_i(ID_instruction_w),
    .rd_data1_i(ID_rd_data1_w),
    .rd_data2_i(ID_rd_data2_w),
    .immediate_i(ID_immediate_w),
    .ALUSrcA_i(ID_ALUSrcA_w),
    .ALUSrcB_i(ID_ALUSrcB_w),
    .Branch_i(ID_Branch_w),
    .Jump_i(ID_Jump_w),
    .MemWrite_i(ID_MemWrite_w),
    .MemRead_i(ID_MemRead_w),
    .RegWrite_i(ID_RegWrite_w),
    .WBSel_i(ID_WBSel_w),

    .pc_o(EX_pc_w),
    .pc_plus4_o(EX_pc_plus4_w),
    .instruction_o(EX_instruction_w),
    .rd_data1_o(EX_rd_data1_w),
    .rd_data2_o(EX_rd_data2_w),
    .immediate_o(EX_immediate_w),
    .ALUSrcA_o(EX_ALUSrcA_w),
    .ALUSrcB_o(EX_ALUSrcB_w),
    .Branch_o(EX_Branch_w),
    .Jump_o(EX_Jump_w),
    .MemWrite_o(EX_MemWrite_w),
    .MemRead_o(EX_MemRead_w),
    .RegWrite_o(EX_RegWrite_w),
    .WBSel_o(EX_WBSel_w)
  );

  ex_stage #(

  ) u_ex_inst (

  );
endmodule
