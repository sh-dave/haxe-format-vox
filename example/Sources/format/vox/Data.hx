package format.vox;

@:structInit
class SubTexture {
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;
	@:optional public var frameX : Int;
	@:optional public var frameY : Int;
	@:optional public var frameWidth : Int;
	@:optional public var frameHeight : Int;
	@:optional public var rotated : Bool;
}

@:structInit
class TextureAtlas {
	public var imagePath : String;
	public var width : Int;
	public var height : Int;
	public var subTextures : Map<String, SubTexture>;
}
