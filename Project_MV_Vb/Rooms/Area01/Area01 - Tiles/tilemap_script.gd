extends TileMap


export var tiletype = "generictile"
export var damagetick = 0
export var cooldownset = 1

export var destructible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func tiledamage(cellposition):
	if destructible:
		
		#get_cellv(cellposition, -1)
		# above line is for getting tile index
		
		set_cellv(cellposition, 1)
		# when set_cellv(inputVector2, -1), -1 removes tile
