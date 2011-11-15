package
{
	import com.yogurt3d.core.materials.MaterialTexture;
	import com.yogurt3d.core.materials.base.Material;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.io.loaders.DisplayObjectLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.TextureMap_Parser;
	import com.yogurt3d.presets.primitives.sceneobjects.PlaneSceneObject;
	import com.yogurt3d.presets.setup.BasicSetup;
	import com.yogurt3d.test.BaseTest;
	
	import flash.geom.Vector3D;
	
	import net.hires.debug.Stats;
	
	[SWF(width="800", height="600", frameRate="120")]
	public class AlphaTextureTest extends BaseTest
	{
		public static const PATH:String = "../resources/runtimeResources/"; //"http://www.yogurt3d.com/examples/resources/"; //
		
		protected var material:Material;
		protected var sceneObject:SceneObjectRenderable;
		
		private var setup:BasicSetup;
		
		public function AlphaTextureTest()
		{			
			super();
			setup = new BasicSetup(this);
			
			loadObjects();
		}
		private function loadObjects():void
		{
			showLoader();
			this.addChild( new Stats() );
			
			var loader:LoadManager = new LoadManager();
			loader.add( PATH + "alpha.png", DisplayObjectLoader, TextureMap_Parser );
			
			loader.addEventListener( LoaderEvent.LOAD_PROGRESS, function( _e:LoaderEvent ):void{
				var path:String = _e.loader.loadPath;
				path = path.substr( path.lastIndexOf("/")+1 );
				setLoaderData( _e.bytesLoaded / _e.bytesTotal * 100, "Loading " + path +"..." );
			});
			loader.addEventListener( LoaderEvent.ALL_COMPLETE, function( _E:LoaderEvent ):void
			{				
				setup.scene.sceneColor.setColorUint(0xFF333333 );
				
				sceneObject = new PlaneSceneObject();
				var texture:TextureMap = loader.getLoadedContent( PATH + "alpha.png" );
				sceneObject.material = new MaterialTexture( texture );
				MaterialTexture(sceneObject.material).alphaTexture = true;
				setup.scene.addChild( sceneObject );
				
				setup.camera.transformation.position = new Vector3D(0,2,0);
				setup.camera.transformation.rotationX = -90;
				
				hideLoader();
			});
			loader.start();
		}
		
	}
}