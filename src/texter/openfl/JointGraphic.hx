package texter.openfl;
#if openfl
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.BitmapData;

class JointGraphic {
    
    var d:DynamicTextField;

    public function new(d:DynamicTextField) {this.d = d;}

    /**
     * This joint will be used when no other joint is available.
     * This can be used as a fallback graphic, or as a default for all joints.
     */
    public var defaultGraphic(default, set):BitmapData = new DefaultJoint();

    function set_defaultGraphic(g:BitmapData):BitmapData {
        if (g == null) return g;

        var ref = new Sprite();
        for (i in [top, left, right, bottom]) {
            if (defaultEdgeGraphic != null) break;
            if (i != null) continue;
            if (i == top) ref = d.joints.middleTop;
            if (i == left) ref = d.joints.middleLeft;
            if (i == right) ref = d.joints.middleRight;
            if (i == bottom) ref = d.joints.middleBottom;
            
            ref.removeChildren();
            ref.addChild(new Bitmap(g));
        }

        for (i in [topRight, topLeft, bottomRight, bottomLeft]) {
            if (defaultCornerGraphic != null) break;
            if (i != null) continue;
            if (i == topRight) ref = d.joints.topRight;
            if (i == topLeft) ref = d.joints.topLeft;
            if (i == bottomRight) ref = d.joints.bottomRight;
            if (i == bottomLeft) ref = d.joints.bottomLeft;
            ref.removeChildren();
            ref.addChild(new Bitmap(g)); 
        }
        //update positions - the supplied graphic may be larger than the previous one
        d.width = d.width;
        d.width = d.height;
        return g;
    }
    /**
     * This joint will be used when no other corner joint is available.
     * This can be used as a fallback graphic, or as a default for all corner joints.
     * 
     * Notice - this will only apply to corner joints.
     */
    public var defaultCornerGraphic(default, set):BitmapData;

    function set_defaultCornerGraphic(g:BitmapData):BitmapData {
        if (g == null) return g;
        var ref = new Sprite();
        for (i in [topRight, topLeft, bottomRight, bottomLeft]) {
            if (i != null) continue;
            if (i == topRight) ref = d.joints.topRight;
            if (i == topLeft) ref = d.joints.topLeft;
            if (i == bottomRight) ref = d.joints.bottomRight;
            if (i == bottomLeft) ref = d.joints.bottomLeft;
            ref.removeChildren();
            ref.addChild(new Bitmap(g)); 
        }
        //update positions - the supplied graphic may be larger than the previous one
        d.width = d.width;
        d.width = d.height;
        return g;
    }

    /**
     * This joint will be used when no other edge joint is available.
     * This can be used as a fallback graphic, or as a default for all edge joints.
     * 
     * Notice - this will only apply to edge joints.
     */
    public var defaultEdgeGraphic(default, set):BitmapData;

    function set_defaultEdgeGraphic(g:BitmapData):BitmapData {
        if (g == null) return g;
        var ref = new Sprite();
        for (i in [top, left, right, bottom]) {
            if (i != null) continue;
            if (i == top) ref = d.joints.middleTop;
            if (i == left) ref = d.joints.middleLeft;
            if (i == right) ref = d.joints.middleRight;
            if (i == bottom) ref = d.joints.middleBottom;
            ref.removeChildren();
            ref.addChild(new Bitmap(g)); 
        }
        //update positions - the supplied graphic may be larger than the previous one
        d.width = d.width;
        d.width = d.height;
        return g;
    }

    /**
        This joint will be used for the rotation joint.

        When unset, will use the default graphic.
    **/
    public var rotationHandle(default, set):BitmapData = new DefaultJoint();

    function set_rotationHandle(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.rotation.removeChildren();
        d.joints.rotation.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.rotation.x = d.textField.width / 2 - d.joints.rotation.width / 2;
        d.joints.rotation.y = -ROTATION_JOINT_GUTTER;

        return g;
    }

    /**
     * When set, will be used for the top left corner joint.
     */
    public var topLeft(default, set):BitmapData;

    function set_topLeft(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.topLeft.removeChildren();
        d.joints.topLeft.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.topLeft.x = -JOINT_GUTTER;
        d.joints.topLeft.y = -JOINT_GUTTER;
        return g;
    }

    /**
     * When set, will be used for the top right corner joint.
     */
    public var topRight(default, set):BitmapData;

    function set_topRight(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.topRight.removeChildren();
        d.joints.topRight.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.topRight.x = d.textField.width -JOINT_GUTTER;
        d.joints.topRight.y = -JOINT_GUTTER;
        return g;
    }

    /**
     * When set, will be used for the bottom left corner joint.
     */
    public var bottomLeft(default, set):BitmapData;

    function set_bottomLeft(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.bottomLeft.removeChildren();
        d.joints.bottomLeft.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.bottomLeft.x = -JOINT_GUTTER;
        d.joints.bottomLeft.y = d.textField.height -JOINT_GUTTER;
        return g;
    }

    /**
     * When set, will be used for the bottom right corner joint.
     */
    public var bottomRight(default, set):BitmapData;

    function set_bottomRight(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.bottomRight.removeChildren();
        d.joints.bottomRight.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.bottomRight.x = d.textField.width -JOINT_GUTTER;
        d.joints.bottomRight.y = d.textField.height -JOINT_GUTTER;
        return g;
    }

    /**
     * When set, will be used for the left edge joint.
     */
    public var left(default, set):BitmapData;

    function set_left(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.middleLeft.removeChildren();
        d.joints.middleLeft.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.middleLeft.x = -JOINT_GUTTER;
        d.joints.middleLeft.y = d.textField.height / 2 - d.joints.middleLeft.height / 2;
        return g;
    }

    /**
     * When set, will be used for the right edge joint.
     */
    public var right(default, set):BitmapData;

    function set_right(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.middleRight.removeChildren();
        d.joints.middleRight.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.middleRight.x = d.textField.width -JOINT_GUTTER;
        d.joints.middleRight.y = d.textField.height / 2 - d.joints.middleRight.height / 2;
        return g;
    }

    /**
     * When set, will be used for the top edge joint.
     */
    public var top(default, set):BitmapData;

    function set_top(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.middleTop.removeChildren();
        d.joints.middleTop.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.middleTop.x = d.textField.width / 2 - d.joints.middleTop.width / 2;
        d.joints.middleTop.y = -JOINT_GUTTER;
        return g;
    }

    /**
     * When set, will be used for the bottom edge joint.
     */
    public var bottom(default, set):BitmapData;

    function set_bottom(g:BitmapData):BitmapData {
        if (g == null) return g;
        d.joints.middleBottom.removeChildren();
        d.joints.middleBottom.addChild(new Bitmap(g));
        //update positions - the supplied graphic may be larger than the previous one
        d.joints.middleBottom.x = d.textField.width / 2 - d.joints.middleBottom.width / 2;
        d.joints.middleBottom.y = d.textField.height -JOINT_GUTTER;
        return g;
    }
    
    public static final JOINT_GUTTER = 7;
    public static final ROTATION_JOINT_GUTTER = 40;
}

private class DefaultJoint extends BitmapData {
    
    public function new() {
        super(15, 15, true, 0x00000000);
        #if (js || flash)
        BitmapData.loadFromFile("assets/texter/DynamicTextField/DefaultJoint.png").onComplete(
            b -> {
                this.draw(b);
            }
        );
        #else
        this.draw(BitmapData.fromFile("assets/texter/DynamicTextField/DefaultJoint.png"));
        #end
    }
}
#end