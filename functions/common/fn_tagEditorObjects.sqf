if (!isServer) exitWith {};

if (([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) == 1) then {
    {
        _x setVariable ["grad_persistence_isEditorObject",true];
        false
    } count allUnits;
};

if (([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) == 1) then {
    _allVehicles = vehicles;
    _allVehicles = _allVehicles select {!(_x isKindOf "Static")};
    {
        _x setVariable ["grad_persistence_isEditorObject",true];
        false
    } count _allVehicles;
};

if (([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) == 1) then {
    _statics = allMissionObjects "Static";
    {
        _x setVariable ["grad_persistence_isEditorObject",true];
        false
    } count _statics;
};
