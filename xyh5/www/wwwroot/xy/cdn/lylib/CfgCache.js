var CfgCache = (function () {
    function CfgCache() {
        this._cache = {};
    }
	
	CfgCache.prototype.parseDb = function(output,roughData){
        var headIndex = 1;
        var dataIndex = 2;
        
        var lines = roughData.split(/\r\n/);
    
        var propertyList = [];
        var state = 0;
		var index = 0;
        for(var line of lines){			
			if(headIndex == index){
				 propertyList = line.split(/\t/);
			}
			
			++index;
			
			if(index <= dataIndex)
			{
				continue;
			}
			
			if(!line.trim()){
				continue;
			}

			var words = line.split(/\t/);

			if(words.length > 0){
				var data = {};
				for(var i = 0; i < words.length; ++i){
					if(i >= propertyList.length){
						break;
					}

					data[propertyList[i]] = words[i];
				}

				output.push(data);
			}
        }
    };
    
    CfgCache.prototype.parseCfg = function(output,roughData){
        var headPattern = "[header]";
        var dataPattern = "[data]";
        
        var lines = roughData.split(/\r\n/);
    
        var propertyNameReg = /^(\S+)\t/;
        var propertyList = [];
        var state = 0;
        for(var line of lines){
            if(state == 0 && line.indexOf(headPattern) != -1){
                state = 0;
                continue;
            }
            else if(state == 0 && line.indexOf(dataPattern) != -1){
                state = 1;
                continue;
            }
    
            if(state == 0){
                var properyResult = propertyNameReg.exec(line);
    
                if(properyResult && properyResult[1]){
                    propertyList.push(properyResult[1]);
                }
            }
            else if(state == 1){
                if(!line.trim()){
                    continue;
                }
    
                var words = line.split(/\t/);
    
                if(words.length > 0){
                    var data = {};
                    for(var i = 0; i < words.length; ++i){
                        if(i >= propertyList.length){
                            break;
                        }
    
                        data[propertyList[i]] = words[i];
                    }
    
                    output.push(data);
                }
            }
        }
    };

    CfgCache.prototype.addData = function (storeId, list, ids) {
        this._cache[storeId] = this._toDict(list, ids);
        
        console.log('cfg complete:' + storeId);
    };

    CfgCache.prototype.getData = function (storeId, keys) {
        if (this._cache[storeId]) {
            var dict = this._cache[storeId];
            for (var _i = 0, keys_1 = keys; _i < keys_1.length; _i++) {
                var key = keys_1[_i];
                dict = dict[key];
                if(!dict){
                    return null;
                }
            }
            return dict;
        }
        return null;
    };

    CfgCache.prototype.every = function(storeId, callback){
        var dict = this._cache[storeId];

        if(dict){
            for(var key in dict){
                callback(dict[key]);
            }
        }
    };
	
	CfgCache.prototype.getCfcArr = function(storeId){
		var dict = this._cache[storeId];
		var cfcArr = [];
        if(dict){
            for(var key in dict){
               cfcArr.push(dict[key]);
            }
        }
        return cfcArr;
    };

    CfgCache.prototype.hasCfg = function(storeId){
        return this._cache[storeId] != undefined;
    }

    CfgCache.prototype._toDict = function (list, ids) {
        var dict = {};
        if (!ids || ids.length == 0) {
            return dict;
        }
        for (var _i = 0, list_1 = list; _i < list_1.length; _i++) {
            var data = list_1[_i];
            var innerDict = dict;
            for (var i = 0; i < ids.length - 1; ++i) {
                var key = data[ids[i]];
                if (!innerDict[key]) {
                    innerDict[key] = {};
                }
                innerDict = innerDict[key];
            }
            innerDict[data[ids[ids.length - 1]]] = data;
        }
        return dict;
    };
    return CfgCache;
}());

//module.exports = CfgCache;