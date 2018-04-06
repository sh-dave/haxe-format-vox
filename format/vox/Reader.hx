package format.vox;

import format.vox.Data;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;

class Reader {
	var input: Input;

	public function new( bytes: Bytes )
		this.input = bytes == null ? null : new BytesInput(bytes);

	public function read() : Null<Vox> {
		if (input == null) {
			trace('no valid input');
			return null;
		}

		if (input.readString(4) != VoxMagic) {
			trace('"VOX " expected');
			return null;
		}

		if (i32(input) != 150) {
			trace('unsupported version');
			return null;
		}

		var vox = new Array<Chunk>();
		readChunk(input, vox);
		return vox;
	}

	static function readChunk( input: Input, vox: Vox ) : Int {
		var chunkId = input.readString(4);
		#if debug trace('chunk id = "${chunkId}"'); #end
		var contentSize = i32(input);
		#if debug trace('content size = "${contentSize}"'); #end
		var childBytes  = i32(input);
		#if debug trace('child bytes = "${childBytes}"'); #end

		switch chunkId {
			case MainChunkId:
			case SizeChunkId:
				vox.push(Chunk.Dimensions(i32(input), i32(input), i32(input)));
			case GeometryChunkId:
				vox.push(Chunk.Geometry([for (c in 0...i32(input)) readVoxel(input)]));
			case PaletteChunkId:
				vox.push(Chunk.Palette([for (c in 0...256) readColor(input)]));
			default:
				trace('skipping unsupported chunk "${chunkId}"');
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

	static inline var VoxMagic = 'VOX ';

	static inline var MainChunkId = 'MAIN';
	static inline var SizeChunkId = 'SIZE';
	static inline var GeometryChunkId = 'XYZI';
	static inline var PaletteChunkId = 'RGBA';
}
