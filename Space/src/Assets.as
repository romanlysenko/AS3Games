package {

    public class Assets {
        [Embed(source="fonts/emulogic.ttf", fontFamily="Emulogic", mimeType="application/x-font", embedAsCFF="false")]
        private var Emulogic:Class;

        [Embed(source="assets/gameBackground.png")]
        public static var GameBackground:Class;

        [Embed(source="assets/shipImage.png")]
        public static var ShipImage:Class;

        [Embed(source="assets/bulletImage.png")]
        public static var BulletImage:Class;

        /*[Embed(source="track1.mp3")]
        public static var Track1:Class;
        private var track1:Sound = new Track1() as Sound;
        track1.play();*/
    }
}