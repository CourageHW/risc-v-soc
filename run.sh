#!/bin/zsh
iverilog -o sim.out -g2012 ./rtl/memory/ram.sv ./tb/tb_ram.sv &&
time vvp sim.out || exit 1
gtkwave dump.vcd

rm -rf dump.vcd sim.out
