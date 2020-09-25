package format.vox.types;

class Vox {
	public var sizes: Array<Size> = [];
	public var models: Array<Array<Voxel>> = [];
	public var palette: Array<Color>;
	public var materials: Array<Dict> = [];

	// public var nodeData: Array<NodeData> = [];
	public var nodeGraph: Node;

	public function new() {
	}
}
