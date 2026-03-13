module top (
    input  wire clk,
    output wire [5:0] led
);

logic [5:0] animation = 5'b00001;
logic [31:0] counter = 0;

logic volver = 0;

localparam FRECUENCIA = 2;

always_ff @(posedge clk) begin
    if (counter >= FRECUENCIA) begin
        counter <= 0;
        if (animation == 5'b10000) volver <= 1;
        else if (animation == 5'b00001) volver <= 0;

        if(volver)
            animation <= animation >> 1;
        else
            animation <= animation << 1;
    end
    else
        counter <= counter + 1;
end


assign led = ~animation;


endmodule