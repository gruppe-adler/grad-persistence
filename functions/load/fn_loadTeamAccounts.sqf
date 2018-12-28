#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _staticsTag = _missionTag + "_teamAccounts";
private _teamAccountHash = [_staticsTag,true,0] call FUNC(getSaveData);

missionNamespace setVariable ["grad_lbm_teamFunds_WEST",[_teamAccountHash,"WEST"] call CBA_fnc_hashGet, true];
missionNamespace setVariable ["grad_lbm_teamFunds_EAST",[_teamAccountHash,"EAST"] call CBA_fnc_hashGet, true];
missionNamespace setVariable ["grad_lbm_teamFunds_INDEPENDENT",[_teamAccountHash,"INDEPENDENT"] call CBA_fnc_hashGet, true];
missionNamespace setVariable ["grad_lbm_teamFunds_CIVILIAN",[_teamAccountHash,"CIVILIAN"] call CBA_fnc_hashGet, true];
