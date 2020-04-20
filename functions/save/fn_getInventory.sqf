#include "script_component.hpp"

params ["_vehicle"];

private _inventory = [];

private _itemCargo = itemCargo _vehicle;
if (isNil "_itemCargo") then {_itemCargo = []};

if (GVAR(acreLoaded)) then {
    _itemCargo = [_itemCargo] call FUNC(deInstanceACRERadios);
};
if (GVAR(tfarLoaded)) then {
    _itemCargo = [_itemCargo] call FUNC(deInstanceTFARRadios);
};

_itemCargo = [_itemCargo] call FUNC(generateCountArray);
_inventory pushBack _itemCargo;


private _weaponCargo = weaponsItemsCargo _vehicle;
if (isNil "_weaponCargo") then {_weaponCargo = []};
_inventory pushBack _weaponCargo;


private _magazineCargo = getMagazineCargo _vehicle;
if (isNil "_magazineCargo") then {_magazineCargo = []};
_inventory pushBack _magazineCargo;


private _backpackCargo = [];
private _backpackItems = everyBackpack _vehicle;
if (isNil "_backpackItems") then {_backpackItems = []};
{
    _backpackData = [typeOf _x];

    _backpackItemCargo = itemCargo _x;
    if (GVAR(acreLoaded)) then {
        _backpackItemCargo = [_backpackItemCargo] call FUNC(deInstanceACRERadios);
    };
    if (GVAR(tfarLoaded)) then {
        _backpackItemCargo = [_backpackItemCargo] call FUNC(deInstanceTFARRadios);
    };
    _backpackItemCargo = [_backpackItemCargo] call FUNC(generateCountArray);

    _backpackBackpackCargo = backpackCargo _x;
    _backpackBackpackCargo = [_backpackBackpackCargo] call FUNC(generateCountArray);

    _backpackData pushBack _backpackItemCargo;
    _backpackData pushBack (weaponsItems _x);
    _backpackData pushBack (getMagazineCargo _x);
    _backpackData pushBack _backpackBackpackCargo;

    _backpackCargo pushBack _backpackData;
} forEach _backpackItems;
_inventory pushBack _backpackCargo;

_inventory
