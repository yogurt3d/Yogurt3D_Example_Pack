package
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.events.MouseEvent3D;
	import com.yogurt3d.core.geoms.Mesh;
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.managers.tickmanager.TickManager;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.materials.MaterialDiffuseFill;
	import com.yogurt3d.core.materials.MaterialFill;
	import com.yogurt3d.core.materials.MaterialSpecularTexture;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.transformations.Transformation;
	import com.yogurt3d.io.loaders.DataLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.TextureMap_Parser;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	import com.yogurt3d.presets.primitives.sceneobjects.BoxSceneObject;
	import com.yogurt3d.presets.primitives.sceneobjects.PlaneSceneObject;
	import com.yogurt3d.presets.setup.TargetSetup;
	import com.yogurt3d.test.BaseTest;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoaderDataFormat;
	
	import net.hires.debug.Stats;
	
	import skybox.DuskSkyBox;

	[SWF(width="800", height="600", frameRate="60")]
	public class BuildingTest extends BaseTest implements ITickedObject
	{
		public static const PATH:String = "http://www.yogurt3d.com/examples/resources/";//"../resources/runtimeResources/"; //
		private var light:RenderableLight;
		private var light2:RenderableLight;
		private var sceneObject:SceneObjectRenderable;
		private var bitmapData:BitmapData;
		
		private var setup:TargetSetup;
		public function BuildingTest() 
		{
			super();
			
			setup = new TargetSetup(this);
			
			createSceneObjects();
			
			TickManager.registerObject( this );
		}
		
		public function createSceneObjects():void{
			showLoader();

			this.addChild( new Stats() );
			var loader:LoadManager = new LoadManager();
			loader.add( PATH +  "house_normal.atf", DataLoader, TextureMap_Parser, {dataFormat: URLLoaderDataFormat.BINARY} );
			loader.add( PATH + "house_diffuse.atf", DataLoader, TextureMap_Parser, {dataFormat: URLLoaderDataFormat.BINARY} );
			loader.add( PATH + "house_spec.atf", DataLoader, TextureMap_Parser, {dataFormat: URLLoaderDataFormat.BINARY} );
			loader.add( PATH + "House.y3d", DataLoader, Y3D_Parser, {dataFormat: URLLoaderDataFormat.BINARY} );
			loader.addEventListener( LoaderEvent.LOAD_PROGRESS, function( _e:LoaderEvent ):void{
				var path:String = _e.loader.loadPath;
				path = path.substr( path.lastIndexOf("/")+1 );
				setLoaderData( _e.bytesLoaded / _e.bytesTotal * 100, "Loading " + path + " ... \t\t("+Math.round(_e.bytesLoaded/1024)+"KB/"+ Math.round(_e.bytesTotal/1024) +"KB)" );
			});
			loader.addEventListener( LoaderEvent.ALL_COMPLETE, function( _E:LoaderEvent ):void
			{
				
				setup.scene.skyBox = new DuskSkyBox();
				
				// Create Building
				var _mesh:Mesh = loader.getLoadedContent(  PATH + "House.y3d") as Mesh;
				var _mat:MaterialSpecularTexture = new MaterialSpecularTexture( loader.getLoadedContent( PATH + "house_diffuse.atf") );
				_mat.specularMap = loader.getLoadedContent( PATH + "house_spec.atf");
				_mat.normalMap = loader.getLoadedContent( PATH + "house_normal.atf");
				_mat.ambientColor.a = 0.3;
				_mat.shininess = 10;
				
				var box:BoxSceneObject = new BoxSceneObject();
				box.material = new MaterialFill( 0xFF0000 );
				setup.scene.addChild( box );
				
				sceneObject = new SceneObjectRenderable();
				sceneObject.geometry = _mesh;
				sceneObject.material = _mat;
				//sceneObject.interactive = true;
				setup.scene.addChild( sceneObject );
				sceneObject.onMouseMove.add( function( _e:MouseEvent3D ):void{
				//	box.transformation.position = _e.intersection;
				});
				
				// Create Floor
				var plane:PlaneSceneObject = new PlaneSceneObject( 10000, 10000, 1, 1 );
				plane.material = new MaterialDiffuseFill( 0x1E3C00 );
				plane.pickEnabled = false;
				setup.scene.addChild( plane );
				
				// create light 1
				light = new RenderableLight(ELightType.POINT, 0xFFFFFF, 5);
				light.transformation.position = new Vector3D(600,300,800);
				light.intensity = 0.75;
				setup.scene.addChild( light );
				
				// create light 2
				light2 = new RenderableLight(ELightType.POINT,0xFFFFFF, 5);
				light2.transformation.position = new Vector3D(-600,300,800);
				light2.intensity = 0.75;
				setup.scene.addChild( light2 );
				
				
				// set camera projection
				setup.camera.frustum.setProjectionPerspective( 75, 800/600, 1, 9000);
				

				// setup default camera pos
				setup.camera.dist = 1600;
				setup.camera.rotY = -45;
				setup.camera.rotX = -30;
				setup.camera.limitRotXMin = -90;
				setup.camera.limitRotXMax = -1;

				hideLoader();
			});
			loader.start();
		}
		
		public function updateWithTimeInfo(_timeInfo:TimeInfo):void{
			if( light )
			{
				light.transformation.position = new Vector3D(
					800* Math.sin( (_timeInfo.objectTime / 1000) * 50 * Transformation.DEG_TO_RAD ),
					500*1,
					650* Math.cos( (_timeInfo.objectTime / 1000) * 50 * Transformation.DEG_TO_RAD )
				);
				light2.transformation.position = light.transformation.position;
				light2.transformation.x *= -1;
				light2.transformation.z *= -1;
			}
		}
	}
}