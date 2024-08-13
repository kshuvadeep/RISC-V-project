#!/bin/bash 

iverilog Soc.v soc_tb.sv -o soc_sim 
rm -rf sim/soc_sim
mv soc_sim sim/.
./sim/soc_sim
