#include "script_component.hpp"

private _saveUnits = ([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveUnits) then {[] call FUNC(loadGroups)};

private _saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveVehicles) then {[] call FUNC(loadVehicles)};

private _saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveContainers", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveVehicles) then {[] call FUNC(loadContainers)};

private _saveStatics = ([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveStatics) then {[] call FUNC(loadStatics)};

private _saveTeamAccounts = ([missionConfigFile >> "CfgGradPersistence", "saveTeamAccounts", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveTeamAccounts) then {[] call FUNC(loadTeamAccounts)};

private _saveTasks = ([missionConfigFile >> "CfgGradPersistence", "saveTasks", 0] call BIS_fnc_returnConfigEntry) > 0;
if (_saveTasks) then {[] call FUNC(loadTasks)};

INFO("mission loaded");
"grad-persistence: mission loaded" remoteExec ["systemChat",0,false];
