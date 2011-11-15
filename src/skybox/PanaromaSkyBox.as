package skybox
{
	import com.yogurt3d.core.sceneobjects.SkyBox;
	import com.yogurt3d.core.texture.CubeTextureMap;
	
	import flash.display.BitmapData;

	/**
	 * Sample SkyBox
	 * 
	 * Images Curtosey of Adobe
	 * @author Gurel Erceis
	 * 
	 */
	public class PanaromaSkyBox extends SkyBox
	{
		[Embed(source="../../resources/panaroma/hills_negative_x.png")]
		private var embednegativeX:Class;
		
		[Embed(source="../../resources/panaroma/hills_negative_y.png")]
		private var embednegativeY:Class;
		
		[Embed(source="../../resources/panaroma/hills_negative_z.png")]
		private var embednegativeZ:Class;
		
		[Embed(source="../../resources/panaroma/hills_positive_x.png")]
		private var embedpositiveX:Class;
		
		[Embed(source="../../resources/panaroma/hills_positive_y.png")]
		private var embedpositiveY:Class;
		
		[Embed(source="../../resources/panaroma/hills_positive_z.png")]
		private var embedpositiveZ:Class;
		
		public function PanaromaSkyBox()
		{
			var cubeTexture:CubeTextureMap = new CubeTextureMap();
			cubeTexture.setFace( CubeTextureMap.POSITIVE_X, new embedpositiveX().bitmapData );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_X, new embednegativeX().bitmapData );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Y, new embedpositiveY().bitmapData );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Y, new embednegativeY().bitmapData );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Z, new embedpositiveZ().bitmapData );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Z, new embednegativeZ().bitmapData );
			
			super(	cubeTexture, 100 );
			
		}
	}
}