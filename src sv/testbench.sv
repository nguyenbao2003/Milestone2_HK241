module testbench;

	reg i_clk;
	reg i_rst;
	reg [31:0] io_sw_i;
	
//	wire [31:0] check_pc;
//	wire[31:0]	o_pc_debug;
//	wire 			o_insn_vld;
//	wire [31:0] 	st_data_debug;
	wire [4:0] check_alu_op;
	wire 			check_br_sel;
	wire 			check_br_equal;
//	wire [31:0] 	ld_data_debug;
//	wire [31:0] 	alu_data_debug;
	wire [31:0] wb_data_debug;
	wire [31:0] instr_debug;
	wire  br_less_debug;
	wire  br_unsigned_debug;
	wire [1:0] wb_sel_debug;
	wire [31:0] o_io_ledr;
	wire [6:0] HEX0;
	wire [6:0] HEX1;
	wire [6:0] HEX2;
	wire [6:0] HEX3;
	wire [6:0] HEX4;
	wire [6:0] HEX5;
	wire [6:0] HEX6;
	wire [6:0] HEX7;
	wire[31:0] checkx1;  //it is to see x1 of file (you can ignore it if your simulator allows you to see full RF)
   wire [31:0] checkx2;
   wire [31:0] checkx3;
	wire [6:0] o_io_hex0;
	wire [6:0] o_io_hex1;
//	wire [6:0] o_io_hex2;
//	wire [6:0] o_io_hex3;
//	wire [6:0] o_io_hex4;
//	wire [6:0] o_io_hex5;
//	wire [6:0] o_io_hex6;
//	wire [6:0] o_io_hex7;
//   wire [31:0] checkx4;
//	wire [31:0] checkx5;
	
	singlecycle dut3(
		.i_clk (i_clk),
		.i_rst (i_rst),
//		.check_pc (check_pc),
//		.o_pc_debug (o_pc_debug),
//		.o_insn_vld (o_insn_vld),
//		.st_data_debug (st_data_debug),
		.check_br_sel (check_br_sel),
		.check_br_equal (check_br_equal),
		.check_alu_op (check_alu_op),
//		.ld_data_debug (ld_data_debug),
//		.alu_data_debug (alu_data_debug),
		.wb_data_debug (wb_data_debug),
		.instr_debug (instr_debug),
		.br_less_debug (br_less_debug),
		.br_unsigned_debug (br_unsigned_debug),
		.wb_sel_debug (wb_sel_debug),
		.o_io_ledr (o_io_ledr),
		.HEX0 (HEX0),
		.HEX1 (HEX1),
		.HEX2 (HEX2),
		.HEX3 (HEX3),
		.HEX4 (HEX4),
		.HEX5 (HEX5),
		.HEX6 (HEX6),
		.HEX7 (HEX7),
		.o_io_hex0 (o_io_hex0),
		.o_io_hex1 (o_io_hex1),
//		.o_io_hex2 (o_io_hex2),
//		.o_io_hex3 (o_io_hex3),
//		.o_io_hex4 (o_io_hex4),
//		.o_io_hex5 (o_io_hex5),
//		.o_io_hex6 (o_io_hex6),
//		.o_io_hex7 (o_io_hex7),
		.checkx1 (checkx1),
		.checkx2 (checkx2),
		.checkx3 (checkx3)
//		.checkx4 (checkx4),
//		.checkx5 (checkx5)
	);
	
	// Clock Generation
	initial begin
		i_clk = 0;
		forever #15 i_clk = ~i_clk;  // 40 ns period
	end
	
	initial begin
		i_rst = 1;
		io_sw_i = 0;
		@(posedge i_clk);
		i_rst = 0;
//		io_sw_i = 32'hFF;
//		#100;
//		io_sw_i = 1;
//		#40;
//		io_sw_i = 0;
		#8000;
		
		$stop;
	end
endmodule