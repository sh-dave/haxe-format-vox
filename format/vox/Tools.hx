package format.vox;

import format.vox.Data;

class Tools {
	public static function fixZ_3d( vox: Vox ) {
		var dz = 0;
		var dy = 0;

		for (chunk in vox) {
			switch chunk {
				case Chunk.Dimensions(x, y, z):
					dz = z;
					dy = y;
				case Chunk.Geometry(voxels):
					for (v in voxels) {
						var y = v.y;
						var z = v.z;
						v.y = z;
						v.z = dy - 1 - y;
					}
				case Chunk.Palette(_):
			}
		}
	}

	public static function transformColor( color: Int ) : Color return {
		r : color & 0xff,
		g : (color >> 8) & 0xff,
		b : (color >> 16) & 0xff,
		a : (color >> 24) & 0xff,
	}
}
