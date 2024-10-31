module pc_inst_debug(
	input clk_i,
	input rst_ni,
	input insn_vld,
	input [31:0] pc,
	output reg o_insn_vld,
	output reg [31:0] o_pc_debug
);

	always @(posedge clk_i or negedge rst_ni) begin
		if (!rst_ni) begin
			o_insn_vld <= 1'b0;
			o_pc_debug <= 32'b0;
		end else begin
			o_insn_vld <= insn_vld;
			o_pc_debug <= pc;
		end
	end
endmodule