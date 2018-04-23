package format.vox.types;

abstract Rotation(Int) from Int {
	public inline function new( r: Int )
		this = r;

	public var r0(get, never): Int;
	public var r1(get, never): Int;
	// public var i2(get, never): Int;

	public var sign0(get, never): Int;
	public var sign1(get, never): Int;
	public var sign2(get, never): Int;

	/*inline*/ function get_r0() : Int {
		var a = (this & 1 << 0);
		var b = (this & 1 << 1);
		return a + b;
	}

	/*inline*/ function get_r1() : Int {
		var a = (this >> 2 & 1 << 0);
		var b = (this >> 2 & 1 << 1);
		return a + b;
	}

	inline function get_sign0() : Int
		return this & (1 << 4) == 0 ? 1 : -1;

	inline function get_sign1() : Int
		return this & (1 << 5) == 0 ? 1 : -1;

	inline function get_sign2() : Int
		return this & (1 << 6) == 0 ? 1 : -1;
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
