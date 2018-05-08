package format.vox;

import format.vox.types.*;

typedef Translation = {
	x: Float,
	y: Float,
	z: Float,
}

typedef Rotation = {
	_00: Float, _10: Float, _20: Float, // , 0
	_01: Float, _11: Float, _21: Float, // , 0
	_02: Float, _12: Float, _22: Float, // , 0
	// 0, 0, 0, 1
}

@:expose @:keep
class VoxTools {
	public static function transformYZ( vox: Vox ) {
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

	static inline var TranslationKey = '_t';

	public static function dictHasTranslation( d: Dict ) : Bool
		return d.get(TranslationKey) != null;

	public static function getTranslationFromDict( d: Dict ) : Translation {
		var t = d.get(TranslationKey);

		if (t == null) {
			return { x: 0, y: 0, z: 0 }
		}

		var split = t.split(' ');
		var x = Std.parseInt(split[0]);
		var y = Std.parseInt(split[1]);
		var z = Std.parseInt(split[2]);

		return { x: x, y: y, z: z }
	}

	static inline var RotationKey = '_r';

	public static function dictHasRotation( d: Dict ) : Bool
		return d.get(RotationKey) != null;

	public static function getRotationFromDict( d: Dict ) : Rotation {
		var r = d.get(RotationKey);

		if (r == null) {
			return {
				_00: 1, _10: 0, _20: 0,
				_01: 0, _11: 1, _21: 0,
				_02: 0, _12: 0, _22: 1,
			}
		}

		var value: RotationBits = Std.parseInt(r);

		var s0 = value.sign0;
		var s1 = value.sign1;
		var s2 = value.sign2;
		var r0 = value.r0;
		var r1 = value.r1;
		var r2 = switch [r0, r1] {
			case [0, 1]: 2;
			case [1, 0]: 2;
			case [0, 2]: 1;
			case [2, 0]: 1;
			case [1, 2]: 0;
			case [2, 1]: 0;
			case _: trace('missing r0;r1 match'); 0;
		}
		
		return {
			_00: r0 == 0 ? s0 : 0, _10: r0 == 1 ? s0 : 0, _20: r0 == 2 ? s0 : 0,
			_01: r1 == 0 ? s1 : 0, _11: r1 == 1 ? s1 : 0, _21: r1 == 2 ? s1 : 0,
			_02: r2 == 0 ? s2 : 0, _12: r2 == 1 ? s2 : 0, _22: r2 == 2 ? s2 : 0,
		}
	}
}
