package
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.animation.controllers.SkinController;
	import com.yogurt3d.core.geoms.SkeletalAnimatedMesh;
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.lights.Light;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.materials.MaterialSpecularTexture;
	import com.yogurt3d.core.materials.base.Color;
	import com.yogurt3d.core.sceneobjects.SceneObjectContainer;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.io.loaders.DataLoader;
	import com.yogurt3d.io.loaders.DisplayObjectLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.TextureMap_Parser;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	import com.yogurt3d.io.parsers.YOA_Parser;
	import com.yogurt3d.presets.setup.TargetSetup;
	import com.yogurt3d.test.BaseTest;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoaderDataFormat;
	
	import skybox.PanaromaSkyBox;
	
	[SWF(width="800", height="600", frameRate="60")]
	public class SkinningTest extends BaseTest
	{
		
		public static const PATH:String = "http://www.yogurt3d.com/examples/resources/";//"../resources/runtimeResources/"; //"http://www.yogurt3d.com/examples/resources/";//
				
		public var dragon:SceneObjectRenderable;
		public var skinController:SkinController;
		public var container:SceneObjectContainer;
		public var box:Vector.<SceneObjectRenderable>;
		public var sceneObject:SceneObjectRenderable

		private var setup:TargetSetup;
		
		public function SkinningTest()
		{
			super();
			
			setup = new TargetSetup(this);
			
			createSceneObjects();
			
			setupUI();
		}
		
		public function createSceneObjects():void{
			showLoader();
			setup.scene.skyBox = new PanaromaSkyBox();
			
			var loader:LoadManager = new LoadManager();
			loader.add( PATH + "Dragon.jpg", DisplayObjectLoader, TextureMap_Parser );
			loader.add( PATH + "dragon2.y3d", DataLoader, Y3D_Parser, {dataFormat: URLLoaderDataFormat.BINARY} );
			loader.add( PATH + "Dragon_Flight.yoa", DataLoader, YOA_Parser, {dataFormat: URLLoaderDataFormat.BINARY} );
			loader.add( PATH + "Dragon_Idle.yoa", DataLoader, YOA_Parser, {dataFormat: URLLoaderDataFormat.BINARY} );
			loader.addEventListener( LoaderEvent.LOAD_PROGRESS, function( _e:LoaderEvent ):void{
				var path:String = _e.loader.loadPath;
				path = path.substr( path.lastIndexOf("/")+1 );
				setLoaderData( _e.bytesLoaded / _e.bytesTotal * 100, "Loading " + path + " ... \t\t("+Math.round(_e.bytesLoaded/1024)+"KB/"+ Math.round(_e.bytesTotal/1024) +"KB)" );
			});
			loader.addEventListener( LoaderEvent.ALL_COMPLETE, function( _E:LoaderEvent ):void
			{				
				var alpha:Number = 0.5;
				
				var mesh:*;

				var sceneObject:SceneObjectRenderable = new SceneObjectRenderable();
				sceneObject.material = new MaterialSpecularTexture( loader.getLoadedContent(PATH + "Dragon.jpg") );
				sceneObject.material.ambientColor = new Color( 1,1,1,.6 );
				sceneObject.geometry = loader.getLoadedContent(PATH + "dragon2.y3d") as SkeletalAnimatedMesh;
				sceneObject.transformation.y -= 5;
				setup.scene.addChild( sceneObject );
				
				skinController = SkeletalAnimatedMesh(sceneObject.geometry).controller as SkinController;
				skinController.addAnimation( "fly", loader.getLoadedContent(PATH + "Dragon_Flight.yoa") );
				//skinController.addAnimation( "idle", loader.getLoadedContent(PATH + "polySurface8.yoa") );
				skinController.playAnimation( "fly" );
				
				
				skinController = SkeletalAnimatedMesh(sceneObject.geometry).controller as SkinController;
				skinController.addAnimation( "idle", loader.getLoadedContent(PATH + "Dragon_Idle.yoa") );
				//skinController.addAnimation( "idle", loader.getLoadedContent(PATH + "polySurface8.yoa") );
				skinController.playAnimation( "idle" );
			
				var light:Light = new Light( ELightType.POINT, 0xFFFFFF, 1 );
				light.transformation.position = new Vector3D(1000,1000,1000);
				light.transformation.lookAt( new Vector3D );
				setup.scene.addChild( light );

				setup.camera.dist = 100;
				
				setup.scene.sceneColor.setColorUint(0xFF333333);
				
				dragon = sceneObject;
				hideLoader();
			});
			loader.start();

		}
		private function setupUI():void{
			Style.setStyle( Style.DARK );
			
			var hideButton:PushButton = new PushButton( this, 5,5,"-",function(_e:Event):void{
				hbox.visible = !hbox.visible; 
				hideButton.label = ( hbox.visible )?"-":"+";
			} );
			hideButton.width = 20;
			var hbox:HBox = new HBox( this, 30, 0 );			
			var window:Window = new Window(hbox, 5,5);
			window.title = "Player"
			window.width = 110;
			window.draggable = false;
			var vbox:VBox = new VBox( window,5,5);
			var playButton:PushButton = new PushButton( vbox, 0,0,"Play", function():void{
				skinController.play();
			});
			var pauseButton:PushButton = new PushButton( vbox, 0,0,"Pause", function():void{
				skinController.pause();
			});
			var stopButton:PushButton = new PushButton( vbox, 0,0,"Stop", function():void{
				skinController.stop();
			});
			window = new Window(hbox, 5,5);
			window.title = "Animation"
			window.width = 110;
			window.draggable = false;
			vbox = new VBox( window,5,5);
			var flyButton:PushButton = new PushButton( vbox, 0,0,"Fly", function():void{
				skinController.playAnimation("fly", 0, 0, SkinController.BLEND_ANIMATED, 2 );
			});
			var idleButton:PushButton = new PushButton( vbox, 0,0,"Idle", function():void{
				skinController.playAnimation("idle", 0, 0, SkinController.BLEND_ANIMATED, 2 );
			});
		}
	}
}