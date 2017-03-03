params ["_itemData","_container"];
_itemData params ["_itemClassNames","_itemCounts"];

{
    _container addItemCargoGlobal [_x,_itemCounts select _forEachIndex];
} forEach _itemClassNames;
