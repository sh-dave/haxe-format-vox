package format.vox.types;

abstract RotationBits(Int) from Int {
	public inline function new( r: Int )
		this = r;

	public var r0(get, never): Int;
	public var r1(get, never): Int;

	public var sign0(get, never): Int;
	public var sign1(get, never): Int;
	public var sign2(get, never): Int;

	inline function get_r0() : Int {
		var a = (this & 1 << 0);
		var b = (this & 1 << 1);
		return a + b;
	}

	inline function get_r1() : Int {
		var a = (this >> 2 & 1 << 0);
		var b = (this >> 2 & 1 << 1);
		return a + b;
	}

	inline function get_sign0() : Int {
		return this & (1 << 4) == 0 ? 1 : -1;
	}

	inline function get_sign1() : Int {
		return this & (1 << 5) == 0 ? 1 : -1;
	}

	inline function get_sign2() : Int {
		return this & (1 << 6) == 0 ? 1 : -1;
	}
}
