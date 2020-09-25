package format.vox.types;

enum Node {
	Transform( attributes: Dict, reserved: Int, layerId: Int, frames: Array<Frame>, child: Node );
	Group( attributes: Dict, children: Array<Node> );
	Shape( attributes: Dict, models: Array<Model> );
}

// T -> G / S
// G -> T
