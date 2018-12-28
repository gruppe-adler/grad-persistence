#include "script_component.hpp"

params ["_area"];

private _markerSaveSetting = [missionConfigFile >> "CfgGradPersistence", "saveMarkers", 1] call BIS_fnc_returnConfigEntry;

private _applicableMarkers = allMapMarkers select {
    !((getMarkerType _x) in ["","Empty"]) &&
    {(_x find "ACE_BFT") != 0}
};

if !(_area isEqualType false) then {
    _applicableMarkers = _applicableMarkers select {
        (getMarkerPos _x) inArea _area
    };
};

if (_markerSaveSetting in [1,3]) then {
    _applicableMarkers = _applicableMarkers select {
        (_x in (missionNamespace getVariable [QGVAR(editorMarkers),[]])) isEqualTo (_markerSaveSetting == 3)
    };
};

if (_markerSaveSetting in [1,2]) then {
    _applicableMarkers select {
        ([_x] call FUNC(getMarkerChannel)) in [-1,0]
    };
};
