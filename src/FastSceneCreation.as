package
{
	import com.yogurt3d.core.materials.MaterialTwoColorFresnel;
	import com.yogurt3d.presets.cameras.TargetCamera;
	import com.yogurt3d.presets.primitives.sceneobjects.TorusKnotSceneObject;
	import com.yogurt3d.presets.setup.TargetSetup;
	import com.yogurt3d.test.BaseTest;
	
	[SWF(width="800", height="600")]
	public class FastSceneCreation extends BaseTest
	{
		public function FastSceneCreation()
		{
			super();
			
			var knot:TorusKnotSceneObject = new TorusKnotSceneObject(1,.3,128,32);
			knot.material = new MaterialTwoColorFresnel(0xFF0000,0x0000FF,0.28,2);
			
			new TargetSetup(this).scene.addChild( knot );
		}
	}
}