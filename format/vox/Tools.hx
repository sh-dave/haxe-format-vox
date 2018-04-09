package format.vox;

import format.vox.types.*;

class Tools {
	public static function transformCoordinateSystem( vox: Vox ) {
		var dy = vox.size.y;

		for (v in vox.voxels) {
			var y = v.y;
			var z = v.z;
			v.y = z;
			v.z = dy - 1 - y;
		}
	}

	public static function transformColor( color: Int ) : Color return {
		r : color & 0xff,
		g : (color >> 8) & 0xff,
		b : (color >> 16) & 0xff,
		a : (color >> 24) & 0xff,
	}
}
