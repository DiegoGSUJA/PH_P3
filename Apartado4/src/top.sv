module top (
    input  wire clk,       // Reloj de 27MHz (Pin 52)
    input  wire rst_n,     // Reset/S1 (Pin 3)
    output logic [5:0] led // LEDs
);

    typedef enum logic [1:0] {ROJO, AMARILLO, VERDE, EXTRA} state_t;
    state_t state_reg, state_next;
    
    // Timer para que el cambio sea visible (aprox cada segundo)
    logic [24:0] timer;

    localparam frec = 2700000;

    

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= ROJO;
            timer <= 0;
        end else begin
            if (timer >= frec) begin
                state_reg <= state_next;
                timer <= 0;
            end else begin
                timer <= timer + 1'b1;
            end
        end
    end

    always_comb begin
        case (state_reg)
            ROJO:     state_next = AMARILLO;
            AMARILLO: state_next = VERDE;
            VERDE:    state_next = EXTRA;
            EXTRA:    state_next = ROJO;
            default:  state_next = ROJO;
        endcase
    end

    always_comb begin
        case (state_reg)
            ROJO:     led = 6'b111110; 
            AMARILLO: led = 6'b111100; 
            VERDE:    led = 6'b111011; 
            EXTRA:    led = 6'b000000; 
            default:  led = 6'b111111;
        endcase
    end
endmodule