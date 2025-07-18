`timescale 1ns / 1ps

module if_stage2 #(
  parameter DATA_WIDTH = 32
) (
  input logic clk,
  input logic rst_n,
  input logic [DATA_WIDTH-1:0] pc_i,
  input logic [DATA_WIDTH-1:0] pc_plus4_i,

  output logic [DATA_WIDTH-1:0] pc_o,
  output logic [DATA_WIDTH-1:0] pc_plus4_o
);

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    pc_o       <= '0;
    pc_plus4_o <= '0;
  end else begin
    pc_o       <= pc_i;
    pc_plus4_o <= pc_plus4_i;
  end
end

endmodule
