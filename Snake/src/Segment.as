/**
 * AS3Games
 * Copyright 2023 Roman Lysenko
 * Email: romanlysenkoua@gmail.com
 */

package {
    import flash.display.Shape;

    public class Segment extends Shape {

        public function Segment(newColor:uint = 0x00ff00) {
            graphics.beginFill(newColor, 1);
            graphics.drawRect(0, 0, 16, 16);
        }

    }

}
