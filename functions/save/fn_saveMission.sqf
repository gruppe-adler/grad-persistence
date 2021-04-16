#include "script_component.hpp"

params [["_showWarning",false],["_waitTime",10],["_area",false]];

if (_showWarning) then {
    [_waitTime] remoteExec [QFUNC(showWarningMessage),0,false];
};

[{
    params ["_area"];

    private _allVariableClasses = "true" configClasses (missionConfigFile >> "CfgGradPersistence" >> "customVariables");

    _saveUnits = ([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveUnits) then {[_area,_allVariableClasses] call FUNC(saveGroups)};

    _saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveVehicles) then {[_area,_allVariableClasses] call FUNC(saveVehicles)};

    _saveContainers = ([missionConfigFile >> "CfgGradPersistence", "saveContainers", 1] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveContainers) then {[_area,_allVariableClasses] call FUNC(saveContainers)};

    _saveStatics = ([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveStatics) then {[_area,_allVariableClasses] call FUNC(saveStatics)};

    _saveGradFortificationsStatics = ([missionConfigFile >> "CfgGradPersistence", "saveGradFortificationsStatics", 3] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveGradFortificationsStatics) then {[_area,_allVariableClasses] call FUNC(saveGradFortificationsStatics)};

    _saveTriggers = ([missionConfigFile >> "CfgGradPersistence", "saveTriggers", 0] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveTriggers) then {[_area,_allVariableClasses] call FUNC(saveTriggers)};

    _saveMarkers = ([missionConfigFile >> "CfgGradPersistence", "saveMarkers", 0] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveMarkers) then {[_area] call FUNC(saveMarkers)};

    _saveTeamAccounts = ([missionConfigFile >> "CfgGradPersistence", "saveTeamAccounts", 1] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveTeamAccounts) then {[] call FUNC(saveTeamAccounts)};

    _saveTasks = ([missionConfigFile >> "CfgGradPersistence", "saveTasks", 0] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveTasks) then {[] call FUNC(saveTasks)};

    _saveTimeAndDate = ([missionConfigFile >> "CfgGradPersistence", "saveTimeAndDate", 0] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveTimeAndDate) then {[] call FUNC(saveTimeAndDate)};

    _savePlayerInventory = ([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1;
    _savePlayerDamage = ([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 1] call BIS_fnc_returnConfigEntry) == 1;
    _savePlayerPosition = ([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 1] call BIS_fnc_returnConfigEntry) == 1;
    _savePlayerMoney = ([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 1] call BIS_fnc_returnConfigEntry) == 1;
    if (_savePlayerInventory || _savePlayerDamage || _savePlayerPosition || _savePlayerMoney) then {[_savePlayerInventory,_savePlayerDamage,_savePlayerPosition,_savePlayerMoney,_allVariableClasses] call FUNC(saveAllPlayers)};

    [_allVariableClasses] call FUNC(saveVariables);

    "grad-persistence: mission saved" remoteExec ["systemChat",0,false];
}, [_area], _waitTime] call CBA_fnc_waitAndExecute;
