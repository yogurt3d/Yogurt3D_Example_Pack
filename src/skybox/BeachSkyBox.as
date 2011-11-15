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
	public class BeachSkyBox extends SkyBox
	{
		[Embed(source="../../resources/sky/negativeX.png")]
		private var embednegativeX:Class;
		
		[Embed(source="../../resources/sky/negativeY.png")]
		private var embednegativeY:Class;
		
		[Embed(source="../../resources/sky/negativeZ.png")]
		private var embednegativeZ:Class;
		
		[Embed(source="../../resources/sky/positiveX.png")]
		private var embedpositiveX:Class;
		
		[Embed(source="../../resources/sky/positiveY.png")]
		private var embedpositiveY:Class;
		
		[Embed(source="../../resources/sky/positiveZ.png")]
		private var embedpositiveZ:Class;
		
		public function BeachSkyBox()
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