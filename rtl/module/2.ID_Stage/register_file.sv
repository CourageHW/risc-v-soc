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

  localparam NUM_REGS = 1 << REG_MEM_ADDR_WIDTH;

  logic [DATA_WIDTH-1:0] registers [0:NUM_REGS-1];

  // read
  always_comb begin
    if (wr_en_i && wr_addr_i != '0 && wr_addr_i == rd_addr1_i) begin
      rd_data1_o = wr_data_i;
    end else begin
      rd_data1_o = (rd_addr1_i == '0) ? '0 : registers[rd_addr1_i];
    end

    if (wr_en_i && wr_addr_i != '0 && wr_addr_i == rd_addr2_i) begin
      rd_data2_o = wr_data_i;
    end else begin
      rd_data2_o = (rd_addr2_i == '0) ? '0 : registers[rd_addr2_i];
    end
  end

  // write
  always_ff @(posedge clk) begin
    if (wr_en_i && wr_addr_i != '0) begin
      registers[wr_addr_i] <= wr_data_i;
    end
  end
endmodule
