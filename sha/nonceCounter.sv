// $Id: $
// File name:   nonceCounter.sv
// Created:     11/30/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: nonce Counter

module nonceCounter 
  #(
    parameter NCORE = 1
    )
   (
    input wire 	       clk,
    input wire 	       clearCounter,
    input wire [5:0]   cycle,
    output wire [31:0] nonce
   );

   wire [31:0] 	       roll;
   reg 		       enable;
   reg [31:0] 	       out;
	       
   assign roll = 32'd4294967295 / NCORE;
   assign enable = (cycle == 32'd63) ? 1'b1 : 0;
   assign nonce = out; // artificially increased for debugging
   counter #(32) cnt(.clk(clk),.n_rst(clearCounter),.enable(enable),.rollover_val(roll),.count_out(out));
   
   
endmodule // nonceCounter

  
