package
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.events.MouseEvent3D;
	import com.yogurt3d.core.geoms.Mesh;
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.lights.Light;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.managers.contextmanager.Context;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.materials.MaterialBitmap;
	import com.yogurt3d.core.materials.MaterialDiffuseFill;
	import com.yogurt3d.core.materials.MaterialDiffuseTexture;
	import com.yogurt3d.core.materials.MaterialEnvMapping;
	import com.yogurt3d.core.materials.MaterialFill;
	import com.yogurt3d.core.materials.MaterialSpecularFill;
	import com.yogurt3d.core.materials.MaterialTexture;
	import com.yogurt3d.core.materials.MaterialTextureColorFresnel;
	import com.yogurt3d.core.materials.MaterialTwoColorFresnel;
	import com.yogurt3d.core.materials.base.Material;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.core.transformations.Transformation;
	import com.yogurt3d.core.viewports.Viewport;
	import com.yogurt3d.io.loaders.DisplayObjectLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.TextureMap_Parser;
	import com.yogurt3d.presets.primitives.meshs.GeodesicSphereMesh;
	import com.yogurt3d.presets.primitives.sceneobjects.BoxSceneObject;
	import com.yogurt3d.presets.primitives.sceneobjects.PlaneSceneObject;
	import com.yogurt3d.presets.renderers.molehill.MolehillRenderer;
	import com.yogurt3d.presets.setup.BasicSetup;
	import com.yogurt3d.presets.setup.TargetSetup;
	import com.yogurt3d.test.BaseTest;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import net.hires.debug.Stats;
	
	import skybox.DuskSkyBox;

	[SWF(width="800", height="600", frameRate="60")]
	public class ViewportTest extends BaseTest implements ITickedObject
	{
		
		public static const PATH:String = "../resources/runtimeResources/"; // "http://www.yogurt3d.com/examples/resources/"
		
		
		private var light:Light;
		private var sceneObject:SceneObjectRenderable;
		
		private var setup:TargetSetup;
		private var setup2:TargetSetup;
		
		public function ViewportTest()
		{
			super();
			
			setup = new TargetSetup(this);
			setup2 = new TargetSetup(this);

			setup2.scene = setup.scene;
			//setup2.camera = setup.camera;
			
			setup.camera.dist = 100;
			setup.camera.frustum.setProjectionPerspective( 75, 400/600, 1, 9000);
			
			setup2.camera.dist = 100;
			setup2.camera.frustum.setProjectionPerspective( 75, 400/600, 1, 9000);
			
			setup.setArea(0,0,400,600);
			setup2.setArea(400,0,400,600);
			
			createSceneObjects();
		}
		
		public function createSceneObjects():void{
			showLoader();

			var loader:LoadManager = new LoadManager();
			loader.add( PATH + "blender-002.jpg", DisplayObjectLoader, TextureMap_Parser );
			loader.add( PATH + "Ogre.jpg", DisplayObjectLoader, TextureMap_Parser );
			loader.addEventListener( LoaderEvent.LOAD_PROGRESS, function( _e:LoaderEvent ):void{
				var path:String = _e.loader.loadPath;
				path = path.substr( path.lastIndexOf("/")+1 );
				setLoaderData( _e.bytesLoaded / _e.bytesTotal * 100, "Loading " + path + " ... \t\t("+Math.round(_e.bytesLoaded/1024)+"KB/"+ Math.round(_e.bytesTotal/1024) +"KB)" );
			});
			loader.addEventListener( LoaderEvent.ALL_COMPLETE, function( _E:LoaderEvent ):void
			{
				setup.scene.skyBox = new DuskSkyBox();
				
				// Create Building
				var mesh:Mesh = new GeodesicSphereMesh(10,16);
				var mat:Material = new MaterialTwoColorFresnel(  );
				var mat2:Material = new MaterialTexture( loader.getLoadedContent(PATH +"blender-002.jpg") as TextureMap );
				
				// BUG FIX: Bug reason unknown but these two lines fix it
				mat2.shaders[0].getProgram(Yogurt3D.CONTEXT3D[0], null, "Mesh");
				mat2.shaders[0].getProgram(Yogurt3D.CONTEXT3D[1], null, "Mesh");
				
				sceneObject = new SceneObjectRenderable();
				sceneObject.geometry = mesh;
				sceneObject.material = mat2;
				sceneObject.transformation.y = 10;
				sceneObject.transformation.z = -5;
				setup.scene.addChild( sceneObject );
				
				sceneObject = new SceneObjectRenderable();
				sceneObject.geometry = mesh;
				sceneObject.material = mat2;
				sceneObject.transformation.y = 10;
				sceneObject.transformation.z = -25;				
				setup.scene.addChild( sceneObject );
				
				/*
				sceneObject = new SceneObjectRenderable();
				sceneObject.geometry = mesh;
				sceneObject.material = mat2;
				sceneObject.transformation.y = 10;
				sceneObject.transformation.z = 0;				
				setup2.scene.addChild( sceneObject );
				
				sceneObject = new SceneObjectRenderable();
				sceneObject.geometry = mesh;
				sceneObject.material = mat;
				sceneObject.transformation.y = 10;
				sceneObject.transformation.z = -25;				
				setup2.scene.addChild( sceneObject );*/

			
				hideLoader();
			}
			);
			loader.start();
		}
		
		public function updateWithTimeInfo(_timeInfo:TimeInfo):void{
			if( light )
			{
				light.transformation.position = new Vector3D(
					80* Math.sin( (_timeInfo.objectTime / 1000) * 50 * Transformation.DEG_TO_RAD ),
					50*1,
					65* Math.cos( (_timeInfo.objectTime / 1000) * 50 * Transformation.DEG_TO_RAD )
				);
				
				//light.transformation.position = camera.transformation.position;
				//light.transformation.y += 200;
				//light.transformation.lookAt( new Vector3D );
				//bitmapData.noise( int(Math.random() * 100), 0, 255, 7, true );
			}
		}
	}
}