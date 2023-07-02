set display_name {AXI4-Stream Multiport Double Channel Adder}

set core [ipx::current_core]

set_property DISPLAY_NAME $display_name $core
set_property DESCRIPTION $display_name $core

core_parameter AXIS_TDATA_PORT_WIDTH {AXIS TDATA PORT WIDTH} {Width of the M_AXIS and S_AXIS adder data buses.}
core_parameter AXIS_TDATA_ACC_WIDTH {AXIS TDATA PORT WIDTH OF INPUT AND OUTPUT} {Width of the M_AXIS and S_AXIS accumulator data buses.}
core_parameter AXIS_TDATA_SIGNED {AXIS TDATA SIGNED} {If TRUE, the M_AXIS and S_AXIS data are signed values.}

set bus [ipx::get_bus_interfaces -of_objects $core m_axis]
set_property NAME M_AXIS $bus
set_property INTERFACE_MODE master $bus

set bus [ipx::get_bus_interfaces -of_objects $core s_axis_0]
set_property NAME S_AXIS_0 $bus
set_property INTERFACE_MODE slave $bus

set bus [ipx::get_bus_interfaces -of_objects $core s_axis_1]
set_property NAME S_AXIS_1 $bus
set_property INTERFACE_MODE slave $bus

set bus [ipx::get_bus_interfaces -of_objects $core s_axis_2]
set_property NAME S_AXIS_2 $bus
set_property INTERFACE_MODE slave $bus

set bus [ipx::get_bus_interfaces -of_objects $core s_axis_accin]
set_property NAME S_AXIS_accin $bus
set_property INTERFACE_MODE slave $bus

set bus [ipx::get_bus_interfaces aclk]
set parameter [ipx::get_bus_parameters -of_objects $bus ASSOCIATED_BUSIF]
set_property VALUE M_AXIS:S_AXIS_0:S_AXIS_1:S_AXIS_2:S_AXIS_ACCIN $parameter
