`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2023 09:05:08 PM
// Design Name: 
// Module Name: TestBench_TxUART
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

module TestBench_TxUART(

    );
    
    localparam DELAY_TIME = `DELAY_TIME;
    
    reg i_clock;
    reg i_reset;
    reg i_tick;
    reg i_txStart;
    reg [8-1:0]i_data;
    
    wire o_doneTick;
    wire o_txData;

    TxUART#()
    u_TxUART(
        .i_clock(i_clock),
        .i_reset(i_reset),
        .i_tick(i_tick),
        .i_txStart(i_txStart),
        .i_data(i_data),
        .o_doneTick(o_doneTick),
        .o_txData(o_txData)
    );
    
    integer i;
    initial begin
        #2500
		i_clock = 1'b0;
		i_tick = 1;
		i_reset = 1'b1; // Reset en 0. (Normal cerrado el boton del reset).
		
		#DELAY_TIME i_reset = 1'b0; // Desactivo la accion del reset.
		i_tick = 0;
		
		// Test 1: Prueba reset.
		#10000 i_reset = 1'b1; // Reset.
		i_tick = 0;
		#DELAY_TIME i_reset = 1'b0; // Desactivo el reset.
		i_data=8'b10100011;
		i_txStart=1;
		i_tick=1;
		#DELAY_TIME
		i_txStart=0;
		i_tick=0;
		 for (i = 0; i < 200; i = i + 1) begin
            #DELAY_TIME i_tick=1;
            #DELAY_TIME i_tick=0;
        end
		
    
    end
    always #2.5 i_clock=~i_clock;
endmodule
