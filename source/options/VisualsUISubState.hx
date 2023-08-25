package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import Controls;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	var language:String = ClientPrefs.language;
	var androidorientation:String = ClientPrefs.androidorientation;
	var noteSkinList:Array<String> = CoolUtil.coolTextFile(SUtil.getPath() + Paths.txt('noteSkinList'));
	var noteSkinListMods:Array<String> = CoolUtil.coolTextFile(Paths.modFolders('data/noteSkinList'));
	
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence
		
		for (i in 0...noteSkinListMods.length)
		{
			noteSkinList.unshift(noteSkinListMods[i]);
		}

		noteSkinList.unshift('Default');
		
		if (ClientPrefs.language == 'Chinese') {
		var option:Option = new Option('Note Splashes',
			'当获得“sick”判定时的打击特效',
			'noteSplashes',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Note Skin',
			"选择按键皮肤",
			'noteSkin',
			'string',
			'Default',
			noteSkinList);
		addOption(option);
		option.onChange = onChangeNoteSkin;

		var option:Option = new Option('Hide HUD',
			'隐藏HUD',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Language',
			'语言 只有中/英 有的文字没有改(悲',
			'language',
			'string',
			'English',
			['English', 'Chinese']);
		addOption(option);

		var option:Option = new Option('Time Bar:',
			'时间条应该显示什么!?!?',
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			'如果你对闪光敏感请关闭',
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			'关闭后镜头不会随节拍缩放',
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			'点击按键时Score Text缩放',
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'生命条不透明度',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('Fun Loading',
			'一个很cool的加载界面',
			'funloading',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('FPS Counter',
			'FPS 计数器',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('Pause Screen Song:',
			'暂停界面应该放什么歌?',
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'该更新啦!',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);
		#end
		
		var option:Option = new Option('File Check',
			'在加载谱面时检测文件以防报错',
			'filecheck',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Combo Stacking',
			'嗯，如果他关闭了的话。玩的时候最多就只会出现一个这样的贴图\n    -----油盐不贵',
			'comboStacking',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Androidorientation',
			'KKKKKKKKK这是Android orientation',
			'androidorientation',
			'string',
			'UNSPECIFIED',
			['UNSPECIFIED', 'PORTRAIT', 'REVERSE_PORTRAIT', 'SENSOR_PORTRAIT','SENSOR_PORTRAIT', 'LANDSCAPE', 'REVERSE_LANDSCAPE']);
		addOption(option);
		}
		else {
		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Note Skin',
			"Choose your note skin",
			'noteSkin',
			'string',
			'Default',
			noteSkinList);
		addOption(option);
		option.onChange = onChangeNoteSkin;

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Language',
			"We have only Chinese and English LOL\nAnd only change some text",
			'language',
			'string',
			'English',
			['English', 'Chinese']);
		addOption(option);

		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('Fun Loading',
			'A cool loading state',
			'funloading',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);
		#end
		
		var option:Option = new Option('File Check',
			'Check chart file when load song json\nAvoid crash maybe',
			'filecheck',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			'bool',
			true);
		addOption(option);
		}

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		if (noteExample != null) remove(noteExample);
		super.destroy();
	}

	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	
	function onChangeNoteSkin()
	{
		if (noteExample != null)
			remove(noteExample);
			
		if (noteSkinChange != null)
			noteSkinChange.cancel();
		
		var noteSkin = 'NOTE_assets';
		var noteAnimArray = ['arrowLEFT0', 'purple0', 'arrowDOWN0', 'blue0', 'arrowUP0', 'green0', 'arrowRIGHT0', 'red0'];
		var curAnim = 0;
		
		noteExample = new FlxSprite(1000, 0);
		if (ClientPrefs.noteSkin != 'Default') noteSkin = 'noteSkin/' + ClientPrefs.noteSkin;
		noteExample.frames = Paths.getSparrowAtlas(noteSkin);
		noteExample.antialiasing = ClientPrefs.globalAntialiasing;
		
		for (i in 0...noteAnimArray.length)
		{
			noteExample.animation.addByPrefix(noteAnimArray[i], noteAnimArray[i], 24);
		}
		
		noteExample.animation.play('arrowLEFT');
		noteExample.screenCenter(Y);
		noteExample.updateHitbox();
		add(noteExample);
		
		noteSkinChange = new FlxTimer().start(0.75, function(tmr:FlxTimer)
		{
			curAnim++;
			if (curAnim > noteAnimArray.length-1) curAnim = 0;
			noteExample.animation.play(noteAnimArray[curAnim]);
		}, 0);
	}
}
