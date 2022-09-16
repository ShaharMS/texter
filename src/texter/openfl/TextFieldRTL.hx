package texter.openfl;

#if openfl
import openfl.text.TextField;

/**
 * `TextFieldRTL` is an "extention" of `TextField` that adds support for right-to-left text.
 */
class TextFieldRTL extends TextField
{
	/**
		Creates a new TextField instance. After you create the TextField instance,
		call the `addChild()` or `addChildAt()` method of
		the parent DisplayObjectContainer object to add the TextField instance to
		the display list.

		The default size for a text field is 100 x 100 pixels.
	**/
	public function new() {
		super();
		BidiTools.attachBidifier(this);
	}
}
#end
