#coding=utf-8
try:
	import xml.etree.cElementTree as ET
except ImportError:
	import xml.etree.ElementTree as ET
import sys
import os
import ConfigParser
import zlib
import zipfile
import md5  
import hashlib
import struct

def Transfer_Unit_To_Png(filename):  
    if not os.path.isfile(filename):  
        return 

    f = file(filename, 'rb')
    f.read(1) #var b1:int = bytes.getInt8();
    f.read(1) #unit.rideHeight = bytes.getInt8();
    f.read(1) #unit.fps = bytes.getInt8();
    frame = struct.unpack('!h', f.read(2))[0] #unit.nFrame = bytes.getInt16();
    #print frame
    f.read(1) #unit.directions = bytes.getInt8();
    f.read(2) #unit.modelHeight = bytes.getInt16();
    f.read(2) #unit.interactiveRectX = bytes.getInt16();
    f.read(2) #unit.interactiveRectY = bytes.getInt16();
    f.read(2) #unit.interactiveRectWidth = bytes.getInt16();
    f.read(2) #unit.interactiveRectHeight = bytes.getInt16();
    while True:
        f.read(2) #frameInfo.offsetX = bytes.getInt16();
        f.read(2) #frameInfo.offsetY = bytes.getInt16();
        f.read(2) #frameInfo.bitmapOffsetX = bytes.getInt16();
        f.read(2) #frameInfo.bitmapOffsetY = bytes.getInt16();
        f.read(2) #frameInfo.bitmapWidth = bytes.getInt16();
        f.read(2) #frameInfo.bitmapHeight = bytes.getInt16();
        frame = frame - 1
        if frame <= 0:
            break;

    imageSize = struct.unpack('!i', f.read(4))[0] #bytes.getInt32();
    #print imageSize
    #print os.path.splitext(filename)[0] + '.png'
    f2 = open(os.path.splitext(filename)[0] + '.png', 'wb')
    f2.write(f.read(imageSize))

    f.close()

def Get_All_Unit_File(filePath, fileList):
    newFilePath = filePath

    if os.path.isfile(filePath):
        if os.path.splitext(filePath)[1] == ".unit": fileList.append(filePath)        
    elif os.path.isdir(filePath):
        for s in os.listdir(filePath):
            newFilePath = os.path.join(filePath, s)
            Get_All_Unit_File(newFilePath, fileList)

    return fileList

def main():
    jsonfile = Get_All_Unit_File('./', [])
    for e in jsonfile:
        Transfer_Unit_To_Png(e)
        print e.replace("\\", "/")[0:]

if __name__ == '__main__':
	main()