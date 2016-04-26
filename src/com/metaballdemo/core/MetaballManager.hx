package com.metaballdemo.core;

import com.metaballdemo.util.Vector2D;
import flash.display.GraphicsPath;
import openfl.errors.Error;

//import com.metaballdemo.util.*;

class MetaballManager
{
	// --------------------------------------------------------------------------------
	// Members
	// --------------------------------------------------------------------------------
	
	// Singleton management
	private static var instance:MetaballManager = null;
	private static var lock:Bool = false;
	
	// Metaball system properties
	public static var gooieness:Float = 2.0;
	public static var threshold:Float = 0.0006;
	public static var resolution:Float = 10.0;
	public static var maxSteps:Int = 400;
	
	// A list of all of the metaballs in the system
	private var _metaballs:Array<Metaball>;
	
	// The last frozen outline of the system.
	private var _outline:GraphicsPath;
	
	// Smallest size metaball in the system
	private var minstrength:Float;
	
	// --------------------------------------------------------------------------------
	// Singleton Management
	// --------------------------------------------------------------------------------
	
	/**
	 * Do not attempt to construct a the manager yourself; it is a singleton.
	 * Use MetaballManager.getInstance() instead.
	 */
	public function new()
	{
		if (lock)
			throw new Error("Error: Instantiation failed. Use MetaballManager.getInstance() instead of new.");
		else
		{
			_metaballs = new Array<Metaball>();
			_outline = new GraphicsPath();
			
			minstrength = Metaball.MIN_STRENGTH;
		}
	}
	
	/**
	 * Get an instance of the MetaballManager singleton.
	 * @return	MetaballManager	The metaball system manager.
	 */
	public static function getInstance():MetaballManager
	{
		if (instance == null)
		{
			instance = new MetaballManager();
			lock = true;
		}
		
		return instance;
	}
	
	// --------------------------------------------------------------------------------
	// Properties
	// --------------------------------------------------------------------------------
	public var outline(get, null):GraphicsPath;
	public function get_outline():GraphicsPath
	{
		return _outline;
	}
	
	// --------------------------------------------------------------------------------
	// Metaball Functions
	// --------------------------------------------------------------------------------
	
	/**
	 * Add a metaball to the system.
	 * @param	metaball	The metaball to add.
	 */
	public function addMetaball(metaball:Metaball)
	{
		minstrength = Math.min(metaball.strength, minstrength);
		
		_metaballs.push(metaball);
	}
	
	/**
	 * Remove a metaball from the system.
	 * @param	metaball	The metaball to remove.
	 */
	public function removeMetaball(metaball:Metaball)
	{
		var index:Int = _metaballs.indexOf(metaball);
		
		if (index < 0)
			throw new Error("Metaball not found.");
		
		_metaballs.splice(index, 1);
	}
	
	/**
	 * The number of metaballs in the system.
	 */
	public var size(get, null):Int;
	public function get_size():Int
	{
		trace(_metaballs);
		return _metaballs.length;
	}
	
	/**
	 * Freeze the current state of the system into a GraphicsPath object, accessible
	 * through the <code>outline</code> property.
	 */
	public function freeze()
	{
		_outline = new GraphicsPath();
		
		var seeker:Vector2D = new Vector2D(), metaball:Metaball, i:Int;
		
		// Reset the tracking on all of the metaballs and find their edge.
		for (metaball in _metaballs)
		{
			metaball.tracked = false;
			
			// Start at the center of the metaball.
			seeker.copy(metaball.position);
			
			// Step towards border until the force of the field goes below the threshold.
			i = 0;
			while ((stepToEdge(seeker) > threshold) && (++i < 50)) {}
			
			metaball.edge.copy(seeker);
		}
		
		var edgeSteps:Int = 0, current:Metaball = untrackedMetaball();
		
		seeker.copy(current.edge);
		_outline.moveTo(seeker.x, seeker.y);
		
		while (current != null && edgeSteps < maxSteps)
		{
			// Integrate the edge seeker.
			rk2(seeker, resolution);
			
			// Add the current edge point to the final outline.
			_outline.lineTo(seeker.x, seeker.y);
			
			// Check against each other metaball in the system to see if this one's
			// edge seeker has found that one's edge point.
			for (metaball in _metaballs)
			{
				if (seeker.dist(metaball.edge) < (resolution * 0.9))
				{
					seeker.copy(metaball.edge);
					_outline.lineTo(seeker.x, seeker.y);
					
					current.tracked = true;
					
					if (metaball.tracked)
					{
						current = untrackedMetaball();
						
						if (current!=null)
						{
							seeker.copy(current.edge);
							_outline.moveTo(seeker.x, seeker.y);
						}
					}
					else
					{
						current = metaball;
					}
					
					// Get back to tracking the edge.
					break;
				}
			}
			
			++edgeSteps;
		}
	}
	
	// --------------------------------------------------------------------------------
	// Helpers
	// --------------------------------------------------------------------------------
	
	/**
	 * Find a metaball that has not been tracked yet.
	 * @return	An untracked metaball, or null if all have been tracked.
	 */
	private function untrackedMetaball():Metaball
	{
		for (metaball in _metaballs)
		{
			if (!metaball.tracked)
				return metaball;
		}
		
		return null;
	}
	
	/**
	 * Step once towards an edge of the system from the specified position.
	 * @param	pos		The vector to step towards an edge.
	 * @return	Number	The force of the metaball system at the specified position.
	 */
	private function stepToEdge(seeker:Vector2D):Float
	{
		var force:Float = fieldStrength(seeker), stepsize:Float;
		
		// Calc stepsize for seeker from force & normal, with a small offset to avoid 
		// a Zeno paradox
		stepsize = Math.pow(minstrength / threshold, 1 / gooieness) - Math.pow(minstrength / force, 1 / gooieness) + 0.01;
		
		// Add the stepsize to the seeker in the direction of the normal.
		seeker.add(fieldNormal(seeker).multiply(stepsize));
		
		return force;
	}
	
	/**
	 * Calculate the metaball field strength at a point.
	 * @param	v			The position to find the field strength at.
	 * @return	Number		The field strength.
	 */
	private function fieldStrength(v:Vector2D):Float
	{
		var force:Float = 0.0;
		
		for (metaball in _metaballs)
		{
			force += metaball.strengthAt(v, gooieness);
		}
		
		return force;
	}
	
	/**
	 * Calculate the metaball field normal at a point.
	 * @param	v	The position to find the normal vector from.
	 * @return	The normalized field Array
	 */
	private function fieldNormal(v:Vector2D):Vector2D
	{
		var force:Vector2D = new Vector2D(), radius:Vector2D;
		
		for  ( metaball in _metaballs)
		{
			radius = Vector2D.subtractVectors(metaball.position, v);
			
			if (radius.lengthSq == 0)
				continue;
			
			radius.multiply(-gooieness * metaball.strength * (1 / Math.pow(radius.lengthSq, (2 + gooieness) * 0.5)));
			
			force.add(radius);
		}
		
		return force.norm();
	}
	
	/**
	 * Second-order Runge-Kutta integration.
	 * @param	v	The vector to integrate on.
	 * @param	h	The velocity or stepsize to integrate with.
	 */
	private function rk2(v:Vector2D, h:Float)
	{
		var t1:Vector2D = fieldNormal(v).perpLeft;
		t1.multiply(h * 0.5);
		
		var t2:Vector2D = fieldNormal(Vector2D.addVectors(v, t1)).perpLeft;
		t2.multiply(h);
		
		v.add(t2);
	}
}
