class_name NoteBall extends CharacterBody2D;

var color = Color(1.0, 1.0, 1.0, 1.0);
var sound: String;
var audioPlayer: AudioStreamPlayer = AudioStreamPlayer.new();
var initialTouch := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var radius = 7.5
	
	var array = [];
	for i in range(0, 360):
		var pos = Vector2(radius, 0.0);
		var rot = pos.rotated(deg_to_rad(i));
		
		array.append(rot);
	# End For
	
	var packedArray = PackedVector2Array(array);
	
	$Polygon2D.polygon = packedArray;
	$Polygon2D.color = color;
	
	$CollisionPolygon2D.polygon = packedArray;
	
	
	var s = load(sound);
	audioPlayer.stream = s;
	
	audioPlayer.volume_db = -30;
	audioPlayer.max_polyphony = 2;
	
	add_child(audioPlayer);
# End Function


func playSound() -> void:
	if(not initialTouch):
		initialTouch = true;
		return;
	# End If
	
	audioPlayer.stop();
	audioPlayer.play();
# End Function
