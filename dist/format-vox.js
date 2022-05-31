var $hx_exports = typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this;
(function ($global) { "use strict";
$hx_exports["format"] = $hx_exports["format"] || {};
$hx_exports["format"]["vox"] = $hx_exports["format"]["vox"] || {};
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var nc = x.charCodeAt(i + 1);
				var v = parseInt(x,nc == 120 || nc == 88 ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
var format_vox_VoxNodeTools = $hx_exports["format"]["vox"]["VoxNodeTools"] = function() { };
format_vox_VoxNodeTools.__name__ = true;
format_vox_VoxNodeTools.walkNodeGraph = function(vox,w) {
	w.beginGraph(vox);
	format_vox_VoxNodeTools.nodeWalker(vox.nodeGraph,w);
	w.endGraph();
};
format_vox_VoxNodeTools.nodeWalker = function(node,w) {
	if(node == null) {
		console.log("format/vox/VoxNodeTools.hx:30:","TODO (DK)");
	} else {
		switch(node._hx_index) {
		case 0:
			w.onTransform(node.frames[0]);
			format_vox_VoxNodeTools.nodeWalker(node.child,w);
			break;
		case 1:
			var _g = node.children;
			w.beginGroup(node.attributes);
			var _g1 = 0;
			while(_g1 < _g.length) format_vox_VoxNodeTools.nodeWalker(_g[_g1++],w);
			w.endGroup();
			break;
		case 2:
			w.onShape(node.attributes,node.models);
			break;
		}
	}
};
var format_vox_VoxReader = $hx_exports["format"]["vox"]["VoxReader"] = function() { };
format_vox_VoxReader.__name__ = true;
format_vox_VoxReader.read = function(data,then) {
	if(data == null) {
		then(null,"Invalid input");
		return;
	}
	var input = new haxe_io_BytesInput(haxe_io_Bytes.ofData(data));
	if(input.readString(4) != "VOX ") {
		then(null,"Expected \"VOX \" header");
		return;
	}
	var version = input.readInt32();
	if(version != 150 && version != 200) {
		then(null,"Unsupported version \"" + version + "\"");
		return;
	}
	var vox = new format_vox_types_Vox();
	var _this = format_vox_VoxReader.get_DefaultPalette();
	var f = format_vox_VoxTools.transformColor;
	var result = new Array(_this.length);
	var _g = 0;
	var _g1 = _this.length;
	while(_g < _g1) {
		var i = _g++;
		result[i] = f(_this[i]);
	}
	vox.palette = result;
	var nodeData = [];
	format_vox_VoxReader.readChunk(input,vox,nodeData,{ modelIndex : 0, sizeIndex : 0});
	if(nodeData.length > 0) {
		vox.nodeGraph = format_vox_VoxReader.buildNodeGraph(vox,nodeData,0);
	}
	then(vox,null);
};
format_vox_VoxReader.readChunk = function(input,vox,nodeData,state) {
	var chunkId = input.readString(4);
	var contentSize = input.readInt32();
	var childBytes = input.readInt32();
	switch(chunkId) {
	case "MAIN":
		break;
	case "MATL":
		var m_id = input.readInt32();
		var _g = new haxe_ds_StringMap();
		var _g1 = 0;
		var _g2 = input.readInt32();
		while(_g1 < _g2) {
			++_g1;
			var key = input.read(input.readInt32()).toString();
			var value = input.read(input.readInt32()).toString();
			_g.h[key] = value;
		}
		vox.materials[m_id] = _g;
		break;
	case "PACK":
		input.readInt32();
		break;
	case "RGBA":
		var palette = format_vox_VoxReader.get_DefaultPalette();
		var _g = 0;
		while(_g < 255) palette[_g++ + 1] = input.readInt32();
		input.readInt32();
		var f = format_vox_VoxTools.transformColor;
		var result = new Array(palette.length);
		var _g = 0;
		var _g1 = palette.length;
		while(_g < _g1) {
			var i = _g++;
			result[i] = f(palette[i]);
		}
		vox.palette = result;
		break;
	case "SIZE":
		vox.sizes[state.sizeIndex++] = new format_vox_types_Size(input.readInt32(),input.readInt32(),input.readInt32());
		break;
	case "XYZI":
		var vox1 = vox.models;
		var tmp = state.modelIndex++;
		var _g = [];
		var _g1 = 0;
		var _g2 = input.readInt32();
		while(_g1 < _g2) {
			++_g1;
			_g.push(new format_vox_types_Voxel(input.readByte(),input.readByte(),input.readByte(),input.readByte()));
		}
		vox1[tmp] = _g;
		break;
	case "nGRP":
		var nodeId = input.readInt32();
		var _g = new haxe_ds_StringMap();
		var _g1 = 0;
		var _g2 = input.readInt32();
		while(_g1 < _g2) {
			++_g1;
			var key = input.read(input.readInt32()).toString();
			var value = input.read(input.readInt32()).toString();
			_g.h[key] = value;
		}
		var numChildren = input.readInt32();
		var _g1 = [];
		var _g2 = 0;
		while(_g2 < numChildren) {
			++_g2;
			_g1.push(input.readInt32());
		}
		nodeData[nodeId] = format_vox__$VoxReader_NodeData.GroupNodeData(_g,_g1);
		break;
	case "nSHP":
		var nodeId = input.readInt32();
		var _g = new haxe_ds_StringMap();
		var _g1 = 0;
		var _g2 = input.readInt32();
		while(_g1 < _g2) {
			++_g1;
			var key = input.read(input.readInt32()).toString();
			var value = input.read(input.readInt32()).toString();
			_g.h[key] = value;
		}
		var numModels = input.readInt32();
		var _g1 = [];
		var _g2 = 0;
		while(_g2 < numModels) {
			++_g2;
			var _g3 = input.readInt32();
			var _g4 = new haxe_ds_StringMap();
			var _g5 = 0;
			var _g6 = input.readInt32();
			while(_g5 < _g6) {
				++_g5;
				var key = input.read(input.readInt32()).toString();
				var value = input.read(input.readInt32()).toString();
				_g4.h[key] = value;
			}
			_g1.push(new format_vox_types_Model(_g3,_g4));
		}
		nodeData[nodeId] = format_vox__$VoxReader_NodeData.ShapeNodeData(_g,_g1);
		break;
	case "nTRN":
		var nodeId = input.readInt32();
		var _g = new haxe_ds_StringMap();
		var _g1 = 0;
		var _g2 = input.readInt32();
		while(_g1 < _g2) {
			++_g1;
			var key = input.read(input.readInt32()).toString();
			var value = input.read(input.readInt32()).toString();
			_g.h[key] = value;
		}
		var childNodeId = input.readInt32();
		var reserved = input.readInt32();
		var layerId = input.readInt32();
		var numFrames = input.readInt32();
		var _g1 = [];
		var _g2 = 0;
		while(_g2 < numFrames) {
			++_g2;
			var _g3 = new haxe_ds_StringMap();
			var _g4 = 0;
			var _g5 = input.readInt32();
			while(_g4 < _g5) {
				++_g4;
				var key = input.read(input.readInt32()).toString();
				var value = input.read(input.readInt32()).toString();
				_g3.h[key] = value;
			}
			_g1.push(_g3);
		}
		nodeData[nodeId] = format_vox__$VoxReader_NodeData.TransformNodeData(_g,childNodeId,reserved,layerId,_g1);
		break;
	default:
		input.read(contentSize);
	}
	var chunkSize = 12 + contentSize + childBytes;
	while(childBytes > 0) childBytes -= format_vox_VoxReader.readChunk(input,vox,nodeData,state);
	return chunkSize;
};
format_vox_VoxReader.buildNodeGraph = function(vox,nodeData,nodeId) {
	var n = nodeData[nodeId];
	switch(n._hx_index) {
	case 0:
		return format_vox_types_Node.Transform(n.attributes,n.reserved,n.layerId,n.frames,format_vox_VoxReader.buildNodeGraph(vox,nodeData,n.childNodeId));
	case 1:
		var _g = n.attributes;
		var _g1 = n.children;
		var _g2 = [];
		var _g3 = 0;
		while(_g3 < _g1.length) _g2.push(format_vox_VoxReader.buildNodeGraph(vox,nodeData,_g1[_g3++]));
		return format_vox_types_Node.Group(_g,_g2);
	case 2:
		return format_vox_types_Node.Shape(n.attributes,n.models);
	}
};
format_vox_VoxReader.readVoxel = function(input) {
	return new format_vox_types_Voxel(input.readByte(),input.readByte(),input.readByte(),input.readByte());
};
format_vox_VoxReader.readMaterial = function(input) {
	var tmp = input.readInt32();
	var _g = new haxe_ds_StringMap();
	var _g1 = 0;
	var _g2 = input.readInt32();
	while(_g1 < _g2) {
		++_g1;
		var key = input.read(input.readInt32()).toString();
		var value = input.read(input.readInt32()).toString();
		_g.h[key] = value;
	}
	return { id : tmp, props : _g};
};
format_vox_VoxReader.readDict = function(input) {
	var _g = new haxe_ds_StringMap();
	var _g1 = 0;
	var _g2 = input.readInt32();
	while(_g1 < _g2) {
		++_g1;
		var key = input.read(input.readInt32()).toString();
		var value = input.read(input.readInt32()).toString();
		_g.h[key] = value;
	}
	return _g;
};
format_vox_VoxReader.i32 = function(input) {
	return input.readInt32();
};
format_vox_VoxReader.byte = function(input) {
	return input.readByte();
};
format_vox_VoxReader.string = function(input) {
	return input.read(input.readInt32()).toString();
};
format_vox_VoxReader.get_DefaultPalette = function() {
	return [0,-1,-3342337,-6684673,-10027009,-13369345,-16711681,-13057,-3355393,-6697729,-10040065,-13382401,-16724737,-26113,-3368449,-6710785,-10053121,-13395457,-16737793,-39169,-3381505,-6723841,-10066177,-13408513,-16750849,-52225,-3394561,-6736897,-10079233,-13421569,-16763905,-65281,-3407617,-6749953,-10092289,-13434625,-16776961,-52,-3342388,-6684724,-10027060,-13369396,-16711732,-13108,-3355444,-6697780,-10040116,-13382452,-16724788,-26164,-3368500,-6710836,-10053172,-13395508,-16737844,-39220,-3381556,-6723892,-10066228,-13408564,-16750900,-52276,-3394612,-6736948,-10079284,-13421620,-16763956,-65332,-3407668,-6750004,-10092340,-13434676,-16777012,-103,-3342439,-6684775,-10027111,-13369447,-16711783,-13159,-3355495,-6697831,-10040167,-13382503,-16724839,-26215,-3368551,-6710887,-10053223,-13395559,-16737895,-39271,-3381607,-6723943,-10066279,-13408615,-16750951,-52327,-3394663,-6736999,-10079335,-13421671,-16764007,-65383,-3407719,-6750055,-10092391,-13434727,-16777063,-154,-3342490,-6684826,-10027162,-13369498,-16711834,-13210,-3355546,-6697882,-10040218,-13382554,-16724890,-26266,-3368602,-6710938,-10053274,-13395610,-16737946,-39322,-3381658,-6723994,-10066330,-13408666,-16751002,-52378,-3394714,-6737050,-10079386,-13421722,-16764058,-65434,-3407770,-6750106,-10092442,-13434778,-16777114,-205,-3342541,-6684877,-10027213,-13369549,-16711885,-13261,-3355597,-6697933,-10040269,-13382605,-16724941,-26317,-3368653,-6710989,-10053325,-13395661,-16737997,-39373,-3381709,-6724045,-10066381,-13408717,-16751053,-52429,-3394765,-6737101,-10079437,-13421773,-16764109,-65485,-3407821,-6750157,-10092493,-13434829,-16777165,-256,-3342592,-6684928,-10027264,-13369600,-16711936,-13312,-3355648,-6697984,-10040320,-13382656,-16724992,-26368,-3368704,-6711040,-10053376,-13395712,-16738048,-39424,-3381760,-6724096,-10066432,-13408768,-16751104,-52480,-3394816,-6737152,-10079488,-13421824,-16764160,-65536,-3407872,-6750208,-10092544,-13434880,-16776978,-16776995,-16777029,-16777046,-16777080,-16777097,-16777131,-16777148,-16777182,-16777199,-16716288,-16720640,-16729344,-16733696,-16742400,-16746752,-16755456,-16759808,-16768512,-16772864,-1179648,-2293760,-4521984,-5636096,-7864320,-8978432,-11206656,-12320768,-14548992,-15663104,-1118482,-2236963,-4473925,-5592406,-7829368,-8947849,-11184811,-12303292,-14540254,-15658735];
};
var format_vox__$VoxReader_NodeData = $hxEnums["format.vox._VoxReader.NodeData"] = { __ename__:true,__constructs__:null
	,TransformNodeData: ($_=function(attributes,childNodeId,reserved,layerId,frames) { return {_hx_index:0,attributes:attributes,childNodeId:childNodeId,reserved:reserved,layerId:layerId,frames:frames,__enum__:"format.vox._VoxReader.NodeData",toString:$estr}; },$_._hx_name="TransformNodeData",$_.__params__ = ["attributes","childNodeId","reserved","layerId","frames"],$_)
	,GroupNodeData: ($_=function(attributes,children) { return {_hx_index:1,attributes:attributes,children:children,__enum__:"format.vox._VoxReader.NodeData",toString:$estr}; },$_._hx_name="GroupNodeData",$_.__params__ = ["attributes","children"],$_)
	,ShapeNodeData: ($_=function(attributes,models) { return {_hx_index:2,attributes:attributes,models:models,__enum__:"format.vox._VoxReader.NodeData",toString:$estr}; },$_._hx_name="ShapeNodeData",$_.__params__ = ["attributes","models"],$_)
};
format_vox__$VoxReader_NodeData.__constructs__ = [format_vox__$VoxReader_NodeData.TransformNodeData,format_vox__$VoxReader_NodeData.GroupNodeData,format_vox__$VoxReader_NodeData.ShapeNodeData];
var format_vox_VoxTools = $hx_exports["format"]["vox"]["VoxTools"] = function() { };
format_vox_VoxTools.__name__ = true;
format_vox_VoxTools.transformYZ = function(vox) {
	var _g = 0;
	var _g1 = vox.models.length;
	while(_g < _g1) {
		var i = _g++;
		var dy = vox.sizes[i].y;
		var _g2 = 0;
		var _g3 = vox.models[i];
		while(_g2 < _g3.length) {
			var v = _g3[_g2];
			++_g2;
			var y = v.y;
			v.y = v.z;
			v.z = dy - 1 - y;
		}
	}
};
format_vox_VoxTools.transformColor = function(color) {
	return new format_vox_types_Color(color & 255,color >> 8 & 255,color >> 16 & 255,color >> 24 & 255);
};
format_vox_VoxTools.dictHasTranslation = function(d) {
	return d.h["_t"] != null;
};
format_vox_VoxTools.getTranslationFromDict = function(d) {
	var t = d.h["_t"];
	if(t == null) {
		return { x : 0, y : 0, z : 0};
	}
	var split = t.split(" ");
	return { x : Std.parseInt(split[0]), y : Std.parseInt(split[1]), z : Std.parseInt(split[2])};
};
format_vox_VoxTools.dictHasRotation = function(d) {
	return d.h["_r"] != null;
};
format_vox_VoxTools.getRotationFromDict = function(d) {
	var r = d.h["_r"];
	if(r == null) {
		return { _00 : 1, _10 : 0, _20 : 0, _01 : 0, _11 : 1, _21 : 0, _02 : 0, _12 : 0, _22 : 1};
	}
	var value = Std.parseInt(r);
	var s0 = (value & 16) == 0 ? 1 : -1;
	var s1 = (value & 32) == 0 ? 1 : -1;
	var s2 = (value & 64) == 0 ? 1 : -1;
	var r0 = (value & 1) + (value & 2);
	var r1 = (value >> 2 & 1) + (value >> 2 & 2);
	var r2;
	switch(r0) {
	case 0:
		switch(r1) {
		case 1:
			r2 = 2;
			break;
		case 2:
			r2 = 1;
			break;
		default:
			console.log("format/vox/VoxTools.hx:90:","missing r0;r1 match");
			r2 = 0;
		}
		break;
	case 1:
		switch(r1) {
		case 0:
			r2 = 2;
			break;
		case 2:
			r2 = 0;
			break;
		default:
			console.log("format/vox/VoxTools.hx:90:","missing r0;r1 match");
			r2 = 0;
		}
		break;
	case 2:
		switch(r1) {
		case 0:
			r2 = 1;
			break;
		case 1:
			r2 = 0;
			break;
		default:
			console.log("format/vox/VoxTools.hx:90:","missing r0;r1 match");
			r2 = 0;
		}
		break;
	default:
		console.log("format/vox/VoxTools.hx:90:","missing r0;r1 match");
		r2 = 0;
	}
	return { _00 : r0 == 0 ? s0 : 0, _10 : r0 == 1 ? s0 : 0, _20 : r0 == 2 ? s0 : 0, _01 : r1 == 0 ? s1 : 0, _11 : r1 == 1 ? s1 : 0, _21 : r1 == 2 ? s1 : 0, _02 : r2 == 0 ? s2 : 0, _12 : r2 == 1 ? s2 : 0, _22 : r2 == 2 ? s2 : 0};
};
var format_vox_types_Color = function(r,g,b,a) {
	this.r = r;
	this.g = g;
	this.b = b;
	this.a = a;
};
format_vox_types_Color.__name__ = true;
var format_vox_types_Model = function(modelId,attributes) {
	this.modelId = modelId;
	this.attributes = attributes;
};
format_vox_types_Model.__name__ = true;
var format_vox_types_Node = $hxEnums["format.vox.types.Node"] = { __ename__:true,__constructs__:null
	,Transform: ($_=function(attributes,reserved,layerId,frames,child) { return {_hx_index:0,attributes:attributes,reserved:reserved,layerId:layerId,frames:frames,child:child,__enum__:"format.vox.types.Node",toString:$estr}; },$_._hx_name="Transform",$_.__params__ = ["attributes","reserved","layerId","frames","child"],$_)
	,Group: ($_=function(attributes,children) { return {_hx_index:1,attributes:attributes,children:children,__enum__:"format.vox.types.Node",toString:$estr}; },$_._hx_name="Group",$_.__params__ = ["attributes","children"],$_)
	,Shape: ($_=function(attributes,models) { return {_hx_index:2,attributes:attributes,models:models,__enum__:"format.vox.types.Node",toString:$estr}; },$_._hx_name="Shape",$_.__params__ = ["attributes","models"],$_)
};
format_vox_types_Node.__constructs__ = [format_vox_types_Node.Transform,format_vox_types_Node.Group,format_vox_types_Node.Shape];
var format_vox_types_Size = function(x,y,z) {
	this.x = x;
	this.y = y;
	this.z = z;
};
format_vox_types_Size.__name__ = true;
var format_vox_types_Vox = function() {
	this.materials = [];
	this.models = [];
	this.sizes = [];
};
format_vox_types_Vox.__name__ = true;
var format_vox_types_Voxel = function(x,y,z,colorIndex) {
	this.x = x;
	this.y = y;
	this.z = z;
	this.colorIndex = colorIndex;
};
format_vox_types_Voxel.__name__ = true;
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = true;
haxe_Exception.caught = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value;
	} else if(((value) instanceof Error)) {
		return new haxe_Exception(value.message,null,value);
	} else {
		return new haxe_ValueException(value,null,value);
	}
};
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	unwrap: function() {
		return this.__nativeException;
	}
	,toString: function() {
		return this.get_message();
	}
	,get_message: function() {
		return this.message;
	}
	,get_native: function() {
		return this.__nativeException;
	}
});
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	unwrap: function() {
		return this.value;
	}
});
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
var haxe_exceptions_PosException = function(message,previous,pos) {
	haxe_Exception.call(this,message,previous);
	if(pos == null) {
		this.posInfos = { fileName : "(unknown)", lineNumber : 0, className : "(unknown)", methodName : "(unknown)"};
	} else {
		this.posInfos = pos;
	}
};
haxe_exceptions_PosException.__name__ = true;
haxe_exceptions_PosException.__super__ = haxe_Exception;
haxe_exceptions_PosException.prototype = $extend(haxe_Exception.prototype,{
	toString: function() {
		return "" + haxe_Exception.prototype.toString.call(this) + " in " + this.posInfos.className + "." + this.posInfos.methodName + " at " + this.posInfos.fileName + ":" + this.posInfos.lineNumber;
	}
});
var haxe_exceptions_NotImplementedException = function(message,previous,pos) {
	if(message == null) {
		message = "Not implemented";
	}
	haxe_exceptions_PosException.call(this,message,previous,pos);
};
haxe_exceptions_NotImplementedException.__name__ = true;
haxe_exceptions_NotImplementedException.__super__ = haxe_exceptions_PosException;
haxe_exceptions_NotImplementedException.prototype = $extend(haxe_exceptions_PosException.prototype,{
});
var haxe_io_Bytes = function(data) {
	this.length = data.byteLength;
	this.b = new Uint8Array(data);
	this.b.bufferValue = data;
	data.hxBytes = this;
	data.bytes = this.b;
};
haxe_io_Bytes.__name__ = true;
haxe_io_Bytes.ofData = function(b) {
	var hb = b.hxBytes;
	if(hb != null) {
		return hb;
	}
	return new haxe_io_Bytes(b);
};
haxe_io_Bytes.prototype = {
	getString: function(pos,len,encoding) {
		if(pos < 0 || len < 0 || pos + len > this.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		if(encoding == null) {
			encoding = haxe_io_Encoding.UTF8;
		}
		var s = "";
		var b = this.b;
		var i = pos;
		var max = pos + len;
		switch(encoding._hx_index) {
		case 0:
			while(i < max) {
				var c = b[i++];
				if(c < 128) {
					if(c == 0) {
						break;
					}
					s += String.fromCodePoint(c);
				} else if(c < 224) {
					var code = (c & 63) << 6 | b[i++] & 127;
					s += String.fromCodePoint(code);
				} else if(c < 240) {
					var code1 = (c & 31) << 12 | (b[i++] & 127) << 6 | b[i++] & 127;
					s += String.fromCodePoint(code1);
				} else {
					var u = (c & 15) << 18 | (b[i++] & 127) << 12 | (b[i++] & 127) << 6 | b[i++] & 127;
					s += String.fromCodePoint(u);
				}
			}
			break;
		case 1:
			while(i < max) {
				var c = b[i++] | b[i++] << 8;
				s += String.fromCodePoint(c);
			}
			break;
		}
		return s;
	}
	,toString: function() {
		return this.getString(0,this.length);
	}
};
var haxe_io_Input = function() { };
haxe_io_Input.__name__ = true;
haxe_io_Input.prototype = {
	readByte: function() {
		throw new haxe_exceptions_NotImplementedException(null,null,{ fileName : "haxe/io/Input.hx", lineNumber : 53, className : "haxe.io.Input", methodName : "readByte"});
	}
	,readBytes: function(s,pos,len) {
		var k = len;
		var b = s.b;
		if(pos < 0 || len < 0 || pos + len > s.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		try {
			while(k > 0) {
				b[pos] = this.readByte();
				++pos;
				--k;
			}
		} catch( _g ) {
			if(!((haxe_Exception.caught(_g).unwrap()) instanceof haxe_io_Eof)) {
				throw _g;
			}
		}
		return len - k;
	}
	,readFullBytes: function(s,pos,len) {
		while(len > 0) {
			var k = this.readBytes(s,pos,len);
			if(k == 0) {
				throw haxe_Exception.thrown(haxe_io_Error.Blocked);
			}
			pos += k;
			len -= k;
		}
	}
	,read: function(nbytes) {
		var s = new haxe_io_Bytes(new ArrayBuffer(nbytes));
		var p = 0;
		while(nbytes > 0) {
			var k = this.readBytes(s,p,nbytes);
			if(k == 0) {
				throw haxe_Exception.thrown(haxe_io_Error.Blocked);
			}
			p += k;
			nbytes -= k;
		}
		return s;
	}
	,readInt32: function() {
		var ch1 = this.readByte();
		var ch2 = this.readByte();
		var ch3 = this.readByte();
		var ch4 = this.readByte();
		if(this.bigEndian) {
			return ch4 | ch3 << 8 | ch2 << 16 | ch1 << 24;
		} else {
			return ch1 | ch2 << 8 | ch3 << 16 | ch4 << 24;
		}
	}
	,readString: function(len,encoding) {
		var b = new haxe_io_Bytes(new ArrayBuffer(len));
		this.readFullBytes(b,0,len);
		return b.getString(0,len,encoding);
	}
};
var haxe_io_BytesInput = function(b,pos,len) {
	if(pos == null) {
		pos = 0;
	}
	if(len == null) {
		len = b.length - pos;
	}
	if(pos < 0 || len < 0 || pos + len > b.length) {
		throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
	}
	this.b = b.b;
	this.pos = pos;
	this.len = len;
	this.totlen = len;
};
haxe_io_BytesInput.__name__ = true;
haxe_io_BytesInput.__super__ = haxe_io_Input;
haxe_io_BytesInput.prototype = $extend(haxe_io_Input.prototype,{
	readByte: function() {
		if(this.len == 0) {
			throw haxe_Exception.thrown(new haxe_io_Eof());
		}
		this.len--;
		return this.b[this.pos++];
	}
	,readBytes: function(buf,pos,len) {
		if(pos < 0 || len < 0 || pos + len > buf.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		if(this.len == 0 && len > 0) {
			throw haxe_Exception.thrown(new haxe_io_Eof());
		}
		if(this.len < len) {
			len = this.len;
		}
		var b1 = this.b;
		var b2 = buf.b;
		var _g = 0;
		var _g1 = len;
		while(_g < _g1) {
			var i = _g++;
			b2[pos + i] = b1[this.pos + i];
		}
		this.pos += len;
		this.len -= len;
		return len;
	}
});
var haxe_io_Encoding = $hxEnums["haxe.io.Encoding"] = { __ename__:true,__constructs__:null
	,UTF8: {_hx_name:"UTF8",_hx_index:0,__enum__:"haxe.io.Encoding",toString:$estr}
	,RawNative: {_hx_name:"RawNative",_hx_index:1,__enum__:"haxe.io.Encoding",toString:$estr}
};
haxe_io_Encoding.__constructs__ = [haxe_io_Encoding.UTF8,haxe_io_Encoding.RawNative];
var haxe_io_Eof = function() {
};
haxe_io_Eof.__name__ = true;
haxe_io_Eof.prototype = {
	toString: function() {
		return "Eof";
	}
};
var haxe_io_Error = $hxEnums["haxe.io.Error"] = { __ename__:true,__constructs__:null
	,Blocked: {_hx_name:"Blocked",_hx_index:0,__enum__:"haxe.io.Error",toString:$estr}
	,Overflow: {_hx_name:"Overflow",_hx_index:1,__enum__:"haxe.io.Error",toString:$estr}
	,OutsideBounds: {_hx_name:"OutsideBounds",_hx_index:2,__enum__:"haxe.io.Error",toString:$estr}
	,Custom: ($_=function(e) { return {_hx_index:3,e:e,__enum__:"haxe.io.Error",toString:$estr}; },$_._hx_name="Custom",$_.__params__ = ["e"],$_)
};
haxe_io_Error.__constructs__ = [haxe_io_Error.Blocked,haxe_io_Error.Overflow,haxe_io_Error.OutsideBounds,haxe_io_Error.Custom];
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = true;
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var con = e.__constructs__[o._hx_index];
			var n = con._hx_name;
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
if( String.fromCodePoint == null ) String.fromCodePoint = function(c) { return c < 0x10000 ? String.fromCharCode(c) : String.fromCharCode((c>>10)+0xD7C0)+String.fromCharCode((c&0x3FF)+0xDC00); }
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
format_vox_VoxTools.TranslationKey = "_t";
format_vox_VoxTools.RotationKey = "_r";
})({});
var format = $hx_exports["format"];
