`timescale 1ns / 1ps

module top_tb();

logic clk = 0;
logic [5:0]led;

top test(
    .clk(clk),
    .led(led)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("ondas.vcd");
    $dumpvars(0, top_tb);
    repeat (100) @(posedge clk);
    $finish;
end

always @(test.animation) begin
        $display("Tiempo: %t | LED (invertido): %b | Animación: %b", $time, led, test.animation);
end

endmodule