package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String { return throw "stub!"; };
	
	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
	public function left():Bool { return throw "stub!"; }
	public function right():Bool { return throw "stub!"; }
}



class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
		description = 'Change your controls';
		acceptValues = true;
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new KeyBindMenu());
		return false;
	}
	override function right():Bool {
		return false;
	}
	override function left():Bool {
		return false;
	}
	override function getValue():String {
		return KeyBindMenu.getKeyBindsString();
	}
	private override function updateDisplay():String
	{
		return "Key Bindings";
	}
}

class CpuStrums extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.cpuStrums = !FlxG.save.data.cpuStrums;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.cpuStrums ? "Light CPU Strums" : "CPU Strums stay static";
	}

}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class GhostTapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.ghost = !FlxG.save.data.ghost;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.ghost ? "Ghost Tapping" : "No Ghost Tapping";
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
	}
}

class SongPositionOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Song Position " + (!FlxG.save.data.songPosition ? "off" : "on");
	}
}

class DistractionsAndEffectsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.distractions = !FlxG.save.data.distractions;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Distractions " + (!FlxG.save.data.distractions ? "off" : "on");
	}
}

class ResetButtonOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.resetButton = !FlxG.save.data.resetButton;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Reset Button " + (!FlxG.save.data.resetButton ? "off" : "on");
	}
}

class FlashingLightsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.flashing = !FlxG.save.data.flashing;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Flashing Lights " + (!FlxG.save.data.flashing ? "off" : "on");
	}
}

class Judgement extends Option
{
	

	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}
	
	public override function press():Bool
	{
		return true;
	}

	private override function updateDisplay():String
	{
		return "Safe Frames";
	}

	override function left():Bool {

		if (Conductor.safeFrames == 1)
			return false;

		Conductor.safeFrames -= 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
		return true;
	}

	override function getValue():String {
		return "Safe Frames: " + Conductor.safeFrames +
		" - SIK: " + HelperFunctions.truncateFloat(45 * Conductor.timeScale, 0) +
		"ms GD: " + HelperFunctions.truncateFloat(90 * Conductor.timeScale, 0) +
		"ms BD: " + HelperFunctions.truncateFloat(135 * Conductor.timeScale, 0) + 
		"ms SHT: " + HelperFunctions.truncateFloat(155 * Conductor.timeScale, 0) +
		"ms TOTAL: " + HelperFunctions.truncateFloat(Conductor.safeZoneOffset,0) + "ms";
	}

	override function right():Bool {

		if (Conductor.safeFrames == 20)
			return false;

		Conductor.safeFrames += 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
		return true;
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
	}
}



class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "FPS Cap";
	}
	
	override function right():Bool {
		if (FlxG.save.data.fpsCap >= 290)
		{
			FlxG.save.data.fpsCap = 290;
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);
		}
		else
			FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 1;
		if (FlxG.save.data.fpsCap < 20) FlxG.save.data.fpsCap = 20;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		return true;
	}

	override function left():Bool {
		if (FlxG.save.data.fpsCap > 290)
			FlxG.save.data.fpsCap = 290;
		else if (FlxG.save.data.fpsCap < 20)
			FlxG.save.data.fpsCap = 20;
		else
			FlxG.save.data.fpsCap = FlxG.save.data.fpsCap - 1;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
		return true;
	}

	override function getValue():String
	{
		return "Current FPS Cap: " + FlxG.save.data.fpsCap + 
		(FlxG.save.data.fpsCap == Application.current.window.displayMode.refreshRate ? "Hz (Refresh Rate)" : "");
	}
}


class ScrollSpeedOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "Scroll Speed";
	}

	override function right():Bool {
		FlxG.save.data.scrollSpeed += 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 4)
			FlxG.save.data.scrollSpeed = 4;
		return true;
	}

	override function getValue():String {
		return "Current Scroll Speed: " + HelperFunctions.truncateFloat(FlxG.save.data.scrollSpeed,1);
	}

	override function left():Bool {
		FlxG.save.data.scrollSpeed -= 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 4)
			FlxG.save.data.scrollSpeed = 4;

		return true;
	}
}


class RainbowFPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fpsRain = !FlxG.save.data.fpsRain;
		(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Rainbow " + (!FlxG.save.data.fpsRain ? "off" : "on");
	}
}

class NPSDisplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "NPS Display " + (!FlxG.save.data.npsDisplay ? "off" : "on");
	}
}

class ReplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new LoadReplayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Load replays";
	}
}

class AccuracyDOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.accuracyMod = FlxG.save.data.accuracyMod == 1 ? 0 : 1;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy Mode: " + (FlxG.save.data.accuracyMod == 0 ? "Accurate" : "Complex");
	}
}

class CustomizeGameplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new GameplayCustomizeState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Customize Gameplay";
	}
}

// class WatermarkOption extends Option
// {
// 	public function new(desc:String)
// 	{
// 		super();
// 		description = desc;
// 	}

// 	public override function press():Bool
// 	{
// 		Main.watermarks = !Main.watermarks;
// 		FlxG.save.data.watermark = Main.watermarks;
// 		display = updateDisplay();
// 		return true;
// 	}

// 	private override function updateDisplay():String
// 	{
// 		return "Watermarks " + (Main.watermarks ? "on" : "off");
// 	}
// }

class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		var poop:String = Highscore.formatSong("Tutorial", 1);

		PlayState.SONG = Song.loadFromJson(poop, "Tutorial");
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}
class BotPlay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.botplay = false;
		trace('BotPlay : ' + FlxG.save.data.botplay);
		display = updateDisplay();
		return true;
	}
	
	private override function updateDisplay():String
		return "BotPlay " + (FlxG.save.data.botplay ? "on" : "off");
}
// Added options
class PlayerOption extends Option
{
	public static var playerEdit:Int = 0;
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;

	}
	override function right():Bool {
		return false;
	}
	override function left():Bool {
		return false;
	}

	public override function press():Bool
	{
		playerEdit = 0;
		FlxG.switchState(new CharSelection());
		return true;
	}

	private override function updateDisplay():String
	{
		return "Player Character";
	}

	override function getValue():String {
		return "Current Player: " + FlxG.save.data.playerChar;
	}
}
class GFOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;

	}
	override function right():Bool {
		return false;
	}
	override function left():Bool {
		return false;
	}

	public override function press():Bool
	{
		PlayerOption.playerEdit = 2;
		FlxG.switchState(new CharSelection());
		return true;
	}

	private override function updateDisplay():String
	{
		return "GF Character";
	}

	override function getValue():String {
		return "Current GF: " + FlxG.save.data.gfChar;
	}
}
class OpponentOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;

	}
	override function right():Bool {
		return false;
	}
	override function left():Bool {
		return false;
	}
	public override function press():Bool
	{
		PlayerOption.playerEdit = 1;
		FlxG.switchState(new CharSelection());
		return true;
	}

	private override function updateDisplay():String
	{
		return "Opponent Character";
	}

	override function getValue():String {
		return "Current Opponent: " + FlxG.save.data.opponent;
	}

}
class CharAutoOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.charAuto = !FlxG.save.data.charAuto;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Force selected opponent " + (!FlxG.save.data.charAuto ? "on" : "off");
	}
}
class AnimDebugOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.animDebug = !FlxG.save.data.animDebug;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Anim Debug " + (!FlxG.save.data.animDebug ? "off" : "on");
	}
}
class NoteSplashOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.noteSplash = !FlxG.save.data.noteSplash;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Splashes " + (!FlxG.save.data.noteSplash ? "off" : "on");
	}
}
class ShitQualityOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.preformance = !FlxG.save.data.preformance;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Shit Quality " + (!FlxG.save.data.preformance ? "off" : "on");
	}
}
class NoteRatingOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.noterating = !FlxG.save.data.noterating;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Ratings " + (!FlxG.save.data.noterating ? "off" : "on");
	}
}

class GUIGapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "GUI Gap";
	}
	
	override function right():Bool {
		FlxG.save.data.guiGap += 1;

		return true;
	}

	override function left():Bool {
		FlxG.save.data.guiGap -= 1;
		return true;
	}

	override function getValue():String
	{
		return 'Hud distance: ${FlxG.save.data.guiGap}, Press enter to reset to 0';
	}
}
class SelStageOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;

	}
	override function right():Bool {
		return false;
	}
	override function left():Bool {
		return false;
	}
	public override function press():Bool
	{
		FlxG.switchState(new StageSelection());
		return true;
	}

	private override function updateDisplay():String
	{
		return "Selected Stage";
	}

	override function getValue():String {
		return "Current Stage: " + FlxG.save.data.selStage;
	}

}
class ReloadCharlist extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;

	}
	override function right():Bool {
		return false;
	}
	override function left():Bool {
		return false;
	}
	public override function press():Bool
	{
		TitleState.checkCharacters();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Reload Char/Stage List";
	}

	override function getValue():String {
		return '${TitleState.choosableCharacters.length} character${CoolUtil.multiInt(TitleState.choosableCharacters.length)} loaded';
	}

}
class InputHandlerOption extends Option
{
	var ies:Array<String> = ["Kade","Tweaked Kade"];
	var iesDesc:Array<String> = ["Good old kade","Kade engine without antimash, and some improvements"];
	public function new(desc:String)
	{
		super();
		if (FlxG.save.data.inputHandler >= ies.length) FlxG.save.data.inputHandler = 0;
		description = desc;

		acceptValues = true;
	}

	override function getValue():String {
		return iesDesc[FlxG.save.data.inputHandler];
	}

	override function right():Bool {
		FlxG.save.data.inputHandler += 1;
		if (FlxG.save.data.inputHandler >= ies.length) FlxG.save.data.inputHandler = 0;
		display = updateDisplay();
		return true;
	}
	override function left():Bool {
		FlxG.save.data.inputHandler -= 1;
		if (FlxG.save.data.inputHandler < 0) FlxG.save.data.inputHandler = ies.length - 1;
		display = updateDisplay();
		return true;
	}
	public override function press():Bool{return right();}

	private override function updateDisplay():String
	{
		return '${ies[FlxG.save.data.inputHandler]} Input Engine';
	}
}
class NoteSelOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;

	}
	override function right():Bool {
		return false;
	}
	override function left():Bool {
		return false;
	}

	public override function press():Bool
	{
		FlxG.switchState(new ArrowSelection());
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Style Selection";
	}

	override function getValue():String {
		return "Current note style: " + FlxG.save.data.noteAsset;
	}
}

class HitSoundOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.hitSound = !FlxG.save.data.hitSound;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Hit Sound " + (!FlxG.save.data.hitSound ? "off" : "on");
	}
}

class CamMovementOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.camMovement = !FlxG.save.data.camMovement;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Camera Movement " + (!FlxG.save.data.camMovement ? "off" : "on");
	}
}

class PracticeModeOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.practiceMode = !FlxG.save.data.practiceMode;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Practice Mode " + (!FlxG.save.data.practiceMode ? "off" : "on");
	}
}
class ShowP2Option extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.dadShow = !FlxG.save.data.dadShow;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Opponent " + (!FlxG.save.data.dadShow ? "off" : "on");
	}
}
class ShowP1Option extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.bfShow = !FlxG.save.data.bfShow;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Player " + (!FlxG.save.data.bfShow ? "off" : "on");
	}
}
class ShowGFOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.gfShow = !FlxG.save.data.gfShow;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Girlfriend " + (!FlxG.save.data.gfShow ? "off" : "on");
	}
}
class PlayVoicesOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.playVoices = !FlxG.save.data.playVoices;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Play voices " + (!FlxG.save.data.playVoices ? "off" : "on");
	}
}
class CheckForUpdatesOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.updateCheck = !FlxG.save.data.updateCheck;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Check for updates " + (!FlxG.save.data.updateCheck ? "off" : "on");
	}
}
class UnloadSongOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.songUnload = !FlxG.save.data.songUnload;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Unload song " + (!FlxG.save.data.songUnload ? "off" : "on");
	}
}
class UseBadArrowsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.useBadArrowTex = !FlxG.save.data.useBadArrowTex;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Hurt arrow texture " + (!FlxG.save.data.useBadArrowTex ? "off" : "on");
	}

}
class MiddlescrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.middleScroll = !FlxG.save.data.middleScroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Middle scroll " + (!FlxG.save.data.middleScroll ? "off" : "on");
	}

}
class OpponentStrumlineOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.oppStrumLine = !FlxG.save.data.oppStrumLine;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Show Opponent Strumline " + (!FlxG.save.data.oppStrumLine ? "off" : "on");
	}

}
class MissSoundsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.playMisses = !FlxG.save.data.playMisses;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Play miss sounds " + (!FlxG.save.data.playMisses ? "off" : "on");
	}

}
