`timescale 1ns / 1ps

module tb_register_file;

  localparam CLK_PERIOD = 10;
  localparam DATA_WIDTH = 32;
  localparam REG_MEM_ADDR_WIDTH = 5;
  localparam NUM_REGS   = 1 << REG_MEM_ADDR_WIDTH;
  
  logic clk;
  logic [REG_MEM_ADDR_WIDTH-1:0] rd_addr1_i;
  logic [REG_MEM_ADDR_WIDTH-1:0] rd_addr2_i;

  logic [REG_MEM_ADDR_WIDTH-1:0] wr_addr_i;
  logic [DATA_WIDTH-1:0]         wr_data_i;
  logic                          wr_en_i;

  logic [DATA_WIDTH-1:0]         rd_data1_o;
  logic [DATA_WIDTH-1:0]         rd_data2_o;

  register_file #(
    .DATA_WIDTH(DATA_WIDTH),
    .REG_MEM_ADDR_WIDTH(REG_MEM_ADDR_WIDTH)
  ) reg_inst (
    .clk(clk),

    // read
    .rd_addr1_i(rd_addr1_i),
    .rd_addr2_i(rd_addr2_i),

    // write
    .wr_addr_i(wr_addr_i),
    .wr_data_i(wr_data_i),
    .wr_en_i(wr_en_i),

    // output
    .rd_data1_o(rd_data1_o),
    .rd_data2_o(rd_data2_o)
  );

  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  initial begin
    initialize_port();

    write_full();
    read_full();

    write_read_full();

    repeat(100) @(posedge clk);
    $display("[SUCCESS] Register File Test");
    $finish;
  end

  task initialize_port;
    rd_addr1_i = '0;
    rd_addr2_i = '0;
    wr_addr_i  = '0;
    wr_data_i  = '0;
    wr_en_i    = 1'b0;
  endtask

  task write_full;
    @(posedge clk);

    wr_en_i = 1'b1;

    @(posedge clk);

    for (int i = 0; i < NUM_REGS; i++) begin
      wr_addr_i = i;
      wr_data_i = i*2;
      @(posedge clk);
    end

    wr_en_i = 0;
    @(posedge clk);

    $display("[SUCCESS] write full");
  endtask

  task read_full;
    @(posedge clk);

    for (int i = 0; i < NUM_REGS; i++) begin
      rd_addr1_i = i;
      rd_addr2_i = NUM_REGS-1-i;
      #1;
      assert (rd_data1_o == i*2) else $error("[FAIL] read data 1 mismatch. expected: %d, Got: %d at %d", i*2, rd_data1_o, i);
      assert (rd_data2_o == (NUM_REGS-1-i) * 2) else $error("[FAIL] read data 2 mismatch. expected: %d, Got: %d at %d", (NUM_REGS-1-i) * 2, rd_data2_o, NUM_REGS-1-i);
      @(posedge clk);
    end

    @(posedge clk);

    $display("[SUCCESS] read full");
  endtask

  task write_read_full;
    @(posedge clk);

    wr_en_i = 1'b1;

    @(posedge clk);

    for (int i = 0; i < NUM_REGS; i++) begin
      wr_data_i = i*3;
      wr_addr_i = i;
      rd_addr1_i = i;
      #1;
      assert (rd_data1_o == wr_data_i) else $error("[FAIL] read_data 1 mismatch at read_write. expected: %d, Got: %d at %d", wr_data_i, rd_data1_o, i);
      @(posedge clk);
    end

    @(posedge clk);

    wr_en_i = 1'b0;

    @(posedge clk);

    $display("[SUCCESS] write and read");
  endtask
endmodule
