`timescale 1ns / 1ps

import core_pkg::*;

module top (
  input logic clk,
  input logic rst_n,

  output logic [DATA_WIDTH-1:0] o_rdata_inst // debug
);

  logic [DATA_WIDTH-1:0] w_rdata_inst;
  logic [DATA_WIDTH-1:0] w_rdata_mem;
  logic [DATA_WIDTH-1:0] w_wrdata_mem;
  logic w_we_mem;

  logic [INST_MEM_ADDR_WIDTH-1:0] w_addr_inst;
  logic [DATA_MEM_ADDR_WIDTH-1:0] w_addr_mem;

  assign o_rdata_inst = w_rdata_inst;

  riscv_core #(
    .DATA_WIDTH(DATA_WIDTH),
    .REG_MEM_ADDR_WIDTH(REG_MEM_ADDR_WIDTH),
    .INST_MEM_ADDR_WIDTH(INST_MEM_ADDR_WIDTH),
    .DATA_MEM_ADDR_WIDTH(DATA_MEM_ADDR_WIDTH)
  ) u_riscv_core (
    .i_clk(clk),
    .i_rst_n(rst_n),

    // instruction memory ports
    .i_rdata_inst(w_rdata_inst),
    .o_addr_inst(w_addr_inst),

    // data memory ports
    .i_rdata_mem(w_rdata_mem),
    .o_wrdata_mem(w_wrdata_mem),
    .o_addr_mem(w_addr_mem),
    .o_we_mem(w_we_mem)
  );

  ram #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(DATA_MEM_ADDR_WIDTH)
  ) u_data_memory (
    .i_clk(clk),
    .i_we(w_we_mem),
    .i_addr(w_addr_mem),
    .i_wrdata(w_wrdata_mem),
    .o_rdata(w_rdata_mem)
  );

  rom #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(INST_MEM_ADDR_WIDTH)
  ) u_instruction_memory (
    .i_clk(clk),
    .i_addr(w_addr_inst),
    .o_rdata(w_rdata_inst)
  );

endmodule
