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
        output wire o_txUartData,
        output wire [4-1 : 0]o_LEDS
    );
    
    //interface
    /*
    i_clock,
    i_rxUartData,
    i_reset,
    o_txUartData,
    o_LEDS
    */
    
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
    //OK probado enviando varios datos por separado
    RxUART#()
    u_RxUART(
        .i_rxData(i_rxUartData),
        .i_clock(i_clock),
        .i_tick(o_tick),
        .i_reset(i_reset),
         
        .o_data(o_rxData),
        .o_rxDone(o_rxDone)
    );
    
  
    wire [8-1:0] o_interfaceData;
    wire o_txStart;
    wire o_doneTick;
    
    wire [8-1:0]o_reg_dataA;
    wire [8-1:0]o_reg_dataB;
    wire [6-1:0]o_reg_operationCode;
    
    wire [8-1:0]o_reg_aluResult;
    
    InterfaceCircuit#()
    u_InterfaceCircuit(
        .i_clock(i_clock),
        .i_data(o_rxData),
        .i_rxDone(o_rxDone),
        .i_reset(i_reset),
        .i_txDone(o_doneTick),
        .i_tick(o_tick),
        
        .o_dataA(o_reg_dataA),
        .o_dataB(o_reg_dataB),
        .o_operationCode(o_reg_operationCode),
        .i_dataAluResult(o_reg_aluResult),
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
    
    ALU#()
    u_ALU(
        .i_A(o_reg_dataA),
        .i_B(o_reg_dataB),
        .i_ALUBitsControl(o_reg_operationCode),
        
        .o_ALUResult(o_reg_aluResult)
    );
    
    
    
    
    
assign o_LEDS[0]=o_reg_dataA[0];
assign o_LEDS[1]=o_reg_dataA[1];
assign o_LEDS[2]=o_reg_dataA[2];
assign o_LEDS[3]=o_reg_dataA[3];
    
/*assign o_LEDS[0]=o_reg_aluResult[0];
assign o_LEDS[1]=o_reg_aluResult[1];
assign o_LEDS[2]=o_reg_aluResult[2];
assign o_LEDS[3]=o_reg_aluResult[3];*/


/*assign o_LEDS[0]=o_rxDone;
assign o_LEDS[1]=0;
assign o_LEDS[2]=o_doneTick;
assign o_LEDS[3]=0;
    */
    
endmodule
