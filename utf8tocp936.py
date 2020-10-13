# -*- coding: utf-8 -*-
# cython: language_level=3

import re
import os
import sys

DIR='.'

       
def filename_ext(filename):
    if "." in filename:
        return (filename.split('.')[-1])
    else:
        return ""
        
def filename_main(filename):
    if "." in filename:
        ext_len=len(filename_ext(filename))
        return filename[:(-ext_len-1)]
    else:
        return filename

def conv(f):
    fp=open(DIR+os.sep+f, 'r', encoding='utf-8')
    lines=fp.readlines()
    fp.close()
    
    lines_out=[]
    
    for i in lines:
        if re.findall("^chcp 65001", i):
            i = i.replace('65001', '936')
        #print(i)    
        #lines_out.append(i.encode("utf-8").decode('cp936','replace'))
        lines_out.append(i)
        
    fp=open(filename_main(f)+"-cp936."+filename_ext(f), 'w', encoding='cp936')
    for i in lines_out:
        fp.write(i)
    fp.close()
    
    

filelist=os.listdir(DIR)
for i in filelist:
    #print(i, re.findall('.py$', i))
    if os.path.isfile(i) and re.findall('\.bat$', i) and (not re.findall("cp936", i)):

        print("Converting ", i)
        conv(i)
            

#EOF