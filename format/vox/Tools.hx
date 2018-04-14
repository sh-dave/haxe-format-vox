package format.vox;

import format.vox.types.*;

class Tools {
	public static function transformCoordinateSystem( vox: Vox ) {
		for (i in 0...vox.models.length) {
			var dy = vox.sizes[i].y;

			for (v in vox.models[i]) {
				var y = v.y;
				var z = v.z;
				v.y = z;
				v.z = dy - 1 - y;
			}
		}
	}

	public static function transformColor( color: Int ) : Color return {
		r : color & 0xff,
		g : (color >> 8) & 0xff,
		b : (color >> 16) & 0xff,
		a : (color >> 24) & 0xff,
	}

	public static function getTranslationFromDict( d: Dict, key: String /*= '_t'*/ ) : { x: Float, y: Float, z: Float } {
		var t = d.get(key);

		if (t == null) {
			return { x: 0, y: 0, z: 0 }
		}

		var split = t.split(' ');
		var x = Std.parseInt(split[0]);
		var y = Std.parseInt(split[1]);
		var z = Std.parseInt(split[2]);

		return { x: x, y: y, z: z }
	}

	public static function getRotationFromDict( d: Dict, key: String /*= '_r'*/ ) : { x: Float, y: Float, z: Float } {
		// TODO (DK) implement me
		return { x: 0, y: 0, z: 0 }
	}
}
