package format.vox.types;

@:structInit
class TransformNode implements Node {
	public var attributes: Dict;
	public var childNodeId: Int;
	public var reserved: Int;
	public var layerId: Int;
	// public var numFrames: Int;
	public var frames: Array<Frame>;
}
