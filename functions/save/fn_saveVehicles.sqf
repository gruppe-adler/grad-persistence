#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false],["_allVariableClasses",[]]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

private _allVehicleVariableClasses = _allVariableClasses select {
    ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "vehicle"
};

private _missionTag = [] call FUNC(getMissionTag);
private _vehiclesTag = _missionTag + "_vehicles";
private _vehiclesData = [_vehiclesTag] call FUNC(getSaveData);
private _foundVehiclesVarnames = GVAR(allFoundVarNames) select 1;
_vehiclesData resize 0;

private _saveVehiclesMode = [missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry;

private _allVehicles = vehicles select {
    !(_x isKindOf "Static") &&
    !((_x isKindOf "ThingX") && (([configfile >> "CfgVehicles" >> typeOf _x,"maximumLoad",0] call BIS_fnc_returnConfigEntry) > 0)) &&
    {alive _x} &&
    {!([_x] call FUNC(isBlacklisted))} &&
    {
        _saveVehiclesMode == 2 ||
        (_x getVariable [QGVAR(isEditorObject),false]) isEqualTo (_saveVehiclesMode == 1)
    } &&
    {if (_area isEqualType false) then {true} else {_x inArea _area}}
};

{
    private _thisVehicle = _x;
    private _hitPointDamage = getAllHitPointsDamage _thisVehicle;
    private _hitNames = [];
    private _hitDamages = [];
    if (count _hitPointDamage > 0) then {
        _hitNames = _hitPointDamage select 0;
        _hitDamages = _hitPointDamage select 2;
    };

    private _vehicleInventory = [_thisVehicle] call FUNC(getInventory);

    private _thisVehicleHash = [] call CBA_fnc_hashCreate;

    private _vehVarName = vehicleVarName _thisVehicle;
    if (_vehVarName != "") then {
        [_thisVehicleHash,"varName",_vehVarName] call CBA_fnc_hashSet;
        _foundVehiclesVarnames deleteAt (_foundVehiclesVarnames find _vehVarName);
    };

    [_thisVehicleHash,"type",typeOf _thisVehicle] call CBA_fnc_hashSet;
    [_thisVehicleHash,"posASL",getPosASL _thisVehicle] call CBA_fnc_hashSet;
    [_thisVehicleHash,"vectorDirAndUp",[vectorDir _thisVehicle,vectorUp _thisVehicle]] call CBA_fnc_hashSet;
    [_thisVehicleHash,"hitpointDamage",[_hitNames,_hitDamages]] call CBA_fnc_hashSet;
    [_thisVehicleHash,"fuel",fuel _thisVehicle] call CBA_fnc_hashSet;
    [_thisVehicleHash,"hasCrew",{!isPlayer _thisVehicle} count (crew _thisVehicle) > 0] call CBA_fnc_hashSet;
    [_thisVehicleHash,"side",side _thisVehicle] call CBA_fnc_hashSet;
    [_thisVehicleHash,"turretMagazines", magazinesAllTurrets _thisVehicle] call CBA_fnc_hashSet;
    [_thisVehicleHash,"inventory", _vehicleInventory] call CBA_fnc_hashSet;
    [_thisVehicleHash,"isGradFort",!isNil {_thisVehicle getVariable "grad_fortifications_fortOwner"}] call CBA_fnc_hashSet;


    private _thisVehicleVars = [_allVehicleVariableClasses,_thisVehicle] call FUNC(saveObjectVars);
    [_thisVehicleHash,"vars",_thisVehicleVars] call CBA_fnc_hashSet;

    _vehiclesData pushBack _thisVehicleHash;
} forEach _allVehicles;

// all _foundVehiclesVarnames that were not saved must have been removed or killed --> add to killedVarNames array
private _killedVarnames = [_missionTag + "_killedVarnames"] call FUNC(getSaveData);
private _killedVehiclesVarnames = _killedVarnames param [1,[]];
_killedVehiclesVarnames append _foundVehiclesVarnames;
_killedVehiclesVarnames arrayIntersect _killedVehiclesVarnames;
_killedVarnames set [1,_killedVehiclesVarnames];


saveProfileNamespace;
