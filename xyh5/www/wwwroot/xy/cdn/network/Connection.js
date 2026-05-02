//var Key = require("Key");
//var NetPacket = require("NetPacket");

var Connection = (function(){

	function Connection(){
		this._key = new Key();
		this._autoIncrease = 1;
		this._socket = null;
		this._ip = "";
		this._port = 0;
		this._connected = false;
		this._pakList = [];
		this._recvBuffer = null;
		this._readState = 0;
		this._readPosition = 0;
		this._dataLength = 0;
		this._isCompress = 0;

		this._netPacketStream = null;
		this._recvNetPacket = null;

		this._receiveTarget = null;
		this._receiveFunc = null;
	}

	Object.defineProperty(Connection.prototype, "connected", {
		get: function(){
			return this._connected;
		}
	});

	Connection.prototype.connect = function(ip, port, isSSL){  
		if(this._connected){
			return;
		}
		
		this._ip = ip;
		this._port = port;
		this._connected = false;
		try{  
			console.log('connect:' + ip + ":" + port);
			if (isSSL) {
				this._socket=new WebSocket('wss://'+ip+':'+port);
			}
			else {
				this._socket=new WebSocket('ws://'+ip+':'+port);
			}
			this._socket.binaryType = "arraybuffer";
		}catch(e){  
			console.log('websocket error');  
			return;  
		}  
		this._socket.onopen = this._sOpen.bind(this);
		this._socket.onerror = this._sError.bind(this);
		this._socket.onmessage = this._sMessage.bind(this);
		this._socket.onclose = this._sClose.bind(this);
	}; 

	Connection.prototype.syncTime = function (time){
		this._key.syncTime(time);
	}

	Connection.prototype._sOpen = function(){
		console.log('connect success!');
		this._connected = true;

		this._sendPakList();
	};

	Connection.prototype._sError = function(e){
		console.log("error " + e);
		
	};

	Connection.prototype._sMessage = function(msg){  
		//  cc.log('on message');  
		console.log("_sMessage: " + msg.data.byteLength);
		if(this._recvBuffer){
			var newBuffer = new ArrayBuffer(this.getBytesAvailable() + msg.data.byteLength);

			var uint8Buffer = new Uint8Array(newBuffer);
			var oldBuffer = new Uint8Array(this._recvBuffer, this._readPosition, this.getBytesAvailable());

			uint8Buffer.set(oldBuffer);
			uint8Buffer.set(new Uint8Array(msg.data), oldBuffer.length);
            
			this._recvBuffer = newBuffer;
			this._readPosition = 0;
		}
		else{
			this._recvBuffer = msg.data;
			this._readPosition = 0;
		}
			
		var netPak = new NetPacket();
		netPak.setData(this._recvBuffer);
	
		if(this._socket.readyState == 1){
			do
			{
				if(this._readState == 0 && this.getBytesAvailable() >= 8){
					netPak._position = this._readPosition;
					this._dataLength = netPak.readUint32();
//					this._isCompress = netPak.readInt16();
					this._readState = 1;
//					this._readPosition += netPak.position;
				}

				if(this._readState == 1 && this.getBytesAvailable() >= this._dataLength){
					var recvData = new NetPacket();
					recvData.setData(this._recvBuffer.slice(this._readPosition, this._readPosition + this._dataLength));
//					if(this._isCompress){
//						recvData.uncompress();
//					}
                    //console.log(recvData.uncompress());
					//NetPacket
					this.splitByteArray(recvData);

					this._readPosition += this._dataLength;
					this._readState = 0;
				}
			}
			while(this._socket.readyState == 1 && this._readState == 0 && this.getBytesAvailable() >= 8);
		}
	};

	Connection.prototype.splitByteArray = function(pak){
		if(!this._netPacketStream){
			this._netPacketStream = new NetPacket(new ArrayBuffer(0),0);
		}

		this._netPacketStream.appendData(pak.buff, true);
		do{
			if(this._recvNetPacket == null && this._netPacketStream.bytesAvailable >= 8){
				this._recvNetPacket = new NetPacket(new ArrayBuffer(0),0);
				this._recvNetPacket.procType = 1; //this._netPacketStream.readInt8();
				this._recvNetPacket.procLength = this._netPacketStream.readUint32();
				this._recvNetPacket.proc = this._netPacketStream.readUint32();
			}

			if(this._recvNetPacket && this._netPacketStream.bytesAvailable >= this._recvNetPacket.procLength - 8){
				var buff = this._netPacketStream.readBytes(this._recvNetPacket.procLength - 8);
				this._recvNetPacket.appendData(buff);

				this.resolvePacket(this._recvNetPacket);

				this._recvNetPacket.clear();
				this._recvNetPacket = null;
			}
		}
		while(this._recvNetPacket == null && this._netPacketStream.bytesAvailable >= 8);
		
	}

	Connection.prototype.resolvePacket = function (pak){
		// cc.log(pak.proc);
		if(this._receiveTarget){
			this._receiveTarget.onMsg(pak);
		}
	}

	Connection.prototype.setReceiver = function(target){
		this._receiveTarget = target;
	}

	Connection.prototype.getBytesAvailable = function(){
		if(this._recvBuffer){
			var size = this._recvBuffer.byteLength - this._readPosition;
			return size;
		}

		return 0;
	}

	Connection.prototype._sClose = function(e){
		console.log("connect closed:" + e.code);

		this._connected = false;
		this.clearPakList();
        this._receiveTarget.closed(e.code)
	};  

	Connection.prototype.clearPakList = function(){
		this._pakList = [];
	};

	Connection.prototype.send = function(proc, netpacket){
		console.log("发送")
		if(this._connected){
			this._sendPacketToServer(this._socket, proc, netpacket);
		}
		else{
			this._pakList.push([proc, netpacket]);
		}
	}; 

	Connection.prototype._sendPakList = function(){
		for(var i = 0; i < this._pakList.length; ++i){
			this.send(this._pakList[i][0], this._pakList[i][1]);
		}
	};

	Connection.prototype.close = function(){
		this._socket.close();
	};
	
	Connection.prototype._sendPacketToServer = function(socket, proc, packet){
//		packet.writeInt32(this._autoIncrease++);
//		packet.writeInt8(0);

		var buff = packet.buff;
		var dataSize = packet.dataSize;
//		var startIndex = packet.headSize;

//		var keyProc = proc;
//		if(proc == 2001 || proc == 1001 || proc <= 7 || proc == 10 || proc == 331){
//			keyProc = 0;
//		}

//		var test = new Int8Array(buff, 0);
//		this._key.encryptNetData(keyProc, new Int8Array(buff, startIndex), dataSize);
		packet.encodeHead(1, proc, dataSize + 8);

		socket.send(packet.getNetData());
	}

	return Connection;
}());

//module.exports = Connection;