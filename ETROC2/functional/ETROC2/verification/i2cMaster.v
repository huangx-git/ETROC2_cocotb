  parameter  I2CSDADEL  = 100;
  parameter  I2CPER = 250 ; // 4MHz
  // parameter  I2CPER = 1000 ; // 1MHz
  // parameter  I2CPER = 2500 ; // 400KHz
//  parameter  I2CPER = 3000 ; // 333KHz
//  parameter  I2CPER = 5000 ; // 200KHz
//    parameter  I2CPER = 4000 ; // 250KHz

  reg  MS_SDAout;
  reg  MS_SDAen;
  wire SL_SDAout;
  wire SL_SDAen;

  reg  MS_SCLout;
  reg  MS_SCLen;
  wire SL_SCLout;
  wire SL_SCLen;

  integer i2cTimeToStop;
  integer timeTmr=0;

  parameter I2CIDLE=0,I2CSTART=1,I2CDEVADR=2,I2CRW=3,I2CDEVACK=4,I2CREGADR=5,I2CREGADR2=6,I2CREGACK=7,I2CDATA=8,I2CDATAACK=9,I2CSTOP=10;
  reg  [5:0] i2cstate=I2CIDLE;
  reg  i2cError;
  initial
  begin
    i2cError=0;
    i2cTimeToStop=0;

  end
  task i2c_error;
    begin
      i2cError=1;
      #1;
      i2cError=0;
      $stop;
    end
  endtask


  reg [7:0] i2c_del_time=0;
  integer i2c_del_seed=1;
/*
  task i2c_start;
    begin
      i2c_del_time=$random(i2c_del_seed);
      #(10+i2c_del_time);
      // - start -
      i2cstate=I2CSTART;
      MS_SCLout = 1'b1;
      MS_SCLen  = 1'b1;
      #(I2CPER/2); //start bit
      MS_SDAout = 1'b1;
      MS_SDAen  = 1'b1;
      #(I2CPER/2); //start bit
      MS_SDAout = 1'b0;
      #(I2CPER/2); //clock down
      MS_SCLout = 1'b0;
      #(I2CPER/2); //clock down
    end
  endtask
*/

  task i2c_start;   //modifed by quan
    begin
      i2c_del_time=$random(i2c_del_seed);
      #(10+i2c_del_time);
      // - start -
      i2cstate=I2CSTART;
      MS_SDAout = 1'b1;
      MS_SDAen  = 1'b1;
      #(I2CPER/2); //start bit
      MS_SCLout = 1'b1;
      MS_SCLen  = 1'b1;
      #(I2CPER/2); //start bit
      MS_SDAout = 1'b0;
      #(I2CPER/2); //clock down
      MS_SCLout = 1'b0;
      #(I2CPER/2); //clock down
    end
  endtask

  task i2c_stop;
    begin
      // stop

      #(I2CPER/2);
      i2cstate=I2CSTOP;
      MS_SCLen   = 1'b1;
      MS_SCLout  = 1'b0;
      #(I2CPER/2);
      MS_SDAen   = 1'b1;
      MS_SDAout  = 1'b0;

      #(I2CPER/2);
      MS_SCLen  = 1'b0;
      #(I2CPER/2);
      MS_SDAen  = 1'b0;

      MS_SDAout = 1'b1;
      MS_SCLout = 1'b1;
      i2cstate=I2CIDLE;
    end
  endtask

  task i2c_write_bits;
    input [7:0] data;
    input [3:0] bits;
    integer i;
    begin
      #(I2CSDADEL/4);
      MS_SDAen = 1'b1;
      for(i=bits; i > 0; i = i - 1) begin
          #(I2CPER/4);
          MS_SDAout = data[i-1];
          #(I2CPER/4);
          MS_SCLout = 1'b1;
          #(I2CPER/2);
          MS_SCLout = 1'b0;
      end
    end
  endtask


  task i2c_read_bits;
    output [7:0] data;
    input [3:0] bits;
    integer i;
    begin
      #(I2CSDADEL);
      MS_SDAen = 1'b0;
      MS_SDAout = 1'b1;

      for(i=bits; i > 0; i = i - 1) begin
          timeTmr = 0;
          #(I2CPER/2-I2CSDADEL);
          MS_SCLout = 1'b1;

          #(I2CPER/8);
          timeTmr = timeTmr + SDA;
          #(I2CPER/8);
          timeTmr = timeTmr + SDA;
          #(I2CPER/8);
          timeTmr = timeTmr + SDA;
          #(I2CPER/8);

          data[i-1]=0;
          if (timeTmr>=2)
              data[i-1]=1;

          MS_SCLout = 1'b0;
          #(I2CSDADEL);
      end

      MS_SDAen = 1'b1;
      MS_SDAout = 1'b0;
