_missionTag = [missionConfigFile >> "CfgGradPersistence", "missionTag", ""] call BIS_fnc_returnConfigEntry;
if (_missionTag == "") then {_missionTag = missionName};
_missionTag = [_missionTag] call BIS_fnc_filterString;
_missionTag = "mcd_grad_persistence_" + _missionTag;

_missionTag
