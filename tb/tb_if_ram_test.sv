`timescale 1ns / 1ps

module tb_if_ram_test;

  localparam DATA_WIDTH = 32;
  localparam CLK_PERIOD = 10; // 10 ns

  logic clk;
  logic rst_n;
  logic [DATA_WIDTH-1:0] o_rdata_inst;

  top uut (
    .clk(clk),
    .rst_n(rst_n),
    .o_rdata_inst(o_rdata_inst)
  );

  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  initial begin
    initialize_ports();
    reset_perform();

    repeat(100) @(posedge clk);
    $finish;
  end
  
  task initialize_ports;
    rst_n = 1;
  endtask

  task reset_perform;
    @(posedge clk);
    rst_n = 0;
    repeat(2) @(posedge clk);
    rst_n = 1;
    @(posedge clk);
  endtask


endmodule
