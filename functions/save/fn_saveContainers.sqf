if (!isServer) exitWith {};

params [["_area",false]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_containersTag = _missionTag + "_containers";
_containersData = [_containersTag] call grad_persistence_fnc_getSaveData;
_containersData resize 0;

_allContainers = vehicles;
_allContainers = _allContainers select {
    (_x isKindOf "ThingX") &&
    (([configfile >> "CfgVehicles" >> typeOf _x,"maximumLoad",0] call BIS_fnc_returnConfigEntry) > 0) &&
    !(_x isKindOf "Static") &&
    {alive _x} &&
    {!(_x getVariable ["grad_persistence_isEditorObject",false])} &&
    {!(_x getVariable ["grad_persistence_isExcluded",false])} &&
    {if (_area isEqualType false) then {true} else {_x inArea _area}}
};

{
    _containerInventory = [_x] call grad_persistence_fnc_getInventory;

    _thisContainerHash = [] call CBA_fnc_hashCreate;

    [_thisContainerHash,"type",typeOf _x] call CBA_fnc_hashSet;
    [_thisContainerHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
    [_thisContainerHash,"vectorDirAndUp",[vectorDir _x,vectorUp _x]] call CBA_fnc_hashSet;
    [_thisContainerHash,"damage",damage _x] call CBA_fnc_hashSet;
    [_thisContainerHash,"inventory", _containerInventory] call CBA_fnc_hashSet;
    [_thisContainerHash,"isGradFort",!isNil {_x getVariable "grad_fortifications_fortOwner"}] call CBA_fnc_hashSet;

    _containersData pushBack _thisContainerHash;

    false
} count _allContainers;

saveProfileNamespace;
