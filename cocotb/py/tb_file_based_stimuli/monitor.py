#!/usr/bin/env python -W ignore::DeprecationWarning

import cocotb
import inspect

from cocotb.triggers import RisingEdge, FallingEdge, Timer

@cocotb.coroutine
async def fc_serial_dump(dut, filename):
    """
    Coroutine function to dump serial FC data to a file.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """

    # Get interface handles
    fc_serial = dut.FastComSerial
    cnt_fc_dump = dut.cnt_fcDump

    with open(filename, 'w') as file:
        while not dut.done.value:
            # Dump serial FC @ 320 MHz (= 1,280 MHz / 4)
            await RisingEdge(cnt_fc_dump[1])
            time_ns = str(cocotb.utils.get_sim_time(units='ns'))
            file.write('{}ns,{}\n'.format(time_ns, fc_serial.value))
            file.flush()

@cocotb.coroutine
async def fc_parallel_dump(dut, filename):
    """
    Coroutine function to dump parallel FC data to a file.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """

    # Get interface handles
    fc_parallel = dut.FastComParallel
    cnt_fc_dump = dut.cnt_fcDump

    with open(filename, 'w') as file:
        while not dut.done.value:
            # Dump parallel FC @ 40 MHz (= 1,280 MHz / 32)
            await RisingEdge(cnt_fc_dump[4])
            time_ns = str(cocotb.utils.get_sim_time(units='ns'))
            file.write('{}ns,{}\n'.format(time_ns, fc_parallel.value))
            file.flush()

@cocotb.coroutine
async def monitor_fc(dut, serial_filename, parallel_filename):
    """
    Coroutine function to monitor FC data.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    # Get interface handles
    fc_serial = dut.FastComSerial
    fc_parallel = dut.FastComParallel
    cnt_fc_dump = dut.cnt_fcDump
    clk1280 = dut.CLK1280

    cnt_fc_dump.value = 0

    task_fc_serial_dump = cocotb.start_soon(fc_serial_dump(dut, serial_filename))
    task_fc_parallel_dump = cocotb.start_soon(fc_parallel_dump(dut, parallel_filename))

    # Counter (or decrementer) @ 1,280MHz
    while not dut.done.value:
        await RisingEdge(clk1280)
        cnt_fc_dump.value = cnt_fc_dump.value - 1
    #dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))

@cocotb.coroutine
async def dor_serial_dump(dut, filename):
    """
    Coroutine function to dump serial DOR data to a file.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    cnt_fc_dump = dut.cnt_fcDump
    dor_serial = dut.DOR
    with open(filename, 'w') as file:
        while not dut.done.value:
            await RisingEdge(cnt_fc_dump[0])
            time_ns = str(cocotb.utils.get_sim_time(units='ns'))
            file.write('{}ns,{}\n'.format(time_ns, dor_serial.value))
            file.flush()

@cocotb.coroutine
async def dor_parallel_dump(dut, filename):
    """
    Coroutine function to dump parallel DOR data to a file.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    cnt_dor_dump = dut.cnt_dataDump
    dor_parallel = dut.DataCheck_inst.DataWord
    with open(filename, 'w') as file:
        while not dut.done.value:
            await RisingEdge(cnt_dor_dump[5])
            time_ns = str(cocotb.utils.get_sim_time(units='ns'))
            file.write('{}ns,{}\n'.format(time_ns, dor_parallel.value))
            file.flush()

@cocotb.coroutine
async def monitor_dor(dut, serial_filename, parallel_filename):
    """
    Coroutine function to monitor DOR data.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    cnt_dor_dump = dut.cnt_dataDump
    cnt_fc_dump = dut.cnt_fcDump
    clk1280 = dut.CLK1280

    cnt_dor_dump.value = 0

    task_dor_serial_dump = cocotb.start_soon(dor_serial_dump(dut, serial_filename))
    task_dor_parallel_dump = cocotb.start_soon(dor_parallel_dump(dut, parallel_filename))

    while not dut.done.value:
        await FallingEdge(cnt_fc_dump[0])
        if (cnt_dor_dump.value == 39):
            cnt_dor_dump.value = 0
        else:
            cnt_dor_dump.value = cnt_dor_dump.value + 1
    #dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))
