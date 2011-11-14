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
		list.Sort(AIList.SORT_BY_VALUE, true);
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
		local i = 0;
		for (i = 5; i < 15; i++) {
			if (i == 8 || i == 12) i++; //Ignore tiles that should contain crossroads
			
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(i, 1), AITown.GetLocation(town) + AIMap.GetTileIndex(i, 0));
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(i, -1), AITown.GetLocation(town) + AIMap.GetTileIndex(i, 0));
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-i, 1), AITown.GetLocation(town) + AIMap.GetTileIndex(-i, 0));
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-i, -1), AITown.GetLocation(town) + AIMap.GetTileIndex(-i, 0));
			
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(1, i), AITown.GetLocation(town) + AIMap.GetTileIndex(0, i));
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(1, -i), AITown.GetLocation(town) + AIMap.GetTileIndex(0, -i));
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-1, i), AITown.GetLocation(town) + AIMap.GetTileIndex(0, i));
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-1, -i), AITown.GetLocation(town) + AIMap.GetTileIndex(0, -i));
			
		}
		return depottiles;
	}
}