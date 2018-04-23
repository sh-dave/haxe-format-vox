package format.vox;

import format.vox.types.*;

class VoxTools {
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

	// TODO (DK) implement me
	public static function getRotationFromDict( d: Dict, key: String /*= '_r'*/ ) : { x: Float, y: Float, z: Float } {
		var r = d.get(key);

		if (r == null) {
			return { x: 0, y: 0, z: 0 }
		}

		// var test: Int = (1 << 0) | (2 << 2) | (0 << 4) | (1 << 5) | (1 << 6);
		// trace(test);

		var value: Rotation = Std.parseInt(r);
		var result = { x: 0.0, y: 0.0, z: 0.0 }

		var r0 = value.r0;
		var r1 = value.r1;
		var s0 = value.sign0;
		var s1 = value.sign1;
		var s2 = value.sign2;

		#if 0 trace('$r0 $r1 $s0 $s1 $s2'); #end

		return result;
	}
}
