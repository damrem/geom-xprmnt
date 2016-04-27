package;
import openfl.display.Graphics;
import thx.geom.d2.Circle;

/**
 * ...
 * @author damrem
 */
class GraphicsStatExt
{
	public static function drawFromCircle(g:Graphics, circle:Circle)
	{
		g.drawCircle(circle.center.x, circle.center.y, circle.radius);
	}
}