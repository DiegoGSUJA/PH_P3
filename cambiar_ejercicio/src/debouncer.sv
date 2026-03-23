module debounce #(
    parameter N = 20 
) (
    input  logic clk,
    input  logic noisy,
    output logic clean
);
    logic [$clog2(N)-1:0] count = 0;
    logic noisy_prev = 0;

    always_ff @(posedge clk) begin
        noisy_prev <= noisy;
        if (noisy != noisy_prev)
            count <= 0;            
        else if (count < N - 1)
            count <= count + 20'd1;      
        else
            clean <= noisy;        
    end
endmodule