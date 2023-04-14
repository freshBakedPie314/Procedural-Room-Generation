extends TileMap
@onready var doors = [$Marker0 , $Marker1 ,$Marker2 , $Marker3];
var executed_once= 0
func _remove_door(doorPos):
	var mapPos = self.local_to_map(doorPos)
	self.set_cell(0 , mapPos , -1)

#this removes walls and doors that are overlapping so the player can move freely
#must be a better to do this than this(maybe aome back to this later)
func _physics_process(delta):
	if(executed_once < 2):
		for i in doors.size():
			var space_state = get_world_2d().direct_space_state
			
			#casts a ray to check if there if there is a wall where there is a door
			var query = PhysicsRayQueryParameters2D.create(doors[i].global_position, 
			doors[i].global_position + Vector2(20,20)) #shouldnt this be cast in the z dir? no idea why this works 
			var result = space_state.intersect_ray(query)
			if result:
				#if there is a wall remove the wall and the door
				var mapPos = self.local_to_map(doors[i].position)
				self.set_cell(0 , mapPos , -1)
				instance_from_id(result.collider_id).set_cell(0,
				instance_from_id(result.collider_id).local_to_map(doors[i].position) , -1)
		executed_once+=1
