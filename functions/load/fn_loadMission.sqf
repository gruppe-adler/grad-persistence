_saveUnits = ([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) == 1;
if (_saveUnits) then {[] call grad_persistence_fnc_loadGroups};
