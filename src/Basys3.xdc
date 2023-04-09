set_property PACKAGE_PIN W5 [get_ports basys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports basys_clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports basys_clk]

set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports basys_reset]

<<<<<<< HEAD
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

=======
>>>>>>> d6aa4f82317a3e52c94469fb00714d214472ce07
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[0] }]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[1] }]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[2] }]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[3] }]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[4] }]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[5] }]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[6] }]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[7] }]
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[8] }]
set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[9] }]
set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[10] }]
set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[11] }]
set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[12] }]
set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports { mips_status_o[13] }]


#set_property -dict { PACKAGE_PIN T3   IOSTANDARD LVCMOS33 } [get_ports { operand1[0] }]
#set_property -dict { PACKAGE_PIN T2   IOSTANDARD LVCMOS33 } [get_ports { operand1[1] }]
#set_property -dict { PACKAGE_PIN R3   IOSTANDARD LVCMOS33 } [get_ports { operand1[2] }]
#set_property -dict { PACKAGE_PIN W2   IOSTANDARD LVCMOS33 } [get_ports { operand1[3] }]
#set_property -dict { PACKAGE_PIN U1   IOSTANDARD LVCMOS33 } [get_ports { operand1[4] }]
#set_property -dict { PACKAGE_PIN T1   IOSTANDARD LVCMOS33 } [get_ports { operand1[5] }]
#set_property -dict { PACKAGE_PIN L3   IOSTANDARD LVCMOS33 } [get_ports { operand1[6] }]
#set_property -dict { PACKAGE_PIN M3   IOSTANDARD LVCMOS33 } [get_ports { operand1[7] }]

#set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports { operand2[0] }]
#set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { operand2[1] }]
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { operand2[2] }]
#set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { operand2[3] }]
#set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { operand2[4] }]
#set_property -dict { PACKAGE_PIN V2   IOSTANDARD LVCMOS33 } [get_ports { operand2[5] }]
#set_property -dict { PACKAGE_PIN L4   IOSTANDARD LVCMOS33 } [get_ports { operand2[6] }]
#set_property -dict { PACKAGE_PIN M4   IOSTANDARD LVCMOS33 } [get_ports { operand2[7] }]

#set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports { operation[0] }]
#set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports { operation[1] }]
#set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33 } [get_ports { operation[2] }]




