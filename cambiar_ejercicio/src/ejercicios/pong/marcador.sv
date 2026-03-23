module marcador (
    input  logic [3:0] valor,  
    input  logic [2:0] fila_y, 
    output logic [7:0] data_x  
);
    always_comb begin
        case (valor)
            4'd0: case(fila_y)
                0: data_x = 8'b00111100; 
                1: data_x = 8'b01100110; 
                2: data_x = 8'b01100110;
                3: data_x = 8'b01100110; 
                4: data_x = 8'b01100110; 
                5: data_x = 8'b01100110;
                6: data_x = 8'b00111100; default: data_x = 8'b00000000; endcase
            4'd1: case(fila_y)
                0: data_x = 8'b00011000; 
                1: data_x = 8'b00111000;
                2: data_x = 8'b00011000;
                3: data_x = 8'b00011000;
                4: data_x = 8'b00011000;
                5: data_x = 8'b00011000;
                6: data_x = 8'b00111100; default: data_x = 8'b00000000; endcase
            4'd2: case(fila_y)
                0: data_x = 8'b00111100; 
                1: data_x = 8'b01100110; 
                2: data_x = 8'b00000110;
                3: data_x = 8'b00011100; 
                4: data_x = 8'b00110000; 
                5: data_x = 8'b01100000;
                6: data_x = 8'b01111110; default: data_x = 8'b00000000; endcase
            4'd3: case(fila_y)
                0: data_x = 8'b00111100;
                1: data_x = 8'b01100110;
                2: data_x = 8'b00000110;
                3: data_x = 8'b00011100;
                4: data_x = 8'b00000110;
                5: data_x = 8'b01100110;
                6: data_x = 8'b00111100;
                default: data_x = 8'b00000000;
            endcase
            4'd4: case(fila_y)
                0: data_x = 8'b01100110;
                1: data_x = 8'b01100110;
                2: data_x = 8'b01100110;
                3: data_x = 8'b01111110;
                4: data_x = 8'b00000110;
                5: data_x = 8'b00000110;
                6: data_x = 8'b00000110;
                default: data_x = 8'b00000000;
            endcase
            4'd5: case(fila_y)
                0: data_x = 8'b01111110;
                1: data_x = 8'b01100000;
                2: data_x = 8'b01100000;
                3: data_x = 8'b01111100;
                4: data_x = 8'b00000110;
                5: data_x = 8'b01100110;
                6: data_x = 8'b00111100;
                default: data_x = 8'b00000000;
            endcase
            4'd6: case(fila_y)
                0: data_x = 8'b00111100;
                1: data_x = 8'b01100110;
                2: data_x = 8'b01100000;
                3: data_x = 8'b01111100;
                4: data_x = 8'b01100110;
                5: data_x = 8'b01100110;
                6: data_x = 8'b00111100;
                default: data_x = 8'b00000000;
            endcase
            4'd7: case(fila_y)
                0: data_x = 8'b01111110;
                1: data_x = 8'b00000110;
                2: data_x = 8'b00000110;
                3: data_x = 8'b00001100;
                4: data_x = 8'b00011000;
                5: data_x = 8'b00011000;
                6: data_x = 8'b00011000;
                default: data_x = 8'b00000000;
            endcase
            4'd8: case(fila_y)
                0: data_x = 8'b00111100;
                1: data_x = 8'b01100110;
                2: data_x = 8'b01100110;
                3: data_x = 8'b00111100;
                4: data_x = 8'b01100110;
                5: data_x = 8'b01100110;
                6: data_x = 8'b00111100;
                default: data_x = 8'b00000000;
            endcase
            4'd9: case(fila_y)
                0: data_x = 8'b00111100;
                1: data_x = 8'b01100110;
                2: data_x = 8'b01100110;
                3: data_x = 8'b00111110;
                4: data_x = 8'b00000110;
                5: data_x = 8'b00000110;
                6: data_x = 8'b00111100;
                default: data_x = 8'b00000000;
            endcase
            default: data_x = 8'b00000000;
        endcase
    end
endmodule