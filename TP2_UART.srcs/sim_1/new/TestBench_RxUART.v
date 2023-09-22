`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2023 10:51:54 PM
// Design Name: 
// Module Name: TestBench_RxUART
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define BAUD_RATE                9600            // Baud rate a generar.             
`define CLOCK_FREQUENCY_MHZ      100.0           // Frecuencia del clock en MHZ.

`define DATA_LENGTH 8

`define DELAY_TIME 120


module TestBench_RxUART(

    );
    
    // Parametros
    parameter BAUD_RATE = `BAUD_RATE;
    parameter CLOCK_FREQUENCY_MHZ = `CLOCK_FREQUENCY_MHZ;
    parameter DATA_LENGTH=`DATA_LENGTH;
    parameter DELAY_TIME=`DELAY_TIME;
	
	//Todo puerto de salida del modulo es un cable.
	//Todo puerto de estimulo o generacion de entrada es un registro.
	
	// Entradas.
    reg i_clock;                                  // Clock.
    reg i_reset;                             // Reset.
    //wire o_tick;
    
    
    
    reg i_rxDa;
    
    wire [DATA_LENGTH-1:0]o_data;
    wire o_rxDone;
    wire o_fail;
    reg o_tick;
    RxUART#()
    u_RxUART(
        .i_rxData(i_rxDa),//recievedData recibe el bit de información
        .i_clock(i_clock),
        .i_tick(o_tick),
        .i_reset(i_reset),
        
        .o_data(o_data),
        .o_rxDone(o_rxDone),
        .o_fail(o_fail)
    );
    
    integer i;
    
    initial begin
        #2500
		i_clock = 1'b0;
		o_tick = 1;
		i_reset = 1'b1; // Reset en 0. (Normal cerrado el boton del reset).
		
		#DELAY_TIME i_reset = 1'b0; // Desactivo la accion del reset.
		o_tick = 0;
		
		// Test 1: Prueba reset.
		#10000 i_reset = 1'b1; // Reset.
		o_tick = 0;
		#DELAY_TIME i_reset = 1'b0; // Desactivo el reset.
		
		///////////////----------------
		i_rxDa=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        //tendria que pasar a start
        //quiero envier el numero 10010111//151
        i_rxDa=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxDa=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxDa=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxDa=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxDa=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxDa=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxDa=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxDa=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        //bit de parada
        i_rxDa=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        
		
		
		
		#5000000 $finish;
    
    end 
    
    always #2.5 i_clock=~i_clock;  // Simulacion de clock.
    
    
    
    
    
endmodule
