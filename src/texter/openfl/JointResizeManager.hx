package texter.openfl;
#if openfl
import texter.openfl.DynamicTextField;
import openfl.geom.Point;
import openfl.events.MouseEvent;
using Math;
class JointResizeManager {
    

    public var tf:DynamicTextField;

    public function new(tf:DynamicTextField) {
        this.tf = tf;
    }
        
    public function startResizeTopLeft(e:MouseEvent) {

        var p = {
            x: e.stageX,
            y: e.stageY,
            w: tf.width - 4, //gutter
            h: tf.height - 4 //gutter
        };

        function res(e:MouseEvent) {
            if (!e.buttonDown) {
                tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
                return;
            }
            tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
            tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
            final width = p.w + (p.x - e.stageX);
            final height = p.h + (p.y - e.stageY);
            tf.width = width;
            tf.height = height;
            if (width < 0) {
               tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
               tf.width = -width;
            }
            if (height < 0) {
               tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
               tf.height = -height;
            }
            @:privateAccess tf.calculateFrame();
        }

        tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);

        
    }

    public function startResizeTopRight(e:MouseEvent) {

        var p = {
            x: e.stageX,
            y: e.stageY,
            w: tf.width - 4, //gutter
            h: tf.height - 4 //gutter
        };

        function res(e:MouseEvent) {
            if (!e.buttonDown) {
                tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
                return;
            }
            tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
            final width = p.w - (p.x - e.stageX);
            final height = p.h + (p.y - e.stageY);
            tf.width = width;
            tf.height = height;
            if (width < 0) {
               tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
               trace(width);
               tf.width = -width;
            }
            if (height < 0) {
               tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
               tf.height = -height;
            }
            @:privateAccess tf.calculateFrame();
        }

        tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);        
    }

    public function startResizeBottomLeft(e:MouseEvent) {

        var p = {
            x: e.stageX,
            y: e.stageY,
            w: tf.width - 4, //gutter
            h: tf.height - 4 //gutter
        };

        function res(e:MouseEvent) {
            if (!e.buttonDown) {
                tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
                return;
            }
            tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
            final width = p.w + (p.x - e.stageX);
            final height = p.h - (p.y - e.stageY);
            tf.width = width;
            tf.height = height;
            if (width < 0) {
               tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
               tf.width = -width;
            }
            if (height < 0) {
               tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
               tf.height = -height;
            }
            @:privateAccess tf.calculateFrame();
        }

        tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
    }

    public function startResizeBottomRight(e:MouseEvent) {

        var p = {
            x: e.stageX,
            y: e.stageY,
            w: tf.width - 4, //gutter
            h: tf.height - 4 //gutter
        };

        function res(e:MouseEvent) {
            if (!e.buttonDown) {
                tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
                return;
            }
            final width = p.w - (p.x - e.stageX);
            final height = p.h - (p.y - e.stageY);
            tf.width = width;
            tf.height = height;
            if (width < 0) {
               tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
               tf.width = -width;
            }
            if (height < 0) {
               tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
               tf.height = -height;
            }
            @:privateAccess tf.calculateFrame();
        }

        tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
    }

    public function startResizeLeft(e:MouseEvent) {

        var p = {
            x: e.stageX,
            y: e.stageY,
            w: tf.width - 4, //gutter
            h: tf.height - 4 //gutter
        };

        function res(e:MouseEvent) {
            if (!e.buttonDown) {
                tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
                return;
            }
            tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
            final width = p.w + (p.x - e.stageX);
            tf.width = width;
            if (width < 0) {
               tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x + width;
               tf.width = -width;
            }
            @:privateAccess tf.calculateFrame();
        }

        tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
    }

    public function startResizeRight(e:MouseEvent) {

        var p = {
            x: e.stageX,
            y: e.stageY,
            w: tf.width - 4, //gutter
            h: tf.height - 4 //gutter
        };

        function res(e:MouseEvent) {
            if (!e.buttonDown) {
                tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
                return;
            }
            final width = p.w - (p.x - e.stageX);
            tf.width = width;
            if (width < 0) {
               tf.x = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).x;
               tf.width = -width;
            }
            @:privateAccess tf.calculateFrame();
        }

        tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
    }

    public function startResizeTop(e:MouseEvent) {

        var p = {
            x: e.stageX,
            y: e.stageY,
            w: tf.width - 4, //gutter
            h: tf.height - 4 //gutter
        };

        function res(e:MouseEvent) {
            if (!e.buttonDown) {
                tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
                return;
            }
            tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
            final height = p.h + (p.y - e.stageY);
            tf.height = height;
            if (height < 0) {
               tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y + height;
               tf.height = -height;
            }
            @:privateAccess tf.calculateFrame();
        }

        tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
    }

    public function startResizeBottom(e:MouseEvent) {

        var p = {
            x: e.stageX,
            y: e.stageY,
            w: tf.width - 4, //gutter
            h: tf.height - 4 //gutter
        };

        function res(e:MouseEvent) {
            if (!e.buttonDown) {
                tf.stage.removeEventListener(MouseEvent.MOUSE_MOVE, res);
                return;
            }
            final height = p.h - (p.y - e.stageY);
            tf.height = height;
            if (height < 0) {
               tf.y = tf.parent.globalToLocal(new Point(e.stageX, e.stageY)).y;
               tf.height = -height;
            }
            @:privateAccess tf.calculateFrame();
        }

        tf.stage.addEventListener(MouseEvent.MOUSE_MOVE, res);
    }

}
#end