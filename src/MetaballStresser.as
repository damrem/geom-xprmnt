package 
{
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.system.System;
	
	import com.flashdynamix.utils.SWFProfiler;
	
	import com.metaballdemo.core.*;
	import com.metaballdemo.util.*;
	
	/**
	 * This document is a simple stress test of the MetaballManager class.
	 */
	public class MetaballStresser extends MovieClip
	{
		// ----------------------------------------------------------------------
		// Members
		// ----------------------------------------------------------------------
		
		// Display Members
		
		private var canvas:Sprite;
		private var stroke:IGraphicsData;
		
		// Metaball Members
		
		private var manager:MetaballManager;
		
		private var metaballs:Vector.<Metaball>;
		private var velocities:Vector.<Vector2D>;
		
		// ----------------------------------------------------------------------
		// Constructor & Initialization
		// ----------------------------------------------------------------------
		
		public function MetaballStresser() 
		{
			trace("Initializing");
			
			SWFProfiler.init(stage, this);
			
			//// Metaballs ////
			
			manager = MetaballManager.getInstance();
			
			metaballs = new Vector.<Metaball>;
			velocities = new Vector.<Vector2D>;
			
			//// Styling & Display ////
			
			canvas = new Sprite();
			addChild(canvas);
			
			stroke = new GraphicsStroke(2.0, false, "normal", "none", "round", 3, new GraphicsSolidFill(0xFFFFFF));
			
			//// Event Listeners ////
			
			stage.addEventListener(Event.ACTIVATE, activateListener);
			stage.addEventListener(Event.DEACTIVATE, deactivateListener);
			stage.addEventListener(Event.ENTER_FRAME, efListener);
			
			// Deactivate the demo to start with.
			
			stage.frameRate = 0;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			
			gotoAndPlay("nofocus");
		}
		
		// ----------------------------------------------------------------------
		// Event Listeners
		// ----------------------------------------------------------------------
		
		private function activateListener(event:Event):void
		{
			stage.frameRate = 30;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			
			gotoAndPlay("focus");
		}
		
		private function deactivateListener(event:Event):void
		{
			stage.frameRate = 0;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			
			gotoAndPlay("nofocus");
		}
		
		private function efListener(event:Event):void
		{
			for (var i:int = 0, n:int = metaballs.length, p:Vector2D, v:Vector2D; i < n; ++i) {
				p = metaballs[i].position;
				v = velocities[i];
				
				p.add(v);
				
				if (p.x < -100 || p.x > stage.stageWidth + 100) v.x *= -1.0;
				
				if (p.y < -100 || p.y > stage.stageHeight + 100) v.y *= -1.0;
			}
			
			if (n > 0) {
				manager.freeze();
				
				canvas.graphics.clear();
				canvas.graphics.drawGraphicsData(Vector.<IGraphicsData>( [ stroke, manager.outline ] ));
			}
		}
		
		private function mouseDownListener(event:Event):void
		{
			var m:Metaball = new Metaball( new Vector2D(stage.mouseX, stage.mouseY), Math.random() * 4.0 + 1.0 );
			
			velocities.push( new Vector2D(Math.random() * 10.0 - 5.0, Math.random() * 10.0 - 5.0) );
			
			metaballs.push(m);
			manager.addMetaball(m);
			
			MetaballManager.maxSteps = metaballs.length * 400;
		}
	}
}