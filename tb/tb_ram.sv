`timescale 1ns / 1ps

module tb_ram;

  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 12;
  parameter CLK_PERIOD = 10;

  logic clk;
  logic we;
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wrdata;
  logic [DATA_WIDTH-1:0] rdata;

  ram #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) uut (
    .i_clk(clk),
    .i_we(we),
    .i_addr(addr),
    .i_wrdata(wrdata),
    .o_rdata(rdata)
  );
  
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_ram);
  end

  initial begin
    initialize_port();

    @(posedge clk);

    write_full();

    @(posedge clk);

    write_read_full();

    @(posedge clk);

    read_full();

    @(posedge clk);

    $display("[SUCCESS] RAM Test");
    $finish();
  end

  task initialize_port;
    we = 0;
    addr = 0;
    wrdata = 0;
  endtask

  task write_full;
    we = 1;

    @(posedge clk);
    #1;

    for (int i = 0; i < (1 << ADDR_WIDTH); i++) begin
      addr = i;
      wrdata = i*2;
      @(posedge clk);
      #1;
    end

    we = 0;
    @(posedge clk);

    $display("[SUCCESS] Write Full");
  endtask

  task write_read_full;
    we = 1;

    @(posedge clk);
    #1;

    for (int i = 0; i < (1 << ADDR_WIDTH); i++) begin
      addr = i;
      wrdata = i*3;
      @(posedge clk);
      #1;
      assert (rdata == i*2) else $error("rdata mismatch.");
    end

    we = 0;
    @(posedge clk);

    $display("[SUCCESS] Write and Read");
  endtask

  task read_full;
    @(posedge clk);
    #1;

    for (int i = 0; i < (1 << ADDR_WIDTH); i++) begin
      addr = i;
      @(posedge clk);
      #1;
      assert (rdata == i*3) else $error("rdata mismatch.");
    end

    @(posedge clk);

    $display("[SUCCESS] Read full");
  endtask
endmodule
