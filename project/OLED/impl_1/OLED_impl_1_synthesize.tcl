if {[catch {

# define run engine funtion
source [file join {D:/shixi/install/lattice} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "D:/shixi/project/FPGA/ICE40/Demo/project/OLED"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- OLED_impl_1.vm OLED_impl_1.ldc
run_engine_newmsg synthesis -f "OLED_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o OLED_impl_1_syn.udb OLED_impl_1.vm] "D:/shixi/project/FPGA/ICE40/Demo/project/OLED/impl_1/OLED_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
