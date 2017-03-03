params ["_backpackData","_container"];

{
    _x params ["_backpackClassName","_backpackItemData","_backpackWeaponsItems","_backpackMagazines","_backpackBackpacks"];
    _vehicle addBackpackCargoGlobal [_backpackClassName,1];
    _backpack = (everyBackpack _vehicle) select _forEachIndex;

    [_backpackItemData,_backpack] call grad_persistence_fnc_addItems;
    [_backpackWeaponsItems,_backpack] call grad_persistence_fnc_addWeaponItems;
    [_backpackMagazines,_backpack] call grad_persistence_fnc_addMagazines;

    _backpackBackpacks params ["_backpackBackpackClassnames","_backpackBackpackCounts"];
    {
        _backpack addBackpackCargoGlobal [_x, _backpackBackpackCounts select _forEachIndex];
    } forEach _backpackBackpackClassnames;

    false
} forEach _backpackData;
