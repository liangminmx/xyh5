#coding=utf-8

import os
import re

def main():
	print "please input track file name:"
	trackFileName = 'log/' + raw_input()

	if not os.path.exists(trackFileName):
		print "error track file name!"
		return

	outFileName = trackFileName + ".codeline"
	outFileObj = open(outFileName, 'w')

	with open(trackFileName, "r") as fin:
		for line in fin:
			line = line.strip('\n')
			outFileObj.write(line.strip('\n') + '\n')

			values = line.split('/')
			if len(values) <= 0:
				continue;

			value = values[len(values) - 1]
			#print value

			soName = ""
			if value.find('(') != -1:
				soName = value[:value.find('(')]
			elif value.find('[') != -1:
				soName = value[:value.find('[')]
			else:
				continue

			if soName.find('.') != -1:
				soName = soName[:soName.find('.')]

			if not os.path.exists(soName) and not os.path.exists(soName + ".so"):
				continue;

			#print soName

			if os.path.exists(soName):
				pattern = re.compile('\[(\w+)\]')
				res = pattern.findall(value)
				if len(res) <= 0:
					continue
				address = res[0]

				#print os.popen("addr2line -e " + soName + " " + address).read().strip('\n')
				outFileObj.write("========>" + os.popen("addr2line -e " + soName + " " + address).read().strip('\n') + '\n')

			elif os.path.exists(soName + ".so"):
				pattern = re.compile('\((.+)\)')
				res = pattern.findall(value)
				if len(res) <= 0:
					continue
				address = res[0]

				addresses = address.split('+')
				if len(addresses) < 2:
					continue
				address1 = addresses[0]
				address2 = addresses[1]

				if len(address1) < 1 or len(address2) < 1:
					continue
				#print address1
				#print address2

				baseaddress = os.popen("nm " + soName + ".so | grep " + address1).read().split()[0]
				#print baseaddress

				address2 = str(hex(int(baseaddress, 16) + int(address2, 16)))
				#print address2

				#print os.popen("addr2line -e " + soName + ".so " + address2).read().strip('\n')
				outFileObj.write("========>" + os.popen("addr2line -e " + soName + ".so " + address2).read().strip('\n') + '\n')

	print "output to file " + outFileName
	print "done!"

if __name__ == '__main__':
	main()