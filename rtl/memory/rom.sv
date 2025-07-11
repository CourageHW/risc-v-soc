`timescale 1ns / 1ps

module rom #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 12
) (
  input  logic                  i_clk,
  input  logic [ADDR_WIDTH-1:0] i_addr,
  output logic [DATA_WIDTH-1:0] o_rdata
);

  localparam MEM_DEPTH = 1 << ADDR_WIDTH;

  logic [DATA_WIDTH-1:0] mem [0:MEM_MEPTH-1];

  initial begin
    $readmemh("program.mem", mem);
  end

  // always block for read
  always_ff @(posedge i_clk) begin
    o_rdata <= mem[i_addr];
  end

endmodule
