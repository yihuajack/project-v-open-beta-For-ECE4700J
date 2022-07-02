# start_gui
cd ../baseline

set outputdir ./VivadoProject
file mkdir $outputdir

set files [glob -nocomplain "$outputdir/*"]
if {[llength $files] != 0} {
    puts "deleting contents of $outputdir"
    file delete -force {*}[glob -directory $outputdir *]; 
} else {
    puts "$outputdir is empty"
}

# Create your project
create_project pipeline $outputdir -part xcvu35p-fsvh2892-3-e
# set obj [current_project]
# set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
add_files -norecurse  {verilog/if_stage.sv verilog/id_stage.sv verilog/ex_stage.sv verilog/mem_stage.sv verilog/wb_stage.sv verilog/pipeline.sv verilog/regfile.sv program.mem }

update_compile_order -fileset sources_1
update_compile_order -fileset sources_1

add_files -norecurse  {ISA.svh sys_defs.svh}
# set file [file normalize sys_defs.svh]
# read_verilog -sv {sys_defs.svh}
# add_files -norecurse $file
set_property is_global_include true [get_files {ISA.svh sys_defs.svh}]
# set_property is_global_include true [get_files  {F:/Documents/GitHub/ECE4700J_SU2022/Lab4/project-v-open-beta-For-ECE4700J/baseline/sys_defs.svh F:/Documents/GitHub/ECE4700J_SU2022/Lab4/project-v-open-beta-For-ECE4700J/baseline/ISA.svh}]
update_compile_order -fileset sources_1
update_compile_order -fileset sources_1




update_compile_order -fileset sources_1
set_property SOURCE_SET sources_1 [get_filesets sim_1]


add_files -fileset sim_1 -norecurse -scan_for_includes testbench/riscv_inst.h testbench/pipe_print.c
add_files -fileset sim_1 -norecurse -scan_for_includes testbench/mem.sv testbench/testbench.sv

update_compile_order -fileset sim_1

set_property top pipeline [current_fileset]
update_compile_order -fileset sources_1

set_property top testbench [get_filesets sim_1]

update_compile_order -fileset sim_1

set_property is_global_include true [get_files {ISA.svh sys_defs.svh}]
update_compile_order -fileset sources_1


# launch RTL analysis & synthesis
launch_runs synth_1 -jobs 8
wait_on_run synth_1


update_compile_order -fileset sources_1
set_property -name {xsim.simulate.runtime} -value {10000000ns} -objects [get_filesets sim_1]

launch_simulation

close_project


exit
