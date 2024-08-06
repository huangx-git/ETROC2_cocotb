//-------------------------------------------------------------------------
// Copyright (c) 1997-2009 Cadence Design Systems, Inc.  All rights reserved.
// This work may not be copied, modified, re-published, uploaded, executed,
// or distributed in any way, in any medium, whether in whole or in part,
// without prior written permission from Cadence Design Systems, Inc.
//------------------------------------------------------------------------

//------------------------------------------------------------------------
//  Abstract   : Simulation Architecture for CW_ram_r_w_a_lat
//  RC Release : v12.10-s012_1
//------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////
//
// Chipware -  Cadence Design Systems Ireland.
//
// Name:        CW_ram_r_w_a_lat.v.
//
// Description: Synchronous Write Port, Asynchronous Read Port RAM
//              Latched Based.
//
// Module:      CW_ram_r_w_a_lat
// Description: This is the top module of CW_ram_r_w_a_lat
//
////////////////////////////////////////////////////////////////////////////


module CW_ram_r_w_a_lat (
                           rst_n,
                           cs_n, 
                           wr_n, 
                           rd_addr, 
                           wr_addr, 
                           data_in, 
                           data_out
                           );

parameter data_width=16, depth=8, rst_mode=0;



parameter log_depth = depth > 8388608 ? 24 :
                   (depth > 4194304   ? 23 :
		    (depth > 2097152   ? 22 :
		     (depth > 1048576   ? 21 :
		      (depth > 524288    ? 20 :
		       (depth > 262144    ? 19 :
		        (depth > 131072    ? 18 :
			 (depth > 65536     ? 17 :
			  (depth > 32768     ? 16 :
			   (depth > 16384     ? 15 :
			    (depth > 8192      ? 14 :
			     (depth > 4096      ? 13 :
			      (depth > 2048      ? 12 :
			       (depth > 1024      ? 11 :
			        (depth > 512       ? 10 :
				 (depth > 256       ? 9 :
				  (depth > 128       ? 8 :
				   (depth > 64        ? 7 :
				    (depth > 32        ? 6 :
				     (depth > 16        ? 5 :
				      (depth > 8         ? 4 :
				       (depth > 4         ? 3 :
				        (depth > 2 ? 2 : 1))))))))))))))))))))));




// input declarations
input rst_n;
input cs_n;
input wr_n;
input [(log_depth - 1):0] rd_addr;
input [(log_depth - 1):0] wr_addr;
input [(data_width - 1):0] data_in;

// output declarations
output [(data_width - 1):0] data_out;

// reg declarations
reg [(data_width - 1):0] mem[0:(depth - 1)];

// wire declarations
wire tmp_rst_n;

// integer declarations
integer i;


