set VERILOG_FILE_NAMES $::env(VERILOG_FILE_NAMES)
set TOP_MODULE $::env(TOP_MODULE)
set TB_FILE_NAME $::env(TB_FILE_NAME)
set SYNTHESIZED_NETLIST_OUTPUT $::env(SYNTHESIZED_NETLIST_OUTPUT)
set REPORT_CELLS_LOG $::env(REPORT_CELLS_LOG)
set LIBRARY_SEARCH_PATH $::env(LIBRARY_SEARCH_PATH)
set LIBRARY_NAME $::env(LIBRARY_NAME)

set search_path [list /home/eng/a/axk230133/cad/synopsys]
set link_library library.db
set target_library library.db
set  symbol_library library.sdb

# Read the Verilog file 
analyze -format verilog $VERILOG_FILE_NAMES

elaborate $TOP_MODULE
# Compile the design with specific options
compile -exact_map -ungroup_all -auto_ungroup area -only_design_rule

redirect -file $REPORT_CELLS_LOG report_cell

write -hierarchy -format verilog -output $SYNTHESIZED_NETLIST_OUTPUT

gui_start
#exit