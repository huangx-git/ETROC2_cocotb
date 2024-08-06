  wire [6:0] AddrSlaveDUT;
  assign AddrSlaveDUT = 7'h67;
  task test_pixel;
    input [3:0] pixel_x;
    input [3:0] pixel_y;
    reg [31:0] pixelConfig1, pixelConfig2, pixelConfig3, pixelConfig4, pixelConfig5, pixelConfig6, pixelConfig7, pixelConfig8;
    reg [255:0] pixelConfig;
    reg [255:0] pixelConfigReadback;
    reg [63:0] pixelStatus;
    reg [15:0] pixelConfigAddr;
    reg [15:0] pixelStatusAddr;
    begin
    $display("%12d [invoking test_pixel]",$time);
    pixelConfig1 = $random;
    pixelConfig2 = $random;
    pixelConfig3 = $random;
    pixelConfig4 = $random;
    pixelConfig5 = $random;
    pixelConfig6 = $random;
    pixelConfig7 = $random;
    pixelConfig8 = $random;
    pixelConfig = {pixelConfig1,pixelConfig2,pixelConfig3, pixelConfig4, pixelConfig5, pixelConfig6, pixelConfig7, pixelConfig8};
    pixelConfigAddr = 16'h8000 | pixel_y<<9 | pixel_x<<5;

    pixelStatusAddr = 16'h4000 | pixelConfigAddr;
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h0, pixelConfig[7:0], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1, pixelConfig[15:8], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h2, pixelConfig[23:16], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h3, pixelConfig[31:24], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h4, pixelConfig[39:32], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h5, pixelConfig[47:40], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h6, pixelConfig[55:48], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h7, pixelConfig[63:56], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h8, pixelConfig[71:64], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h9, pixelConfig[79:72], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hA, pixelConfig[87:80], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hB, pixelConfig[95:88], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hC, pixelConfig[103:96], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hD, pixelConfig[111:104], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hE, pixelConfig[119:112], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hF, pixelConfig[127:120], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h10, pixelConfig[135:128], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h11, pixelConfig[143:136], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h12, pixelConfig[151:144], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h13, pixelConfig[159:152], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h14, pixelConfig[167:160], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h15, pixelConfig[175:168], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h16, pixelConfig[183:176], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h17, pixelConfig[191:184], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h18, pixelConfig[199:192], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h19, pixelConfig[207:200], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1A, pixelConfig[215:208], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1B, pixelConfig[223:216], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1C, pixelConfig[231:224], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1D, pixelConfig[239:232], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1E, pixelConfig[247:240], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1F, pixelConfig[255:248], 1'b1);

    $display("%12d [pixel%0x%0x] config: 0x%08h",$time, pixel_x, pixel_y, pixelConfig);

    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h0, pixelConfigReadback[7:0], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1, pixelConfigReadback[15:8], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h2, pixelConfigReadback[23:16], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h3, pixelConfigReadback[31:24], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h4, pixelConfigReadback[39:32], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h5, pixelConfigReadback[47:40], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h6, pixelConfigReadback[55:48], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h7, pixelConfigReadback[63:56], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h8, pixelConfigReadback[71:64], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h9, pixelConfigReadback[79:72], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hA, pixelConfigReadback[87:80], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hB, pixelConfigReadback[95:88], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hC, pixelConfigReadback[103:96], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hD, pixelConfigReadback[111:104], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hE, pixelConfigReadback[119:112], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hF, pixelConfigReadback[127:120], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h10, pixelConfigReadback[135:128], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h11, pixelConfigReadback[143:136], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h12, pixelConfigReadback[151:144], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h13, pixelConfigReadback[159:152], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h14, pixelConfigReadback[167:160], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h15, pixelConfigReadback[175:168], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h16, pixelConfigReadback[183:176], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h17, pixelConfigReadback[191:184], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h18, pixelConfigReadback[199:192], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h19, pixelConfigReadback[207:200], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1A, pixelConfigReadback[215:208], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1B, pixelConfigReadback[223:216], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1C, pixelConfigReadback[231:224], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1D, pixelConfigReadback[239:232], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1E, pixelConfigReadback[247:240], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1F, pixelConfigReadback[255:248], 1'b1);
    $display("%12d [pixel%0x%0x] config readback: 0x%08h",$time, pixel_x, pixel_y, pixelConfigReadback);
    if (pixelConfig!=pixelConfigReadback)
      //$error("Unexpected value!"); 
      $display("Unexpected value: config readback!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    else 
      $display("expected configuration readback ^_^|^_^|^_^");

    

    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h0, pixelStatus[7:0], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h1, pixelStatus[15:8], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h2, pixelStatus[23:16], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h3, pixelStatus[31:24], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h4, pixelStatus[39:32], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h5, pixelStatus[47:40], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h6, pixelStatus[55:48], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h7, pixelStatus[63:56], 1'b1);
/*    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h8, pixelStatus[71:64], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h9, pixelStatus[79:72], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'hA, pixelStatus[87:80], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'hB, pixelStatus[95:88], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'hC, pixelStatus[103:96], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'hD, pixelStatus[111:104], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'hE, pixelStatus[119:112], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'hF, pixelStatus[127:120], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h10, pixelStatus[135:128], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h11, pixelStatus[143:136], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h12, pixelStatus[151:144], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h13, pixelStatus[159:152], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h14, pixelStatus[167:160], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h15, pixelStatus[175:168], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h16, pixelStatus[183:176], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h17, pixelStatus[191:184], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h18, pixelStatus[199:192], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h19, pixelStatus[207:200], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h1A, pixelStatus[215:208], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h1B, pixelStatus[223:216], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h1C, pixelStatus[231:224], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h1D, pixelStatus[239:232], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h1E, pixelStatus[247:240], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelStatusAddr | 16'h1F, pixelStatus[255:248], 1'b1);*/
    $display("%12d [pixel%0x%0x] status: 0x%08h",$time, pixel_x, pixel_y, pixelStatus);

    if (pixelConfig[63:0]!=(pixelStatus^64'hFFFFFFFFFFFFFFFF)) 
      //$error("Unexpected value!"); 
      $display("Unexpected value: status readback!!!!! for i2c test chip. might be ok for ETROC2");
    end
  endtask



 task test_common;		//added by qsun
	
  	input [4:0] comReg;
	reg [7:0] comConfig;
	reg [7:0] comConfigReadback;
	reg [7:0] comStatus;
	reg [15:0] comConfigAddr;
	reg [15:0] comStatusAddr;
	begin
    // $display("%12d [invoking test_common]",$time);
    $display("%12d [invoking test_common], addr:0x%0x",$time, comReg);
		comConfig = $random;
		comConfigAddr = comReg ;
		comStatusAddr = 16'h0100 | comConfigAddr;
		i2c_write_single(AddrSlaveDUT, comConfigAddr | 16'h0, comConfig[7:0], 1'b1);
		$display("%12d [Common Circuities Config Addr%0x] config: 0x%4h",$time, comConfigAddr, comConfig);

		i2c_read_single(AddrSlaveDUT, comConfigAddr | 16'h0, comConfigReadback[7:0], 1'b1);
		$display("%12d [Common Circuities Config Addr%0x] config readback: 0x%4h",$time, comConfigAddr, comConfigReadback);
		if (comConfig!=comConfigReadback) 
			$display("%12d Unexpected value at common circuities config!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",$time);
      			//$error("Unexpected value!");

		i2c_read_single(AddrSlaveDUT, comStatusAddr | 16'h0, comStatus[7:0], 1'b1);
		$display("%12d [Common Circuities Status Addr%0x] status: 0x%4h",$time, comStatusAddr, comStatus);
		// if (comConfig!=comStatus)
    //   			//$error("Unexpected value!");
	  // 		$display("%12d Unexpected value at common circuities status!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",$time);
	end
  endtask

  task test_peripheral_config;
    reg [7:0] comConfig;
    reg [7:0] comConfigReadback;
    reg [15:0] comConfigAddr;
    integer i;
    begin
      $display("invoking test_peripheral_config");
      for(i=0;i<32;i=i+1) begin 
        comConfigAddr = i ;
        comConfig = $random;
        i2c_write_single(AddrSlaveDUT, comConfigAddr | 16'h0, comConfig[7:0], 1'b1);
        $display("%12d [Peripheral Config Addr%0x] config: 0x%4h",$time, comConfigAddr, comConfig);
        i2c_read_single(AddrSlaveDUT, comConfigAddr | 16'h0, comConfigReadback[7:0], 1'b1);
        if (comConfig!=comConfigReadback) 
          $display("%12d Unexpected value at peripheral config!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",$time);
      end  //end for
    end
  endtask

  task test_peripheral_default_config;
    input [255:0] comConfigDefault;
    reg [255:0] comConfigReadback, comConfigDefaultInt;
    reg [15:0] comConfigAddr;
    integer i;
    begin
      $display("invoking test_peripheral_default_config");
      $display("the reference default is: 0x%0x",comConfigDefault);
      comConfigDefaultInt = comConfigDefault;
      i2c_read_single(AddrSlaveDUT, 0 | 16'h0, comConfigReadback[7:0], 1'b1);
      i2c_read_single(AddrSlaveDUT, 1 | 16'h0, comConfigReadback[15:8], 1'b1);
      i2c_read_single(AddrSlaveDUT, 2 | 16'h0, comConfigReadback[23:16], 1'b1);
      i2c_read_single(AddrSlaveDUT, 3 | 16'h0, comConfigReadback[31:24], 1'b1);
      i2c_read_single(AddrSlaveDUT, 4 | 16'h0, comConfigReadback[39:32], 1'b1);
      i2c_read_single(AddrSlaveDUT, 5 | 16'h0, comConfigReadback[47:40], 1'b1);
      i2c_read_single(AddrSlaveDUT, 6 | 16'h0, comConfigReadback[55:48], 1'b1);
      i2c_read_single(AddrSlaveDUT, 7 | 16'h0, comConfigReadback[63:56], 1'b1);
      i2c_read_single(AddrSlaveDUT, 8 | 16'h0, comConfigReadback[71:64], 1'b1);
      i2c_read_single(AddrSlaveDUT, 9 | 16'h0, comConfigReadback[79:72], 1'b1);
      i2c_read_single(AddrSlaveDUT, 10 | 16'h0, comConfigReadback[87:80], 1'b1);
      i2c_read_single(AddrSlaveDUT, 11 | 16'h0, comConfigReadback[95:88], 1'b1);
      i2c_read_single(AddrSlaveDUT, 12 | 16'h0, comConfigReadback[103:96], 1'b1);
      i2c_read_single(AddrSlaveDUT, 13 | 16'h0, comConfigReadback[111:104], 1'b1);
      i2c_read_single(AddrSlaveDUT, 14 | 16'h0, comConfigReadback[119:112], 1'b1);
      i2c_read_single(AddrSlaveDUT, 15 | 16'h0, comConfigReadback[127:120], 1'b1);
      i2c_read_single(AddrSlaveDUT, 16 | 16'h0, comConfigReadback[135:128], 1'b1);
      i2c_read_single(AddrSlaveDUT, 17 | 16'h0, comConfigReadback[143:136], 1'b1);
      i2c_read_single(AddrSlaveDUT, 18 | 16'h0, comConfigReadback[151:144], 1'b1);
      i2c_read_single(AddrSlaveDUT, 19 | 16'h0, comConfigReadback[159:152], 1'b1);
      i2c_read_single(AddrSlaveDUT, 20 | 16'h0, comConfigReadback[167:160], 1'b1);
      i2c_read_single(AddrSlaveDUT, 21 | 16'h0, comConfigReadback[175:168], 1'b1);
      i2c_read_single(AddrSlaveDUT, 22 | 16'h0, comConfigReadback[183:176], 1'b1);
      i2c_read_single(AddrSlaveDUT, 23 | 16'h0, comConfigReadback[191:184], 1'b1);
      i2c_read_single(AddrSlaveDUT, 24 | 16'h0, comConfigReadback[199:192], 1'b1);
      i2c_read_single(AddrSlaveDUT, 25 | 16'h0, comConfigReadback[207:200], 1'b1);
      i2c_read_single(AddrSlaveDUT, 26 | 16'h0, comConfigReadback[215:208], 1'b1);
      i2c_read_single(AddrSlaveDUT, 27 | 16'h0, comConfigReadback[223:216], 1'b1);
      i2c_read_single(AddrSlaveDUT, 28 | 16'h0, comConfigReadback[231:224], 1'b1);
      i2c_read_single(AddrSlaveDUT, 29 | 16'h0, comConfigReadback[239:232], 1'b1);
      i2c_read_single(AddrSlaveDUT, 30 | 16'h0, comConfigReadback[247:240], 1'b1);
      i2c_read_single(AddrSlaveDUT, 31 | 16'h0, comConfigReadback[255:248], 1'b1);
      $display("%12d [Peripheral Default Config Readback] config: 0x%4h",$time, comConfigReadback);
      $display("%12d [Peripheral Default Config Input   ] config: 0x%4h",$time, comConfigDefaultInt);
      if (comConfigReadback != comConfigDefaultInt) begin
        $display("%12d Unexpected value at peripheral default config!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",$time);
      end
      else begin 
        $display("%12d periphery default values are correct ^__^|^__^|^__^",$time);
      end
    end
  endtask


  task test_pixel_bc;
    input [3:0] pixel_x;
    input [3:0] pixel_y;
    reg [31:0] pixelConfig1, pixelConfig2, pixelConfig3, pixelConfig4, pixelConfig5, pixelConfig6, pixelConfig7, pixelConfig8;
    reg [255:0] pixelConfig;
    reg [255:0] pixelConfigReadback;
    reg [63:0] pixelStatus;
    reg [15:0] pixelConfigAddr;
    reg [15:0] pixelStatusAddr;
    integer i;
    begin

    pixelConfig1 = $random;
    pixelConfig2 = $random;
    pixelConfig3 = $random;
    pixelConfig4 = $random;
    pixelConfig5 = $random;
    pixelConfig6 = $random;
    pixelConfig7 = $random;
    pixelConfig8 = $random;
    pixelConfig = {pixelConfig1,pixelConfig2, pixelConfig3, pixelConfig4, pixelConfig5, pixelConfig6, pixelConfig7, pixelConfig8};
    pixelConfigAddr = 16'hA000 | pixel_y<<9 | pixel_x<<5;

    pixelStatusAddr = 16'h4000 | pixelConfigAddr;
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h0, pixelConfig[7:0], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1, pixelConfig[15:8], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h2, pixelConfig[23:16], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h3, pixelConfig[31:24], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h4, pixelConfig[39:32], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h5, pixelConfig[47:40], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h6, pixelConfig[55:48], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h7, pixelConfig[63:56], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h8, pixelConfig[71:64], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h9, pixelConfig[79:72], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hA, pixelConfig[87:80], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hB, pixelConfig[95:88], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hC, pixelConfig[103:96], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hD, pixelConfig[111:104], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hE, pixelConfig[119:112], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'hF, pixelConfig[127:120], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h10, pixelConfig[135:128], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h11, pixelConfig[143:136], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h12, pixelConfig[151:144], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h13, pixelConfig[159:152], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h14, pixelConfig[167:160], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h15, pixelConfig[175:168], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h16, pixelConfig[183:176], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h17, pixelConfig[191:184], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h18, pixelConfig[199:192], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h19, pixelConfig[207:200], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1A, pixelConfig[215:208], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1B, pixelConfig[223:216], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1C, pixelConfig[231:224], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1D, pixelConfig[239:232], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1E, pixelConfig[247:240], 1'b1);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | 16'h1F, pixelConfig[255:248], 1'b1);
    $display("BC %12d [pixel%0x%0x] config: 0x%08h",$time, pixel_x, pixel_y, pixelConfig);

    for(i=0;i<16;i=i+1) begin
      $display("BC %12d i=%6d",$time, i);
      pixel_x = $random;
      pixel_y = $random;
      pixelConfigAddr = 16'hA000 | pixel_y<<9 | pixel_x<<5;

      pixelStatusAddr = 16'h4000 | pixelConfigAddr;
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h0, pixelConfigReadback[7:0], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1, pixelConfigReadback[15:8], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h2, pixelConfigReadback[23:16], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h3, pixelConfigReadback[31:24], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h4, pixelConfigReadback[39:32], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h5, pixelConfigReadback[47:40], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h6, pixelConfigReadback[55:48], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h7, pixelConfigReadback[63:56], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h8, pixelConfigReadback[71:64], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h9, pixelConfigReadback[79:72], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hA, pixelConfigReadback[87:80], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hB, pixelConfigReadback[95:88], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hC, pixelConfigReadback[103:96], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hD, pixelConfigReadback[111:104], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hE, pixelConfigReadback[119:112], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hF, pixelConfigReadback[127:120], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h10, pixelConfigReadback[135:128], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h11, pixelConfigReadback[143:136], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h12, pixelConfigReadback[151:144], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h13, pixelConfigReadback[159:152], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h14, pixelConfigReadback[167:160], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h15, pixelConfigReadback[175:168], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h16, pixelConfigReadback[183:176], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h17, pixelConfigReadback[191:184], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h18, pixelConfigReadback[199:192], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h19, pixelConfigReadback[207:200], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1A, pixelConfigReadback[215:208], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1B, pixelConfigReadback[223:216], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1C, pixelConfigReadback[231:224], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1D, pixelConfigReadback[239:232], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1E, pixelConfigReadback[247:240], 1'b1);
      i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1F, pixelConfigReadback[255:248], 1'b1);
      $display("BC %12d [pixel%0x%0x] config readback: 0x%08h",$time, pixel_x, pixel_y, pixelConfigReadback);
      if (pixelConfig!=pixelConfigReadback)
        $display("Unexpected value: config readback!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    end
  end
  endtask


  task test_pixel_default_config;
    input [255:0] pixelConfigDefault;
    input [3:0] pixel_x;
    input [3:0] pixel_y;
    reg [255:0] pixelConfigReadback;
    reg [15:0] pixelConfigAddr;
    begin
    $display("test_pixel_default_config invoked");
    pixelConfigAddr = 16'h8000 | pixel_y<<9 | pixel_x<<5;
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h0, pixelConfigReadback[7:0], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1, pixelConfigReadback[15:8], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h2, pixelConfigReadback[23:16], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h3, pixelConfigReadback[31:24], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h4, pixelConfigReadback[39:32], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h5, pixelConfigReadback[47:40], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h6, pixelConfigReadback[55:48], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h7, pixelConfigReadback[63:56], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h8, pixelConfigReadback[71:64], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h9, pixelConfigReadback[79:72], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hA, pixelConfigReadback[87:80], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hB, pixelConfigReadback[95:88], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hC, pixelConfigReadback[103:96], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hD, pixelConfigReadback[111:104], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hE, pixelConfigReadback[119:112], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'hF, pixelConfigReadback[127:120], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h10, pixelConfigReadback[135:128], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h11, pixelConfigReadback[143:136], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h12, pixelConfigReadback[151:144], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h13, pixelConfigReadback[159:152], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h14, pixelConfigReadback[167:160], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h15, pixelConfigReadback[175:168], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h16, pixelConfigReadback[183:176], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h17, pixelConfigReadback[191:184], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h18, pixelConfigReadback[199:192], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h19, pixelConfigReadback[207:200], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1A, pixelConfigReadback[215:208], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1B, pixelConfigReadback[223:216], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1C, pixelConfigReadback[231:224], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1D, pixelConfigReadback[239:232], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1E, pixelConfigReadback[247:240], 1'b1);
    i2c_read_single(AddrSlaveDUT, pixelConfigAddr | 16'h1F, pixelConfigReadback[255:248], 1'b1);
    $display("%12d [pixel%0x%0x] config readback: 0x%4h",$time, pixel_x, pixel_y, pixelConfigReadback);
    if (pixelConfigDefault!=pixelConfigReadback)
      //$error("Unexpected value!"); 
      $display("Unexpected value: config readback!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    else
      $display("%12d [pixel%0x%0x] default values are correct ^__^|^__^|^__^",$time, pixel_x, pixel_y);
    
    end
  endtask




  task pixel_bc;
    input [3:0] pixel_x;
    input [3:0] pixel_y;
    input [7:0] pixelConfig;
    input [5:0] pixelConfigAddrIn;
    reg [15:0] pixelConfigAddr;
    begin
    $display("%12d pixel_bc: BEGIN", $time);
    $display("%12d  - pixel_x         : 0x%h", $time, pixel_x);
    $display("%12d  - pixel_y         : 0x%h", $time, pixel_y);
    $display("%12d  - pixelConfig     : 0x%h", $time, pixelConfig);
    $display("%12d  - pixelConfigAddrIn: 0x%h", $time, pixelConfigAddrIn);
    pixelConfigAddr = 16'hA000 | pixel_y<<9 | pixel_x<<5;
    $display("%12d  - pixelConfigAddr: 0x%h", $time, pixelConfigAddr);
    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | pixelConfigAddrIn, pixelConfig, 1'b1);
    $display("BC %12d [pixel%0x%0x] config: 0x%h addr: 0x%h",$time, pixel_x, pixel_y, pixelConfig, pixelConfigAddrIn);
    $display("%12d pixel_bc: END", $time);

  end
  endtask


  task pixel_write;
    input [3:0] pixel_x;
    input [3:0] pixel_y;
    input [7:0] pixelConfig;
    input [5:0] pixelConfigAddrIn;
    reg [15:0] pixelConfigAddr;
    begin

    pixelConfigAddr = 16'h8000 | pixel_y<<9 | pixel_x<<5;

    i2c_write_single(AddrSlaveDUT, pixelConfigAddr | pixelConfigAddrIn, pixelConfig, 1'b1);
    $display("Pixel Write %12d [pixel%0x%0x] config: 0x%2h addr: 0x%2h",$time, pixel_x, pixel_y, pixelConfig, pixelConfigAddrIn);

  end
  endtask


  