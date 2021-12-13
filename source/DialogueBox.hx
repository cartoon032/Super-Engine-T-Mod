package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = 'bf';
	var playerTalk:Bool = true;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		if(dialogueList == null || dialogueList[0] == null) return;

		switch (PlayState.SONG.song.toLowerCase())
		{
			// case 'senpai':
			default:
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = true;
		var pixelBox = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking','shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24);
			case 'senpai':
				pixelBox = true;
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				pixelBox = true;
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				pixelBox = true;
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-20, 40);
		if(pixelBox){

			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		}else{
			// portraitLeft.makeGraphic(Std.int(PlayState.dad.width), Std.int(PlayState.dad.height), 0x00000000);
			portraitLeft = new HealthIcon(PlayState.dad.curCharacter);
			portraitLeft.screenCenter(Y);
			portraitLeft.scale.x *= 2;
			portraitLeft.scale.y *= 2;
			// portraitLeft.stamp(PlayState.dad,0,0);
		}
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);

		if(!pixelBox) portraitLeft.x = FlxG.width * 0.10 - (portraitLeft.width * 0.5);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		if(pixelBox){

			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		}else{
			// portraitRight.makeGraphic(Std.int(PlayState.boyfriend.width), Std.int(PlayState.boyfriend.height), 0x00000000);
			portraitRight = new HealthIcon(PlayState.boyfriend.curCharacter,true);
			portraitRight.screenCenter(Y);
			
			portraitRight.scale.x *= 2;
			portraitRight.scale.y *= 2;

			// portraitLeft.stamp(PlayState.boyfriend,0,0);
		}
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		if(!pixelBox) portraitRight.x = FlxG.width * 0.75 - (portraitRight.width * 0.5);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		if(pixelBox){

			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			box.updateHitbox();
		}else{
			box.y += Std.int(FlxG.height * 0.5);

		}
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		// handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic('week6:images/weeb/pixelUI/hand_textbox');
		// add(handSelect);


		// if (!talkingRight)
		// {
		// 	// box.flipX = true;
		// }

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		if(pixelBox) dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		if(pixelBox) {
			swagDialogue.font = 'Pixel Arial 11 Bold';
			swagDialogue.color = 0xFF3F2021;
		}else{
			swagDialogue.color = 0xFF221122;
		}
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		swagDialogue.completeCallback = function(){
			swagDialogue.cursorCharacter = " ->";
		};
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			if(swagDialogue.text != dialogueList[0] && !FlxG.keys.justPressed.ESCAPE){
				swagDialogue.skip();
			}else{

				remove(dialogue);
					

				if (dialogueList[1] == null && dialogueList[0] != null || FlxG.keys.justPressed.ESCAPE)
				{
					if (!isEnding)
					{
						isEnding = true;
						FlxG.sound.play(Paths.sound('clickText'), 0.8);

						if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
							FlxG.sound.music.fadeOut(2.2, 0);

						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 1 / 5;
							bgFade.alpha -= 1 / 5 * 0.7;
							portraitLeft.visible = false;
							portraitRight.visible = false;
							swagDialogue.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);

						new FlxTimer().start(1.2, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
				}
				else
				{
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
					dialogueList.remove(dialogueList[0]);
					startDialogue();
				}
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.cursorCharacter = "";


		// switch (curCharacter)
		// {
		// 	case 'dad':
		// 		portraitRight.visible = false;
		// 		if (!portraitLeft.visible)
		// 		{
		// 			portraitLeft.visible = true;
		// 			// portraitLeft.animation.play('enter');
		// 		}
		// 		box.flipX = true;
		// 	case 'bf':
		// 		portraitLeft.visible = false;
		// 		if (!portraitRight.visible)
		// 		{
		// 			portraitRight.visible = true;
		// 			// portraitRight.animation.play('enter');
		// 		}
		// 		box.flipX = false;
		// }
		if(curCharacter.contains("dad") || curCharacter.contains("opponent")){
			updatePortrait(false);
		}else if (curCharacter.contains("bf") || curCharacter.contains("player")){
			updatePortrait(true);
		}
	}
	function updatePortrait(isPlayer:Bool){
		if(playerTalk != isPlayer){
			playerTalk = isPlayer;
			portraitLeft.visible = true;
			portraitRight.visible = true;
			portraitLeft.scale.x *= (if(isPlayer) 0.9 else 1.1);
			portraitLeft.scale.y *= (if(isPlayer) 0.9 else 1.1);
			portraitRight.scale.x *= (if(isPlayer) 1.1 else 0.9);
			portraitRight.scale.y *= (if(isPlayer) 1.1 else 0.9);
			portraitRight.alpha = (if(isPlayer) 1 else 0.6);
			portraitLeft.alpha = (if(isPlayer) 0.6 else 1);
			box.flipX = !isPlayer;
			FlxTween.tween(box.scale,{x:1.2,y:0.8},0.1,{ease:FlxEase.cubeIn,onComplete:function(t){

				FlxTween.tween(box.scale,{x:1,y:1},0.1,{ease:FlxEase.cubeIn,onComplete:function(t){
						swagDialogue.start(0.04, true);
						swagDialogue.setTypingVariation(0.2,true);
				}});
			}});
		}
		// portraitLeft
	}

	function cleanDialog():Void
	{
		trace(dialogueList[0]);
		if(dialogueList[0].contains(":")){
			var splitName:Array<String> = dialogueList[0].split(":");
			if(splitName[2] == null){
				curCharacter = splitName[0];
				dialogueList[0] = splitName[1];
			}else{

				curCharacter = splitName[1];
				dialogueList[0] = splitName[2];
			}
		}
	}
}
