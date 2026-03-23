module maquina (
    input  wire clk,       
    input  wire rst_n,    
    input  logic on,
    output logic [5:0] led 
);

    typedef enum logic [1:0] {ROJO, AMARILLO, VERDE} state_t;
    state_t state_reg, state_next;
    
    logic [24:0] timer;

    localparam frec = 27000000;

    

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= ROJO;
            timer <= 0;
        end else begin
            if (on) begin
                if (timer >= frec) begin
                    state_reg <= state_next;
                    timer <= 0;
                end else begin
                    timer <= timer + 1'b1;
                end
            end
        end
    end

    always_comb begin
        case (state_reg)
            ROJO:     state_next = AMARILLO;
            AMARILLO: state_next = VERDE;
            VERDE:    state_next = ROJO;
            default:  state_next = ROJO;
        endcase
    end

    always_comb begin
        case (state_reg)
            ROJO:     led = 6'b110011; 
            AMARILLO: led = 6'b101101; 
            VERDE:    led = 6'b000000; 
            default:  led = 6'b111111;
        endcase
    end
endmodule