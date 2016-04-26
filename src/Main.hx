package;


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
	
	public function new() 
	{
		super();
		
		
		/*
		circles = [
			{center:new Point(100, 100), radius:50},
			{center:new Point(125, 125), radius:50},
			{center:new Point(75, 125), radius:50}
		];
		
		graphics.lineStyle(1, 0xff0000);
		for (circle0 in circles)
		{
			graphics.drawFromCircle(circle0);
			
			for (circle1 in circles)
			{
				if (circle1 == circle0){
					break;
				}
				for (p in intersection(circle0, circle1))
				{
					graphics.drawCircle(p.x, p.y, 2.5);
				}
			}
		}
		*/
		
		addChild(new MetaballRacetrack());
		
		
		addChild(new FPS(10, 10, 0xff0000));
		
	}
	
	
	function intersection(circle0:Circle, circle1:Circle):Array<Point>
	{
		var x0 = circle0.center.x;
		var y0 = circle0.center.y;
		var r0 = circle0.radius;
		
		var x1 = circle1.center.x;
		var y1 = circle1.center.y;
		var r1 = circle1.radius;
		
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

