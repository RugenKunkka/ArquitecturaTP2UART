`timescale 1ns / 1ps

`define BAUD_RATE                9600            // Baud rate a generar.             
`define CLOCK_FREQUENCY_MHZ      100.0           // Frecuencia del clock en MHZ.

`define DATA_LENGTH 8

//`define DELAY_TIME 52080
`define DELAY_TIME 104166 



module TestBech_TopLevel_UART(

    );
    parameter DATA_LENGTH=`DATA_LENGTH;
    parameter DELAY_TIME=`DELAY_TIME;
    
    reg i_clock;
    reg i_rxData;
    reg i_reset;
    wire o_txUartData;
    
    
    TopLevel_UART#()
    TopLevel_UART(
        .i_clock(i_clock),
        .i_rxUartData(i_rxData),
        .i_reset(i_reset),
        .o_txUartData(o_txUartData),
        .o_LEDS()
    );
    
    
    initial begin
        #2500
		i_clock = 1'b0;
		i_reset = 1'b1; // Reset en 0. (Normal cerrado el boton del reset).
		i_rxData = 1;
		
		#2000 i_reset = 1'b0;
		
		//#DELAY_TIME i_rxData=0;
		//2 en binario.. 00000010
		// Test 1: Paso Data A como parametro
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b1;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b1;
		
		// Dejo un intervalo de tiempo.
		#DELAY_TIME i_rxData = 1'b1;
		
		// Test 2: Paso Data B como parametro
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b1;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b1;
		
		// Dejo un intervalo de tiempo.
		#DELAY_TIME i_rxData = 1'b1;
		
		// Test 3: Paso Operation Code como parametro
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b1;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b0;
		#DELAY_TIME i_rxData = 1'b1;
		
		// Dejo un intervalo de tiempo.
		#DELAY_TIME i_rxData = 1'b1;
		
		// Test 4: Reset
		//#3000000 i_reset = 1'b0; // Reset.
		//#3000000 i_reset = 1'b1; // Desactivo el reset.
		
		
		#50000000 $finish;
        
    
    end
    
    always #5.0 i_clock=~i_clock;
    
endmodule
