# Module Testing Instructions

## General process
1) Compile listed files modelsim with **VHDL 2008** settings
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
    ![](tb_shift_register.png) 


