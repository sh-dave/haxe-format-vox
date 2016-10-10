package format.vox;

import format.vox.Data;
import haxe.io.Input;

class Reader {
	var i : Input;

	public function new( i : Input ) {
		this.i = i;
	}

	static inline var VoxTag = 'VOX ';
	static inline var MainTag = 'MAIN';
	static inline var SizeTag = 'SIZE';
	static inline var VoxelTag = 'XYZI';
	static inline var PaletteTag = 'RGBA';

	public function read() : Vox {
		if (i.readString(4) != VoxTag) throw '"VOX " expected';
		if (i.read(4).getInt32(0) != 150) throw 'unsupported version';
		var vox : Array<Chunk> = [];
		readChunk(i, vox);
		return vox;
	}

	static function readChunk( i : Input, vox : Vox ) : Int {
		var tag = i.readString(4);
		trace('tag = "${tag}"');
		var contentSize = i.readInt32();
		trace('content size = "${contentSize}"');
		var childBytes  = i.readInt32();
		trace('child bytes = "${childBytes}"');

		switch (tag) {
			case MainTag:
			case SizeTag: vox.push(Chunk.Size(i.readInt32(), i.readInt32(), i.readInt32()));
			case VoxelTag: vox.push(Chunk.Voxel([for (c in 0...i.readInt32()) readVoxel(i)]));
			case PaletteTag: vox.push(Chunk.Palette([for (c in 0...256) readColor(i)]));
			default:
				trace('skipping invalid tag "${tag}"'); i.read(contentSize);
		}

		var chunkSize = 4 + 4 + 4 + contentSize + childBytes;

		while (childBytes > 0) {
			childBytes -= readChunk(i, vox);
		}

		return chunkSize;
	}

	static inline function readColor( i : Input ) : Color {
		var color : Color = {
			r : i.readByte(),
			g : i.readByte(),
			b : i.readByte(),
			a : i.readByte(),
		}

		return color;
	}

	static inline function readVoxel( i : Input ) : Voxel {
		var voxel : Voxel = {
			x : i.readByte(),
			y : i.readByte(),
			z : i.readByte(),
			colorIndex : i.readByte(),
		}

		return voxel;
	}
}
