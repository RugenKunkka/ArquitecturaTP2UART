`timescale 1ns / 1ps

module ALU
    // Parameters 
    #(
        parameter   p_dataLength = 4,//32
                    p_operatorsInputSize = 4 
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

reg signed [p_dataLength-1:0]o_reg_ALUResult;
// Continuous Assignments
//assign o_Zero = (o_ALUResult == {p_operatorsInputSize{1'b0}} ) ? 1'b1 : 1'b0;
 
// Procedural Blocks
  always @(i_A or i_B or i_ALUBitsControl) begin
    case (i_ALUBitsControl)
      4'b0001: o_reg_ALUResult = i_A + i_B;   // ADD suma  
      4'b0010: o_reg_ALUResult = i_A - i_B;   // SUB resta
      4'b0011: o_reg_ALUResult = i_A & i_B;   // AND 
      4'b0101: o_reg_ALUResult = i_A | i_B;   // OR
      4'b0111: o_reg_ALUResult = i_A ^ i_B;   // XOR
      4'b1000: o_reg_ALUResult = (i_A >>> i_B);   // SRA (Shift Right Arithmetic)
      4'b1100: o_reg_ALUResult = (i_A >> i_B);    // SRL (Shift Right Logical)
      4'b1110: o_reg_ALUResult = ~(i_A | i_B);   // NOR
      default: o_reg_ALUResult = {p_dataLength{1'b0}};//JAMAS OLVIDARES EL DEFAULT!!!!! si uno se lo olvida, el sintetizador hace cualquier cosa.. crea compuertas flipflops etc.. No queremos un comportamiento an?malo
    endcase
  end
assign o_ALUResult=o_reg_ALUResult;
endmodule
