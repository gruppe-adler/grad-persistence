#include "script_component.hpp"

params ["_missionTag",["_worldName",worldName]];

if (!isServer) exitWith {};

private _isThisMission = false;
private _actualTag = if (isNil "_missionTag") then {
    _isThisMission = true;
    [] call FUNC(getMissionTag)
} else {
    _isThisMission = _missionTag == ([missionConfigFile >> "CfgGradPersistence", "missionTag", ""] call BIS_fnc_returnConfigEntry);
    [_missionTag] call FUNC(getMissionTag)
};

if (_isThisMission) then {
    ("Players will no longer be saved on disconnect.") remoteExec ["systemChat",0,false];
    missionNamespace setVariable [QGVAR(thisMissionCleared),true];
};

profileNamespace setVariable [_actualTag + "_groups",nil];
profileNamespace setVariable [_actualTag + "_vehicles",nil];
profileNamespace setVariable [_actualTag + "_containers",nil];
profileNamespace setVariable [_actualTag + "_statics",nil];
profileNamespace setVariable [_actualTag + "_gradFortificationsStatics",nil];
profileNamespace setVariable [_actualTag + "_triggers",nil];
profileNamespace setVariable [_actualTag + "_markers",nil];
profileNamespace setVariable [_actualTag + "_tasks",nil];
profileNamespace setVariable [_actualTag + "_players",nil];
profileNamespace setVariable [_actualTag + "_teamAccounts",nil];
profileNamespace setVariable [_actualTag + "_vars",nil];
profileNamespace setVariable [_actualTag + "_killedVarnames",nil];
profileNamespace setVariable [_actualTag + "_timeAndDate",nil];

INFO_1("Missiondata for missiontag %1 deleted.",_actualTag);
(format ["Missiondata for missiontag %1 deleted.",_actualTag]) remoteExec ["systemChat",0,false];

saveProfileNamespace;
