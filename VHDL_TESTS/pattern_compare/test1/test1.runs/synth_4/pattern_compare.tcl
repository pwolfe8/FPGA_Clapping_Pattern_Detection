# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xcku035-ffva1156-3-e

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/will/DSP/FPGA_Clapping_Pattern_Detection/VHDL_TESTS/pattern_compare/test1/test1.cache/wt [current_project]
set_property parent.project_path /home/will/DSP/FPGA_Clapping_Pattern_Detection/VHDL_TESTS/pattern_compare/test1/test1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /home/will/DSP/FPGA_Clapping_Pattern_Detection/VHDL_TESTS/pattern_compare/test1/test1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /home/will/DSP/FPGA_Clapping_Pattern_Detection/VHDL_TESTS/pattern_compare/typePack.vhd
  /home/will/DSP/FPGA_Clapping_Pattern_Detection/VHDL_TESTS/pattern_compare/boundary_comp.vhd
  /home/will/DSP/FPGA_Clapping_Pattern_Detection/VHDL_TESTS/pattern_compare/pattern_compare.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/will/DSP/FPGA_Clapping_Pattern_Detection/VHDL/Basys3_connections.xdc
set_property used_in_implementation false [get_files /home/will/DSP/FPGA_Clapping_Pattern_Detection/VHDL/Basys3_connections.xdc]


synth_design -top pattern_compare -part xcku035-ffva1156-3-e


write_checkpoint -force -noxdef pattern_compare.dcp

catch { report_utilization -file pattern_compare_utilization_synth.rpt -pb pattern_compare_utilization_synth.pb }
