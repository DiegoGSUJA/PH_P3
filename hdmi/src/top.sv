module top(
    input clk,
    input rst_n,

    output [2:0] tmds_data_p, tmds_data_n,
    output tmds_clk_p, tmds_clk_n
);

logic h_sync, v_sync, de;
logic [7:0] r,g,b;
logic [11:0] x,y;

logic ser_clk, pixel_clk;

localparam [11:0]H = 50;
localparam [11:0]W = 50;

logic [11:0]f_x,f_y;

assign f_x = 200;
assign f_y = 200;

ser_gen u_pull(
    .clkout(ser_clk), //output clkout
    .clkin(clk) //input clkin
);

pixel_gen d_pull(
    .clkout(pixel_clk), //output clkout
    .hclkin(ser_clk), //input hclkin
    .resetn(rst_n) //input resetn
);



sync_gen sync_gen_inst (
    .clk(pixel_clk),
    .rst_n(rst_n),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .de(de),
    .x(x),
    .y(y)
);

always_comb begin
    if (de) begin
        if (x >= f_x && x <= f_x+W && y >= f_y && y <= f_y+H) begin
            r = 8'hFF; // Rojo
            g = 8'h00;
            b = 8'h00;
        end else begin
            r = 8'h20; // Fondo gris oscuro
            g = 8'h20;
            b = 8'h20;
        end
    end else begin
        r = 8'h00;
        g = 8'h00;
        b = 8'h00;
    end
end

DVI_TX_Top hdmi(
		.I_rst_n(rst_n), //input I_rst_n
		.I_serial_clk(ser_clk), //input I_serial_clk
		.I_rgb_clk(pixel_clk), //input I_rgb_clk
		.I_rgb_vs(v_sync), //input I_rgb_vs
		.I_rgb_hs(h_sync), //input I_rgb_hs
		.I_rgb_de(de), //input I_rgb_de
		.I_rgb_r(r), //input [7:0] I_rgb_r
		.I_rgb_g(g), //input [7:0] I_rgb_g
		.I_rgb_b(b), //input [7:0] I_rgb_b
		.O_tmds_clk_p(tmds_clk_p),
        .O_tmds_clk_n(tmds_clk_n),
        .O_tmds_data_p(tmds_data_p),
        .O_tmds_data_n(tmds_data_n)
);

endmodule