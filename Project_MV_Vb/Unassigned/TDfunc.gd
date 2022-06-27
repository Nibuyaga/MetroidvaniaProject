extends Node

export var destructname_export= "no name"

# When area2D or similiar returns multiple nodes
# !this is not a function for handling multiple tiles from the same node!
func TD_multibodies(overlapping_bodies, node_self, destructname = destructname_export):
	for current in overlapping_bodies:
		TDf(current, node_self, destructname)


# Tile destruction function 
func TDf(node_tilemap, node_self, destructname = "no name"):
	if "TileMap" in str(node_tilemap):
		node_tilemap.tiledamage(node_self.global_position, destructname)
	elif "TileSingle - Destructable" in str(node_tilemap):
		node_tilemap.destructableTile_destroyed(destructname)
	else:
		#print("TDf sees a non-Tilemap, from " + get_parent().get_name() + "/TDfunc")
		pass
