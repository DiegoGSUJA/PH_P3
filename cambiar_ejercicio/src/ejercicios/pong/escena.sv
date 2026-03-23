module escena(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        de,     
    input  logic [11:0] x, y,   
    
    output logic [7:0]  r, g, b
);

    // =========================================================================
    // PARÁMETROS DE RESOLUCIÓN Y TIMING
    // =========================================================================
    localparam [11:0] MAX_X = 1280;
    localparam [11:0] MAX_Y = 720;
    localparam [23:0] FREQ_UPDATE = 1237500; 

    // =========================================================================
    // PARÁMETROS DEL JUEGO
    // =========================================================================
    localparam [11:0] PALA_H    = 120;
    localparam [11:0] PALA_W    = 15;
    localparam [11:0] VEL_PALA  = 4;

    localparam [11:0] BALL_S    = 25;
    localparam [12:0] BALL_VEL_INIT = 4;

    localparam [11:0] J1_X_POS  = 25;
    localparam [11:0] J2_X_POS  = MAX_X - PALA_W - 25;

    // =========================================================================
    // REGISTROS E INSTANCIAS DEL MARCADOR
    // =========================================================================
    logic [3:0] score1 = 4'd0;
    logic [3:0] score2 = 4'd0;

    logic [7:0] rom_data1, rom_data2;
    logic [2:0] rom_row;

    assign rom_row = (y - 12'd50) >> 3;

    marcador m1 (
        .valor(score1),
        .fila_y(rom_row),
        .data_x(rom_data1)
    );

    marcador m2 (
        .valor(score2),
        .fila_y(rom_row),
        .data_x(rom_data2)
    );
    // =========================================================================
    // PARÁMETROS DE COLORES (RGB 24-bit)
    // =========================================================================
    localparam [23:0] COLOR_BG    = 24'h101010; // Gris oscuro
    localparam [23:0] COLOR_BALL  = 24'hFF0000; // Rojo
    localparam [23:0] COLOR_PALA  = 24'hFFFFFF; // Blanco
    localparam [23:0] COLOR_RED   = 24'h303030; // Gris medio (línea central)
    localparam [23:0] COLOR_BLACK = 24'h000000; // Fuera de pantalla

    // =========================================================================
    // REGISTROS DE ESTADO DEL JUEGO
    // =========================================================================
    logic signed [12:0] j1_y;
    logic signed [12:0] j2_y;
    logic [11:0] pala_deadzone;
    
    logic signed [12:0] ball_x, ball_y;
    logic signed [12:0] ball_dx, ball_dy;

    logic [23:0] cnt;
    logic        update_tick;

    logic [7:0]  next_r, next_g, next_b;

    // =========================================================================
    // SHADOW REGISTERS — Solo para el renderizado (FIX píxeles azules)
    // =========================================================================
    // Se actualizan cada ciclo de clk, de forma que el bloque combinacional
    // de renderizado nunca lee un valor a mitad de transición.
    logic signed [12:0] r_ball_x, r_ball_y;
    logic signed [12:0] r_j1_y,   r_j2_y;
 
    always_ff @(posedge clk) begin
        r_ball_x <= ball_x;
        r_ball_y <= ball_y;
        r_j1_y   <= j1_y;
        r_j2_y   <= j2_y;
    end

    logic [15:0] lfsr;
 
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 16'd25;
        end else begin  
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[14] ^ lfsr[12] ^ lfsr[3]};
        end
    end

    function automatic [11:0] calc_deadzone(input [6:0] rnd);
        if (rnd > 7'd59)     calc_deadzone = 12'd69;
        else if (rnd < 7'd20) calc_deadzone = 12'd20;
        else                  calc_deadzone = {5'd0, rnd};
    endfunction

    // =========================================================================
    // GENERADOR DE TICK DE ACTUALIZACIÓN (60 FPS)
    // =========================================================================
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 24'd0;
            update_tick <= 1'b0;
        end else begin
            if (cnt >= FREQ_UPDATE - 1) begin
                cnt <= 24'd0;
                update_tick <= 1'b1;
            end else begin
                cnt <= cnt + 24'd1;
                update_tick <= 1'b0;
            end
        end
    end

    // =========================================================================
    // LÓGICA PRINCIPAL DEL JUEGO (MOVIMIENTO Y COLISIONES)
    // =========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset de posiciones y velocidades
            ball_x  <= (MAX_X / 2) - (BALL_S / 2);
            ball_y  <= (MAX_Y / 2) - (BALL_S / 2);
            ball_dx <= BALL_VEL_INIT;
            ball_dy <= BALL_VEL_INIT;
            pala_deadzone <= 80;

            j1_y    <= (MAX_Y / 2) - (PALA_H / 2);
            j2_y    <= (MAX_Y / 2) - (PALA_H / 2);
            
            score1  <= 4'd0;
            score2  <= 4'd0;
        end else if (score1 == 10 || score2 == 10) begin
            score1  <= 0;
            score2  <= 0;
        end else if (update_tick) begin
            // -----------------------------------------------------------------
            // IA Jugador 1 (Izquierda) - Solo se mueve si la bola va hacia él
            // -----------------------------------------------------------------
            if (ball_dx < 0) begin
                if (ball_y + (BALL_S/2) < j1_y + (PALA_H/2) - $signed(pala_deadzone)) begin
                    if (j1_y > 13'sd0) j1_y <= j1_y - $signed(VEL_PALA);
                end else if (ball_y + (BALL_S/2) > j1_y + (PALA_H/2) + $signed(pala_deadzone)) begin
                    if (j1_y < $signed(MAX_Y - PALA_H)) j1_y <= j1_y + $signed(VEL_PALA);
                end
            end

            // -----------------------------------------------------------------
            // IA Jugador 2 (Derecha) - Solo se mueve si la bola va hacia él
            // -----------------------------------------------------------------
            if (ball_dx > 0) begin
                if (ball_y + (BALL_S/2) < j2_y + (PALA_H/2) - $signed(pala_deadzone)) begin
                    if (j2_y > 13'sd0) j2_y <= j2_y - $signed(VEL_PALA);
                end else if (ball_y + (BALL_S/2) > j2_y + (PALA_H/2) + $signed(pala_deadzone)) begin
                    if (j2_y < $signed(MAX_Y - PALA_H)) j2_y <= j2_y + $signed(VEL_PALA);
                end
            end

            // -----------------------------------------------------------------
            // Movimiento de la bola: Eje Y (Rebotes en techo y suelo)
            // -----------------------------------------------------------------
            if (ball_y <= 0) begin
                ball_dy <= -ball_dy;
                ball_y  <= 1;
            end else if (ball_y >= (MAX_Y - BALL_S)) begin
                ball_dy <= -ball_dy;
                ball_y  <= MAX_Y - BALL_S - 1;
            end else begin
                ball_y  <= ball_y + ball_dy;
            end

            // -----------------------------------------------------------------
            // Movimiento de la bola: Eje X (Colisiones con palas y puntos)
            // -----------------------------------------------------------------
            // Colisión Pala 1
            if (ball_dx < 0 && ball_x <= (J1_X_POS + PALA_W) && 
                (ball_y + BALL_S > j1_y) && (ball_y < j1_y + PALA_H)) begin
                
                ball_dx <= -ball_dx;
                ball_x  <= J1_X_POS + PALA_W + 1;

                pala_deadzone <= calc_deadzone(lfsr[6:0]);
            // Colisión Pala 2
            end else if (ball_dx > 0 && ball_x + BALL_S >= J2_X_POS && 
                         (ball_y + BALL_S > j2_y) && (ball_y < j2_y + PALA_H)) begin
                
                ball_dx <= -ball_dx;
                ball_x  <= J2_X_POS - BALL_S - 1;
                
                pala_deadzone <= calc_deadzone(lfsr[6:0]);
            // Punto marcado (sale por los bordes izquierdo o derecho)
            end else if (ball_x <= 0 || ball_x >= (MAX_X - BALL_S)) begin
                // Resetear al centro y cambiar dirección de saque
                ball_x  <= (MAX_X / 2) - (BALL_S / 2);
                ball_y  <= (MAX_Y / 2) - (BALL_S / 2);
                ball_dx <= -ball_dx; 

                if(ball_x <= 0) begin
                    score2 <= score2 + 4'd1;
                end else begin
                    score1 <= score1 + 4'd1;
                end
            
                pala_deadzone <= calc_deadzone(lfsr[6:0]);
                
            // Sin colisión, simplemente avanzar
            end else begin
                ball_x  <= ball_x + ball_dx;
            end

        end
    end

    // =========================================================================
    // RENDERIZADO (Combinacional)
    // =========================================================================
    // Convertimos x e y a signados de 13 bits para evitar problemas al comparar 
    // con las posiciones del juego (ball_x, ball_y, etc.) que pueden ser negativas.
    wire signed [12:0] sx = signed'({1'b0, x});
    wire signed [12:0] sy = signed'({1'b0, y});

    always_comb begin
        if (!de) begin
            {next_r, next_g, next_b} = COLOR_BLACK;
        end else begin
            {next_r, next_g, next_b} = COLOR_BG;
 
            // Bola
            if (sx >= r_ball_x && sx < r_ball_x + BALL_S &&
                sy >= r_ball_y && sy < r_ball_y + BALL_S) begin
                {next_r, next_g, next_b} = COLOR_BALL;
 
            // Pala 1
            end else if (sx >= J1_X_POS && sx < J1_X_POS + PALA_W &&
                         sy >= r_j1_y   && sy < r_j1_y + PALA_H) begin
                {next_r, next_g, next_b} = COLOR_PALA;
 
            // Pala 2
            end else if (sx >= J2_X_POS && sx < J2_X_POS + PALA_W &&
                         sy >= r_j2_y   && sy < r_j2_y + PALA_H) begin
                {next_r, next_g, next_b} = COLOR_PALA;
 
            // Red central (línea discontinua)
            end else if (sx >= (MAX_X/2 - 1) && sx <= (MAX_X/2 + 1) && y[4]) begin
                {next_r, next_g, next_b} = COLOR_RED;
 
            // Marcador jugador 1
            end else if (x >= 500 && x < 564 && y >= 50 && y < 114) begin
                if (rom_data1[7 - ((x - 12'd500) >> 3)])
                    {next_r, next_g, next_b} = 24'hFFFFFF;
                else
                    {next_r, next_g, next_b} = COLOR_BG;
 
            // Marcador jugador 2
            end else if (x >= 716 && x < 780 && y >= 50 && y < 114) begin
                if (rom_data2[7 - ((x - 12'd716) >> 3)])
                    {next_r, next_g, next_b} = 24'hFFFFFF;
                else
                    {next_r, next_g, next_b} = COLOR_BG;
            end
        end
    end

    // =========================================================================
    // SALIDA REGISTRADA
    // =========================================================================
    // Esto introduce un ciclo de retardo respecto a (x,y), asegúrate de que
    // el módulo controlador VGA/HDMI envíe 'de' acorde a este pipeline.
    always_ff @(posedge clk) begin
        r <= next_r;
        g <= next_g;
        b <= next_b;
    end

endmodule