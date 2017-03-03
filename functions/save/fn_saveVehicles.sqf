if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_vehiclesTag = _missionTag + "_vehicles";
_vehiclesData = [_vehiclesTag] call grad_persistence_fnc_getSaveData;
_vehiclesData resize 0;

_allVehicles = vehicles;
_allVehicles = _allVehicles select {!(_x isKindOf "Static") && {alive _x}};
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
