extends Node2D

@onready var rooms = [
	preload("res://room_1.tscn"),
	preload("res://room_2.tscn")
]

@export var numberOfRooms = 15
@export var numberOfSubRooms = 10
@onready var startingDoorPos = [
	$MainTileMap/Door0.global_position ,
	$MainTileMap/Door1.global_position, 
	$MainTileMap/Door2.global_position , 
	$MainTileMap/Door3.global_position
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
var startingDoorDuplicate = startingDoorPos
func _ready():
	createMainBranch()
	createSubBranches()
	createSubBranches()
	createSubBranches()
	print(spawnedRooms)


func createMainBranch():
	roomsDuplicate = rooms
	mainRoomDoorIndex = randi_range(0 , startingDoorPos.size() -1 )
	currentDoorPos = startingDoorPos[mainRoomDoorIndex]
	spawnedRooms.append(currentRoom)
	for i in numberOfRooms:
		createRooms()


func createSubBranches():
	roomsDuplicate = rooms
	attempts=0
	first = true
	currentRoom = mainRoom
	mainRoomDoorIndex = randi_range(0 , startingDoorPos.size() -1 )
	currentDoorPos = startingDoorPos[mainRoomDoorIndex]
	for i in numberOfSubRooms:
		createRooms()


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
				currentDoorPos = currentRoom.doors[randi_range(0, currentRoom.doors.size()-1)].global_position
			createRooms()
	else:
		attempts=0
		spawnedRooms.append(room)
		currentRoom = room
		roomDoorIndex = randi_range(0 , room.doors.size() -1 )
		currentDoorPos = currentRoom.doors[roomDoorIndex].global_position
		if first:
			startingDoorPos.pop_at(mainRoomDoorIndex)
			print(startingDoorPos)
		first = false



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


func _draw():
	draw_rect(oldRoomRec , Color8(255,0,0,125))
	draw_rect(newRoomRec ,  Color8(0,255,0,125))
	var lastRoom = spawnedRooms[1-1]
	var lastRoomRecSize = to_global(lastRoom.map_to_local(lastRoom.get_used_rect().size))
	var lastRoomRec = Rect2i(lastRoom.global_position , lastRoomRecSize).grow(-32)
	draw_rect(newRoomRec ,  Color8(0,0,255,125))

