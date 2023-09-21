`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2023 02:11:00 PM
// Design Name: 
// Module Name: TestBench_BaudRateGenerator
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

module TestBench_BaudRateGenerator();

    // Parametros
    parameter BAUD_RATE = `BAUD_RATE;
    parameter CLOCK_FREQUENCY_MHZ = `CLOCK_FREQUENCY_MHZ;
	
	//Todo puerto de salida del modulo es un cable.
	//Todo puerto de estimulo o generacion de entrada es un registro.
	
	// Entradas.
    reg i_clock;                                  // Clock.
    reg i_reset;                             // Reset.
    wire o_tick;
    
	//Modulo para pasarle los estimulos del banco de pruebas.
    BaudRateGenerator
    #(
         .BAUD_RATE (BAUD_RATE),
         .CLOCK_FREQUENCY_MHZ (CLOCK_FREQUENCY_MHZ)
     ) 
    u_BaudRateGenerator    // Una sola instancia de este modulo.
    (
      .i_clock (i_clock),
      .i_reset (i_reset),
      .o_tick (o_tick)
    );
	
	initial	begin
	    #2500
		i_clock = 1'b0;
		i_reset = 1'b1; // Reset en 0. (Normal cerrado el boton del reset).
		
		#120 i_reset = 1'b0; // Desactivo la accion del reset.
		
		// Test 1: Prueba reset.
		#10000 i_reset = 1'b1; // Reset.
		#120 i_reset = 1'b0; // Desactivo el reset.
		
		
		#5000000 $finish;
	end
	
	always #2.5 i_clock=~i_clock;  // Simulacion de clock.






endmodule
