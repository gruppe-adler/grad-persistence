if (!isServer) exitWith {};

params [["_area",false]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_vehiclesTag = _missionTag + "_vehicles";
_vehiclesData = [_vehiclesTag] call grad_persistence_fnc_getSaveData;
_vehiclesData resize 0;

_allVehicles = vehicles;
_allVehicles = _allVehicles select {
    !(_x isKindOf "ThingX") &&
    !(_x isKindOf "Static") &&
    {alive _x} &&
    {!(_x getVariable ["grad_persistence_isEditorObject",false])} &&
    {!(_x getVariable ["grad_persistence_isExcluded",false])} &&
    {if (_area isEqualType false) then {true} else {_x inArea _area}}
};

{
    _hitPointDamage = getAllHitPointsDamage _x;
    private _hitNames = [];
    private _hitDamages = [];
    if (count _hitPointDamage > 0) then {
        _hitNames = _hitPointDamage select 0;
        _hitDamages = _hitPointDamage select 2;
    };

    _vehicleInventory = [_x] call grad_persistence_fnc_getInventory;

    _thisVehicleHash = [] call CBA_fnc_hashCreate;

    [_thisVehicleHash,"type",typeOf _x] call CBA_fnc_hashSet;
    [_thisVehicleHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
    [_thisVehicleHash,"vectorDirAndUp",[vectorDir _x,vectorUp _x]] call CBA_fnc_hashSet;
    [_thisVehicleHash,"hitpointDamage",[_hitNames,_hitDamages]] call CBA_fnc_hashSet;
    [_thisVehicleHash,"hasCrew",{!isPlayer _x} count (crew _x) > 0] call CBA_fnc_hashSet;
    [_thisVehicleHash,"side",side _x] call CBA_fnc_hashSet;
    [_thisVehicleHash,"turretMagazines", magazinesAllTurrets _x] call CBA_fnc_hashSet;
    [_thisVehicleHash,"inventory", _vehicleInventory] call CBA_fnc_hashSet;
    [_thisVehicleHash,"isGradFort",!isNil {_x getVariable "grad_fortifications_fortOwner"}] call CBA_fnc_hashSet;

    _vehiclesData pushBack _thisVehicleHash;

    false
} count _allVehicles;

saveProfileNamespace;
