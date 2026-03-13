create_clock -name sys_clk -period 37.037 [get_ports {clk}]

create_generated_clock -name pixel_clk -source [get_ports {clk}] -master_clock sys_clk -multiply_by 11 -divide_by 4 [get_pins {d_pull/clkdiv_inst/CLKOUT}]

# 3. False Paths (Ignorar chequeos de tiempo en señales asíncronas o pines físicos diferenciales)
set_false_path -from [get_ports {rst_n}]
set_false_path -to [get_ports {tmds_data_p[*]}]
set_false_path -to [get_ports {tmds_data_n[*]}]
set_false_path -to [get_ports {tmds_clk_p}]
set_false_path -to [get_ports {tmds_clk_n}]