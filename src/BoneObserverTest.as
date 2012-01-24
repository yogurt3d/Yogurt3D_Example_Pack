package
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.animation.controllers.SkinController;
	import com.yogurt3d.core.events.MouseEvent3D;
	import com.yogurt3d.core.geoms.Mesh;
	import com.yogurt3d.core.geoms.SkeletalAnimatedMesh;
	import com.yogurt3d.core.geoms.interfaces.IMesh;
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.lights.Light;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.managers.idmanager.IDManager;
	import com.yogurt3d.core.managers.tickmanager.TickManager;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.materials.MaterialDiffuseFill;
	import com.yogurt3d.core.materials.MaterialDiffuseTexture;
	import com.yogurt3d.core.materials.MaterialFill;
	import com.yogurt3d.core.materials.MaterialSpecularFill;
	import com.yogurt3d.core.materials.MaterialSpecularTexture;
	import com.yogurt3d.core.materials.MaterialTexture;
	import com.yogurt3d.core.materials.base.Material;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectContainer;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.io.loaders.CompressedFile;
	import com.yogurt3d.io.loaders.DataLoader;
	import com.yogurt3d.io.loaders.DisplayObjectLoader;
	import com.yogurt3d.io.loaders.ZipFileLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.TextureMap_Parser;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	import com.yogurt3d.io.parsers.YOA_Parser;
	import com.yogurt3d.presets.primitives.sceneobjects.BoxSceneObject;
	import com.yogurt3d.presets.primitives.sceneobjects.PlaneSceneObject;
	import com.yogurt3d.presets.setup.TargetSetup;
	import com.yogurt3d.test.BaseTest;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoaderDataFormat;
	
	import net.hires.debug.Stats;
	
	import org.osmf.elements.ImageLoader;
	
	import skybox.DuskSkyBox;
	
	[SWF(width="800", height="600", frameRate="60")]
	public class BoneObserverTest extends BaseTest implements ITickedObject
	{
		public static const PATH:String = "../resources/runtimeResources/"; //"http://www.yogurt3d.com/examples/resources/"; //"http://www.yogurt3d.com/examples/resources/";//
		
		private var ogre:SceneObjectRenderable;
		private var mace:SceneObjectRenderable;
		private var surface:SceneObjectRenderable;
		
		private var light:RenderableLight;
		private var light2:RenderableLight;
	
		private var setup:TargetSetup;
		
		public function BoneObserverTest()
		{
			super();
			
			setup = new TargetSetup( this );
			
			loadObjects();
			
			TickManager.registerObject( this );
		}
		private function loadObjects():void{
			showLoader();
			
			this.addChild( new Stats() );
			var loader:LoadManager = new LoadManager();
			loader.add( PATH + "ogre.zip", ZipFileLoader, null, {dataFormat: URLLoaderDataFormat.BINARY}  );
			loader.addEventListener( LoaderEvent.LOAD_PROGRESS, function( _e:LoaderEvent ):void{
				var path:String = _e.loader.loadPath;
				path = path.substr( path.lastIndexOf("/")+1 );
				setLoaderData( _e.bytesLoaded / _e.bytesTotal * 100, "Loading " + path + " ... \t\t("+Math.round(_e.bytesLoaded/1024)+"KB/"+ Math.round(_e.bytesTotal/1024) +"KB)" );
			});
			loader.addEventListener( LoaderEvent.ALL_COMPLETE, function( _E:LoaderEvent ):void
			{
				setup.scene.skyBox = new DuskSkyBox();
				
				// Create Building
				var _mesh:IMesh = CompressedFile(loader.getLoadedContent(  PATH + "ogre.zip")).getContent("ogre.y3d") as IMesh;
				var _mat:MaterialDiffuseTexture = new MaterialDiffuseTexture( CompressedFile(loader.getLoadedContent(  PATH + "ogre.zip")).getContent("Ogre.jpg") );
				_mat.ambientColor.a = 0.3;
				//_mat.shininess = 10;
				
				SkinController(SkeletalAnimatedMesh(_mesh).controller).addAnimation( "walk", CompressedFile(loader.getLoadedContent(  PATH + "ogre.zip")).getContent("ogre.yoa") );
				
				var container:SceneObject = new SceneObject();
				
				ogre = new SceneObjectRenderable();
				ogre.geometry = _mesh;
				ogre.material = _mat;
				container.addChild( ogre );
				ogre.transformation.scale = 5;
				ogre.transformation.y = -.1;
				container.userID = "ogre";
				
				ogre.geometry.axisAlignedBoundingBox.centerGlobal;
				
				mace = new SceneObjectRenderable();
				mace.geometry = CompressedFile(loader.getLoadedContent(  PATH + "ogre.zip")).getContent("mace.y3d");
				mace.material = new MaterialSpecularFill(0x999999);
				container.addChild( mace );
				
				SkinController(SkeletalAnimatedMesh(_mesh).controller).playAnimation("walk");
				
				SkeletalAnimatedMesh(_mesh).bones[12].addObserver( mace.transformation, ogre.transformation,null, new Vector3D(-.07,-.04,.1) /*front,side,up */ );
				
				setup.scene.addChild(container);
				
				// Create Floor
				surface = new SceneObjectRenderable( );
				surface.geometry = CompressedFile(loader.getLoadedContent(  PATH + "ogre.zip")).getContent("zemin.y3d");
				surface.material = new MaterialDiffuseTexture(CompressedFile(loader.getLoadedContent(  PATH + "ogre.zip")).getContent("zemin.jpg"));
				surface.transformation.scale = 5;
				setup.scene.addChild( surface );
				
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
				setup.camera.dist = 10;
				setup.camera.rotY = -45;
				setup.camera.rotX = -30;
				//setup.camera.lookOffset.y = 0.5
				setup.camera.limitRotXMin = -90;
				setup.camera.limitRotXMax = -1;
				setup.camera.limitDistMax = 150;

				hideLoader();
			});
			loader.start();
		}
		
		public function updateWithTimeInfo(_timeInfo:TimeInfo):void{
			if( surface )
			{
				surface.transformation.z = (_timeInfo.objectTime % 10000 ) / 10000  * -10;
			}
		}
	}
}