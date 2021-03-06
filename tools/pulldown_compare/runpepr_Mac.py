In#!/usr/local/bin/python2.7

import argparse
from subprocess import Popen, PIPE
import sys
import re
import logging

parser = argparse.ArgumentParser()

parser.add_argument('--o', action='append', dest='collection1',
                    default=[],
                    help='Add repeated values to a list',
                    )
parser.add_argument('--i1', action='append', dest='collection2',
                    default=[],
                    help='Add repeated values to a list',
                    )
parser.add_argument('--c1', action='append', dest='collection3',
                    default=[],
                    help='Add repeated values to a list',
                    )
parser.add_argument('--i2', action='append', dest='collection16',
                    default=[],
                    help='Add repeated values to a list',
                    )
parser.add_argument('--c2', action='append', dest='collection17',
                    default=[],
                    help='Add repeated values to a list',
                    )
parser.add_argument('--expName', type=str , dest='collection5',
                    help='expName',
                    )
parser.add_argument('--format', type=str , dest='collection6',
                    help='Add format values to a list',
                    )
parser.add_argument('--peakType', type=str , dest='collection7',
                    help='Add peakType values to a list',
                    )
parser.add_argument('--thresh', type=str , dest='collection8',
                    help='Add thresh values to a list',
                    )
parser.add_argument('--removeArt', type=str , dest='collection9',
                    help='Add removeArt values to a list',
                    )
parser.add_argument('--rd_dup', type=str , dest='collection10',
                    help='Add rd_dup values to a list',
                    )	   
parser.add_argument('--o1', type=str , dest='collection11',
                    help='pepr_peaks',
                    )
parser.add_argument('--o2', type=str , dest='collection12',
                    help='pepr_filtered peaks true',
                    )
parser.add_argument('--o3', type=str , dest='collection13',
                    help='pepr parameters',
                    )
parser.add_argument('--diff', type=str , dest='collection14',
                    help='Add diff values to a list',
                    )
parser.add_argument('--o4', type=str , dest='collection15',
                    help='pepr_peaks_diff diff true',
                    )
results = parser.parse_args()
import subprocess
print 'input file1     =', results.collection2
print 'Chip_value1   =', results.collection3
print 'input file2     =', results.collection16
print 'Chip_value2   =', results.collection17
print 'expName_switch   =', results.collection5
print 'format       =', results.collection6
print 'peaktype     =', results.collection7
print 'thers   =', results.collection8
print 'removeArt   =', results.collection9
print 'rd_dupt       =', results.collection10
print 'index       =', results.collection1
print 'peak up file       =', results.collection11
print 'filtered peaks RD       =', results.collection12
print 'PArameters file        =', results.collection13
print 'diff down peaks         =', results.collection15


#python2.7 /home/rcavalca/.local/lib/python2.7/site-packages/PePr-1.0.8-py2.7.egg/PePr/PePr.py --input1=$INPUT1 --input2=$INPUT2 --chip1=$CHIP1 --chip2=$CHIP2 --name=$COMPARISON --file-format=bam --peaktype=sharp --diff --threshold #1e-03 --remove_artefacts

command = "--input1 "
command+=  ','.join(results.collection2)
command+= " --chip1 "
command+=  ','.join(results.collection3)
print "after the the input1"
command+= " --input2 "
command+=  ','.join(results.collection16)
command+= " --chip2 "
command+=  ','.join(results.collection17)
command+=" --name "
command+= results.collection5
command+=" --o1 "
command+= results.collection11
command+=" --o3 "
command+= results.collection13
command+= " --file-format "
command+= results.collection6
command+= " --peaktype "
command+= results.collection7
command+= " --threshold "
command+= results.collection8

if results.collection14 == 'true':
    command+= " --diff"
    command+=" --o4 "
    command+= results.collection15
if results.collection10 == 'true':
    command+= " --remove_artefacts "
    command+=" --o2 "
    command+= results.collection12 
   
print command

print 2
import shlex, subprocess
import os

print "sys.executable is", sys.executable


p = subprocess.Popen(['/usr/local/bin/python2.7', '/usr/lib/python2.6/site-packages/PePr/PePr.py']+command.split(), 
                                    stdout=subprocess.PIPE, 
                                    stderr=subprocess.STDOUT)
for line in iter(p.stdout.readline, b''):
    print(line)	

print 3 

fo = open(results.collection13, "r+")

print(fo.read())


print subprocess.PIPE







