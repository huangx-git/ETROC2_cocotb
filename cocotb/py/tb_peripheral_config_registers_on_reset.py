#!/usr/bin/env python -W ignore::DeprecationWarning

import cocotb
import inspect

from cocotb.triggers import RisingEdge, FallingEdge
from cocotb.types import Logic, LogicArray

@cocotb.coroutine
async def driver_peripheral_config_registers_on_reset(dut):
    """
    This coroutine function monitor the peripheral configuration registers after reset.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))   
    # Get interface handles
    #start = dut.FCStart

    dut.done.value = 0
    
    dut.VSS.value = 0.0
    dut.VDD1P2.value = 0.0
    dut.VDD2P5.value = 0.0
    dut.VDD_Dig.value = 0
    dut.CLK40REF.value = 0
    dut.CLK320.value = 0
    dut.CLK1280.value = 0
    dut.FCStart.value = 0
    dut.RSTN.value = 1
    
    await(cocotb.triggers.Timer(1000, 'ns'))
    dut._log.debug('RSTN = 0')
    dut.RSTN.value = 0
    
    await(cocotb.triggers.Timer(2000, 'ns'))
    dut._log.debug('VDDs = ...')
    dut.VDD1P2.value = 1.2
    dut.VDD_Dig.value = 1
    
    await(cocotb.triggers.Timer(3000, 'ns'))
    dut._log.debug('RSTN = 1')
    dut.RSTN.value = 1
    
    await(cocotb.triggers.Timer(300, 'ns'))
    dut._log.debug('FCStart = 1')
    dut.FCStart.value = 1

    await(cocotb.triggers.Timer(148 + 148, 'ns'))
#    dut._log.info('BEGIN power-up sequence')
#    await(cocotb.triggers.Timer(120000 + 30000, 'ns'))
#    dut._log.info('END   power-up sequence')
    
    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))

@cocotb.coroutine
async def monitor_peripheral_config_registers_on_reset(dut):
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))

    # After reset pulse
    await(FallingEdge(dut.RSTN))
    await(RisingEdge(dut.RSTN))
    dut._log.info('AFTER RSTN {}'.format(inspect.currentframe().f_code.co_name))

    # 1. readoutClockDelayPixel[4:0]
    assert(dut.ETROC2_inst.I2CCon_readoutClockDelayPixelA.value == 0b00000)
    assert(dut.ETROC2_inst.I2CCon_readoutClockDelayPixelB.value == 0b00000)
    assert(dut.ETROC2_inst.I2CCon_readoutClockDelayPixelC.value == 0b00000)
    
    # 2. readoutClockWidthPixel[4:0]
    assert(dut.ETROC2_inst.I2CCon_readoutClockWidthPixelA.value == 0b10000)
    assert(dut.ETROC2_inst.I2CCon_readoutClockWidthPixelB.value == 0b10000)
    assert(dut.ETROC2_inst.I2CCon_readoutClockWidthPixelC.value == 0b10000)
    
    # 3. readoutClockDelayGlobal[4:0]
    assert(dut.ETROC2_inst.I2CCon_readoutClockDelayGlobalA.value == 0b00000)
    assert(dut.ETROC2_inst.I2CCon_readoutClockDelayGlobalB.value == 0b00000)
    assert(dut.ETROC2_inst.I2CCon_readoutClockDelayGlobalC.value == 0b00000)
    
    # 4. readoutClockWidthGlobal[4:0]
    assert(dut.ETROC2_inst.I2CCon_readoutClockWidthGlobalA.value == 0b10000)
    assert(dut.ETROC2_inst.I2CCon_readoutClockWidthGlobalB.value == 0b10000)
    assert(dut.ETROC2_inst.I2CCon_readoutClockWidthGlobalC.value == 0b10000)
    
    # 5. serRateRight[1:0]
    assert(dut.ETROC2_inst.I2CCon_serRateRightA.value == 0b01)
    assert(dut.ETROC2_inst.I2CCon_serRateRightB.value == 0b01)
    assert(dut.ETROC2_inst.I2CCon_serRateRightC.value == 0b01)
    
    # 6. serRateLeft[1:0]
    assert(dut.ETROC2_inst.I2CCon_serRateLeftA.value == 0b01)
    assert(dut.ETROC2_inst.I2CCon_serRateLeftB.value == 0b01)
    assert(dut.ETROC2_inst.I2CCon_serRateLeftC.value == 0b01)
    
    # 7. linkResetTestPattern
    assert(dut.ETROC2_inst.I2CCon_linkResetTestPatternA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_linkResetTestPatternB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_linkResetTestPatternC.value == 0b1)

    # 8. linkResetFixedPattern[31:0]
    assert(dut.ETROC2_inst.I2CCon_linkResetFixedPatternA.value == 0xACC78CC5)
    assert(dut.ETROC2_inst.I2CCon_linkResetFixedPatternB.value == 0xACC78CC5)
    assert(dut.ETROC2_inst.I2CCon_linkResetFixedPatternC.value == 0xACC78CC5)

    # 9. emptySlotBCID[11:0]
    assert(dut.ETROC2_inst.I2CCon_emptySlotBCIDA.value == 0b000000000001)
    assert(dut.ETROC2_inst.I2CCon_emptySlotBCIDB.value == 0b000000000001)
    assert(dut.ETROC2_inst.I2CCon_emptySlotBCIDC.value == 0b000000000001)

    # 10. triggerGranularity[2:0]
    assert(dut.ETROC2_inst.I2CCon_triggerGranularityA.value == 0b00)
    assert(dut.ETROC2_inst.I2CCon_triggerGranularityB.value == 0b00)
    assert(dut.ETROC2_inst.I2CCon_triggerGranularityC.value == 0b00)

    # 11. disScrambler
    assert(dut.ETROC2_inst.I2CCon_disScramblerA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_disScramblerB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_disScramblerC.value == 0b0)

    # 12. mergeTriggerData
    assert(dut.ETROC2_inst.I2CCon_mergeTriggerDataA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_mergeTriggerDataB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_mergeTriggerDataC.value == 0b0)

    # 13. singlePort
    assert(dut.ETROC2_inst.I2CCon_singlePortA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_singlePortB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_singlePortC.value == 0b1)

    # 14. onChipL1AConf[1:0]
    assert(dut.ETROC2_inst.I2CCon_onChipL1AConfA.value == 0b00)
    assert(dut.ETROC2_inst.I2CCon_onChipL1AConfB.value == 0b00)
    assert(dut.ETROC2_inst.I2CCon_onChipL1AConfC.value == 0b00)

    # 15. BCIDoffset[11:0]
    assert(dut.ETROC2_inst.I2CCon_BCIDoffsetA.value == 0x0d0)
    assert(dut.ETROC2_inst.I2CCon_BCIDoffsetB.value == 0x0d0)
    assert(dut.ETROC2_inst.I2CCon_BCIDoffsetC.value == 0x0d0)

    # 16. fcSelfAlignEn
    #     fcSelfAlign
    assert(dut.ETROC2_inst.I2CCon_fcSelfAlignA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_fcSelfAlignB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_fcSelfAlignC.value == 0b0)

    # 17. fcClkDelayEn
    assert(dut.ETROC2_inst.I2CCon_fcClkDelayEnA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_fcClkDelayEnB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_fcClkDelayEnC.value == 0b0)

    # 18. fcDataDelayEn
    assert(dut.ETROC2_inst.I2CCon_fcDataDelayEnA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_fcDataDelayEnB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_fcDataDelayEnC.value == 0b0)

    # 19. chargeInjectionDelay
    assert(dut.ETROC2_inst.I2CCon_chargeInjectionDelayA.value == 0x18)
    assert(dut.ETROC2_inst.I2CCon_chargeInjectionDelayB.value == 0x18)
    assert(dut.ETROC2_inst.I2CCon_chargeInjectionDelayC.value == 0x18)

    # 20. RefStrSel[7:0]
    assert(dut.ETROC2_inst.I2CCon_RefStrSel.value == 0b00000011)

    # 21. PLL_BiasGen_CONFIG[3:0]
    assert(dut.ETROC2_inst.I2CCon_PLL_BiasGen_CONFIG.value == 0b1000)

    # 22. PLL_CONFIG_I_PLL[3:0]
    assert(dut.ETROC2_inst.I2CCon_PLL_CONFIG_I_PLL.value == 0b1001)

    # 23. PLL_CONFIG_P_PLL[3:0]
    assert(dut.ETROC2_inst.I2CCon_PLL_CONFIG_P_PLL.value == 0b1001)
        
    # 24. PLL_R_CONFIG[3:0]
    assert(dut.ETROC2_inst.I2CCon_PLL_R_CONFIG.value == 0b0010)

    # 25. PLL_vcoDAC[3:0]
    assert(dut.ETROC2_inst.I2CCon_PLL_vcoDAC.value == 0b1000)

    # 26. PLL_vcoRailMode
    assert(dut.ETROC2_inst.I2CCon_PLL_vcoRailMode.value == 0b1)

    # 27. PLL_ENABLEPLL
    assert(dut.ETROC2_inst.I2CCon_PLL_ENABLEPLL.value == 0b0)

    # 28. PLL_FBDiv_skip
    #     FBDiv_skip
    assert(dut.ETROC2_inst.I2CCon_FBDiv_skipA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_FBDiv_skipB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_FBDiv_skipC.value == 0b0)

    # 29. PLL_FBDiv_clkTreeDisable
    #     FBDiv_clkTreeDisable
    assert(dut.ETROC2_inst.I2CCon_FBDiv_clkTreeDisableA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_FBDiv_clkTreeDisableB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_FBDiv_clkTreeDisableC.value == 0b0)

    # 30. PLLclkgen_disSER
    #     CLKGen_disSER
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disSERA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disSERB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disSERC.value == 0b1)

    # 31. PLLclkgen_disVCO
    #     CLKGen_disVCO
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disVCOA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disVCOB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disVCOC.value == 0b0)

    # 32. PLLclkgen_disEOM
    #     CLKGen_disEOM
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disEOMA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disEOMB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disEOMC.value == 0b1)

    # 33. PLLclkgen_disCLK
    #     CLKGen_disCLK
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disCLKA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disCLKB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disCLKC.value == 0b0)

    # 34. PLLclkgen_disDES
    #     CLKGen_disDES
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disDESA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disDESB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_CLKGen_disDESC.value == 0b0)

    # 35. CLKSel
    assert(dut.ETROC2_inst.I2CCon_CLKSel.value == 0b1)

    # 36. PS_CPCurrent[3:0]
    assert(dut.ETROC2_inst.I2CCon_PS_CPCurrent.value == 0b0001)

    # 37. PS_CapRst
    assert(dut.ETROC2_inst.I2CCon_PS_CapRstA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_PS_CapRstB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_PS_CapRstC.value == 0b0)

    # 38. PS_Enable
    assert(dut.ETROC2_inst.I2CCon_PS_EnableA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_PS_EnableB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_PS_EnableC.value == 0b1)

    # 39. PS_ForceDown
    assert(dut.ETROC2_inst.I2CCon_PS_ForceDown.value == 0b0)

    # 40. PS_PhaseAdj[7:0]
    assert(dut.ETROC2_inst.I2CCon_PS_PhaseAdj.value == 0b00000000)

    # 41. CLK40_EnRx
    assert(dut.ETROC2_inst.CLK40_EnRx.value == 0b1)

    # 42. CLK40_EnTer
    assert(dut.ETROC2_inst.CLK40_EnTer.value == 0b1)

    # 43. CLK40_Equ[1:0]
    assert(dut.ETROC2_inst.CLK40_Equ.value == 0b00)

    # 44. CLK40_InvData
    assert(dut.ETROC2_inst.CLK40_InvData.value == 0b0)

    # 45. CLK40_SetCM
    assert(dut.ETROC2_inst.CLK40_SetCM.value == 0b1)

    # 46. CLK1280_EnRx
    assert(dut.ETROC2_inst.CLK1280_EnRx.value == 0b1)

    # 47. CLK1280_EnTer
    assert(dut.ETROC2_inst.CLK1280_EnTer.value == 0b1)

    # 48. CLK1280_Equ[1:0]
    assert(dut.ETROC2_inst.CLK1280_Equ.value == 0b00)

    # 49. CLK1280_InvData
    assert(dut.ETROC2_inst.CLK1280_InvData.value == 0b0)

    # 50. CLK1280_SetCM
    assert(dut.ETROC2_inst.CLK1280_SetCM.value == 0b1)

    # 51. FC_EnRx
    assert(dut.ETROC2_inst.FC_EnRx.value == 0b1)

    # 52. FC_EnTer
    assert(dut.ETROC2_inst.FC_EnTer.value == 0b1)

    # 53. FC_Equ[1:0]
    assert(dut.ETROC2_inst.FC_Equ.value == 0b00)

    # 54. FC_InvData
    assert(dut.ETROC2_inst.FC_InvData.value == 0b0)

    # 55. FC_SetCM
    assert(dut.ETROC2_inst.FC_SetCM.value == 0b1)

    # 56. disPowerSequence
    assert(dut.ETROC2_inst.I2CCon_disPowerSequenceA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_disPowerSequenceB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_disPowerSequenceC.value == 0b0)

    # 57. softBoot
    assert(dut.ETROC2_inst.I2CCon_softBootA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_softBootB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_softBootC.value == 0b0)

    # 58. eFuse_TCKHP[3:0]
    #     EFuse_TCKHP[3:0]
    assert(dut.ETROC2_inst.I2CCon_EFuse_TCKHP.value == 0b0100)

    # 59. eFuse_EnClk
    #     EFuse_EnClk
    assert(dut.ETROC2_inst.I2CCon_EFuse_EnClk.value == 0b0)

    # 60. eFuse_Mode[1:0]
    #     EFuse_Mode[1:0]
    assert(dut.ETROC2_inst.I2CCon_EFuse_Mode.value == 0b10)

    # 61. eFuse_Rstn
    #     EFuse_Rst
    assert(dut.ETROC2_inst.I2CCon_EFuse_Rst.value == 0b1)

    # 62. eFuse_Start
    #     EFuse_Start
    assert(dut.ETROC2_inst.I2CCon_EFuse_Start.value == 0b0)

    # 63. eFuse_Prog[31:0]
    #     EFuse_Prog[31:0]
    assert(dut.ETROC2_inst.I2CCon_EFuse_Prog.value == 0b00000000000000000000000000000000)

    # 64. eFuse_Bypass
    #     EFuse_Bypass --> Implicit declaration
    #assert(dut.ETROC2_inst.I2CCon_EFuse_Bypass.value == 0b1)

    # 65. lfLockThrCounter[3:0]
    assert(dut.ETROC2_inst.I2CCon_lfLockThrCounterA.value == 0xb)
    assert(dut.ETROC2_inst.I2CCon_lfLockThrCounterB.value == 0xb)
    assert(dut.ETROC2_inst.I2CCon_lfLockThrCounterC.value == 0xb)

    # 66. lfReLockThrCounter[3:0]
    assert(dut.ETROC2_inst.I2CCon_lfReLockThrCounterA.value == 0xb)
    assert(dut.ETROC2_inst.I2CCon_lfReLockThrCounterB.value == 0xb)
    assert(dut.ETROC2_inst.I2CCon_lfReLockThrCounterC.value == 0xb)

    # 67. lfUnLockThrCounter[3:0]
    assert(dut.ETROC2_inst.I2CCon_lfUnLockThrCounterA.value == 0xb)
    assert(dut.ETROC2_inst.I2CCon_lfUnLockThrCounterB.value == 0xb)
    assert(dut.ETROC2_inst.I2CCon_lfUnLockThrCounterC.value == 0xb)

    # 68. asyAlignFastcommand
    assert(dut.ETROC2_inst.I2CCon_asyAlignFastcommandA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_asyAlignFastcommandB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_asyAlignFastcommandC.value == 0b0)

    # 69. asyLinkReset
    assert(dut.ETROC2_inst.I2CCon_asyLinkResetA.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_asyLinkResetB.value == 0b0)
    assert(dut.ETROC2_inst.I2CCon_asyLinkResetC.value == 0b0)

    # 70. asyPLLReset
    assert(dut.ETROC2_inst.I2CCon_asyPLLResetA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyPLLResetB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyPLLResetC.value == 0b1)

    # 71. asyResetChargeInj
    assert(dut.ETROC2_inst.I2CCon_asyResetChargeInjA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyResetChargeInjB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyResetChargeInjC.value == 0b1)

    # 72. asyResetFastcommand
    assert(dut.ETROC2_inst.I2CCon_asyResetFastcommandA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyResetFastcommandB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyResetFastcommandC.value == 0b1)

    # 73. asyResetGlobalReadout
    assert(dut.ETROC2_inst.I2CCon_asyResetGlobalReadoutA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyResetGlobalReadoutB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyResetGlobalReadoutC.value == 0b1)

    # 74. asyResetLockDetect
    assert(dut.ETROC2_inst.I2CCon_asyResetLockDetectA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyResetLockDetectB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyResetLockDetectC.value == 0b1)

    # 75. asyStartCalibration
    assert(dut.ETROC2_inst.I2CCon_asyStartCalibrationA.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyStartCalibrationB.value == 0b1)
    assert(dut.ETROC2_inst.I2CCon_asyStartCalibrationC.value == 0b1)

    # 76. VRefGen_PD
    #     VRefGenPD
    assert(dut.ETROC2_inst.I2CCon_VRefGenPD.value == 0b0)

    # 77. TS_PD
    assert(dut.ETROC2_inst.I2CCon_TSPD.value == 0b0)

    # 78. TDCClockTest
    assert(dut.ETROC2_inst.I2CCon_TDCClockTest.value == 0b0)

    # 79. TDCStrobeTest
    assert(dut.ETROC2_inst.I2CCon_TDCStrobeTest.value == 0b0)

    # 80. LTx_AmplSel[2:0]
    assert(dut.ETROC2_inst.I2CCon_LTx_AmplSel.value == 0b100)

    # 81. RTx_AmplSel[2:0]
    assert(dut.ETROC2_inst.I2CCon_RTx_AmplSel.value == 0b100)

    # 82. disLTx
    assert(dut.ETROC2_inst.I2CCon_disLTx.value == 0b0)

    # 83. disRTx
    assert(dut.ETROC2_inst.I2CCon_disRTx.value == 0b0)

    # 84. GRO_TOARST_N
    assert(dut.ETROC2_inst.I2CCon_GRO_TOARST_N.value == 0b1)

    # 85. GRO_Start
    assert(dut.ETROC2_inst.I2CCon_GRO_Start.value == 0b0)

    # 86. GRO_TOA_Latch
    assert(dut.ETROC2_inst.I2CCon_GRO_TOA_Latch.value == 0b1)

    # 87. GRO_TOA_CK
    assert(dut.ETROC2_inst.I2CCon_GRO_TOA_CK.value == 0b1)

    # 88. GRO_TOT_CK
    assert(dut.ETROC2_inst.I2CCon_GRO_TOT_CK.value == 0b1)

    # 89. GRO_TOTRST_N
    assert(dut.ETROC2_inst.I2CCon_GRO_TOTRST_N.value == 0b1)

    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))
