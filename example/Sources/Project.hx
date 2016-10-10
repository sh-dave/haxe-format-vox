package;

class Project {
	public function new() {
		kha.System.notifyOnRender(render);
		kha.Scheduler.addTimeTask(update, 0, 1 / 60);

		setup();
	}

	function setup() {
		var v = new format.vox.Reader(new haxe.io.BytesInput(kha.Assets.blobs._3x3x3_vox.bytes)).read();
	}

	function update() {		
	}

	function render( fb : kha.Framebuffer ) {		
	}
}
