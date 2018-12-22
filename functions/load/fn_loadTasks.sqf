#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _tasksTag = _missionTag + "_tasks";
private _tasksData = [_tasksTag] call FUNC(getSaveData);

{
    _x call BIS_fnc_setTask;
} forEach _tasksData;
