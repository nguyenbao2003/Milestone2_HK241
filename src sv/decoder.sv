module decoder (
	input      [31:0] instr,
	output reg [4:0]  rs1_addr,
	output reg [4:0]  rs2_addr,
	output reg [4:0]  rd_addr,
	output reg [6:0]  OP,
	output reg [2:0]  funct3,
	output reg        funct7,
	output reg        OPb5,
	output reg [24:0] imm,
	output reg [6:0]  funct77
);
	always @(*) begin
		rs1_addr	= instr[19:15];
		rs2_addr	= instr[24:20];
		rd_addr  = instr[11:7];
		OP      	= instr[6:0];
		OPb5	 	= instr[5];
		funct3  	= instr[14:12];
		funct7  	= instr[30];
		imm     	= instr[31:7];
		funct77 	= instr[31:25];
    end
    
endmodule