`timescale 1ns / 1ps

module ALU
    // Parameters 
    #(
        parameter   p_dataLength = 8,//32
                    p_operatorsInputSize = 6 
    )
    // Ports
    (
        // Input Ports
        input wire signed [p_dataLength-1:0] i_A,
        input wire signed [p_dataLength-1:0] i_B,
        input wire [p_operatorsInputSize-1:0] i_ALUBitsControl,
  
        // Output Ports
        output wire signed [p_dataLength-1:0] o_ALUResult
        //output wire o_Zero
    );
    //interfaz
    /*
    i_A,
    i_B,
    i_ALUBitsControl,
    
    o_ALUResult
    */

reg signed [p_dataLength-1:0]o_reg_ALUResult;
// Continuous Assignments
//assign o_Zero = (o_ALUResult == {p_operatorsInputSize{1'b0}} ) ? 1'b1 : 1'b0;
 
// Procedural Blocks
  always @(i_A or i_B or i_ALUBitsControl) begin
    case (i_ALUBitsControl)
      6'b100000: o_reg_ALUResult = i_A + i_B;   // ADD suma  
      6'b100010: o_reg_ALUResult = i_A - i_B;   // SUB resta
      6'b100100: o_reg_ALUResult = i_A & i_B;   // AND 
      6'b100101: o_reg_ALUResult = i_A | i_B;   // OR
      6'b100110: o_reg_ALUResult = i_A ^ i_B;   // XOR
      6'b000011: o_reg_ALUResult = (i_A >>> i_B);   // SRA (Shift Right Arithmetic)
      6'b000010: o_reg_ALUResult = (i_A >> i_B);    // SRL (Shift Right Logical)
      6'b100111: o_reg_ALUResult = ~(i_A | i_B);   // NOR
      default: o_reg_ALUResult = {p_dataLength{1'b0}};//JAMAS OLVIDARES EL DEFAULT!!!!! si uno se lo olvida, el sintetizador hace cualquier cosa.. crea compuertas flipflops etc.. No queremos un comportamiento an?malo
    endcase
  end
assign o_ALUResult=o_reg_ALUResult;
endmodule
