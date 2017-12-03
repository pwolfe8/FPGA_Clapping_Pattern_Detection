# Modelsim Testing Instructions


## General process
1) Perform any testbench modifications if listed
2) Compile listed files modelsim with **VHDL 2008** settings 
3) Double click the testbench to start simulation:
    - add all signals to waveform
    - change radix to hex
    - run -a
    - view "Wave" window (view .main_pane.wave)
    - hit "f" to zooom to fit all
4) Verify that no test cases fail and the waveform looks like the expected result

# Clap State Machine

## Shift Register
* behavior: shifts in data, able to be flushed (zeroed)
* files:
    - typePack.vhd
    - src/ClapStateMachine/shift_register.vhd
    - tb/ClapStateMachine/tb_shift_register.vhd
* expected result:
    - progression of data_out should be:
        - {00,00,00,00}
        - {DE,00,00,00}
        - {DE,DE,00,00}
        - {AD,DE,DE,00}
        - {AD,AD,DE,DE}
        - {00,00,00,00}

![](tb_shift_register.png) 

## Clap Finite State Machine
* behavior: logs intervals between claps to shift register, flushes when new pattern starts
* testbench modifications:
    - before testing clap_FSM.vhd, modify the R_clk_ctr to be 8 for simulation.
    (comment line 41 & uncomment line 42)
    - after adding all signals also add "clk_counter" from the DUT submodule object
* files:
    - typePack.vhd
    - src/ClapStateMachine/shift_register.vhd
    - src/ClapStateMachine/clap_FSM.vhd
    - tb/ClapStateMachine/tb_clap_FSM.vhd
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
    - ending value clk_counter should stop after "hitting max" 0x20

![](tb_clap_FSM.png)
![](tb_clap_FSM_end.png)


# Checking the Pattern

## min_compare2
* behavior: finds the minimum of 2 intervals that's not zero
* files:
    - typePack.vhd
    - src/CheckPattern/min_compare2.vhd
    - tb/CheckPattern/tb_min_compare2.vhd
* expected result:
    - out_min_val_2 should progress:
        - 00, 04, 08, 07

![](tb_min_compare2.png)

 ## min_not_zero
* behavior: finds the minimum of 2 intervals that's not zero
* files:
    - typePack.vhd
    - src/CheckPattern/min_compare2.vhd
    - src/CheckPattern/min_not_zero.vhd
    - tb/CheckPattern/min_not_zero.vhd
* expected result:
    - smallest should progress:
        - 00, 04, 01, 00, 14

![](tb_min_not_zero.png)

## divider
* behavior: divides 2 numbers and signals when done
* files:
    - typePack.vhd
    - src/CheckPattern/divider.vhd
    - tb/CheckPattern/tb_divider.vhd
* expected result:
    - result should progress:
        - 00, 18, 00, 08, 00, 10, 00, 2A

![](tb_divider.png)

## div_by_min
* behavior: Normalizes an interval bank by dividing by minimum interval
* files:
    - typePack.vhd
    - src/CheckPattern/divider.vhd
    - src/CheckPattern/div_by_min.vhd
    - tb/CheckPattern/tb_div_by_min.vhd
* expected result:
    - bank_out should progress:
        - {00,00,00,00}
        - {00,00,20,00}
        - {00,18,20,00}
        - {10,18,20,00}
        - {00,00,00,00}
        - {00,10,00,00}
        - {46,10,00,00}

![](tb_div_by_min.png)

## boundary_comp
* behavior: compares recorded pattern with a stored pattern to check for a match
* files:
    - typePack.vhd
    - src/CheckPattern/boundary_comp.vhd
    - tb/CheckPattern/tb_boundary_comp.vhd
* expected result:
    - match should progress:
        - 0, 1, 0, 1

![](tb_boundary_comp.png) 

## pattern_compare
* behavior: compares recorded pattern to all stored patterns & reports which one matches
* files:
    - typePack.vhd
    - src/CheckPattern/boundary_comp.vhd
    - tb/CheckPattern/tb_boundary_comp.vhd
* expected result:
    - patterns_matched should end on 2 & check_pattern_done should go high after that for 1 clock cycle

![](tb_pattern_compare.png) 

## CheckPattern
* behavior: Top level pattern checking system
* files:
    - typePack.vhd
    - src/CheckPattern/
    - tb/CheckPattern/
* expected result:
    - match should progress:
        - 0, 1, 0, 1

![](tb_boundary_comp.png) 

# Testing Clap Detector

## Clap Detector Python
* files:
    - run Python_high_level_testing/clap_detection/clap.py
* dependencies:
    - scipy
    - matplotlib
* expected result
    - graph of clap with red overlayed and clap timestamps printed

# Basys3 Tests
