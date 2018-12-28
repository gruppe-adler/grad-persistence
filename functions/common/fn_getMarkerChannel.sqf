#include "script_component.hpp"

params ["_marker"];

if ((_marker find "_USER_DEFINED") != 0) exitWith {-1};

(_marker splitString " ") params ["",["_markerData",""]];
(_markerData splitString "/") params ["","",["_markerChannelStr","-1"]];

private _markerChannel = call compile _markerChannelStr;
if !(_markerChannel isEqualType 0) exitWith {-1};

_markerChannel
