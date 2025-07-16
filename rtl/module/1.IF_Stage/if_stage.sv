`timescale 1ns / 1ps

module if_stage #(
  parameter DATA_WIDTH = 32
) (
  input logic clk,
  input logic rst_n,
  input logic pc_we,

  output logic [DATA_WIDTH-1:0] pc_o
);

  logic [DATA_WIDTH-1:0] pc_w;

  program_counter #(
    .DATA_WIDTH(DATA_WIDTH)
  ) pc_inst (
    .clk(clk),
    .rst_n(rst_n),
    .pc_we(pc_we),
    .pc_i(pc_w),
    .pc_o(pc_o)
  );

  assign pc_w = pc_o + 32'd4;
endmodule
