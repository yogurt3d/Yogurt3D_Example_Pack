package
{
	import com.yogurt3d.core.managers.tickmanager.TickManager;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.materials.base.Material;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.io.loaders.DataLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	import com.yogurt3d.presets.setup.TargetSetup;
	import com.yogurt3d.test.BaseTest;
	import com.yogurt3d.test.assets.CustomShader;
	
	import flash.net.URLLoaderDataFormat;
	
	[SWF(width="800", height="600", frameRate="60")]
	public class CustomShaderTest extends BaseTest implements ITickedObject
	{
		public static const PATH:String =  "http://www.yogurt3d.com/examples/resources/";//"../resources/runtimeResources/"; // 
		
		protected var material:Material;
		protected var sceneObject:SceneObjectRenderable;
		
		private var setup:TargetSetup;
		
		public function CustomShaderTest()
		{			
			super();
			
			setup = new TargetSetup(this);
			
			createSceneObjects();
			
			TickManager.registerObject( this );
		}
		public function createSceneObjects():void{
			showLoader();
			
			var loader:LoadManager = new LoadManager();
			loader.add( PATH + "Head.y3d", DataLoader, Y3D_Parser, {dataFormat: URLLoaderDataFormat.BINARY} );
			loader.addEventListener( LoaderEvent.LOAD_PROGRESS, function( _e:LoaderEvent ):void{
				var path:String = _e.loader.loadPath;
				path = path.substr( path.lastIndexOf("/")+1 );
				setLoaderData( _e.bytesLoaded / _e.bytesTotal * 100, "Loading " + path + " ... \t\t("+Math.round(_e.bytesLoaded/1024)+"KB/"+ Math.round(_e.bytesTotal/1024) +"KB)" );
			});
			loader.addEventListener( LoaderEvent.ALL_COMPLETE, function( _E:LoaderEvent ):void
			{
				setup.scene.sceneColor.setColorUint( 0xFF333333 );
				
				material = new Material();
				material.shaders.push( new CustomShader() );
				
				sceneObject = new SceneObjectRenderable();
				sceneObject.geometry = loader.getLoadedContent(PATH + "Head.y3d");
				sceneObject.material = material;
				setup.scene.addChild( sceneObject );

				setup.camera.dist = 15;
				
				hideLoader();
			});
			loader.start();
		}
		
		public function updateWithTimeInfo(_timeInfo:TimeInfo):void{
			if( sceneObject )
				sceneObject.transformation.rotationY += 0.5;
		}
	}
}