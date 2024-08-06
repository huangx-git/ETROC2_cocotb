import cocotb
import inspect
import random

from cocotb.types import LogicArray, Range
from enum import Enum

I2CSDADEL = 100
I2CPER = 250 # 4MHz
I2C_DEL_SEED = 1

class state(Enum):
    I2CIDLE = 0
    I2CSTART = 1
    I2CDEVADR = 2
    I2CRW = 3
    I2CDEVACK = 4
    I2CREGADR = 5
    I2CREGADR2 = 6
    I2CREGACK = 7
    I2CDATA = 8
    I2CDATAACK = 9
    I2CSTOP = 10

i2c_state = state.I2CIDLE

@cocotb.coroutine
async def i2c_start(dut):
    """
    Coroutine to perform I2C start sequence.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    random.seed(I2C_DEL_SEED)
    i2c_del_time = random.randint(0,255)
    #await cocotb.triggers.Timer(10 + i2c_del_time, 'ns')
    dut._log.debug('START SLEEP {}'.format(10 + i2c_del_time))
    # start
    i2c_state = state.I2CSTART
    dut._log.debug('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    dut.MS_SDAout.value = 1
    dut.MS_SDAen.value  = 1
    await cocotb.triggers.Timer(I2CPER/2, 'ns') # start bit
    dut.MS_SCLout.value = 1
    dut.MS_SCLen.value  = 1
    await cocotb.triggers.Timer(I2CPER/2, 'ns') # start bit
    dut.MS_SDAout.value = 0
    await cocotb.triggers.Timer(I2CPER/2, 'ns') # clock down
    dut.MS_SCLout.value = 0
    await cocotb.triggers.Timer(I2CPER/2, 'ns') # clock down
    dut._log.debug('END   {}'.format(inspect.currentframe().f_code.co_name))

@cocotb.coroutine
async def i2c_stop(dut):
    """
    Coroutine to perform I2C stop sequence.

    Args:
        dut: The DUT (Device Under Test) object.

    Returns:
        None
    """
    # stop
    dut._log.debug('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    await cocotb.triggers.Timer(I2CPER/2, 'ns')
    i2c_state = state.I2CSTOP
    dut.MS_SCLen.value = 1
    dut.MS_SCLout.value  = 0
    await cocotb.triggers.Timer(I2CPER/2, 'ns')
    dut.MS_SDAen.value = 1
    dut.MS_SDAout.value = 0

    await cocotb.triggers.Timer(I2CPER/2, 'ns')
    dut.MS_SCLen.value = 0
    await cocotb.triggers.Timer(I2CPER/2, 'ns')
    dut.MS_SDAen.value = 0

    dut.MS_SDAout.value = 1
    dut.MS_SCLout.value = 1
    i2c_state = state.I2CIDLE;
    dut._log.debug('END   {}'.format(inspect.currentframe().f_code.co_name))

@cocotb.coroutine
async def i2c_write_bits(dut, data):
    """
    Coroutine to write bits over I2C.

    Args:
        dut: The DUT (Device Under Test) object.
        data: The data to be written.

    Returns:
        None
    """
    # TODO assumption data.range.left > data.range.right that is range is "downto"
    bits = data.range.left - data.range.right
    dut._log.debug('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    dut._log.debug('  - data       : {} ({})'.format(data, hex(data.integer)))
    dut._log.debug('  - bits       : {}'.format(bits))
    await cocotb.triggers.Timer(I2CSDADEL/4, 'ns') # start bit
    dut.MS_SDAen.value = 1
    #for i in range(bits-1, -1, -1):
    for i in range(data.range.left, data.range.right-1, -1):
        await cocotb.triggers.Timer(I2CPER/4, 'ns') # start bit
        dut.MS_SDAout.value = data[i]
        #dut._log.debug('[{}] {}'.format(i, data[i]))
        await cocotb.triggers.Timer(I2CPER/4, 'ns') # start bit
        dut.MS_SCLout.value = 1
        await cocotb.triggers.Timer(I2CPER/2, 'ns') # clock down
        dut.MS_SCLout.value = 0
    dut._log.debug('END   {}'.format(inspect.currentframe().f_code.co_name))

@cocotb.coroutine
async def i2c_read_bits(dut, bits):
    """
    Coroutine to read bits over I2C.

    Args:
        dut: The DUT (Device Under Test) object.
        bits: The number of bits to be read.

    Returns:
        data: The read data.
    """
    data = LogicArray(0, Range(bits-1, 'downto', 0))
    dut._log.debug('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    dut._log.debug('  - bits       : {}'.format(bits))
    await cocotb.triggers.Timer(I2CSDADEL, 'ns')
    dut.MS_SDAen.value = 0
    dut.MS_SDAout.value = 1

    for i in range(bits-1, -1, -1):
        time_tmr = 0
        await cocotb.triggers.Timer((I2CPER/2)-I2CSDADEL, 'ns')
        dut.MS_SCLout.value = 1

        await cocotb.triggers.Timer((I2CPER/8), 'ns')
        time_tmr = time_tmr + dut.SDA.value
        await cocotb.triggers.Timer((I2CPER/8), 'ns')
        time_tmr = time_tmr + dut.SDA.value
        await cocotb.triggers.Timer((I2CPER/8), 'ns')
        time_tmr = time_tmr + dut.SDA.value
        await cocotb.triggers.Timer((I2CPER/8), 'ns')

        data[i] = 0
        if (time_tmr > 2):
            data[i] = 1

        dut.MS_SCLout.value = 0
        await cocotb.triggers.Timer(I2CSDADEL, 'ns')
    dut._log.debug('  - data       : {} ({})'.format(data, hex(data.integer)))
    dut._log.debug('END   {}'.format(inspect.currentframe().f_code.co_name))
    return data

@cocotb.coroutine
async def i2c_write_single(dut, slave_addr, reg_addr, data, report_error = False):
    """
    Coroutine to perform single I2C write operation.

    Args:
        dut: The DUT (Device Under Test) object.
        slave_addr: The slave address.
        reg_addr: The register address.
        data: The data to be written.
        report_error: Flag to indicate whether to report errors.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    dut._log.info('  - slave_addr : {} ({})'.format(slave_addr, hex(slave_addr.integer)))
    dut._log.info('  - reg_addr   : {} ({})'.format(reg_addr, hex(reg_addr.integer)))
    dut._log.info('  - data       : {} ({})'.format(data, hex(data.integer)))
    dut._log.info('  - report_error: {}'.format(report_error))

    await i2c_start(dut)

    # Send slave addr
    i2c_state = state.I2CDEVADR
    await i2c_write_bits(dut, slave_addr)

    # R/W=0 (write)
    i2c_state = state.I2CRW
    await i2c_write_bits(dut, LogicArray(0))

    # Wait for ack
    i2c_state = state.I2CDEVACK
    nack = await i2c_read_bits(dut, 1)
    if (nack.integer == 1):
        if (report_error):
            dut._log.error('i2c_write_single NACK after dev address!')
        await i2c_stop(dut)
    else:
        # Register address (lo)
        i2c_state = state.I2CREGADR
        await i2c_write_bits(dut, reg_addr[7:0])

        # Wait for ack
        i2c_state = state.I2CREGACK
        nack = await i2c_read_bits(dut, 1)
        if (nack.integer == 1):
            if (report_error):
                dut._log.error('i2c_write_single NACK after register address (lo)!')
            await i2c_stop(dut)
        else:
            # Register address (hi)
            i2c_state = state.I2CREGADR
            await i2c_write_bits(dut, reg_addr[15:8])

            # Wait for ack
            i2c_state = state.I2CREGACK
            nack = await i2c_read_bits(dut, 1)
            if (nack.integer == 1):
                if (report_error):
                    dut._log.error('i2c_write_single NACK after register address (hi)!')
                await i2c_stop(dut)
            else:
                # Data
                i2c_state = state.I2CDATA
                await i2c_write_bits(dut, data)

                # Wait for ack
                i2c_state = state.I2CDATAACK
                nack = await i2c_read_bits(dut, 1)
                if (nack.integer == 1):
                    if (report_error):
                        dut._log.error('i2c_write_single no ack after data!')
                    await i2c_stop(dut)

                dut.MS_SDAen.value = 0
                await i2c_stop(dut)
    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))


