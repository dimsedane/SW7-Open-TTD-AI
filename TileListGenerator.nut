class TileListGenerator {
	function generateNear(tile, radius) {
		local list = AITileList();
	
		for (local i = 1; i < radius; i++) {
			for (local j = 0; j <= i; j++) {
				
				local k = i - j;
				local tmp = tile + AIMap.GetTileIndex(k, j);
				
				if (AIRoad.IsRoadTile(tmp)) {
					list.AddItem(tmp, i);
				}
				tmp = tile + AIMap.GetTileIndex(-k, -j);
				if (AIRoad.IsRoadTile(tmp)) {
					list.AddItem(tmp, i);
				}
				
				tmp = tile + AIMap.GetTileIndex(-k, j);
				if (AIRoad.IsRoadTile(tmp)) {
					list.AddItem(tmp, i);
				}
				
				tmp = tile + AIMap.GetTileIndex(k, -j);
				if (AIRoad.IsRoadTile(tmp)) {
					list.AddItem(tmp, i);
				}
			}
		}
	
		return list;
	}
	
	function generateFlatRoadTilesNear(tile, radius) {
		local list = TileListGenerator.generateNear(tile, radius);
		
		foreach (tile, _ in list) {
			if (!AIRoad.IsRoadTile(tile) && (AITile.GetMinHeight(tile) == AITile.GetMaxHeight(tile))) {
				list.RemoveItem(tile);
			}
		}
		
		return list;
	}
	
	function generateDepotTiles(town) {
		local depottiles = AITileList();
		depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(14, 1), 1);
		depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(14, -1), 0);
		depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-14, 1), 1);
		depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-14, -1), 0);
		depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(1, 14), 2);
		depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(1, -14), 2);
		depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-1, 14), 3);
		depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-1, -14), 3);
		
		return depottiles;
	}
}