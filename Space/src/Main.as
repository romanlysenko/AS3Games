package {
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    [SWF(width="640", height="480", backgroundColor="#333333", frameRate="60")]
    public class Main extends Sprite {
        private const LEFT_BORDER:int = 112;
        private const RIGHT_BORDER:int = 272;
        private const TOP_BORDER:int = 80;
        private const BOTTOM_BORDER:int = 384;
        private const TILE_SIZE:int = 16;
        private const ENEMY_ROW:int = 6;

        private var gameBackground:DisplayObject;

        private var enemies:Array;
        private var positions:Array;
        private var hero:DisplayObject;
        private var bullet:DisplayObject;

        private var timer:Timer;
        private var speed:Number = 1000;

        public function Main() {
            if (stage) {
                initialize();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, initialize);
            }
        }

        private function initialize(event:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, initialize);

            gameBackground = new Assets.GameBackground();
            addChild(gameBackground);

            createHero();

            enemies = [];

            // Creating an array of possible positions
            positions = generatePositions(LEFT_BORDER, RIGHT_BORDER, TILE_SIZE);

            // TODO: Find out if this is necessary
            stage.focus = stage;

            // Adding keyboard event listener
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress);

            // Creating timer
            timer = new Timer(speed, 0);
            timer.addEventListener(TimerEvent.TIMER, update);
            timer.start();
        }

        private function createHero():void {
            hero = new Assets.ShipImage();
            hero.x = LEFT_BORDER + Math.floor(Math.random() * (RIGHT_BORDER - LEFT_BORDER) / TILE_SIZE) * TILE_SIZE;
            hero.y = BOTTOM_BORDER;
            addChild(hero);
        }

        private function createEnemies():void {
            // Shuffling an array of positions
            shuffleArray(positions);

            // Creating and adding 6 enemies to the enemies array
            for (var i:int = 0; i < ENEMY_ROW; i++) {
                var enemy:DisplayObject = new Assets.ShipImage();

                // Selecting the first position from a shuffled array
                enemy.x = positions[i];
                enemy.y = TOP_BORDER;
                enemies.push(enemy);
                addChild(enemies[enemies.length - 1]);
            }
        }

        // Function to generate possible horizontal positions
        private function generatePositions(minX:Number, maxX:Number, step:Number):Array {
            var positions:Array = [];
            for (var posX:Number = minX; posX <= maxX - step; posX += step) {
                positions.push(posX);
            }

            return positions;
        }

        // Function for shuffling the array (Fisher-Yates shuffle)
        private function shuffleArray(array:Array):void {
            for (var i:int = array.length - 1; i > 0; i--) {
                var j:int = Math.floor(Math.random() * (i + 1));
                var temp:* = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
        }

        private function keyPress(event:KeyboardEvent):void {
            // key "Left"
            if (event.keyCode == 37) {
                hero.x -= TILE_SIZE;
            }

            // key "Right"
            if (event.keyCode == 39) {
                hero.x += TILE_SIZE;
            }

            // key "X"
            if (event.keyCode == 88) {
                // TODO: Create a method for shooting
                shootBullet();
            }
        }

        private function shootBullet():void {
            // We create a bullet only if it is not already on the scene
            if (!bullet) {
                bullet = new Assets.BulletImage();
                bullet.x = hero.x;
                bullet.y = hero.y;
                addChild(bullet);
                addEventListener(Event.ENTER_FRAME, onEnterFrame);
            }
        }

        private function onEnterFrame(e:Event):void {
            if (bullet) {
                bullet.y -= TILE_SIZE;
                if (bullet.y < TOP_BORDER) {
                    removeBullet();
                } else {
                    checkBulletCollision();
                }
            }
        }

        private function checkBulletCollision():void {
            for (var i:int = 0; i < enemies.length; i++) {
                var enemy:DisplayObject = enemies[i];
                if (bullet.x == enemy.x && bullet.y == enemy.y) {
                    removeChild(enemy);
                    enemies.splice(i, 1);
                    removeBullet();
                    break;
                }
            }
        }

        private function removeBullet():void {
            removeChild(bullet);
            bullet = null;
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function update(event:TimerEvent):void {
            // Move all enemies down
            for each (var enemy:DisplayObject in enemies) {
                enemy.y += TILE_SIZE;
            }

            // Creating a new row of enemies
            createEnemies();
        }

        private function finalize():void {
            if (timer.running) {
                timer.stop();
            }

            timer.removeEventListener(TimerEvent.TIMER, update);
            timer = null;

            stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPress);

            removeHero();

            removeEnemies();

            removeChild(gameBackground);
            gameBackground = null;
        }

        private function removeHero():void {
            removeChild(hero);
            hero = null;
        }

        private function removeEnemies():void {
            if (enemies.length > 0) {
                for (var i:int = 0; i < enemies.length; i++) {
                    removeChild(enemies[i]);
                }
            }

            enemies = null;
        }
    }
}