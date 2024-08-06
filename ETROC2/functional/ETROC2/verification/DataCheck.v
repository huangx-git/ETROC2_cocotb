
module DataCheck(
    input CLK1280,
    input DataIn
    );

reg CLKBit=0;
reg [39:0] DataWordTemp;            // a temperary registers group to host possible word
reg [39:0] DataWord;                // word identified
reg [5:0] AlignCounter;             // the counter used to sync the word
reg [23:0] FrameCount = 0;           // the number of frame 
reg [15:0] ReAlignCount = 0;          // the number of re-alignment: the word identifier found at a unexpected place

localparam WordIdentifier	= 16'H3C5C;

always@(posedge CLK1280) begin      // need to modify according to the data rate
    CLKBit <= ~CLKBit;              //640 MHz for 640 Mbps data rate
end

always@(posedge CLKBit) begin
    DataWordTemp <= {DataIn, DataWordTemp[39:1]};
end

always@(posedge CLKBit) begin
    if(DataWordTemp[39:24] == WordIdentifier)
        AlignCounter <= 0;
    else
        if(AlignCounter == 39)
            AlignCounter <= 0;
        else
            AlignCounter <= AlignCounter + 1;
end

always@(posedge CLKBit) begin
    if(DataWordTemp[39:24] == WordIdentifier && AlignCounter!=39)
        ReAlignCount <= ReAlignCount + 1;
end

always@(posedge CLKBit) begin
    if(AlignCounter == 39)
        DataWord <= DataWordTemp;
end

wire [7:0] FH_L1Counter;
wire [1:0] FH_TYPE;
wire [11:0] FH_BCID;
wire [1:0] FD_EA;
wire [3:0] FD_Col_ID, FD_Row_ID;
wire [9:0] FD_TOA_CODE, FD_CAL_CODE;
wire [8:0] FD_TOT_CODE;
wire [16:0] FT_CHIPID;
wire [5:0] FT_STATUS;
wire [7:0] FT_HITS;
wire [7:0] FT_CRC;
wire [7:0] FF_RT_L1Counter;
wire [1:0] FF_EBS;
wire [11:0] FF_RT_BCID;

assign FH_L1Counter = DataWord[21:14];
assign FH_TYPE = DataWord[13:12];
assign FH_BCID = DataWord[11:0];
assign FD_EA = DataWord[38:37];
assign FD_Col_ID = DataWord[36:33];
assign FD_Row_ID = DataWord[32:29];
assign FD_TOA_CODE = DataWord[28:19];
assign FD_TOT_CODE = DataWord[18:10];
assign FD_CAL_CODE = DataWord[9:0];
assign FT_CHIPID = DataWord[38:22];
assign FT_STATUS = DataWord[21:16];
assign FT_HITS = DataWord[15:8];
assign FT_CRC = DataWord[7:0];
assign FF_RT_L1Counter = DataWord[21:14];
assign FF_EBS = DataWord[13:12];
assign FF_RT_BCID = DataWord[11:0];

endmodule