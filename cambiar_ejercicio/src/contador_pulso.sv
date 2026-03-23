module contador_pulso (
    input  logic clk,
    input  logic signal_in,
    output logic es_larga
);
    localparam int UMBRAL_LARGA = 27_000_000;

    int   counter     = 0;
    logic signal_prev = 0;
    logic larga_prev  = 0;

    always_ff @(posedge clk) begin
        signal_prev <= signal_in;
        es_larga    <= 0;

        if (!signal_in) begin
            counter <= counter + 1;
        end
        else if (!signal_prev && signal_in) begin
            counter <= 0;
        end

        larga_prev <= (counter >= UMBRAL_LARGA);
        if ((counter >= UMBRAL_LARGA) && !larga_prev)
            es_larga <= 1;
    end

endmodule