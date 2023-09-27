package {

    public class Assets {
        [Embed(source="fonts/emulogic.ttf", fontFamily="Emulogic", mimeType="application/x-font", embedAsCFF="false")]
        private var Emulogic:Class;

        [Embed(source="assets/gameBackground.png")]
        public static var GameBackground:Class;

        [Embed(source="assets/snakeImage.png")]
        public static var SnakeImage:Class;

        [Embed(source="assets/foodImage.png")]
        public static var FoodImage:Class;

        [Embed(source="assets/wallImage.png")]
        public static var WallImage:Class;

        /*[Embed(source="track1.mp3")]
        public static var Track1:Class;
        private var track1:Sound = new Track1() as Sound;
        track1.play();*/
    }

}
