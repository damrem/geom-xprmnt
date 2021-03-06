package;


import com.metaballdemo.util.MathUtil;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;
import src.hxgeomalgo.Tess2;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.geom.Point;

using GraphicsStatExt;
//using PointStatExt;

/**
 * ...
 * @author damrem
 */
class Main extends Sprite 
{

	var circles:Array<Circle>;
	var isMouseDown:Bool;
	var scene0:Sprite;
	var scene1:Sprite;
	var currentScene:Sprite;
	//var buffer0:BitmapData;
	//var buffer1:BitmapData;
	var currentBuffer:BitmapData;
	
	public function new() 
	{
		super();
		
		//buffer0 = new BitmapData(Std.int(stage.stageWidth), Std.int(stage.stageHeight));
		//buffer1 = new BitmapData(Std.int(stage.stageWidth), Std.int(stage.stageHeight));
		currentBuffer = new BitmapData(Std.int(stage.stageWidth), Std.int(stage.stageHeight));
		var screen = new Bitmap(currentBuffer);
		addChild(screen);
		
		scene0 = new Sprite();
		scene1 = new Sprite();
		currentScene = scene0;
		
		var stage = Lib.current.stage;
		
		circles = [
			{center: new Point(stage.stageWidth/2, stage.stageHeight/2), radius:50}
			//{center:new Point(225, 125), radius:100},
			//{center: new Point(375, 225), radius:100}
		];
		
		//trace(polygons.length);
		
		
		
		
		
		
		
		
		
		
		
		addChild(new FPS(10, 10, 0xff0000));
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseUpOrDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUpOrDown);
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function update(e:Event):Void 
	{
		if (isMouseDown)
		{
			circles.push( { center:new Point(mouseX, mouseY), radius:50 } );
		}
		
		
		
		var polygonCoords:Array<Array<Float>> = circles.map(function(circle)
		{
			return getCoordsFromCircle(circle);
		});
		
		
		var polyCoords:Array<Array<Float>> = polygonCoords.slice(0,polygonCoords.length);
		var union:TessResult={vertices:[], vertexIndices:[], vertexCount:0,elements:[],elementCount:0};
		var combined:Array<Float> = [];
		
		while (polyCoords.length > 0)
		{
			var toCombine = polyCoords.shift();
			if (toCombine == null)
			{
				toCombine = [];
			}
			union = Tess2.union([combined], [toCombine], ResultType.BOUNDARY_CONTOURS);
			combined = union.vertices;
			
		}
		var res = Tess2.convertResult(union.vertices, union.elements, ResultType.BOUNDARY_CONTOURS, 3);
		currentScene.graphics.clear();
		currentScene.graphics.lineStyle(5, 0xff0000);
		for (poly in res)
		{
			var lastPoint = poly[poly.length - 1];
			currentScene.graphics.moveTo(lastPoint.x, lastPoint.y);
			for (pt in poly)
			{
				currentScene.graphics.lineTo(pt.x, pt.y);
			}
		}
		
		currentBuffer.fillRect(currentBuffer.rect, 0x000000);
		currentBuffer.draw(currentScene);
		
		if (currentScene == scene0)
		{
			currentScene = scene1;
		}
		else
		{
			currentScene = scene0;
		}
	}
	
	private function onMouseUpOrDown(e:MouseEvent):Void 
	{
		if (e.type == MouseEvent.MOUSE_DOWN)
		{
			isMouseDown = true;
		}
		else
		{
			isMouseDown = false;
		}
	}
	
	
	
	
	function getPolygonFromCircle(circle:Circle, size:Int=32):Array<Point>
	{
		var slice = Math.PI * 2 / size;
		//trace( size, slice);
		var hand = new Vector2D(circle.radius, 0);
		
		var pts = [];
		
		for (i in 0...size)
		{
			
			pts.push(new Point(circle.center.x+hand.x, circle.center.y+hand.y));
			//trace(hand.x);
			
			hand.angle += slice;
			
			
			//v=new Vector2D(v.toAngle()+ slice);
		}
		return pts;
	}
	
	
	function getCoordsFromCircle(circle:Circle, size:Int=32):Array<Float>
	{
		var slice = Math.PI * 2 / size;
		//trace( size, slice);
		var hand = new Vector2D(circle.radius, 0);
		
		var floats = [];
		
		for (i in 0...size)
		{
			
			floats.push(circle.center.x + hand.x);
			floats.push(circle.center.y + hand.y);
			//trace(hand.x);
			
			hand.angle += slice;
			
			
			//v=new Vector2D(v.toAngle()+ slice);
		}
		return floats;
	}
	
	
	
	
	function intersection(circle0:Circle, circle1:Circle):Array<Point>
	{
		var x0 = circle0.center.x;
		var y0 = circle0.center.y;
		var r0 = circle0.radius/*.toFloat()*/;
		
		var x1 = circle1.center.x;
		var y1 = circle1.center.y;
		var r1 = circle1.radius/*.toFloat()*/;
		
		var a, dx, dy, d, h, rx, ry;
        var x2, y2;

        /* dx and dy are the vertical and horizontal distances between
         * the circle centers.
         */
        dx = x1 - x0;
        dy = y1 - y0;

        /* Determine the straight-line distance between the centers. */
        d = Math.sqrt((dy*dy) + (dx*dx));

        /* Check for solvability. */
        if (d > (r0 + r1)) {
            /* no solution. circles do not intersect. */
            return [];
        }
        if (d < Math.abs(r0 - r1)) {
            /* no solution. one circle is contained in the other */
            return [];
        }

        /* 'point 2' is the point where the line through the circle
         * intersection points crosses the line between the circle
         * centers.  
         */

        /* Determine the distance from point 0 to point 2. */
        a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d) ;

        /* Determine the coordinates of point 2. */
        x2 = x0 + (dx * a/d);
        y2 = y0 + (dy * a/d);

        /* Determine the distance from point 2 to either of the
         * intersection points.
         */
        h = Math.sqrt((r0*r0) - (a*a));

        /* Now determine the offsets of the intersection points from
         * point 2.
         */
        rx = -dy * (h/d);
        ry = dx * (h/d);

        /* Determine the absolute intersection points. */
        var xi = x2 + rx;
        var xi_prime = x2 - rx;
        var yi = y2 + ry;
        var yi_prime = y2 - ry;

		return [new Point(xi, yi), new Point(xi_prime, yi_prime)];
    }

}

