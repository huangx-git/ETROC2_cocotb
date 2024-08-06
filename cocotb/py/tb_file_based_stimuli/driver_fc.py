#!/usr/bin/env python -W ignore::DeprecationWarning

import csv
import cocotb
import inspect

from cocotb.triggers import RisingEdge, FallingEdge, Timer

@cocotb.coroutine
async def driver_fc(dut, start_delay_ps, fc_stimuli_csv):
    """
    Coroutine function that drives the Fast Command (FC) stimuli to the dut.

    Args:
        dut: The DUT (Device Under Test) object.
        start_delay_ps: The delay in picoseconds before starting the stimuli.
        fc_stimuli_csv: The path to the CSV file containing the FC stimuli.

    Returns:
        None
    """

    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))

    # FastCommand encoding
    fast_command_dict = {
        'IDLE'         : '11110000', # F0
        'LinkReset'    : '00110011', # 33
        'BCR'          : '01011010', # 5A
        'SyncForTrig'  : '01010101', # 55
        'L1A_CR'       : '01100110', # 66
        'ChargeInj'    : '01101001', # 69
        'L1A'          : '10010110', # 96
        'L1A_BCR'      : '10011001', # 99
        'WS_Start'     : '10100101', # A5
        'WS_Stop'      : '10101010'  # AA
    }

    def get_fast_command_info(csv_row):
        """
        Helper function to extract fast command information from a CSV row.

        Args:
            csv_row: A list representing a row in the CSV file.

        Returns:
            Tuple containing the fast command name, encoding, and count.
        """

        fc_name = csv_row[0]
        fc_encoding = fast_command_dict[fc_name]
        fc_count = int(csv_row[1])
        return fc_name, fc_encoding, fc_count

    # Get interface handles
    clk320 = dut.CLK320
    fc_serial = dut.FastComSerial
    fc_parallel = dut.FastComParallel

    # 24.96ns, 8 clk320 cycles
    #for _ in range(8):
    #    await RisingEdge(clk320)
    await(Timer(start_delay_ps, 'ps'))

    # Open the CSV file
    with open(fc_stimuli_csv, 'r') as file:
        fc_csv_file_reader = csv.reader(file)
        # Iterate over each row in the csv
        for csv_row in fc_csv_file_reader:
            fc_name, fc_encoding, fc_count = get_fast_command_info(csv_row)

            # Send FC and as many FC as specified in the CSV file
            for d in range (fc_count):
                    # ... send it serially (1 bit per clock cycle)
                    for i in range(7, -1, -1):
                        await FallingEdge(clk320)
                        dut.FastComParallel.value = int(fc_encoding, 2)
                        dut.FastComSerial.value = int(fc_encoding[i], 2)

    await RisingEdge(clk320)

    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))
