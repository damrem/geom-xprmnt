package com.metaballdemo.util;
class MathUtil
{
	public static inline var PI:Float = 3.14159265;
	public static inline var HALF_PI:Float = 1.57079633;
	public static inline var PI_OVER_180:Float = 0.0174532925;
	public static inline var PI_UNDER_180:Float = 57.2957795;
	
	/**
	 * Re-maps a value from one range to another.
	 * @param	value		the value to be remapped
	 * @param	fromLow		the lowest value of the original range
	 * @param	fromHigh	the highest value of the original range
	 * @param	toLow		the lowest value of the new range
	 * @param	toHigh		the highest value of the new range
	 * @return	Float		the re-mapped value
	 */
	public static function map(value:Float, fromLow:Float, fromHigh:Float, toLow:Float, toHigh:Float):Float
	{
		return (value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
	}
	
	/**
	 * Re-maps a value from one range to another, and clamps the value to the new range.
	 * @param	value		the value to be remapped
	 * @param	fromLow		the lowest value of the original range
	 * @param	fromHigh	the highest value of the original range
	 * @param	toLow		the lowest value of the new range
	 * @param	toHigh		the highest value of the new range
	 * @return	Float		the re-mapped value
	 */
	public static function strictMap(value:Float, fromLow:Float, fromHigh:Float, toLow:Float, toHigh:Float):Float
	{
		var result:Float = (value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
		return result < toLow ? toLow : (result > toHigh ? toHigh : result);
	}
	
	/**
	 * Clamps a value to be between a minimum and a maximum.
	 * @param	value		the value to be clamped
	 * @param	min			the minimum value to clamp to
	 * @param	max			the maximum value to clamp to
	 * @return	Float		the clamped value
	 */
	public static function clamp(value:Float, min:Float, max:Float):Float
	{
		return value < min ? min : (value > max ? max : value);
	}
	
	/**
	 * Computes the angle between two absolute points on the stage, in the range of -180.0 to 180.0 degrees.
	 * @param	x			the x coordinate of the first point
	 * @param	y			the y coordinate of the first point
	 * @param	u			the x coordinate of the second point
	 * @param	v			the y coordinate of the second point
	 * @param	radians		if true, returns the result in radians
	 * @return	the angle between the two points
	 */
	public static function angleBetween(x:Float, y:Float, u:Float, v:Float, radians:Bool = false):Float
	{
		return radians ? Math.atan2(v - y, u - x) : degrees( Math.atan2(v - y, u - x) );
	}
	
	/**
	 * Takes an angle in radians can converts it to degrees.
	 * @param	value	the angle in radians
	 * @return	the angle in degrees
	 */
	public static function degrees(value:Float):Float
	{
		return value * PI_UNDER_180;
	}
	
	/**
	 * Takes an angle in degrees and converts it to radians.
	 * @param	value	the angle in degrees
	 * @return	the angle in radians
	 */
	public static function radians(value:Float):Float
	{
		return value * PI_OVER_180;
	}
}
