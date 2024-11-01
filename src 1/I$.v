module I$ (
	input 				i_clk,
	input 				i_rst,
	input      [31:0] pc,
	output reg [31:0] instr
);
	reg [31:0] instructions_Value [255:0];  // maximum 2048 instruction

	initial begin
		//prefer absolute paths in simulators
		$readmemh("C://Users//NCB//OneDrive//Documents//Quartus//milestone2//instruction.mem", instructions_Value);
	end

//	always @(posedge i_clk or posedge i_rst) begin
	always @(*) begin
//		if (i_rst) begin
//			instr <= 32'd0;
//		end else begin
			// instruction = instructions_Value[PCF/4];  // dividing will take more hardware resources
			instr <= instructions_Value[pc[31:2]];  //instead, we can ignore the least 2 LSBs
//		end
	end
    
endmodule