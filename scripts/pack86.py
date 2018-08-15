#!/usr/bin/python3
""" pack86.py

    A lightweight TI-86 binary packer. Packs zasm output into a the 86p
    format that can be transferred to TI-86 calculators/emulators.
"""
import io
import os
import sys
from functools import reduce
from struct import pack


def _outfile(path: str) -> str:
    """ Determine the out filepath based on the input file. It'll be in the
        form of <path>/<filename>.86p

        Args:
            path - Path to in file.

        Returns:
            Path to out file.
    """
    (path, base) = os.path.split(path)
    outfile = f'{os.path.splitext(base)[0]}.86p'

    return os.path.join(path, outfile)


def _write_header(outfile: io.BufferedWriter, datasize: int):
    """ Writes the 86p header to the outfile.

        Args:
            outfile - Outfile to write to.
            datasize - Size of the ASM program.
            checksum - ASM program checksum
    """

    # Pack the signature, **TI86** plus 3 bytes of magic number.
    out = pack('8s B B B', bytes('**TI86**', 'ascii'), 0x1a, 0x0a, 0x00)
    outfile.write(out)
    # Pack a comment (up to 42 bytes)
    out = pack('42s', bytes('Packed by pack86.py', 'ascii'))
    outfile.write(out)
    # Length of program + 16 for the data header + 4 for the program header.
    outfile.write(pack('H', datasize + 16 + 4))


def _write_data(outfile: io.BufferedWriter, data):
    """ Writes the 86p data section to the outfile

        Args:
            outfile - Outfile to write to.
            data - Data buffer
    """
    checksum = 0
    # Header struct format:
    # H -> Always 12 (0x0c00)
    # H -> length of the variable data
    # B -> Data Type ID
    # B -> Length of the variable name
    # 8s -> Variable name, padding w/ space characters
    # H -> length of the variable data (again)
    vname = bytes('MiniRPG', 'ascii')
    # We add 4 to the data len to account for the program header.
    # So many headers.
    dlen = len(data) + 4
    entry_header = pack('H H B B 8s H', 12, dlen, 18, 7, vname, dlen)
    outfile.write(entry_header)
    checksum += reduce(lambda x, y: x + y, entry_header)

    # Write the ASM program into the fileformat
    prog_header = pack('H B B', len(data), 0x8e, 0x28)
    outfile.write(prog_header)
    checksum += reduce(lambda x, y: x + y, prog_header)

    outfile.write(bytes(data))
    checksum += reduce(lambda x,y: x + y, data)

    return checksum


def main():
    infile = sys.argv[1]

    outfile = _outfile(infile)

    print(f'Reading ASM file: {infile}')
    print(f'Writing packed file to: {outfile}')

    # Read the file into a buffer
    buffer = []
    checksum = 0
    with open(infile, 'rb') as fhandle:
        byte = fhandle.read(1)
        while byte:
            checksum += byte[0]
            buffer.extend(byte)
            byte = fhandle.read(1)

    with open(outfile, 'wb') as outhand:
        _write_header(outhand, len(buffer))
        checksum = _write_data(outhand, buffer)
        # 86p file format only uses the lower 2 bytes of the checksum
        lower_cs = pack('<I', checksum)[:-2]
        outhand.write(pack('2s', lower_cs))


if __name__ == '__main__':
    main()