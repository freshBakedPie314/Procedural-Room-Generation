extends Node2D

@onready var rooms = [
	preload("res://Scenes/Room/room_1.tscn"),
	preload("res://Scenes/Room/room_2.tscn")
]

@export var numberOfRooms = 15
@export var numberOfSubRooms = 10
@onready var startingDoorPos = [
	$MainTileMap/Door0 ,
	$MainTileMap/Door1, 
	$MainTileMap/Door2 , 
	$MainTileMap/Door3
]

@onready var roomsDuplicate = rooms
@onready var currentDoorPos
@onready var mainRoom = $MainTileMap
@onready var currentRoom = mainRoom
var newRoomRec 
var oldRoomRec
var roomDoorIndex
var spawnedRooms = []
var first = true
var mainRoomDoorIndex
var attempts = 0
var precviousDoorIndex
var startingDoorDuplicate = startingDoorPos
func _ready():
	var time_before = Time.get_ticks_msec()
	createMainRoot()
	createSubRoot()
	createSubRoot()
	createSubRoot()
	createBranches()
	var execution_time = Time.get_ticks_msec()-time_before
	print("Execution Time = " , execution_time/1000 , "sec")

func createMainRoot():
	roomsDuplicate = rooms
	mainRoomDoorIndex = randi_range(0 , startingDoorPos.size() -1 )
	currentDoorPos = startingDoorPos[mainRoomDoorIndex].global_position
	spawnedRooms.append(currentRoom)
	for i in numberOfRooms:
		createRooms()

func createSubRoot():
	roomsDuplicate = rooms
	attempts=0
	first = true
	currentRoom = mainRoom
	mainRoomDoorIndex = randi_range(0 , startingDoorPos.size() -1 )
	currentDoorPos = startingDoorPos[mainRoomDoorIndex].global_position
	for i in numberOfSubRooms:
		createRooms()

func createBranches():
	pass


func createRooms():
	var Room = rooms[randi_range(0,rooms.size()-1)].instantiate()
	self.add_child(Room)
	roomDoorIndex = randi_range(0 , Room.doors.size() -1 )
	_position_room(Room)



func _position_room(room):
	var diffX = room.doors[roomDoorIndex].global_position.x - currentDoorPos.x 
	var diffY = room.doors[roomDoorIndex].global_position.y - currentDoorPos.y
	room.global_position = Vector2(room.global_position.x - diffX , room.global_position.y - diffY)
	if(isRoomOverlapping(room)):
		if(attempts > 500):
			attempts = 0
			room.get_parent().remove_child(room)
			return
		else:
			attempts+=1
			room.get_parent().remove_child(room)
			if !first:
				precviousDoorIndex = randi_range(0, currentRoom.doors.size()-1)
				currentDoorPos = currentRoom.doors[precviousDoorIndex].global_position
			createRooms()
	else:
		attempts=0
		room._remove_door(room.doors[roomDoorIndex].position)
		if !first:
			currentRoom._remove_door(currentRoom.doors[precviousDoorIndex].position)
		else:
			_remove_door(startingDoorPos[mainRoomDoorIndex].position)
		spawnedRooms.append(room)
		
		currentRoom = room
		precviousDoorIndex = randi_range(0 , room.doors.size() -1 )
		currentDoorPos = currentRoom.doors[precviousDoorIndex].global_position
		if first:
			startingDoorPos.pop_at(mainRoomDoorIndex)
		first = false



func checkForOverllappingDoors(room):
	if !first:
		for i in room.doors.size()-1:
			var pos = room.doors[i].global_position
			for j in spawnedRooms.size()-1:
				for k in spawnedRooms[j].doors.size()-1:
					var pos2 = spawnedRooms[j].doors[k].global_position
					if pos == pos2:
						print("door")



func isRoomOverlapping(romomToCheck):
	for i in spawnedRooms.size():
		if(checkOverlappingBetween(romomToCheck , spawnedRooms[i])):
			return true;
	return false;



func checkOverlappingBetween(newRoom , oldRoom):
	var oldRoomRecSize = to_global(oldRoom.map_to_local(oldRoom.get_used_rect().size))
	oldRoomRec = Rect2i(oldRoom.global_position , oldRoomRecSize).grow(-32)
	var newRoomRecSize = to_global(newRoom.map_to_local(newRoom.get_used_rect().size))
	newRoomRec = Rect2i(newRoom.global_position , newRoomRecSize).grow(-32)
	return (oldRoomRec.intersects(newRoomRec))


func _remove_door(doorPos):
	var mapPos = mainRoom.local_to_map(doorPos)
	mainRoom.set_cell(0 , mapPos , -1)

func _draw():
	#draw_rect(oldRoomRec , Color8(255,0,0,125))
	#draw_rect(newRoomRec ,  Color8(0,255,0,125))
	
	var firstRoom = spawnedRooms[0]
	var firstRoomRecSize = to_global(firstRoom.map_to_local(firstRoom.get_used_rect().size))
	var firstRoomRec = Rect2i(firstRoom.global_position , firstRoomRecSize).grow(-32)
	draw_rect(firstRoomRec ,  Color8(255,0,0,125))
	
	var lastRoom = spawnedRooms[numberOfRooms]
	var lastRoomRecSize = to_global(lastRoom.map_to_local(lastRoom.get_used_rect().size))
	var lastRoomRec = Rect2i(lastRoom.global_position , lastRoomRecSize).grow(-32)
	draw_rect(lastRoomRec ,  Color8(0,0,255,125))

