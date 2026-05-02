#coding=utf-8
import tinify
import shutil

try:
	import xml.etree.cElementTree as ET
except ImportError:
	import xml.etree.ElementTree as ET
import sys
import os
import zlib

def Transfer_Png_To_Pkm(filename):  
    if not os.path.isfile(filename):  
        return

    os.chdir("D:\\Program Files\\ARM\\Mali Developer Tools\\Mali Texture Compression Tool v4.3.0\\bin")
    if os.system ("etcpack.exe %s pkm -c etc1 -s fast -aa -ext PNG" % (filename)) == 0:
    	shutil.move(".\\pkm\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm", os.path.dirname(filename))

    	os.rename(os.path.dirname(filename) + "\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm", os.path.dirname(filename) + "\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm1")
    	infile = open(os.path.dirname(filename) + "\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm1", 'rb')
    	dst = open(os.path.dirname(filename) + "\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkma", 'wb')
    	compress = zlib.compressobj(9)
    	data = infile.read(1024)
    	while data:
    		dst.write(compress.compress(data))
    		data = infile.read(1024)
    	dst.write(compress.flush())

def Transfer_Jpg_To_Pkm(filename):  
    if not os.path.isfile(filename):  
        return

    os.chdir("D:\\Program Files\\ARM\\Mali Developer Tools\\Mali Texture Compression Tool v4.3.0\\bin")
    if os.system ("etcpack.exe %s pkm -c etc1 -s fast -ext JPG" % (filename)) == 0:
        shutil.move(".\\pkm\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm", os.path.dirname(filename))

        os.rename(os.path.dirname(filename) + "\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm", os.path.dirname(filename) + "\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm1")
        infile = open(os.path.dirname(filename) + "\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm1", 'rb')
        dst = open(os.path.dirname(filename) + "\\" + os.path.splitext(os.path.basename(filename))[0] + ".pkm", 'wb')
        compress = zlib.compressobj(9)
        data = infile.read(1024)
        while data:
            dst.write(compress.compress(data))
            data = infile.read(1024)
        dst.write(compress.flush())

def Get_All_Png_File():
    listFiles = [
    './comp/common/img_role_background.png',
    './comp/image/10.png',
    './comp/image/background_role.png',
    './comp/image/img_background.png',
    './comp/partner/background.png', 
    './comp/partner/di5.png', 
    './comp/partner/ditu.png', 
    './comp/partner/dizuo.png', 
    './comp/pet/huxing.png', 
    './comp/rank/img_rank_backgroud.png', 
    './comp/recruit/img_better.png', 
    './comp/recruit/img_normal.png', 
    './comp/shouchong/sc_tishi.png', 
    './comp/tuitu/tuitu_bigba8.png', 
    './comp/zhuanpan/zp_bg_1.png', 
    './comp/wawaji/wawa_bg.png']
    return listFiles

def Get_All_Jpg_File():
    listFiles = [
    './comp/image/foundrole_bg1.jpg', 
    './comp/image/foundrole_bg2.jpg', 
    './comp/image/foundrole_bg3.jpg', 
    './comp/image/tuitu_bigbg1.jpg', 
    './comp/image/tuitu_bigbg2.jpg', 
    './comp/image/tuitu_bigbg3.jpg', 
    './comp/image/tuitu_bigbg4.jpg', 
    './comp/image/tuitu_bigbg5.jpg', 
    './comp/image/tuitu_bigbg6.jpg', 
    './comp/image/tuitu_bigbg7.jpg', 
    './comp/loading/bg.jpg',
    './comp/map/100.jpg', 
    './comp/tuitu/tuitu_bigbg1.jpg']
    return listFiles

def Get_All_Atlas_File(filePath, fileList):
    newFilePath = filePath

    if os.path.isfile(filePath):
        if os.path.splitext(filePath)[1] == ".png": fileList.append(filePath)        
    elif os.path.isdir(filePath):
        for s in os.listdir(filePath):
            newFilePath = os.path.join(filePath, s)
            Get_All_Atlas_File(newFilePath, fileList)

    return fileList

def Del_All_File(filePath, fileext):
    n = 0
    for root, dirs, files in os.walk(filePath):
        for name in files:
            if(name.endswith(fileext)):
                n += 1
                print "del file: " + os.path.join(root, name)
                os.remove(os.path.join(root, name))

def main():
    curpath = os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + os.path.sep + ".")

    if os.path.exists('./comp/icon/equip/'): shutil.rmtree('./comp/icon/equip/')
    if os.path.exists('./comp/icon/head_1/'): shutil.rmtree('./comp/icon/head_1/')
    if os.path.exists('./comp/icon/item/'): shutil.rmtree('./comp/icon/item/')
    if os.path.exists('./comp/icon/skill/'): shutil.rmtree('./comp/icon/skill/')

    shutil.copytree('../../laya/assets/comp/icon/equip/', './comp/icon/equip/')
    shutil.copytree('../../laya/assets/comp/icon/head_1/', './comp/icon/head_1/')
    shutil.copytree('../../laya/assets/comp/icon/item/', './comp/icon/item/')
    shutil.copytree('../../laya/assets/comp/icon/skill/', './comp/icon/skill/')

    Del_All_File(".\\comp\\", ".pkm")
    Del_All_File(".\\comp\\", ".pkm1")

    Del_All_File(".\\res\\atlas\\", ".pkm")
    Del_All_File(".\\res\\atlas\\", ".pkm1")

    return

    unitfile1 = Get_All_Png_File()
    for e in unitfile1:
        print curpath + e[1:]
    	Transfer_Png_To_Pkm(curpath + e[1:])

    unitfile2 = Get_All_Jpg_File()
    for e in unitfile2:
        print curpath + e[1:]
        Transfer_Jpg_To_Pkm(curpath + e[1:])

    os.chdir(curpath)
    Del_All_File(".\\comp\\", ".pkm1")

    unitfile3 = Get_All_Atlas_File('.\\res\\atlas\\', [])
    for e in unitfile3:
        print curpath + e[1:]
        Transfer_Png_To_Pkm(curpath + e[1:])

    os.chdir(curpath)
    Del_All_File(".\\res\\atlas\\", ".pkm1")

if __name__ == '__main__':
	main()