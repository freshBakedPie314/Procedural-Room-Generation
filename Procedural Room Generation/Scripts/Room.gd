extends TileMap
@onready var doors = [$Marker0 , $Marker1 ,$Marker2 , $Marker3];
#0 - up
#1- down
#2 - right
#3 - left
#new
@onready var area = $Area2D
var overlapping = false

func _physics_process(delta):
	for i in doors.size() - 1:
		self.erase_cell(0,to_local(doors[i].global_position))
