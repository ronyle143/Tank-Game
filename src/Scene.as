package
{
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.Color;
 
    public class Scene extends starling.display.Sprite
    {
		public var playing:Boolean = true;
        private var tank:MovieClip;
		private var bg:Image;
		private var lifebarinner:Image;
		private var distance:int;
		private var active:Boolean = false;
		private var sky:Image;
		private var lifebar:Image;
		private var uniticon:Image;
		private var fg:Image;
		private var smoke:Image;
		private var velocity:int=-11;
		private var falldistance:int=1;
		public var reload:int = 0;
		public var downKeyIsBeingPressed:Boolean;
		public var textField:TextField = new TextField(100, 20, "*um*", "Comic Sans MS", 12, Color.WHITE);
		public var hpNum:TextField = new TextField(100, 20, "*um*", "Comic Sans MS", 12, Color.WHITE);
		
		public var      projectiles:Array = [];
		public var enemyProjectiles:Array = [];
		public var          enemies:Array = [];
		
		public var score:Number = 0;
		public var scoreDisplay:TextField = new TextField(100, 20, "*um*", "Comic Sans MS", 12, Color.WHITE);
		
		private var reloadmagazine:int = 0;
		private var reloadmagazinetime:int = 200;
		private var reloadbarinner:Image;
		private var reloadbar:Image;
		private var texttime:int = 0;
		private var shakeScreenTime:Number = 0;
		private var placeholder:Sprite;
		private var lockedOnStart:Boolean = true;
		private var lockedOnTime:int = 300;
		public var capacity:int = 5;
		
		public var hp:int = 100;
		public var speed:int = 2.5;
		public var reloadspeed:int = 1;
		public var reloadtime:int = 60;
		public var direction:String = "right"
		
		public var rounds:int = capacity;
		public var roundsDisplay:TextField = new TextField(100, 20, "*um*", "Comic Sans MS", 12, Color.WHITE);
		
		public var isRight:Boolean=false
		public var isLeft:Boolean=false
		public var isUp:Boolean=false
		public var isDown:Boolean=false
		public var jumping:Boolean = false;
		
		public var xxx:Number;
		public var yyy:Number;
		
        public function Scene()
        {
            sky = new Image(Root.assets.getTexture("Mountain_BG"));
			sky.x = -50;
			sky.y = -50;
			sky.width = Constants.STAGE_WIDTH * 1.2;
			sky.height = Constants.STAGE_HEIGHT * 1.2;
            addChild(sky);
			
			smoke = new Image(Root.assets.getTexture("smoked_BG"));
			smoke.x = 0;
			smoke.y = 65;
			smoke.width = Constants.STAGE_WIDTH*4;
			smoke.height = Constants.STAGE_HEIGHT;
            addChild(smoke);
						
			bg = new Image(Root.assets.getTexture("Treelineloop"));
			bg.x = 0;
			bg.y = 65;
			bg.width = Constants.STAGE_WIDTH*2;
			bg.height = Constants.STAGE_HEIGHT;
            addChild(bg);
 
            tank = new MovieClip(Root.assets.getTextures("stuart_0"), 6);
            tank.x = Constants.STAGE_WIDTH / 2;
            tank.y = Constants.STAGE_HEIGHT * 0.71;
			tank.width = tank.width/2;
			tank.height = tank.height/2;
			tank.pivotX = tank.width;
			tank.pivotY = tank.height;
            addChild(tank);
			
			placeholder = new Sprite();
			addChild(placeholder);
			
 
            Starling.juggler.add(tank);
            tank.stop();
			
			fg = new Image(Root.assets.getTexture("Treeline"));
			fg.x = 0;
			fg.y = Constants.STAGE_HEIGHT/2+100;
			fg.width = Constants.STAGE_WIDTH*2;
			fg.height = Constants.STAGE_HEIGHT/2;
            addChild(fg);
			
			uniticon = new Image(Root.assets.getTexture("uniticon"));
			uniticon.width *= 2;
			uniticon.height *= 2;
            uniticon.x = 10;
			uniticon.pivotY = uniticon.height/2;
            uniticon.y = Constants.STAGE_HEIGHT;
            addChild(uniticon);
			
			lifebarinner = new Image(Root.assets.getTexture("lifebarinner"));
			lifebarinner.width *= 2;
			lifebarinner.height *= 2;
            lifebarinner.x = 10;
			lifebarinner.pivotY = lifebarinner.height/2;
            lifebarinner.y = Constants.STAGE_HEIGHT-10;
            addChild(lifebarinner);
			
			lifebar = new Image(Root.assets.getTexture("lifebarframe"));
			lifebar.width *= 2;
			lifebar.height *= 2;
            lifebar.x = 10;
			lifebar.pivotY = lifebar.height/2;
            lifebar.y = Constants.STAGE_HEIGHT-10;
            addChild(lifebar);
			
			reloadbarinner = new Image(Root.assets.getTexture("lifebarinner"));
			reloadbarinner.pivotX = reloadbarinner.width;
			reloadbarinner.width = Constants.STAGE_WIDTH * 0.8;
			reloadbarinner.height = Constants.STAGE_HEIGHT * 0.05;
            reloadbarinner.x = Constants.STAGE_WIDTH;
            reloadbarinner.y = Constants.STAGE_HEIGHT-reloadbarinner.height;
			reloadbarinner.color = Color.RED;
            addChild(reloadbarinner);
			
			hpNum.text = "" + hp;
			hpNum.pivotX = hpNum.width / 2;
			hpNum.pivotY = (hpNum.height / 2) + hpNum.height
			hpNum.x = lifebar.x + lifebar.width / 2;
			hpNum.y = Constants.STAGE_HEIGHT-lifebar.height;
			addChild(hpNum);
			hpNum.visible = true;
			
			scoreDisplay.text = "" + score;
			scoreDisplay.hAlign = "right";
			scoreDisplay.pivotX = scoreDisplay.width;
			scoreDisplay.x = Constants.STAGE_WIDTH;
			addChild(scoreDisplay);
			
			roundsDisplay.text = "" + rounds;
			roundsDisplay.hAlign = "right";
			roundsDisplay.pivotX = roundsDisplay.width;
			roundsDisplay.pivotY = roundsDisplay.height;
			roundsDisplay.x = Constants.STAGE_WIDTH;
			roundsDisplay.y = Constants.STAGE_HEIGHT;
			addChild(roundsDisplay);
			
			xxx = this.width;
			yyy = this.height;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ENTER_FRAME, lockedOnTimeUpdated);
			
			var arrayA:Array = [ 1, 2, 3, 4, 5, 6];
			printArray("A", arrayA);
			arrayA = deleteFromArray(arrayA, 3);
			printArray("A", arrayA);
			arrayA = deleteFromArray(arrayA, 0);
			printArray("A", arrayA);
			
        }
		private function printArray(name:String,ary:Array):void
		{
			var str1:String = ""+name+" - ";
			for (var i:int; i < ary.length; i++) {
				str1 += ""+ary[i]+" "
			}
			trace("" + str1 + "+" +ary.length);
		}
		
		private function lockedOnTimeUpdated(e:Event):void 
		{
			if (lockedOnTime > 0) 
			{ 
				direction = "right";
				downKeyIsBeingPressed = true;
				smoke.x -= speed / 2;
				bg.x -= speed; 
				//placeholder.x -= speed;
				for (var i:int= 0; i < enemies.length; i++) {
					enemies[i].x -= speed;
				}
				for (i= 0; i < projectiles.length; i++) {
					projectiles[i].x -= speed;
				}
				for (i= 0; i < enemyProjectiles.length; i++) {
					enemyProjectiles[i].x -= speed;
				}
				fg.x -= speed*2; 
				checkBorders();
				tank.width = tank.width;
				tank.play();
				lockedOnTime--; 
			}
			else 
			{ 
				lockedOnStart = false; 
				removeEventListener(Event.ENTER_FRAME, lockedOnTimeUpdated);
			}
		}
			
		private function onEnterFrame(e:Event):void {//-------------------------------------------------------------[onEnterFrame(e:Event)]
				tank.play();
				hpNum.text = "" + hp;//----------------------------------------------------------------------------------update hp
				scoreDisplay.text = "" + score;//------------------------------------------------------------------------update score
				roundsDisplay.text = rounds + " ◘";//--------------------------------------------------------------------update rounds
				texttime--;
				//reloadspeed
				reloadbarinner.width = 100-((reloadmagazinetime - reloadmagazine)/2); //---------------------------------update reload bar
				if (hp >= 0) {//-----------------------------------------------------------------------------------------update lifebar
					lifebarinner.height = (lifebar.height / 100) * hp;
				}
				else {
					lifebarinner.height = 0;
					hp = 0;
				}
				if (hp <= 0)//-------------------------------------------------------------------------------------------no more life
				{
					tank.alpha -= 0.02;
					isLeft,isRight = false;
					if (tank.alpha <= 0)
					{
						//this.alpha -= 0.02;
						//playing = false
					}
				}
				if (reload > 0) {//-------------------------------------------------------------------------------------reload mechanics
					reload = reload - reloadspeed;
				}else {
					textField.visible = false;
				}
				addEventListener( KeyboardEvent.KEY_DOWN, onKeyPress );
				addEventListener( KeyboardEvent.KEY_UP, onKeyRelease );
				if(!lockedOnStart){
					if (isRight && !isLeft && hp > 0) //-----------------------------------------------------------------------------go Left
					{
						
						direction = "right";
						downKeyIsBeingPressed = true;
						smoke.x -= speed / 2;
						bg.x -= speed; 
						//placeholder.x -= speed;
						for (var i:int= 0; i < enemies.length; i++) {
							enemies[i].x -= speed;
						}
						for (i= 0; i < projectiles.length; i++) {
							projectiles[i].x -= speed;
						}
						for (i= 0; i < enemyProjectiles.length; i++) {
							enemyProjectiles[i].x -= speed;
						}
						fg.x -= speed*2; 
						checkBorders();
						tank.width = tank.width;
						tank.play();
					}
					if (isLeft && !isRight && hp > 0)//--------------------------------------------------------------------------------go Right
					{
						direction = "left";
						smoke.x += speed / 2;
						bg.x += speed; 
						//placeholder.x += speed;
						for (i = 0; i < enemies.length; i++) {
							enemies[i].x += speed;
						}
						for (i= 0; i < projectiles.length; i++) {
							projectiles[i].x += speed;
						}
						for (i= 0; i < enemyProjectiles.length; i++) {
							enemyProjectiles[i].x += speed;
						}
						fg.x += speed*2;
						checkBorders();
						tank.width = -tank.width;
						tank.play();
					}
					if ((!isLeft) && (!isRight)) //---------------------------------------------------------------------------movement restriction
					{
						tank.stop();
					}
				}
				if (jumping && hp > 0)//--------------------------------------------------------------------------------------------jumping mechanics
				{
					if (tank.y >= Constants.STAGE_HEIGHT * 0.71)
					{
						tank.y = Constants.STAGE_HEIGHT * 0.71;
						jumping = false;
						trace(hp, falldistance, velocity);
						takeDamage((falldistance-4)*5);
						falldistance = 0;
						velocity = -10;
						isLeft,isRight = false;
					}else {
						tank.y -= velocity;
						velocity--;
					}
					if (velocity <= 0)//------------------------------------------------------------------------------falldistance counter
					{
						falldistance++;
					}
				}
		}
		
		private function takeDamage(num:int):void 
		{
			hp -= num;
			if (hp < 0) { hp = 0; }
			if (hp <= 0) {
					shakeScreen(100);
			}
		}
		public function onKeyPress( e:KeyboardEvent ):void//------------------------------------------------[onKeyPress( e:KeyboardEvent )]
		{if(hp>0){
			// [A] or [<]
			if ( e.keyCode == 65 || e.keyCode == 37 )
			{
				//isLeft = true;
				tankTurn("left");
			}
			// [D] or [>]
			if ( e.keyCode == 68 || e.keyCode == 39 )
			{
				//isRight = true;
				tankTurn("right");
			}
			//[Space]
			if (e.keyCode == 32) {
				shoot();
			}
			//[J]
			if ( e.keyCode == 74)
			{
				if (!jumping)
				{
					jumping = true;
					velocity = 10;
					tank.y--;
				}
			}
			//[R]
			if ( e.keyCode == 82)
			{
				if ( rounds < capacity) {
					reArm();
				}
			}
			//[N]
			if ( e.keyCode == 78)
			{
				addEnemy("tank", 1, 100);
			}
			trace("pressed: "+e.keyCode);
		}}
		
		private function reArm():void //-------------------------------------------------------------------------------------reArm():void 
		{
			reloadmagazine = reloadmagazinetime;
			addEventListener(EnterFrameEvent.ENTER_FRAME, Arm);
		}
		
		private function Arm(e:EnterFrameEvent):void //--------------------------------------------------------Arm(e:EnterFrameEvent):void 
		{
			reloadmagazine--;
			if (reloadmagazine <= 0)
			{
				rounds = capacity;
				removeEventListener(EnterFrameEvent.ENTER_FRAME, Arm);
			}
		}
		
		private function tankTurn(dir:String):void //-------------------------------------------------------------tankTurn(dir:String):void 
		{
			if (dir == "left")
			{
				isLeft = true;
			}
			if (dir == "right")
			{
				isRight = true;
			}
		}
		
		public function onKeyRelease( e:KeyboardEvent ):void//---------------------------------[onKeyRelease( keyboardEvent:KeyboardEvent )]
		{
			if ( e.keyCode == 65 || e.keyCode == 37 )
			{
				isLeft = false;
				//isRight = false;
				tank.stop();
			}
			if ( e.keyCode == 68 || e.keyCode == 39 )
			{
				//isLeft = false;
				isRight = false;
				tank.stop();
			}
		}
		public function createEnemyTank(name:String):Sprite//-------------------------------------------------------------------createEnemyTank():void
		{	
			var entity1:Sprite = new Sprite();
			
			var ent:MovieClip = new MovieClip(Root.assets.getTextures(name), 12);
			ent.width = ent.width/2;
			ent.height = ent.height/2;
			ent.pivotX = ent.width;
			ent.pivotY = ent.height;
			ent.play();
            entity1.addChild(ent);
			
			return entity1; 
		}
		private function addEnemy(enemyType:String,spd:Number,rng:Number):void //----------------addEnemy(enemyType:String,spd:Number,rng:Number)
		{
			if (enemyType == "tank")
			{
				var new_Tank:Sprite = createEnemyTank("pzII");
				var firing:Boolean = false;
				var new_Tank_reload:int = 0;
				var new_Tank_ROF:int = 20;
				var value:int = 20;
				
				if (direction == "right")
				{
					new_Tank.x = tank.x + 200;
				}
				else {
					new_Tank.x = tank.x - 200;
				}
				new_Tank.y = Constants.STAGE_HEIGHT * 0.71;
				var dirr:String = direction
				new_Tank.addEventListener(
					Event.ENTER_FRAME, function moveTank(e:Event):void {
						var entity:Sprite = e.currentTarget as Sprite;
						if (entity.x > tank.x) {
							dirr = "right";
						}else {
							dirr = "left";
						}
						if (dirr == "right")
						{
							entity.width = -(entity.width);
							if ((entity.x - tank.x) > rng)
							{
								entity.x -= spd;
								firing = false;
							}
							else {
								//firing = true;-----------------------------------------------------------------------enemy fire function
								var new_bullet:Sprite;
								var dirr:String;
								if (new_Tank_reload >= new_Tank_ROF && hp > 0)
								{
									new_bullet = createProjectile();
									new_bullet.x = new_Tank.x;
									new_bullet.y = new_Tank.y - 4;
									dirr = dirr;
									new_bullet.addEventListener(
										Event.ENTER_FRAME, function moveBullet(e:Event):void {
											var bullet:Sprite = e.currentTarget as Sprite;
											if (dirr == "right")
											{
												bullet.x -= 10;
											}else {
												bullet.x += 10;
											}
											if (bullet.x < 0 -500 || bullet.x > stage.stageWidth +500|| bullet.y < 0 || bullet.y > stage.stageHeight) {
												bullet.removeEventListener(Event.ENTER_FRAME, moveBullet);
												bullet.parent.removeChild(bullet);
												bullet = null;
											}
											var isColliding:Boolean = bullet.getBounds(bullet.parent).intersects(tank.getBounds(tank.parent));
											if (isColliding)
											{
												trace("hit!");
												takeDamage(1);
												bullet.removeFromParent(true);
											}
										}
									); 
									addChild(new_bullet);
									enemyProjectiles.push(new_bullet);
									shakeScreen(5);
									new_Tank_reload=0
								}
								else {
									new_Tank_reload++;
								}
								//------------------------------------------------------------------------------------------------------
							}
						}else {
							entity.width = entity.width;
							if ((tank.x - entity.x) > rng)
							{
								entity.x += spd;
								firing = false;
							}
							else {
								//firing = true;-----------------------------------------------------------------------enemy fire function
								if (new_Tank_reload >= new_Tank_ROF && hp > 0)
								{
									new_bullet = createProjectile();
									new_bullet.x = new_Tank.x;
									new_bullet.y = new_Tank.y - 4;
									dirr = dirr;
									new_bullet.addEventListener(
										Event.ENTER_FRAME, function moveBullet(e:Event):void {
											var bullet:Sprite = e.currentTarget as Sprite;
											if (dirr == "right")
											{
												bullet.x -= 10;
											}else {
												bullet.x += 10;
											}
											var isColliding:Boolean = bullet.getBounds(bullet.parent).intersects(tank.getBounds(tank.parent));
											if (isColliding)
											{
												//trace("hit!");
												takeDamage(1);
												bullet.removeFromParent(true);
											}
											if (bullet.x < 0 -500 || bullet.x > stage.stageWidth +500|| bullet.y < 0 || bullet.y > stage.stageHeight) {
												bullet.removeEventListener(Event.ENTER_FRAME, moveBullet);
												bullet.parent.removeChild(bullet);
												bullet = null;
											}
										}
									); 
									addChild(new_bullet);
									enemyProjectiles.push(new_bullet);
									shakeScreen(5);
									new_Tank_reload=0
								}
								else {
									new_Tank_reload++;
								}
								//------------------------------------------------------------------------------------------------------
							}
						}/*
						if (entity.x < -500 || entity.x > stage.stageWidth +500 || entity.y < 0 || entity.y > stage.stageHeight) {
							entity.removeEventListener(Event.ENTER_FRAME, moveTank);
							entity.parent.removeChild(entity);
							entity = null;
						}//*/
					}
				);
				this.placeholder.addChild(new_Tank);
				enemies.push(new_Tank);
			}
		}
		public function deleteFromArray(arrayA:Array, num:int):Array //---------------------------deleteFromArray(arrayA:Array, num:int):Array
		{
			var arrayB:Array = [];
			for (var i:int; i < arrayA.length; i++)
			{
				if (i >= num) {
					arrayB[i] = arrayA[i + 1];
				}
				else {
					arrayB[i] = arrayA[i];
				}
			}
			arrayB.length -= 1;
			return arrayB;
		}
		public function createProjectile():Sprite//-------------------------------------------------------------------createProjectile():Sprite
		{	
			var bullet1:Sprite = new Sprite();
			// draw the graphics
			/*var g:Graphics = bullet.graphics;
			g.beginFill(0xEEEEEE);
			g.drawCircle(0, 0, 5);
			g.endFill();//*/
			var bullet:Image = new Image(Root.assets.getTexture("shell"));
			bullet.pivotX = bullet.width / 2;
			bullet.pivotY = bullet.height / 2;
            bullet1.addChild(bullet);
			
			return bullet1; 
		}
		private function shoot():void //--------------------------------------------------------------------------shoot():void 
		{                             //                                                                             with 
			if (reload < 0)           //                                                                   moveBullet(e:Event):void {
			{
				reload = 0;
			}
			if (reload == 0)
			{
				reload = reloadtime;
				if (rounds > 0)
				{
					var new_bullet:Sprite = createProjectile();
					new_bullet.x = tank.x;
					new_bullet.y = tank.y - 6;
					var dirr:String = direction
					new_bullet.addEventListener(
						Event.ENTER_FRAME, function moveBullet(e:Event):void {
							var bullet:Sprite = e.currentTarget as Sprite;
							var removeint:int = 0;
							var removeOk:Boolean = false;
							if (dirr == "right")
							{
								bullet.x += 10;
							}else {
								bullet.x -= 10;
							}
							for ( var i:int = 0; i < enemies.length&& !removeOk; i++) {
								if(enemies[i] != null){
								var isColliding:Boolean = bullet.getBounds(bullet.parent).intersects(enemies[i].getBounds(enemies[i].parent.parent));
								if (isColliding && !removeOk)
								{
									trace("they're hit!");
									addScore(100);
									removeint = i;
									removeOk = true;
									//enemies = deleteFromArray[enemies, i];
									removeEventListener(EnterFrameEvent.ENTER_FRAME, moveBullet);
									
									break;
								}}
							}
							if (bullet.x < 0 -500 || bullet.x > stage.stageWidth +500|| bullet.y < 0 || bullet.y > stage.stageHeight) {
								bullet.removeEventListener(Event.ENTER_FRAME, moveBullet);
								bullet.parent.removeChild(bullet);
								bullet = null;
								
								removeEventListener(EnterFrameEvent.ENTER_FRAME, moveBullet);
							}
							if (removeOk) {
								
								bullet.removeFromParent(true);
								//enemies[removeint].removeFromParent(true);
								//enemies = deleteFromArray[enemies, removeint];
								removeEventListener(EnterFrameEvent.ENTER_FRAME, moveBullet);
							}
						}
					); 
					addChild(new_bullet);
					projectiles.push(new_bullet);
					shakeScreen(20);
					rounds--;
				}
				else
				{
					if (texttime <= 0 && 100-((reloadmagazinetime - reloadmagazine)/2) <= 0)
					{
							//emptyRound();
							reArm();
					}
				}
			}
			
		}
		
		private function addScore(num:int):void 
		{
			score += num;
		}
		private function shakeScreen(number:Number):void //-----------------------------------------------------shakeScreen(number:Number):void
		{
			shakeScreenTime = number;
			addEventListener(EnterFrameEvent.ENTER_FRAME,updateShakeScreenTime);
		}
		private function updateShakeScreenTime(e:Event):void {
			if (shakeScreenTime > 0) { // -----------------------------------------------------------------------shakeScreenTime Update
				var i:int=shakeScreenTime;
				this.x = 0;
				this.x = Math.random() * (i-(i/2));
				this.y = 0;
				this.y = Math.random() * (i-(i/2));
				shakeScreenTime--;
			}
			else {
				this.x = 0;
				this.y = 0;
				shakeScreenTime = 0;
				removeEventListener(EnterFrameEvent.ENTER_FRAME, updateShakeScreenTime);
			}
		}
		private function emptyRound():void //----------------------------------------------------------------------------emptyRound():void 
		{
			var list:Array = new Array();
			list.push("*pew!*");
			list.push("*pew!*");
			list.push("*pew!*");
			list.push("*pew!*");
			list.push("Nein!");
			list.push("*pchooo!*");
			list.push("*bang!*");
			list.push("Stop pressing space!");
			list.push(">=C");
			list.push("We have no more rounds, Sir.");
			list.push("We're out of rounds!");
			var tmp:int = Math.random()* list.length;
			textField.text = list[tmp];
			textField.x = tank.x;
			textField.width = 200;
			textField.y = tank.y-(textField.height);
			textField.pivotX = textField.width / 2;
			textField.pivotY = textField.height / 2;
			addChild(textField);
			textField.visible = true;
			texttime = 60;
			
			addEventListener(Event.ENTER_FRAME, generateText);//*/
			/*var pd = new txt();
			pd.x = tank.x;
			pd.y = tank.y;
			stage.addChild(pd);*/
		}
		
		private function generateText(e:Event):void //-------------------------------------------------------------generateText(e:Event):void
		{
			
			if (texttime > 0)
			{
				textField.visible = true;
			}else {
				textField.visible = false;
			}
		}//*/
			
		public function checkBorders():void //-------------------------------------------------------------------------[checkBorders()]:void
		{	// [>]
			if (smoke.x >= 1)
			{
				smoke.x =  ( -(smoke.width/2));
			}
			if (bg.x >= 1)
			{
				bg.x =  (-(bg.width/2));
			}
			if (fg.x >= 1)
			{
				fg.x =  (-(fg.width/2));
			}
			// [<]
			if (smoke.x <= (-(smoke.width/2))-1)
			{
				smoke.x = 0 ;
			}
			if (bg.x <= (-(bg.width/2))-1)
			{
				bg.x = 0 ;
			}
			if (fg.x <= (-(fg.width/2))-1)
			{
				fg.x = 0 ;
			}
		}
    }
}