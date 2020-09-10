#include "script_component.hpp"

params [
    ["_savePlayerInventory",([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerDamage",([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerPosition",([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerMoney",([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 1] call BIS_fnc_returnConfigEntry) == 1]
];

_allPlayers = allPlayers select {_x isKindOf "Man"};

{
    [_x,_savePlayerInventory,_savePlayerDamage,_savePlayerPosition,_savePlayerMoney] call grad_persistence_fnc_loadPlayer;

    false
} count _allPlayers;

INFO("all players loaded");
"grad-persistence: players loaded" remoteExec ["systemChat",0,false];
