module Address_Generator (
	input             i_rst,
	input             i_clk,
	input             br_sel,
	input      [31:0] pc_four,
   input      [31:0] pc_bru,
	output reg [31:0] pc
);
	reg [31:0] nxt_pc;

	always @(*) begin  //combinational block so block assignment (=) and not a non-blocking one (<=)
		nxt_pc = br_sel ? pc_bru : pc_four;
	end

	always @(posedge i_clk or posedge i_rst) begin //sequential block so non-block assigment (<=) is used
		if (i_rst) begin
			pc <= 32'd0;
		end
		else begin
			pc <= nxt_pc;
		end
	end 
 
endmodule