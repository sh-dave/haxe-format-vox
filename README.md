# haxe-format-vox

A reader for [MagicaVoxels](https://ephtracy.github.io)'s VOX files. Reads most of the v0.99 chunks including the world builder nodes.

- [x] PACK - skipped / unused
- [x] SIZE
- [x] XYZI
- [x] RGBA
- [x] MATT - skipped / unused
- [X] MATL
- [x] nTRN
- [x] nSHP
- [x] nGRP
- [ ] rOBJ - [missing specs](https://github.com/ephtracy/voxel-model/issues/19)
- [ ] LAYR - [missing specs](https://github.com/ephtracy/voxel-model/issues/19)

## haxe

### usage in haxe
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

### haxe examples

- old vox viewer - [code](https://github.com/sh-dave/haxe-format-vox-examples) - [html5 demo](https://sh-dave.github.io/haxe-format-vox-examples)
- new vox viewer - [code](https://github.com/sh-dave/vox-viewer)

## javascript

### usage in javascript

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

### javascript examples

- a more complete usage example - [code](https://github.com/sh-dave/haxe-format-vox-examples-js)

## javascript library build instructions

```shell
npm install
npx haxe build-js.hxml
```
