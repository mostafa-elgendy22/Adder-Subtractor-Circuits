exec cmd.exe /c "vlib work"
exec cmd.exe /c "vlog carry_select_adder_tb.v > carry_select_adder_tb.log"
exec {*}[auto_execok start] vmap -c


exec {*}[auto_execok start] vsim work.carry_select_adder_tb -do "add wave -position insertpoint  \
    sim:/carry_select_adder_tb/U_carry_select_adder/A \
    sim:/carry_select_adder_tb/U_carry_select_adder/B \
    sim:/carry_select_adder_tb/U_carry_select_adder/Cin \
    sim:/carry_select_adder_tb/U_carry_select_adder/S \
    sim:/carry_select_adder_tb/U_carry_select_adder/CF \
    sim:/carry_select_adder_tb/U_carry_select_adder/OF; \
    radix signal sim:/carry_select_adder_tb/U_carry_select_adder/A Signed; \
    radix signal sim:/carry_select_adder_tb/U_carry_select_adder/B Signed; \
    radix signal sim:/carry_select_adder_tb/U_carry_select_adder/S Signed; \
    run -all"


exec cmd.exe /c "del transcript > nul 2>&1"
exec cmd.exe /c "del modelsim.ini > nul 2>&1"
exec cmd.exe /c "del vsim.wlf > nul 2>&1"
exec cmd.exe /c "del vsim_stacktrace.vstf > nul 2>&1"
exec cmd.exe /c "del wlft3ghn8c > nul 2>&1"
exec cmd.exe /c "del *.vstf > nul 2>&1"
exec cmd.exe /c "rmdir /s /q work > nul 2>&1"