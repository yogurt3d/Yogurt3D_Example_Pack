package com.yogurt3d.test.assets
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.materials.shaders.base.EVertexAttribute;
	import com.yogurt3d.core.materials.shaders.base.Shader;
	import com.yogurt3d.core.materials.shaders.renderstate.EShaderConstantsType;
	import com.yogurt3d.core.materials.shaders.renderstate.ShaderConstants;
	import com.yogurt3d.core.materials.shaders.renderstate.ShaderConstantsType;
	import com.yogurt3d.core.utils.ShaderUtils;
	
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.ByteArray;
	
	public class CustomShader extends Shader
	{
		public function CustomShader()
		{
			super();
			
			key = "CustomShader";
			
			attributes.push( EVertexAttribute.POSITION, EVertexAttribute.NORMAL );
			
			params.writeDepth 		= true;
			
			params.blendEnabled 	= false;
			params.culling			= Context3DTriangleFace.FRONT;
			params.depthFunction 	= Context3DCompareMode.LESS_EQUAL;
			requiresLight = false;
			
			var _vertexShaderConsts:ShaderConstants 	= new ShaderConstants( 0, EShaderConstantsType.MVP_TRANSPOSED);			
			params.vertexShaderConstants.push(_vertexShaderConsts);
			
			_vertexShaderConsts 	= new ShaderConstants(4, EShaderConstantsType.MODEL_TRANSPOSED);
			
			params.vertexShaderConstants.push(_vertexShaderConsts);
			params.blendDestination = Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA;
			params.blendSource = Context3DBlendFactor.ONE;
				params.blendEnabled = true;
		}
		
		public override function getVertexProgram(_meshKey:String, _lightType:ELightType=null):ByteArray{
			return ShaderUtils.vertexAssambler.assemble(Context3DProgramType.VERTEX, 
				"m44 op, va0, vc0\n" + // calculate vertex positions
				"m33 v0.xyz, va1, vc4\n" + // rotate normals
				"mov v0.w, va1.w\n"
			);
		}
		
		public override function getFragmentProgram(_lightType:ELightType=null):ByteArray{
			return ShaderUtils.fragmentAssambler.assemble(AGALMiniAssembler.FRAGMENT, 
				"mov ft0, v0\n"+
				"nrm ft0.xyz, ft0.xyz\n"+
				"mov oc, ft0"
			);
		}
	}
}