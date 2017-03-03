params ["_magazineData","_container"];
_magazineData params ["_magazineClassNames","_magazineCounts"];
{
    _container addMagazineCargoGlobal [_x,_magazineCounts select _forEachIndex];
} forEach _magazineClassNames;
