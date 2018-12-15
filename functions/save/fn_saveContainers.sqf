#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

private _missionTag = [] call FUNC(getMissionTag);
private _containersTag = _missionTag + "_containers";
private _containersData = [_containersTag] call FUNC(getSaveData);
_containersData resize 0;

private _allContainers = vehicles;
_allContainers = _allContainers select {
    (_x isKindOf "ThingX") &&
    (([configfile >> "CfgVehicles" >> typeOf _x,"maximumLoad",0] call BIS_fnc_returnConfigEntry) > 0) &&
    !(_x isKindOf "Static") &&
    {alive _x} &&
    {!(_x getVariable [QGVAR(isExcluded),false])} &&
    {(_x getVariable [QGVAR(isEditorObject),false]) isEqualTo (([missionConfigFile >> "CfgGradPersistence", "saveContainers", 1] call BIS_fnc_returnConfigEntry) == 3)} &&
    {if (_area isEqualType false) then {true} else {_x inArea _area}}
};

{
    _containerInventory = [_x] call FUNC(getInventory);

    _thisContainerHash = [] call CBA_fnc_hashCreate;

    [_thisContainerHash,"type",typeOf _x] call CBA_fnc_hashSet;
    [_thisContainerHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
    [_thisContainerHash,"vectorDirAndUp",[vectorDir _x,vectorUp _x]] call CBA_fnc_hashSet;
    [_thisContainerHash,"damage",damage _x] call CBA_fnc_hashSet;
    [_thisContainerHash,"inventory", _containerInventory] call CBA_fnc_hashSet;
    [_thisContainerHash,"isGradFort",!isNil {_x getVariable "grad_fortifications_fortOwner"}] call CBA_fnc_hashSet;
    [_thisContainerHash,"isGradMoneymenuStorage",_x getVariable ["grad_moneymenu_isStorage",false]] call CBA_fnc_hashSet;
    [_thisContainerHash,"gradMoneymenuOwner",_x getVariable ["grad_moneymenu_owner",objNull]] call CBA_fnc_hashSet;
    [_thisContainerHash,"gradLbmMoney",_x getVariable ["grad_lbm_myFunds",0]] call CBA_fnc_hashSet;

    _containersData pushBack _thisContainerHash;
} forEach _allContainers;

saveProfileNamespace;
