package
{
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HBox;
	import com.bit101.components.Knob;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.geoms.Mesh;
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.lights.EShadowType;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.managers.idmanager.IDManager;
	import com.yogurt3d.core.materials.MaterialDiffuseFill;
	import com.yogurt3d.core.materials.MaterialSpecularFill;
	import com.yogurt3d.core.namespaces.YOGURT3D_INTERNAL;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.transformations.Transformation;
	import com.yogurt3d.core.utils.MathUtils;
	import com.yogurt3d.core.viewports.EAabbDrawMode;
	import com.yogurt3d.io.loaders.DataLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	import com.yogurt3d.presets.primitives.sceneobjects.PlaneSceneObject;
	import com.yogurt3d.presets.setup.TargetSetup;
	import com.yogurt3d.test.BaseTest;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.getTimer;
	
	[SWF(width="800", height="600", frameRate="60")]
	public class LightTest extends BaseTest
	{
		public static var PATH:String;
		
		protected var material:MaterialSpecularFill;
		
		protected var light1:RenderableLight;
		protected var light2:RenderableLight;
		protected var light3:RenderableLight;
		
		protected var sceneObject:SceneObjectRenderable;
		
		private var setup:TargetSetup;
		
		public function LightTest()
		{
			super();
			if( this.loaderInfo.loaderURL.indexOf("yogurt3d.com") != -1 )
			{
				PATH = "http://www.yogurt3d.com/examples/resources/";	
			}else{
				PATH = "../resources/runtimeResources/";
			}
			
			setup = new TargetSetup(this);
			
			createSceneObjects();
			
			setupUI();
			
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
				setup.scene.YOGURT3D_INTERNAL::m_rootObject.aabbWireframe = EAabbDrawMode.CUMULATIVE;
				
				var mesh:Mesh = loader.getLoadedContent( PATH + "Head.y3d" );
				material = new MaterialSpecularFill(0x999999,1 );
				material.shininess = 60;
				material.specularColor.a = 0;
				
				sceneObject = new SceneObjectRenderable();
				sceneObject.geometry = mesh;//new TorusKnotMesh(1,0.4,32);
				sceneObject.material = material;
				sceneObject.castShadows = true;
				//sceneObject.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				setup.scene.addChild( sceneObject );
				
				light1 = new RenderableLight(ELightType.SPOT, 0x00FF00);
				light1.transformation.position = new Vector3D(10,10,10);
				light1.shadows = EShadowType.SOFT;
				light1.shadowColor.a = 0.4;
				light1.transformation.lookAt( new Vector3D() );
				light1.transformation.userID = "spot";
				//light1.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				//light1.sceneObject.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				sceneObject.addChild( light1 );
				
				light2 = new RenderableLight(ELightType.POINT, 0xFF0000);
				light2.transformation.position = new Vector3D(-10,10,10);
				light2.transformation.lookAt( new Vector3D() );
				light2.shadows = EShadowType.HARD;
				light2.shadowColor.a = 0.4;
				light2.range = 100;
				light2.transformation.userID = "point";
				//light2.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				//light2.sceneObject.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				sceneObject.addChild( light2 );
				
				light3 = new RenderableLight(ELightType.DIRECTIONAL, 0x0000FF);
				light3.transformation.position = new Vector3D(-10,10,-10);
				light3.transformation.lookAt( new Vector3D() );
				light3.shadows = EShadowType.SOFT;
				light3.shadowColor.a = 0.8;
				//light3.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				//light3.sceneObject.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				light3.transformation.userID = "dir";
				//light3.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				sceneObject.addChild( light3 );
				
				
				var plane:PlaneSceneObject = new PlaneSceneObject(36,36,36,10,10);
				plane.material = new MaterialDiffuseFill(0xFFFFFF);
				plane.receiveShadows = true;
				plane.transformation.y = -4;
				sceneObject.addChild( plane );
				//plane.aabbWireframe = EAabbDrawMode.BOTH_CUM_AND_STR;
				
				setup.camera.dist = 15;
				
				Yogurt3D.instance.enginePreUpdateCallback = function():void{
					( IDManager.getObjectByUserID("dir") as Transformation ).rotationX = Math.cos( getTimer() / 50 * MathUtils.DEG_TO_RAD ) * 30 - 37;
					( IDManager.getObjectByUserID("point") as Transformation ).y = Math.cos( getTimer() / 50 * MathUtils.DEG_TO_RAD ) * 10 + 15;
					( IDManager.getObjectByUserID("spot") as Transformation ).y = Math.cos( getTimer() / 50 * MathUtils.DEG_TO_RAD ) * 10 + 15;
					( IDManager.getObjectByUserID("spot") as Transformation ).lookAt( new Vector3D() );
				};

				hideLoader();
			});
			loader.start();
		}
		
		public function setupUI():void{
			Style.setStyle( Style.DARK );
			
			var hideButton:PushButton = new PushButton( this, 5,5,"-",function(_e:Event):void{
				hbox.visible = !hbox.visible; 
				hideButton.label = ( hbox.visible )?"-":"+";
			} );
			hideButton.width = 20;
			var hbox:HBox = new HBox( this, 30, 0 );			
			var window:Window = new Window(hbox, 5,5);
			window.title = "Material"
			window.width = 110;
			window.height = 160;
			window.draggable = false;
			var vbox:VBox = new VBox( window,5,5);
			var diffuseButton:PushButton = new PushButton( vbox, 0,0,"Diffuse", function():void{
				material.specularColor.a = 0;
			});
			var specularButton:PushButton = new PushButton( vbox, 0,0,"Specular", function():void{
				material.specularColor.a = 1;
			});
			
			var knob:Knob = new Knob( vbox, 0,0,"Shineness", function():void{
				material.shininess = knob.value;
			});
			knob.minimum = 10;
			knob.maximum = 160;
			knob.value = 60;
			
			window = new Window(hbox, 5,5);
			window.title = "Material"
			window.width = 110;
			window.draggable = false;
			vbox = new VBox( window,5,5);
			
			var colorChooser1:ColorChooser = new ColorChooser( vbox, 0, 0, 0x00FF00, function():void{
				light1.setColor(colorChooser1.value);
			});	
			colorChooser1.usePopup = true;
			
			var colorChooser2:ColorChooser = new ColorChooser( vbox, 0, 0, 0xFF0000, function():void{
				light2.setColor(colorChooser2.value);
			});	
			colorChooser2.usePopup = true;
			
			var colorChooser3:ColorChooser = new ColorChooser( vbox, 0, 0, 0x0000FF, function():void{
				light3.setColor(colorChooser3.value);
			});	
			colorChooser3.usePopup = true;
		}
	}
}