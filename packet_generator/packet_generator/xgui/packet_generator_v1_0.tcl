# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  set AXIS_WIDTH [ipgui::add_param $IPINST -name "AXIS_WIDTH"]
  set_property tooltip {Axis Width (values different from 64 require changes in the fifo width)} ${AXIS_WIDTH}

}

proc update_PARAM_VALUE.AXIS_WIDTH { PARAM_VALUE.AXIS_WIDTH } {
	# Procedure called to update AXIS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS_WIDTH { PARAM_VALUE.AXIS_WIDTH } {
	# Procedure called to validate AXIS_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH { PARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_Lite_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH { PARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_Lite_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_Lite_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_Lite_ADDR_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH PARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_Lite_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH PARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_Lite_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.AXIS_WIDTH { MODELPARAM_VALUE.AXIS_WIDTH PARAM_VALUE.AXIS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS_WIDTH}] ${MODELPARAM_VALUE.AXIS_WIDTH}
}

