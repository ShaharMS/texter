package texter.openfl;

#if openfl
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import texter.openfl.DynamicTextField;
import openfl.geom.Point;
import openfl.events.MouseEvent;

using Math;
class JointManager
{
	public var tf:DynamicTextField;

	public function new(tf:DynamicTextField)
	{
		this.tf = tf;
	}

	public function startResizeTopLeft(e:MouseEvent)
	{
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.width - 5, // gutter
			h: tf.height - 22 // gutter
		};

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				return;
			}
			tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
			tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
			final width = p.w + (p.x - e.stageX);
			final height = p.h + (p.y - e.stageY);
			tf.width = width;
			tf.height = height;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
				tf.width = -width;
			}
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
				tf.height = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeTopRight(e:MouseEvent)
	{
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.width - 5, // gutter
			h: tf.height - 22 // gutter
		};

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				return;
			}
			
			final width = p.w - (p.x - e.stageX);
			final height = p.h + (p.y - e.stageY);
            trace("width: " + width + " height: " + height);
            //mins
            if (tf.minWidth > 0) tf.width = width > tf.minWidth ? width : tf.minWidth;
			if (tf.minHeight > 0) tf.height = height > tf.minHeight ? height : tf.minHeight;
            //maxs
            if (tf.maxWidth > 0) tf.width = Math.abs(tf.width) < tf.maxWidth ? tf.width : tf.maxWidth;        
            if (tf.maxHeight > 0) tf.height = Math.abs(tf.height) < tf.maxHeight ? tf.height : tf.maxHeight;
            
            tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
			
            if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
				trace(width);
				tf.width = -width;
			}
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
				tf.height = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeBottomLeft(e:MouseEvent)
	{
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.width - 5, // gutter
			h: tf.height - 22 // gutter
		};

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				return;
			}
			tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
			final width = p.w + (p.x - e.stageX);
			final height = p.h - (p.y - e.stageY);
			tf.width = width;
			tf.height = height;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
				tf.width = -width;
			}
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
				tf.height = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeBottomRight(e:MouseEvent)
	{
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.width - 5, // gutter
			h: tf.height - 22 // gutter
		};

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				return;
			}
			final width = p.w - (p.x - e.stageX);
			final height = p.h - (p.y - e.stageY);
			tf.width = width;
			tf.height = height;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
				tf.width = -width;
			}
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
				tf.height = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeLeft(e:MouseEvent)
	{
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.width - 5, // gutter
			h: tf.height - 22 // gutter
		};

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				return;
			}
			tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
			final width = p.w + (p.x - e.stageX);
			tf.width = width;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
				tf.width = -width;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeRight(e:MouseEvent)
	{
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.width - 5, // gutter
			h: tf.height - 22 // gutter
		};

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				return;
			}
			final width = p.w - (p.x - e.stageX);
			tf.width = width;
			if (width < 0)
			{
				tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
				tf.width = -width;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeTop(e:MouseEvent)
	{
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.width - 5, // gutter
			h: tf.height - 22 // gutter
		};

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				return;
			}
			tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
			final height = p.h + (p.y - e.stageY);
			tf.height = height;
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
				tf.height = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startResizeBottom(e:MouseEvent)
	{
		var p = {
			x: e.stageX,
			y: e.stageY,
			w: tf.width - 5, // gutter
			h: tf.height - 22 // gutter
		};

		function res(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
				return;
			}
			final height = p.h - (p.y - e.stageY);
			tf.height = height;
			if (height < 0)
			{
				tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
				tf.height = -height;
			}
		}

		tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
	}

	public function startRotation(e:MouseEvent)
	{
		var rect:Rectangle = tf.getBounds(tf.parent);
		var centerX = rect.left + (rect.width / 2);
		var centerY = rect.top + (rect.height / 2);

		var centerPoint = {
			x: centerX - 2.5,
			y: centerY - 11
		};

		function rot(e:MouseEvent)
		{
			if (!e.buttonDown)
			{
				tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, rot);
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
