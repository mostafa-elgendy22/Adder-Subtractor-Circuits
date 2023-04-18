# create a list
set modules [list "Ripple carry adder" "Carry lookahead adder" "Carry Select Adder"]
set length [llength $modules]

# for loop to run the simulation for different values of the parameter
for {set i 0} {$i < $length} {incr i} {

    exec cmd.exe /c "vlib work"
    exec cmd.exe /c "vlog generic_testbench.v > generic_testbench.log"
    exec {*}[auto_execok start] vmap -c


    # Run the simulation
    exec {*}[auto_execok start] vsim -c work.generic_testbench -do "run -all; quit -f"

    
    set module [lindex $modules $i]
    puts $module

    set output [exec python evaluate.py]
    puts $output
    puts ""

    # Clean the directory from temporary files
    exec python clean.py

    set next_module [expr ($i + 1) % $length]

    # Change the adder module
    exec python change_adder_module.py $i $next_module
}
