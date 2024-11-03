module pc_inst_debug(
	input i_clk,
	input i_rst,
	input insn_vld,
	input [31:0] pc,
	output reg o_insn_vld,
	output reg [31:0] o_pc_debug
);

	always @(posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			o_insn_vld <= 1'b0;
			o_pc_debug <= 32'b0;
		end else begin
			o_insn_vld <= insn_vld;
			o_pc_debug <= pc;
		end
	end
endmodule