# TCL script for ModelSim simulation
set VERILOG_FILE_NAMES $::env(VERILOG_FILE_NAMES)
set TOP_MODULE $::env(TOP_MODULE)
set TB_FILE_NAME $::env(TB_FILE_NAME)


# Create a new simulation project
vlib work
vmap work work

# Compile the Verilog and testbench files
foreach file $VERILOG_FILE_NAMES {
    vlog -sv $file
}

vlog -sv $TB_FILE_NAME

# Elaborate the design
vsim $TOP_MODULE

# Simulate for 500 nanoseconds (or adjust as needed)
wave add *
run 500ns

# Save the simulation results in VCD format (uncomment and modify as needed)
# write -format vcd simulation_results.vcd

# Exit ModelSim
quit -f
