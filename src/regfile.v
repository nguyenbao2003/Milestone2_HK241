module regfile (
	input      [4:0]  i_rs1_addr,
	input      [4:0]  i_rs2_addr,
	input      [4:0]  i_rd_addr,
	input      [31:0] i_rd_data,
	input             i_clk,
	input             i_rd_wren,
	input             i_rst,
	output reg [31:0] o_rs1_data,
	output reg [31:0] o_rs2_data,
	output reg [31:0] checkx1,  //it is to see x1 of register file (you can ignore it if your simulator allows you to see full RF)
	output reg [31:0] checkx2,
	output reg [31:0] checkx3,
	output reg [31:0] checkx4,
	output reg [31:0] checkx5,
	output reg [31:0] checkx6,
	output reg [31:0] checkx7
);
	reg [31:0] Registers[31:0];
	integer j;

	always @(*) begin
		o_rs1_data = Registers[i_rs1_addr];
		o_rs2_data = Registers[i_rs2_addr];
		  
		checkx1 = Registers[1];
      checkx2 = Registers[2];
      checkx3 = Registers[3];
      checkx4 = Registers[4];
      checkx5 = Registers[5];
      checkx6 = Registers[6];
		checkx7 = Registers[7];
    end

    always @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            for(j = 0; j < 32;j = j + 1) begin
                Registers[j] <= 32'd0;
            end

        end else if (i_rd_wren && (|i_rd_addr)) begin    //i_rd_addr, avoid writing at x0
            Registers[i_rd_addr] <= i_rd_data;
        end
    end
    
endmodule