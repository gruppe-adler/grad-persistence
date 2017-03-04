params [["_missionTag",[missionConfigFile >> "CfgGradPersistence", "missionTag", ""] call BIS_fnc_returnConfigEntry]];

if (_missionTag == "") then {_missionTag = missionName};
_missionTag = [_missionTag] call BIS_fnc_filterString;
_missionTag = format ["%1_%2","mcd_grad_persistence",_missionTag];

_missionTag
