#!/usr/bin/python3
""" unpack86.py

    A lightweight TI-86 binary unpacker. Parses and outputs info about an 86p file.
"""
from collections import namedtuple
import io
import struct
import sys


def _read_header(f: io.BufferedReader) -> int:
    """ Reads the header section of the 86p file format.

    Args:
        f - File buffer

    Returns:
        int - Size of the data section chunk.
    """
    print('-- Header --')

    signature = f.read(8)
    print(f'Signature:\t0x{signature.hex()} | {signature.decode("utf-8")}')
    signature = f.read(3)
    print(f'Signature:\t0x{signature.hex()}')

    # Can be null terminated or up to 42 characters.
    comment = f.read(42)
    print(f'Comment:\t{comment.decode("utf-8")}')

    size = f.read(2)
    size = int.from_bytes(size, byteorder="little")
    print(f'Data Size:\t{size} bytes')

    return size


def _read_data(f: io.BufferedReader, datasize: int) -> bool:
    """ Reads the data section of the 86p file format.

    Args:
    f - File buffer
    datasize - Size of the data section chunk

    Returns:
    bool - whether or not we have any bytes left in the buffer.
    """
    print('\n-- Data --')

    data_buffer = f.read(datasize)
    # Read data header
    data_header = struct.unpack('H H B B 8s H', data_buffer[:16])
    print(f'Data Header:\t{data_header}')

    # Program start
    print(f'Program Len:\t{int.from_bytes(data_buffer[16:18], byteorder="little")}')
    print(f'Program Type:\t0x{data_buffer[18:20].hex()}')

    dataChecksum = 0
    for byte in data_buffer:
        dataChecksum += byte

    checksum = f.read(2).hex()
    dataChecksum = struct.pack('<I', dataChecksum)[:-2].hex()
    print(f'Checksum (in file):\t0x{checksum}')
    print(f'Checksum (calculated):\t0x{dataChecksum}')

    isLastByte = len(f.read(1)) == 0
    if not isLastByte:
        print('still bytes left in buffer.')
    return isLastByte


def main():
    with open(sys.argv[1], 'rb') as f:
        try:
            size = _read_header(f)
            _read_data(f, size)
        finally:
            f.close()

if __name__ == '__main__':
    main()