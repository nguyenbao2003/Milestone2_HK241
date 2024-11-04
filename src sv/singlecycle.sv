module singlecycle(
	input i_clk,
	input i_rst,
	input [31:0] i_io_sw,
	
//	output wire [31:0] check_pc,
	output wire [31:0]	o_pc_debug,
	output wire 			o_insn_vld,
//	output wire [31:0] 	st_data_debug,
//	output wire [31:0] 	ld_data_debug,
//	output wire [31:0] 	ld_data_debug_1,
//	output wire [31:0] 	alu_data_debug,
//	output wire [31:0] 	o_io_lcd,
	output wire [31:0] 	o_io_ledg,
	output wire [31:0]	o_io_ledr,
	output wire [6:0]	o_io_hex0,
	output wire [6:0]	o_io_hex1,
//	output wire [6:0]	o_io_hex2,
//	output wire [6:0]	o_io_hex3,
//	output wire [6:0]	o_io_hex4,
//	output wire [6:0]	o_io_hex5,
//	output wire [6:0]	o_io_hex6,
//	output wire [6:0]	o_io_hex7,
//mo ra la nhu cu
	output wire [6:0]	HEX0,
	output wire [6:0]	HEX1,
	output wire [6:0]	HEX2,
	output wire [6:0]	HEX3,
	output wire [6:0]	HEX4,
	output wire [6:0]	HEX5,
	output wire [6:0]	HEX6,
	output wire [6:0]	HEX7,
	 
	 // Checker for testbench
	 output wire check_br_sel,
	 output wire check_br_equal,
	 output wire [4:0] check_alu_op,
	 output wire [31:0] wb_data_debug,
	 output wire [31:0] instr_debug,
	 output wire  br_less_debug,
	 output wire  br_unsigned_debug,
	 output wire [1:0] wb_sel_debug,
	 output wire[31:0] checkx1,  //it is to see x1 of file (you can ignore it if your simulator allows you to see full RF)
    output wire [31:0] checkx2,
    output wire [31:0] checkx3
//    output wire [31:0] checkx4,
//    output wire [31:0] checkx5
//    output wire [31:0] checkx6,
//	 output wire [31:0] checkx7
);

//	wire [6:0]	o_io_hex0;
//	wire [6:0]	o_io_hex1;
	wire [6:0]	o_io_hex2;
	wire [6:0]	o_io_hex3;
	wire [6:0]	o_io_hex4;
	wire [6:0]	o_io_hex5;
	wire [6:0]	o_io_hex6;
	wire [6:0]	o_io_hex7;

//	wire [31:0] check_pc;
//	wire [31:0] checkx1;
//	wire [31:0] checkx2;
//	wire [31:0] checkx3;
	wire [31:0] checkx4;
	wire [31:0] checkx5;
	
	
	
	wire 			br_sel;
	wire [31:0] pc, pc_four, pc_bru;
	wire [31:0]	instr;
	wire [4:0] 	rs1_addr, rs2_addr, rd_addr;
	wire [31:0] i_operand_a, i_operand_b;
	wire [31:0] o_alu_data;
	wire [6:0] 	OP;
	wire [2:0] 	funct3;
	wire 			funct7, OPb5;
	wire [24:0] imm;
	wire [6:0] 	funct77;
	wire 			rd_wren;
	wire [31:0] rs1_data, rs2_data, st_data;
	wire [2:0] 	ImmSel;
	wire [31:0] ImmExtD;
	wire 			br_unsigned, br_less, br_equal;
	wire 			mem_wren;
	wire 			op_a_sel, op_b_sel;
	wire [3:0] 	alu_op;
	wire [1:0]	wb_sel;
	wire [31:0] alu_data, addr, wb_data;
	wire [31:0] io_sw;
	wire [31:0] io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7;
	wire [31:0] ld_data, io_lcd, io_ledg, io_ledr;
	wire 			slti_sel;
	wire 			insn_vld;
//	wire [31:0] rs2_data_tmp;
//	wire [31:0] ld_data_tmp;
//	wire [31:0] ld_data_1;
	wire [31:0] ld_data_2;
	
	
	//cainaylahexled
	wire [6:0] io_hex0_o, io_hex1_o,io_hex2_o,io_hex3_o,io_hex4_o,io_hex5_o,io_hex6_o, io_hex7_o;
	
	assign wb_data_debug = wb_data;
	assign instr_debug = instr;
	assign br_less_debug = br_less;
	assign br_unsigned_debug = br_unsigned;
	assign wb_sel_debug = wb_sel;
