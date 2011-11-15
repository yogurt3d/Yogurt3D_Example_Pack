package
{
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.lights.Light;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialSpecularFill;
	import com.yogurt3d.core.materials.base.Material;
	import com.yogurt3d.presets.primitives.sceneobjects.BoxSceneObject;
	import com.yogurt3d.presets.primitives.sceneobjects.ConeSceneObject;
	import com.yogurt3d.presets.primitives.sceneobjects.GeodesicSphereSceneObject;
	import com.yogurt3d.presets.primitives.sceneobjects.SphereSceneObject;
	import com.yogurt3d.presets.primitives.sceneobjects.TorusKnotSceneObject;
	import com.yogurt3d.presets.primitives.sceneobjects.TorusSceneObject;
	import com.yogurt3d.presets.setup.TargetSetup;
	import com.yogurt3d.test.BaseTest;
	
	import flash.geom.Vector3D;
	
	import skybox.TronSkyBoxLow;
	
	[SWF(width="800",height="600",backgroundColor='0x333333', frameRate="120")]
	public class PrimitiveTest extends BaseTest
	{	
		private var setup:TargetSetup;
		
		public function PrimitiveTest()
		{	
			super();	
			
			setup = new TargetSetup(this);
			
			createSceneObjects();
		}
		
		public function createSceneObjects():void
		{
			setup.scene.skyBox = new TronSkyBoxLow();

			var material:Material = new MaterialSpecularFill(  0xFFFFFF );
			MaterialSpecularFill(material).shininess = 250;
			
			var sphere:SphereSceneObject = new SphereSceneObject( 10, 32, 32 );
			sphere.material = material;
			sphere.transformation.x = 35;
			sphere.transformation.z = -30;
			
			var torus:TorusSceneObject = new TorusSceneObject( 10, 5, 200, 100 );
			torus.material = material;
			torus.transformation.x = 35;
			torus.transformation.z = 30;
			
			var torusKnot:TorusKnotSceneObject = new TorusKnotSceneObject( 10,5,100,600 );
			torusKnot.material = material;
			torusKnot.transformation.x = -35;
			torusKnot.transformation.z = -30;
			
			var geodesicSphere:GeodesicSphereSceneObject = new GeodesicSphereSceneObject( 10, 32 );
			geodesicSphere.material = material;
			geodesicSphere.transformation.x = -35;
			geodesicSphere.transformation.z = 30;
			
			/*var wireFrameMesh:WireFrameMesh = new WireFrameMesh(geodesicSphere.geometry as Mesh);
			var wire:SceneObjectRenderable = new SceneObjectRenderable( );
			wire.geometry = wireFrameMesh;
			wire.material = new MaterialFill(0xFF0000 );
			wire.material.shaders[0].params.depthFunction = Context3DCompareMode.ALWAYS;
			wire.material.shaders[0].params.writeDepth 	  = false;
			wire.material.shaders[0].params.culling 	  = Context3DTriangleFace.NONE;
			
			scene.addChild( wire );*/
			
			var box:BoxSceneObject = new BoxSceneObject(  );
			box.material = material;
			box.transformation.x = 0;
			box.transformation.z = 30;
			
			var cone:ConeSceneObject = new ConeSceneObject(  );
			cone.material = material;
			cone.transformation.x = 0;
			cone.transformation.z = -30;
			
			setup.scene.addChild( sphere );
			setup.scene.addChild( torus );
			setup.scene.addChild( torusKnot );
			setup.scene.addChild( geodesicSphere );
			setup.scene.addChild( cone );
			setup.scene.addChild( box );
			
			
			var light1:Light = new RenderableLight(ELightType.DIRECTIONAL, 0x00FF00, 10);
			light1.transformation.position = new Vector3D(100,50,100);
			light1.transformation.lookAt( new Vector3D );
			setup.scene.addChild( light1 );
			
			var light2:Light = new RenderableLight(ELightType.DIRECTIONAL, 0xFF0000, 10);
			light2.transformation.position = new Vector3D(-100,-50,100);
			light2.transformation.lookAt( new Vector3D );
			setup.scene.addChild( light2 );
			
			var light3:Light = new RenderableLight(ELightType.DIRECTIONAL, 0x0000FF, 10);
			light3.transformation.position = new Vector3D(-100,50,-100);
			light3.transformation.lookAt( new Vector3D );
			setup.scene.addChild( light3 );
			
			var light4:Light = new RenderableLight(ELightType.DIRECTIONAL, 0xEEEEEE, 10);
			light4.transformation.position = new Vector3D(100,-50,-100);
			light4.transformation.lookAt( new Vector3D );
			setup.scene.addChild( light4 );
			
			setup.camera.dist = 100;
			
			setup.scene.sceneColor.setColorUint(0xFF333333);
		}		
	}
}