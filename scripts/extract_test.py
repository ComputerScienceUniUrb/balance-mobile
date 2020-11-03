#! /usr/bin/python

import json
import sys
import os

# Extract the file from argv
if len(sys.argv) != 2:
    print('Use: extract_test.py [FILE]')
    sys.exit(2)
if not sys.argv[1].endswith('json'):
    print('file must be .json')
    sys.exit(2)

# Load the file in a string
try:
    input = open(sys.argv[1], 'r').read()
except FileNotFoundError:
    print("no file with name",sys.argv[1],"found!")
    sys.exit(2)

dirName = os.path.dirname(sys.argv[1])
fileName = os.path.basename(sys.argv[1]).split(".")[0]
resultDir = os.path.join(dirName, fileName)

if not os.path.exists(resultDir):
    os.mkdir(resultDir)

# Decode the json object
decoded = json.loads(input)

# Write the measurement to his file
meas = decoded['measurement']
measPath = os.path.join(resultDir, "meas.txt")
if not os.path.exists(measPath):
    measFile = open(measPath, 'x')
else:
    measFile = open(measPath, 'w')
for key in meas:
    measFile.write(key+': '+str(meas[key])+"\n")
measFile.close()

# Write the raw data to his file
raw = decoded['rawMeasurement']
rawPath = os.path.join(resultDir, "raw.txt")
if not os.path.exists(rawPath):
    rawFile = open(rawPath, 'x')
else:
    rawFile = open(rawPath, 'w')
for item in raw:
    out = ''
    for key in item:
        if key != 'id' and key != 'measurementId':
            out = out + str(item[key]) + " "
    rawFile.write(out+"\n")
rawFile.close()

# Write the cogv data to his file
cogv = decoded['cogv']
cogvPath = os.path.join(resultDir, "cogv.txt")
if not os.path.exists(cogvPath):
    cogvFile = open(cogvPath, 'x')
else:
    cogvFile = open(cogvPath, 'w')
for item in cogv:
    out = ''
    for key in item:
        if key != 'id' and key != 'measurementId':
            out = out + str(item[key]) + " "
    cogvFile.write(out+"\n")
cogvFile.close()

