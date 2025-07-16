`timescale 1ns / 1ps

module program_counter #(
  parameter DATA_WIDTH = 32
) (
  input  logic clk,
  input  logic rst_n,
  input  logic pc_we,
  input  logic [DATA_WIDTH-1:0] pc_i,
  output logic [DATA_WIDTH-1:0] pc_o
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc_o <= '0;
    end else if (pc_we) begin
      pc_o <= pc_i;
    end
  end
endmodule
