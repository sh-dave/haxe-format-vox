package;

import format.vox.Data;

class ExampleG2 {
	var dx : Int;
	var dy : Int;
	var dz : Int;
	var palette : Array<Color>;
	var voxels : Array<Voxel>;

	public function new() {
		kha.System.notifyOnRender(render2d);
		setupModel();
	}

	function setupModel() {
		// var vox = new format.vox.Reader(new BlobInput(kha.Assets.blobs._3x3x3_vox)).read();
		// var vox = new format.vox.Reader(new BlobInput(kha.Assets.blobs.doom_vox)).read();
		var vox = new format.vox.Reader(new BlobInput(kha.Assets.blobs.chr_sword_vox)).read();
		// var vox = new format.vox.Reader(new BlobInput(kha.Assets.blobs.chr_knight_vox)).read();

		for (chunk in vox) {
			switch (chunk) {
				case Chunk.Dimensions(x, y, z):
					dx = x;
					dy = y;
					dz = y;
				case Chunk.Geometry(v): voxels = v;
				case Chunk.Palette(p): palette = p;
			}
		}

		format.vox.Tools.fixZ_2d(vox);

		voxels.sort(function( a, b ) return b.y - a.y);

		if (palette == null) {
			palette = format.vox.Tools.defaultPalette;
		}
	}

	function render2d( fb : kha.Framebuffer ) {
		var f2 = fb.g2;
		var vs = 8;

		f2.begin(true);
			for (v in voxels) {
				var c = palette[v.colorIndex - 1];
				f2.color = kha.Color.fromBytes(c.r, c.g, c.b, c.a);
				f2.fillRect(v.x * vs, v.z * vs, vs, vs);
			}
		f2.end();
	}

}
