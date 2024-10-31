module PCPlus4 (
	input      [31:0] pc,
	output reg [31:0] pc_four
);
	always @(*) begin
		pc_four = pc + 4;
	end

endmodule