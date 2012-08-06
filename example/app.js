Titanium.Paint = Ti.Paint = require('yy.tivinci');


var win = Ti.UI.createWindow({ backgroundColor: '#fff' });
var paintView = Ti.Paint.createView({
top:0, right:0, bottom:80, left:0,
    // strokeWidth (float), strokeColor (string), strokeAlpha (int, 0-255)
strokeColor:'#0f0', strokeAlpha:255, strokeWidth:10,
    image: 'Default.png'
});
setTimeout(function() {
    paintView.image = 'Default.png';},2000);
win.add(paintView);

var buttonStrokeWidth = Ti.UI.createButton({ left:10, bottom:10, right:10, height:30, title:'Decrease Stroke Width' });
buttonStrokeWidth.addEventListener('click', function(e) {
	paintView.strokeWidth = (paintView.strokeWidth === 10) ? 5 : 10;
	e.source.title = (paintView.strokeWidth === 10) ? 'Decrease Stroke Width' : 'Increase Stroke Width';
});
win.add(buttonStrokeWidth);

var buttonStrokeColorRed = Ti.UI.createButton({ bottom:100, left:10, width:75, height:30, title:'Red' });
buttonStrokeColorRed.addEventListener('click', function() { paintView.strokeColor = 'red'; });
var buttonStrokeColorGreen = Ti.UI.createButton({ bottom:70, left:10, width:75, height:30, title:'Green' });
buttonStrokeColorGreen.addEventListener('click', function() { paintView.strokeColor = '#0f0'; });
var buttonStrokeColorBlue = Ti.UI.createButton({ bottom:40, left:10, width:75, height:30, title:'Blue' });
buttonStrokeColorBlue.addEventListener('click', function() { paintView.strokeColor = '#0000ff'; });
win.add(buttonStrokeColorRed);
win.add(buttonStrokeColorGreen);
win.add(buttonStrokeColorBlue);

var clear = Ti.UI.createButton({ bottom:40, left:100, width:75, height:30, title:'Clear' });
clear.addEventListener('click', function() { paintView.clear(); });
win.add(clear);

var buttonStrokeAlpha = Ti.UI.createButton({ bottom:70, right:10, width:100, height:30, title:'Alpha : 100%' });
buttonStrokeAlpha.addEventListener('click', function(e) {
	paintView.strokeAlpha = (paintView.strokeAlpha === 255) ? 127 : 255;
	e.source.title = (paintView.strokeAlpha === 255) ? 'Alpha : 100%' : 'Alpha : 50%';
});
win.add(buttonStrokeAlpha);

var buttonStrokeColorEraser = Ti.UI.createButton({ bottom:40, right:10, width:100, height:30, title:'Erase' });
buttonStrokeColorEraser.addEventListener('click', function(e) {
	paintView.drawMode = Ti.Paint.ERASE;
});
win.add(buttonStrokeColorEraser);

var buttonBezier = Ti.UI.createButton({ bottom:70, left:100, width:100, height:30, title:'Bezier' });
buttonBezier.addEventListener('click', function(e) {
	paintView.drawMode = Ti.Paint.CURVE_LINE;
});
win.add(buttonBezier);

var buttonStraight = Ti.UI.createButton({ bottom:100, left:100, width:100, height:30, title:'Straight' });
buttonStraight.addEventListener('click', function(e) {
	paintView.drawMode = Ti.Paint.STRAIGHT_LINE;
});
win.add(buttonStraight);

var buttonCircle = Ti.UI.createButton({ bottom:100, right:10, width:100, height:30, title:'Circle' });
buttonCircle.addEventListener('click', function(e) {
	paintView.drawMode = Ti.Paint.CIRCLE;
});
win.add(buttonCircle);

var buttonSquare = Ti.UI.createButton({ bottom:130, right:10, width:100, height:30, title:'Rectangle' });
buttonSquare.addEventListener('click', function(e) {
	paintView.drawMode = Ti.Paint.RECTANGLE;
});
win.add(buttonSquare);

var buttonDynamic = Ti.UI.createButton({ bottom:130, left:10, width:100, height:30, title:'Dynamic: Off' });
buttonDynamic.addEventListener('click', function(e) {
	paintView.strokeDynamic = !paintView.strokeDynamic;
    buttonDynamic.title = 'Dynamic: ' + (paintView.strokeDynamic? "On" : "Off");
});
win.add(buttonDynamic);

var buttonBlur = Ti.UI.createButton({ bottom:160, left:10, width:100, height:30, title:'Blurred: Off' });
buttonBlur.addEventListener('click', function(e) {
	paintView.blurredEdges = !paintView.blurredEdges;
    buttonBlur.title = 'Blurred: ' + (paintView.blurredEdges? "On" : "Off");
});
win.add(buttonBlur);

var buttonUndo = Ti.UI.createButton({ bottom:190, left:10, width:60, height:30, title:'Undo' });
buttonUndo.addEventListener('click', function(e) {
	paintView.undo();
});
win.add(buttonUndo);

paintView.addEventListener("draw", function(e) {
    Ti.API.info(JSON.stringify(e));
});


win.open();

