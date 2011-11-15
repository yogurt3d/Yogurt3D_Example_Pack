package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.bit101.utils.MinimalConfigurator;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.events.MouseEvent3D;
	import com.yogurt3d.core.geoms.interfaces.IMesh;
	import com.yogurt3d.core.materials.MaterialFill;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.primitives.meshs.BoxMesh;
	import com.yogurt3d.presets.setup.FreeFlightSetup;
	import com.yogurt3d.test.BaseTest;
	
	import flash.events.Event;
	
	import skybox.PanaromaSkyBox;
	
	[SWF(width="800",height="600",backgroundColor='0x333333',frameRate="60")]
	public class PickingTest extends BaseTest
	{
		protected var uiConfigurator:MinimalConfigurator;
		public var driver:Text;
		public var pick:Text;
		
		private var m_mouseOverEnabled:Boolean = false;
		private var m_mouseOutEnabled:Boolean = false;
		private var m_mouseDownEnabled:Boolean = false;
		private var m_mouseUprEnabled:Boolean = false;
		private var m_mouseClickEnabled:Boolean = false;
		private var m_mouseMoveEnabled:Boolean = false;
		
		private var setup:FreeFlightSetup;
		
		public function PickingTest()
		{	
			super();
			
			setup = new FreeFlightSetup(this);
			
			createSceneObjects();
			
			setupUI();
		}
		
		public function createSceneObjects():void
		{
			setup.scene.skyBox = new PanaromaSkyBox();
			setup.viewport.pickingEnabled = true;
					
			var _box:SceneObjectRenderable;
			var _mesh:IMesh = new BoxMesh(10,10,10,10,10,10 );
			for (var i:int = 0; i < 11; i++) {
				for (var j:int = 0; j < 11; j++) {
					_box = new SceneObjectRenderable();
					_box.geometry = _mesh;
					_box.onMouseOver.add(onMouseOver);
					_box.onMouseOut.add( onMouseOut);
					_box.onMouseDown.add( onMouseDown);
					_box.onMouseUp.add( onMouseUp);
					_box.onMouseClick.add( onMouseClick);
					_box.onMouseMove.add( onMouseMove);
					_box.pickEnabled 	= true;
					_box.useHandCursor 	= true;
					_box.interactive 	= true;
					_box.material 		= new MaterialFill(((i*24)<<16)+((j*24)<<8)+200);
					setup.scene.addChild(_box);
					_box.transformation.x = (j-5) * 15;
					_box.transformation.z = (i-5) * -15;
					_box.userID = "box i:"+i+" j:"+j;
				}		
			}
			
			setup.camera.transformation.z = 200;
			setup.camera.transformation.y = 70;
			
			setup.scene.sceneColor.setColorUint(0xFF333333);
			
		}
		
		protected function onMouseDown(event:MouseEvent3D):void
		{
			if( m_mouseDownEnabled )
				pick.text = "MouseDown: \n" + event.target3d.userID;
		}
		protected function onMouseOut(event:MouseEvent3D):void
		{
			if( m_mouseOutEnabled )
				pick.text = "MouseOut: \n" + event.target3d.userID;
		}
		protected function onMouseOver(event:MouseEvent3D):void
		{
			if( m_mouseOverEnabled )
				pick.text = "MouseOver: \n" + event.target3d.userID;
		}
		protected function onMouseClick(event:MouseEvent3D):void
		{
			if( m_mouseClickEnabled )
				pick.text = "MouseClick: \n" + event.target3d.userID;
		}
		protected function onMouseMove(event:MouseEvent3D):void
		{
			if( m_mouseMoveEnabled )
				pick.text = "MouseMove: \n" + event.target3d.userID + "\n" +
					[event.intersection.x.toPrecision(2),event.intersection.y.toPrecision(2),event.intersection.z.toPrecision(2)].join("\n");
		}
		
		protected function onMouseUp(event:MouseEvent3D):void
		{
			if( m_mouseUprEnabled )
				pick.text = "MouseUp: \n" + event.target3d.userID;
		}
		
		private function setupUI():void{
			/**
			 * UI Initialization
			 **/
			Style.setStyle( Style.DARK );
			
			var hideButton:PushButton = new PushButton( this, 5,5,"-",function(_e:Event):void{
				hbox.visible = !hbox.visible; 
				hideButton.label = ( hbox.visible )?"-":"+";
			} );
			hideButton.width = 20;
			var hbox:HBox = new HBox( this, 30, 0 );			
			var window:Window = new Window(hbox, 5,5);
			window.title = "DRIVER"
			window.width = 150;
			driver = new Text( window,0,0 );
			driver.width = 150;
			driver.textField.multiline = true;
			driver.textField.wordWrap = true;
			window = new Window(hbox, 5,5);
			window.title = "PICK RESULTS"
			window.width = 100;
			pick = new Text( window, 0, 0 );
			pick.width = 100;
			driver.textField.multiline = true;
			driver.textField.wordWrap = true;
			window = new Window(hbox, 5,5);
			window.title = "PICK OPTIONS";
			window.height = 120;
			var vbox:VBox = new VBox( window, 5,5 );
			new CheckBox( vbox,0,0,"Mouse_Over", function(_e:Event):void{ m_mouseOverEnabled = !m_mouseOverEnabled; });
			new CheckBox( vbox,0,0,"Mouse_Out", function(_e:Event):void{ m_mouseOutEnabled = !m_mouseOutEnabled; });
			new CheckBox( vbox,0,0,"Mouse_Down", function(_e:Event):void{ m_mouseDownEnabled = !m_mouseDownEnabled });
			new CheckBox( vbox,0,0,"Mouse_Up", function(_e:Event):void{ m_mouseUprEnabled = !m_mouseUprEnabled; });
			new CheckBox( vbox,0,0,"Mouse_Click", function(_e:Event):void{ m_mouseClickEnabled = !m_mouseClickEnabled; });
			new CheckBox( vbox,0,0,"Mouse_Move", function(_e:Event):void{ m_mouseMoveEnabled = !m_mouseMoveEnabled; });
			window = new Window(hbox, 5,5);
			window.title = "CAMERA INSTRUCTIONS";
			window.width = 150;
			window.height = 70;
			vbox = new VBox( window, 5,5 );
			new Label( vbox, 0,0, "WASD FOR CAMERA POSITION" );
			new Label( vbox, 0,0, "MOUSE FOR CAMERA ROTATION" );
		}
		
		
	}
}