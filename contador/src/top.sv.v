module top (
    input  wire clk,
    input  wire up_n,
    input  wire down_n,
    output wire [5:0] led
);

logic [4:0] counter = 0;
logic up_reg, down_reg;

always_ff @(posedge clk) begin
    up_reg <= up_n;
    down_reg <= down_n;

    if (!up_n && up_reg)
        counter <= counter + 1'b1;
    else if (!down_n && down_reg) 
        counter <= counter - 1'b1;
end

assign led[4:0] = ~counter; 

endmodule