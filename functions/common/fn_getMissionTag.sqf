params [["_missionTag",[missionConfigFile >> "CfgGradPersistence", "missionTag", ""] call BIS_fnc_returnConfigEntry],["_worldName",worldName]];

if (_missionTag == "") then {_missionTag = missionName};
_missionTag = [_missionTag] call BIS_fnc_filterString;
_worldName = [_worldName] call BIS_fnc_filterString;
_missionTag = format ["%1_%2_%3","mcd_grad_persistence",_worldName,_missionTag];

_missionTag
