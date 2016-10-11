# haxe-format-vox

```haxe
import format.vox.Data;

var vox = new format.vox.Reader('...something based on haxe.io.Input...').read();

for (chunk in vox) {
  switch (chunk) {
    case Chunk.Size(x, y, z): // object dimensions: int, int, int
    case Chunk.Palette(p): // custom palette (Array<Color>) or null 
    case Chunk.Geometry(v): // voxel data (Array<Voxel>)
  }
}
```

## [HTML5 Demo](https://sh-dave.github.io/haxe-format-vox)
