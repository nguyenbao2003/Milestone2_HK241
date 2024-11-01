/* ALU Arithmetic and Logic Operations
----------------------------------------------------------------------
|ALU_Sel|   ALU Operation
----------------------------------------------------------------------
| 0000  |   ALU_Out = A + B;
----------------------------------------------------------------------
| 0001  |   ALU_Out = A - B;
----------------------------------------------------------------------
| 0010  |   ALU_Out = A * B;
----------------------------------------------------------------------
| 0011  |   ALU_Out = A / B;
----------------------------------------------------------------------
| 0100  |   ALU_Out = A << B;
----------------------------------------------------------------------
| 0101  |   ALU_Out = A >> A;
----------------------------------------------------------------------
| 0110  |   ALU_Out = A rotated left by 1;
----------------------------------------------------------------------
| 0111  |   ALU_Out = A rotated right by 1;
----------------------------------------------------------------------
| 1000  |   ALU_Out = A and B;
----------------------------------------------------------------------
| 1001  |   ALU_Out = A or B;
----------------------------------------------------------------------
| 1010  |   ALU_Out = A xor B;
----------------------------------------------------------------------
| 1011  |   ALU_Out = A nor B;
----------------------------------------------------------------------
| 1100  |   ALU_Out = A nand B;
----------------------------------------------------------------------
| 1101  |   ALU_Out = A xnor B;
----------------------------------------------------------------------
| 1110  |   ALU_Out = 1 if A>B else 0;
----------------------------------------------------------------------
| 1111  |   ALU_Out = 1 if A=B else 0;
----------------------------------------------------------------------*/

module alu(
    input		[31:0] 	i_operand_a, i_operand_b,  // rs1_data, rs2_data
	 input					op_a_sel, op_b_sel,	
	 input 		[31:0] 	pc,
	 input		[31:0] 	ImmExtD,
    input      [4:0]  	i_alu_op,  				// ALU Selection
	 input					br_less,
    output reg [31:0] 	o_alu_data,    			// ALU 32-bit Output
    output reg        	CarryOut     			// Carry Out Flag
);

   reg  [31:0]  o_alu_data_temp;
   reg  [32:0]  tmp;
	wire 	[31:0] operand_a, operand_b;
	reg [31:0] shift_temp;	

   always @(*) begin
		tmp       = {1'b0, i_operand_a} + {1'b0, i_operand_b};
      CarryOut  = tmp[32];
   end

	assign operand_a = (op_a_sel)? pc : i_operand_a;
	assign operand_b = (op_b_sel)? ImmExtD : i_operand_b;
 
	always @(*) begin
		shift_temp = operand_a; // Extend operand_a to 32-bits
	 	case(i_alu_op)
        5'b00000: o_alu_data_temp =   operand_a + operand_b;  // add
        5'b00001: o_alu_data_temp =   operand_a + ~operand_b + 1;  // sub
        5'b00010: o_alu_data_temp =   operand_a & operand_b;	  // and, andi
        5'b00011: o_alu_data_temp =   operand_a | operand_b;   // or, ori
//        5'b00100: o_alu_data_temp =   operand_a << operand_b;   // sll, sli		
		  5'b00100: begin   //sll, slli
		     if (operand_b[0]) shift_temp = {shift_temp[30:0], 1'b0};
                if (operand_b[1]) shift_temp = {shift_temp[29:0], 2'b00};
                if (operand_b[2]) shift_temp = {shift_temp[27:0], 4'b0000};
                if (operand_b[3]) shift_temp = {shift_temp[23:0], 8'b00000000};
                if (operand_b[4]) shift_temp = {shift_temp[15:0], 16'b0000000000000000};
                o_alu_data_temp = shift_temp;
        end 
        5'b00101: o_alu_data_temp =	(br_less) ? 32'd1 : 32'd0 ; // slt, slti
//		  5'b00111: o_alu_data_temp =  	operand_a >>> operand_b;    // sra, srai
		  5'b00111: begin
		     if (operand_b[0]) shift_temp = {shift_temp[31], shift_temp[31:1]};
                if (operand_b[1]) shift_temp = {{2{shift_temp[31]}}, shift_temp[31:2]};
                if (operand_b[2]) shift_temp = {{4{shift_temp[31]}}, shift_temp[31:4]};
                if (operand_b[3]) shift_temp = {{8{shift_temp[31]}}, shift_temp[31:8]};
                if (operand_b[4]) shift_temp = {{16{shift_temp[31]}}, shift_temp[31:16]};
                o_alu_data_temp = shift_temp;
		  end
        5'b01000: o_alu_data_temp =   (br_less) ? 32'd1 : 32'd0; // sltu, sltiu
        5'b01010: o_alu_data_temp =   operand_a ^ operand_b; // xor
//        5'b01011: o_alu_data_temp =  	operand_a >> operand_b; // srl, srli
        5'b01011: begin
		      if (operand_b[0]) shift_temp = {1'b0, shift_temp[31:1]};
                if (operand_b[1]) shift_temp = {2'b00, shift_temp[31:2]};
                if (operand_b[2]) shift_temp = {4'b0000, shift_temp[31:4]};
                if (operand_b[3]) shift_temp = {8'b00000000, shift_temp[31:8]};
                if (operand_b[4]) shift_temp = {16'b0000000000000000, shift_temp[31:16]};
                o_alu_data_temp = shift_temp;
		  end
		  5'b01100: o_alu_data_temp =  	operand_b; // lui
        default:  o_alu_data_temp =   32'b0;
		endcase
	end
	 
	always @(*) begin
		o_alu_data = o_alu_data_temp;
	end
    
endmodule 
