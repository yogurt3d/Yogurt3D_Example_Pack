package com.yogurt3d.test
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.cameras.Camera;
	import com.yogurt3d.core.events.Yogurt3DEvent;
	import com.yogurt3d.core.managers.contextmanager.Context;
	import com.yogurt3d.core.managers.tickmanager.TickManager;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	import com.yogurt3d.core.sceneobjects.Scene;
	import com.yogurt3d.core.setup.SetupBase;
	import com.yogurt3d.core.viewports.Viewport;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BaseTest extends Sprite
	{
		private var m_camera		:Camera;
		private var m_scene		:Scene;
		private var m_viewport	:Viewport;
		protected var m_textField	:TextField;
		private var m_context		:Context;
		private var m_loader:LoaderGUI;
		
		private var m_timeInfo:TimeInfo;

		
		public function BaseTest()
		{	
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Add Yogurt3D Logo Start
			var logo:Yogurt3DLogo;
			addChild( logo = new Yogurt3DLogo() );
			logo.scaleX = 0.2;
			logo.scaleY = 0.2;
			//logo.height = 150;
			logo.x = stage.stageWidth - logo.width - 10;
			logo.y = stage.stageHeight - logo.height - 10;
			
			stage.addEventListener( Event.RESIZE, function( _e:Event ):void{
				if( m_loader )
				{
					m_loader.width = 500;
					m_loader.height = 35;
					m_loader.x = (stage.stageWidth - m_loader.width ) / 2;
					m_loader.y = (stage.stageHeight - m_loader.height ) / 2;
				}
				if( logo )
				{
					logo.x = stage.stageWidth - logo.width - 10;
					logo.y = stage.stageHeight - logo.height - 10;
				}
			});			
		}
		public function setLoaderData( _progress:Number, _text:String ):void{
			m_loader.width = 500;
			m_loader.height = 35;
			m_loader.progress = _progress;
			m_loader.text = _text;
		}
		public function showLoader():void{
			if( m_loader )
			{
				this.removeChild( m_loader );
			}
			m_loader = new LoaderGUI();
			m_loader.width = 500;
			m_loader.height = 35;
			m_loader.x = (this.width - m_loader.width ) / 2;
			m_loader.y = (this.height - m_loader.height ) / 2;
			this.addChild( m_loader );
			m_loader.width = 500;
			m_loader.height = 35;
		}
		public function hideLoader():void{
			if( m_loader )
			{
				this.removeChild( m_loader );
			}
		}		
	}
}