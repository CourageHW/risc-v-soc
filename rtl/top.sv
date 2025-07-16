`timescale 1ns / 1ps

import core_pkg::*;

module top (
  input logic clk,
  input logic rst_n
);


  riscv_core #(
    .DATA_WIDTH(DATA_WIDTH),
    .INST_MEM_ADDR_WIDTH(INST_MEM_ADDR_WIDTH),
    .DATA_MEM_ADDR_WIDTH(DATA_MEM_ADDR_WIDTH)
  ) u_riscv_core (
    .i_clk(clk),
    .i_rst_n(rst_n),

    // instruction memory ports
    .i_rdata_inst(),
    .o_addr_inst(),

    // data memory ports
    .i_rdata_mem(),
    .o_wrdata_mem(),
    .o_addr_mem(),
    .o_we_mem()
  );

  ram #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(DATA_MEM_ADDR_WIDTH)
  ) u_data_memory (
    .i_clk(clk),
    .i_we(),
    .i_addr(),
    .i_wrdata(),
    .o_rdata()
  );

  rom #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(INST_MEM_ADDR_WIDTH)
  ) u_instruction_memory (
    .i_clk(clk),
    .i_addr(),
    .o_rdata()
  );

endmodule
