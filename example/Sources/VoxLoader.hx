package;

import format.vox.Data;

class VoxLoader {
	public var data : Array<Float> = [];
	public var indices : Array<Int> = [];
	public var dx = 0;
	public var dy = 0;
	public var dz = 0;

	public function new( vox : Vox ) {
		build(vox);
	}

	function build( vox : Vox ) {
		// Cube.create(0, 0, 0, 1, 1, 1, data, indices);
		// Cube.create(2, 0, 0, 1, 0, 0, data, indices);
		// Cube.create(0, 2, 0, 0, 1, 0, data, indices);
		// Cube.create(0, 0, 2, 0, 0, 1, data, indices);

		var palette : Array<Color> = null;
		var voxels : Array<Voxel> = null;

		for (chunk in vox) {
			switch (chunk) {
				case Chunk.Size(x, y, z):
					dx = x;
					dy = z;
					dz = y;
				case Chunk.Palette(p): palette = p;
				case Chunk.Voxel(v): voxels = v;
			}
		}

		format.vox.Tools.fixZ_3d(vox);
		
		if (palette == null) {
			palette = format.vox.Tools.defaultPalette; 
		}

		for (v in voxels) {
			var c = palette[v.colorIndex - 1];
			Cube.create(v.x, v.y, v.z, c.r / 255, c.g / 255, c.b / 255, data, indices);
		}
	}
}

private class Cube {
	public static function create( x : Float, y : Float, z : Float, r : Float, g : Float, b : Float, vd : Array<Float>, id : Array<Int> ) {
		var is = id.length;

		for (i in 0...36) {
			vd.push(vertices[i * 3 + 0] + x);
			vd.push(vertices[i * 3 + 1] + y);
			vd.push(vertices[i * 3 + 2] + z);
			vd.push(r);
			vd.push(g);
			vd.push(b);
			vd.push(normals[i * 3 + 0]);
			vd.push(normals[i * 3 + 1]);
			vd.push(normals[i * 3 + 2]);
			
			id.push(is + indices[i]);
		}
	}

	static var indices = [
		0,  1,  2,      0,  2,  3,    // front
		4,  5,  6,      4,  6,  7,    // back
		8,  9,  10,     8,  10, 11,   // top
		12, 13, 14,     12, 14, 15,   // bottom
		16, 17, 18,     16, 18, 19,   // right
		20, 21, 22,     20, 22, 23    // left
	];

	static var vertices = [
		// Front face
		-0.5, -0.5,  0.5,
		0.5, -0.5,  0.5,
		0.5,  0.5,  0.5,
		-0.5,  0.5,  0.5,
		
		// Back face
		-0.5, -0.5, -0.5,
		-0.5,  0.5, -0.5,
		0.5,  0.5, -0.5,
		0.5, -0.5, -0.5,
		
		// Top face
		-0.5,  0.5, -0.5,
		-0.5,  0.5,  0.5,
		0.5,  0.5,  0.5,
		0.5,  0.5, -0.5,
		
		// Bottom face
		-0.5, -0.5, -0.5,
		0.5, -0.5, -0.5,
		0.5, -0.5,  0.5,
		-0.5, -0.5,  0.5,
		
		// Right face
		0.5, -0.5, -0.5,
		0.5,  0.5, -0.5,
		0.5,  0.5,  0.5,
		0.5, -0.5,  0.5,
		
		// Left face
		-0.5, -0.5, -0.5,
		-0.5, -0.5,  0.5,
		-0.5,  0.5,  0.5,
		-0.5,  0.5, -0.5
	];

	static var uvs = [
		// Front
		0.0,  0.0,
		1.0,  0.0,
		1.0,  1.0,
		0.0,  1.0,

		// Back
		0.0,  0.0,
		1.0,  0.0,
		1.0,  1.0,
		0.0,  1.0,

		// Top
		0.0,  0.0,
		1.0,  0.0,
		1.0,  1.0,
		0.0,  1.0,

		// Bottom
		0.0,  0.0,
		1.0,  0.0,
		1.0,  1.0,
		0.0,  1.0,

		// Right
		0.0,  0.0,
		1.0,  0.0,
		1.0,  1.0,
		0.0,  1.0,

		// Left
		0.0,  0.0,
		1.0,  0.0,
		1.0,  1.0,
		0.0,  1.0
	];

	static var normals : Array<Float> = [
		// Front
		0.0,  0.0,  1.0,
		0.0,  0.0,  1.0,
		0.0,  0.0,  1.0,
		0.0,  0.0,  1.0,
		
		// Back
		0.0,  0.0, -1.0,
		0.0,  0.0, -1.0,
		0.0,  0.0, -1.0,
		0.0,  0.0, -1.0,
		
		// Top
		0.0,  1.0,  0.0,
		0.0,  1.0,  0.0,
		0.0,  1.0,  0.0,
		0.0,  1.0,  0.0,
		
		// Bottom
		0.0, -1.0,  0.0,
		0.0, -1.0,  0.0,
		0.0, -1.0,  0.0,
		0.0, -1.0,  0.0,
		
		// Right
		1.0,  0.0,  0.0,
		1.0,  0.0,  0.0,
		1.0,  0.0,  0.0,
		1.0,  0.0,  0.0,
		
		// Left
		-1.0,  0.0,  0.0,
		-1.0,  0.0,  0.0,
		-1.0,  0.0,  0.0,
		-1.0,  0.0,  0.0
	];	
}
