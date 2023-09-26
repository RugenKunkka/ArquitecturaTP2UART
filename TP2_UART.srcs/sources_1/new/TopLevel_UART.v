`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 11:55:39 AM
// Design Name: 
// Module Name: TopLevel_UART
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


module TopLevel_UART(
        input wire i_clock,
        input wire i_rxUartData,
        input wire i_reset,
        output wire o_txUartData  
    );
    
    wire o_tick;
    
    BaudRateGenerator#() 
    u_BaudRateGenerator    // Una sola instancia de este modulo.
    (
      .i_clock (i_clock),
      .i_reset (i_reset),
      .o_tick (o_tick)
    );
    
    wire [8-1:0] o_rxData;
    wire o_rxDone;
    wire o_fail;
    
    RxUART#()
    u_RxUART(
        .i_rxData(i_rxUartData),
        .i_clock(i_clock),
        .i_tick(o_tick),
        .i_reset(i_reset),
         
        .o_data(o_rxData),
        .o_rxDone(o_rxDone),
        .o_fail(o_fail)
    );
    
    wire o_interfaceData;
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
    
    
    
    
    
endmodule
