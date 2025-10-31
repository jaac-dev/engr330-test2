set TOP [lindex $argv 0]
set PART xc7a35tcsg324-1
set SRC_DIR ./src
set OUT_NAME [lindex $argv 1]
set OUT_DIR ./reports/$OUT_NAME
file mkdir $OUT_DIR

set_param general.maxThreads [expr {[get_param general.maxThreads]}]

foreach f [lsort [glob -nocomplain -types f -directory $SRC_DIR *.{v,sv,vhd,vhdl}]] {
  read_verilog -sv $f
}

synth_design -top $TOP -part $PART -flatten_hierarchy rebuilt
report_utilization -file $OUT_DIR/${OUT_NAME}_util.txt

create_clock -name virt -period 100.000
set_max_delay -from [get_ports {a[*] b[*] c_in}] \
              -to   [get_ports {y[*] c_out}] \
              100.000 -datapath_only
report_timing -file $OUT_DIR/${OUT_NAME}_timing.txt -max_paths 10