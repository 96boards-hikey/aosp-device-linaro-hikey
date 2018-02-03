#!/usr/bin/env python

import os
import os.path
import sys, getopt
import binascii
import struct
import string

class generator(object):
    block_size = 512
    ns_bl1u_lba = 192  # 96KB

    # set in self.add()
    idx = 0

    # file pointer
    p_file = 0      # pointer in file

    def __init__(self, out_img):
        try:
            self.fp = open(out_img, "wb+")
        except IOError, e:
            print "*** file open error:", e
            sys.exit(3)

    def __del__(self):
        self.fp.close()

    def add(self, lba, fname):
        try:
            fsize = os.path.getsize(fname)
        except IOError, e:
            print "*** file open error:", e
            sys.exit(4)
        else:
            blocks = (fsize + self.block_size - 1) / self.block_size
            print 'lba: ', lba, 'blocks: ', blocks, 'fname: ', fname
            # write images
            fimg = open(fname, "rb")
            for i in range (0, blocks):
                buf = fimg.read(self.block_size)
                # loader's p_file is 0 at here
                self.fp.seek(self.p_file)
                self.fp.write(buf)
                # p_file is the file pointer of the new binary file
                # At last, it means the total block size of the new binary file
                self.p_file += self.block_size
            left_bytes = 0
            if (self.idx == 0):
                if (lba != 0):
                    print 'bl1.bin doesn\'t start from 0KB offset'
                left_bytes = self.ns_bl1u_lba * self.block_size - self.p_file
                print 'blocks: ', blocks, 'size: ', self.ns_bl1u_lba * self.block_size, ' p_file: ', self.p_file, 'left_bytes: ', left_bytes
                if (left_bytes < 0):
                    print 'bl1.bin exceeds the 96KB limitation'
                    sys.exit(4)
            elif (self.idx == 1):
                if (lba != self.ns_bl1u_lba):
                    print 'ns_bl1u.bin doesn\'t start from 96KB offset'
                    sys.exit(4)
            else:
                print 'wrong index is inputed'
                sys.exit(4)

            if (left_bytes > 0):
                for i in range (0, left_bytes):
                    zero = struct.pack('x')
                    self.fp.write(zero)
                self.p_file += left_bytes
                print 'p_file: ', self.p_file, '  pad to: ', self.fp.tell()

            self.idx += 1

            fimg.close()

    def hex2(self, data):
        return data > 0 and hex(data) or hex(data & 0xffffffff)

    def pad(self, align_bytes):
        unalign_bytes = self.p_file % align_bytes
        if (unalign_bytes > 0):
            count = align_bytes - unalign_bytes
            for i in range (0, count):
                zero = struct.pack('x')
                self.fp.write(zero)
            self.p_file += count

    def end(self):
        self.fp.close()

    def create(self, img_bl1, img_ns_bl1u, output_img):
        print '+-----------------------------------------------------------+'
        print ' Input Images:'
        print '     bl1:                          ', img_bl1
        print '     ns_bl1u:                         ', img_ns_bl1u
        print ' Ouput Image:                      ', output_img
        print '+-----------------------------------------------------------+\n'

        # bl1.bin starts from 0KB
        self.add(0, img_bl1)
        # ns_bl1u.bin starts from 96KB
        self.add(self.ns_bl1u_lba, img_ns_bl1u)
        # padding to 128KB
        self.pad(128 * 1024)

def main(argv):
    img_bl1 = 0
    img_ns_bl1u = 0
    output_img = 0
    try:
        opts, args = getopt.getopt(argv,"ho:",["img_bl1=","img_ns_bl1u="])
    except getopt.GetoptError:
        print 'gen_loader.py -o <l-loader.bin> --img_bl1 <bl1.bin> --img_ns_bl1u <ns_bl1u.bin>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'gen_loader.py -o <l-loader.bin> --img_bl1 <bl1.bin> --img_ns_bl1u <ns_bl1u.bin>'
            sys.exit(1)
        elif opt == '-o':
            output_img = arg
        elif opt in ("--img_bl1"):
            img_bl1 = arg
        elif opt in ("--img_ns_bl1u"):
            img_ns_bl1u = arg

    if (img_bl1 == 0) or (img_ns_bl1u == 0) or (output_img == 0):
        print 'parameters are invalid'
        print 'gen_loader.py -o <l-loader.bin> --img_bl1 <bl1.bin> --img_ns_bl1u <ns_bl1u.bin>'
        sys.exit(2)

    loader = generator(output_img)
    loader.idx = 0

    loader.create(img_bl1, img_ns_bl1u, output_img)

    loader.end()

if __name__ == "__main__":
    main(sys.argv[1:])
