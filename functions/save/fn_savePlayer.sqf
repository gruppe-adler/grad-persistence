#include "script_component.hpp"

params [
    "_unit",
    ["_save",false],
    ["_savePlayerInventory",([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerDamage",([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerPosition",([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerMoney",([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 0] call BIS_fnc_returnConfigEntry) == 1],
    "_uid",
    "_allPlayerVariableClasses"
];


if (!isServer) exitWith {};
if (_unit getVariable [QGVAR(isExcluded),false]) exitWith {};

if (isNil "_allPlayerVariableClasses") then {
    private _allVariableClasses = "true" configClasses (missionConfigFile >> "CfgGradPersistence" >> "customVariables");
    _allPlayerVariableClasses = _allVariableClasses select {
        ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "player"
    };
};

private _missionTag = [] call FUNC(getMissionTag);
private _playersTag = _missionTag + "_players";
private _playersDataHash = [_playersTag,true,false] call FUNC(getSaveData);

if (isNil "_uid") then {
    _uid = getPlayerUID _unit;
};
if (_uid == "") exitWith {};

private _unitDataHash = [[],false] call CBA_fnc_hashCreate;

if (_savePlayerInventory) then {
    [_unitDataHash, "inventory", getUnitLoadout _unit] call CBA_fnc_hashSet;
};

if (_savePlayerDamage) then {
    private _allHitPointsDamage = getAllHitPointsDamage _unit;
    private _damage = if (count _allHitPointsDamage > 2) then {
        [_allHitPointsDamage select 0,_allHitPointsDamage select 2]
    } else {
        [[],[]]
    };
    [_unitDataHash,"damage",_damage] call CBA_fnc_hashSet;
};

if (_savePlayerPosition) then {
    [_unitDataHash,"posASL",getPosASL _unit] call CBA_fnc_hashSet;
    [_unitDataHash,"dir",getDir _unit] call CBA_fnc_hashSet;
};

if (_savePlayerMoney) then {
    [_unitDataHash,"money",_unit getVariable ["grad_lbm_myFunds",0]] call CBA_fnc_hashSet;
    [_unitDataHash,"bankMoney",_unit getVariable ["grad_moneymenu_myBankBalance",0]] call CBA_fnc_hashSet;
};

private _thisUnitVars = [_allPlayerVariableClasses,_unit] call FUNC(saveObjectVars);
[_unitDataHash,"vars",_thisUnitVars] call CBA_fnc_hashSet;

[_playersDataHash,_uid,_unitDataHash] call CBA_fnc_hashSet;

if (_save) then {
    saveProfileNamespace;
};
