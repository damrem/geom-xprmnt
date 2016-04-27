package;
import com.metaballdemo.core.Metaball;
import com.metaballdemo.core.MetaballManager;
import com.metaballdemo.util.MathUtil;
import com.metaballdemo.util.Vector2D;
import openfl.display.GraphicsSolidFill;
import openfl.display.GraphicsStroke;
import openfl.display.IGraphicsData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;




/**
 * This document demonstrates a unique benefit of a vector-based metaball
 * renderer. A "car" races around the line created by the metaball system.
 */
class MetaballRacetrack extends Sprite
{
	// ----------------------------------------------------------------------
	// Members
	// ----------------------------------------------------------------------
	
	// Display Members
	
	private var canvas:Sprite;
	private var car:Sprite;
	
	private var stroke:IGraphicsData;
	private var fill:IGraphicsData;
	
	private var percent:Float;
	
	// Metaball Members
	
	private var manager:MetaballManager;
	private var target:Metaball;
	
	// ----------------------------------------------------------------------
	// Constructor & Initialization
	// ----------------------------------------------------------------------
	
	public function new() 
	{
		super();
		trace("Initializing");
		
		//SWFProfiler.init(stage, this);
		
		//// Metaballs ////
		
		MetaballManager.resolution = 4.0;
		
		target = new Metaball( new Vector2D(400.0, 60.0), 2.0 );
		
		manager = MetaballManager.getInstance();
		manager.addMetaball(new Metaball( new Vector2D(600.0, 200.0), 4.0 ));
		manager.addMetaball(new Metaball( new Vector2D(300.0, 200.0), 4.0 ));
		manager.addMetaball(new Metaball( new Vector2D(450.0, 150.0), 1.0 ));
		manager.addMetaball(target);
		
		//// Styling & Display ////
		
		canvas = new Sprite();
		addChild(canvas);
		
		car = new Sprite();
		car.graphics.beginFill(0x00708C);
		car.graphics.drawCircle(0, 0, 6.0);
		car.graphics.endFill();
		addChild(car);
		
		stroke = new GraphicsStroke(6.5, false, "normal", "none", "round", 3, new GraphicsSolidFill(0x00CCFF));
		fill = new GraphicsSolidFill(0xF0F0F0);
		
		percent = 0;
		
		//// Event Listeners ////
		
		Lib.current.stage.addEventListener(Event.ACTIVATE, activateListener);
		Lib.current.stage.addEventListener(Event.DEACTIVATE, deactivateListener);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, efListener);
		
		// Deactivate the demo to start with.
		
		Lib.current.stage.frameRate = 30;
		//gotoAndStop("nofocus");
	}
	
	// ----------------------------------------------------------------------
	// Event Listeners
	// ----------------------------------------------------------------------
	
	private function activateListener(event:Event)
	{
		stage.frameRate = 30;
		//gotoAndStop("focus");
	}
	
	private function deactivateListener(event:Event)
	{
		stage.frameRate = 0;
		//gotoAndStop("nofocus");
	}
	
	private function efListener(event:Event)
	{
		// Update the target metaball.
		
		target.position.x = MathUtil.clamp(canvas.mouseX, 100, 800);
		target.position.y = MathUtil.clamp(canvas.mouseY, 100, 300);
		
		// Draw the track.
		
		manager.freeze();
		
		canvas.graphics.clear();
		canvas.graphics.drawGraphicsData(/*cast( */[ stroke, fill, manager.outline ] /*, Vector<IGraphicsData>)*/);
		
		// Move the car along the track.
		
		percent = (percent >= 1.0) ? 0.0 : (percent + 0.01);
		//trace(manager.outline.data);
		var n = manager.outline.data.length;
		var i = Std.int(percent * n);
		
		car.x = manager.outline.data[ ( (i % 2)!=0 ? (i + 1) : i ) % n ];
		car.y = manager.outline.data[ ( (i % 2)!=0 ? i : (i + 1) ) % n ];
	}
}
