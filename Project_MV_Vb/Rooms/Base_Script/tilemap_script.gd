extends TileMap


export var tiletype = "generictile"
export var damagetick = 0
export var cooldownset = 1

export var destructible = true
var listexplosion = [
	Vector2(-5,-5),
	Vector2(5,-5),
	Vector2(-5,5),
	Vector2(5,5)
	]
const tilecorr = Vector2(10,10)


export var cameraborder = false
export var lowest_border_correction = Vector2(20,20)
export var highest_border_correction = Vector2(-20,-20)

# references and preloads
var dummyTile = preload("res://Rooms/Base_Script/TileSingle - Destructable.tscn")

onready var tileD = get_node_or_null("TileMap - DestructableTiles")


var listpositions = []
var listcells = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# turns tileD invisible
	if tileD != null:
		tileD.visible = false

func provide_border():
	# information
	return [
		world_to_map(get_used_rect().position),
		world_to_map(get_used_rect().end)
	]



func tiledamage(input_pos, destruct_name = "no name", radius = 5, nodeself = null):
	if destructible:
		
		if nodeself == null or nodeself.onetime:
			if nodeself != null and nodeself.continuous == false:
				nodeself.onetime = false
			
			listpositions = radiushandling(input_pos, radius)
			
			# listcells becomes filled and checked for duplicates
			for x in listpositions:
				if not world_to_map(x) in listcells:
					listcells.append(world_to_map(x))
			
			# applies tile destruction
			for cell in listcells:
				check_destructible(cell, destruct_name)
			
			# clears the lists after use
			listpositions.clear()
			listcells.clear()




func radiushandling(input_pos, radius):
	var tilesize = 20/5	# use maybe half
	var listpos = []
	
	var min_y = input_pos.y - radius
	var max_y = input_pos.y + radius
	var _min_x = input_pos.x - radius
	var _max_x = input_pos.x + radius
	
	
	var loop_y = min_y	# loop_xy are the coordinate in the world
	var loop_x = 0	# is determined in the loop
	var loop_x_max = 0	# is to determine what the border is
	var calculation = 0
	while loop_y <= max_y:
		# create loop_x
		calculation = sqrt(pow(radius,2) - pow((input_pos.y - loop_y),2))
		loop_x = input_pos.x - calculation
		loop_x_max = input_pos.x + calculation
		
		
		while loop_x <= loop_x_max:
			listpos.append(Vector2(loop_x, loop_y))
			loop_x += tilesize
		listpos.append(Vector2(loop_x_max, loop_y))	# a bit of fine tuning
		
		loop_y += tilesize	# readies loop_y for next loop
	
	
	return listpos

func check_destructible(cellposition, destruct_name = "no name"):
	var tile_id = tileD.get_cellv(cellposition)
	if get_cellv(cellposition) == -1:
		tile_id = -1
	
	match tile_id:
		# When the cell is destructable by everything
		0:
			set_cellv(cellposition,-1)
		
		# When it hits the dummy block
		1:
			set_cellv(cellposition,-1)
			var added_tile = dummyTile.instance()
			added_tile.position = map_to_world(cellposition)
			added_tile.destructableTile_created("dummy")
			Global.grab_current_level().add_child(added_tile)
		
		# for the sword
		2:
			set_cellv(cellposition,-1)
			if not destruct_name in ["sword"]:	#list should contain checks
				var added_tile = dummyTile.instance()
				added_tile.position = map_to_world(cellposition)
				added_tile.destructableTile_created("sword")
				Global.grab_current_level().add_child(added_tile)
		
		# for the grenade
		3:
			set_cellv(cellposition,-1)
			if not destruct_name in ["grenade"]:	#list should contain checks
				var added_tile = dummyTile.instance()
				added_tile.position = map_to_world(cellposition)
				added_tile.destructableTile_created("grenade")
				Global.grab_current_level().add_child(added_tile)
		
		# When it's an empty cell
		-1:
			#print("tilecell is empty, by " + self.get_name())
			pass
			
		# When it's from an unknown cell
		_:
			#print("tilecell is not recognized, by " + self.get_name())
			pass