//	assign st_data_debug = st_data;
//	assign ld_data_debug = ld_data; // sau LSU
//	assign ld_data_debug_1 = ld_data;	// sau MUX LOAD
//	assign alu_data_debug = alu_data;
//	assign check_pc = pc;
	assign check_alu_op = alu_op;
	assign check_br_sel = br_sel;
	assign check_br_equal = br_equal;
	
	
	
	
	
	Address_Generator u0(
		.i_rst	(i_rst		),
		.i_clk	(i_clk		),
		.br_sel	(br_sel		),
		.pc_four	(pc_four		),
		.pc_bru	(alu_data	),	
		.pc		(pc			)
	);
	
	PCPlus4 u1(
		.pc 		(pc		),
		.pc_four (pc_four	)
	);
	
	I$ u2(
//		.i_clk	(i_clk	),
//		.i_rst 	(i_rst	),
		.pc 		(pc		),
		.instr	(instr	)
	);
	
	decoder u3(
		.instr 	(instr	),
		.rs1_addr(rs1_addr),
		.rs2_addr(rs2_addr),
		.rd_addr	(rd_addr	),
		.OP		(OP		),
		.funct3 	(funct3	),
		.funct7 	(funct7	),
		.OPb5 	(OPb5		),
		.imm 		(imm		),
		.funct77 (funct77	)
	);
	
	regfile u4(
		.i_rs1_addr(rs1_addr),
		.i_rs2_addr(rs2_addr),
		.i_rd_addr	(rd_addr	),
		.i_rd_data	(wb_data	),
		.i_clk 	(i_clk	),
		.i_rd_wren (rd_wren	),
		.i_rst 	(i_rst	),
		.o_rs1_data(rs1_data),
		.o_rs2_data(rs2_data),
		.checkx1 (checkx1	),
		.checkx2 (checkx2	),
//		.checkx4 (checkx4	),
		.checkx3 (checkx3	)
//		.checkx5 (checkx5	)
//		.checkx6 (checkx6	),
//		.checkx7 (checkx7	)
	);
	
	ImmGen u5(
		.imm		(imm		),
		.ImmSel 	(ImmSel	),
		.ImmExtD (ImmExtD	)
	);
	
	brc u6(
		.i_rs1_data 	(rs1_data	),
		.i_rs2_data 	(rs2_data	),
		.ImmExtD		(ImmExtD		),
		.i_slti_sel 	(slti_sel	),
		.i_br_un(br_unsigned),
		.o_br_less 	(br_less		),
		.o_br_equal 	(br_equal	)
	);
	
	Controller u7(
		.OP				(OP			),
		.instr 			(instr		),
		.funct3 			(funct3		),
		.funct7 			(funct7		),
		.OPb5 			(OPb5			),
		.br_less 		(br_less		),
		.br_equal 		(br_equal	),
		.mem_wren 		(mem_wren	),
		.rd_wren 		(rd_wren		),
		.op_a_sel 		(op_a_sel	),
		.op_b_sel 		(op_b_sel	),
		.br_sel 			(br_sel		),
		.br_unsigned	(br_unsigned),
		.slti_sel		(slti_sel	),
		.insn_vld 		(insn_vld	),
		.alu_op 			(alu_op		),
		.wb_sel 			(wb_sel		),
		.ImmSel 			(ImmSel		)
	);
	
	alu u8(
		.i_operand_a 	(rs1_data),
		.i_operand_b 	(rs2_data),
		.op_a_sel 	(op_a_sel),
		.op_b_sel 	(op_b_sel),
		.pc 			(pc		),
		.ImmExtD		(ImmExtD	),
		.i_alu_op 		(alu_op	),
		.br_less 	(br_less	),
		.o_alu_data 	(alu_data)
	);
	
	lsu u9(
		.i_st_data (rs2_data	),
		.i_lsu_addr 	(alu_data	),
		.i_clk 	(i_clk		),
		.i_lsu_wren 	(mem_wren	),
		.i_rst 	(i_rst		),
		.funct3	(funct3		),
		.i_io_sw 	(i_io_sw		),
		.o_io_hex0 (o_io_hex0	),
		.o_io_hex1 (o_io_hex1	),
		.o_io_hex2 (o_io_hex2	),
		.o_io_hex3 (o_io_hex3	),
		.o_io_hex4 (o_io_hex4	),
		.o_io_hex5 (o_io_hex5	),
		.o_io_hex6 (o_io_hex6	),
		.o_io_hex7 (o_io_hex7	),
//		.o_io_hex0 (HEX0	),
//		.o_io_hex1 (HEX1	),
//		.o_io_hex2 (HEX2	),
//		.o_io_hex3 (HEX3	),
//		.o_io_hex4 (HEX4	),
//		.o_io_hex5 (HEX5	),
//		.o_io_hex6 (HEX6	),
//		.o_io_hex7 (HEX7  ),
		.o_io_ledg (o_io_ledg	),
		.o_io_ledr (o_io_ledr	),
//		.o_io_lcd 	(o_io_lcd	),
		.o_ld_data (ld_data)
	);
	
	mux_1 u10(
		.pc_four (pc_four	),
		.alu_data(alu_data),
		.ld_data_2 (ld_data),
		.wb_sel 	(wb_sel	),
		.wb_data (wb_data	)
	);
	
	pc_inst_debug u11(
		.i_clk (i_clk),
		.i_rst (i_rst),
		.insn_vld (insn_vld),
		.pc (pc),
		.o_insn_vld (o_insn_vld),
		.o_pc_debug (o_pc_debug)
	);
	
	//cainaycualed7doanxoaduoc
	
	seven_led abc(
	.io_hex0_o (o_io_hex0),
	.io_hex1_o (o_io_hex1),
	.io_hex2_o (o_io_hex2),
	.io_hex3_o (o_io_hex3),
	.io_hex4_o (o_io_hex4),
	.io_hex5_o (o_io_hex5),
	.io_hex6_o (o_io_hex6),
	.io_hex7_o (o_io_hex7),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3),
	.HEX4(HEX4),
	.HEX5(HEX5),
	.HEX6(HEX6),
	.HEX7(HEX7)
	);
//	mux_st u12(
//		.rs2_data_tmp (rs2_data),
//		.funct3 	(funct3),
//		.rs2_data (st_data)
//	);
//	
//	mux_load u13(
//		.ld_data_tmp (ld_data_tmp),
//		.funct3 	(funct3),
//		.ld_data_1 (ld_data)
//	);
	
endmodule