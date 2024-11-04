module seven_led(
	 input  logic [6:0]   io_hex0_o,  // 7-segment LED inputs
    input  logic [6:0]   io_hex1_o,
    input  logic [6:0]   io_hex2_o,
    input  logic [6:0]   io_hex3_o,
    input  logic [6:0]   io_hex4_o,
    input  logic [6:0]   io_hex5_o,
    input  logic [6:0]   io_hex6_o,
    input  logic [6:0]   io_hex7_o, 
	 output logic [6:0]   HEX0     , // 8 32-bit data to drive 7-segment LEDs.
	 output logic [6:0]   HEX1     ,
	 output logic [6:0]   HEX2     ,
	 output logic [6:0]   HEX3     ,
	 output logic [6:0]   HEX4     ,
	 output logic [6:0]   HEX5     ,
	 output logic [6:0]   HEX6     ,
	 output logic [6:0]   HEX7
);

  logic [6:0] Display0,Display1, Display2, Display3, Display4,Display5, Display6, Display7;

  function [6:0] conv_to_seg(
    input [3:0] Digit
  );
  
    case (Digit)
      4'b0000 : conv_to_seg = 7'h40;
	   4'b0001 : conv_to_seg = 7'h79;
	   4'b0010 : conv_to_seg = 7'h24;
	   4'b0011 : conv_to_seg = 7'h30;
	   4'b0100 : conv_to_seg = 7'h19;          
	   4'b0101 : conv_to_seg = 7'h12;
	   4'b0110 : conv_to_seg = 7'h02;
	   4'b0111 : conv_to_seg = 7'h78;
	   4'b1000 : conv_to_seg = 7'h00;
	   4'b1001 : conv_to_seg = 7'h10;
	   default: ;// do nothing
    endcase
  endfunction

  always_comb begin
    Display0 = conv_to_seg( io_hex0_o);
    Display1 = conv_to_seg( io_hex1_o);
    Display2 = conv_to_seg( io_hex2_o);
    Display3 = conv_to_seg( io_hex3_o);
    Display4 = conv_to_seg( io_hex4_o);
    Display5 = conv_to_seg( io_hex5_o);
    Display6 = conv_to_seg( io_hex6_o);
    Display7 = conv_to_seg( io_hex7_o);
  end
	
  always_comb begin
    HEX0 = Display0 ; // 8 32-bit data to drive 7-segment LEDs.
	 HEX1 = Display1 ;
	 HEX2 = Display2 ;
	 HEX3 = Display3 ;
	 HEX4 = Display4 ;
	 HEX5 = Display5 ;
	 HEX6 = Display6 ;
	 HEX7 = Display7 ; 
  end
endmodule