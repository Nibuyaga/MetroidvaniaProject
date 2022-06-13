extends Node


# When area2D or similiar returns multiple nodes
# !this is not a function for handling multiple tiles from the same node!
func TD_multibodies(overlapping_bodies, node_self):
	for current in overlapping_bodies:
		TDf(current, node_self)


# Tile destruction function 
func TDf(node_tilemap, node_self):
	
	if "TileMap" in str(node_tilemap):
		node_tilemap.tiledamage(node_self.position)
	else:
		print("TDf sees a non-Tilemap, from " + get_parent().get_name() + "/TDfunc")
	
