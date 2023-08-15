package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.effects.FlxFlicker;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', #if android 'Android Controls', #end 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	var language:String = ClientPrefs.language;
	var velocityBG:FlxBackdrop;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				#if android
				removeVirtualPad();
				#end
				openSubState(new options.NotesSubState());
			case 'Android Controls':
				#if android
				removeVirtualPad();
				#end
				openSubState(new options.AndroidControlSettings());
			case 'Controls':
				#if android
				removeVirtualPad();
				#end
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				#if android
				removeVirtualPad();
				#end
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				#if android
				removeVirtualPad();
				#end
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				#if android
				removeVirtualPad();
				#end
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		
		velocityBG = new FlxBackdrop(Paths.image('velocity_background'));
		velocityBG.velocity.set(50, 50);
		add(velocityBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		#if android
		if (ClientPrefs.language == 'Chinese') {
		var tipText:FlxText = new FlxText(10, 12, 0, '按下E打开按键修改界面', 16);
		tipText.setFormat(Paths.font("syht.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 2;
		tipText.scrollFactor.set();
		add(tipText);
		} else {
		var tipText:FlxText = new FlxText(10, 12, 0, 'Press E to Go In Android Controls Menu', 16);
		tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 2;
		tipText.scrollFactor.set();
		add(tipText);
		}
		#end

		changeSelection();
		ClientPrefs.saveSettings();

		#if android
		addVirtualPad(UP_DOWN, A_B_E);
		#end

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}
	
	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P && !selectedSomethin) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P && !selectedSomethin) {
			changeSelection(1);
		}

		if (controls.BACK && !selectedSomethin) {
			if (PauseSubState.optionMenu) {
				MusicBeatState.switchState(new PlayState());
				PauseSubState.optionMenu = false;
			} else {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		#if android
		if (_virtualpad.buttonE.justPressed && !selectedSomethin) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new android.AndroidControlsMenu());
		}
		#end

		if (controls.ACCEPT && !selectedSomethin) {
			selectedSomethin = true;
			for (item in grpOptions.members)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTween.tween(item, {alpha: 0}, 0.8, {ease: FlxEase.quadOut});
				FlxTween.tween(item, {x: item.x - 600}, 0.8, {ease: FlxEase.quadOut});
				remove(selectorLeft);
				remove(selectorRight);
				FlxFlicker.flicker(item, 0.8, 0.06, false, false, function(flick:FlxFlicker)
				{
					openSelectedSubstate(options[curSelected]);
				});
			}
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
	}
}
