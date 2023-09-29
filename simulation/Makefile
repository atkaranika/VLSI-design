# Makefile for ModelSim simulation

# Set your workspace directory
export WORKSPACE := /home/eng/a/axk230133/Documents/Fall2023/VLSI/Assigments/Project_1_axk220238_axk230133/Project_1_axk220238_axk230133/
export MODELSIM_EXE := vsim 
export MENTOR_PROFILE := /proj/cad/startup/profile.mentor_2021
export VERILOG_FILE_NAMES := ../rtl/matrix_add_sub.v ../rtl/matrix_alu.v ../rtl/matrix_kronecker.v ../rtl/matrix_mul.v 
export TOP_MODULE := matrix_alu_tb
export TB_FILE_NAME := ../testbench/matrix_alu_tb.v
export SIMULATION_TCL_SCRIPT := /home/eng/a/axk230133/Documents/Fall2023/VLSI/Assigments/Project_1_axk220238_axk230133/Project_1_axk220238_axk230133/simulation/sim_script.tcl

all: setup simulation 

setup:
	cd $(WORKSPACE)

simulation:
	# Run ModelSim with the temporary TCL script
	source $(MENTOR_PROFILE); \
	 $(MODELSIM_EXE) -do $(SIMULATION_TCL_SCRIPT)

clean:
	rm -rf work transcript *.wlf

.PHONY: all setup simulation clean