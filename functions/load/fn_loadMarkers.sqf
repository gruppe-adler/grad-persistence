#include "script_component.hpp"

private _missionTag = [] call FUNC(getMissionTag);
private _markersTag = _missionTag + "_markers";
private _markersData = [_markersTag] call FUNC(getSaveData);

{
    _thisMarkerHash = _x;
    _thisMarker = createMarker [[_thisMarkerHash,"name"] call CBA_fnc_hashGet,[0,0,0]];

    _thisMarker setMarkerAlpha ([_thisMarkerHash,"alpha"] call CBA_fnc_hashGet);
    _thisMarker setMarkerBrush ([_thisMarkerHash,"brush"] call CBA_fnc_hashGet);
    _thisMarker setMarkerColor ([_thisMarkerHash,"color"] call CBA_fnc_hashGet);
    _thisMarker setMarkerDir ([_thisMarkerHash,"dir"] call CBA_fnc_hashGet);
    _thisMarker setMarkerPos ([_thisMarkerHash,"pos"] call CBA_fnc_hashGet);
    _thisMarker setMarkerShape ([_thisMarkerHash,"shape"] call CBA_fnc_hashGet);
    _thisMarker setMarkerSize ([_thisMarkerHash,"size"] call CBA_fnc_hashGet);
    _thisMarker setMarkerText ([_thisMarkerHash,"text"] call CBA_fnc_hashGet);
    _thisMarker setMarkerType ([_thisMarkerHash,"type"] call CBA_fnc_hashGet);

} forEach _markersData;
