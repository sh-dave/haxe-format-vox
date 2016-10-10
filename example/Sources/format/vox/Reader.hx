package format.vox;

import haxe.io.Bytes;
import haxe.io.Input;

class Voxel {
	public var x : Int;
	public var y : Int;
	public var z : Int;
	public var colorIndex : Int;
}

class Color {
	public var r : Int;
	public var g : Int;
	public var b : Int;
	public var a : Int;
}

enum Chunk {
	Size( x : Int, y : Int, z : Int );
	Voxel( v : Array<Voxel> );
	Palette( c : Array<Color> );
}

class Vox {
	public var chunks : Array<Chunk> = [];

	public function new() {		
	}
}

class Reader {
	var i : Input;

	public function new( i : Input ) {
		this.i = i;
	}

	static inline var VoxTag = 'VOX ';
	static inline var MainTag = 'MAIN';
	static inline var SizeTag = 'SIZE';
	static inline var VoxelTag = 'XYZI';
	static inline var PaletteTag = 'RGBA'; // 256x4 rgba

	public function read() : Vox {
		var vox = new Vox();

		if (i.readString(4) != VoxTag) throw '"VOX " expected';
		if (i.read(4).getInt32(0) != 150) throw 'unsupported version';

		while (true) {
			var tag = i.readString(4);
			trace('tag = "${tag}"');
			var contentSize = i.readInt32();
			trace('content size = "${contentSize}"');

			switch (tag) {
				case SizeTag:
					vox.chunks.push(Chunk.Size(
						i.readInt32(),
						i.readInt32(),
						i.readInt32()
					));
				case PaletteTag:
					vox.chunks.push([
						for (i in 0...256) 
					]);
			}

			var childCount = i.read(4).getInt32(0);
			trace('children = "${childCount}"');

			var contentBytes = i.read(contentSize);
		}

		return vox;
	}
}
