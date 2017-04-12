if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_staticsTag = _missionTag + "_teamAccounts";
_teamAccountHash = [_staticsTag,true,0] call grad_persistence_fnc_getSaveData;

missionNamespace setVariable ["grad_lbm_teamFunds_WEST",[_teamAccountHash,"WEST"] call CBA_fnc_hashGet, true];
missionNamespace setVariable ["grad_lbm_teamFunds_EAST",[_teamAccountHash,"EAST"] call CBA_fnc_hashGet, true];
missionNamespace setVariable ["grad_lbm_teamFunds_INDEPENDENT",[_teamAccountHash,"INDEPENDENT"] call CBA_fnc_hashGet, true];
missionNamespace setVariable ["grad_lbm_teamFunds_CIVILIAN",[_teamAccountHash,"CIVILIAN"] call CBA_fnc_hashGet, true];
