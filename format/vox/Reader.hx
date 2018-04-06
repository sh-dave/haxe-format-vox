package format.vox;

import format.vox.Data;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;

class Reader {
	var input: Input;

	public function new( bytes: Bytes )
		this.input = new BytesInput(bytes);

	public function read() : Vox {
		if (input.readString(4) != VoxTag) {
			throw '"VOX " expected';
		}

		if (i32(input) != 150) {
			throw 'unsupported version';
		}

		var vox = new Array<Chunk>();
		readChunk(input, vox);
		return vox;
	}

	static function readChunk( input: Input, vox: Vox ) : Int {
		var tag = input.readString(4);
		#if debug trace('tag = "${tag}"'); #end
		var contentSize = i32(input);
		#if debug trace('content size = "${contentSize}"'); #end
		var childBytes  = i32(input);
		#if debug trace('child bytes = "${childBytes}"'); #end

		switch tag {
			case MainTag:
			case SizeTag:
				vox.push(Chunk.Dimensions(i32(input), i32(input), i32(input)));
			case VoxelTag:
				vox.push(Chunk.Geometry([for (c in 0...i32(input)) readVoxel(input)]));
			case PaletteTag:
				vox.push(Chunk.Palette([for (c in 0...256) readColor(input)]));
			default:
				trace('skipping unsupported tag "${tag}"');
				input.read(contentSize);
		}

		var chunkSize = 4 + 4 + 4 + contentSize + childBytes;

		while (childBytes > 0) {
			childBytes -= readChunk(input, vox);
		}

		return chunkSize;
	}

	static inline function readColor( input: Input ) : Color
		return { r: byte(input), g: byte(input), b: byte(input), a: byte(input) }

	static inline function readVoxel( input: Input ) : Voxel
		return { x: byte(input), y: byte(input), z: byte(input), colorIndex: byte(input) }

	static inline function i32( input: Input ) : Int
		return input.readInt32();

	static inline function byte( input: Input ) : Int
		return input.readByte();

	static inline var VoxTag = 'VOX ';
	static inline var MainTag = 'MAIN';
	static inline var SizeTag = 'SIZE';
	static inline var VoxelTag = 'XYZI';
	static inline var PaletteTag = 'RGBA';
}
