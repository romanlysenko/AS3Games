package {
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    [SWF(width="640", height="480", backgroundColor="#333333", frameRate="30")]
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

        private var leftPressed:Boolean = false;
        private var rightPressed:Boolean = false;
        private var xPressed:Boolean = false;
        private var lastShootTime:Number = 0;

        // Firing interval in milliseconds
        private var shootInterval:Number = 500;

        private var timer:Timer;
        private var speed:Number = 1500;

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

            // Adding keyboard event listeners
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);

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

        private function onKeyDown(e:KeyboardEvent):void {
            if (e.keyCode == 37) { // key "Left"
                leftPressed = true;
            } else if (e.keyCode == 39) { // key "Right"
                rightPressed = true;
            } else if (e.keyCode == 88) { // key "X"
                xPressed = true;
            }
        }

        private function onKeyUp(e:KeyboardEvent):void {
            if (e.keyCode == 37) { // key "Left"
                leftPressed = false;
            } else if (e.keyCode == 39) { // key "Right"
                rightPressed = false;
            } else if (e.keyCode == 88) { // key "X"
                xPressed = false;
            }
        }

        private function onEnterFrame(e:Event):void {
            if (leftPressed) {
                // Changing the driving speed
                hero.x -= TILE_SIZE;

                if (hero.x < LEFT_BORDER) {
                    hero.x = LEFT_BORDER;
                }
            }

            if (rightPressed) {
                // Changing the driving speed
                hero.x += TILE_SIZE;

                if (hero.x > RIGHT_BORDER - TILE_SIZE) {
                    hero.x = RIGHT_BORDER - TILE_SIZE;
                }
            }

            if (xPressed) {
                var currentTime:Number = new Date().getTime();

                if (currentTime - lastShootTime > shootInterval) {
                    shootBullet();
                    lastShootTime = currentTime;
                }
            }

            if (bullet) {
                bullet.y -= TILE_SIZE;

                if (bullet.y < TOP_BORDER) {
                    removeBullet();
                } else {
                    checkBulletCollision();
                }
            }
        }

        private function checkCollisionWithHero():Boolean {
            for each (var enemy:DisplayObject in enemies) {
                if (enemy.y >= hero.y) {
                    return true;
                }
            }

            return false;
        }

        private function shootBullet():void {
            // We create a bullet only if it is not already on the scene
            if (!bullet) {
                bullet = new Assets.BulletImage();
                bullet.x = hero.x;
                bullet.y = hero.y;
                addChild(bullet);
            }
        }

        private function checkBulletCollision():void {
            for (var i:int = 0; i < enemies.length; i++) {
                var enemy:DisplayObject = enemies[i];

                if (bullet.x < enemy.x + 16 && bullet.x + 16 > enemy.x &&
                        bullet.y < enemy.y + 16 && bullet.y + 16 > enemy.y) {
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
        }

        private function update(event:TimerEvent):void {
            // Move all enemies down
            for each (var enemy:DisplayObject in enemies) {
                enemy.y += TILE_SIZE;
            }

            // Checking for enemy collisions with the player
            if (checkCollisionWithHero()) {
                finalize();
                return;
            }

            // Creating a new row of enemies
            createEnemies();
        }

        // End game
        private function finalize():void {
            // Stop timer
            if (timer.running) {
                timer.stop();
            }

            timer.removeEventListener(TimerEvent.TIMER, update);
            timer = null;

            // Remove all enemies
            for each (var enemy:DisplayObject in enemies) {
                removeChild(enemy);
            }

            enemies = null;

            // Remove player
            removeChild(hero);
            hero = null;

            // Remove the bullet if there is one
            if (bullet) {
                removeBullet();
            }

            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

            // Remove frame handler
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);

            // Display a message about the end of the game
            trace("Game Over");
        }
    }
}