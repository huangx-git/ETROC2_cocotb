#!/usr/bin/env python -W ignore::DeprecationWarning

import cocotb
import inspect

@cocotb.coroutine
async def driver_general(dut):
    """
    This function is a driver for the general stimuli in the ETROC2 project.
    It initializes the dut signals and performs a power-up sequence.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))   

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
    dut._log.info('BEGIN power-up sequence')
    await(cocotb.triggers.Timer(120000 + 30000, 'ns'))
    dut._log.info('END   power-up sequence')
    
    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))

