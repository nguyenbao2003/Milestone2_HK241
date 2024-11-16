module lsu (
	input logic		[31:0]	i_st_data,  // rs2_data (data to be written)
	input logic		[31:0] 	i_lsu_addr,		// alu_data (memory address)
	input logic					i_clk,    // clock input
	input logic					i_lsu_wren,    // mem_wren (store enable for writes)
	input logic					i_rst,   // reset (active low)
	input logic		[2:0] 	funct3,

	// I/O Peripheral ports
	input		logic	[31:0] 	i_io_sw,     // 32-bit switch inputs
	input		logic	[31:0] 	i_io_btn,    // 32-bit button inputs (optional)
	output logic [1:0] byte_offset,
	output logic	[6:0] 	o_io_hex0,   // 7-segment LED outputs
	output logic	[6:0] 	o_io_hex1,
	output logic	[6:0] 	o_io_hex2,
	output logic	[6:0] 	o_io_hex3,
	output logic	[6:0] 	o_io_hex4,
	output logic	[6:0] 	o_io_hex5,
	output logic	[6:0] 	o_io_hex6,
	output logic	[6:0] 	o_io_hex7,
	output logic	[31:0] 	o_io_ledg,   // 32-bit Green LED outputs
	output logic	[31:0] 	o_io_ledr,   // 32-bit Red LED outputs
	output logic	[31:0] 	o_ld_data,   // load data (output to CPU for lw)
	output logic	[31:0] 	o_io_lcd	   // 32-bit LCD data output
);

	// Memory operation types (based on funct3)
    localparam F3_B   = 3'b000;  // LB/SB
    localparam F3_H   = 3'b001;  // LH/SH
    localparam F3_W   = 3'b010;  // LW/SW
    localparam F3_BU  = 3'b100;  // LBU
    localparam F3_HU  = 3'b101;  // LHU
	
	
	// SDRAM-based memory (8191 x 8-bit = 8KiB)
	logic[7:0] 	Data_Mem [8191:0];  // Simulating SDRAM with some delay for demo
	logic[7:0] 	reg_7_segment [7:0];
