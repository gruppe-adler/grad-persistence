#include "script_component.hpp"

if (!isServer) exitWith {};

// units, vehicles, containers, statics
GVAR(allFoundVarNames) = [[],[],[],[]];

private _fnc_saveVarNames = {
    {
        private _varName = vehicleVarName _x;
        if (_varName != "") then {
            _varNames pushBack _varName;
        };
    } forEach _this;
};

private _saveUnitsMode = [missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry;
if (_saveUnitsMode > 0) then {
    private _allUnits = allUnits;
    private _varNames = GVAR(allFoundVarNames) select 0;

    if (_saveUnitsMode in [1,3]) then {
        {_x setVariable [QGVAR(isEditorObject),true]} forEach _allUnits;
    };

    if (_saveUnitsMode in [1,2]) then {
        _allUnits call _fnc_saveVarNames;
    };
};

private _saveVehiclesMode = [missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry;
if (_saveVehiclesMode > 0) then {
    private _allVehicles = vehicles select {!(_x isKindOf "Static") && !((_x isKindOf "ThingX") && (([configfile >> "CfgVehicles" >> typeOf _x,"maximumLoad",0] call BIS_fnc_returnConfigEntry) > 0))};
    private _varNames = GVAR(allFoundVarNames) select 1;

    if (_saveVehiclesMode in [1,3]) then {
        {_x setVariable [QGVAR(isEditorObject),true]} forEach _allVehicles;
    };

    if (_saveVehiclesMode in [1,2]) then {
        _allVehicles call _fnc_saveVarNames;
    };
};

private _saveContainersMode = [missionConfigFile >> "CfgGradPersistence", "saveContainers", 1] call BIS_fnc_returnConfigEntry;
if (_saveContainersMode > 0) then {
    private _allContainers = vehicles select {!(_x isKindOf "Static") && (_x isKindOf "ThingX") && (([configfile >> "CfgVehicles" >> typeOf _x,"maximumLoad",0] call BIS_fnc_returnConfigEntry) > 0)};
    private _varNames = GVAR(allFoundVarNames) select 2;

    if ((_saveContainersMode) in [1,3]) then {
        {_x setVariable [QGVAR(isEditorObject),true]} forEach _allContainers;
    };

    if (_saveContainersMode in [1,2]) then {
        _allContainers call _fnc_saveVarNames;
    };
};

private _saveStaticsMode = [missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry;
if (_saveStaticsMode > 0) then {
    private _allStatics = allMissionObjects "Static";
    private _varNames = GVAR(allFoundVarNames) select 3;

    if (_saveStaticsMode in [1,3]) then {
        {_x setVariable [QGVAR(isEditorObject),true]} forEach _allStatics;
    };

    if (_saveStaticsMode in [1,2]) then {
        _allStatics call _fnc_saveVarNames;
    };
};

if (([missionConfigFile >> "CfgGradPersistence", "saveMarkers", 1] call BIS_fnc_returnConfigEntry) in [1,3]) then {
    GVAR(editorMarkers) = allMapMarkers;
};
