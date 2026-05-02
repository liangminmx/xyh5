var NetPacket = (
function(){
    function NetPacket(arrayBuffer, headLength){
        this._setBuff(arrayBuffer ? arrayBuffer : new ArrayBuffer(8));//new ArrayBuffer(1024));
        this._length = 0;
        this.littleEndian = false;
        this.headLength = headLength != undefined ? headLength : 8;
        this._position = this.headLength;
        this._length = this._position;

        this.procType = 0;
        this.proc = 0;
        this.procLength = 0;
    }

    NetPacket.prototype.setData = function(arrayBuffer){
        this._setBuff(arrayBuffer);

        this._length = this._buffLen;
        this.headLength = 0;
        this._position = 0;
    }

    NetPacket.prototype.clear = function(){
        this._buff = null;
        this.data = null;
    },

    NetPacket.prototype._setBuff =  function(arrayBuffer){
        this._buffLen = arrayBuffer.byteLength;
        this._buff = arrayBuffer;
        this.data = new DataView(this._buff);
    }

    NetPacket.prototype.appendData = function(arrayBuffer, isCutBeforePosition){
        var isCut = isCutBeforePosition == undefined ? false : isCutBeforePosition;

        var startPosition = 0;

        var oldSize = 0;
        if(isCut){
            startPosition = this.position;
        }
        else{
            startPosition = 0;
        }

        var totalSize = this._length + arrayBuffer.byteLength - startPosition;

        var newBuffer = new ArrayBuffer(totalSize);
        var uint8Buffer = new Uint8Array(newBuffer);
        //var oBuffer = new Uint8Array(this._buff);
        //var oldBuffer = oBuffer.slice(startPosition, this._length);
		
		var oldBuffer = new Uint8Array(this._buff, startPosition, this._length - startPosition);
		
        uint8Buffer.set(oldBuffer);
        uint8Buffer.set(new Uint8Array(arrayBuffer), oldBuffer.length);

        this._setBuff(newBuffer);    

        this.position -= startPosition;

        this._length = totalSize;
    }

    NetPacket.prototype.slice = function(start, end){
        return this._buff.slice(start, end);
    };

    NetPacket.prototype.uncompress = function(){
        var inflate = new Zlib.Inflate(new Uint8Array(this._buff));
        var plain = inflate.decompress();

        var buff = new ArrayBuffer(plain.length);

        var newData = new Uint8Array(buff);

        newData.set(plain);

        this.setData(buff);
    }

    Object.defineProperty(NetPacket.prototype, "bytesAvailable", {
        get: function(){
            return this._length - this.position;
        }
    })

    Object.defineProperty(NetPacket.prototype, "buff", {
        get: function () {
            return this._buff;
        }
    });

    Object.defineProperty(NetPacket.prototype, "length", {
        get: function () {
            return this._length;
        }
    });

    Object.defineProperty(NetPacket.prototype, "dataSize", {
        get: function () {
            return this._length - this.headLength;
        }
    });

    Object.defineProperty(NetPacket.prototype, "headSize", {
        get: function () {
            return this.headLength;
        }
    });

    Object.defineProperty(NetPacket.prototype, "position", {
        get: function () {
            return this._position;
        },

        set: function(value) {
            this._position = value;
        }
    });

    NetPacket.prototype.getNetData = function(){
        var buff = this._buff.slice(0, this._length);
        return buff;
    }

    NetPacket.prototype.setLittleEndian = function (value){
        this.littleEndian = value
    }

    NetPacket.prototype.writeInt8 = function (value){
        this.data.setInt8(this.position++, value, this.littleEndian);

        if(this.position > this._length)
            this._length = this.position;
    }

    NetPacket.prototype.writeUint8 = function (value){
        this.data.setUint8(this.position++, value, this.littleEndian);
        if(this.position > this._length)
            this._length = this.position;
    }

    NetPacket.prototype.writeInt16 = function (value){
        this.data.setInt16(this.position, value, this.littleEndian);
        this.position += 2;
        if(this.position > this._length)
            this._length = this.position;
    }

    NetPacket.prototype.writeUint16 = function (value){
        this.data.setUint16(this.position, value, this.littleEndian);
        this.position += 2;
        if(this.position > this._length)
            this._length = this.position;
    }

    NetPacket.prototype.writeInt32 = function (value){
        this.data.setInt32(this.position, value, this.littleEndian);
        this.position += 4;
        if(this.position > this._length)
            this._length = this.position;
    }

    NetPacket.prototype.writeUint32 = function (value){
        this.data.setUint32(this.position, value, this.littleEndian);
        this.position += 4;
        if(this.position > this._length)
            this._length = this.position;
    }

    NetPacket.prototype.writeFloat32 = function (value){
        this.data.setFloat32(this.position, value, this.littleEndian);
        this.position += 4;
        if(this.position > this._length)
            this._length = this.position;
    }

    NetPacket.prototype.writeUTF8 = function (s){
        this.writeInt16(s.length);

        var i, code, len = s.length;  
        var size = 0;
        
        for(i = 0; i < len; i++){  
            code = s.charCodeAt(i);  
            if(code > 0x0 && code <= 0x7f){  
                //单字节  
                //UTF-16 0000 - 007F  
                //UTF-8  0xxxxxxx  
                this.writeInt8(code);
                size++;
            }else if(code >= 0x80 && code <= 0x7ff){  
                //双字节  
                //UTF-16 0080 - 07FF  
                //UTF-8  110xxxxx 10xxxxxx  
                //110xxxxx  
                this.writeInt8(0xc0 | ((code >> 6) & 0x1f));
                //10xxxxxx  
                this.writeInt8(0x80 | (code & 0x3f));
                size += 2;
            }else if(code >= 0x800 && code <= 0xffff){  
                //三字节  
                //UTF-16 0800 - FFFF  
                //UTF-8  1110xxxx 10xxxxxx 10xxxxxx  
                //1110xxxx  
                this.writeInt8(0xe0 | ((code >> 12) & 0xf));
                //10xxxxxx  
                this.writeInt8(0x80 | ((code >> 6) & 0x3f));
                //10xxxxxx  
                this.writeInt8(0x80 | (code & 0x3f));
                size += 3;
            }  
        }  

        if(size > 0){
            this.position -=  size + 2;
            this.writeInt16(size);
            this.position += size;
        }
    }

    NetPacket.prototype.readInt8 = function (){
        var ret = this.data.getInt8(this.position, this.littleEndian);
        this.position++;
        return ret;
    }

     NetPacket.prototype.readUint8 = function (){
        var ret = this.data.getUint8(this.position, this.littleEndian);
        this.position++;
        return ret;
    }

    NetPacket.prototype.readInt16 = function (){
        var ret = this.data.getInt16(this.position, this.littleEndian);
        this.position += 2;
        return ret;
    }

    NetPacket.prototype.readUint16 = function (){
        var ret = this.data.getUint16(this.position, this.littleEndian);
        this.position += 2;
        return ret;
    }

    NetPacket.prototype.readInt32 = function (){
        var ret = this.data.getInt32(this.position, this.littleEndian);
        this.position += 4;
        return ret;
    }

    NetPacket.prototype.readUint32 = function (){
        var ret = this.data.getUint32(this.position, this.littleEndian);
        this.position += 4;
        return ret;
    }

    NetPacket.prototype.readFloat32 = function (value){
        var ret = this.data.getFloat32(this.position, this.littleEndian);
        this.position += 4;
        return ret;
    }

    NetPacket.prototype.readUTF8 = function (){
        var len = this.readInt16();
        var codes = [];
        var ret = "";
        var c = 0;
        var c2 = 0;
        var c3 = 0;
        for(var i = 0; i < len; ++i){
            c = this.readUint8();
            if(c < 128){
                ret += String.fromCharCode(c);
            }
            else if(c > 191 && c < 224){
                c2 = this.readUint8();
                ++i;
                ret += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
            }
            else{
                c2 = this.readUint8();
                c3 = this.readUint8();

                i += 2;

                ret += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
            }
        }

        return ret;
    }

    NetPacket.prototype.readBytes = function(size){
        var buff = new ArrayBuffer(size);
        var view = new DataView(buff);        

        var position = 0;
        for(var i = 0; i < size; ++i){
            view.setUint8(position, this.readUint8());
            position++;
        }

        return buff;
    }

    NetPacket.prototype.encodeHead = function(type, proc, size){
        var position = 0;
//      this.data.setUint8(position, type, this.littleEndian);
//      position++;
        this.data.setUint32(position, size, this.littleEndian);
        position += 4;
        this.data.setUint32(position, proc, this.littleEndian);
    }

    return NetPacket;
}());

//module.exports = NetPacket;