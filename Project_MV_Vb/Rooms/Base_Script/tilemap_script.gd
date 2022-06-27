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
var arrayDistance = []
var arrayCell = []

export var cameraborder = false
export var lowest_border_correction = Vector2(20,20)
export var highest_border_correction = Vector2(-20,-20)

# references and preloads
var dummyTile = preload("res://Rooms/Base_Script/TileSingle - Destructable.tscn")

onready var tileD = get_node_or_null("TileMap - DestructableTiles")



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



func tiledamage(input_pos, destruct_name = "no name", point1 = Vector2(-5,-5), point2 = Vector2(5,5)):
	if destructible:
		var cellposition = world_to_map(input_pos)
		
		#get_cellv(cellposition, -1)
		# above line is for getting tile index
		if get_cellv(cellposition) != -1:
			check_destructible(cellposition, destruct_name)
		else:
			cellposition = nearbyhandling(input_pos)	# Check function below
			if cellposition != null:
				check_destructible(cellposition, destruct_name)
		# when set_cellv(inputVector2, -1), -1 removes tile

func nearbyhandling(input_pos):
	# returns cell coördinate which can be used
	arrayDistance.clear()	#clears the array
	arrayCell.clear()
	for curr in listexplosion:
		if get_cellv(world_to_map(curr + input_pos)) != -1:
			var cellpos = map_to_world(world_to_map(curr+input_pos)) + tilecorr
			
			arrayCell.append(world_to_map(curr + input_pos))
			arrayDistance.append(cellpos.distance_to(curr))
	
	if not arrayCell.empty():
		
		return arrayCell[
			arrayDistance.find(
				arrayDistance.min()
				)
			]
	else:
		return null
	

func check_destructible(cellposition, destruct_name = "no name"):
	var tile_id = tileD.get_cellv(cellposition)
	
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

