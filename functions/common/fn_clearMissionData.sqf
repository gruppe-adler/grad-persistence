params [["_missionTag",[] call grad_persistence_fnc_getMissionTag]];

if (!isServer) exitWith {};

profileNamespace setVariable [_missionTag + "_groups",nil];


saveProfileNamespace;
