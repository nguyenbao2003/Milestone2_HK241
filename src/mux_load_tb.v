module mux_load_tb;

	reg [31:0] ld_data_tmp;
   reg [2:0] funct3;
   wire [31:0] ld_data_1;
	
	mux_load dut1(
		.ld_data_tmp (ld_data_tmp),
		.funct3 (funct3),
		.ld_data_1 (ld_data_1)
	);
	
	
	initial begin
		ld_data_tmp = 32'b0;
		funct3 = 3'b000;
		
		#20;
		funct3 = 3'b001;
		ld_data_tmp = 32'h1000_F0EE;
		#1;
		if (ld_data_1 != 32'hFFFF_F0EE) begin
			$display ("Fail. Expect: 32'hFFFF_F0EE. But, actual: %h", ld_data_1);
			#100;
			$stop;
		end else begin
			$display ("Pass. Output is %0h", ld_data_1);
		end
		
		#20;
		funct3 = 3'b100;
		ld_data_tmp = 32'h1000_F0EE;
		#1;
		if (ld_data_1 != 32'h000_00EE) begin
			$display ("Fail. Expect: 332'h000_00EE. But, actual: %h", ld_data_1);
			#100;
			$stop;
		end else begin
			$display ("Pass. Output is %0h", ld_data_1);
		end
		#100;
		$stop;
	end
endmodule