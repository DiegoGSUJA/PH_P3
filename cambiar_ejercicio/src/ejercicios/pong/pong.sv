module pong (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       on,

    output logic [2:0] tmds_data_p,
    output logic [2:0] tmds_data_n,
    output logic       tmds_clk_p,
    output logic       tmds_clk_n
);

    // =========================================================================
    // Declaración de Señales Internas
    // =========================================================================
    logic        h_sync;
    logic        v_sync;
    logic        de;
    logic [7:0]  r, g, b;
    logic [11:0] x, y;
    
    logic        ser_clk;   
    logic        pixel_clk;

    // =========================================================================
    // 1. Generación de Relojes
    // =========================================================================
    
    ser_gen clk_serial (
        .clkin  (clk),
        .clkout (ser_clk)
    );

    pixel_gen clk_pixel (
        .hclkin (ser_clk),
        .resetn (rst_n),
        .clkout (pixel_clk)
    );

    // =========================================================================
    // 2. Controladores y Lógica de Video
    // =========================================================================
    
    // Generador de tiempos de video (VGA/HDMI Timings)
    sync_gen sync_gen_inst (
        .clk    (pixel_clk),
        .rst_n  (rst_n),
        .h_sync (h_sync),
        .v_sync (v_sync),
        .de     (de),
        .x      (x),
        .y      (y)
    );

    // Generador de la imagen/escena
    escena escena_inst (
        .clk    (pixel_clk),
        .rst_n  (rst_n && on),
        .de     (de),
        .x      (x),
        .y      (y),
        .r      (r),
        .g      (g),
        .b      (b)
    );

    // =========================================================================
    // 3. Capa Física (Transmisor TMDS/DVI/HDMI)
    // =========================================================================
    
    DVI_TX_Top hdmi_tx (
        .I_rst_n       (rst_n && on),
        .I_serial_clk  (ser_clk),
        .I_rgb_clk     (pixel_clk),
        .I_rgb_vs      (v_sync),
        .I_rgb_hs      (h_sync),
        .I_rgb_de      (de),
        .I_rgb_r       (r),
        .I_rgb_g       (g),
        .I_rgb_b       (b),
        .O_tmds_clk_p  (tmds_clk_p),
        .O_tmds_clk_n  (tmds_clk_n),
        .O_tmds_data_p (tmds_data_p),
        .O_tmds_data_n (tmds_data_n)
    );

endmodule