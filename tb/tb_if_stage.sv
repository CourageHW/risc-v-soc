`timescale 1ns / 1ps

module tb_if_stage;

  localparam CLK_PERIOD = 10;
  localparam DATA_WIDTH = 32;

  logic clk;
  logic rst_n;
  logic pc_we;
  logic [DATA_WIDTH-1:0] pc_o;

  if_stage #(
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .pc_we(pc_we),
    .pc_o(pc_o)
  );

  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  initial begin
    initialize_ports();
    reset_perform();
  
    test_pc();

    repeat(10)@(posedge clk);
    $finish;
  end

  task initialize_ports;
    rst_n = 1;
    pc_we = 0;
  endtask

  task reset_perform;
    @(posedge clk);
    rst_n = 0;
    repeat(2) @(posedge clk);
    rst_n = 1;
    @(posedge clk);
  endtask

  task test_pc;
    @(posedge clk);
    pc_we = 1;

    for (int i = 0; i < 10; i++) begin
      assert(pc_o == i*4) else $error("PC Mismatch.");
      @(posedge clk);
      $display("[SUCCESS] Index 0x%h", 4*i);
    end
    @(posedge clk);
  endtask

endmodule
