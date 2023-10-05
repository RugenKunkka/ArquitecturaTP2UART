`timescale 1ns / 1ps

`define DATA_LENGTH 8
`define OPERATION_CODE_LENGTH 6

`define BAUD_RATE 9600    //bits/sec 
`define CLOCK_FREQUENCY_MHZ 100.0 //MHZ
`define MHZ_TO_HZ_CONVERSION_FACTOR 1000000

module TopLevel_UART
    #(
        parameter DATA_LENGTH= `DATA_LENGTH,
        parameter OPERATION_CODE_LENGTH= `OPERATION_CODE_LENGTH,
        parameter BAUD_RATE    = `BAUD_RATE,
        parameter CLOCK_FREQUENCY_MHZ  = `CLOCK_FREQUENCY_MHZ,
        parameter MHZ_TO_HZ_CONVERSION_FACTOR  = `MHZ_TO_HZ_CONVERSION_FACTOR
    )
    (
        input wire i_clock,
        input wire i_rxUartData,
        input wire i_reset,
        output wire o_txUartData
    );
    
    wire o_tick;
    BaudRateGenerator#
    (
        .BAUD_RATE (BAUD_RATE),
        .CLOCK_FREQUENCY_MHZ  (CLOCK_FREQUENCY_MHZ),
        .MHZ_TO_HZ_CONVERSION_FACTOR (MHZ_TO_HZ_CONVERSION_FACTOR)
    ) 
    u_BaudRateGenerator    // Una sola instancia de este modulo.
    (
      .i_clock (i_clock),
      .i_reset (i_reset),
      .o_tick (o_tick)
    );
    
    wire [DATA_LENGTH-1:0] o_rxData;
    wire o_rxDone;
    RxUART#
    (
        .DATA_LENGTH (DATA_LENGTH)
    )
    u_RxUART(
        .i_rxData(i_rxUartData),
        .i_clock(i_clock),
        .i_tick(o_tick),
        .i_reset(i_reset),
        .o_data(o_rxData),
        .o_rxDone(o_rxDone)
    );
    
  
    wire [DATA_LENGTH-1:0] o_interfaceData;
    wire o_txStart;  
    wire [DATA_LENGTH-1:0]o_reg_dataA;
    wire [DATA_LENGTH-1:0]o_reg_dataB;
    wire [OPERATION_CODE_LENGTH-1:0]o_reg_operationCode;
    wire [DATA_LENGTH-1:0]o_reg_aluResult;    
    InterfaceCircuit#
    (
        .DATA_LENGTH (DATA_LENGTH),
        .OPERATION_CODE_LENGTH (OPERATION_CODE_LENGTH)
    )
    u_InterfaceCircuit(
        .i_clock(i_clock),
        .i_data(o_rxData),
        .i_rxDone(o_rxDone),
        .i_reset(i_reset),
        
        .o_dataA(o_reg_dataA),
        .o_dataB(o_reg_dataB),
        .o_operationCode(o_reg_operationCode),
        .i_dataAluResult(o_reg_aluResult),
        .o_data(o_interfaceData),
        .o_txStart(o_txStart)
    );
    
    TxUART#
    (
        .DATA_LENGTH (DATA_LENGTH),
        .SB_TICK (16)
    )
    u_TxUART(
        .i_clock(i_clock),
        .i_reset(i_reset),
        .i_tick(o_tick),
        .i_txStart(o_txStart),
        .i_data(o_interfaceData),
        .o_doneTick(o_doneTick),
        .o_txData(o_txUartData)
    );
    
    ALU#
    (
        .DATA_LENGTH (DATA_LENGTH),
        .OPERATION_CODE_LENGTH (OPERATION_CODE_LENGTH)
    )
    u_ALU(
        .i_A(o_reg_dataA),
        .i_B(o_reg_dataB),
        .i_ALUBitsControl(o_reg_operationCode),      
        .o_ALUResult(o_reg_aluResult)
    );
    
endmodule