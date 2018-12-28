#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

private _missionTag = [] call FUNC(getMissionTag);
private _markersTag = _missionTag + "_markers";
private _markersData = [_markersTag] call FUNC(getSaveData);
_markersData resize 0;

private _markers = [_area] call FUNC(getApplicableMarkers);

{
    private _thisMarkerHash = [] call CBA_fnc_hashCreate;

    [_thisMarkerHash,"name",_x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"alpha",markerAlpha _x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"brush",markerBrush _x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"color",getMarkerColor _x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"dir",markerDir _x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"pos",getMarkerPos _x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"shape",markerShape _x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"size",getMarkerSize _x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"text",markerText _x] call CBA_fnc_hashSet;
    [_thisMarkerHash,"type",getMarkerType _x] call CBA_fnc_hashSet;

    _markersData pushBack _thisMarkerHash;

} forEach _markers;

saveProfileNamespace;
