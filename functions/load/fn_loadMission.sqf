_saveUnits = ([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveUnits) then {[] call grad_persistence_fnc_loadGroups};

_saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveVehicles) then {[] call grad_persistence_fnc_loadVehicles};

_saveStatics = ([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveStatics) then {[] call grad_persistence_fnc_loadStatics};

_saveTeamAccounts = ([missionConfigFile >> "CfgGradPersistence", "saveTeamAccounts", 1] call BIS_fnc_returnConfigEntry) > 0;
if (_saveTeamAccounts) then {[] call grad_persistence_fnc_loadTeamAccounts};

_savePlayerInventory = ([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1;
_savePlayerDamage = ([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 1] call BIS_fnc_returnConfigEntry) == 1;
_savePlayerPosition = ([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 1] call BIS_fnc_returnConfigEntry) == 1;
_savePlayerMoney = ([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 1] call BIS_fnc_returnConfigEntry) == 1;
if (_savePlayerInventory || _savePlayerDamage || _savePlayerPosition || _savePlayerMoney) then {[_savePlayerInventory,_savePlayerDamage,_savePlayerPosition,_savePlayerMoney] call grad_persistence_fnc_loadAllPlayers};

"grad-persistence: mission loaded" remoteExec ["systemChat",0,false];
