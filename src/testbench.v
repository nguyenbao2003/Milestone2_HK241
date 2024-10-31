module testbench;

	reg clk_i;
	reg rst_ni;
	reg [31:0] io_sw_i;
	
//	wire [31:0] check_pc;
	wire[31:0]	o_pc_debug;
	wire 			o_insn_vld;
//	wire [31:0] 	st_data_debug;
	wire [4:0] check_alu_op;
	wire 			check_br_sel;
	wire 			check_br_equal;
//	wire [31:0] 	ld_data_debug;
	wire [31:0] 	alu_data_debug;
	wire [31:0] wb_data_debug;
	wire [31:0] instr_debug;
	wire  br_less_debug;
	wire  br_unsigned_debug;
	wire [1:0] wb_sel_debug;
	wire [31:0] o_io_ledr;
	wire[31:0] checkx1;  //it is to see x1 of file (you can ignore it if your simulator allows you to see full RF)
//   wire [31:0] checkx2;
   wire [31:0] checkx3;
	wire [6:0]	HEX0;
	wire [6:0]	HEX1;
	wire [6:0]	HEX2;
	wire [6:0]	HEX3;
//   wire [31:0] checkx4;
//	wire [31:0] checkx5;
	
	singlecycle dut3(
		.clk_i (clk_i),
		.rst_ni (rst_ni),
//		.check_pc (check_pc),
		.o_pc_debug (o_pc_debug),
		.o_insn_vld (o_insn_vld),
//		.st_data_debug (st_data_debug),
		.check_br_sel (check_br_sel),
		.check_br_equal (check_br_equal),
		.check_alu_op (check_alu_op),
//		.ld_data_debug (ld_data_debug),
		.alu_data_debug (alu_data_debug),
		.wb_data_debug (wb_data_debug),
		.instr_debug (instr_debug),
		.br_less_debug (br_less_debug),
		.br_unsigned_debug (br_unsigned_debug),
		.wb_sel_debug (wb_sel_debug),
		.o_io_ledr (o_io_ledr),
		.checkx1 (checkx1),
//		.checkx2 (checkx2),
		.checkx3 (checkx3)
//		.checkx4 (checkx4),
//		.checkx5 (checkx5)
	);
	
	// Clock Generation
	initial begin
		clk_i = 0;
		forever #20 clk_i = ~clk_i;  // 40 ns period
	end
	
	initial begin
		rst_ni = 0;
		io_sw_i = 0;
		@(posedge clk_i);
		rst_ni = 1;
//		io_sw_i = 32'hFF;
		#3000;
		
		$stop;
	end
endmodule