#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _timeAndDateTag = _missionTag + "_timeAndDate";

private _date = profileNamespace getVariable _timeAndDateTag;
if (!isNil "_date") then {
    setDate _date;
};
