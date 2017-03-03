params [
    "_unit",
    ["_save",false],
    ["_savePlayerInventory",([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerDamage",([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerPosition",([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerMoney",([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 0] call BIS_fnc_returnConfigEntry) == 1]
];


if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_playersTag = _missionTag + "_players";
_playersDataHash = [_playersTag,true,false] call grad_persistence_fnc_getSaveData;

_uid = getPlayerUID _unit;
if (_uid == "") exitWith {};

_unitDataHash = [[],false] call CBA_fnc_hashCreate;

if (_savePlayerInventory) then {
    [_unitDataHash, "inventory", getUnitLoadout _unit] call CBA_fnc_hashSet;
};

if (_savePlayerDamage) then {
    _allHitPointsDamage = getAllHitPointsDamage _unit;
    _damage = if (count _allHitPointsDamage > 2) then {
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
};

[_playersDataHash,_uid,_unitDataHash] call CBA_fnc_hashSet;

if (_save) then {
    saveProfileNamespace;
};
