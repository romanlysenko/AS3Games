/**
 * AS3Games
 * Copyright 2023 Roman Lysenko
 * Email: romanlysenkoua@gmail.com
 */

package {
    import flash.display.Shape;

    public class Food extends Shape {

        public function Food() {
            graphics.beginFill(0xff0000, 1);
            graphics.drawRect(0, 0, 16, 16);
        }

    }

}
