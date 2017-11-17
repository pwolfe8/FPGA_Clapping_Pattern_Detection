# Module Testing Instructions

## General process
1) Compile listed files modelsim with **VHDL 2008** settings
    - be sure to match the "R\_int" and "n\_int" constants in typePack.vhd with the testbench before compiling
2) Double click tb_shift_register to start simulation:
    - add all signals to waveform
    - change radix to hex
    - run -a
    - view "Wave" and hit "f" to view all
3) Verify that no test cases fail and the waveform looks like this the expected result


## Shift Register
* files:
    - typePack.vhd
    - src/shift_register.vhd
    - tb/tb_shift_register.vhd
* expected result:
    - ![](tb_shift_register.png) 

## State Machine
* files:
    - typePack.vhd
    - src/clap_FSM.vhd
    - tb/tb_clap_FSM.vhd
* expected results:
    - tested 3 claps with intervals of 14, and then 17 clock cycles shifted into the "bank_array" shift register
    - "DUT/state" progression should be:
        - IDLE
        - WAIT_FOR_NEXT_CLAP
        - LOG_INTERVAL
        - WAIT_FOR_NEXT_CLAP
        - LOG_INTERVAL
        - WAIT_FOR_NEXT_CLAP
        - CHECKING_PATTERN
        - IDLE
    - "bank_array" progression should be:
        - {00,00,00,00}
        - {14,00,00,00}
        - {17,14,00,00}
        - {00,00,00,00}
    - overall picture:
        - ![](tb_clap_FSM.png)
    - ending picture:
        - ![](tb_clap_FSM_end.png)

