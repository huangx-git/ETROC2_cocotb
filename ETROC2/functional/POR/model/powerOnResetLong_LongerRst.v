`timescale 1ns/1ns

module powerOnResetLong_LongerRst (
  POR, VDD, VSS
);
  //tmrg do_not_touch
    output reg POR;
    inout VDD, VSS;

  initial
    begin
      POR=1;
    end

  always #1800 POR = ~VDD;
endmodule
