#include "script_component.hpp"

params [
    ["_savePlayerInventory",([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerDamage",([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerPosition",([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerMoney",([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_allVariableClasses",[]]
];

private _allPlayerVariableClasses = _allVariableClasses select {
    ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "player"
};

private _allPlayers = allPlayers select {_x isKindOf "Man" && {!([_x] call FUNC(isBlacklisted))}};

{
    [_x,false,_savePlayerInventory,_savePlayerDamage,_savePlayerPosition,_savePlayerMoney,nil,_allPlayerVariableClasses] call FUNC(savePlayer);
} forEach _allPlayers;

saveProfileNamespace;
