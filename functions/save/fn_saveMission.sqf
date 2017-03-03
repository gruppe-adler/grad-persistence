_saveUnits = ([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) == 1;
if (_saveUnits) then {[] call grad_persistence_fnc_saveGroups};

_saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) == 1;
if (_saveVehicles) then {[] call grad_persistence_fnc_saveVehicles};

_saveStatics = ([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) == 1;
if (_saveStatics) then {[] call grad_persistence_fnc_saveStatics};

_savePlayerInventory = ([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1;
_savePlayerDamage = ([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1;
_savePlayerPosition = ([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1;
if (_savePlayerInventory || _savePlayerDamage || _savePlayerPosition) then {[_savePlayerInventory,_savePlayerDamage,_savePlayerPosition] call grad_persistence_fnc_saveAllPlayers};
