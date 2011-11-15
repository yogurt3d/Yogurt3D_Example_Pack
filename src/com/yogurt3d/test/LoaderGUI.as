package com.yogurt3d.test
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class LoaderGUI extends Sprite
	{
		private var m_width:Number;
		private var m_height:Number;
		private var m_text:Number;
		private var myTextField:TextField;
		
		public function LoaderGUI()
		{
			super();
			myTextField = new TextField();
			myTextField.x = 5;
			myTextField.y = 5;
			myTextField.width = 200;
			myTextField.background = false;  
			myTextField.border = false;
			myTextField.wordWrap = false;
			myTextField.autoSize = TextFieldAutoSize.LEFT;
			myTextField.blendMode = BlendMode.INVERT;
						
			this.addChild(myTextField);
		}
		public function set progress( _value:Number ):void{
			if( !isNaN( _value ) )
			{
				with( this.graphics )
				{
					clear();
					beginFill( 0xFFFFFF, 1 );
					drawRect(0,0,m_width, m_height);
					endFill();
					beginFill( 0x000000, 1 );
					drawRect(4,4, (m_width - 8) * _value / 100, m_height - 8 );
					endFill();
				}
			}
		}
		public function set text( _value:String ):void{
			myTextField.text = _value;
		}
		public override function set width(value:Number):void{
			super.width = value;
			m_width = value;
		}
		public override function set height(value:Number):void{
			super.height = value;
			m_height = value;
		}
	}
}