
module Controller (
	input wire     [31:0]instr,
	input      [6:0] OP,
	input      [6:0] funct77,
	input      [2:0] funct3,
	input            funct7,
	input					OPb5,
	input 				br_less,
	input 				br_equal,
	output reg       	mem_wren,
	output reg       	rd_wren,
	output reg 			op_a_sel,
	output reg 			op_b_sel,
	output reg 			br_sel,
	output reg	 		br_unsigned,
	output reg 			slti_sel,
	output reg 			insn_vld,
	output reg [4:0] 	alu_op,
	output reg [1:0] 	wb_sel,
	output reg [2:0] 	ImmSel
);
    
	reg [1:0]	alu_control;
	reg 			br_sel_tmp;

	
	// Check instruction valid
	always @(*) begin
		if (instr == 32'b0) begin
			insn_vld = 0;  // Instruction is invalid if it's all zeros
		end else begin
			// Check if the opcode matches one of the valid opcodes
			case (OP)
				7'b0000011: insn_vld = 1; // lw
				7'b0100011: insn_vld = 1; // sw
				7'b0110011: insn_vld = 1; // R-type
				7'b1100011: insn_vld = 1; // branch
				7'b0010011: insn_vld = 1; // I-type
				7'b1101111: insn_vld = 1; // j
				7'b1100111: insn_vld = 1; // jalr
				7'b0110111: insn_vld = 1; // lui
				7'b0010111: insn_vld = 1; // auipc
            default: insn_vld = 0;  // Invalid instruction if opcode doesn't match
			endcase
		end
	end
	
	
	always @(*) begin 
		if (OP == 7'b1100011) begin
			case(funct3)
			3'b000:   br_unsigned =  0; //beq
			3'b001:   br_unsigned =  0; //bne
			3'b100:   br_unsigned =  0;  //blt
			3'b101:   br_unsigned =  0;  //bge
			3'b110:   br_unsigned =  1;  //bltu
			3'b111:   br_unsigned =  1; //bgeu
			default : br_unsigned =  0;
			endcase
		end else if (OP == 7'b0110011) begin
			case(funct3)
			3'b010:   br_unsigned =  0; // slt
			3'b011:   br_unsigned =  1; // sltu
			default: br_unsigned = 0;
			endcase
		end else if (OP == 7'b0010011) begin
			case(funct3)
			3'b010: begin
				slti_sel = 1;
				br_unsigned = 0;	// slti
				end
			3'b011: begin
				slti_sel = 1;
				br_unsigned = 1;	// sltiu
				end
			default: begin
				slti_sel = 0;
				br_unsigned = 0;
				end
			endcase
		end else begin
			br_unsigned = 0;
		end
	end	
		
	always @(*) begin
		case(funct3)
			3'b000:   br_sel_tmp = (br_equal)? 1 : 0; //beq
			3'b001:   br_sel_tmp = (~br_equal)? 1 : 0; //bne
			3'b100:   br_sel_tmp = (br_less)? 1 : 0;  //blt
			3'b101:   br_sel_tmp = (!br_less | br_equal)? 1: 0;  //bge
			3'b110:   br_sel_tmp = (br_less)? 1 :0;  //bltu
			3'b111:   br_sel_tmp = (!br_less | br_equal)? 1: 0; //bgeu
			default : br_sel_tmp =  1'b0;
		endcase
	end
	 
	always @ (*) begin
		casex (OP)
			7'b0000011: begin        //lw
				mem_wren = 1'b0;
				rd_wren = 1'b1;
				op_a_sel = 1'b0;
				op_b_sel = 1'b1;
				br_sel = 1'b0;
				wb_sel = 2'b01;
				alu_control= 2'b00;
				ImmSel    = 3'b000;
	end 

			7'b0100011: begin  //sw
				mem_wren = 1'b1;
				rd_wren = 1'b0;
				op_a_sel = 1'b0;
				op_b_sel = 1'b1;
				br_sel = 1'b0;
				wb_sel = 2'bxx;
				alu_control= 2'b00;
				ImmSel    = 3'b001;
			end

			7'b0110011: begin  //R-type
				mem_wren = 1'b0;
				rd_wren = 1'b1;
				op_a_sel = 1'b0;
				op_b_sel = 1'b0;
				br_sel = 1'b0;
				wb_sel = 2'b00;
				alu_control= 2'b10;
				ImmSel    = 3'bxxx;
			end

			7'b1100011: begin  //branch
				mem_wren = 1'b0;
				rd_wren = 1'b0;
				op_a_sel = 1'b1;
				op_b_sel = 1'b1;
				br_sel = br_sel_tmp;
				wb_sel = 2'bxx;
				alu_control= 2'b00; // add
				ImmSel    = 3'b010;
			end

			7'b0010011: begin  //I-Type
				mem_wren = 1'b0;
				rd_wren = 1'b1;
				op_a_sel = 1'b0;
				op_b_sel = 1'b1;
				br_sel = 1'b0;
				wb_sel = 2'b00;
				alu_control= 2'b10;
				ImmSel    = 3'b000;
			end
            
			7'b1101111: begin //j
				mem_wren = 1'b0;
				rd_wren = 1'b1;
				op_a_sel = 1'b1;
				op_b_sel = 1'b1;
				br_sel = 1'b1;
				wb_sel = 2'b11;
				alu_control= 2'b11;
				ImmSel    = 3'b011;
			end
				
			7'b1100111: begin //jalr
				mem_wren = 1'b0;	
				rd_wren = 1'b1;
				op_a_sel = 1'b0;
				op_b_sel = 1'b1;
				br_sel = 1'b1;
				wb_sel = 2'b11;
				alu_control= 2'b11;
				ImmSel    = 3'b000;
         end
         
			7'b0110111: begin //LUI
				mem_wren = 1'b0;
				rd_wren = 1'b1;
				op_a_sel = 1'bx;
				op_b_sel = 1'b1;
				br_sel = 1'b0;
				wb_sel = 2'b00;
				alu_control= 2'b01;
				ImmSel = 3'b100;
			end
			
			7'b0010111: begin //AUIPC
				mem_wren = 1'b0;
				rd_wren = 1'b1;
				op_a_sel = 1'b1;
				op_b_sel = 1'b1;
				br_sel = 1'b0;
				wb_sel = 2'b00;
				alu_control= 2'b00;
				ImmSel = 3'b100;
			end 
                
			default: begin
				mem_wren = 1'b0;
				rd_wren = 1'b0;
				op_a_sel = 1'bx;
				op_b_sel = 1'bx;
				br_sel = 1'b0;
				wb_sel = 2'bxx;
				alu_control= 2'b00;
				ImmSel    = 3'b000;
			end 
		endcase
	end
	
	wire RtypeSub;
	assign RtypeSub = funct7 & OPb5; // TRUE for R-type subtract
	
	always @ (*) begin
		case(alu_control)
		2'b00: alu_op = 5'b00000; // addition // lw // auipc
		2'b01: alu_op = 5'b01100; // lui
		2'b11: alu_op = 5'b00000; // jal, jalr
		default: 
			case(funct3) // R–type or I–type ALU
			3'b000: 
				if (RtypeSub)
					alu_op = 5'b00001; // sub, done
				else
					alu_op = 5'b00000; // add, addi , done
			3'b001: alu_op = 5'b00100; // sll, slli, done
			3'b010: alu_op = 5'b00101; // slt, slti, done
			3'b011: alu_op = 5'b01000; // sltu, sltiu
			3'b100: alu_op = 5'b01010; // xor, xori, done
			3'b101: 
				if (~funct7)
					alu_op = 5'b01011;	// srl, srli , done
				else
					alu_op = 5'b00111;  // sra, srai done
			3'b110: alu_op = 5'b00011; // or, ori, done
			3'b111: alu_op = 5'b00010; // and, andi, done
			default: alu_op = 5'bxxxxx; // ???
			endcase
		endcase
	end
endmodule