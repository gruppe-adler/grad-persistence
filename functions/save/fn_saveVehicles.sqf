#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

private _missionTag = [] call FUNC(getMissionTag);
private _vehiclesTag = _missionTag + "_vehicles";
private _vehiclesData = [_vehiclesTag] call FUNC(getSaveData);
_vehiclesData resize 0;

private _allVehicles = vehicles select {
    !(_x isKindOf "ThingX") &&
    !(_x isKindOf "Static") &&
    {alive _x} &&
    {(_x getVariable [QGVAR(isEditorObject),false]) isEqualTo (([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) == 3)} &&
    {!(_x getVariable [QGVAR(isExcluded),false])} &&
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

    _vehicleInventory = [_x] call FUNC(getInventory);

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
} forEach _allVehicles;

saveProfileNamespace;
