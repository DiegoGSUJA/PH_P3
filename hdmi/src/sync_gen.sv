module sync_gen (
    input  logic clk,       // 74.25 MHz para 720p @ 60Hz
    input  logic rst_n,
    output logic h_sync,
    output logic v_sync,
    output logic de,        // Data Enable
    output logic [11:0] x,  // Coordenada X (0 a 1279)
    output logic [11:0] y   // Coordenada Y (0 a 719)
);

    // Parámetros estándar CEA-861 para 1280x720p @ 60Hz
    localparam H_ACTIVE = 1280;
    localparam H_FRONT  = 110;
    localparam H_SYNC   = 40;
    localparam H_BACK   = 220;
    localparam H_TOTAL  = 1650;

    localparam V_ACTIVE = 720;
    localparam V_FRONT  = 5;
    localparam V_SYNC   = 5;
    localparam V_BACK   = 20;
    localparam V_TOTAL  = 750;

    logic [11:0] h_cnt, v_cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            h_cnt <= 0;
            v_cnt <= 0;
        end else begin
            if (h_cnt == H_TOTAL - 1) begin
                h_cnt <= 0;
                if (v_cnt == V_TOTAL - 1)
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 12'd1; // <--- ¡Corregido! (antes: + 1)
            end else begin
                h_cnt <= h_cnt + 12'd1;     // <--- ¡Corregido! (antes: + 1)
            end
        end
    end

    // Polaridad positiva para 720p
    assign h_sync = (h_cnt >= (H_ACTIVE + H_FRONT) && h_cnt < (H_ACTIVE + H_FRONT + H_SYNC));
    assign v_sync = (v_cnt >= (V_ACTIVE + V_FRONT) && v_cnt < (V_ACTIVE + V_FRONT + V_SYNC));
    
    assign de = (h_cnt < H_ACTIVE) && (v_cnt < V_ACTIVE);
    assign x  = (de) ? h_cnt : 12'd0;
    assign y  = (de) ? v_cnt : 12'd0;

endmodule