

package
{
	import flash.events.KeyboardEvent;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
 
    public class Root extends Sprite
    {
        private static var sAssets:AssetManager;
 
        public function Root()
        {
        }
        public function start(background:Texture, assets:AssetManager):void
        {
            sAssets = assets;
			var bg:Image = new Image(background);
            addChild(bg);
            assets.loadQueue(function onProgress(ratio:Number):void
            {
                if (ratio == 1)
                {
					bg.removeFromParent(true);
                    var scene:Scene = new Scene();
                    addChild(scene);
					//scene.x = 100;
					
                }
            });
        }
 
        public static function get assets():AssetManager { return sAssets; }
    }
}

