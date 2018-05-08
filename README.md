# haxe-format-vox

A reader for [MagicaVoxels](https://ephtracy.github.io)'s vox files. Reads most of the v0.99 chunks.

- [x] PACK - skipped
- [x] SIZE
- [x] XYZI
- [x] RGBA
- [x] MATT - skipped
- [X] MATL
- [x] nTRN
- [x] nSHP
- [x] nGRP
- [ ] rOBJ - [missing specs](https://github.com/ephtracy/voxel-model/issues/19)
- [ ] LAYR - [missing specs](https://github.com/ephtracy/voxel-model/issues/19)

## haxe usage

```haxe
var data: BytesData = ...;
var vox = format.vox.VoxReader.read(data, function( ?vox, ?err ) {
	if (err != null) {
		trace(err);
		return;
	}

	// use vox.models to get the meshes
	// use vox.nodeGraph to access to world builder nodes
});
```

## js usage

```js
const VoxReader = require('@sh-dave/format-vox').VoxReader;
const data = ...some ArrayBuffer...;

var vox = VoxReader.read(data, (vox, err) => {
	if (err) {
		console.error(err);
		return;
	}

	// use vox.models to get the meshes
	// use vox.nodeGraph to access to world builder nodes
});
```

## haxe examples

- https://github.com/sh-dave/haxe-format-vox-examples
- [online html5 demo](https://sh-dave.github.io/haxe-format-vox)

## js examples

- https://github.com/sh-dave/haxe-format-vox-examples-js

## js library build instructions

```shell
npm install
npx haxe build-js.hxml
```
