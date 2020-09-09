package menu;

import Main;
import openfl.system.System;
import openfl.Lib;

/**
 * ...
 * @author Victor Reynolds
 */
class DebugPage extends MenuPage 
{
	var counter:MenuElement;
	var consolemsg:MenuElement;
	var prevfpsdisplay:MenuElement;
	var timedisplay:MenuElement;
	var startseconds:Float;
	
	public static var entcount:Int = 0;
	public static var tilecount:Int = 0;
	
	static var logmsg:Array<String>;
	static var maxLog:Int = 6;
	static var msgPersist:Int = 600;
	static var logHead:Int = 0;
	static var msgDecay:Array<Float>;
	
	public function new() 
	{
		super();
		
		counter = new MenuElement();
		counter.AddText("FPS: 0", "fonts/pirulen.ttf", 12, 0xaabb55);
		counter.xpos = 0;
		counter.ypos = 0;
		Add(counter);
		
		consolemsg = new MenuElement();
		consolemsg.AddText("", "fonts/pirulen.ttf", 12, 0xaabb55, "right");
		consolemsg.xpos = 0.88;
		consolemsg.ypos = 0;
		Add(consolemsg);
		
		prevfpsdisplay = new MenuElement();
		prevfpsdisplay.AddText("", "fonts/unispace.ttf", 8, 0xaabb55);
		prevfpsdisplay.xpos = 0.2;
		prevfpsdisplay.ypos = 0.88;
		Add(prevfpsdisplay);
		
		timedisplay = new MenuElement();
		timedisplay.AddText("", "fonts/unispace.ttf", 8, 0xaabb55, "center");
		timedisplay.xpos = 0.4;
		timedisplay.ypos = 0.11;
		Add(timedisplay);
		
		logmsg = new Array<String>();
		msgDecay = new Array<Float>();
		for (i in 0...maxLog)
		{
			logmsg.push("");
			msgDecay.push(0);
		}
		
		super.Update();
		
		startseconds = Date.now().getTime();
	}
	
	public override function Update()
	{
		super.Update();
		
		//counter.textField.text = "fps: " + Main.fps;
		counter.textField.text = "fps: " + Math.round(Main.fps * 100) / 100;
		counter.textField.text += "\nents: " + entcount;
		counter.textField.text += "\ntiles: " + tilecount;
		counter.textField.text += "\nmem: " + Math.floor(System.totalMemory / 1000000.0);
		
		for (j in 0...msgDecay.length)
		{
			if (msgDecay[j] > 0)
			{
				msgDecay[j] -= 1;
			}
		}
		
		var msgPointer:Int = logHead + 1;
		if (msgPointer >= logmsg.length) msgPointer = 0;
		
		consolemsg.textField.text = "";
		
		for (i in 0...logmsg.length)
		{
			if (msgDecay[msgPointer] > 0) consolemsg.textField.text += logmsg[msgPointer] + "\n";
			
			if (msgPointer == logHead) break;
			
			msgPointer += 1;
			if (msgPointer >= logmsg.length) msgPointer = 0;
		}
		
		/*
		prevfpsdisplay.textField.text = "";
		
		for (k in 0...Main.prevFPS.length)
		{
			var num = Math.round(Main.prevFPS[k]);
			var padding = 0;
			if (num < 10)
				prevfpsdisplay.textField.text += "[_" + num + "_]";
			else if (num < 100)
				prevfpsdisplay.textField.text += "[_" + num + "]";
			else
				prevfpsdisplay.textField.text += "[" + num + "]";
			
			if (k == 29)
			{
				prevfpsdisplay.textField.text += "\n";
			}
		}
		*/		
		//timedisplay.textField.text = "sec: " + Math.round(Lib.getTimer() / 1000) + " other sec: " + Math.round((Date.now().getTime() - startseconds) / 1000);
	}
	
	public static function Log(msg:String)
	{
		logHead += 1;
		if (logHead >= logmsg.length)
		{
			logHead = 0;
		}
		logmsg[logHead] = msg;
		msgDecay[logHead] = msgPersist;
	}
}