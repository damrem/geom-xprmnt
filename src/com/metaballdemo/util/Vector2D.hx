package com.metaballdemo.util;
/**
 * A two-dimensional vector class.
 */
class Vector2D 
{
	// --------------------------------------------------------------------------------
	// Members
	// --------------------------------------------------------------------------------
	
	public var x:Float;
	public var y:Float;
	
	// --------------------------------------------------------------------------------
	// Constructor
	// --------------------------------------------------------------------------------
	
	public function new(x:Float = 0, y:Float = 0) 
	{
		this.x = x;
		this.y = y;
	}
	
	// --------------------------------------------------------------------------------
	// Properties
	// --------------------------------------------------------------------------------
	
	/**
	 * The length of the vector.
	 */
	public var length(get, set):Float;
	public function get_length():Float
	{
		return Math.sqrt(lengthSq);
	}
	
	/** @private */
	public function set_length(value:Float):Float
	{
		x *= (value /= length);
		y *= value;
		return value;
	}
	
	/**
	 * The length of the vector, squared.
	 */
	public var lengthSq(get, null):Float;
	public function get_lengthSq():Float
	{
		return (x * x + y * y);
	}
	
	/**
	 * The angle (in radians) of the vector from the positve x-axis.
	 */
	public var angle(get, set):Float;
	public function get_angle():Float
	{
		return Math.atan2(x, y);
	}
	
	/** @private */
	public function set_angle(value:Float):Float
	{
		var len:Float = length;
		x = Math.cos(value) * len;
		y = Math.sin(value) * len;
		return value;
	}
	
	/**
	 * Finds the dot product between this vector and another.
	 * @param	v2	The vector to compute the dot product against.
	 */
	public function dot(v2:Vector2D):Float
	{
		return (x * v2.x) + (y * v2.y);
	}
	
	/**
	 * Finds the absolute distance between this vector and another.
	 * @param	v2	The vector to compute the distance to.
	 */
	public function dist(v2:Vector2D):Float
	{
		return Math.sqrt(distSq(v2));
	}
	
	/**
	 * Finds the absolute distance, squared, between this vector and another.
	 * @param	v2	The vector to compute the distance to.
	 */
	public function distSq(v2:Vector2D):Float
	{
		var dx:Float = v2.x - x, dy:Float = v2.y - y;
		
		return (dx * dx + dy * dy);
	}
	
	// --------------------------------------------------------------------------------
	// Return this Vector2D
	// --------------------------------------------------------------------------------
	
	/**
	 * Zeroes out both components of the vector.
	 * @return 	A reference to this vector.
	 */
	public function zero():Vector2D
	{
		x = 0;
		y = 0;
		
		return this;
	}
	
	/**
	 * Sets the components of the vector to those of another vector.
	 * @param	v2	The vector to copy.
	 * @return 	A reference to this vector.
	 */
	public function copy(v2:Vector2D):Vector2D
	{
		x = v2.x;
		y = v2.y;
		
		return this;
	}
	
	/**
	 * Normalizes the vector to a length of 1.
	 * @return 	A reference to this vector.
	 */
	public function norm():Vector2D
	{
		if (x == 0 && y == 0) 
		{
			x = 1;
			return this;
		}
		
		var len:Float = length;
		x /= len;
		y /= len;
		
		return this;
	}
	
	/**
	 * Limits the vector to a maximum length. If the length is already under the maximum,
	 * it remains unchanged. If the length is zero, it becomes the x-axis normal vector.
	 * @param 	max 	The maximum length of the vector.
	 * @return 	A reference to this vector.
	 */
	public function limit(max:Float):Vector2D
	{
		var len:Float = length;
		if (len > max)
		{
			x *= (max /= len);
			y *= max;
		}
		
		return this;
	}
	
	/**
	 * Adds a vector to this vector.
	 * @param	v2	The vector to add.
	 * @return 	A reference to this vector.
	 */
	public function add(v2:Vector2D):Vector2D
	{
		x += v2.x;
		y += v2.y;
		
		return this;
	}
	
	/**
	 * Subtracts a vector from this vector.
	 * @param	v2	The vector to subtract.
	 * @return 	A reference to this vector.
	 */
	public function subtract(v2:Vector2D):Vector2D
	{
		x -= v2.x;
		y -= v2.y;
		
		return this;
	}
	
	/**
	 * Multiplies this vector by a scaler.
	 * @param	value	The scaler to multiply with.
	 * @return 	A reference to this vector.
	 */
	public function multiply(value:Float):Vector2D
	{
		x *= value;
		y *= value;
		
		return this;
	}
	
	/**
	 * Divides this vector by a scaler.
	 * @param	value	The scaler to divide by.
	 * @return 	A reference to this vector.
	 */
	public function divide(value:Float):Vector2D
	{
		x /= value;
		y /= value;
		
		return this;
	}
	
	// --------------------------------------------------------------------------------
	// Return new Vector2D
	// --------------------------------------------------------------------------------
	
	/**
	 * Creates a new instance of the vector.
	 * @return A clone of this vector.
	 */
	public function clone():Vector2D
	{
		return new Vector2D(x, y);
	}
	
	/**
	 * Finds the vector that is perpindicular and to the left of this vector.
	 * @return The perpindicular vector.
	 */
	public var perpLeft(get, null):Vector2D;
	public function get_perpLeft():Vector2D
	{
		return new Vector2D(-y, x);
	}
	
	/**
	 * Finds the vector that is perpindicular and to the right of this vector.
	 * @return The perpindicular vector.
	 */
	public var perpRight(get, null):Vector2D;
	public function get_perpRight():Vector2D
	{
		return new Vector2D(y, -x);
	}
	
	// --------------------------------------------------------------------------------
	// Static Functions
	// --------------------------------------------------------------------------------
	
	/**
	 * Finds the counter-clockwise angle (in radians) between two vectors.
	 * @param	v1	The first vector.
	 * @param	v2	The second vector.
	 */
	public static function angleBetween(v1:Vector2D, v2:Vector2D):Float
	{
		return Math.atan2(v2.y, v2.x) - Math.atan2(v1.y, v1.x);
	}
	
	/**
	 * Adds two vectors together.
	 * @param	v1	The first vector.
	 * @param	v2	The second vector.
	 * @return	A new vector that is the sum of v1 and v2.
	 */
	public static function addVectors(v1:Vector2D, v2:Vector2D):Vector2D
	{
		return new Vector2D(v1.x + v2.x, v1.y + v2.y);
	}
	
	/**
	 * Subtracts the second vector from the first.
	 * @param	v1	The first vector.
	 * @param	v2	The second vector.
	 * @return 	A new vector that is the difference of v1 and v2.
	 */
	public static function subtractVectors(v1:Vector2D, v2:Vector2D):Vector2D
	{
		return new Vector2D(v1.x - v2.x, v1.y - v2.y);
	}
	
	// --------------------------------------------------------------------------------
	// Helpers
	// --------------------------------------------------------------------------------
	
	/**
	 * Creates a string out of the vector.
	 * @return A string in format "[Vector2D (x: num, y: num)]".
	 */
	public function toString():String
	{
		return "[object Vector2D][x=" + x + "][y=" + y + "]";
	}
}
