# -----------------------------------------------------------------------------
# Recreates the Vivado project from the sources in src/.
#
# Usage (from the repository root):
#   vivado -mode batch -source scripts/create_project.tcl
#
# The project is generated in build/ (ignored by git), so the repository only
# tracks hand-written sources, never Vivado-generated files.
# -----------------------------------------------------------------------------

set proj_name  simon_fpga
set part       xc7a100tcsg324-1        ;# Digilent Nexys A7-100T
set root_dir   [file normalize [file dirname [info script]]/..]
set build_dir  $root_dir/build

create_project $proj_name $build_dir -part $part -force
set_property target_language VHDL [current_project]

# Package first, then every other VHDL source
add_files -norecurse $root_dir/src/pkg/simon_pkg.vhd
add_files [glob $root_dir/src/{game,display,clocking,memory,uart}/*.vhd]

# Constraints (pin assignments) — added automatically once present
set xdc_files [glob -nocomplain $root_dir/constraints/*.xdc]
if {[llength $xdc_files] > 0} {
    add_files -fileset constrs_1 $xdc_files
}

set_property top fsm_simon [current_fileset]
update_compile_order -fileset sources_1

puts "Project created in $build_dir"
