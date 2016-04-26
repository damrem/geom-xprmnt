package com.flashdynamix.utils;
import flash.display.*;
import flash.events.*;
//import flash.net.LocalConnection;
import flash.system.System;
import flash.ui.*;
import flash.utils.*;	

/**
 * @author shanem
 */
class SWFProfiler {
	private static var itvTime : Int;
	private static var initTime : Int;
	private static var currentTime : Int;
	private static var frameCount : Int;
	private static var totalCount : Int;

	public static var minFps : Float;
	public static var maxFps : Float;
	public static var minMem : Float;
	public static var maxMem : Float;
	public static var history : Int = 60;
	public static var fpsList : Array<Dynamic> = [];
	public static var memList : Array<Dynamic> = [];

	private static var displayed : Bool = false;
	private static var started : Bool = false;
	private static var inited : Bool = false;
	private static var frame : Sprite;
	private static var stage : Stage;
	private static var content : ProfilerContent;
	//private static var ci : ContextMenuItem;

	public static function init(swf : Stage, context : InteractiveObject)  {
		if(inited) return;
		
		inited = true;
		stage = swf;
		
		content = new ProfilerContent();
		frame = new Sprite();
		
		minFps = 1.79769313486231e+308;
		maxFps = -1.79769313486231e+308;
		minMem = 1.79769313486231e+308;
		maxMem = -1.79769313486231e+308;
		
		var cm : ContextMenu = new ContextMenu();
		cm.hideBuiltInItems();
		ci = new ContextMenuItem("Show Profiler", true);
		addEvent(ci, ContextMenuEvent.MENU_ITEM_SELECT, onSelect);
		cm.customItems = [ci];
		context.contextMenu = cm;
		
		start();
	}

	public static function start()  {
		if(started) return;
		
		started = true;
		initTime = itvTime = getTimer();
		totalCount = frameCount = 0;
		
		addEvent(frame, Event.ENTER_FRAME, draw);
	}

	public static function stop()  {
		if(!started) return;
		
		started = false;
		
		removeEvent(frame, Event.ENTER_FRAME, draw);
	}

	public static function gc()  {
		/*try {
			new LocalConnection().connect('foo');
			new LocalConnection().connect('foo');
		} catch (e : Error) {
		}*/
	}

	public static function get_currentFps() : Float {
		return frameCount / intervalTime;
	}

	public static function get_currentMem() : Float {
		return (System.totalMemory / 1024) / 1000;
	}

	public static function get_averageFps() : Float {
		return totalCount / runningTime;
	}

	private static function get_runningTime() : Float {
		return (currentTime - initTime) / 1000;
	}

	private static function get_intervalTime() : Float {
		return (currentTime - itvTime) / 1000;
	}

	
	private static function onSelect(e : ContextMenuEvent)  {
		if(!displayed) {
			show();
		} else {
			hide();
		}
	}

	private static function show()  {
		ci.caption = "Hide Profiler";
		displayed = true;
		addEvent(stage, Event.RESIZE, resize);
		stage.addChild(content);
		updateDisplay();
	}

	private static function hide()  {
		ci.caption = "Show Profiler";
		displayed = false;
		removeEvent(stage, Event.RESIZE, resize);
		stage.removeChild(content);
	}
	
	private static function resize(e:Event)  {
		content.update(runningTime, minFps, maxFps, minMem, maxMem, currentFps, currentMem, averageFps, fpsList, memList, history);
	}
	
	private static function draw(e : Event)  {
		currentTime = getTimer();
		
		frameCount++;
		totalCount++;

		if(intervalTime >= 1) {
			if(displayed) {
				updateDisplay();
			} else {
				updateMinMax();
			}
			
			fpsList.unshift(currentFps);
			memList.unshift(currentMem);
			
			if(fpsList.length > history) fpsList.pop();
			if(memList.length > history) memList.pop();
			
			itvTime = currentTime;
			frameCount = 0;
		}
	}

	private static function updateDisplay()  {
		updateMinMax();
		content.update(runningTime, minFps, maxFps, minMem, maxMem, currentFps, currentMem, averageFps, fpsList, memList, history);
	}

	private static function updateMinMax()  {
		minFps = Math.min(currentFps, minFps);
		maxFps = Math.max(currentFps, maxFps);
			
		minMem = Math.min(currentMem, minMem);
		maxMem = Math.max(currentMem, maxMem);
	}

	private static function addEvent(item : EventDispatcher, type : String, listener : Event->Void)  {
		item.addEventListener(type, listener, false, 0, true);
	}

	private static function removeEvent(item : EventDispatcher, type : String, listener : Event->Void)  {
		item.removeEventListener(type, listener);
	}
}



