IncludeJavaScript("js/fabric.js-master/dist/all.js");

IncludeJavaScript("js/Math_Lib.js");
var MathUtils = null;

window.addEventListener("load", eventWindowLoaded, false);

var nwCanvas = null;
var canvasWidth = null;
var canvasHeight = null;
var canvasHW = null;
var canvasHH = null;
var centerPoint = {};

var circle2 = null;
var c2Deg = null;

var spiral = new Array();
var sprialCount = 100;
var centerRect = null;

function Init() {
	nwCanvas = new fabric.Canvas('NWCanvas');
	canvasWidth = nwCanvas.width;
	canvasHeight = nwCanvas.height;
	canvasHW = canvasWidth * .5;
	canvasHH = canvasHeight * .5;
	centerPoint.x = canvasHW;
	centerPoint.y = canvasHH;
	
	MathUtils = MathLib.New();
	
}

function ClearCanvas(inColor) {
	var rect = new fabric.Rect({
		left:canvasHW,
		top:canvasHH,
		fill: inColor,
		width: canvasWidth,
		height: canvasHeight,
		selectable: false,
	});
	nwCanvas.add(rect);
	rect.sendToBack();
}

function DrawCanvas() {

	function DrawObjects() {
		
		fabric.Image.fromURL('images/BlueBrain_650x500.png', function(img) {
			img.left = canvasHW;
			img.top = canvasHH;
			img.width = canvasWidth;
			img.height = canvasHeight;
			img.selectable = false;
			nwCanvas.add(img);
			img.sendToBack();
		});
		
		function DrawRects(){
			/*
			var rect1 = new fabric.Rect({
				left:canvasWidth * .5,
				top:canvasHeight * .5,
				fill: '#3e3749',
				width: 150,
				height: 200,
				strokeWidth: 2,
				stroke: '#00ffff',
				//selectable: false,
			});
			nwCanvas.add(rect1);
			//rect1.bringToFront();

			function SpinRect1() {
				//rect1.set('angle', 0);
				rect1.animate('angle', '+=1', {
					//onChange: nwCanvas.renderAll.bind(nwCanvas),
					//from: 0,
					duration: 10,
					easing: fabric.util.ease.easeLinear,
					onComplete: SpinRect1
				});
			}
			SpinRect1();
			*/
			
			centerRect = new fabric.Rect({
				left:canvasWidth * .5,
				top:canvasHeight * .5,
				fill: '#00ffff',
				width: 40,
				height: 40,
				strokeWidth: 2,
				stroke: '#3e3749',
				//selectable: false,
			});
			nwCanvas.add(centerRect);
			//centerRect.bringToFront();
			
			function SpinRect2() {
				//rect1.set('angle', 0);
				centerRect.animate('angle', '+=.4', {
					//onChange: nwCanvas.renderAll.bind(nwCanvas),
					//from: 0,
					duration: 10,
					easing: fabric.util.ease.easeLinear,
					onComplete: SpinRect2
				});
			}
			SpinRect2();
		}
		DrawRects();
		
		/*
		var gradCircle = new fabric.Circle({
			left: 10, //canvasHW,
			top: 10, //canvasHH,
			fill: '#00ffff',
			radius: 10
		});
		nwCanvas.add(gradCircle);
		
		function MoveCircle() {
			function MoveRight() {
				gradCircle.animate('left', '+=' + (nwCanvas.width - 20), {
					//onChange: nwCanvas.renderAll.bind(nwCanvas),
					//from: 0,
					duration: 4000,
					easing: fabric.util.ease.easeLinear,
					onComplete: MoveDown
				});
			}
			
			function MoveDown() {
				gradCircle.animate('top', '+=' + (nwCanvas.height - 20), {
					//onChange: nwCanvas.renderAll.bind(nwCanvas),
					//from: 0,
					duration: 4000,
					easing: fabric.util.ease.easeLinear,
					onComplete: MoveLeft
				});			
			}
			
			function MoveLeft() {
				gradCircle.animate('left', '-=' + (nwCanvas.width - 20), {
					//onChange: nwCanvas.renderAll.bind(nwCanvas),
					//from: 0,
					duration: 4000,
					easing: fabric.util.ease.easeLinear,
					onComplete: MoveUp
				});			
			}
			
			function MoveUp() {
				gradCircle.animate('top', '-=' + (nwCanvas.height - 20), {
					//onChange: nwCanvas.renderAll.bind(nwCanvas),
					//from: 0,
					duration: 4000,
					easing: fabric.util.ease.easeLinear,
					onComplete: MoveRight
				});			
			}
			MoveRight();
		}
		MoveCircle();
		*/
		
/*
		gradCircle.setGradient('fill', {
			//type: 'linear',
			x1: 0,
			y1: 0,
			x2: 0,
			y2: gradCircle.height,
			colorStops: {
				0: '#00ffff',
				1: '#3e3749'
			}
		});
*/
		var dist = 0;
		var adist = 5;
		for(var spc=0;spc<sprialCount;spc++){
			var newLocation = MathUtils.getOrbitalLocationFromObjectDeg(centerPoint, dist, spc * 10);
			
			spiral[spc] = new fabric.Circle({
				left: newLocation.x,
				top: newLocation.y,
				fill: '#82e0f0',
				radius: 5,
				selectable: false,
				dist:dist,
				deg:c2Deg + spc * 10
			});
			nwCanvas.add(spiral[spc]);
			dist = dist + adist;
		}
	}
	
	//ClearCanvas('black');
	DrawObjects();
	
	function AnimateCanvas(){
		function AdvanceSpiral(){
			c2Deg = MathUtils.getNextDeg(c2Deg,-2);
			for(var spc=0;spc<sprialCount;spc++){
				//spiral[spc].deg = spiral[spc].deg - spc
				var newLocation = MathUtils.getOrbitalLocationFromObjectDeg(centerRect, spiral[spc].dist, spiral[spc].deg + c2Deg);
				spiral[spc].left = newLocation.x;
				spiral[spc].top = newLocation.y;
			}
		}
		AdvanceSpiral();
			
		fabric.util.requestAnimFrame(AnimateCanvas, nwCanvas.getElement());
		nwCanvas.renderAll();
	}
	AnimateCanvas()
}

function eventWindowLoaded() {
	Init();
	DrawCanvas();
	
}

//Utils
function IncludeJavaScript(jsFile) {
  document.write('<script type="text/javascript" src="'
    + jsFile + '"></scr' + 'ipt>'); 
}