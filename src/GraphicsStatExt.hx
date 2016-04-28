package;
import openfl.display.Graphics;

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