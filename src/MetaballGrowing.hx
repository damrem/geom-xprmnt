package;
import com.metaballdemo.core.Metaball;
import com.metaballdemo.core.MetaballManager;
import com.metaballdemo.util.Vector2D;
import openfl.display.GraphicsSolidFill;
import openfl.display.GraphicsStroke;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;

/**
 * ...
 * @author damrem
 */
class MetaballGrowing extends Sprite
{
	var outlineCanvas:Sprite;
	var fillCanvas:Sprite;
	var manager:MetaballManager;
	var stroke:openfl.display.GraphicsStroke;
	var fill:openfl.display.GraphicsSolidFill;
	var isOutlineMousedDown:Bool;
	var isFillMousedDown:Bool;
	
	public function new() 
	{
		super();
		outlineCanvas = new Sprite();
		fillCanvas = new Sprite();
		addChild(fillCanvas);
		addChild(outlineCanvas);
		
		manager = MetaballManager.getInstance();
		
		manager.addMetaball(new Metaball(new Vector2D(Lib.current.stage.stageWidth / 2, Lib.current.stage.stageHeight / 2), 1));
		
		stroke = new GraphicsStroke(6.5, false, "normal", "none", "round", 3, new GraphicsSolidFill(0x00CCFF));
		fill = new GraphicsSolidFill(0xF0F0F0);
		
		addEventListener(Event.ENTER_FRAME, update);
		
		outlineCanvas.addEventListener(MouseEvent.MOUSE_OVER, hoverOutline);
		outlineCanvas.addEventListener(MouseEvent.MOUSE_OUT, leaveOutline);
		outlineCanvas.addEventListener(MouseEvent.MOUSE_DOWN, downOutline);
		outlineCanvas.addEventListener(MouseEvent.MOUSE_DOWN, upOutline);
		
		fillCanvas.addEventListener(MouseEvent.MOUSE_DOWN, downFill);
		fillCanvas.addEventListener(MouseEvent.MOUSE_UP, upFill);
	}
	
	private function upFill(e:MouseEvent):Void 
	{
		isFillMousedDown = false;
	}
	
	private function downFill(e:MouseEvent):Void 
	{
		isFillMousedDown = true;
	}
	
	private function upOutline(e:MouseEvent):Void 
	{
		isOutlineMousedDown = false;
	}
	
	private function downOutline(e:MouseEvent):Void 
	{
		isOutlineMousedDown = true;
		var newMetaball = new Metaball(new Vector2D(e.localX, e.localY), 1);
		manager.addMetaball(newMetaball);
	}
	
	private function hoverOutline(e:MouseEvent):Void 
	{
		outlineCanvas.alpha = 0.5;
	}
	
	private function leaveOutline(e:MouseEvent):Void 
	{
		outlineCanvas.alpha = 1.0;
	}
	
	private function update(e:Event):Void 
	{
		manager.freeze();
		outlineCanvas.graphics.clear();
		fillCanvas.graphics.clear();
		fillCanvas.graphics.drawGraphicsData([fill, manager.outline]);
		outlineCanvas.graphics.drawGraphicsData([stroke, manager.outline]);
		
		if (isOutlineMousedDown)
		{
			
		}
	}
	
}