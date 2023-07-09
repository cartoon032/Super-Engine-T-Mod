package;


import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.FlxObject;
import flixel.FlxBasic;
import Overlay.Console;
import se.extensions.flixel.FlxSpriteLockScale;

import flixel.group.FlxGroup.FlxTypedGroup;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	public var curStep:Int = 0;
	public var curStepProgress:Float = 0;
	public var curBeat:Int = 0;
	private var controls(get, never):Controls;
	var forceQuit = true;
	public static var instance:MusicBeatState;

	var loading = true;
	public function onFileDrop(file:String):Null<Bool>{
		return true;
	}
	var mouseEnabledTmr:FlxTimer;
	override function onFocus() {
		super.onFocus();
		CoolUtil.setFramerate(true);
		mouseEnabledTmr = new FlxTimer().start(0.25,function(_){FlxG.mouse.enabled = true;});
	}
	override function onFocusLost(){
		super.onFocusLost();
		CoolUtil.setFramerate(24,false,true);
		if(mouseEnabledTmr != null)mouseEnabledTmr.cancel();
		FlxG.mouse.enabled = false;
	}
	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
	override function create()
	{
		CoolUtil.setFramerate(true);

		instance = this;
		super.create();

		tranIn();
	}
	
	var tempMessBacking:FlxSprite;
	var tempMessage:FlxText;
	var tempMessTimer:FlxTimer;
	public function showTempmessage(str:String,?color:FlxColor = FlxColor.LIME,?time = 5,?center:Bool = true,?trac:Bool = true){
		if (tempMessage != null){
			remove(tempMessage);
			tempMessage.destroy();

		}
		if (tempMessage != null && tempMessTimer != null){
			tempMessTimer.cancel();}
		if(tempMessBacking != null){
			remove(tempMessBacking);
			tempMessBacking.destroy();
		}
		if(trac) trace(str);
		tempMessage = new FlxText(40,60,1000,str,24);
		tempMessage.setFormat(CoolUtil.font, 24, color, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		tempMessage.scrollFactor.set();
		tempMessage.autoSize = false;
		tempMessage.width = 1280;
		tempMessage.height = 720;
		tempMessage.textField.width = 1280;
		tempMessage.textField.height = 720;
		if(center){
			tempMessage.alignment = CENTER;
			tempMessage.screenCenter(X);
		}
		// tempMessage.wordWrap = false;
		tempMessBacking = new FlxSprite(tempMessage.x - 2,tempMessage.y - 2).loadGraphic(FlxGraphic.fromRectangle(Std.int(tempMessage.width + 4),Std.int(tempMessage.height + 4),0xaa000000));
		tempMessBacking.scrollFactor.set();
		if(FlxG.cameras.list[FlxG.cameras.list.length - 1] != null){
			tempMessBacking.cameras = tempMessage.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}
		add(tempMessBacking);
		add(tempMessage);
		tempMessTimer = new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			if (tempMessage != null) tempMessage.destroy();
			if (tempMessBacking != null) tempMessBacking.destroy();
		},1);
	}

	var skippedFrames = 0;
	var checkInputFocus:Bool = true;
	var hasTextInputFocus = false;
	public var toggleVolKeys:Bool = true; 
	public function onTextInputFocus(object:Dynamic){
		if(toggleVolKeys) CoolUtil.toggleVolKeys(false);
	}
	public function onTextInputUnfocus(object:Dynamic){
		if(toggleVolKeys) CoolUtil.toggleVolKeys(true);
	}

	// public var UIElements:Array<Dynamic> = [];
	public var uiMap:Map<String,Dynamic> = new Map<String,Dynamic>(); 
	inline function clearUIMap(){
		for (i => v in uiMap){
			if (v != null && v.destroy != null) v.destroy();
			uiMap[i] = null;
		}
	}
	// Have to keep track of steps, else they'll try to hit multiple times
	var oldBeat:Int = -10000;
	var oldStep:Int = -10000;
	override function update(elapsed:Float)
	{
		updateCurStep();
		updateBeat();
		if(FlxG.keys.justPressed.F3){
			var mess = 'Global Mouse pos: ${FlxG.mouse.x},${FlxG.mouse.y}; Screen mouse pos: ${FlxG.mouse.screenX},${FlxG.mouse.screenY}; member count: ${members.length}'; 
			// trace(mess);
			showTempmessage(mess);
		}

		if (oldStep != curStep && curStep > 0){
			oldStep = curStep;
			stepHit();
		}
		if(FlxG.mouse.justPressed && checkInputFocus && FlxG.mouse.visible){
			var hasPressed = false;

			var i:Int = 0;
			var obj:Dynamic = null;
			try{

				forEach(function(basic:Dynamic){
					try{

						if(!Std.isOfType(basic,flixel.addons.ui.FlxUITabMenu) && !Std.isOfType(basic,flixel.addons.ui.FlxUI) && Reflect.field(basic,"HasFocus") != null && Reflect.field(basic,"HasFocus")){
							obj = basic;
							hasPressed = true;
						}
					}catch(e){trace('oh no i errored while checking for a item');}
				},true);
				if(!hasPressed){
					for (i => obj in uiMap){
						if(obj != null && Reflect.field(obj,"HasFocus") != null && Reflect.field(obj,"HasFocus")) hasPressed = true; break;
					}
					
				}
			}catch(e){trace('oh no i errored while checking for a item');}

			// while (i < length)
			// {
			// 	basic = members[i++];

			// 	if (basic != null)
			// 	{
					
			// 	}
			// }
			if(hasTextInputFocus != hasPressed){
				hasTextInputFocus = hasPressed;
				if(hasPressed) onTextInputFocus(obj);
				else onTextInputUnfocus(obj);

			}
		}
		if(FlxG.save.data.animDebug){
			Overlay.debugVar = '\nBPM:${Conductor.bpm}/${HelperFunctions.truncateFloat(Conductor.crochet,2)}MS(S:${HelperFunctions.truncateFloat(Conductor.stepCrochet,2)}MS)\ncurBeat:${curBeat}\ncurStep:${curStep}';
		}

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		lastBeat = curStep;
		curBeat = Math.floor(curStep / 4);
	}

	public static var currentColor = 0;

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
			else break;
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
		// var prog = Math.floor(Conductor.offset + Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet; // wtf is this for super?
		// curStepProgress = prog % 1;
		// curStep = lastChange.stepTime + Math.floor(prog);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0 && oldBeat != curBeat){
			oldBeat = curBeat;
			beatHit();
		}
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
	
	public function fancyOpenURL(schmancy:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [schmancy, "&"]);
		#else
		FlxG.openURL(schmancy);
		#end
	}
	override function switchTo(nextState:FlxState):Bool{
		tranOut();
		FlxG.mouse.visible = false;
		FlxG.mouse.enabled = true;
		return super.switchTo(nextState);
	}

	function tranIn(){ // Replace with empty functions to disable
		var oldX = FlxG.camera.x;
		FlxG.camera.x -= 300;
		FlxTween.tween(FlxG.camera, {x:oldX},0.7,{ease: FlxEase.expoOut});
		var oldZoom = FlxG.camera.zoom;
		FlxG.camera.zoom += 1;
		FlxTween.tween(FlxG.camera, {zoom:oldZoom},0.7,{ease: FlxEase.expoOut});
		LoadingScreen.hide();
	}
	function tranOut(){
		// active = false;
		if(loading) LoadingScreen.show();
		FlxTween.tween(FlxG.camera, {x:FlxG.width},0.9,{ease: FlxEase.expoIn});
		FlxTween.tween(FlxG.camera, {zoom:2},1,{ease: FlxEase.expoIn});
	}


	public var debugMode:Bool = false;
	public var debugOverlay:DebugOverlay;
	override function tryUpdate(elapsed:Float):Void
	{
		if(FlxG.keys.justPressed.F1 && forceQuit){
			Console.showConsole = false;
			MainMenuState.handleError("Manually triggered force exit");
		}
		if(Console.showConsole && onlinemod.OnlinePlayMenuState.socket == null ) return;
		if(FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.F8 && onlinemod.OnlinePlayMenuState.socket == null){
			debugMode = !debugMode;
			if(debugMode){
				debugOverlay = new DebugOverlay(this);
			}else{
				debugOverlay.destroy();
			}
		}
		if(debugMode)
			debugOverlay.update(elapsed);
		else if ((persistentUpdate || subState == null))
			update(elapsed);

		if (_requestSubStateReset)
		{
			_requestSubStateReset = false;
			resetSubState();
		}
		if (subState != null)
		{
			subState.tryUpdate(elapsed);
		}
	}


	override function draw(){
		super.draw();
		if(debugMode) debugOverlay.draw();
	}
}

