var FileTool=(function(){
	function FileTool(){
		this._length=0;
		this.classDic={};
		this._length=0;
		this._objectEncoding_=0;
		this._position_=0;
		this._allocated_=8;
		this._data_=null;
		this._littleEndian_=false;
		this._byteView_=null;
		this._strTable=null;
		this._objTable=null;
		this._traitsTable=null;
		this.___resizeBuffer(this._allocated_);
	}

	var __proto=FileTool.prototype;

	__proto.writeArrayBuffer=function(arraybuffer,offset,length){
		(offset===void 0)&& (offset=0);
		(length===void 0)&& (length=0);
		if (offset < 0 || length < 0)throw "writeArrayBuffer error - Out of bounds";
		if(length==0)length=arraybuffer.byteLength-offset;
		this.ensureWrite (this._position_+length);
		var uint8array=new Uint8Array(arraybuffer);
		this._byteView_ = uint8array;
		this._byteView_.set(uint8array.subarray (offset,offset+length),this._position_);
		this._position_+=length;
	}

	__proto.clear=function(){
		this._strTable=[];
		this._objTable=[];
		this._traitsTable=[];
		this._position_=0;
		this.length=0;
	}

	__proto.ensureWrite=function(lengthToEnsure){
		if (this._length < lengthToEnsure)this._byteView_.length=lengthToEnsure;
	}

	__proto.readUTFBytes=function(len){
		(len===void 0)&& (len=-1);
		var value="";
		var max=this._position_+len;
		var c=0,c2=0,c3=0;
		while (this._position_ < max){
			c=this._data_.getUint8 (this._position_++);
			if (c < 0x80){
				if (c !=0){
					value+=String.fromCharCode (c);
				}
				}else if (c < 0xE0){
				value+=String.fromCharCode (((c & 0x3F)<< 6)| (this._data_.getUint8 (this._position_++)& 0x7F));
				}else if (c < 0xF0){
				c2=this._data_.getUint8 (this._position_++);
				value+=String.fromCharCode (((c & 0x1F)<< 12)| ((c2 & 0x7F)<< 6)| (this._data_.getUint8 (this._position_++)& 0x7F));
				}else {
				c2=this._data_.getUint8 (this._position_++);
				c3=this._data_.getUint8 (this._position_++);
				value+=String.fromCharCode (((c & 0x0F)<< 18)| ((c2 & 0x7F)<< 12)| ((c3 << 6)& 0x7F)| (this._data_.getUint8 (this._position_++)& 0x7F));
			}
		}
		return value;
	}

	__proto.___resizeBuffer=function(len){
		try{
			var newByteView=new Uint8Array(len);
			if (this._byteView_!=null){
				if (this._byteView_.length <=len)newByteView.set (this._byteView_);
				else newByteView.set (this._byteView_.subarray (0,len));
			}
			this._byteView_=newByteView;
			this._data_=new DataView(newByteView.buffer);
		}
		catch (err){
			throw "___resizeBuffer err:"+len;
		}
	}

	__proto.bytesAvailable=function(){
		return this._byteView_.length-this._position_;
	}

	__proto.uncompress=function(algorithm){
		(algorithm===void 0)&& (algorithm="zlib");
		var inflate=new Zlib.Inflate(this._byteView_);
		this._byteView_=inflate.decompress();
		this._data_=new DataView(this._byteView_ .buffer);;
		this._$1__allocated_=this._$1__length=this._byteView_.byteLength;
		this._position_=0;
	}

	__proto.toString=function(){
		var cachePosition=this._position_;
		this._position_=0;
		var value=this.readUTFBytes (this._byteView_.length);
		this._position_=cachePosition;
		return value;
	}
	return FileTool;
})();

/*function doLoadGameZFile($url){
	var http = new XMLHttpRequest();
	http.open('get', $url, true);
	http.responseType = "arraybuffer";
	http.onerror = function(e) {
	}
	http.onload = function(e) {
		var status = http.status !== undefined ? http.status : 200;
		
		if (status === 200 || status === 204 || status === 0) {
			_data = http.response || http.responseText;
			var fileTool = new FileTool();
			fileTool.writeArrayBuffer(_data);
			fileTool._position_ = 0;
			fileTool.uncompress();
			var str = fileTool.readUTFBytes(fileTool.bytesAvailable());
			window.eval(str);
			http.onload = null;
			http = null;
			var ft = document.getElementById('fileTool');
			if(ft)
			{
				ft.parentNode.removeChild(ft);
			}
			
		} else {
			error("[" + http.status + "]" + http.statusText + ":" + http.responseURL);
		}
	}
	http.send(null);
}*/
