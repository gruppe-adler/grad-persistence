#define PREFIX grad
#define COMPONENT persistence
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_missionTag",["_worldName",worldName]];

if (!isServer) exitWith {};

_actualTag = if (isNil "_missionTag") then {
    [] call grad_persistence_fnc_getMissionTag;
} else {
    [_missionTag] call grad_persistence_fnc_getMissionTag;
};

profileNamespace setVariable [_actualTag + "_groups",nil];
profileNamespace setVariable [_actualTag + "_vehicles",nil];
profileNamespace setVariable [_actualTag + "_statics",nil];
profileNamespace setVariable [_actualTag + "_players",nil];
profileNamespace setVariable [_actualTag + "_teamAccounts",nil];

INFO_1("Missiondata for missiontag %1 deleted.",_actualTag);
(format ["Missiondata for missiontag %1 deleted.",_actualTag]) remoteExec ["systemChat",0,false];

saveProfileNamespace;
