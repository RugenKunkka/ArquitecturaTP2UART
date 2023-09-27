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

module InterfaceCircuit(
        input wire [`DATA_LENGTH-1:0] i_data,
        input wire i_rxDone,
        input wire i_reset,
        
        input wire i_txDone,
        output wire [`DATA_LENGTH-1:0] o_data,
        output wire o_txStart
    );
    
    localparam DATA_LENGTH = `DATA_LENGTH;
    //interface!!! 
    /*
    i_data
    i_rxDone
    i_reset
        
    i_txDone
    o_data
    o_txStart
    */
    reg [DATA_LENGTH-1:0] o_reg_data;
    reg o_reg_txStart;
    
    always@(*) begin
        if(i_reset) begin
            o_reg_data=8'b0;
            o_reg_txStart=0;
        end
        else begin
            if(i_rxDone) begin 
                o_reg_txStart=1;
            end
            else begin
                 o_reg_txStart=0;
            end
       end
    end
    
assign o_data=i_data;
assign o_txStart=o_reg_txStart;

    
endmodule