//	logic [1:0] byte_offset;
   assign byte_offset = i_lsu_addr[1:0];
	
	
		
	// Memory-mapped I/O addresses (adjusted for new peripherals)
	localparam [31:0] RED_LED_START    = 32'h7000, RED_LED_END   = 32'h700F;
	localparam [31:0] GREEN_LED_START  = 32'h7010, GREEN_LED_END = 32'h701F;
	localparam [31:0] SEVEN_SEG_START  = 32'h7020   , SEVEN_SEG_END = 32'h7027;
	localparam [31:0] LCD_CTRL_START   = 32'h7030, LCD_CTRL_END  = 32'h703F;
	localparam [31:0] SWITCH_START     = 32'h7800, SWITCH_END    = 32'h780F;
	localparam [31:0] BUTTON_START     = 32'h7810, BUTTON_END    = 32'h781F;

	// SDRAM memory range: 0x2000 -> 0x3FFF
	localparam [31:0] SDRAM_START      = 32'h2000, SDRAM_END     = 32'h3FFF;

	integer e;
	
	// Load data logic (read from peripherals or memory)
	always_comb begin
		if (!i_rst) begin
			o_ld_data = 32'b0;
		end else if (i_lsu_wren) begin
			o_ld_data = 32'b0;
		end else begin	
        if (i_lsu_addr >= SDRAM_START && i_lsu_addr <= SDRAM_END) begin
                case (funct3)
                    F3_W: begin // LW
                        o_ld_data = {Data_Mem[i_lsu_addr-SDRAM_START+3], 
                                 Data_Mem[i_lsu_addr-SDRAM_START+2],
                                 Data_Mem[i_lsu_addr-SDRAM_START+1], 
                                 Data_Mem[i_lsu_addr-SDRAM_START]};
                    end
                    F3_H: begin // LH
                        case (byte_offset)
                            2'b00: o_ld_data = {{16{Data_Mem[i_lsu_addr-SDRAM_START+1][7]}}, 
                                            Data_Mem[i_lsu_addr-SDRAM_START+1], 
                                            Data_Mem[i_lsu_addr-SDRAM_START]};
                            2'b10: o_ld_data = {{16{Data_Mem[i_lsu_addr-SDRAM_START+1][7]}}, 
                                            Data_Mem[i_lsu_addr-SDRAM_START+1], 
                                            Data_Mem[i_lsu_addr-SDRAM_START]};
                            default: o_ld_data = 32'b0; // Unaligned access
                        endcase
                    end
                    F3_B: begin // LB
                        case (byte_offset)
                            2'b00: o_ld_data = {{24{Data_Mem[i_lsu_addr-SDRAM_START][7]}}, 
                                            Data_Mem[i_lsu_addr-SDRAM_START]};
                            2'b01: o_ld_data = {{24{Data_Mem[i_lsu_addr-SDRAM_START][7]}}, 
                                            Data_Mem[i_lsu_addr-SDRAM_START]};
                            2'b10: o_ld_data = {{24{Data_Mem[i_lsu_addr-SDRAM_START][7]}}, 
                                            Data_Mem[i_lsu_addr-SDRAM_START]};
                            2'b11: o_ld_data = {{24{Data_Mem[i_lsu_addr-SDRAM_START][7]}}, 
                                            Data_Mem[i_lsu_addr-SDRAM_START]};
                        endcase
                    end
                    F3_BU: begin // LBU
                        case (byte_offset)
                            2'b00: o_ld_data = {24'b0, Data_Mem[i_lsu_addr-SDRAM_START]};
                            2'b01: o_ld_data = {24'b0, Data_Mem[i_lsu_addr-SDRAM_START]};
                            2'b10: o_ld_data = {24'b0, Data_Mem[i_lsu_addr-SDRAM_START]};
                            2'b11: o_ld_data = {24'b0, Data_Mem[i_lsu_addr-SDRAM_START]};
                        endcase
                    end
                    F3_HU: begin // LHU
                        case (byte_offset)
                            2'b00: o_ld_data = {16'b0, Data_Mem[i_lsu_addr-SDRAM_START+1], 
                                            Data_Mem[i_lsu_addr-SDRAM_START]};
                            2'b10: o_ld_data = {16'b0, Data_Mem[i_lsu_addr-SDRAM_START+1], 
                                            Data_Mem[i_lsu_addr-SDRAM_START]};
                            default: o_ld_data = 32'b0; // Unaligned access
                        endcase
                    end
                    default: o_ld_data = 32'b0;
                endcase
     //       end
        end else begin
            // Peripheral read operations remain unchanged
            if (i_lsu_addr >= RED_LED_START && i_lsu_addr <= RED_LED_END) begin
                o_ld_data = {15'b0, o_io_ledr[16:0]};
            end else if (i_lsu_addr >= GREEN_LED_START && i_lsu_addr <= GREEN_LED_END) begin
                o_ld_data = {24'b0, o_io_ledg[7:0]};
            end else if (i_lsu_addr >= 32'h7020 && i_lsu_addr <= 32'h7027) begin
					case (funct3)
                    F3_W: begin // LW
                        o_ld_data = {reg_7_segment[i_lsu_addr-SEVEN_SEG_START+3],
												reg_7_segment[i_lsu_addr-SEVEN_SEG_START+2],
												reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1],
												reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                    end
                    F3_H: begin // LH
                        case (byte_offset)
                            2'b00: o_ld_data = {{16{reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1][7]}}, 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1], 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            2'b10: o_ld_data = {{16{reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1][7]}}, 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1], 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            default: o_ld_data = 32'b0; // Unaligned access
                        endcase
                    end
                    F3_B: begin // LB
                        case (byte_offset)
                            2'b00: o_ld_data = {{24{reg_7_segment[i_lsu_addr-SEVEN_SEG_START][7]}}, 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            2'b01: o_ld_data = {{24{reg_7_segment[i_lsu_addr-SEVEN_SEG_START][7]}}, 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            2'b10: o_ld_data = {{24{reg_7_segment[i_lsu_addr-SEVEN_SEG_START][7]}}, 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            2'b11: o_ld_data = {{24{reg_7_segment[i_lsu_addr-SEVEN_SEG_START][7]}}, 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                        endcase
                    end
                    F3_BU: begin // LBU
                        case (byte_offset)
                            2'b00: o_ld_data = {24'b0, reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            2'b01: o_ld_data = {24'b0, reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            2'b10: o_ld_data = {24'b0, reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            2'b11: o_ld_data = {24'b0, reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                        endcase
                    end
                    F3_HU: begin // LHU
                        case (byte_offset)
                            2'b00: o_ld_data = {16'b0, reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1], 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            2'b10: o_ld_data = {16'b0, reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1], 
                                            reg_7_segment[i_lsu_addr-SEVEN_SEG_START]};
                            default: o_ld_data = 32'b0; // Unaligned access
                        endcase
                    end
                    default: o_ld_data = 32'b0;
                endcase
            end else if (i_lsu_addr >= 32'h7023 && i_lsu_addr <= 32'h7024) begin
                o_ld_data = {reg_7_segment[7], reg_7_segment[6], reg_7_segment[5], reg_7_segment[4]};
            end else if (i_lsu_addr >= LCD_CTRL_START && i_lsu_addr <= LCD_CTRL_END) begin
                o_ld_data = o_io_lcd;
            end else if (i_lsu_addr >= SWITCH_START && i_lsu_addr <= SWITCH_END) begin
                case (funct3)
                    F3_W: begin // LW
                        o_ld_data = i_io_sw;
                    end
                    F3_H: begin // LH
                        o_ld_data = {{16{i_io_sw[15]}},i_io_sw[15:0]};
                    end
                    F3_B: begin // LB
                        o_ld_data = {{24{i_io_sw[7]}},i_io_sw[7:0]};
                    end
                    F3_BU: begin // LBU
                        o_ld_data = {24'b0,i_io_sw[7:0]};
                    end
                    F3_HU: begin // LHU
                        o_ld_data = {16'b0,i_io_sw[15:0]};
                    end
               endcase
            end else if (i_lsu_addr >= BUTTON_START && i_lsu_addr <= BUTTON_END) begin
                o_ld_data = {22'b0, i_io_btn[9:0]};
            end else begin
                o_ld_data = 32'b0;
            end
        end
    end
	 end
	
	
	// Store data logic with updated operation decoding
    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            // Reset logic remains unchanged
            for (e = 0; e < 256; e = e + 1) begin
                Data_Mem[e] <= 8'd0;
            end
            reg_7_segment[0] <= 8'h0;
				reg_7_segment[1] <= 8'h0;
				reg_7_segment[2] <= 8'h0;
				reg_7_segment[3] <= 8'h0;
				reg_7_segment[4] <= 8'h0;
				reg_7_segment[5] <= 8'h0;
				reg_7_segment[6] <= 8'h0;
				reg_7_segment[7] <= 8'h0;
            o_io_ledg <= 32'b0;
            o_io_ledr <= 32'b0;
            o_io_lcd  <= 32'b0;
        end else if (i_lsu_wren) begin
            if (i_lsu_addr >= SDRAM_START && i_lsu_addr <= SDRAM_END) begin
                case (funct3)
                    F3_W: begin // SW
                        Data_Mem[i_lsu_addr-SDRAM_START]   <= i_st_data[7:0];
                        Data_Mem[i_lsu_addr-SDRAM_START+1] <= i_st_data[15:8];
                        Data_Mem[i_lsu_addr-SDRAM_START+2] <= i_st_data[23:16];
                        Data_Mem[i_lsu_addr-SDRAM_START+3] <= i_st_data[31:24];
                    end
                    F3_H: begin // SH
                        case (byte_offset)
                            2'b00: begin
                                Data_Mem[i_lsu_addr-SDRAM_START]   <= i_st_data[7:0];
                                Data_Mem[i_lsu_addr-SDRAM_START+1] <= i_st_data[15:8];
                            end
                            2'b10: begin
                                Data_Mem[i_lsu_addr-SDRAM_START] <= i_st_data[7:0];
                                Data_Mem[i_lsu_addr-SDRAM_START+1] <= i_st_data[15:8];
                            end
                        endcase
                    end
                    F3_B: begin // SB
                        case (byte_offset)
                            2'b00: Data_Mem[i_lsu_addr-SDRAM_START]   <= i_st_data[7:0];
                            2'b01: Data_Mem[i_lsu_addr-SDRAM_START] <= i_st_data[7:0];
                            2'b10: Data_Mem[i_lsu_addr-SDRAM_START] <= i_st_data[7:0];
                            2'b11: Data_Mem[i_lsu_addr-SDRAM_START] <= i_st_data[7:0];
                        endcase
                    end
                endcase
            end else begin
                // Peripheral write operations remain unchanged
                if (i_lsu_addr >= RED_LED_START && i_lsu_addr <= RED_LED_END) begin
                    o_io_ledr <= i_st_data[16:0];
                end else if (i_lsu_addr >= GREEN_LED_START && i_lsu_addr <= GREEN_LED_END) begin
                    o_io_ledg <= i_st_data[7:0];
                end else if (i_lsu_addr >= 32'h7020 && i_lsu_addr <= 32'h7027) begin
							case (funct3)
								F3_W: begin // SW
									reg_7_segment[i_lsu_addr-SEVEN_SEG_START] <= {1'b0, i_st_data[6:0]};
									reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1] <= {1'b0, i_st_data[14:8]};
									reg_7_segment[i_lsu_addr-SEVEN_SEG_START+2] <= {1'b0, i_st_data[22:16]};
									reg_7_segment[i_lsu_addr-SEVEN_SEG_START+3] <= {1'b0, i_st_data[30:24]};
								end
								F3_H: begin // SH
									case (byte_offset)
										2'b00: begin
										  reg_7_segment[i_lsu_addr-SEVEN_SEG_START]   <= {1'b0, i_st_data[6:0]};
										  reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1] <= {1'b0, i_st_data[14:8]};
										end
										2'b10: begin
										  reg_7_segment[i_lsu_addr-SEVEN_SEG_START]   <= {1'b0, i_st_data[6:0]};
										  reg_7_segment[i_lsu_addr-SEVEN_SEG_START+1] <= {1'b0, i_st_data[14:8]};
										end
									endcase
								end
								F3_B: begin // SB
                        case (byte_offset)
                            2'b00: reg_7_segment[i_lsu_addr-SEVEN_SEG_START]   <= i_st_data[7:0];
                            2'b01: reg_7_segment[i_lsu_addr-SEVEN_SEG_START] <= i_st_data[7:0];
                            2'b10: reg_7_segment[i_lsu_addr-SEVEN_SEG_START] <= i_st_data[7:0];
                            2'b11: reg_7_segment[i_lsu_addr-SEVEN_SEG_START] <= i_st_data[7:0];
                        endcase
                    end
							endcase
		//				end
                end else if (i_lsu_addr >= LCD_CTRL_START && i_lsu_addr <= LCD_CTRL_END) begin
                    o_io_lcd <= i_st_data;
                end
            end
        end
    end
	always_comb begin
		o_io_hex0 = reg_7_segment[0];
		o_io_hex1 = reg_7_segment[1];
		o_io_hex2 = reg_7_segment[2];
		o_io_hex3 = reg_7_segment[3];
		o_io_hex4 = reg_7_segment[4];
		o_io_hex5 = reg_7_segment[5];
		o_io_hex6 = reg_7_segment[6];
		o_io_hex7 = reg_7_segment[7];
	end

endmodule