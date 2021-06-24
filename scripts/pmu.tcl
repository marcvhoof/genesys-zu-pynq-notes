
set project_name [lindex $argv 0]

set proc_name [lindex $argv 1]

set hard_path tmp/$project_name.hard
set pmu_path tmp/$project_name.pmu

file mkdir $pmu_path
hsi open_hw_design $hard_path/$project_name.xsa

hsi generate_app -hw [hsi current_hw_design] -app zynqmp_pmufw -proc psu_pmu_0 -dir $pmu_path -compile
hsi close_hw_design [hsi current_hw_design]
