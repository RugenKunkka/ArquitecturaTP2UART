`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2023 12:13:39 AM
// Design Name: 
// Module Name: TestBech_TopLevel_UART
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



module TestBech_TopLevel_UART(

    );
    parameter DATA_LENGTH=`DATA_LENGTH;
    parameter DELAY_TIME=`DELAY_TIME;
    
    reg i_clock;
    reg i_rxData;
    reg i_reset;
    wire o_txUartData;
    
    
    reg o_tick;
    
    
    wire [8-1:0] o_rxData;
    wire o_rxDone;
    wire o_fail;
    //OK probado enviando varios datos por separado
    RxUART#()
    u_RxUART(
        .i_rxData(i_rxData),
        .i_clock(i_clock),
        .i_tick(o_tick),
        .i_reset(i_reset),
         
        .o_data(o_rxData),
        .o_rxDone(o_rxDone),
        .o_fail(o_fail)
    );
    
    
    wire [8-1:0] o_interfaceData;
    wire o_txStart;
    wire o_doneTick;
    InterfaceCircuit#()
    u_InterfaceCircuit(
        .i_data(o_rxData),
        .i_rxDone(o_rxDone),
        .i_reset(i_reset),
        
        .i_txDone(o_doneTick),
        .o_data(o_interfaceData),
        .o_txStart(o_txStart)
    );
    
    TxUART#()
    u_TxUART(
        .i_clock(i_clock),
        .i_reset(i_reset),
        .i_tick(o_tick),
        .i_txStart(o_txStart),
        .i_data(o_interfaceData),
        .o_doneTick(o_doneTick),
        .o_txData(o_txUartData)
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
		i_rxData=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        //tendria que pasar a start
        //quiero envier el numero 10010111//151
        i_rxData=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxData=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxData=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxData=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxData=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxData=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxData=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        i_rxData=1;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        //bit de parada
        i_rxData=0;
        for (i = 0; i < 16; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
        //---------para el TX
         for (i = 0; i < 200; i = i + 1) begin
            #DELAY_TIME o_tick=1;
            #DELAY_TIME o_tick=0;
        end
        
		#5000000 $finish;
        
    
    end
    
    always #2.5 i_clock=~i_clock;
    
endmodule
