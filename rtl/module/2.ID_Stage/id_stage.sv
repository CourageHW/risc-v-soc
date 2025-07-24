`timescale 1ns / 1ps

import core_pkg::*;

module id_stage #(
  parameter DATA_WIDTH = 32,
  parameter REG_MEM_ADDR_WIDTH = 5
) (
  input logic clk,

  input logic [DATA_WIDTH-1:0] instruction_i,
  
  // register file
  input logic [REG_MEM_ADDR_WIDTH-1:0] wr_addr_i,
  input logic [DATA_WIDTH-1:0] wr_data_i,
  input logic                  wr_en_i,

  output logic [DATA_WIDTH-1:0] rd_data1_o,
  output logic [DATA_WIDTH-1:0] rd_data2_o,

  // immediate generator
  output logic [DATA_WIDTH-1:0] immediate_o,

  // main control unit
  output logic ALUSrcA_o,
  output logic ALUSrcB_o,
  output logic Branch_o,
  output logic Jump_o,
  output logic MemWrite_o,
  output logic MemRead_o,
  output logic RegWrite_o,
  output wb_sel_e WBSel_o
);

  imm_sel_e ImmSel_w; 

  register_file #(
    .DATA_WIDTH(DATA_WIDTH),
    .REG_MEM_ADDR_WIDTH(REG_MEM_ADDR_WIDTH)
  ) u_reg_file_inst (
    .clk(clk),
    .rd_addr1_i(instruction_i[19:15]),
    .rd_addr2_i(instruction_i[24:20]),
    .wr_addr_i(wr_addr_i),
    .wr_data_i(wr_data_i),
    .wr_en_i(wr_en_i),
    .rd_data1_o(rd_data1_o),
    .rd_data2_o(rd_data2_o)
  );

  immediate_generator #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_imm_gen_inst (
    .instruction_i(instruction_i),
    .ImmSel_i(ImmSel_w),
    .immediate_o(immediate_o)
  );

  main_control_unit main_ctrl_unit_inst (
    .opcode_i(instruction_i[6:0]),
    .funct3_i(instruction_i[14:12]),
    .ImmSel_o(ImmSel_w),
    .ALUSrcA_o(ALUSrcA_o),
    .ALUSrcB_o(ALUSrcB_o),
    .Branch_o(Branch_o),
    .Jump_o(Jump_o),
    .MemWrite_o(MemWrite_o),
    .MemRead_o(MemRead_o),
    .RegWrite_o(RegWrite_o),
    .WBSel_o(WBSel_o)
  );
endmodule
