package format.vox;

import format.vox.Data;
import haxe.io.Input;

class Reader {
	public function new( i : Input ) this.i = i;

	public function read() : Vox {
		if (i.readString(4) != VoxTag) throw '"VOX " expected';
		if (i32(i) != 150) throw 'unsupported version';
		var vox : Array<Chunk> = [];
		readChunk(i, vox);
		return vox;
	}

	static function readChunk( i : Input, vox : Vox ) : Int {
		var tag = i.readString(4);
		#if debug trace('tag = "${tag}"'); #end
		var contentSize = i32(i);
		#if debug trace('content size = "${contentSize}"'); #end
		var childBytes  = i32(i);
		#if debug trace('child bytes = "${childBytes}"'); #end

		switch (tag) {
			case MainTag:
			case SizeTag: vox.push(Chunk.Dimensions(i32(i), i32(i), i32(i)));
			case VoxelTag: vox.push(Chunk.Geometry([for (c in 0...i32(i)) readVoxel(i)]));
			case PaletteTag: vox.push(Chunk.Palette([for (c in 0...256) readColor(i)]));
			default: trace('skipping unsupported tag "${tag}"'); i.read(contentSize);
		}

		var chunkSize = 4 + 4 + 4 + contentSize + childBytes;

		while (childBytes > 0) {
			childBytes -= readChunk(i, vox);
		}

		return chunkSize;
	}

	var i : Input;

	static inline function readColor( i : Input ) : Color return { r : b(i), g : b(i), b : b(i), a : b(i) }
	static inline function readVoxel( i : Input ) : Voxel return { x : b(i), y : b(i), z : b(i), colorIndex : b(i) }

	static inline function i32( i ) return i.readInt32();
	static inline function b( i ) return i.readByte();

	static inline var VoxTag = 'VOX ';
	static inline var MainTag = 'MAIN';
	static inline var SizeTag = 'SIZE';
	static inline var VoxelTag = 'XYZI';
	static inline var PaletteTag = 'RGBA';	
}
