package 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.flashdynamix.utils.SWFProfiler;
	
	import com.metaballdemo.core.*;
	import com.metaballdemo.util.*;
	
	public class MetaballGrapher extends MovieClip
	{
		// ----------------------------------------------------------------------
		// Members
		// ----------------------------------------------------------------------
		
		// Display Members
		
		public var top:Sprite;
		public var left:Sprite;
		private var stroke:IGraphicsData;
		
		// Metaball Members
		
		private var target:Metaball;
		private var manager:MetaballManager;
		private var metaballs:Vector.<Metaball>;
		
		// ----------------------------------------------------------------------
		// Constructor & Initialization
		// ----------------------------------------------------------------------
		
		public function MetaballGrapher()
		{
			SWFProfiler.init(stage, this);
			
			//// Metaballs ////
			
			metaballs = new Vector.<Metaball>();
			metaballs.push(new Metaball( new Vector2D(200.0, 60.0), 1.0 ));
			metaballs.push(new Metaball( new Vector2D(700.0, 60.0), 3.0 ));
			
			target = new Metaball( new Vector2D(400.0, 60.0), 2.0 );
			metaballs.push(target);
			
			manager = MetaballManager.getInstance();
			MetaballManager.resolution = 4;
			
			for each (var m:Metaball in metaballs)
				manager.addMetaball(m);
			
			//// Styling & Display ////
			
			stroke = new GraphicsStroke(2.5, false, "normal", "none", "round", 3, new GraphicsSolidFill(0x00CCFF));
			
			//// Event Listeners ////
			
			stage.addEventListener(Event.ACTIVATE, activateListener);
			stage.addEventListener(Event.DEACTIVATE, deactivateListener);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameListener);
			
			// Deactivate the demo to start with.
			
			stage.frameRate = 0;
			gotoAndPlay("nofocus");
		}
		
		// ----------------------------------------------------------------------
		// Event Listeners
		// ----------------------------------------------------------------------
		
		private function activateListener(event:Event):void
		{
			stage.frameRate = 30;
			gotoAndPlay("focus");
		}
		
		private function deactivateListener(event:Event):void
		{
			stage.frameRate = 0;
			gotoAndPlay("nofocus");
		}
		
		private function mouseMoveListener(event:Event):void
		{
			target.position.x = top.mouseX;
		}
		
		private function enterFrameListener(event:Event):void
		{
			// Graph the stength of metaball field along the y-axis.
			
			left.graphics.clear();
			left.graphics.lineStyle(1.6, 0x0, 0.5);
			
			for (var i:int = 0, n:int = 820, s:Number, v:Vector2D; i <= n; i += 2)
			{
				// The position in the field we are evaluating.
				v = new Vector2D(i, 60.0);
				
				s = 0.0;
				
				// Accumulate the strength of the field at that position.
				for each (var m:Metaball in metaballs)
					s += m.strengthAt(v, 2.0);
				
				if (i > 0)
					// Graph the strength on the y-axis.
					left.graphics.lineTo( i, 140 - (s * 100000.0) );
				else
					left.graphics.moveTo( i, 140 - (s * 100000.0) );
			}
			
			// Render the metaball system.
			
			manager.freeze();
			
			top.graphics.clear();
			top.graphics.drawGraphicsData( Vector.<IGraphicsData>( [ stroke, manager.outline ] ) );
		}
	}
}