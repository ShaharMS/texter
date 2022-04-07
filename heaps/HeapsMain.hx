import hxd.Res;
import h2d.TextInput;

class HeapsMain extends hxd.App
{
	override function init()
	{
		var tf = new h2d.TextInput(hxd.res.DefaultFont.get(), s2d);
		tf.text = "Hello World!";
		tf.maxWidth = 300;
		tf.onTextInput = function(text)
		{
			trace("TextInput: " + text);
		};
	}

	static function main()
	{
		new HeapsMain();
	}
}