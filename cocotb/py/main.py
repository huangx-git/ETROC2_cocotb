#!/usr/bin/env python -W ignore::DeprecationWarning

import cocotb
import inspect

from tb_file_based_stimuli.driver_general import driver_general
from tb_file_based_stimuli.driver_i2c import driver_i2c
from tb_file_based_stimuli.driver_fc import driver_fc
from tb_file_based_stimuli.monitor import monitor_fc
from tb_file_based_stimuli.monitor import monitor_dor

from tb_peripheral_config_registers_on_reset import driver_peripheral_config_registers_on_reset
from tb_peripheral_config_registers_on_reset import monitor_peripheral_config_registers_on_reset

@cocotb.test()
async def test_file_base_stimuli(dut):
    """
    Test function for file-based stimuli.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    clock_info_dict = {
        'CLK40' :   [ 25000,   24960, 'ps'],
        'CLK320' :  [  3125,    3120, 'ps'],
        'CLK1280' : [   781.25,  780, 'ps'],
    }

    # Get interface handles

    # Start a general signal driver
    task_driver_1 = cocotb.start_soon(driver_general(dut))
    # Start I2C signal driver
    task_driver_2 = cocotb.start_soon(driver_i2c(dut, i2c_stimuli_csv='csv/i2c_tb_inputs.csv'))
    # Start FastCommand driver
    fc_start_delay_ps = clock_info_dict['CLK40'][1]
    task_driver_3 = cocotb.start_soon(driver_fc(dut, start_delay_ps=fc_start_delay_ps, fc_stimuli_csv='csv/fc_tb_inputs.csv'))

    # Start FastCommand and data-out-right tracing
    task_fc_monitor = cocotb.start_soon(monitor_fc(dut, serial_filename='fc_serial.cocotb.txt', parallel_filename='fc_parallel.cocotb.txt'))
    task_dor_monitor = cocotb.start_soon(monitor_dor(dut, serial_filename='dor_serial.cocotb.txt', parallel_filename='dor_parallel.cocotb.txt'))

    await cocotb.triggers.Combine (
        task_driver_1,
        task_driver_2,
        task_driver_3
    )

    dut.done.value = 1
    dut._log.info('TB (cocotb) done!')
    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))

@cocotb.test()
async def test_peripheral_config_registers_on_reset(dut):
    """
    Test function for peripheral configuration registers on reset.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    clock_info_dict = {
        'CLK40' :   [ 25000,   24960, 'ps'],
        'CLK320' :  [  3125,    3120, 'ps'],
        'CLK1280' : [   781.25,  780, 'ps'],
    }

    # Get interface handles

    # Start signal driver
    task_driver = cocotb.start_soon(driver_peripheral_config_registers_on_reset(dut))
    # Start monitor peripheral configuration registers after reset
    task_monitor = cocotb.start_soon(monitor_peripheral_config_registers_on_reset(dut))

    await cocotb.triggers.Combine (
        task_driver,
        task_monitor,
    )

    dut.done.value = 1
    dut._log.info('TB (cocotb) done!')
    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))
