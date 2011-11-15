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
	public class DuskSkyBox extends SkyBox
	{
		[Embed(source="../../resources/dusk/negativeX.jpg")]
		private var embednegativeX:Class;
		
		[Embed(source="../../resources/dusk/positiveY.jpg")]
		private var embednegativeY:Class;
		
		[Embed(source="../../resources/dusk/negativeZ.jpg")]
		private var embednegativeZ:Class;
		
		[Embed(source="../../resources/dusk/positiveX.jpg")]
		private var embedpositiveX:Class;
		
		[Embed(source="../../resources/dusk/positiveY.jpg")]
		private var embedpositiveY:Class;
		
		[Embed(source="../../resources/dusk/positiveZ.jpg")]
		private var embedpositiveZ:Class;
		
		public function DuskSkyBox()
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