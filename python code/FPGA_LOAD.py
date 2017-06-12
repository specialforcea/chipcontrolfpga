# -*- coding: utf-8 -*-
"""
Created on Wed Jul 27 15:27:28 2016

@author: yny8
"""

import visa
import time
rm = visa.ResourceManager()
md = rm.open_resource("ASRL4::INSTR")

md.write_raw("\x01")
time.sleep(0.01)

md.write_raw("\x03")
time.sleep(0.01)

for i in range(6):
    md.write_raw("\x1E")
    time.sleep(0.01)
    
for i in range(6):
    md.write_raw("\x01")
    time.sleep(0.01)
    
for i in range(96):
    md.write_raw("\x00")
    time.sleep(0.01)
##############################
md.write_raw("\x01")
time.sleep(0.01)

md.write_raw("\x03")
time.sleep(0.01)

for i in range(6):
    md.write_raw("\x1E")
    time.sleep(0.01)
    
for i in range(6):
    md.write_raw("\x01")
    time.sleep(0.01)
    
for i in range(96):
    md.write_raw("\x01")
    time.sleep(0.01)
##############################
md.write_raw("\x01")
time.sleep(0.01)

md.write_raw("\x03")
time.sleep(0.01)

for i in range(6):
    md.write_raw("\x1E")
    time.sleep(0.01)
    
for i in range(6):
    md.write_raw("\x01")
    time.sleep(0.01)
    
for i in range(96):
    md.write_raw("\x02")
    time.sleep(0.01)
##############################
md.write_raw("\x01")
time.sleep(0.01)

md.write_raw("\x03")
time.sleep(0.01)

for i in range(6):
    md.write_raw("\x1E")
    time.sleep(0.01)
    
for i in range(6):
    md.write_raw("\x01")
    time.sleep(0.01)
    
for i in range(96):
    md.write_raw("\x03")
    time.sleep(0.01)
##############################
md.write_raw("\x01")
time.sleep(0.01)

md.write_raw("\x03")
time.sleep(0.01)

for i in range(6):
    md.write_raw("\x1E")
    time.sleep(0.01)
    
for i in range(6):
    md.write_raw("\x01")
    time.sleep(0.01)
    
for i in range(96):
    md.write_raw("\x04")
    time.sleep(0.01)
##############################
md.write_raw("\x01")
time.sleep(0.01)

md.write_raw("\x03")
time.sleep(0.01)

for i in range(6):
    md.write_raw("\x1E")
    time.sleep(0.01)
    
for i in range(6):
    md.write_raw("\x01")
    time.sleep(0.01)
    
for i in range(96):
    md.write_raw("\x00")
    time.sleep(0.01)
##############################
md.write_raw("\x01")
time.sleep(0.01)

md.write_raw("\x03")
time.sleep(0.01)

for i in range(6):
    md.write_raw("\x1E")
    time.sleep(0.01)
    
for i in range(6):
    md.write_raw("\x01")
    time.sleep(0.01)
    
for i in range(96):
    md.write_raw("\x01")
    time.sleep(0.01)
##############################
md.write_raw("\x01")
time.sleep(0.01)

md.write_raw("\x03")
time.sleep(0.01)

for i in range(6):
    md.write_raw("\x1E")
    time.sleep(0.01)
    
for i in range(6):
    md.write_raw("\x01")
    time.sleep(0.01)
    
for i in range(96):
    md.write_raw("\x02")
    time.sleep(0.01)
##############################
 md.visalib.read(md.session,md.bytes_in_buffer)