module LSU_tb;

	reg clk_i;    // clock input
	reg rst_ni;   // reset (active low)	
	reg st_en;    // mem_wren (store enable for writes)
	reg [31:0]	st_data;  // rs2_data (data to be written)
	reg [31:0] 	addr;		// alu_data (memory address)	
	wire 	[31:0] 	ld_data;   // load data (output to CPU for lw)
	// I/O Peripheral ports
	reg [31:0] 	io_sw;     // 32-bit switch inputs
	wire [31:0] 	io_btn;    // 32-bit button inputs (optional)
	wire 	[31:0] 	io_hex0;   // 7-segment LED outputs
	wire 	[31:0] 	io_hex1;
	wire 	[31:0] 	io_hex2;
	wire 	[31:0] 	io_hex3;
	wire 	[31:0] 	io_hex4;
	wire 	[31:0] 	io_hex5;
	wire 	[31:0] 	io_hex6;
	wire 	[31:0] 	io_hex7;
	wire 	[31:0] 	io_ledg;   // 32-bit Green LED outputs
	wire 	[31:0] 	io_ledr;   // 32-bit Red LED outputs
	wire 	[31:0] 	io_lcd;	   // 32-bit LCD data output
	
	LSU dut2(
		.st_data (st_data	),
		.addr 	(addr),
		.clk_i 	(clk_i	),
		.st_en 	(st_en	),
		.rst_ni 	(rst_ni	),
		.io_sw 	(io_sw_i	),
		.io_hex0 (io_hex0),
		.io_hex1 (io_hex1),
		.io_hex2 (io_hex2),
		.io_hex3 (io_hex3),
		.io_hex4 (io_hex4),
		.io_hex5 (io_hex5),
		.io_hex6 (io_hex6),
		.io_hex7 (io_hex7),
		.io_ledg (io_ledg),
		.io_ledr (io_ledr),
		.io_lcd 	(io_lcd),
		.ld_data (ld_data)
	);
	
	// Clock Generation
	initial begin
		clk_i = 0;
		forever #20 clk_i = ~clk_i;  // 40 ns period
	end
	
	initial begin
		st_data = 32'b0;
		addr = 32'b0;
		st_en = 0;
		io_sw = 32'b0;
		rst_ni = 0;
		
		
		// Test case 1: Check initial value
		@(posedge clk_i);
		#1;
		$display ("=============================== Check initial value =======================================");
		if (io_hex0 != 32'h0) begin
			$display ("Fail. Expect: 32'h0. Actual io_hex0: %0h", io_hex0);
		end else begin
			$display ("Pass. Output io_hex0 is %0h", io_hex0);
		end
		
		#1;
		if (io_hex1 != 32'h0) begin
			$display ("Fail. Expect: 32'h0. Actual io_hex1: %0h", io_hex1);
		end else begin
			$display ("Pass. Output io_hex1 is %0h", io_hex1);
		end
		
		#1;
		if (io_hex2 != 32'h0) begin
			$display ("Fail. Expect: 32'h0. Actual io_hex2: %0h", io_hex2);
		end else begin
			$display ("Pass. Output io_hex2 is %0h", io_hex2);
		end
		
		#1;
		if (io_hex3 != 32'h0) begin
			$display ("Fail. Expect: 32'h0. Actual io_hex3: %0h", io_hex3);
		end else begin
			$display ("Pass. Output io_hex3 is %0h", io_hex3);
		end
		
		#1;
		if (io_ledg != 32'h0) begin
			$display ("Fail. Expect: 32'h0. Actual io_ledg: %0h", io_ledg);
		end else begin
			$display ("Pass. Output io_ledg is %0h", io_ledg);
		end
		
		#1;
		if (io_ledr != 32'h0) begin
			$display ("Fail. Expect: 32'h0. Actual io_ledr: %0h", io_ledr);
		end else begin
			$display ("Pass. Output io_ledr is %0h", io_ledr);
		end
		
		#1;
		if (io_lcd != 32'h0) begin
			$display ("Fail. Expect: 32'h0. Actual io_lcd: %0h", io_lcd);
		end else begin
			$display ("Pass. Output io_lcd is %0h", io_lcd);
		end
		
		// Test case 2: Check store and load value
		
		$display ("=============================== Check load-store =======================================");
//		@(posedge clk_i);
//		rst_ni = 1;
//		st_en = 1;
//		addr = 32'h7000;
//		st_data = 32'h8;
//		
//		@(posedge clk_i);
//		st_en = 0;
//		addr = 32'h7000;
//		
//		#1;
//		if (ld_data != 32'h8) begin
//			$display ("Fail. Expect: 32'h8. Actual ld_data: %0h", ld_data);
//		end else begin
//			$display ("Pass. Output ld_data is %0h", ld_data);
//		end
		
		@(posedge clk_i);
		rst_ni = 1;
		st_en = 1;
		addr = 32'h3000;
		st_data = 32'h8;
		
		@(posedge clk_i);
		st_en = 0;
		addr = 32'h3000;
		
		#1;
		if (ld_data != 32'h8) begin
			$display ("Fail. Expect: 32'h8. Actual ld_data: %0h", ld_data);
		end else begin
			$display ("Pass. Output ld_data is %0h", ld_data);
		end
		#100;
		$stop;
	end
endmodule