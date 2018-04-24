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

		var value: Rotation = Std.parseInt(r);
		var result = { x: 0.0, y: 0.0, z: 0.0 }

		var r0 = value.r0;
		var r1 = value.r1;
		var s0 = value.sign0;
		var s1 = value.sign1;
		var s2 = value.sign2;

		result.x = switch s0 {
			case 0: d2r(90);
			case 1: d2r(-90);
			case _: 0;
		}

		result.y = switch s1 {
			case 0: d2r(90);
			case 1: d2r(-90);
			case _: 0;
		}

		result.z = switch s2 {
			case 0: d2r(90);
			case 1: d2r(-90);
			case _: 0;
		}

		trace('$r0 $r1 $s0 $s1 $s2');

		return result;
	}

	static inline function d2r( d: Float ) : Float
		return d * Math.PI / 180.0;
}


// 20 -> 10100

// (c) ROTATION type

// store row-major rotation in bits of bytes

// 0 0 -1 1 0 0 0 -1 0

// for example :
// R =
//  0  1  0
//  0  0 -1
// -1  0  0
// ==>
// unsigned char _r = (1 << 0) | (2 << 2) | (0 << 4) | (1 << 5) | (1 << 6)

// bit | value
// 0-1 : 1 : index of non-zero entry in row 0
// 2-3 : 2 : index of non-zero entry in row 1
// 4   : 0 : sign in row 0 (0 : positive; 1 : negative)
// 5   : 1 : sign in row 1 (0 : positive; 1 : negative)
// 6   : 1 : sign in row 2 (0 : positive; 1 : negative)
