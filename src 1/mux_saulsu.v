module mux_saulsu(
	input 		[31:0] 	pc_four,
	input 		[31:0] 	alu_data,
	input 		[31:0] 	ld_data_2,
	input 		[1:0] 	wb_sel,
	output reg 	[31:0] 	wb_data
);

	always @(*) begin
		case (wb_sel)
			2'b00: 	wb_data 	= alu_data;
			2'b01: 	wb_data 	= ld_data_2;
			default: wb_data 	= pc_four;
		endcase
	end
endmodule	