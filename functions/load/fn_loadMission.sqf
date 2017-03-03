_saveUnits = ([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) == 1;
if (_saveUnits) then {[] call grad_persistence_fnc_loadGroups};

_saveVehicles = ([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) == 1;
if (_saveVehicles) then {[] call grad_persistence_fnc_loadVehicles};

_saveStatics = ([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) == 1;
if (_saveStatics) then {[] call grad_persistence_fnc_loadStatics};
