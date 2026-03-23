module aleatorio (
    input  wire clk,       
    input  wire rst_n,   
    input  logic on,
    output logic [5:0] led
);

    logic [15:0] lfsr_reg;
    logic feedback;
    logic [23:0] slow_timer; // Para que el azar no vaya a 27MHz (sería invisible)

    // Polinomio de realimentación (XOR de los taps 16, 14, 13, 11) //IDEA
    assign feedback = lfsr_reg[15] ^ lfsr_reg[13] ^ lfsr_reg[12] ^ lfsr_reg[10];

    // Lógica del LFSR
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Ponemos una "semilla" (seed) inicial.
            lfsr_reg <= 16'hACE1; 
            slow_timer <= 0;
        end else begin
            if (on) begin
                slow_timer <= slow_timer + 1'b1;
                
                if (slow_timer == 0) begin
                    lfsr_reg <= {lfsr_reg[14:0], feedback};
                end
            end
        end
    end

    // Mostramos los 6 bits más bajos en los LEDs
    // Invertimos (~) por la lógica negativa de la Tang Nano
    assign led = ~lfsr_reg[5:0];

endmodule