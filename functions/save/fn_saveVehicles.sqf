if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_vehiclesTag = _missionTag + "_vehicles";
_vehiclesData = [_vehiclesTag] call grad_persistence_fnc_getSaveData;
_vehiclesData resize 0;

_allVehicles = vehicles;
_allVehicles = _allVehicles select {!(_x isKindOf "Thing") && {!(_x isKindOf "Static")} && {!(_x isKindOf "StaticWeapon")} && {alive _x}};
{
    _hitPointDamage = getAllHitPointsDamage _x;

    _thisVehicleHash = [] call CBA_fnc_hashCreate;
    [_thisVehicleHash,"type",typeOf _x] call CBA_fnc_hashSet;
    [_thisVehicleHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
    [_thisVehicleHash,"vectorDirAndUp",[vectorDir _x,vectorUp _x]] call CBA_fnc_hashSet;
    [_thisVehicleHash,"hitpointDamage",[_hitPointDamage select 0,_hitPointDamage select 2]] call CBA_fnc_hashSet;
    [_thisVehicleHash,"hasCrew",count (crew _x) > 0] call CBA_fnc_hashSet;
    [_thisVehicleHash,"side",side _x] call CBA_fnc_hashSet;

    _vehiclesData pushBack _thisVehicleHash;

    false
} count _allVehicles;

saveProfileNamespace;
