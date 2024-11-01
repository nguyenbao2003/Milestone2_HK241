module mux_load (
	input  [31:0] ld_data_tmp,
   input  [2:0] funct3,
   output reg [31:0] ld_data_1
);

	always @ (*) begin
		case (funct3)
			3'b000: ld_data_1 = {{24{ld_data_tmp[7]}}, ld_data_tmp [7:0]}; // LB
         3'b001: ld_data_1 = {{16{ld_data_tmp[15]}}, ld_data_tmp [15:0]}; // LH
         3'b010: ld_data_1 = ld_data_tmp; // lw
         3'b100: ld_data_1 = {24'b0, ld_data_tmp[7:0]}; // LBU
         3'b101: ld_data_1 = {16'b0, ld_data_tmp[15:0]}; // LHU
         default: ld_data_1 = 32'hxxxx_xxxx; // Handle invalid select value
      endcase
	end

endmodule



