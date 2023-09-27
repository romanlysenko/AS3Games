package {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    [SWF(width="640", height="480", backgroundColor="#333333", frameRate="60")]
    public class Main extends Sprite {
        private const LEFT_BORDER:int = 112;
        private const RIGHT_BORDER:int = 256;
        private const TOP_BORDER:int = 80;
        private const BOTTOM_BORDER:int = 384;
        private const TILE_SIZE:int = 16;

        private var gameBackground:DisplayObject;

        private var levels:Array;
        private var grid:Array;
        private var currentLevel:int = 1;

        private var snake:Array;
        private var currentMoveX:int = 0;
        private var currentMoveY:int = 0;
        private var nextMoveX:int = 0;
        private var nextMoveY:int = 0;
        private var headX:int;
        private var headY:int;

        //private var food:Food; // for debug
        private var food:DisplayObject;

        private var timer:Timer;
        private var speed:Number = 200;

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

            createLevelsData();

            drawCurrentLevel(levels, currentLevel);

            // TODO: Need to add information about score, current level, etc.

            createSnake();

            //food = new Food(); // for debug
            food = new Assets.FoodImage();
            createFood();

            // TODO: Find out if this is necessary
            //stage.focus = stage;

            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress);

            timer = new Timer(speed, 0);
            timer.addEventListener(TimerEvent.TIMER, update);
            timer.start();
        }

        private function createLevelsData():void {
            levels = [];

            levels[0] = [
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 1
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 2
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 3
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 4
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 5
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 6
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 7
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 8
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 9
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 10
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 11
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 12
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 13
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 14
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 15
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 16
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 17
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 18
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 19
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]   // 20
            ];

            levels[1] = [
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 1
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 2
                [0, 0, 1, 1, 0, 0, 0, 0, 0, 0],  // 3
                [0, 0, 1, 1, 0, 0, 0, 0, 0, 0],  // 4
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 5
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 6
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 7
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 8
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 9
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 10
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 11
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 12
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 13
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 14
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 15
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 16
                [0, 0, 0, 0, 0, 0, 1, 1, 0, 0],  // 17
                [0, 0, 0, 0, 0, 0, 1, 1, 0, 0],  // 18
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 19
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]   // 20
            ];
        }

        private function drawCurrentLevel(data:Array, level:int):void {
            grid = [];

            for (var i:int = 0; i < data[level].length; i++) {
                grid[i] = [];

                for (var j:int = 0; j < data[level][i].length; j++) {
                    // draw and display grass
                    /*if (data[level][i][j] == 0) {
                        grid[i][j] = new Assets.EmptyImage();
                        grid[i][j].x = 112 + grid[i][j].width * j;
                        grid[i][j].y = 80 + grid[i][j].height * i;
                        addChild(grid[i][j]);
                    }*/

                    // draw and display walls
                    if (data[level][i][j] == 1) {
                        grid[i][j] = new Assets.WallImage();
                        grid[i][j].x = 112 + grid[i][j].width * j;
                        grid[i][j].y = 80 + grid[i][j].height * i;
                        addChild(grid[i][j]);
                    }
                }
            }
        }

        private function createSnake():void {
            snake = [];

            //snake.push(new Segment(0x0000ff)); // for debug
            snake.push(new Assets.SnakeImage());
            headX = snake[0].x = LEFT_BORDER;
            headY = snake[0].y = TOP_BORDER;

            addChild(snake[0]);
        }

        private function addSegment():void {
            //snake.push(new Segment()); // for debug
            snake.push(new Assets.SnakeImage());
            addChild(snake[snake.length - 1]);
        }

        private function sortSegments():void {
            for (var i:int = snake.length - 1; i > 0; i--) {
                snake[i].x = snake[i - 1].x;
                snake[i].y = snake[i - 1].y;
            }
        }

        private function createFood():void {
            food.x = LEFT_BORDER + Math.floor(Math.random() *
                    (RIGHT_BORDER - LEFT_BORDER + TILE_SIZE) / TILE_SIZE) * TILE_SIZE;
            food.y = TOP_BORDER + Math.floor(Math.random() *
                    (BOTTOM_BORDER - TOP_BORDER + TILE_SIZE) / TILE_SIZE) * TILE_SIZE;

            for (var i:int = 0; i < snake.length; i++) {
                if (food.x == snake[i].x && food.y == snake[i].y) {
                    createFood();
                }
            }

            if (foodCollision()) {
                createFood();
            }

            if (wallCollision(food.x, food.y)) {
                createFood();
            }

            addChild(food);
        }

        private function keyPress(event:KeyboardEvent):void {
            if (event.keyCode == 37) {
                if (currentMoveX != 1) {
                    nextMoveX = -1;
                    nextMoveY = 0;
                }
            }

            if (event.keyCode == 39) {
                if (currentMoveX != -1) {
                    nextMoveX = 1;
                    nextMoveY = 0;
                }
            }

            if (event.keyCode == 38) {
                if (currentMoveY != 1) {
                    nextMoveX = 0;
                    nextMoveY = -1;
                }
            }

            if (event.keyCode == 40) {
                if (currentMoveY != -1) {
                    nextMoveX = 0;
                    nextMoveY = 1;
                }
            }
        }

        // TODO: Need to fix bug with self collision and with wall, take one step back
        private function update(event:TimerEvent):void {
            currentMoveX = nextMoveX;
            currentMoveY = nextMoveY;

            headX = snake[0].x + currentMoveX * TILE_SIZE;
            headY = snake[0].y + currentMoveY * TILE_SIZE;

            if (borderCrossing()) {
                if (foodCollision()) {
                    addSegment();
                    createFood();
                }
            }

            if (selfCollision() || wallCollision(headX, headY)) {
                timer.stop();
            }

            if (foodCollision()) {
                addSegment();
                createFood();
            }

            sortSegments();

            snake[0].x = headX;
            snake[0].y = headY;
        }

        private function borderCrossing():Boolean {
            if (headX > RIGHT_BORDER) {
                headX = LEFT_BORDER;
                return true;
            }

            if (headX < LEFT_BORDER) {
                headX = RIGHT_BORDER;
                return true;
            }

            if (headY > BOTTOM_BORDER) {
                headY = TOP_BORDER;
                return true;
            }

            if (headY < TOP_BORDER) {
                headY = BOTTOM_BORDER;
                return true;
            }

            return false;
        }

        private function selfCollision():Boolean {
            for (var i:int = 1; i < snake.length; i++) {
                if (headX == snake[i].x && headY == snake[i].y) {
                    return true;
                }
            }

            return false;
        }

        // Used for detect the location (x, y) of food or a snake head on a wall
        private function wallCollision(objX:*, objY:*):Boolean {
            for (var i:int = 0; i < levels[currentLevel].length; i++) {
                for (var j:int = 0; j < levels[currentLevel][i].length; j++) {
                    if (levels[currentLevel][i][j] == 1) {
                        if (objX == grid[i][j].x && objY == grid[i][j].y) {
                            return true;
                        }
                    }
                }
            }

            return false;
        }

        private function foodCollision():Boolean {
            return headX == food.x && headY == food.y;
        }

        private function levelCompleted():void {
            if (snake.length == 10) {
                timer.stop();
            }
        }

        private function finalize():void {
            if (timer.running) {
                timer.stop();
            }

            timer.removeEventListener(TimerEvent.TIMER, update);
            timer = null;

            stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPress);

            // TODO: It is necessary to implement functions to clear the scene and free up memory
            //removeFood();
            //removeSnake();
            //removeWalls();

            removeChild(gameBackground);
            gameBackground = null;
        }

    }

}
