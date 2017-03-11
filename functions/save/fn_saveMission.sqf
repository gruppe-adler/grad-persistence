params [["_showWarning",false],["_waitTime",10],["_area",false]];

if (_showWarning) then {
    [_waitTime] remoteExec ["grad_persistence_fnc_showWarningMessage",0,false];
};

[{
    params ["_area"];

    _saveUnits = ([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveUnits) then {[_area] call grad_persistence_fnc_saveGroups};

    _saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveVehicles) then {[_area] call grad_persistence_fnc_saveVehicles};

    _saveStatics = ([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) > 0;
    if (_saveStatics) then {[_area] call grad_persistence_fnc_saveStatics};

    _savePlayerInventory = ([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1;
    _savePlayerDamage = ([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 1] call BIS_fnc_returnConfigEntry) == 1;
    _savePlayerPosition = ([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 1] call BIS_fnc_returnConfigEntry) == 1;
    _savePlayerMoney = ([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 1] call BIS_fnc_returnConfigEntry) == 1;
    if (_savePlayerInventory || _savePlayerDamage || _savePlayerPosition || _savePlayerMoney) then {[_savePlayerInventory,_savePlayerDamage,_savePlayerPosition,_savePlayerMoney] call grad_persistence_fnc_saveAllPlayers};

    "grad-persistence: mission saved" remoteExec ["systemChat",0,false];
}, [_area], _waitTime] call CBA_fnc_waitAndExecute;
