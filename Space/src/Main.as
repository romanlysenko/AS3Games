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
        private const RIGHT_BORDER:int = 256;
        private const TOP_BORDER:int = 80;
        private const BOTTOM_BORDER:int = 384;
        private const TILE_SIZE:int = 16;
        private const ENEMY_ROW:int = 6;

        private var gameBackground:DisplayObject;

        private var enemies:Array;
        private var hero:DisplayObject;

        private var timer:Timer;
        private var speed:Number = 500;

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

            hero = new Assets.ShipImage();
            hero.x = 176;
            hero.y = 384;
            addChild(hero);

            enemies = [];
            enemies.push(new Assets.ShipImage());
            enemies[0].x = 128;
            enemies[0].y = 80;
            addChild(enemies[0]);

            // TODO: Find out if this is necessary
            stage.focus = stage;

            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress);

            timer = new Timer(speed, 0);
            timer.addEventListener(TimerEvent.TIMER, update);
            timer.start();
        }

        private function keyPress(event:KeyboardEvent):void {
            // key "Left"
            if (event.keyCode == 37) {
                hero.x -= 16;
            }

            // key "Right"
            if (event.keyCode == 39) {
                hero.x += 16;
            }

            // key "X"
            if (event.keyCode == 88) {
                // TODO: Create a method for shooting
            }
        }

        private function update(event:TimerEvent):void {

        }

        private function finalize():void {
            if (timer.running) {
                timer.stop();
            }

            timer.removeEventListener(TimerEvent.TIMER, update);
            timer = null;

            stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPress);

            removeChild(gameBackground);
            gameBackground = null;
        }
    }
}