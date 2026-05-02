#coding=utf-8
paths = [
'network/Key.js',
'md5.js',
'jszip.min.js',
'zlib.js',
'network/NetPacket.js',
'network/Connection.js',
'lylib/CfgCache.js',
'lylib/rawinflate.min.js',
'lylib/b3core.0.1.0.js',
'js/business.min.js',
];

totalContent = '';

for path in paths:
	with open(path, 'r') as f:
		totalContent += f.read() + '\n';

with open(r'business.bundle.js', 'w') as f:
    f.write(totalContent);

print 'write complete';

