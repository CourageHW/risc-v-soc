`timescale 1ns / 1ps

module register_file #(
  parameter DATA_WIDTH = 32,
  parameter REG_MEM_ADDR_WIDTH = 5
) (
  input logic clk,

  // read
  input logic [REG_MEM_ADDR_WIDTH-1:0] rd_addr1_i,
  input logic [REG_MEM_ADDR_WIDTH-1:0] rd_addr2_i,

  // write
  input logic [REG_MEM_ADDR_WIDTH-1:0] wr_addr_i,
  input logic [DATA_WIDTH-1:0]         wr_data_i,
  input logic                          wr_en_i,

  // read
  output logic [DATA_WIDTH-1:0] rd_data1_o,
  output logic [DATA_WIDTH-1:0] rd_data2_o
);

endmodule
