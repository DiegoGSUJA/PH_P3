module top(
    input  logic clk,
    input  logic boton_izq,
    input  logic boton_der,

    output [2:0] tmds_data_p, tmds_data_n,
    output tmds_clk_p, tmds_clk_n,
    output logic [5:0] led
);
    logic boton_izq_clean, boton_der_clean;

    debounce #(.N(540_000)) db_izq   (.clk, .noisy(boton_izq),   .clean(boton_izq_clean));
    debounce #(.N(540_000)) db_der (.clk, .noisy(boton_der),  .clean(boton_der_clean));

    typedef enum logic [2:0] { RIDER, CONTADOR, MAQUINA, ALEATORIO, PONG } ejercicio_t;
    ejercicio_t ej_act = PONG;

    logic cambiar_ejercicio;

    logic [4:0] ejercicio = 0;
    logic [5:0] led_rider;
    logic [5:0] led_contar;
    logic [5:0] led_maquina;
    logic [5:0] led_aleatorio;

    contador_pulso cp (
        .clk(clk),
        .signal_in(boton_izq),
        .es_larga(cambiar_ejercicio)
    );

    always_ff @(posedge clk) begin
            if (cambiar_ejercicio) begin
                case(ej_act)
                    RIDER:     ej_act <= CONTADOR;
                    CONTADOR:  ej_act <= MAQUINA;
                    MAQUINA:   ej_act <= ALEATORIO;
                    ALEATORIO: ej_act <= PONG;
                    PONG:      ej_act <= RIDER;
                    default:   ej_act <= RIDER;
                endcase
            end
    end

    always_comb begin
        case(ej_act)
            RIDER:     ejercicio = 5'b00001;
            CONTADOR:  ejercicio = 5'b00010;
            MAQUINA:   ejercicio = 5'b00100;
            ALEATORIO: ejercicio = 5'b01000;
            PONG:      ejercicio = 5'b10000;
            default:   ejercicio = 5'b00000;
        endcase
    end
    
    always_comb begin
        case(ej_act)
            RIDER:     led = led_rider;
            CONTADOR:  led = led_contar;
            MAQUINA:   led = led_maquina;
            ALEATORIO: led = led_aleatorio;
            PONG:      led = 6'b111101;
            default:   led = 6'b000000;
        endcase
    end

    rider ej_r (
        .clk(clk),
        .on(ejercicio[0]),
        .led(led_rider)
    );

    contar ej_c (
        .clk(clk),
        .up_n(boton_der_clean),
        .down_n(boton_izq_clean && ~cambiar_ejercicio),
        .on(ejercicio[1]),
        .led(led_contar)
    );

    maquina ej_m (
        .clk(clk),
        .rst_n(boton_izq_clean && ~cambiar_ejercicio),
        .on(ejercicio[2]),
        .led(led_maquina)
    );

    aleatorio ej_a (
        .clk(clk),
        .rst_n(boton_izq_clean && ~cambiar_ejercicio),
        .on(ejercicio[3]),
        .led(led_aleatorio)
    );

    pong ej_p (
        .clk(clk),
        .rst_n(boton_izq_clean && ~cambiar_ejercicio),
        .on(ejercicio[4]),
        .tmds_data_p(tmds_data_p), 
        .tmds_data_n(tmds_data_n),
        .tmds_clk_p(tmds_clk_p),
        .tmds_clk_n(tmds_clk_n)
    );
endmodule
