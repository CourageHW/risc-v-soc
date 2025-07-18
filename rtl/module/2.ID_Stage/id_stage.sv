`timescale 1ns / 1ps

module id_stage #(
  parameter DATA_WIDTH = 32,
  parameter REG_MEM_ADDR_WIDTH = 5
) (
  input logic clk,
  input logic rst_n,

  input logic [DATA_WIDTH-1:0] pc_i,
  input logic [DATA_WIDTH-1:0] pc_plus4_i,
  input logic [DATA_WIDTH-1:0] instruction_i

);


  register_file #(
    
  ) u_reg_file_inst (

  );
endmodule
