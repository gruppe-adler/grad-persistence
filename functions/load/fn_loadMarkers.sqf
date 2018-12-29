#include "script_component.hpp"

private _missionTag = [] call FUNC(getMissionTag);
private _markersTag = _missionTag + "_markers";
private _markersData = [_markersTag] call FUNC(getSaveData);

{
    private _thisMarkerHash = _x;
    private _originalMarkerName = [_thisMarkerHash,"name"] call CBA_fnc_hashGet;
    private _markerName = if (_originalMarkerName find "_USER_DEFINED" == 0) then {
        (_originalMarkerName splitString " ") params ["",["_markerData",""]];
        (_markerData splitString "/") params ["","",["_channelID","-1"]];

        format ["_USER_DEFINED #%1_%2/%2/%3",QGVAR(marker),_forEachIndex,_channelID]
    } else {
        _originalMarkerName
    };

    // check if marker already exists
    private _thisMarker = if (markerShape _markerName == "") then {
        createMarker [_markerName,[0,0,0]]
    } else {
        _markerName
    };

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
