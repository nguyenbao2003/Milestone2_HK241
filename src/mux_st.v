module mux_st(
	input  [31:0] rs2_data_tmp,
   input  [2:0] funct3,
   output reg [31:0] rs2_data
);

always @(*) begin
		case (funct3)
			3'b000: rs2_data = {{24{rs2_data_tmp[7]}}, rs2_data_tmp [7:0]}; //SB
			3'b001: rs2_data = {{16{rs2_data_tmp[15]}}, rs2_data_tmp [15:0]}; // SH
			3'b010: rs2_data = rs2_data_tmp; // ST
         default: rs2_data = 32'hxxxx_xxxx; // Handle invalid select value
      endcase
	end
endmodule