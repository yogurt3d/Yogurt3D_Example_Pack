package skybox
{
	import com.yogurt3d.core.sceneobjects.SkyBox;
	import com.yogurt3d.core.texture.CubeTextureMap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * Sample SkyBox
	 * 
	 * Images Curtosey of http://www.3delyvisions.com/skf1.htm
	 * @author Gurel Erceis
	 * 
	 */
	public class TronSkyBox extends SkyBox
	{
		[Embed(source="../../resources/tronsky/negativeX.jpg")]
		private var embednegativeX:Class;
		
		[Embed(source="../../resources/tronsky/negativeY.jpg")]
		private var embednegativeY:Class;
		
		[Embed(source="../../resources/tronsky/negativeZ.jpg")]
		private var embednegativeZ:Class;
		
		[Embed(source="../../resources/tronsky/positiveX.jpg")]
		private var embedpositiveX:Class;
		
		[Embed(source="../../resources/tronsky/positiveY.jpg")]
		private var embedpositiveY:Class;
		
		[Embed(source="../../resources/tronsky/positiveZ.jpg")]
		private var embedpositiveZ:Class;
		
		public function TronSkyBox()
		{
			var cubeTexture:CubeTextureMap = new CubeTextureMap();
			cubeTexture.setFace( CubeTextureMap.POSITIVE_X, new embedpositiveX().bitmapData );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_X, new embednegativeX().bitmapData );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Y, new embedpositiveY().bitmapData );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Y, new embednegativeY().bitmapData );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Z, new embedpositiveZ().bitmapData );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Z, new embednegativeZ().bitmapData );
			
			super(	cubeTexture, 10 );
			
		}
	}
}