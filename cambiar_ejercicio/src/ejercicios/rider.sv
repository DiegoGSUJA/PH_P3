module rider (
    input  wire clk,
    input  logic on,
    output wire [5:0] led
);

logic [5:0] animation = 6'b00001;
logic [31:0] counter = 0;

logic volver = 0;

localparam FRECUENCIA = 810000;

always_ff @(posedge clk) begin
    if (on) begin
        if (counter >= FRECUENCIA) begin
            counter <= 0;
            if (animation == 6'b01000) volver <= 1;
            else if (animation == 6'b00010) volver <= 0;

            if(volver)
                animation <= animation >> 1;
            else
                animation <= animation << 1;
        end
        else
            counter <= counter + 1;
    end
end


assign led = ~animation;


endmodule