#!/usr/bin/env python -W ignore::DeprecationWarning

import csv

import cocotb
import inspect

from utils.i2c_utils import *

from cocotb.triggers import RisingEdge, Timer   
from cocotb.types import LogicArray, Range

@cocotb.coroutine
async def driver_i2c(dut, i2c_stimuli_csv):
    """
    A coroutine function that drives I2C stimuli based on a CSV file.

    Args:
        dut: The DUT (Device Under Test) object.
        i2c_stimuli_csv (str): The path to the CSV file containing the I2C stimuli.

    Returns:
        None
    """

    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))

    def get_i2c_info(csv_row):
        """
        Parses a CSV row and returns the I2C information as a dictionary.

        Args:
            csv_row (list): The CSV row containing the I2C information.

        Returns:
            dict: The I2C information as a dictionary.
        """
        i2c_time = int(csv_row[0])
        i2c_command = csv_row[1]
        if i2c_command == 'i2c_nop':
            return {
                'i2c_time' : i2c_time,
                'i2c_command' : i2c_command
                }
        elif i2c_command == 'i2c_write_single':
            i2c_dev_addr = LogicArray(int(csv_row[2], 16), Range(6, 'downto', 0))
            i2c_reg_addr = LogicArray(int(csv_row[3], 16), Range(15, 'downto', 0))
            i2c_reg_data = LogicArray(int(csv_row[4], 16), Range(7, 'downto', 0))
            return {
                'i2c_time' : i2c_time,
                'i2c_command' : i2c_command,
                'i2c_dev_addr' : i2c_dev_addr,
                'i2c_reg_addr' : i2c_reg_addr,
                'i2c_reg_data' : i2c_reg_data
                }
        elif i2c_command == 'i2c_pixel_bc':
            i2c_dev_addr = LogicArray(int(csv_row[2], 16), Range(6, 'downto', 0))
            i2c_pixel_x = LogicArray(int(csv_row[3], 16), Range(3, 'downto', 0))
            i2c_pixel_y = LogicArray(int(csv_row[4], 16), Range(3, 'downto', 0))
            i2c_pixel_config = LogicArray(int(csv_row[5], 16), Range(7, 'downto', 0))
            i2c_pixel_addrin = LogicArray(int(csv_row[6], 16), Range(4, 'downto', 0))
            return {
                'i2c_time' : i2c_time,
                'i2c_command' : i2c_command,
                'i2c_dev_addr' : i2c_dev_addr,
                'i2c_pixel_x' : i2c_pixel_x,
                'i2c_pixel_y' : i2c_pixel_y,
                'i2c_pixel_config' : i2c_pixel_config,
                'i2c_pixel_addrin' : i2c_pixel_addrin
            }
        elif i2c_command == 'i2c_pixel_write':
            i2c_dev_addr = LogicArray(int(csv_row[2], 16), Range(6, 'downto', 0))
            i2c_pixel_x = LogicArray(int(csv_row[3], 16), Range(3, 'downto', 0))
            i2c_pixel_y = LogicArray(int(csv_row[4], 16), Range(3, 'downto', 0))
            i2c_pixel_config = LogicArray(int(csv_row[5], 16), Range(7, 'downto', 0))
            i2c_pixel_addrin = LogicArray(int(csv_row[6], 16), Range(4, 'downto', 0))
            return {
                'i2c_time' : i2c_time,
                'i2c_command' : i2c_command,
                'i2c_dev_addr' : i2c_dev_addr,
                'i2c_pixel_x' : i2c_pixel_x,
                'i2c_pixel_y' : i2c_pixel_y,
                'i2c_pixel_config' : i2c_pixel_config,
                'i2c_pixel_addrin' : i2c_pixel_addrin
            }
        return None

    # Get interface handles
    start = dut.FCStart

    await RisingEdge(start)

    # Open the CSV file
    with open(i2c_stimuli_csv, 'r') as file:
        i2c_csv_file_reader = csv.reader(file)
        # Iterate over each row in the csv
        for csv_row in i2c_csv_file_reader:
            i2c_info = get_i2c_info(csv_row)

            if i2c_info['i2c_command'] == 'i2c_nop':
                dut._log.info('i2c_nop')
                i2c_time = i2c_info['i2c_time']

                if i2c_time > 0:
                    await Timer(i2c_time, 'ns')

            elif i2c_info['i2c_command'] == 'i2c_write_single':
                dut._log.info('i2c_write_single')
                i2c_time = i2c_info['i2c_time']
                i2c_dev_addr = i2c_info['i2c_dev_addr']
                i2c_reg_addr = i2c_info['i2c_reg_addr']
                i2c_reg_data = i2c_info['i2c_reg_data']

                if i2c_time > 0:
                    await Timer(i2c_time, 'ns')
                await i2c_write_single(dut, i2c_dev_addr, i2c_reg_addr, i2c_reg_data, True)

            elif i2c_info['i2c_command'] == 'i2c_pixel_bc':
                dut._log.info('i2c_pixel_bc')
                i2c_time = i2c_info['i2c_time']
                i2c_dev_addr = i2c_info['i2c_dev_addr']
                i2c_pixel_x = i2c_info['i2c_pixel_x']
                i2c_pixel_y = i2c_info['i2c_pixel_y']
                i2c_pixel_config = i2c_info['i2c_pixel_config']
                i2c_pixel_addrin = i2c_info['i2c_pixel_addrin']

                if i2c_time > 0:
                    await Timer(i2c_time, 'ns')
                await i2c_pixel_bc(dut, i2c_dev_addr, i2c_pixel_x, i2c_pixel_y, i2c_pixel_config, i2c_pixel_addrin)

            elif i2c_info['i2c_command'] == 'i2c_pixel_write':
                dut._log.info('i2c_pixel_write')
                i2c_time = i2c_info['i2c_time']
                i2c_dev_addr = i2c_info['i2c_dev_addr']
                i2c_pixel_x = i2c_info['i2c_pixel_x']
                i2c_pixel_y = i2c_info['i2c_pixel_y']
                i2c_pixel_config = i2c_info['i2c_pixel_config']
                i2c_pixel_addrin = i2c_info['i2c_pixel_addrin']

                if i2c_time > 0:
                    await Timer(i2c_time, 'ns')
                await i2c_pixel_write(dut, i2c_dev_addr, i2c_pixel_x, i2c_pixel_y, i2c_pixel_config, i2c_pixel_addrin)

    await(cocotb.triggers.Timer(500, 'ns'))

    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))
