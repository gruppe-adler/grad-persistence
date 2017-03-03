params [["_missionTag",[] call grad_persistence_fnc_getMissionTag]];

if (!isServer) exitWith {};

profileNamespace setVariable [_missionTag + "_groups",nil];
profileNamespace setVariable [_missionTag + "_vehicles",nil];
profileNamespace setVariable [_missionTag + "_statics",nil];


saveProfileNamespace;