// Read
// Output 'data_out' is zero when the address has gone beyond the maximum depth
// Sim model only: data_out is all XX's when rd_addr is invalid i.e. an X or Z value
assign data_out[(data_width -1):0] = (rd_addr > depth - 1 ? 0 : ( (^rd_addr == 1'b0 || ^rd_addr == 1'b1) 
                                    ? mem[rd_addr] : {data_width{1'bx}} )) ;


// Sim model only: Must tie 'rst_n' high if rst_mode = 1
assign tmp_rst_n = (rst_mode) ? 1'b1 : rst_n ; 

// Write
// The LATCH is in TRANSPARENT MODE when wr_n & cs_n are low.
// Inferring latches, use an incomplete assignment within the combinatorial procedure.
// Describe the LATCH when in TRANSPARENT MODE.
// The value of 'mem[wr_addr]' must be remembered, as no default or 'if else' statement is used, 
// and therefore a latch is inferred
// To reset rst_mode must be low and tmp_rst_n must also be low
// Sim model only: For an invalid value of 'wr_n', Xs are written into the RAM at current address.


always @ (data_in or wr_addr or cs_n or wr_n or tmp_rst_n)
begin
if(rst_mode == 0)
   begin
   if(tmp_rst_n == 1'b0)
      // Reset all memory to zero
      for(i = 0 ; i < depth ; i = i+1)
      begin
         mem[i] <= 0;
      end 
   else
      begin
         if ( cs_n == 1'b0 && wr_n == 1'b0 )
            mem[wr_addr] <= data_in ;
         else if (cs_n == 1'b0 && (wr_n === 1'bx || wr_n === 1'bz) )
            mem[wr_addr] <= {data_width{1'bx}} ;
      end
   end

else
   begin
      if ( cs_n == 1'b0 && wr_n == 1'b0 )
         mem[wr_addr] <= data_in ;
      else if (cs_n == 1'b0 && (wr_n === 1'bx || wr_n === 1'bz) )
         mem[wr_addr] <= {data_width{1'bx}} ;
   end
end



//Parameter checking
//cadence translate_off
initial begin

 if (data_width < 1) 
  begin
   $display("FAILURE - Bad parameter, data_width=%0d, which is < 1.", data_width);
   $finish ;
  end

 if (data_width > 256) 
  begin
   $display("WARNING - data_width=%0d.", data_width);
   $display("          Suggested maximum data_width is 256.");
  end

 if (depth < 2) 
  begin
   $display("FAILURE - Bad parameter, depth=%0d, which is < 2.", depth);
   $finish ;
  end

 if (depth > 256 ) 
  begin
   $display("WARNING - depth=%0d.", depth);
   $display("          Suggested maximum depth is 256.");
  end

 if (rst_mode < 0 || rst_mode > 1)
  begin
   $display("FAILURE - Bad parameter, rst_mode=%0d, which is not in the legal range of 0 to 1.", rst_mode);
   $finish ;
  end

end
//cadence translate_on



//Processes to generate WARNINGS on illegal inputs!
//cadence translate_off
always @ (rst_n)
begin
 if (rst_n === 1'bx || rst_n === 1'bz) 
  $display("WARNING: Invalid input on pin 'rst_n': %0b", rst_n );
end
//cadence translate_on

//cadence translate_off
always @ (cs_n)
begin
 if (cs_n === 1'bx || cs_n === 1'bz) 
  $display("WARNING: Invalid input on pin 'cs_n': %0b", cs_n );
end
//cadence translate_on

//cadence translate_off
always @ (wr_n)
begin
 if (wr_n === 1'bx || wr_n === 1'bz) 
  $display("WARNING: Invalid input on pin 'wr_n': %0b", wr_n );
end
//cadence translate_on

//cadence translate_off
always @ (rd_addr)
begin
 if (^rd_addr == 1'b0 || ^rd_addr === 1'b1) 
  begin
  end
 else
  $display("WARNING: Invalid input on pin 'rd_addr': %h", rd_addr );
end
//cadence translate_on

//cadence translate_off
always @ (wr_addr)
begin
 if (^wr_addr == 1'b0 || ^wr_addr === 1'b1) 
  begin
  end
 else
  $display("WARNING: Invalid input on pin 'wr_addr': %h", wr_addr );
end
//cadence translate_on


//Input wr_addr should be stable before RAM enters TRANSPARENT/writable mode. If wr_addr updates during
//this time, output a warning.
//cadence translate_off
always @ (wr_addr)
begin
 if (!cs_n && !wr_n)
  begin
  $display("WARNING: Input 'wr_addr' changes to %h while RAM is in TRANSPARENT mode!", wr_addr);
  $display("WARNING: Input 'wr_addr' should be stable at this point!");
  $display("WARNING: Input 'data_in' is LATCHED into original address!");
  $display("WARNING: Input 'data_in' should only be LATCHED by rising edge of wr_n!");
  end
end
//cadence translate_on

//Input cs_n should be stable before RAM enters TRANSPARENT/writable mode. If cs_n updates during
//this time, output a warning.
//cadence translate_off
always @ (posedge cs_n)
begin
 if (!wr_n)
  begin
  $display("WARNING: Input 'cs_n' rises to %0b while RAM is in TRANSPARENT mode!", cs_n);
  $display("WARNING: Input 'cs_n' should be stable at this point!");
  $display("WARNING: Input 'data_in' is LATCHED into current address!");
  $display("WARNING: Input 'data_in' should only be LATCHED by rising edge of wr_n!");
  end
end
//cadence translate_on

endmodule   




