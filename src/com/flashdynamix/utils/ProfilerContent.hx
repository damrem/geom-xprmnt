package com.flashdynamix.utils;

import flash.display.*;
import flash.events.Event;
import flash.text.*;

class ProfilerContent extends Sprite {

	private var minFpsTxtBx : TextField;
	private var maxFpsTxtBx : TextField;
	private var minMemTxtBx : TextField;
	private var maxMemTxtBx : TextField;
	private var infoTxtBx : TextField;
	private var box : Shape;
	private var fps : Shape;
	private var mb : Shape;

	public function new()  {
		fps = new Shape();
		mb = new Shape();
		box = new Shape();
			
		this.mouseChildren = false;
		this.mouseEnabled = false;
			
		fps.x = 65;
		fps.y = 45;	
		mb.x = 65;
		mb.y = 90;
			
		var tf : TextFormat = new TextFormat("_sans", 9, 0xAAAAAA);
			
		infoTxtBx = new TextField();
		infoTxtBx.autoSize = TextFieldAutoSize.LEFT;
		infoTxtBx.defaultTextFormat = new TextFormat("_sans", 11, 0xCCCCCC);
		infoTxtBx.y = 98;
			
		minFpsTxtBx = new TextField();
		minFpsTxtBx.autoSize = TextFieldAutoSize.LEFT;
		minFpsTxtBx.defaultTextFormat = tf;
		minFpsTxtBx.x = 7;
		minFpsTxtBx.y = 37;
			
		maxFpsTxtBx = new TextField();
		maxFpsTxtBx.autoSize = TextFieldAutoSize.LEFT;
		maxFpsTxtBx.defaultTextFormat = tf;
		maxFpsTxtBx.x = 7;
		maxFpsTxtBx.y = 5;
			
		minMemTxtBx = new TextField();
		minMemTxtBx.autoSize = TextFieldAutoSize.LEFT;
		minMemTxtBx.defaultTextFormat = tf;
		minMemTxtBx.x = 7;
		minMemTxtBx.y = 83;
			
		maxMemTxtBx = new TextField();
		maxMemTxtBx.autoSize = TextFieldAutoSize.LEFT;
		maxMemTxtBx.defaultTextFormat = tf;
		maxMemTxtBx.x = 7;
		maxMemTxtBx.y = 50;
			
		addChild(box);
		addChild(infoTxtBx);
		addChild(minFpsTxtBx);
		addChild(maxFpsTxtBx);
		addChild(minMemTxtBx);
		addChild(maxMemTxtBx);
		addChild(fps);
		addChild(mb);
		
		this.addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
	}

	public function update(runningTime : Float, minFps : Float, maxFps : Float, minMem : Float, maxMem : Float, currentFps : Float, currentMem : Float, averageFps : Float, fpsList : Array, memList : Array, history : Int)  {
		if(runningTime >= 1) {
			minFpsTxtBx.text = minFps.toFixed(3) + " Fps";
			maxFpsTxtBx.text = maxFps.toFixed(3) + " Fps";
			minMemTxtBx.text = minMem.toFixed(3) + " Mb";
			maxMemTxtBx.text = maxMem.toFixed(3) + " Mb";
		}
			
		infoTxtBx.text = "Current Fps " + currentFps.toFixed(3) + "   |   Average Fps " + averageFps.toFixed(3) + "   |   Memory Used " + currentMem.toFixed(3) + " Mb";
		infoTxtBx.x = stage.stageWidth - infoTxtBx.width - 20;
		
		var vec : Graphics = fps.graphics;
		vec.clear();
		vec.lineStyle(1, 0x33FF00, 0.7);
			
		var i : Int = 0;
		var len : Int = fpsList.length;
		var height : Int = 35;
		var width : Int = stage.stageWidth - 80;
		var inc : Float = width / (history - 1);
		var rateRange : Float = maxFps - minFps;
		var value : Float;
			
		for(i in 0...len) {
			value = (fpsList[i] - minFps) / rateRange;
			if(i == 0) {
				vec.moveTo(0, -value * height);
			} else {
				vec.lineTo(i * inc, -value * height);
			}
		}
			
		vec = mb.graphics;
		vec.clear();
		vec.lineStyle(1, 0x0066FF, 0.7);
			
		i = 0;
		len = memList.length;
		rateRange = maxMem - minMem;
		for(i in 0...len) {
			value = (memList[i] - minMem) / rateRange;
			if(i == 0) {
				vec.moveTo(0, -value * height);
			} else {
				vec.lineTo(i * inc, -value * height);
			}
		}
	}

	private function added(e : Event)  {
		resize();
		stage.addEventListener(Event.RESIZE, resize, false, 0, true);
	}

	private function removed(e : Event)  {
		stage.removeEventListener(Event.RESIZE, resize);
	}

	private function resize(e : Event = null)  {
		var vec : Graphics = box.graphics;
		vec.clear();
		
		vec.beginFill(0x000000, 0.5);
		vec.drawRect(0, 0, stage.stageWidth, 120);
		vec.lineStyle(1, 0xFFFFFF, 0.2);
			
		vec.moveTo(65, 45);
		vec.lineTo(65, 10);
		vec.moveTo(65, 45);
		vec.lineTo(stage.stageWidth - 15, 45);
			
		vec.moveTo(65, 90);
		vec.lineTo(65, 55);
		vec.moveTo(65, 90);
		vec.lineTo(stage.stageWidth - 15, 90);
			
		vec.endFill();
		
		infoTxtBx.x = stage.stageWidth - infoTxtBx.width - 20;
	}
}