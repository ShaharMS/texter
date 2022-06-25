package texter.openfl;

import openfl.display.BitmapData;

class JointGraphic {
    
    public function new() {}

    /**
     * This joint will be used when no other joint is available.
     * This can be used as a fallback graphic, or as a default for all joints.
     */
    public var defaultGraphic:BitmapData;

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

    // topLeft, topRight, bottomLeft, bottomRight

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