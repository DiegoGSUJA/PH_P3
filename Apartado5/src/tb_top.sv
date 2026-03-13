`timescale 1ns/1ps

module tb_top;
    logic clk;
    logic up;
    logic down;
    logic [5:0] led;

    // Conexión con tu diseño
    top dut (
        .clk(clk),
        .up(up),
        .down(down),
        .led(led)
    );

    // Generar reloj de 27MHz (aprox 37ns por ciclo completo)
    always #18.5 clk = ~clk;

    initial begin
        // Inicialización
        clk = 0;
        down = 1; // Botón no presionado
        up = 0;   // Presionamos UP (Reset activo)
        
        #100 up = 1;  // Soltamos Reset: el LFSR empieza a funcionar
        
        #500 down = 0; // Presionamos DOWN: los LEDs deben invertirse
        #100 down = 1; // Soltamos DOWN
        
        #1000 $finish;
    end
endmodule