package;
import openfl.geom.Point;

/**
 * ...
 * @author damrem
 */
class PointStatExt
{

	public static function distance(p:Point, to:Point):Float
	{
		var dx = p.x - to.x;
		var dy = p.y - to.y;
		return Math.sqrt(dx * dx + dy * dy);
	}
	
}