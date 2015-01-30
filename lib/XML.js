Ext.XML = (new(function() { //overriden
    var me = this,
    encodingFunction,
    // decodingFunction,
    // useNative = null,
    // useHasOwn = !! {}.hasOwnProperty,
    // isNative = function() {
        // if (useNative === null) {
            // useNative = Ext.USE_NATIVE_JSON && window.JSON && JSON.toString() == '[object JSON]';
        // }
        // return useNative;
    // },
    pad = function(n) {
        return n < 10 ? "0" + n : n;
    },
    // doDecode = function(json) {
        // return eval("(" + json + ')');
    // },
    doEncode = function(o, newline) {
        
        if (o === null || o === undefined) {
            return "null";
        } else if (o === "") {
            return "null";
        } else if (Ext.isDate(o)) {
            return Ext.XML.encodeDate(o);
        } else if (Ext.isString(o)) {
            return encodeString(o);
        } else if (typeof o == "number") {
            return isFinite(o) ? String(o) : "null";
        } else if (Ext.isBoolean(o)) {
            return o?"1":"null";
        }
        
        
        else if (o.toJSON) {
            return o.toJSON();
        } else if (Ext.isArray(o)) {
			if (o.length>1) {
				return encodeArray(o, newline);
			} else {
				return doEncode(o[0]);
			}
        } else if (Ext.isObject(o)) {
            return encodeObject(o, newline);
        } else if (typeof o === "function") {
            return "null";
        }
        return 'undefined';
    },
    // m = {
        // "\b": '\\b',
        // "\t": '\\t',
        // "\n": '\\n',
        // "\f": '\\f',
        // "\r": '\\r',
        // '"': '\\"',
        // "\\": '\\\\',
        // '\x0b': '\\u000b' 
    // },
    // charToReplace = /[\\\"\x00-\x1f\x7f-\uffff]/g,
    encodeString = function(s) {
		return "'"+s.replace('+', '%2B')+"'";
        // return '"' + s.replace(charToReplace, function(a) {
            // var c = m[a];
            // return typeof c === 'string' ? c : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        // }) + '"';
    },


    encodeArray = function(o, newline) {

        var a = [""], //["<values>"], 
            len = o.length,
            i;
        for (i = 0; i < len; i += 1) {
            a.push("<value>",doEncode(o[i]),"</value>");
        }
        
        // a[a.length - 1] = '</values>';
        return a.join("");
    },

    encodeObject = function(o, newline) {
		return o.isInstance?doEncode(Ext.isObject(o.getValue()) && o.valueField?o.getValue()[o.valueField]:o.getValue()):doEncode(o.value!==undefined?o["value"]:(o.id!==undefined?o["id"]:null));//doEncode(o["value"] || o["id"] || null);
		//return (o.value?"'"+o.value+"'":(o.id?"'"+o.id+"'":'NULL'));
        // var a = ["{", ""], 
            // i;
        // for (i in o) {
            // if (!useHasOwn || o.hasOwnProperty(i)) {
                // a.push(doEncode(i), ":", doEncode(o[i]), ',');
            // }
        // }
        
        // a[a.length - 1] = '}';
        // return a.join("");
    };

    
    me.encodeValue = doEncode;

    
    me.encodeDate = function(o) {
        return "'" + o.getFullYear() + "-"
        + pad(o.getMonth() + 1) + "-"
        + pad(o.getDate()) + "T"
        + pad(o.getHours()) + ":"
        + pad(o.getMinutes()) + ":"
        + pad(o.getSeconds()) + "'";
    };

    
    me.encode = function(o) {
        if (!encodingFunction) {
            
            encodingFunction = /*isNative() ? JSON.stringify : */me.encodeValue;
        }
        return encodingFunction(o);
    };

    
    // me.decode = function(json, safe) {
        // if (!decodingFunction) {
            
            // decodingFunction = isNative() ? JSON.parse : doDecode;
        // }
        // try {
            // return decodingFunction(json);
        // } catch (e) {
            // if (safe === true) {
                // return null;
            // }
            // Ext.Error.raise({
                // sourceClass: "Ext.XML",
                // sourceMethod: "decode",
                // msg: "You're trying to decode an invalid JSON String: " + json
            // });
        // }
    // };
})());