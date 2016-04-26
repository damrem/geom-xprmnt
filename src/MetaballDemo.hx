package;

import CheckBox;
import com.metaballdemo.core.*;
import com.metaballdemo.util.*;
import fl.controls.Slider;
import flash.display.BitmapData;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.MovieClip;
import flash.display.Shader;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.filters.ShaderFilter;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
//import fl.controls.CheckBox;



/**
 * This document renders the same metaball system onto several display objects, 
 * and layers them to create a height map. The height map is then passed to a 
 * PixelBender refraction shader.
 */
class MetaballDemo extends MovieClip
{
	// ----------------------------------------------------------------------
	// Members
	// ----------------------------------------------------------------------
	
	// Shader Members
	
	private var loader:URLLoader;
	private var bmd:BitmapData;
	private var refractor:ShaderFilter;
	private var shading:Boolean;
	
	// Display Members
	
	public var background:MovieClip;
	public var ui:MovieClip;
	
	private var canvas:Sprite;
	private var shaderMap:Sprite;
	private var shaderMask:Sprite;
	
	private var blackFill:IGraphicsData;
	private var whiteFill:IGraphicsData;
	
	// Metaball Members
	
	private var target:Metaball;
	private var manager:MetaballManager;
	
	// ----------------------------------------------------------------------
	// Constructor & Initialization
	// ----------------------------------------------------------------------
	
	public function MetaballDemo()
	{
		trace("Initializing.");
		
		//SWFProfiler.init(stage, this);
		
		//// Metaballs ////
		
		target = new Metaball(new Vector2D(stage.mouseX, stage.mouseY), 2);
		
		manager = MetaballManager.getInstance();
		manager.addMetaball(new Metaball(new Vector2D(200, 200), 3));
		manager.addMetaball(new Metaball(new Vector2D(700, 100), 1));
		manager.addMetaball(new Metaball(new Vector2D(650, 240), 4));
		manager.addMetaball(target);
		
		//// Styling & Display ////
		
		canvas = new Sprite();
		canvas.x = 40;
		canvas.y = 40;
		canvas.filters = [ new BlurFilter(16, 16, 2) ];
		
		shaderMap = new Sprite();
		shaderMap.filters = [ new BlurFilter(128, 128, 1) ];
		
		shaderMask = new Sprite();
		
		whiteFill = new GraphicsSolidFill(0xffffff);
		blackFill = new GraphicsSolidFill(0x000000);
		
		shading = true;
		
		canvas.addChild(shaderMap);
		canvas.addChild(shaderMask);
		canvas.mask = shaderMask;
		
		update();
		
		//// Shader Loading ////
		
		loader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, onShaderLoaded);
		loader.load(new URLRequest("../Assets/RefractionShader.pbj"));
		
		//// Event Listeners ////
		
		ui.getChildByName("shader").addEventListener(Event.CHANGE, shadListener);
		ui.getChildByName("masking").addEventListener(Event.CHANGE, maskListener);
		ui.getChildByName("blur").addEventListener(Event.CHANGE, blurListener);
		ui.getChildByName("refraction").addEventListener(Event.CHANGE, refrListener);
		ui.getChildByName("aberration").addEventListener(Event.CHANGE, aberListener);
		
		stage.addEventListener(Event.ACTIVATE, activateListener);
		stage.addEventListener(Event.DEACTIVATE, deactivateListener);
		
		// Deactivate the demo to start with.
		
		stage.frameRate = 0;
		gotoAndStop("nofocus");
	}
	
	// ----------------------------------------------------------------------
	// Input Event Handlers
	// ----------------------------------------------------------------------
	
	private function activateListener(event:Event)
	{
		stage.frameRate = 30;
		gotoAndStop("focus");
	}
	
	private function deactivateListener(event:Event)
	{
		stage.frameRate = 0;
		gotoAndStop("nofocus");
	}
	
	private function shadListener(event:Event)
	{
		trace("Toggling shader.");
		
		shading = cast(ui.getChildByName("shader"), CheckBox).selected;
		
		if (shading) {
			removeChild(canvas);
			addChild(background);
		}
		else {
			removeChild(background);
			addChild(canvas);
		}
	}
	
	private function maskListener(event:Event)
	{
		trace("Toggling masking.");
		
		var value:Boolean = cast(ui.getChildByName("masking"), CheckBox).selected;
		
		if (value) {
			canvas.addChild(shaderMask);
			canvas.mask = shaderMask;
		}
		else {
			canvas.removeChild(shaderMask);
			canvas.mask = null;
		}
	}
	
	private function blurListener(event:Event)
	{
		trace("Toggling blur.");
		
		var value:Boolean = cast(ui.getChildByName("blur"), CheckBox).selected;
		
		if (value) {
			// Supposedly blurring in powers of 2 is more efficient.
			canvas.filters = [ new BlurFilter(16, 16, 2) ];
			shaderMap.filters = [ new BlurFilter(128, 128, 1) ];
		}
		else {
			canvas.filters = [ ];
			shaderMap.filters = [ ];
		}
	}
	
	private function refrListener(event:Event)
	{
		var value:Number = cast(ui.getChildByName("refraction"), Slider).value;
		
		trace("Modifying refraction value to " + value);
		
		refractor.shader.data.refraction.value = [ value ];
	}
	
	private function aberListener(event:Event)
	{
		var value:Number = cast(ui.getChildByName("aberration"), Slider).value;
		
		trace("Modifying aberration value to " + value);
		
		refractor.shader.data.aberration.value = [ value ];
	}
	
	// ----------------------------------------------------------------------
	// Display Event Handlers
	// ----------------------------------------------------------------------
	
	private function update()
	{
		target.position.x = MathUtil.clamp(canvas.mouseX, 50, 750);
		target.position.y = MathUtil.clamp(canvas.mouseY, 50, 350);
		stage.invalidate();
	}
	
	private function efListener(event:Event)
	{
		update();
		
		manager.freeze();
		
		canvas.graphics.clear();
		
		shaderMap.graphics.clear();
		shaderMap.graphics.drawGraphicsData(Array<IGraphicsData>( [ whiteFill, manager.outline ] ));
		
		shaderMask.graphics.clear();
		shaderMask.graphics.drawGraphicsData(Array<IGraphicsData>( [ blackFill, manager.outline ] ));
		
		if (shading) {
			bmd.fillRect(new Rectangle(0, 0, 820, 420), 0x0);
			bmd.draw(canvas);
			
			refractor.shader.data.map.input = bmd;
			background.filters = [ refractor ];
		}
	}
	
	private function onShaderLoaded(event:Event)
	{
		trace("PixelBender filter loaded.");
		
		background.cacheAsBitmap = true;
		canvas.cacheAsBitmap = true;
		
		var shader:Shader = new Shader(loader.data);
		refractor = new ShaderFilter(shader);
		
		bmd = new BitmapData(820, 420, false, 0x000000);
		
		refractor.shader.data.map.input = bmd;
		refractor.shader.data.refraction.value = [-120.0];
		refractor.shader.data.aberration.value = [ -20.0];
		
		stage.addEventListener(Event.ENTER_FRAME, efListener);
	}
}
