#include "script_component.hpp"

private _saveUnits = ([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveUnits) then {[] call FUNC(loadGroups)};

private _saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveVehicles) then {[] call FUNC(loadVehicles)};

private _saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveContainers", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveVehicles) then {[] call FUNC(loadContainers)};

private _saveStatics = ([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveStatics) then {[] call FUNC(loadStatics)};

private _saveGradFortificationsStatics = ([missionConfigFile >> "CfgGradPersistence", "saveGradFortificationsStatics", 3] call BIS_fnc_returnConfigEntry) > 0;
if (_saveGradFortificationsStatics) then {[] call FUNC(loadGradFortificationsStatics)};

private _saveMarkers = ([missionConfigFile >> "CfgGradPersistence", "saveMarkers", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveMarkers) then {[] call FUNC(loadMarkers)};

private _saveTeamAccounts = ([missionConfigFile >> "CfgGradPersistence", "saveTeamAccounts", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveTeamAccounts) then {[] call FUNC(loadTeamAccounts)};

private _saveTasks = ([missionConfigFile >> "CfgGradPersistence", "saveTasks", 0] call BIS_fnc_returnConfigEntry) > 0;
if (_saveTasks) then {[] call FUNC(loadTasks)};

private _saveTriggers = ([missionConfigFile >> "CfgGradPersistence", "saveTriggers", 0] call BIS_fnc_returnConfigEntry) > 0;
if (_saveTriggers) then {[] call FUNC(loadTriggers)};

private _saveTimeAndDate = ([missionConfigFile >> "CfgGradPersistence", "saveTimeAndDate", 0] call BIS_fnc_returnConfigEntry) > 0;
if (_saveTimeAndDate) then {[] call FUNC(loadTimeAndDate)};

if (isClass (missionConfigFile >> "CfgGradPersistence" >> "customVariables")) then {
    [] call FUNC(loadVariables);
};

INFO("mission loaded");
"grad-persistence: mission loaded" remoteExec ["systemChat",0,false];
