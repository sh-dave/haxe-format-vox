package;

import format.vox.Data;

import kha.graphics4.ConstantLocation;
import kha.math.FastMatrix4;
import kha.math.FastVector3;

import zui.Id;
import zui.Zui;

class ExampleG4 {
	var cameraDistance = 40.0;
	var cameraPitch = Math.PI;
	var cameraRoll = 0.0;

	var tx = 0;
	var ty = 0;
	var tz = 0;

	var mouseDown = false;
	var mdx = 0.0;
	var mdy = 0.0;
	var mx = 0.0;
	var my = 0.0;

	var vs : kha.graphics4.VertexStructure;
	var vb : kha.graphics4.VertexBuffer;
	var ib : kha.graphics4.IndexBuffer;
	var pipe : kha.graphics4.PipelineState;

	var normalId : ConstantLocation;
	var mvId : ConstantLocation;
	var pId : ConstantLocation;

	var model : FastMatrix4;
	var view : FastMatrix4;
	var projection : FastMatrix4;

	var z : Zui;

	public function new() {
		kha.System.notifyOnRender(render3d);
		kha.Scheduler.addTimeTask(update, 0, 1 / 60);

		setupInput();
		setup3d();

		z = new Zui(kha.Assets.fonts.DroidSansMono, 16, 16);
	}

	function setupModel( file : String ) {
		var blob = Reflect.field(kha.Assets.blobs, file);
		var vox = new format.vox.Reader(new BlobInput(blob)).read();

		var voxData = new VoxLoader(vox);
		var vertices = voxData.data;

		var vl = vertices.length;

		vb = new kha.graphics4.VertexBuffer(vertices.length, vs, kha.graphics4.Usage.StaticUsage);
		var vbd = vb.lock();
			for (i in 0...vertices.length) vbd.set(i, vertices[i]);
		vb.unlock();

		var indices = voxData.indices;
		ib = new kha.graphics4.IndexBuffer(indices.length, kha.graphics4.Usage.StaticUsage);
		var ibd = ib.lock();
			for (i in 0...indices.length) ibd[i] = indices[i];
		ib.unlock();

		tx = voxData.dx;
		ty = voxData.dy;
		tz = voxData.dz;
	}

	function update() {
		if (mouseDown) {
			cameraPitch += mdx * -0.005;
			cameraRoll += mdy * -0.005;
			
			var p2 = Math.PI / 2;

			 if (cameraRoll < -p2) {
			 	cameraRoll = -p2;
			 }

			 if (cameraRoll > p2) {
			 	cameraRoll = p2;
			 }
		}

		var target = new FastVector3(tx / 2, ty * 0.25, tz / 2);
		var up = new FastVector3(0, 1, 0);  
		var eye = new FastVector3(
			Math.cos(cameraRoll) * Math.sin(cameraPitch),
			Math.sin(cameraRoll),
			Math.cos(cameraRoll) * Math.cos(cameraPitch)
		);

		eye.normalize();
		eye = eye.mult(cameraDistance);
		eye = target.sub(eye);

		view = FastMatrix4.lookAt(
			eye,
			target,
			up
		);

		mdx = 0;
		mdy = 0;
	}

	function setupInput() kha.input.Mouse.get().notify(mouse_downHandler, mouse_upHandler, mouse_moveHandler, mouse_wheelHandler);
	function mouse_downHandler( b : Int, x : Int, y : Int ) mouseDown = true;
	function mouse_upHandler( b : Int, x : Int, y : Int ) mouseDown = false;

	function mouse_moveHandler( x : Int, y : Int, mx : Int, my : Int ) {
		mdx = x - this.mx;
		mdy = y - this.my;

		this.mx = x;
		this.my = y;
	}

	function mouse_wheelHandler( delta : Int ) {
		if (delta < 0) {
			cameraDistance -= 1;
		} else if (delta > 0) {
			cameraDistance += 1;
		}
	}

	function setup3d() {
		projection = FastMatrix4.perspectiveProjection(Math.PI / 4, 4 / 3, 0.1, 1000);
		model = FastMatrix4.identity();

		vs = new kha.graphics4.VertexStructure();
		vs.add('aVertexPosition', kha.graphics4.VertexData.Float3);
		vs.add('aVertexColor', kha.graphics4.VertexData.Float3);
		vs.add('aVertexNormal', kha.graphics4.VertexData.Float3);

		pipe = new kha.graphics4.PipelineState();
		pipe.inputLayout = [vs];
		pipe.vertexShader = kha.Shaders.simple_vert;
		pipe.fragmentShader = kha.Shaders.simple_frag;
		pipe.depthWrite = true;
		pipe.depthMode = kha.graphics4.CompareMode.Less;
		pipe.cullMode = kha.graphics4.CullMode.None;
		pipe.compile();

		normalId = pipe.getConstantLocation('uNormalMatrix');
		mvId = pipe.getConstantLocation('uMVMatrix');
		pId = pipe.getConstantLocation('uPMatrix');
	}

	function render3d( fb : kha.Framebuffer ) {
		var f4 = fb.g4;

		if (vb != null) {
			var mv = FastMatrix4.identity()
				.multmat(view)
				.multmat(model);

			var normal = mv.inverse().transpose();

			f4.begin();
				f4.clear(kha.Color.Black, 1.0, 0);
				f4.setPipeline(pipe);

				f4.setMatrix(mvId, mv);
				f4.setMatrix(pId, projection);
				f4.setMatrix(normalId, normal);

				f4.setVertexBuffer(vb);
				f4.setIndexBuffer(ib);
				f4.drawIndexedVertices();
			f4.end();
		}
		
		var f2 = fb.g2;

		f2.begin(false);
			z.begin(f2);
				if (z.window(Id.window(), 4, 4, 256, kha.System.windowHeight())) {
					if (z.node(Id.node(), 'MODELS', true)) {
						if (kha.Assets.blobs.names != null) {
							for (m in kha.Assets.blobs.names) {
								if (z.button(m.toUpperCase())) {
									setupModel(m);
								}
							}
						}
					}
				}
			z.end();
		f2.end();
	}
}
