module mux_st_tb;

	reg [31:0] rs2_data_tmp;
   reg [2:0] funct3;
   wire [31:0] rs2_data;
	
	mux_st dut(
		.rs2_data_tmp (rs2_data_tmp),
		.funct3 (funct3),
		.rs2_data (rs2_data)
	);
	
	
	initial begin
		rs2_data_tmp = 32'b0;
		funct3 = 3'b000;
		
		#20;
		funct3 = 3'b001;
		rs2_data_tmp = 32'h1000_F0EE;
		#1;
		if (rs2_data != 32'hFFFF_F0EE) begin
			$display ("Fail");
		end else begin
			$display ("Pass. Output is %0h", rs2_data);
			#100;
		end
		$stop;
	end
endmodule