class DebugOverlay extends FlxTypedGroup<FlxSprite>{
	var bg:FlxSprite;
	override public function new(parent:MusicBeatState){
		mouseEnabled = FlxG.mouse.visible;
		this.parent = parent;
		FlxG.mouse.visible = true;
		super();
		MusicBeatState.instance.showTempmessage('Enabled Debug overlay');
		if(objectPosText == null){
			objectPosText = new FlxText(0,-100,'X:2000,Y:2000');
			objectPosText.setFormat(null, 16, 0xffffaaff, CENTER);
			// objectPosText.setBorderStyle(FlxTextBorderStyle.OUTLINE,FlxColor.BLACK,2,);
			objectPosText.scrollFactor.set();
		}
		if(objectPosBack == null){
			objectPosBack = new FlxSpriteLockScale(-10,-100);
			objectPosBack.makeGraphic(1,1,FlxColor.BLACK);
			objectPosBack.lockGraphicSize((Std.int(objectPosText.width) + 4),Std.int(objectPosText.height) + 4);
			objectPosBack.alpha = 0.4;
			objectPosBack.scrollFactor.set();
		}
		add(objectPosBack);
		add(objectPosText);
		objectPosBack.visible = objectPosText.visible = false;
	}
	var parent:MusicBeatState;
	var obj:FlxObject;
	var ox:Float = 0;
	var oy:Float = 0;
	var mx:Float = 0;
	var my:Float = 0;
	var mouseEnabled:Bool = false;
	var objectPosText:FlxText;
	var objectPosBack:FlxSpriteLockScale;
	function getTopObject():Dynamic{
		var id = parent.members.length - 1;
		while (id >= 0 && obj == null) {
			try{
				var _ob:Dynamic = parent.members[id];
				if(_ob != null && FlxG.mouse.overlaps(_ob)){
					if(!FlxG.keys.pressed.SHIFT && _ob.members != null){
						var _id:Int = Std.int(_ob.members.length-1);
						var _inob:Dynamic = null;
						while (_id >= 0 && obj == null) {
							try{
								_inob = _ob.members[_id];
								_id--;
								if(_inob != null  && FlxG.mouse.overlaps(_inob)){
									obj = cast (_inob,FlxSprite);
									break;
								}
							}catch(e){obj = null;}
						}

						if(obj != null && !FlxG.keys.pressed.CONTROL) return obj;
					}else{
						obj = cast (_ob,FlxSprite);
						if(obj != null && !FlxG.keys.pressed.CONTROL) return obj;
					}
					// trace('Funni click on ${obj}');
						// break;
				}

			}catch(e){obj = null;}
			id--;
		}
		return obj;
	}
	override function update(el:Float){
		super.update(el);
		if(FlxG.mouse.justPressed){
			mx=FlxG.mouse.x;
			my=FlxG.mouse.y;
			obj = getTopObject();
			if(obj != null){
				ox=obj.x;
				oy=obj.y;
			}
			
		}else if (FlxG.mouse.pressed && obj != null){
			// if(!FlxG.keys.pressed.SHIFT){
			obj.x = ox - mx + FlxG.mouse.x;
			obj.y = oy - my + FlxG.mouse.y;
			updateObjPosText();
			

			// }
			// MusicBeatState.instance.showTempmessage('Obj pos: ${obj.x},${obj.y}');

			if(FlxG.mouse.wheel != 0) obj.angle += FlxG.mouse.wheel;

		}else if( FlxG.keys.pressed.ALT #if(!windows) || FlxG.keys.pressed.MENU #end){
			obj = getTopObject();
			updateObjPosText();
			
			objectPosBack.visible = objectPosText.visible = false;
		
		}else if(obj != null){
			obj = null;
			objectPosBack.visible = objectPosText.visible = false;
		}
	}
	@:keep inline function updateObjPosText(){
		objectPosBack.visible = objectPosText.visible = true;
		objectPosText.text = '${Std.int(obj.x * 100) * 0.001},${Std.int(obj.y * 100) * 0.001}';
		objectPosBack.x = (objectPosText.x = FlxG.mouse.screenX + 20) - 2;
		objectPosBack.y = (objectPosText.y = FlxG.mouse.screenY + 20) - 2;
		objectPosBack.lockGraphicSize((Std.int(objectPosText.width) + 4),Std.int(objectPosText.height) + 4);
	}
	override function destroy(){
		FlxG.mouse.visible = mouseEnabled;

		super.destroy();
		MusicBeatState.instance.showTempmessage('Exited Debug overlay');
	}
}