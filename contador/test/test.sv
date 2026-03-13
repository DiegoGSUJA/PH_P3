`timescale 1ns/1ps

module top_tb;

    // Señales del testbench
    logic clk = 0;
    logic up_n = 1;
    logic down_n = 1;
    wire [5:0] led;

    // Instancia del módulo a testear (Unit Under Test)
    top uut (
        .clk(clk),
        .up_n(up_n),
        .down_n(down_n),
        .led(led)
    );

    // Generador de reloj (100MHz aprox)
    always #5 clk = ~clk;

    // Proceso de estímulos
    initial begin
        $dumpfile("top_test.vcd"); // Para ver las ondas en GTKWave
        $dumpvars(0, top_tb);

        // Esperar un par de ciclos
        repeat(2) @(posedge clk);

        // --- Simular pulsación de UP ---
        $display("Pulsando UP...");
        up_n = 0; // Baja la señal
        repeat(2) @(posedge clk);
        up_n = 1; // Sube la señal
        repeat(2) @(posedge clk);

        // --- Simular pulsación de DOWN ---
        $display("Pulsando DOWN...");
        down_n = 0;
        repeat(2) @(posedge clk);
        down_n = 1;
        repeat(5) @(posedge clk);

        $display("Test finalizado. Revisa las ondas.");
        $finish;
    end

endmodule
