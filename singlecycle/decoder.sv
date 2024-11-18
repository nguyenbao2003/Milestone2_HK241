module decoder (
  input  logic [31:0]   instr   ,
  output logic [4:0]    rs1_addr,
  output logic [4:0]    rs2_addr,
  output logic [4:0]    rd_addr ,
  output logic [6:0]    OP      ,
  output logic [2:0]    funct3  ,
  output logic          funct7  ,
  output logic          OPb5    ,
  output logic [24:0]   imm     ,
  output logic [6:0]    funct77
);
  always_comb begin
    rs1_addr = instr[19:15];
	 rs2_addr = instr[24:20];
	 rd_addr  = instr[11:7];
	 OP       = instr[6:0];
	 OPb5	 	 = instr[5];
	 funct3   = instr[14:12];
	 funct7   = instr[30];
	 imm      = instr[31:7];
	 funct77  = instr[31:25];
  end
   
endmodule