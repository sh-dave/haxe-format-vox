package format.vox;

import format.vox.types.Dict;
import format.vox.types.Model;
import format.vox.types.Node;
import format.vox.types.Vox;

typedef Walker = {
	function beginGraph( vox: Vox ) : Void;
	function endGraph() : Void;

	function beginGroup( att: Dict ) : Void;
	function endGroup() : Void;

	function onTransform( att: Dict ) : Void;
	function onShape( att: Dict, models: Array<Model> ) : Void;
}

@:expose @:keep
class VoxNodeTools {
	public static function walkNodeGraph( vox: Vox, w: Walker ) {
		w.beginGraph(vox);
		nodeWalker(vox.nodeGraph, w);
		w.endGraph();
	}

	static function nodeWalker( node: Node, w: Walker ) {
		return switch node {
			case null: // TODO (DK) just for dummy scenes without node graph, should be removed
				trace('TODO (DK)');
			case Transform(att, res, lyr, frames, child):
				w.onTransform(frames[0]);
				nodeWalker(child, w);
			case Group(att, children):
				w.beginGroup(att);
				for (child in children) {
					nodeWalker(child, w);
				}
				w.endGroup();
			case Shape(att, models):
				w.onShape(att, models);
		}
	}
}