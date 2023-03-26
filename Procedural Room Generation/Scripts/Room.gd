extends TileMap
@onready var doors = [$Marker0 , $Marker1 ,$Marker2 , $Marker3];
#0 - up
#1- down
#2 - right
#3 - left
#new
@onready var area = $Area2D
var overlapping = false

func _remove_door(doorPos):
	print("called")
	var mapPos = self.local_to_map(doorPos)
	self.set_cell(0 , mapPos , -1)
