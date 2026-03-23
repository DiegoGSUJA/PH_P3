module contar (
    input  logic clk,
    input  logic up_n,
    input  logic down_n,
    input  logic on,
    output wire [5:0] led
);

logic [5:0] counter = 0;
logic up_reg, down_reg;

always_ff @(posedge clk) begin
    if (on) begin
        up_reg <= up_n;
        down_reg <= down_n;

        if (!up_n && up_reg && (counter < 6'd63))
            counter <= counter + 1'b1;
        else if (!down_n && down_reg && (counter > 6'd0)) 
            counter <= counter - 1'b1;
    end
end

assign led[5:0] = ~counter; 

endmodule