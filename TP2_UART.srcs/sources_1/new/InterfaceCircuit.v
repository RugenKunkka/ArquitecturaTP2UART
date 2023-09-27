`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 11:36:05 AM
// Design Name: 
// Module Name: InterfaceCircuit
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

`define DATA_LENGTH 8
`define OPERATION_CODE_LENGTH 6

module InterfaceCircuit(
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
    
    reg [1:0] reg_actualState;
    
    reg [DATA_LENGTH-1:0] o_reg_dataA;
    reg [DATA_LENGTH-1:0] o_reg_dataB;
    reg [DATA_LENGTH-1:0] o_reg_operationCode;
    reg [DATA_LENGTH-1:0] o_reg_data;
    reg o_reg_txStart;
    
    always@( posedge i_tick) begin
        if(i_reset) begin 
            reg_actualState<=READ_A_STATE;
            o_reg_dataA<=0;
            o_reg_dataB<=0;
            o_reg_operationCode<=0;
            o_reg_data<=0;
            o_reg_txStart<=0;
        end
        else begin
             o_reg_txStart<=0;
             if(i_rxDone) begin
                if(reg_actualState==READ_A_STATE) begin
                     o_reg_dataA<=i_data;
                     reg_actualState<=READ_B_STATE;
                end
                else if (reg_actualState==READ_B_STATE) begin
                    o_reg_dataB<=i_data;
                    reg_actualState<=READ_OPREATION_CODE_STATE;
                
                end
                else if (reg_actualState==READ_OPREATION_CODE_STATE) begin
                    o_reg_operationCode<=i_data[OPERATION_CODE_LENGTH-1:0];
                    //reg_actualState<=CALCULATE_STATE;
                    reg_actualState<=READ_A_STATE;
                    o_reg_txStart<=1;
                end
                else if (reg_actualState==CALCULATE_STATE) begin
                     o_reg_data<=i_dataAluResult;
                     reg_actualState<=READ_A_STATE;
                     o_reg_txStart<=1;
                end
             end
             else begin
             
             end
        end
        
    end
assign o_dataA=o_reg_dataA;
assign o_dataB=o_reg_dataB;
assign o_operationCode=o_reg_operationCode;
//assign o_data=o_reg_data;
assign o_data=i_dataAluResult;
assign o_txStart = o_reg_txStart;
    

    
endmodule