def shift_left(data, bits):
    """
    Function to perform left shift on data.

    Args:
        data: The data to be shifted.
        bits: The number of bits to shift.

    Returns:
        shifted_data: The shifted data.
    """
    shifted_data = data.integer << bits
    return LogicArray(shifted_data, range=data.range)


def shift_left(data, shift_bits, extended_range):
    """
    Function to perform left shift on data with extended range.

    Args:
        data: The data to be shifted.
        shift_bits: The number of bits to shift.
        extended_range: The extended range for the shifted data.

    Returns:
        shifted_data: The shifted data.
    """
    shifted_data = data.integer << shift_bits
    return LogicArray(shifted_data, range=extended_range)

def extend_range(data, extended_range):
    """
    Function to extend the range of data.

    Args:
        data: The data to be extended.
        extended_range: The extended range for the data.

    Returns:
        extended_data: The extended data.
    """
    return LogicArray(data.integer, extended_range)

@cocotb.coroutine
async def i2c_pixel_bc(dut, slave_addr, pixel_x, pixel_y, pixel_cnfg, pixel_addr):
    """
    Coroutine to perform I2C pixel BC (Bit Clear) operation.

    Args:
        dut: The DUT (Device Under Test) object.
        slave_addr: The slave address.
        pixel_x: The x-coordinate of the pixel.
        pixel_y: The y-coordinate of the pixel.
        pixel_cnfg: The pixel configuration.
        pixel_addr: The pixel address.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    dut._log.info('  - slave_addr        : {} ({})'.format(slave_addr, hex(slave_addr.integer)))
    dut._log.info('  - pixel_x           : {} ({})'.format(pixel_x, hex(pixel_x.integer)))
    dut._log.info('  - pixel_y           : {} ({})'.format(pixel_y, hex(pixel_y.integer)))
    dut._log.info('  - pixel_cnfg        : {} ({})'.format(pixel_cnfg, hex(pixel_cnfg.integer)))
    dut._log.info('  - pixel_addr        : {} ({})'.format(pixel_addr, hex(pixel_addr.integer)))

    extended_range = Range(15, 'downto', 0)
    pixel_config_addr = LogicArray(0xa000, extended_range) | shift_left(pixel_y, 9, extended_range) | shift_left(pixel_x, 5, extended_range)

    dut._log.info('  - pixel_config_addr : {} ({})'.format(pixel_config_addr, hex(pixel_config_addr.integer)))

    await i2c_write_single(dut, slave_addr, pixel_config_addr | extend_range(pixel_addr, extended_range) , pixel_cnfg, True)

    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))

@cocotb.coroutine
async def i2c_pixel_write(dut, slave_addr, pixel_x, pixel_y, pixel_cnfg, pixel_addr):
    """
    Coroutine to perform I2C pixel write operation.

    Args:
        dut: The DUT (Device Under Test) object.
        slave_addr: The slave address.
        pixel_x: The x-coordinate of the pixel.
        pixel_y: The y-coordinate of the pixel.
        pixel_cnfg: The pixel configuration.
        pixel_addr: The pixel address.

    Returns:
        None
    """
    dut._log.info('BEGIN {}'.format(inspect.currentframe().f_code.co_name))
    dut._log.info('  - slave_addr        : {} ({})'.format(slave_addr, hex(slave_addr.integer)))
    dut._log.info('  - pixel_x           : {} ({})'.format(pixel_x, hex(pixel_x.integer)))
    dut._log.info('  - pixel_y           : {} ({})'.format(pixel_y, hex(pixel_y.integer)))
    dut._log.info('  - pixel_cnfg        : {} ({})'.format(pixel_cnfg, hex(pixel_cnfg.integer)))
    dut._log.info('  - pixel_addr        : {} ({})'.format(pixel_addr, hex(pixel_addr.integer)))

    extended_range = Range(15, 'downto', 0)
    pixel_config_addr = LogicArray(0x8000, extended_range) | shift_left(pixel_y, 9, extended_range) | shift_left(pixel_x, 5, extended_range)

    dut._log.info('  - pixel_config_addr : {} ({})'.format(pixel_config_addr, hex(pixel_config_addr.integer)))

    await i2c_write_single(dut, slave_addr, pixel_config_addr | extend_range(pixel_addr, extended_range) , pixel_cnfg, True)

    dut._log.info('END   {}'.format(inspect.currentframe().f_code.co_name))

