`timescale 1ns/1ns

module powerOnResetLong (
  POR, VDD, VSS
);
  //tmrg do_not_touch
    output reg POR;
    inout VDD, VSS;

  initial
    begin
      POR=1;
    end

    always #1000 POR = ~VDD;
endmodule
