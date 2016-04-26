package com.metaballdemo.core;
import com.metaballdemo.util.MathUtil;
import com.metaballdemo.util.Vector2D;

//import com.metaballdemo.util.*;

 class Metaball
{
	 public static inline var MIN_STRENGTH:Float = 1;
	 public static inline var MAX_STRENGTH:Float = 100;
	
	private var _position:Vector2D;
	private var _strength:Float;
	
	// Set to true when the ball has finished tracking its segment of the border.
	public var tracked:Bool;
	
	// A point on the edge of the metaball.
	public var edge:Vector2D;
	
	// The direction the edge-seeking algorithm should look in to find the edge.
	public var direction:Vector2D;
	
	// --------------------------------------------------------------------------------
	// Constructor
	// --------------------------------------------------------------------------------
	
	public function new(position:Vector2D, strength:Float)
	{
		_position = position.clone();
		_strength = strength;
		
		tracked = false;
		edge = position.clone();
		direction = new Vector2D(Math.random() * 2 - 1, Math.random() * 2 - 1);
	}
	
	/**
	 * Check the strength of this metaball on a point in space.
	 * @param	v	The point to check against.
	 * @param	c	The exponential constant of the field.
	 * @return	The strength of this metaball's field at the point.
	 */
	public function strengthAt(v:Vector2D, c:Float):Float
	{
		var div:Float = Math.pow(Vector2D.subtractVectors(_position, v).lengthSq, c * 0.5);
		
		return (div != 0) ? (_strength / div) : 10000;
	}
	
	// --------------------------------------------------------------------------------
	// Properties
	// --------------------------------------------------------------------------------
	
	/**
	 * The location of the center of the metaball.
	 */
	public var position(get, set):Vector2D;
	public function get_position():Vector2D
	{
		return _position;
	}
	
	/** @private */
	public function set_position(value:Vector2D):Vector2D
	{
		_position.copy(value);
		return _position;
	}
	
	/**
	 * The relative strength of the metaball within the system.
	 */
	public var strength(get, set):Float;
	public function get_strength():Float
	{
		return _strength;
	}
	
	/**@private */
	public function set_strength(value:Float):Float
	{
		_strength = MathUtil.clamp(value, MIN_STRENGTH, MAX_STRENGTH);
		return _strength;
	}
	
	// --------------------------------------------------------------------------------
	// Helpers
	// --------------------------------------------------------------------------------
	
	public function toString():String
	{
		return "[object Metaball][position=" + position + "][size=" + strength/*.toFixed(4)*/ + "]";
	}
}