//      $display("rd %02x",data);
    end
  endtask

  task i2c_write_single;
    input [6:0] slave_addr;
    input [15:0] reg_addr;
    input [7:0] data;
    input reportError;
    integer i;
    reg ack;
    begin
      $display("%12d i2c_write_single: BEGIN", $time);
      $display("%12d  - slave_addr : 0x%h", $time, slave_addr);
      $display("%12d  - reg_addr   : 0x%h", $time, reg_addr);
      $display("%12d  - data       : 0x%h", $time, data);
      $display("%12d  - reportError: 0x%h", $time, reportError);

      $display("%12d [i2c wr %h/%h] %h", $time, slave_addr, reg_addr, data);

      i2c_start;

      // SEND SLAVE ADDR
      i2cstate=I2CDEVADR;
      i2c_write_bits(slave_addr,7);

      // R/W= 0 (write)
      i2cstate=I2CRW;
      i2c_write_bits(1'b0,1);

      // wait for ack
      i2cstate=I2CDEVACK;
      i2c_read_bits(ack,1);
      if (ack)
      begin
        if (reportError)
        begin
          $display("ERROR: i2c_write_single no ack after dev address! (time : %d)",$time);
          i2c_error;
        end
        i2c_stop;
      end
      else
      begin
        // register address
        i2cstate=I2CREGADR;
        i2c_write_bits(reg_addr[7:0],8);

        // wait for ack
        i2cstate=I2CREGACK;
        i2c_read_bits(ack,1);
        if (ack)
        begin
          if (reportError)
          begin
            $display("ERROR: i2c_write_single no ack after register address! (time : %d)",$time);
            i2c_error;
          end
          i2c_stop;
        end
        else
        begin
          // register address
          i2cstate=I2CREGADR;
          i2c_write_bits(reg_addr[15:8],8);

          // wait for ack
          i2cstate=I2CREGACK;
          i2c_read_bits(ack,1);
          if (ack)
          begin
            if (reportError)
            begin
              $display("ERROR: i2c_write_single no ack after register address (2nd byte)! (time : %d)",$time);
              i2c_error;
            end
            i2c_stop;
          end
          else
          begin
            // register address
            i2cstate=I2CDATA;
            i2c_write_bits(data,8);

            // wait for ack
            i2cstate=I2CDATAACK;
            i2c_read_bits(ack,1);

            if (ack)
            begin
              if (reportError)
              begin
                $display("ERROR: i2c_write_single no ack after data! (time : %d)",$time);
                i2c_error;
              end
              i2c_stop;
            end
          MS_SDAen = 1'b0;
          #(i2cTimeToStop);
          i2c_stop;
          end
        end
      end
      $display("%12d i2c_write_single: END", $time);
    end
  endtask


  task i2c_read_single;
    input [6:0] slave_addr;
    input [15:0] reg_addr;
    output [7:0] data;
    input reportError;
    integer i;
    reg ack;
    begin

      i2c_start;

      // SEND SLAVE ADDR
      i2cstate=I2CDEVADR;
      i2c_write_bits(slave_addr,7);

      // R/W= 0 (write)
      i2cstate=I2CRW;
      i2c_write_bits(1'b0,1);

      // wait for ack
      i2cstate=I2CDEVACK;
      i2c_read_bits(ack,1);

      if (ack)
      begin
        if (reportError)
        begin
          $display("ERROR: i2c_read_single no ack after device address! (time : %d)",$time);
          i2c_error;
        end
        i2c_stop;
      end
      else
      begin
        // register address
        i2cstate=I2CREGADR;
        i2c_write_bits(reg_addr[7:0],8);

        // wait for ack
        i2cstate=I2CREGACK;
        i2c_read_bits(ack,1);

        if (ack)
        begin
          if (reportError)
          begin
            $display("ERROR: i2c_read_single no ack after register address! (time : %d)",$time);
            i2c_error;
          end
          i2c_stop;
        end
        else
        begin
          // register address
          i2cstate=I2CREGADR;
          i2c_write_bits(reg_addr[15:8],8);

          // wait for ack
          i2cstate=I2CREGACK;
          i2c_read_bits(ack,1);

          if (ack)
          begin
            if (reportError)
            begin
              $display("ERROR: i2c_read_single no ack after register address (2nd byt)! (time : %d)",$time);
              i2c_error;
            end
            i2c_stop;
          end
          else
          begin
            #(I2CPER);
            i2c_start;

            // SEND SLAVE ADDR
            i2cstate=I2CDEVADR;
            i2c_write_bits(slave_addr,7);

            // R/W= 1 (read)
            i2cstate=I2CRW;
            i2c_write_bits(1'b1,1);

            i2cstate=I2CDEVACK;
            i2c_read_bits(ack,1);

            // register address
            i2cstate=I2CDATA;
            i2c_read_bits(data,8);

            // write no ack
            i2c_write_bits(1'b1,1);

            i2c_stop;

            $display("%12d [i2c rd %2h/%h] %2h",$time, slave_addr, reg_addr, data);
          end
        end
      end

    end
  endtask

/*
  always @(MS_SDAen or MS_SDAout or SL_SDAen or SL_SDAout)
    begin
      if (MS_SDAen)
        SDA = MS_SDAout;
      else
        if (SL_SDAen)
          SDA = SL_SDAout;
        else
          SDA = 1'b1;
    end

  always @(MS_SCLen or MS_SCLout or SL_SCLen or SL_SCLout)
    begin
      if (MS_SCLen)
        SCL = MS_SCLout;
      else
        if (SL_SCLen)
          SCL = SL_SCLout;
        else
          SCL = 1'b1;
    end
*/
  initial
    begin
      MS_SCLen  = 1'b0;
      MS_SCLout = 1'b1;
      MS_SDAen  = 1'b0;
      MS_SDAout = 1'b1;
   end

  localparam CERN_IO_DS_HIGH     = 1'b1;
  localparam CERN_IO_DS_LOW      = 1'b0;
  localparam CERN_IO_PULLENABLE  = 1'b1;
  localparam CERN_IO_PULLDISABLE = 1'b0;
  localparam CERN_IO_PULLUP      = 1'b1;
  localparam CERN_IO_PULLDOWN    = 1'b0;

  IO_1P2V_C4 SDA_IO (
      .A(1'b0),
      .DS(CERN_IO_DS_LOW),
      .IO(SDA),
      .OUT_EN( (~MS_SDAout) & MS_SDAen),
      .PEN(CERN_IO_PULLENABLE),
      .UD(CERN_IO_PULLUP),
      .Z(),
      .Z_h()
  );
  IO_1P2V_C4 SCL_IO (
      .A(MS_SCLout),
      .DS(CERN_IO_DS_LOW),
      .IO(SCL),
      .OUT_EN(MS_SCLen),
      .PEN(1'b0),
      .UD(CERN_IO_PULLUP),
      .Z(),
      .Z_h()
  );



  task i2c_write_two;
    input [6:0] slave_addr;
    input [7:0] reg_addr;
    input [7:0] data1;
    input [7:0] data2;
    input reportError;
    integer i,j;
    reg [7:0] data;
    reg ack;
    begin
      i2c_start;

      // SEND SLAVE ADDR
      i2cstate=I2CDEVADR;
      i2c_write_bits(slave_addr,7);

      // R/W= 0 (write)
      i2cstate=I2CRW;
      i2c_write_bits(1'b0,1);

      // wait for ack
      i2cstate=I2CDEVACK;
      i2c_read_bits(ack,1);
      if (ack)
      begin
        if (reportError)
        begin
          $display("ERROR: i2c_write_two no ack after dev address! (time : %d)",$time);
          i2c_error;
        end
        i2c_stop;
      end
      else
      begin
        // register address
        i2cstate=I2CREGADR;
        i2c_write_bits(reg_addr,8);

        // wait for ack
        i2cstate=I2CREGACK;
        i2c_read_bits(ack,1);
        if (ack)
        begin
          if (reportError)
          begin
            $display("ERROR: i2c_write_two no ack after register address! (time : %d)",$time);
            i2c_error;
          end
          i2c_stop;
        end
        else
        begin
          for (j=0;j<2;j=j+1)
          begin
            // data
            i2cstate=I2CDATA;
            if(j==0)
              data=data1;
            else
              data=data2;

            $display("%12d [i2c wr%1d %2h/%2h] %2h",$time,j,slave_addr, reg_addr+j, data);
            i2c_write_bits(data,8);


            // wait for ack
            i2cstate=I2CDATAACK;
            i2c_read_bits(ack,1);

            if (ack)
            begin
              if (reportError)
              begin
                $display("ERROR: i2c_write_two no ack after data! (time : %d)",$time);
                i2c_error;
              end
              i2c_stop;
            end
          end
          MS_SDAen = 1'b0;
          #(i2cTimeToStop);
          i2c_stop;
        end
      end
    end
  endtask


task i2c_read_two;
    input [6:0] slave_addr;
    input [7:0] reg_addr;
    output [7:0] data1;
    output [7:0] data2;
    input reportError;
    reg [7:0] data;
    integer i,j;
    reg ack;
    begin

      i2c_start;

      // SEND SLAVE ADDR
      i2cstate=I2CDEVADR;
      i2c_write_bits(slave_addr,7);

      // R/W= 0 (write)
      i2cstate=I2CRW;
      i2c_write_bits(1'b0,1);

      // wait for ack
      i2cstate=I2CDEVACK;
      i2c_read_bits(ack,1);

      if (ack)
      begin
        if (reportError)
        begin
          $display("ERROR: i2c_read_two no ack after device address! (time : %d)",$time);
          i2c_error;
        end
        i2c_stop;
      end
      else
      begin
        // register address
        i2cstate=I2CREGADR;
        i2c_write_bits(reg_addr,8);

        // wait for ack
        i2cstate=I2CREGACK;
        i2c_read_bits(ack,1);

        if (ack)
        begin
          if (reportError)
          begin
            $display("ERROR: i2c_read_two no ack after register address! (time : %d)",$time);
            i2c_error;
          end
          i2c_stop;
        end
        else
        begin
           #(I2CPER);
          i2c_start;

          // SEND SLAVE ADDR
          i2cstate=I2CDEVADR;
          i2c_write_bits(slave_addr,7);

          // R/W= 1 (read)
          i2cstate=I2CRW;
          i2c_write_bits(1'b1,1);

          i2cstate=I2CDEVACK;
          i2c_read_bits(ack,1);

          for (j=0;j<2;j=j+1)
          begin

            // register address
            i2cstate=I2CDATA;
            i2c_read_bits(data,8);

            $display("%12d [i2c rd%1d %2h/%2h] %2h",$time,j, slave_addr, reg_addr+j, data);
            if (j==0)
            begin
              data1=data;
              i2c_write_bits(1'b0,1);
            end
            else
            begin
              data2=data;
              i2c_write_bits(1'b1,1);
            end
          end

          i2c_stop;

        end
      end

    end
  endtask



