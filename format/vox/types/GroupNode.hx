package format.vox.types;

@:structInit
class GroupNode implements Node {
	public var attributes: Dict;
	public var children: Array<Int>;
}
