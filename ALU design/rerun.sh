#!/bin/bash 

iverilog execution.v tb_execution_unit.v -o simulation_execution_unit 
mv simulation_execution_unit sim/.
./sim/simulation_execution_unit
