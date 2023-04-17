exec cmd.exe /c "vlib work"
exec cmd.exe /c "vlog ripple_carry_adder_tb.v > ripple_carry_adder_tb.log"
exec {*}[auto_execok start] vmap -c


exec {*}[auto_execok start] vsim work.ripple_carry_adder_tb -do "add wave -position insertpoint  \
    sim:/ripple_carry_adder_tb/U_ripple_carry_adder/A \
    sim:/ripple_carry_adder_tb/U_ripple_carry_adder/B \
    sim:/ripple_carry_adder_tb/U_ripple_carry_adder/Cin \
    sim:/ripple_carry_adder_tb/U_ripple_carry_adder/S \
    sim:/ripple_carry_adder_tb/U_ripple_carry_adder/CF \
    sim:/ripple_carry_adder_tb/U_ripple_carry_adder/OF; \
    radix signal sim:/ripple_carry_adder_tb/U_ripple_carry_adder/A Signed; \
    radix signal sim:/ripple_carry_adder_tb/U_ripple_carry_adder/B Signed; \
    radix signal sim:/ripple_carry_adder_tb/U_ripple_carry_adder/S Signed; \
    run -all"


exec cmd.exe /c "del transcript > nul 2>&1"
exec cmd.exe /c "del modelsim.ini > nul 2>&1"
exec cmd.exe /c "del vsim.wlf > nul 2>&1"
exec cmd.exe /c "del vsim_stacktrace.vstf > nul 2>&1"
exec cmd.exe /c "del wlft3ghn8c > nul 2>&1"
exec cmd.exe /c "del *.vstf > nul 2>&1"
exec cmd.exe /c "rmdir /s /q work > nul 2>&1"