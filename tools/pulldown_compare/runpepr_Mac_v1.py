#!/usr/local/bin/python2.7

import argparse
from subprocess import Popen, PIPE
import sys
import re
import logging
import tempfile
import shlex, subprocess
import os,shutil
from glob import glob

parser = argparse.ArgumentParser()

parser.add_argument('--o', action='append', dest='collection1',
                    default=[],
                    help='Add repeated values to a list',
                    )
parser.add_argument('--i1', action='append', dest='collection2',
                    default=[],
                    help='input files',
                    )
parser.add_argument('--c1', action='append', dest='collection3',
                    default=[],
                    help='chip files',
                    )
parser.add_argument('--i2', action='append', dest='collection16',
                    default=[],
                    help='Input files group 2',
                    )
parser.add_argument('--c2', action='append', dest='collection17',
                    default=[],
                    help='chip files group 2',
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
parser.add_argument('--maxdup', type=str , dest='collection15',
                    help='Remove duplicates to a list',
                    )
parser.add_argument('--removeArt', type=str , dest='collection9',
                    help='Add removeArt values to a list',
                    )

parser.add_argument('--rd_dup', type=str , dest='collection10',
                    help='Add rd_dup values to a list',
                    )	   
parser.add_argument('--o1', type=str , dest='collection11',
                    help='pepr_chip1',
                    )
parser.add_argument('--o2', type=str , dest='collection12',
                    help='pepr_chip2',
                    )
parser.add_argument('--o3', type=str , dest='collection13',
                    help='pepr parameters',
                    )
parser.add_argument('--diff', type=str , dest='collection14',
                    help='Add diff values to a list',
                    )
parser.add_argument('--normalization', type=str , dest='collection18',
                    help='Add diff values to a list',
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
print 'peak chip1 file       =', results.collection11
print 'peak chip2 file       =', results.collection12
print 'Parameters file        =', results.collection13



#python2.7 /home/rcavalca/.local/lib/python2.7/site-packages/PePr-1.0.8-py2.7.egg/PePr/PePr.py --input1=$INPUT1 --input2=$INPUT2 --chip1=$CHIP1 --chip2=$CHIP2 --name=$COMPARISON --file-format=bam --peaktype=sharp --diff --threshold #1e-03 --remove_artefacts
#$(PATH_TO_PEPR) --input1=$(PULLDOWN_COMPARE_1_INPUT1) --input2=$(PULLDOWN_COMPARE_1_INPUT2) --chip1=$(PULLDOWN_COMPARE_1_CHIP1) --chip2=$(PULLDOWN_COMPARE_1_CHIP2) --name=$(PULLDOWN_COMPARE_1_NAME) --output-directory=$(DIR_PULL_PEPR) ##$(OPTS_PEPR_HPVpos_v_HPVneg_hmc_pulldown)
#OPTS_PEPR_preeclamptic_v_normal_mc_pulldown = --file-format=bam --peaktype=sharp --diff --threshold 1e-03 --remove_artefacts
#OPTS_PEPR_preeclamptic_v_normal_hmc_pulldown = --file-format=bam --peaktype=sharp --diff --threshold 1e-03 --remove_artefacts
output_dir = tempfile.mkdtemp()
command = "--input1 "
command+=  ','.join(results.collection2)
command+= " --chip1 "
command+=  ','.join(results.collection3)
print "after the the input1"
command+= " --input2 "
command+=  ','.join(results.collection16)
command+= " --chip2 "
command+=  ','.join(results.collection17)
command+=" --name="
command+= results.collection5
command+=" --output-directory "
command+= output_dir
command+= " --f "
command+= results.collection6
command+= " --peaktype "
command+= results.collection7
command+= " --threshold "
command+= results.collection8
command+= " --normalization "
command+= results.collection18


if results.collection14 == 'true':
    command+= " --diff "    
if results.collection10 == 'true':
    command+= " --keep-max-dup " 
    command+= results.collection15
    



print "done:"	
print output_dir   
print command
print "sys.executable is", sys.executable
p = subprocess.Popen(['PePr']+command.split(), 
                                    stdout=subprocess.PIPE, 
                                    stderr=subprocess.STDOUT)
for line in iter(p.stdout.readline, b''):
    print(line)	
print subprocess.PIPE

shutil.move( glob(os.path.join( output_dir, '*PePr_chip1_peaks*'))[0], results.collection11 )
shutil.move( glob(os.path.join( output_dir, '*PePr_chip2_peaks*'))[0], results.collection12 )
shutil.move( glob(os.path.join( output_dir, '*PePr_parameters*'))[0], results.collection13)






