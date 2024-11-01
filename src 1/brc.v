module brc (
    input wire [31:0] i_rs1_data,      // First input data (A)
    input wire [31:0] i_rs2_data,      // Second input data (B)
    input wire i_br_un,          // Flag to indicate if comparison is unsigned
    input wire [31:0] ImmExtD,
	 input wire				i_slti_sel,
	 output reg o_br_less,             // Output: true if rs1_data < rs2_data
    output wire o_br_equal             // Output: true if rs1_data == rs2_data
);

    wire [31:0] eq_bits;             // Bits indicating equality for each bit position
    reg [32:0] sub_result;          // Subtraction result (33 bits to hold carry-out)
	 wire [31:0] i_rs2_data_tmp = (i_slti_sel)? ImmExtD : i_rs2_data;

    // Generate equality bits: eq_bits[i] is true if rs1_data[i] == rs2_data[i]
    assign eq_bits = ~(i_rs1_data ^ i_rs2_data_tmp);

    // br_equal is true if all bits are equal (AND reduction of eq_bits)
    assign o_br_equal = &eq_bits;

    // Combinational logic to determine less-than condition
    always @(*) begin
        // Perform subtraction using two's complement
        sub_result = {1'b0, i_rs1_data} + {1'b0, (~i_rs2_data_tmp + 1)};

        if (i_br_un) begin
            o_br_less = !sub_result[32]; // For unsigned, check MSB of the subtraction result
        end else begin
            // For signed, check sign bits and fallback to subtraction result
            o_br_less = (i_rs1_data[31] ^ i_rs2_data_tmp[31]) ? i_rs1_data[31] : sub_result[31];
        end
    end

endmodule












//module brc(
//	input 	[31:0] 	rs1_data,   // First operand
//   input 	[31:0] 	rs2_data,   // Second operand
//	input 	[31:0] 	ImmExtD,
//	input 				slti_sel,	
//   input 				br_unsigned,       // 1 if operands are unsigned, 0 if signed
//   output reg 			br_less,      // 1 if rs1_data < rs2_data
//   output reg 			br_equal      // 1 if rs1_data == rs2_data
//);
//
//	// Intermediate signal for XOR comparison result
//	wire [31:0] diff;
//	reg 			found_difference; // Flag to stop further comparisons once a difference is found
//	wire [31:0] rs2_data_tmp = (slti_sel)? ImmExtD : rs2_data;
//
//	// Calculate XOR of rs1_data and rs2_data
//	assign diff = rs1_data ^ rs2_data_tmp;
//
//	// Check if all bits are zero (if diff is zero, then equal)
//	always @(*) begin
//		br_equal = ~(|diff);  // Reduction OR to check if any bit is set
//	end
//
//	// Less-than check without using <, >, =, -
//	integer i;
//	integer j;
//	always @(*) begin
//		br_less = 1'b0;  // Default to not less
//		found_difference = 1'b0;
//
//		if (!br_unsigned) begin
//      // Signed comparison:
//      // First check sign bit (MSB), rs1 < rs2 if rs1 is negative and rs2 is positive
//			if (rs1_data[31] && ~rs2_data_tmp[31]) begin
//				br_less = 1'b1;
//			end else if (rs1_data[31] == rs2_data_tmp[31]) begin	// If sign bits are the same, proceed to bitwise comparison from MSB to LSB
////				integer i;
//				for (i = 31; i >= 0 && !found_difference; i = i - 1) begin
//					if (rs1_data[i] != rs2_data_tmp[i]) begin
//						br_less = (~rs1_data[i]) & rs2_data_tmp[i];  // rs1 is less if rs1[i] is 0 and rs2[i] is 1
//						found_difference = 1'b1;  // Set the flag to stop further comparisons
//					end
//				end
//			end
//		end else begin
//			// Unsigned comparison:
//			// Compare bit by bit from MSB to LSB
////			integer i;
//			for (j = 31; j >= 0 && !found_difference; j = j - 1) begin
//				if (rs1_data[j] != rs2_data_tmp[j]) begin
//					br_less = (~rs1_data[j]) & rs2_data_tmp[j];  // rs1 is less if rs1[i] is 0 and rs2[i] is 1
//					found_difference = 1'b1;  // Set the flag to stop further comparisons
//				end
//			end
//		end
//	end
//
//endmodule
