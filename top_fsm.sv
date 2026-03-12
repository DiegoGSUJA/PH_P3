module top (
    input  wire clk,       // Reloj de 27MHz
    input  wire rst_n,     // Reset (S1)
    output logic [5:0] led // LEDs
);

    // Definición de estados
    typedef enum logic [1:0] {
        ROJO     = 2'b00,
        AMARILLO = 2'b01,
        VERDE    = 2'b10,
        EXTRA    = 2'b11
    } state_t;

    state_t state_reg, state_next;
    logic [24:0] timer; // Divisor de frecuencia para ver el cambio

    // 1. Lógica secuencial (Estado actual)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= ROJO;
            timer <= 0;
        end else begin
            timer <= timer + 1;
            if (timer == 0) // Cuando el contador desborda (aprox cada 1.2s)
                state_reg <= state_next;
        end
    end

    // 2. Lógica del siguiente estado
    always_comb begin
        case (state_reg)
            ROJO:     state_next = AMARILLO;
            AMARILLO: state_next = VERDE;
            VERDE:    state_next = EXTRA;
            EXTRA:    state_next = ROJO;
            default:  state_next = ROJO;
        endcase
    end

    // 3. Lógica de salida (LEDs activos en bajo)
    always_comb begin
        case (state_reg)
            ROJO:     led = 6'b111110; // Enciende LED 0
            AMARILLO: led = 6'b111101; // Enciende LED 1
            VERDE:    led = 6'b111011; // Enciende LED 2
            EXTRA:    led = 6'b000000; // Todos encendidos
            default:  led = 6'b111111; // Todos apagados
        endcase
    end

endmodule