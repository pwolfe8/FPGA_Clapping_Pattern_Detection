
�
�No debug cores found in the current design.
Before running the implement_debug_core command, either use the Set Up Debug wizard (GUI mode)
or use the create_debug_core and connect_debug_core Tcl commands to insert debug cores into the design.
154*	chipscopeZ16-241h px� 
Q
Command: %s
53*	vivadotcl2 
place_design2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2"
xc7a35t-cpg2362default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2"
xc7a35t-cpg2362default:defaultZ17-349h px� 
y
Command: %s
53*	vivadotcl2H
4report_drc (run_mandatory_drcs) for: incr_eco_checks2default:defaultZ4-113h px� 
P
Running DRC with %s threads
24*drc2
42default:defaultZ23-27h px� 
q
%s completed successfully
29*	vivadotcl23
report_drc (run_mandatory_drcs)2default:defaultZ4-42h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
place_design2default:defaultZ4-22h px� 
w
Command: %s
53*	vivadotcl2F
2report_drc (run_mandatory_drcs) for: placer_checks2default:defaultZ4-113h px� 
P
Running DRC with %s threads
24*drc2
42default:defaultZ23-27h px� 
q
%s completed successfully
29*	vivadotcl23
report_drc (run_mandatory_drcs)2default:defaultZ4-42h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
U

Starting %s Task
103*constraints2
Placer2default:defaultZ18-103h px� 
}
BMultithreading enabled for place_design using a maximum of %s CPUs12*	placeflow2
42default:defaultZ30-611h px� 
v

Phase %s%s
101*constraints2
1 2default:default2)
Placer Initialization2default:defaultZ18-101h px� 
�

Phase %s%s
101*constraints2
1.1 2default:default29
%Placer Initialization Netlist Sorting2default:defaultZ18-101h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
1967.4962default:default2
0.0002default:default2
79772default:default2
114082default:defaultZ17-722h px� 
Z
EPhase 1.1 Placer Initialization Netlist Sorting | Checksum: cfcc7660
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.01 ; elapsed = 00:00:00.02 . Memory (MB): peak = 1967.496 ; gain = 0.000 ; free physical = 7977 ; free virtual = 114082default:defaulth px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
1967.4962default:default2
0.0002default:default2
79792default:default2
114102default:defaultZ17-722h px� 
�

Phase %s%s
101*constraints2
1.2 2default:default2F
2IO Placement/ Clock Placement/ Build Placer Device2default:defaultZ18-101h px� 
�
�IO Placement failed due to overutilization. This design contains %s I/O ports
 while the target %s, contains only %s available user I/O. The target device has %s usable I/O pins of which %s are already occupied by user-locked I/Os.
 To rectify this issue:
 1. Ensure you are targeting the correct device and package.  Select a larger device or different package if necessary.
 2. Check the top-level ports of the design to ensure the correct number of ports are specified.
 3. Consider design changes to reduce the number of I/Os necessary.
415*place2
2952default:default22
 device: 7a35t package: cpg2362default:default2
1052default:default2
1062default:default2
12default:defaultZ30-415h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
�
Instance %s (%s) is not placed
68*place22
check_pattern_done_OBUF_inst2default:default2
OBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place2(
clk_IBUF_BUFG_inst2default:default2
BUFG2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][0]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][0]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][0]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][0]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][1]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][1]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][1]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][1]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][2]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][2]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][2]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][2]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][3]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][3]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][3]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][3]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][4]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][4]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][4]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][4]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][5]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][5]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][5]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][5]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][6]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][6]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][6]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][6]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][7]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][7]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][7]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,0][7]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][0]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][0]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][0]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][0]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][1]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][1]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][1]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][1]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][2]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][2]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][2]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][2]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][3]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][3]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][3]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][3]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][4]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][4]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][4]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][4]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][5]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][5]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][5]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][5]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][6]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][6]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][6]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][6]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][7]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][7]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][7]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[0,1][7]_i_82default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][0]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][0]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][0]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][0]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][1]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][1]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][1]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][1]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][2]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][2]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][2]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][2]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][3]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][3]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][3]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][3]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][4]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][4]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][4]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][4]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][5]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][5]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][5]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][5]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][6]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][6]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][6]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][6]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][7]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][7]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][7]_i_42default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,0][7]_i_52default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,1][0]_i_22default:default2
IBUF2default:default8Z30-68h px� 
�
Instance %s (%s) is not placed
68*place25
current_pattern_reg[1,1][0]_i_32default:default2
IBUF2default:default8Z30-68h px� 
�
�Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2
Place 30-682default:default2
1002default:defaultZ17-14h px� 
g
RPhase 1.2 IO Placement/ Clock Placement/ Build Placer Device | Checksum: cd6e2dde
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:02 ; elapsed = 00:00:01 . Memory (MB): peak = 1967.496 ; gain = 0.000 ; free physical = 7979 ; free virtual = 114102default:defaulth px� 
H
3Phase 1 Placer Initialization | Checksum: cd6e2dde
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:02 ; elapsed = 00:00:01 . Memory (MB): peak = 1967.496 ; gain = 0.000 ; free physical = 7979 ; free virtual = 114102default:defaulth px� 
�
�Placer failed with error: '%s'
Please review all ERROR and WARNING messages during placement to understand the cause for failure.
1*	placeflow2*
IO Clock Placer failed2default:defaultZ30-99h px� 
=
(Ending Placer Task | Checksum: cd6e2dde
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:02 ; elapsed = 00:00:01 . Memory (MB): peak = 1967.496 ; gain = 0.000 ; free physical = 7980 ; free virtual = 114102default:defaulth px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
372default:default2
342default:default2
342default:default2
1032default:defaultZ4-41h px� 
N

%s failed
30*	vivadotcl2 
place_design2default:defaultZ4-43h px� 
m
Command failed: %s
69*common28
$Placer could not place all instances2default:defaultZ17-69h px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Sun Nov 26 22:12:59 20172default:defaultZ17-206h px� 


End Record