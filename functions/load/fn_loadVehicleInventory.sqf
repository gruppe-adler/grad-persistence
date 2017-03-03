params ["_vehicle","_inventoryData"];
_inventoryData params ["_itemData","_weaponData","_magazineData","_backpackData"];

clearItemCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;

[_itemData,_vehicle] call grad_persistence_fnc_addItems;
[_weaponData,_vehicle] call grad_persistence_fnc_addWeaponItems;
[_magazineData,_vehicle] call grad_persistence_fnc_addMagazines;
[_backpackData,_vehicle] call grad_persistence_fnc_addBackpacks;
