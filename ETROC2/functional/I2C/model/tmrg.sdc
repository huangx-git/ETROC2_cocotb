set sdc_version 1.3

set tmrgSucces 0
set tmrgFailed 0
proc constrainNet netName {
  global tmrgSucces
  global tmrgFailed
  # find nets matching netName pattern
  set nets [dc::get_net $netName]
  if {[llength $nets] != 0} {
    set_dont_touch $nets
    incr tmrgSucces
  } else {
    puts "\[TMRG\] Warning! Net(s) '$netName' not found"
    incr tmrgFailed
  }
}

constrainNet /PER/A0in
constrainNet /PER/A0inA
constrainNet /PER/A0inB
constrainNet /PER/A0inC
constrainNet /PER/A1in
constrainNet /PER/A1inA
constrainNet /PER/A1inB
constrainNet /PER/A1inC
constrainNet /PER/AinA[*]
constrainNet /PER/AinB[*]
constrainNet /PER/AinC[*]
constrainNet /PER/Ain[*]
constrainNet /PER/BMA/wbWeDelNextA[*]
constrainNet /PER/BMA/wbWeDelNextB[*]
constrainNet /PER/BMA/wbWeDelNextC[*]
constrainNet /PER/BMA/wbWeDelNextVotedA[*]
constrainNet /PER/BMA/wbWeDelNextVotedB[*]
constrainNet /PER/BMA/wbWeDelNextVotedC[*]
constrainNet /PER/I2C/SCLA[*]
constrainNet /PER/I2C/SCLB[*]
constrainNet /PER/I2C/SCLC[*]
constrainNet /PER/I2C/SCLVotedA[*]
constrainNet /PER/I2C/SCLVotedB[*]
constrainNet /PER/I2C/SCLVotedC[*]
constrainNet /PER/I2C/SCLffA
constrainNet /PER/I2C/SCLffB
constrainNet /PER/I2C/SCLffC
constrainNet /PER/I2C/SCLffVotedA
constrainNet /PER/I2C/SCLffVotedB
constrainNet /PER/I2C/SCLffVotedC
constrainNet /PER/I2C/SCLfilterA[*]
constrainNet /PER/I2C/SCLfilterB[*]
constrainNet /PER/I2C/SCLfilterC[*]
constrainNet /PER/I2C/SCLfilterVotedA[*]
constrainNet /PER/I2C/SCLfilterVotedB[*]
constrainNet /PER/I2C/SCLfilterVotedC[*]
constrainNet /PER/I2C/SDAA[*]
constrainNet /PER/I2C/SDAB[*]
constrainNet /PER/I2C/SDAC[*]
constrainNet /PER/I2C/SDAVotedA[*]
constrainNet /PER/I2C/SDAVotedB[*]
constrainNet /PER/I2C/SDAVotedC[*]
constrainNet /PER/I2C/SDAenIntA
constrainNet /PER/I2C/SDAenIntB
constrainNet /PER/I2C/SDAenIntC
constrainNet /PER/I2C/SDAenIntVotedA
constrainNet /PER/I2C/SDAenIntVotedB
constrainNet /PER/I2C/SDAenIntVotedC
constrainNet /PER/I2C/SDAffA
constrainNet /PER/I2C/SDAffB
constrainNet /PER/I2C/SDAffC
constrainNet /PER/I2C/SDAffVotedA
constrainNet /PER/I2C/SDAffVotedB
constrainNet /PER/I2C/SDAffVotedC
constrainNet /PER/I2C/SDAfilterA[*]
constrainNet /PER/I2C/SDAfilterB[*]
constrainNet /PER/I2C/SDAfilterC[*]
constrainNet /PER/I2C/SDAfilterVotedA[*]
constrainNet /PER/I2C/SDAfilterVotedB[*]
constrainNet /PER/I2C/SDAfilterVotedC[*]
constrainNet /PER/I2C/SDAoutIntA
constrainNet /PER/I2C/SDAoutIntB
constrainNet /PER/I2C/SDAoutIntC
constrainNet /PER/I2C/SDAoutIntVotedA
constrainNet /PER/I2C/SDAoutIntVotedB
constrainNet /PER/I2C/SDAoutIntVotedC
constrainNet /PER/I2C/activeA
constrainNet /PER/I2C/activeB
constrainNet /PER/I2C/activeC
constrainNet /PER/I2C/activeVotedA
constrainNet /PER/I2C/activeVotedB
constrainNet /PER/I2C/activeVotedC
constrainNet /PER/I2C/bufferA[*]
constrainNet /PER/I2C/bufferB[*]
constrainNet /PER/I2C/bufferC[*]
constrainNet /PER/I2C/bufferVotedA[*]
constrainNet /PER/I2C/bufferVotedB[*]
constrainNet /PER/I2C/bufferVotedC[*]
constrainNet /PER/I2C/i2cAddrA[*]
constrainNet /PER/I2C/i2cAddrB[*]
constrainNet /PER/I2C/i2cAddrC[*]
constrainNet /PER/I2C/i2cAddrVotedA[*]
constrainNet /PER/I2C/i2cAddrVotedB[*]
constrainNet /PER/I2C/i2cAddrVotedC[*]
constrainNet /PER/I2C/iA[*]
constrainNet /PER/I2C/iB[*]
constrainNet /PER/I2C/iC[*]
constrainNet /PER/I2C/iVotedA[*]
constrainNet /PER/I2C/iVotedB[*]
constrainNet /PER/I2C/iVotedC[*]
constrainNet /PER/I2C/stateA[*]
constrainNet /PER/I2C/stateB[*]
constrainNet /PER/I2C/stateC[*]
constrainNet /PER/I2C/stateVotedA[*]
constrainNet /PER/I2C/stateVotedB[*]
constrainNet /PER/I2C/stateVotedC[*]
constrainNet /PER/I2C/timeoutCntA[*]
constrainNet /PER/I2C/timeoutCntB[*]
constrainNet /PER/I2C/timeoutCntC[*]
constrainNet /PER/I2C/timeoutCntVotedA[*]
constrainNet /PER/I2C/timeoutCntVotedB[*]
constrainNet /PER/I2C/timeoutCntVotedC[*]
constrainNet /PER/I2C/wbAdrA[*]
constrainNet /PER/I2C/wbAdrB[*]
constrainNet /PER/I2C/wbAdrC[*]
constrainNet /PER/I2C/wbAdrVotedA[*]
constrainNet /PER/I2C/wbAdrVotedB[*]
constrainNet /PER/I2C/wbAdrVotedC[*]
constrainNet /PER/I2C/wbDataInA[*]
constrainNet /PER/I2C/wbDataInB[*]
constrainNet /PER/I2C/wbDataInC[*]
constrainNet /PER/I2C/wbDataInVotedA[*]
constrainNet /PER/I2C/wbDataInVotedB[*]
constrainNet /PER/I2C/wbDataInVotedC[*]
constrainNet /PER/I2C/wbDataOutA[*]
constrainNet /PER/I2C/wbDataOutB[*]
constrainNet /PER/I2C/wbDataOutC[*]
constrainNet /PER/I2C/wbDataOutVotedA[*]
constrainNet /PER/I2C/wbDataOutVotedB[*]
constrainNet /PER/I2C/wbDataOutVotedC[*]
constrainNet /PER/I2C/wbWeA
constrainNet /PER/I2C/wbWeB
constrainNet /PER/I2C/wbWeC
constrainNet /PER/I2C/wbWeVotedA
constrainNet /PER/I2C/wbWeVotedB
constrainNet /PER/I2C/wbWeVotedC
constrainNet /PER/MB/MC/memA[*]
constrainNet /PER/MB/MC/memB[*]
constrainNet /PER/MB/MC/memC[*]
constrainNet /PER/MB/MC/memVotedA[*]
constrainNet /PER/MB/MC/memVotedB[*]
constrainNet /PER/MB/MC/memVotedC[*]
constrainNet /PER/MB/defaultValueA[*]
constrainNet /PER/MB/defaultValueB[*]
constrainNet /PER/MB/defaultValueC[*]
constrainNet /PER/MB/defaultValue[*]
constrainNet /PER/MEC/errDetectedA
constrainNet /PER/MEC/errDetectedB
constrainNet /PER/MEC/errDetectedC
constrainNet /PER/MEC/errDetectedFFA
constrainNet /PER/MEC/errDetectedFFB
constrainNet /PER/MEC/errDetectedFFC
constrainNet /PER/MEC/errDetectedFFVotedA
constrainNet /PER/MEC/errDetectedFFVotedB
constrainNet /PER/MEC/errDetectedFFVotedC
constrainNet /PER/MEC/errDetectedVotedA
constrainNet /PER/MEC/errDetectedVotedB
constrainNet /PER/MEC/errDetectedVotedC
constrainNet /PER/MEC/loadA
constrainNet /PER/MEC/loadB
constrainNet /PER/MEC/loadC
constrainNet /PER/MEC/loadVotedA
constrainNet /PER/MEC/loadVotedB
constrainNet /PER/MEC/loadVotedC
constrainNet /PER/MEC/memA[*]
constrainNet /PER/MEC/memB[*]
constrainNet /PER/MEC/memC[*]
constrainNet /PER/MEC/memVotedA[*]
constrainNet /PER/MEC/memVotedB[*]
constrainNet /PER/MEC/memVotedC[*]
constrainNet /PER/PORV/inA
constrainNet /PER/PORV/inB
constrainNet /PER/PORV/inC
constrainNet /PER/PORV/inVotedA
constrainNet /PER/PORV/inVotedB
constrainNet /PER/PORV/inVotedC
constrainNet /PER/RO/CGDE/clkInA
constrainNet /PER/RO/CGDE/clkInB
constrainNet /PER/RO/CGDE/clkInC
constrainNet /PER/RO/CGDE/clkInVotedA
constrainNet /PER/RO/CGDE/clkInVotedB
constrainNet /PER/RO/CGDE/clkInVotedC
constrainNet /PER/RO/CGE/enableA
constrainNet /PER/RO/CGE/enableB
constrainNet /PER/RO/CGE/enableC
constrainNet /PER/RO/CGE/enableVotedA
constrainNet /PER/RO/CGE/enableVotedB
constrainNet /PER/RO/CGE/enableVotedC
constrainNet /PER/RO/clkEndA
constrainNet /PER/RO/clkEndB
constrainNet /PER/RO/clkEndC
constrainNet /PER/RO/clkEndVotedA
constrainNet /PER/RO/clkEndVotedB
constrainNet /PER/RO/clkEndVotedC
constrainNet /PER/RSTNin
constrainNet /PER/RSTNinA
constrainNet /PER/RSTNinB
constrainNet /PER/RSTNinC
constrainNet /PER/SCLen
constrainNet /PER/SCLenA
constrainNet /PER/SCLenB
constrainNet /PER/SCLenC
constrainNet /PER/SCLin
constrainNet /PER/SCLinA
constrainNet /PER/SCLinB
constrainNet /PER/SCLinC
constrainNet /PER/SCLout
constrainNet /PER/SCLoutA
constrainNet /PER/SCLoutB
constrainNet /PER/SCLoutC
constrainNet /PER/SDAen
constrainNet /PER/SDAenA
constrainNet /PER/SDAenB
constrainNet /PER/SDAenC
constrainNet /PER/SDAin
constrainNet /PER/SDAinA
constrainNet /PER/SDAinB
constrainNet /PER/SDAinC
constrainNet /PER/SDAout
constrainNet /PER/SDAoutA
constrainNet /PER/SDAoutB
constrainNet /PER/SDAoutC
constrainNet /PER/TOM/magicNumberOK
constrainNet /PER/TOM/magicNumberOKA
constrainNet /PER/TOM/magicNumberOKB
constrainNet /PER/TOM/magicNumberOKC
constrainNet /PER/TOM/testOutSelectA[*]
constrainNet /PER/TOM/testOutSelectB[*]
constrainNet /PER/TOM/testOutSelectC[*]
constrainNet /PER/TOM/testOutSelect[*]
constrainNet /PER/TOen
constrainNet /PER/TOenA
constrainNet /PER/TOenB
constrainNet /PER/TOenC
constrainNet /PER/busTmrErrorPresent
constrainNet /PER/busTmrErrorPresentA
constrainNet /PER/busTmrErrorPresentB
constrainNet /PER/busTmrErrorPresentC
constrainNet /PER/clkEnableRegA
constrainNet /PER/clkEnableRegAA
constrainNet /PER/clkEnableRegAB
constrainNet /PER/clkEnableRegAC
constrainNet /PER/clkEnableRegB
constrainNet /PER/clkEnableRegBA
constrainNet /PER/clkEnableRegBB
constrainNet /PER/clkEnableRegBC
constrainNet /PER/clkEnableRegC
constrainNet /PER/clkEnableRegCA
constrainNet /PER/clkEnableRegCB
constrainNet /PER/clkEnableRegCC
constrainNet /PER/defVal00A[*]
constrainNet /PER/defVal00B[*]
constrainNet /PER/defVal00C[*]
constrainNet /PER/defVal00[*]
constrainNet /PER/defVal01A[*]
constrainNet /PER/defVal01B[*]
constrainNet /PER/defVal01C[*]
constrainNet /PER/defVal01[*]
constrainNet /PER/defVal02A[*]
constrainNet /PER/defVal02B[*]
constrainNet /PER/defVal02C[*]
constrainNet /PER/defVal02[*]
constrainNet /PER/defVal03A[*]
constrainNet /PER/defVal03B[*]
constrainNet /PER/defVal03C[*]
constrainNet /PER/defVal03[*]
constrainNet /PER/defVal04A[*]
constrainNet /PER/defVal04B[*]
constrainNet /PER/defVal04C[*]
constrainNet /PER/defVal04[*]
constrainNet /PER/defVal05A[*]
constrainNet /PER/defVal05B[*]
constrainNet /PER/defVal05C[*]
constrainNet /PER/defVal05[*]
constrainNet /PER/defVal06A[*]
constrainNet /PER/defVal06B[*]
constrainNet /PER/defVal06C[*]
constrainNet /PER/defVal06[*]
constrainNet /PER/defVal07A[*]
constrainNet /PER/defVal07B[*]
constrainNet /PER/defVal07C[*]
constrainNet /PER/defVal07[*]
constrainNet /PER/defVal08A[*]
constrainNet /PER/defVal08B[*]
constrainNet /PER/defVal08C[*]
constrainNet /PER/defVal08[*]
constrainNet /PER/defVal09A[*]
constrainNet /PER/defVal09B[*]
constrainNet /PER/defVal09C[*]
constrainNet /PER/defVal09[*]
constrainNet /PER/defVal0AA[*]
constrainNet /PER/defVal0AB[*]
constrainNet /PER/defVal0AC[*]
constrainNet /PER/defVal0A[*]
constrainNet /PER/defVal0BA[*]
constrainNet /PER/defVal0BB[*]
constrainNet /PER/defVal0BC[*]
constrainNet /PER/defVal0B[*]
constrainNet /PER/defVal0CA[*]
constrainNet /PER/defVal0CB[*]
constrainNet /PER/defVal0CC[*]
constrainNet /PER/defVal0C[*]
constrainNet /PER/defVal0DA[*]
constrainNet /PER/defVal0DB[*]
constrainNet /PER/defVal0DC[*]
constrainNet /PER/defVal0D[*]
constrainNet /PER/defVal0EA[*]
constrainNet /PER/defVal0EB[*]
constrainNet /PER/defVal0EC[*]
constrainNet /PER/defVal0E[*]
constrainNet /PER/defVal0FA[*]
constrainNet /PER/defVal0FB[*]
constrainNet /PER/defVal0FC[*]
constrainNet /PER/defVal0F[*]
constrainNet /PER/defVal10A[*]
constrainNet /PER/defVal10B[*]
constrainNet /PER/defVal10C[*]
constrainNet /PER/defVal10[*]
constrainNet /PER/defVal11A[*]
constrainNet /PER/defVal11B[*]
constrainNet /PER/defVal11C[*]
constrainNet /PER/defVal11[*]
constrainNet /PER/defVal12A[*]
constrainNet /PER/defVal12B[*]
constrainNet /PER/defVal12C[*]
constrainNet /PER/defVal12[*]
constrainNet /PER/defVal13A[*]
constrainNet /PER/defVal13B[*]
constrainNet /PER/defVal13C[*]
constrainNet /PER/defVal13[*]
constrainNet /PER/defVal14A[*]
constrainNet /PER/defVal14B[*]
constrainNet /PER/defVal14C[*]
constrainNet /PER/defVal14[*]
constrainNet /PER/defVal15A[*]
constrainNet /PER/defVal15B[*]
constrainNet /PER/defVal15C[*]
constrainNet /PER/defVal15[*]
constrainNet /PER/defVal16A[*]
constrainNet /PER/defVal16B[*]
constrainNet /PER/defVal16C[*]
constrainNet /PER/defVal16[*]
constrainNet /PER/defVal17A[*]
constrainNet /PER/defVal17B[*]
constrainNet /PER/defVal17C[*]
constrainNet /PER/defVal17[*]
constrainNet /PER/defVal18A[*]
constrainNet /PER/defVal18B[*]
constrainNet /PER/defVal18C[*]
constrainNet /PER/defVal18[*]
constrainNet /PER/defVal19A[*]
constrainNet /PER/defVal19B[*]
constrainNet /PER/defVal19C[*]
constrainNet /PER/defVal19[*]
constrainNet /PER/defVal1AA[*]
constrainNet /PER/defVal1AB[*]
constrainNet /PER/defVal1AC[*]
constrainNet /PER/defVal1A[*]
constrainNet /PER/defVal1BA[*]
constrainNet /PER/defVal1BB[*]
constrainNet /PER/defVal1BC[*]
constrainNet /PER/defVal1B[*]
constrainNet /PER/defVal1CA[*]
constrainNet /PER/defVal1CB[*]
constrainNet /PER/defVal1CC[*]
constrainNet /PER/defVal1C[*]
constrainNet /PER/defVal1DA[*]
constrainNet /PER/defVal1DB[*]
constrainNet /PER/defVal1DC[*]
constrainNet /PER/defVal1D[*]
constrainNet /PER/defVal1EA[*]
constrainNet /PER/defVal1EB[*]
constrainNet /PER/defVal1EC[*]
constrainNet /PER/defVal1E[*]
constrainNet /PER/defVal1FA[*]
constrainNet /PER/defVal1FB[*]
constrainNet /PER/defVal1FC[*]
constrainNet /PER/defVal1F[*]
constrainNet /PER/defValA[*]
constrainNet /PER/defValB[*]
constrainNet /PER/defValC[*]
constrainNet /PER/defVal[*]
constrainNet /PER/i2cActive
constrainNet /PER/i2cActiveA
constrainNet /PER/i2cActiveB
constrainNet /PER/i2cActiveC
constrainNet /PER/i2cStart
constrainNet /PER/i2cStartA
constrainNet /PER/i2cStartB
constrainNet /PER/i2cStartC
constrainNet /PER/i2cStop
constrainNet /PER/i2cStopA
constrainNet /PER/i2cStopB
constrainNet /PER/i2cStopC
constrainNet /PER/reg21A[*]
constrainNet /PER/reg21B[*]
constrainNet /PER/reg21C[*]
constrainNet /PER/reg21[*]
constrainNet /PER/testOutSelectA[*]
constrainNet /PER/testOutSelectB[*]
constrainNet /PER/testOutSelectC[*]
constrainNet /PER/testOutSelect[*]
constrainNet /PM/PC/PIX/HIGH
constrainNet /PM/PC/PIX/HIGHA
constrainNet /PM/PC/PIX/HIGHB
constrainNet /PM/PC/PIX/HIGHC
constrainNet /PM/PC/PIX/LOW
constrainNet /PM/PC/PIX/LOWA
constrainNet /PM/PC/PIX/LOWB
constrainNet /PM/PC/PIX/LOWC
constrainNet /PM/PC/PIX/PD/MC/memA[*]
constrainNet /PM/PC/PIX/PD/MC/memB[*]
constrainNet /PM/PC/PIX/PD/MC/memC[*]
constrainNet /PM/PC/PIX/PD/MC/memVotedA[*]
constrainNet /PM/PC/PIX/PD/MC/memVotedB[*]
constrainNet /PM/PC/PIX/PD/MC/memVotedC[*]
constrainNet /PM/PC/PIX/PD/defaultPixelConfigA[*]
constrainNet /PM/PC/PIX/PD/defaultPixelConfigB[*]
constrainNet /PM/PC/PIX/PD/defaultPixelConfigC[*]
constrainNet /PM/PC/PIX/PD/defaultPixelConfig[*]
constrainNet /PM/PC/PIX/PD/pixelConfigA[*]
constrainNet /PM/PC/PIX/PD/pixelConfigB[*]
constrainNet /PM/PC/PIX/PD/pixelConfigC[*]
constrainNet /PM/PC/PIX/PD/pixelConfig[*]
constrainNet /PM/PC/PIX/PD/pixelIDA[*]
constrainNet /PM/PC/PIX/PD/pixelIDB[*]
constrainNet /PM/PC/PIX/PD/pixelIDC[*]
constrainNet /PM/PC/PIX/PD/pixelID[*]
constrainNet /PM/PC/PIX/PD/pixelStatusA[*]
constrainNet /PM/PC/PIX/PD/pixelStatusB[*]
constrainNet /PM/PC/PIX/PD/pixelStatusC[*]
constrainNet /PM/PC/PIX/PD/pixelStatus[*]
constrainNet /PM/PC/PIX/defaultPixelConfigA[*]
constrainNet /PM/PC/PIX/defaultPixelConfigB[*]
constrainNet /PM/PC/PIX/defaultPixelConfigC[*]
constrainNet /PM/PC/PIX/defaultPixelConfig[*]
constrainNet /PM/PC/PIX/pixelConfigA[*]
constrainNet /PM/PC/PIX/pixelConfigB[*]
constrainNet /PM/PC/PIX/pixelConfigC[*]
constrainNet /PM/PC/PIX/pixelConfig[*]
constrainNet /PM/PC/PIX/pixelIDA[*]
constrainNet /PM/PC/PIX/pixelIDB[*]
constrainNet /PM/PC/PIX/pixelIDC[*]
constrainNet /PM/PC/PIX/pixelID[*]
constrainNet /PM/PC/PIX/pixelStatusA[*]
constrainNet /PM/PC/PIX/pixelStatusB[*]
constrainNet /PM/PC/PIX/pixelStatusC[*]
constrainNet /PM/PC/PIX/pixelStatus[*]
constrainNet /regIn100A[*]
constrainNet /regIn100B[*]
constrainNet /regIn100C[*]
constrainNet /regIn100[*]
constrainNet /regIn101A[*]
constrainNet /regIn101B[*]
constrainNet /regIn101C[*]
constrainNet /regIn101[*]
constrainNet /regIn102A[*]
constrainNet /regIn102B[*]
constrainNet /regIn102C[*]
constrainNet /regIn102[*]
constrainNet /regIn103A[*]
constrainNet /regIn103B[*]
constrainNet /regIn103C[*]
constrainNet /regIn103[*]
constrainNet /regIn104A[*]
constrainNet /regIn104B[*]
constrainNet /regIn104C[*]
constrainNet /regIn104[*]
constrainNet /regIn105A[*]
constrainNet /regIn105B[*]
constrainNet /regIn105C[*]
constrainNet /regIn105[*]
constrainNet /regIn106A[*]
constrainNet /regIn106B[*]
constrainNet /regIn106C[*]
constrainNet /regIn106[*]
constrainNet /regIn107A[*]
constrainNet /regIn107B[*]
constrainNet /regIn107C[*]
constrainNet /regIn107[*]
constrainNet /regIn108A[*]
constrainNet /regIn108B[*]
constrainNet /regIn108C[*]
constrainNet /regIn108[*]
constrainNet /regIn109A[*]
constrainNet /regIn109B[*]
constrainNet /regIn109C[*]
constrainNet /regIn109[*]
constrainNet /regIn10AA[*]
constrainNet /regIn10AB[*]
constrainNet /regIn10AC[*]
constrainNet /regIn10A[*]
constrainNet /regIn10BA[*]
constrainNet /regIn10BB[*]
constrainNet /regIn10BC[*]
constrainNet /regIn10B[*]
constrainNet /regIn10CA[*]
constrainNet /regIn10CB[*]
constrainNet /regIn10CC[*]
constrainNet /regIn10C[*]
constrainNet /regIn10DA[*]
constrainNet /regIn10DB[*]
constrainNet /regIn10DC[*]
constrainNet /regIn10D[*]
constrainNet /regIn10EA[*]
constrainNet /regIn10EB[*]
constrainNet /regIn10EC[*]
constrainNet /regIn10E[*]
constrainNet /regIn10FA[*]
constrainNet /regIn10FB[*]
constrainNet /regIn10FC[*]
constrainNet /regIn10F[*]
constrainNet /regOut00A[*]
constrainNet /regOut00B[*]
constrainNet /regOut00C[*]
constrainNet /regOut00[*]
constrainNet /regOut01A[*]
constrainNet /regOut01B[*]
constrainNet /regOut01C[*]
constrainNet /regOut01[*]
constrainNet /regOut02A[*]
constrainNet /regOut02B[*]
constrainNet /regOut02C[*]
constrainNet /regOut02[*]
constrainNet /regOut03A[*]
constrainNet /regOut03B[*]
constrainNet /regOut03C[*]
constrainNet /regOut03[*]
constrainNet /regOut04A[*]
constrainNet /regOut04B[*]
constrainNet /regOut04C[*]
constrainNet /regOut04[*]
constrainNet /regOut05A[*]
constrainNet /regOut05B[*]
constrainNet /regOut05C[*]
constrainNet /regOut05[*]
constrainNet /regOut06A[*]
constrainNet /regOut06B[*]
constrainNet /regOut06C[*]
constrainNet /regOut06[*]
constrainNet /regOut07A[*]
constrainNet /regOut07B[*]
constrainNet /regOut07C[*]
constrainNet /regOut07[*]
constrainNet /regOut08A[*]
constrainNet /regOut08B[*]
constrainNet /regOut08C[*]
constrainNet /regOut08[*]
constrainNet /regOut09A[*]
constrainNet /regOut09B[*]
constrainNet /regOut09C[*]
constrainNet /regOut09[*]
constrainNet /regOut0AA[*]
constrainNet /regOut0AB[*]
constrainNet /regOut0AC[*]
constrainNet /regOut0A[*]
constrainNet /regOut0BA[*]
constrainNet /regOut0BB[*]
constrainNet /regOut0BC[*]
constrainNet /regOut0B[*]
constrainNet /regOut0CA[*]
constrainNet /regOut0CB[*]
constrainNet /regOut0CC[*]
constrainNet /regOut0C[*]
constrainNet /regOut0DA[*]
constrainNet /regOut0DB[*]
constrainNet /regOut0DC[*]
constrainNet /regOut0D[*]
constrainNet /regOut0EA[*]
constrainNet /regOut0EB[*]
constrainNet /regOut0EC[*]
constrainNet /regOut0E[*]
constrainNet /regOut0FA[*]
constrainNet /regOut0FB[*]
constrainNet /regOut0FC[*]
constrainNet /regOut0F[*]
constrainNet /regOut10A[*]
constrainNet /regOut10B[*]
constrainNet /regOut10C[*]
constrainNet /regOut10[*]
constrainNet /regOut11A[*]
constrainNet /regOut11B[*]
constrainNet /regOut11C[*]
constrainNet /regOut11[*]
constrainNet /regOut12A[*]
constrainNet /regOut12B[*]
constrainNet /regOut12C[*]
constrainNet /regOut12[*]
constrainNet /regOut13A[*]
constrainNet /regOut13B[*]
constrainNet /regOut13C[*]
constrainNet /regOut13[*]
constrainNet /regOut14A[*]
constrainNet /regOut14B[*]
constrainNet /regOut14C[*]
constrainNet /regOut14[*]
constrainNet /regOut15A[*]
constrainNet /regOut15B[*]
constrainNet /regOut15C[*]
constrainNet /regOut15[*]
constrainNet /regOut16A[*]
constrainNet /regOut16B[*]
constrainNet /regOut16C[*]
constrainNet /regOut16[*]
constrainNet /regOut17A[*]
constrainNet /regOut17B[*]
constrainNet /regOut17C[*]
constrainNet /regOut17[*]
constrainNet /regOut18A[*]
constrainNet /regOut18B[*]
constrainNet /regOut18C[*]
constrainNet /regOut18[*]
constrainNet /regOut19A[*]
constrainNet /regOut19B[*]
constrainNet /regOut19C[*]
constrainNet /regOut19[*]
constrainNet /regOut1AA[*]
constrainNet /regOut1AB[*]
constrainNet /regOut1AC[*]
constrainNet /regOut1A[*]
constrainNet /regOut1BA[*]
constrainNet /regOut1BB[*]
constrainNet /regOut1BC[*]
constrainNet /regOut1B[*]
constrainNet /regOut1CA[*]
constrainNet /regOut1CB[*]
constrainNet /regOut1CC[*]
constrainNet /regOut1C[*]
constrainNet /regOut1DA[*]
constrainNet /regOut1DB[*]
constrainNet /regOut1DC[*]
constrainNet /regOut1D[*]
constrainNet /regOut1EA[*]
constrainNet /regOut1EB[*]
constrainNet /regOut1EC[*]
constrainNet /regOut1E[*]
constrainNet /regOut1FA[*]
constrainNet /regOut1FB[*]
constrainNet /regOut1FC[*]
constrainNet /regOut1F[*]


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
