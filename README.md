# haxe-format-vox

A reader for [MagicaVoxels](https://ephtracy.github.io)'s vox files.

```haxe
var vox = new format.vox.VoxReader('...something based on haxe.io.Input...').read();
// vox.models to get the meshes
// vox.nodeGraph to access to worldbuilder nodes
```

# examples

- code moved to https://github.com/sh-dave/haxe-format-vox-examples
- [online html5 demo](https://sh-dave.github.io/haxe-format-vox)

# js library build instructions

```shell
npm install
npx haxe build-js.hxml
```
