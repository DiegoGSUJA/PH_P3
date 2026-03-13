module gw_gao(
    \counter[26] ,
    \counter[25] ,
    \counter[24] ,
    \counter[23] ,
    \counter[22] ,
    \counter[21] ,
    \counter[20] ,
    \counter[19] ,
    \counter[18] ,
    \counter[17] ,
    \counter[16] ,
    \counter[15] ,
    \counter[14] ,
    \counter[13] ,
    \counter[12] ,
    \counter[11] ,
    \counter[10] ,
    \counter[9] ,
    \counter[8] ,
    \counter[7] ,
    \counter[6] ,
    \counter[5] ,
    \counter[4] ,
    \counter[3] ,
    \counter[2] ,
    \counter[1] ,
    \counter[0] ,
    clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \counter[26] ;
input \counter[25] ;
input \counter[24] ;
input \counter[23] ;
input \counter[22] ;
input \counter[21] ;
input \counter[20] ;
input \counter[19] ;
input \counter[18] ;
input \counter[17] ;
input \counter[16] ;
input \counter[15] ;
input \counter[14] ;
input \counter[13] ;
input \counter[12] ;
input \counter[11] ;
input \counter[10] ;
input \counter[9] ;
input \counter[8] ;
input \counter[7] ;
input \counter[6] ;
input \counter[5] ;
input \counter[4] ;
input \counter[3] ;
input \counter[2] ;
input \counter[1] ;
input \counter[0] ;
input clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \counter[26] ;
wire \counter[25] ;
wire \counter[24] ;
wire \counter[23] ;
wire \counter[22] ;
wire \counter[21] ;
wire \counter[20] ;
wire \counter[19] ;
wire \counter[18] ;
wire \counter[17] ;
wire \counter[16] ;
wire \counter[15] ;
wire \counter[14] ;
wire \counter[13] ;
wire \counter[12] ;
wire \counter[11] ;
wire \counter[10] ;
wire \counter[9] ;
wire \counter[8] ;
wire \counter[7] ;
wire \counter[6] ;
wire \counter[5] ;
wire \counter[4] ;
wire \counter[3] ;
wire \counter[2] ;
wire \counter[1] ;
wire \counter[0] ;
wire clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({\counter[26] ,\counter[25] ,\counter[24] ,\counter[23] ,\counter[22] ,\counter[21] ,\counter[20] ,\counter[19] ,\counter[18] ,\counter[17] ,\counter[16] ,\counter[15] ,\counter[14] ,\counter[13] ,\counter[12] ,\counter[11] ,\counter[10] ,\counter[9] ,\counter[8] ,\counter[7] ,\counter[6] ,\counter[5] ,\counter[4] ,\counter[3] ,\counter[2] ,\counter[1] ,\counter[0] }),
    .clk_i(clk)
);

endmodule
