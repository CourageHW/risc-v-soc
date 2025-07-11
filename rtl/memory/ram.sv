`timescale 1ns / 1ps

module ram #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 12
) (
  input  logic                  i_clk,
  input  logic                  i_we,
  input  logic [ADDR_WIDTH-1:0] i_addr,
  input  logic [DATA_WIDTH-1:0] i_wrdata,
  output logic [DATA_WIDTH-1:0] o_rdata
);

  localparam MEM_DEPTH = 1 << ADDR_WIDTH;

  logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

  // always block for read
  always_ff @(posedge i_clk) begin
    o_rdata <= mem[i_addr];
  end

  // always block for write
  always_ff @(posedge i_clk) begin
    if (i_we) begin
      mem[i_addr] <= i_wrdata;
    end
  end
endmodule
