package;

class BlobInput extends haxe.io.Input {
	var blob : kha.Blob;
	var position = 0;

	public function new( blob : kha.Blob ) {
		this.blob = blob;
		if (this.blob == null) throw 'null blob argument';
	}

	override public function readByte() : Int {
		try {
			return blob.readU8(position++);
		} catch (e : Dynamic) {
			throw new haxe.io.Eof();
		}
	}
}
