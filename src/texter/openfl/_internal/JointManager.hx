package texter.openfl._internal;

#if openfl
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import texter.openfl.DynamicTextField;
import openfl.geom.Point;
import openfl.events.MouseEvent;

import texter.openfl._internal.JointGraphic.*;

using Math;
class JointManager
{
	public var tf:DynamicTextField;

	public function new(tf:DynamicTextField)
	{
		this.tf = tf;
	}


	var tX:Float;
	var tY:Float;
	var tWidth:Float;
	var tHeight:Float;

	function setPrevStats() {
		tX = tf.x;
		tY = tf.y;
		tWidth = tf.textFieldWidth;
		tHeight = tf.textFieldHeight;
	}

	public function startResizeTopLeft(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.textFieldWidth, // gutter
			h: tf.textFieldHeight// gutter
		};
		setPrevStats();

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);

				tf.onResized(tf.x, tf.y, tf.textFieldWidth, tf.textFieldHeight, tX, tY, tWidth, tHeight);
				return;
			}
			tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
			tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
			final width = p.w + (p.x - e.stageX);
			final height = p.h + (p.y - e.stageY);
			tf.textFieldWidth = width;
			tf.textFieldHeight = height;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
				tf.textFieldWidth = -width;
			}
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
				tf.textFieldHeight = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeTopRight(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.textFieldWidth, // gutter
			h: tf.textFieldHeight // gutter
		};
		setPrevStats();

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);

				tf.onResized(tf.x, tf.y, tf.textFieldWidth, tf.textFieldHeight, tX, tY, tWidth, tHeight);
				return;
			}
			
			final width = p.w - (p.x - e.stageX);
			final height = p.h + (p.y - e.stageY);
            trace("width: " + width + " height: " + height);
            
			tf.textFieldWidth = width;
			tf.textFieldHeight = height;

            tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
			
            if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
				trace(width);
				tf.textFieldWidth = -width;
			}
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
				tf.textFieldHeight = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeBottomLeft(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.textFieldWidth, // gutter
			h: tf.textFieldHeight // gutter
		};
		setPrevStats();

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				
				tf.onResized(tf.x, tf.y, tf.textFieldWidth, tf.textFieldHeight, tX, tY, tWidth, tHeight);
				return;
			}
			tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
			final width = p.w + (p.x - e.stageX);
			final height = p.h - (p.y - e.stageY);
			tf.textFieldWidth = width;
			tf.textFieldHeight = height;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
				tf.textFieldWidth = -width;
			}
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
				tf.textFieldHeight = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeBottomRight(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.textFieldWidth, // gutter
			h: tf.textFieldHeight // gutter
		};
		setPrevStats();

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);

				tf.onResized(tf.x, tf.y, tf.textFieldWidth, tf.textFieldHeight, tX, tY, tWidth, tHeight);
				return;
			}
			final width = p.w - (p.x - e.stageX);
			final height = p.h - (p.y - e.stageY);
			tf.textFieldWidth = width;
			tf.textFieldHeight = height;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
				tf.textFieldWidth = -width;
			}
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
				tf.textFieldHeight = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeLeft(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.textFieldWidth, // gutter
			h: tf.textFieldHeight // gutter
		};
		setPrevStats();

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);

				tf.onResized(tf.x, tf.y, tf.textFieldWidth, tf.textFieldHeight, tX, tY, tWidth, tHeight);
				return;
			}
			tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
			final width = p.w + (p.x - e.stageX);
			tf.textFieldWidth = width;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
				tf.textFieldWidth = -width;
			}
			if (tf.matchTextSize) tf.textFieldHeight = tf.textHeight + 4;
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeRight(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.textFieldWidth, // gutter
			h: tf.textFieldHeight // gutter
		};
		setPrevStats();

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);

				tf.onResized(tf.x, tf.y, tf.textFieldWidth, tf.textFieldHeight, tX, tY, tWidth, tHeight);
				return;
			}
			final width = p.w - (p.x - e.stageX);
			tf.textFieldWidth = width;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
				tf.textFieldWidth = -width;
			}
			if (tf.matchTextSize) tf.textFieldHeight = tf.textHeight + 4;
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeTop(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.textFieldWidth, // gutter
			h: tf.textFieldHeight // gutter
		};
		setPrevStats();

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);

				tf.onResized(tf.x, tf.y, tf.textFieldWidth, tf.textFieldHeight, tX, tY, tWidth, tHeight);
				return;
			}
			tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
			final height = p.h + (p.y - e.stageY);
			tf.textFieldHeight = height;
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
				tf.textFieldHeight = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeBottom(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.textFieldWidth, // gutter
			h: tf.textFieldHeight // gutter
		};
		setPrevStats();

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);

				tf.onResized(tf.x, tf.y, tf.textFieldWidth, tf.textFieldHeight, tX, tY, tWidth, tHeight);
				return;
			}
			final height = p.h - (p.y - e.stageY);
			tf.textFieldHeight = height;
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
				tf.textFieldHeight = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startRotation(e:MouseEvent)
	{
		if (tf.hideControlsWhenUnfocused) tf.showControls();
		var rect:Rectangle = tf.getBounds(tf.parent);
		var centerX = rect.left + (rect.width / 2);
		var centerY = rect.top + (rect.height / 2);

		var centerPoint = {
			x: centerX - 2.5,
			y: centerY - 11
		};
		var prevRotation = tf.rotation;

		function rot(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, rot);

				tf.onRotated(tf.rotation, prevRotation);
				return;
			}
			rotateAroundCenter(tf,
				angleFromPointToPoint(tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x, tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y,
					centerPoint));
		}
		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, rot);
	}

	// create a function that calculates the angle between a point and the center of the object

	function angleFromPointToPoint(x:Float, y:Float, p:{x:Float, y:Float})
	{
		final angle = Math.atan2(y - p.y, x - p.x) * 180 / Math.PI;
		trace(angle);
		return angle;
	}

	public function rotateAroundCenter(object:DynamicTextField, angleDegrees:Float)
	{
		if (object.rotation == angleDegrees)
		{
			return;
		}

		var matrix:Matrix = object.transform.matrix;
		var rect:Rectangle = object.getBounds(object.parent);
		var centerX = rect.left + (rect.width / 2);
		var centerY = rect.top + (rect.height / 2);
		matrix.translate(-centerX, -centerY);
		matrix.rotate(((angleDegrees - object.rotation) / 180 + 0.5) * Math.PI);
		matrix.translate(centerX, centerY);
		object.transform.matrix = matrix;

		object.rotation = object.rotation;
	}
}
#end
