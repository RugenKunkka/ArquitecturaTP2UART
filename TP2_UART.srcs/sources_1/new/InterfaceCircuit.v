`timescale 1ns / 1ps

`define DATA_LENGTH 8
`define OPERATION_CODE_LENGTH 6

module InterfaceCircuit(
        input wire i_clock,
        input wire [`DATA_LENGTH-1:0] i_data,
        input wire i_rxDone,
        input wire i_reset,
        
        input wire i_txDone,
        input wire i_tick,
        
        output wire [`DATA_LENGTH-1:0] o_dataA,
        output wire [`DATA_LENGTH-1:0] o_dataB,
        output wire [`OPERATION_CODE_LENGTH-1:0] o_operationCode,
        
        input wire [`DATA_LENGTH-1:0] i_dataAluResult,
        output wire [`DATA_LENGTH-1:0] o_data,//el resultado
        output wire o_txStart
    );
    
    //interface
    /*
    i_data,
    i_rxDone,
    i_reset,
    i_txDone,
    i_tick,
    
    o_dataA,
    o_dataB,
    o_operationCode,
    i_dataAluResult,
    o_data,
    o_txStart
    */
    localparam DATA_LENGTH= `DATA_LENGTH;
    localparam OPERATION_CODE_LENGTH= `OPERATION_CODE_LENGTH;
    
    localparam READ_A_STATE=2'b00;
    localparam READ_B_STATE=2'b01;
    localparam READ_OPREATION_CODE_STATE=2'b10;
    localparam CALCULATE_STATE=2'b11;
    
    reg [1:0] reg_actualState,reg_nextActualState;
    
    reg [DATA_LENGTH-1:0] o_reg_dataA,o_reg_nextDataA;
    reg [DATA_LENGTH-1:0] o_reg_dataB,o_reg_nextDataB;
    reg [DATA_LENGTH-1:0] o_reg_operationCode,o_reg_nextOperationCode;
    reg [DATA_LENGTH-1:0] o_reg_aluResultData,o_reg_nextAluResultData;
    reg o_reg_txStart,o_reg_nextTxStart;
    
    always@(posedge i_clock) begin
         if(i_reset) begin 
            reg_actualState<=READ_A_STATE;
            o_reg_dataA<=0;
            o_reg_dataB<=0;
            o_reg_operationCode<=0;
            o_reg_aluResultData<=0;
            o_reg_txStart<=0;
        end
        else begin
            reg_actualState<=reg_nextActualState;
            o_reg_dataA<=o_reg_nextDataA;
            o_reg_dataB<=o_reg_nextDataB;
            o_reg_operationCode<=o_reg_nextOperationCode;
            o_reg_aluResultData<=o_reg_nextAluResultData;
            o_reg_txStart<=o_reg_nextTxStart;
            
        end
    end
    
    always@(*) begin
         reg_nextActualState=reg_actualState;
         o_reg_nextDataA=o_reg_dataA;
         o_reg_nextDataB=o_reg_dataB;
         o_reg_nextOperationCode=o_reg_operationCode;
         o_reg_nextAluResultData=o_reg_aluResultData;
         //o_reg_nextData=o_reg_data;
         //o_reg_nextTxStart=o_reg_txStart;
         
         
         o_reg_nextTxStart=0;
         //if(i_rxDone) begin
         //if( i_tick) begin 
            if(i_rxDone && reg_actualState==READ_A_STATE) begin
                //o_reg_nextTxStart=0;//NO SE SI VA AHI XD
                o_reg_nextDataA=i_data;
                reg_nextActualState=READ_B_STATE;
            end
            else if (i_rxDone && reg_actualState==READ_B_STATE) begin
                o_reg_nextDataB=i_data;
                reg_nextActualState=READ_OPREATION_CODE_STATE;
            
            end
            else if (i_rxDone && reg_actualState==READ_OPREATION_CODE_STATE) begin
                o_reg_nextOperationCode=i_data[OPERATION_CODE_LENGTH-1:0];
                reg_nextActualState=CALCULATE_STATE;
                //reg_nextActualState=READ_A_STATE;
                //o_reg_nextTxStart=1;
                //o_reg_nextAluResultData=i_dataAluResult;
            end
            else if (reg_actualState==CALCULATE_STATE) begin
                 o_reg_nextAluResultData=i_dataAluResult;
                 reg_nextActualState=READ_A_STATE;
                 o_reg_nextTxStart=1;
            end
         //end
    end
assign o_dataA=o_reg_dataA;
assign o_dataB=o_reg_dataB;
assign o_operationCode=o_reg_operationCode;
//assign o_data=o_reg_data;
assign o_data=o_reg_aluResultData;
//assign o_data=i_data;
assign o_txStart = o_reg_txStart;
    

    
endmodule
