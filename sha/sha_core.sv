// $Id: $
// File name:   sha_core.sv
// Created:     11/30/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Sha core

module sha_core(
		input wire clk,
		input wire [255:0] midState,
		input wire [511:0] headData,
		input wire [5:0]   cycle,
		input wire [31:0]  nonce,
		output wire [32:0] coreOutput	   
		);

   reg [255:0] 			   coreNextData;
   reg [255:0] 			   coreCurrData;
   reg [511:0] 			   wordNextData;
   reg [511:0] 			   wordCurrData;   
   // when count is 63 check first32
   //Core
   
   
   always_ff @(posedge clk)
     begin : coreflipflop
	if(cycle == 0)
	  coreNextData <= midState;
	else if(cycle == 6'd32)
	  begin
	     coreNextData[31:0] <= 32'h6a09e667;
	     coreNextData[63:32] <= 32'hbb67ae85;
	     coreNextData[95:64] <= 32'h3c6ef372;
	     coreNextData[127:96] <= 32'ha54ff53a;
	     coreNextData[159:128] <= 32'h510e527f;
	     coreNextData[191:160] <= 32'h9b05688c;
	     coreNextData[223:192] <= 32'h1f83d9ab;
	     coreNextData[255:224] <= 32'h5be0cd19;
	  end // if (cycle == 6'd31)
	else
	  coreNextData <= coreCurrData;
     end
   
   sha_math math(
		 .math_input(coreNextData),
		 .W(wordCurrData[63:0]),
		 .cycle(cycle),
		 .math_output(coreCurrData)
		 );
   
   //Word


   always_ff @(posedge clk)
     begin : dataflip_flop
	if(cycle == 0)
	  wordNextData <= {headData[511:128],nonce,headData[95:0]};
	else if(cycle == 6'd32)
	  wordNextData <= {256'b0,coreCurrData};
	else
	  wordNextData <= wordCurrData;
     end
   
   sha_datashift ds(
		    .dataInput(wordNextData),
		    .dataOutput(wordCurrData)
		    );

   //SHA Checker

   hash_checker hashchk(
			.clk(clk), 
			.count(cycle),
			.nonce(nonce),
			.data_in(coreCurrData[31:0]),
			.flag_plus_nonce(coreOutput)
			);
   
endmodule // sha_core
