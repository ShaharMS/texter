package texter.openfl;
#if openfl
import openfl.display.BitmapData;

class JointGraphic {
    
    public function new() {}

    /**
     * This joint will be used when no other joint is available.
     * This can be used as a fallback graphic, or as a default for all joints.
     */
    public var defaultGraphic:BitmapData = new DefaultJoint();

    /**
     * This joint will be used when no other corner joint is available.
     * This can be used as a fallback graphic, or as a default for all corner joints.
     * 
     * Notice - this will only apply to corner joints.
     */
    public var defaultCornerGraphic:BitmapData;

    /**
     * This joint will be used when no other edge joint is available.
     * This can be used as a fallback graphic, or as a default for all edge joints.
     * 
     * Notice - this will only apply to edge joints.
     */
    public var defaultEdgeGraphic:BitmapData;

    /**
        This joint will be used for the rotation joint.

        When unset, will use the default graphic.
    **/
    public var rotationHandle:BitmapData = new DefaultJoint();

    /**
     * When set, will be used for the top left corner joint.
     */
    public var topLeft:BitmapData;

    /**
     * When set, will be used for the top right corner joint.
     */
    public var topRight:BitmapData;

    /**
     * When set, will be used for the bottom left corner joint.
     */
    public var bottomLeft:BitmapData;

    /**
     * When set, will be used for the bottom right corner joint.
     */
    public var bottomRight:BitmapData;

    //left, right, top, bottom

    /**
     * When set, will be used for the left edge joint.
     */
    public var left:BitmapData;

    /**
     * When set, will be used for the right edge joint.
     */
    public var right:BitmapData;

    /**
     * When set, will be used for the top edge joint.
     */
    public var top:BitmapData;

    /**
     * When set, will be used for the bottom edge joint.
     */
    public var bottom:BitmapData;
    
}

private class DefaultJoint extends BitmapData {
    
    public function new() {
        super(5, 5, true, 0xFFFF0000);
        /*
        lock();
        //up
        setPixel(1, 0, 0x000000);
        setPixel(2, 0, 0x000000);
        setPixel(3, 0, 0x000000);

        //down
        setPixel(1, 4, 0x000000);
        setPixel(2, 4, 0x000000);
        setPixel(3, 4, 0x000000);

        //left
        setPixel(0, 1, 0x000000);
        setPixel(0, 2, 0x000000);
        setPixel(0, 3, 0x000000);

        //right
        setPixel(4, 1, 0x000000);
        setPixel(4, 2, 0x000000);
        setPixel(4, 3, 0x000000);

        floodFill(3,3, 0xFFFFFF);
        unlock();
        */
        

    }
}
#end