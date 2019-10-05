#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _timeAndDateTag = _missionTag + "_timeAndDate";

profileNamespace setVariable [_timeAndDateTag,date];

saveProfileNamespace;
