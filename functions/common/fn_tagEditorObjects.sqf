#include "script_component.hpp"

if (!isServer) exitWith {};

if (([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) in [1,3]) then {
    {
        _x setVariable [QGVAR(isEditorObject),true];
        false
    } count allUnits;
};

if (([missionConfigFile >> "CfgGradPersistence", "saveVehicles", 1] call BIS_fnc_returnConfigEntry) in [1,3]) then {
    _allVehicles = vehicles;
    _allVehicles = _allVehicles select {!(_x isKindOf "Static") && !((_x isKindOf "ThingX") && (([configfile >> "CfgVehicles" >> typeOf _x,"maximumLoad",0] call BIS_fnc_returnConfigEntry) > 0))};
    {
        _x setVariable [QGVAR(isEditorObject),true];
        false
    } count _allVehicles;
};

if (([missionConfigFile >> "CfgGradPersistence", "saveContainers", 1] call BIS_fnc_returnConfigEntry) in [1,3]) then {
    _allVehicles = vehicles;
    _allVehicles = _allVehicles select {!(_x isKindOf "Static") && (_x isKindOf "ThingX") && (([configfile >> "CfgVehicles" >> typeOf _x,"maximumLoad",0] call BIS_fnc_returnConfigEntry) > 0)};
    {
        _x setVariable [QGVAR(isEditorObject),true];
        false
    } count _allVehicles;
};

if (([missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry) in [1,3]) then {
    _statics = allMissionObjects "Static";
    {
        _x setVariable [QGVAR(isEditorObject),true];
        false
    } count _statics;
};

if (([missionConfigFile >> "CfgGradPersistence", "saveMarkers", 1] call BIS_fnc_returnConfigEntry) in [1,3]) then {
    GVAR(editorMarkers) = allMapMarkers;
};
