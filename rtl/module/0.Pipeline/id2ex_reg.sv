`timescale 1ns / 1ps

import core_pkg::*;

module id2ex_reg #(
  parameter DATA_WIDTH = 32
) (
  input logic clk,
  input logic rst_n,

  // input
  input logic [DATA_WIDTH-1:0] pc_i,
  input logic [DATA_WIDTH-1:0] pc_plus4_i,
  input logic [DATA_WIDTH-1:0] instruction_i,
  input logic [DATA_WIDTH-1:0] rd_data1_i,
  input logic [DATA_WIDTH-1:0] rd_data2_i,
  input logic [DATA_WIDTH-1:0] immediate_i,

  input logic ALUSrcA_i,
  input logic ALUSrcB_i,
  input logic Branch_i,
  input logic Jump_i,
  input logic MemWrite_i,
  input logic MemRead_i,
  input logic RegWrite_i,
  input wb_sel_e WBSel_i,

  // output
  output logic [DATA_WIDTH-1:0] pc_o,
  output logic [DATA_WIDTH-1:0] pc_plus4_o,
  output logic [DATA_WIDTH-1:0] instruction_o,
  output logic [DATA_WIDTH-1:0] rd_data1_o,
  output logic [DATA_WIDTH-1:0] rd_data2_o,
  output logic [DATA_WIDTH-1:0] immediate_o,

  output logic ALUSrcA_o,
  output logic ALUSrcB_o,
  output logic Branch_o,
  output logic Jump_o,
  output logic MemWrite_o,
  output logic MemRead_o,
  output logic RegWrite_o,
  output wb_sel_e WBSel_o
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc_o          <= '0;
      pc_plus4_o    <= '0;
      instruction_o <= '0;
      rd_data1_o    <= '0;
      rd_data2_o    <= '0;
      immediate_o   <= '0;

      ALUSrcA_o     <= 0;
      ALUSrcB_o     <= 0;
      Branch_o      <= 0;
      Jump_o        <= 0;
      MemWrite_o    <= 0;
      MemRead_o     <= 0;
      RegWrite_o    <= 0;
      WBSel_o       <= WB_NONE;
    end else begin
      pc_o          <= pc_i;
      pc_plus4_o    <= pc_plus4_i;
      instruction_o <= instruction_i;
      rd_data1_o    <= rd_data1_i;
      rd_data2_o    <= rd_data2_i;
      immediate_o   <= immediate_i;
                      
      ALUSrcA_o     <= ALUSrcA_i;
      ALUSrcB_o     <= ALUSrcB_i;
      Branch_o      <= Branch_i;
      Jump_o        <= Jump_i;
      MemWrite_o    <= MemWrite_i;
      MemRead_o     <= MemRead_i;
      RegWrite_o    <= RegWrite_i;
      WBSel_o       <= WBSel_i;
    end
  end
endmodule
