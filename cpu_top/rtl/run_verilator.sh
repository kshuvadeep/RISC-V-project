
verilator -Wall --cc --trace Soc.v  --Wno-fatal --top-module   Soc --exe testbench.cpp
