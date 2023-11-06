class_name Manager extends Node2D;

var totalSemis = 20.0;
var startingRadius = 250.0;
var maxRadius = 900.0;

var loopTime = 750.0;
var maxAngle = PI * 2;

var center = Vector2(960.0, 1020.0);

var preloaded_ball = preload("res://prefab/circle.tscn");
var balls = [];

@onready var StartTime = Time.get_ticks_msec() / 1000.0;


class Ball:
	var body: NoteBall;
	var radius: float;
	var velocity: float;
	
	func _init(b, r, v):
		body = b;
		radius = r;
		
		velocity = v
	# End Function
# End Class;


func _draw() -> void:
	var gap = (maxRadius - startingRadius) / totalSemis;
	var colorStep = 1.0 / (totalSemis + 4);
	var baseRotations = 50;
	
	for i in range(0, totalSemis + 1):
		var rad = startingRadius + (gap * i);
		var packedArray = createPoints(rad);
		
		var color = Color.RED;
		color.s = 1.0;
		color.v = 1.0;
		color.h = colorStep * i;
		
		var velocity = (maxAngle * (baseRotations - i)) / loopTime;
		# Create the ball for each line
		var ball = createBall(packedArray, color, i);
		
		var ballData = Ball.new(ball, rad, velocity);
		balls.append(ballData);
		
		# Draw the line
		draw_polyline(packedArray, color, 1.0, true);
	# End for
# End Function


func createPoints(radius: float) -> PackedVector2Array:
	var array = [];
	for i in range(0, 181):
		var pos = Vector2(-radius, 0.0);
		var rot = pos.rotated(deg_to_rad(i));
		var offsetPos = rot + center;
		
		array.append(offsetPos);
	# End for
	
	var packedArr = PackedVector2Array(array);
	return packedArr;
# End Function

var noteStart = 21;
func createBall(packedArray: PackedVector2Array, color: Color, ballID: int) -> NoteBall:
	# Load the ball
	var ball: NoteBall = preloaded_ball.instantiate();
	ball.color = color;
	ball.sound = "res://src/note_" + str(noteStart - ballID) + ".mp3";
	
	self.add_child(ball);
	ball.position = packedArray[0];
	return ball;
# End Function


func FuckYouShitLanguageForNotHavingATernary(statement: bool, trueValue, falseValue):
	if(statement):
		return trueValue;
	return falseValue;
# End of the extremely obvious thing that this fucking trash language doesn't have


func _process(_delta: float) -> void:
	var elapsedTime = (Time.get_ticks_msec() / 1000.0) - StartTime;
	
	for i in balls.size():
		var BallInfo: Ball = balls[i];
		
		var rotVector = Vector2(BallInfo.radius, 0.0);
		var angle = PI + (elapsedTime * BallInfo.velocity);
		
		var modAngle = fmod(angle, maxAngle);
		var adjustedAngle = FuckYouShitLanguageForNotHavingATernary(PI <= modAngle, modAngle, maxAngle - modAngle);
		
		var rot = rotVector.rotated(adjustedAngle);
		
		BallInfo.body.position = rot + center;
	# End For
# End Function


func _on_button_pressed() -> void:
	get_tree().quit();
# End Function


var counter = 0;
func _onNoteBallTouched(body: Node2D) -> void:
	print(counter);
	counter += 1;
	
	body.playSound();
#	print(body.color);
# End Function
