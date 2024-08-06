
module I2Caddr_PulldownRes(VSS_D, I2CAddr_int);
input VSS_D;
inout [4:0] I2CAddr_int;


	pulldown(I2CAddr_int[0]);
	pulldown(I2CAddr_int[1]);
	pulldown(I2CAddr_int[2]);
	pulldown(I2CAddr_int[3]);
	pulldown(I2CAddr_int[4]);

endmodule
