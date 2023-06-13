#define PREFIX grad
#define COMPONENT persistence
#include "\x\cba\addons\main\script_macros_mission.hpp"

private _waitCondition = {!isNull player};
private _onTimeout = {
    ERROR("Player nullcheck timed out.");
};
private _fnc = {
    if !(player isKindOf "Man") exitWith {};

    private _playerWaitConditionLocal = [missionConfigFile >> "CfgGradPersistence", "playerWaitConditionLocal", ""] call BIS_fnc_returnConfigEntry;
    if (_playerWaitConditionLocal == "") then {_playerWaitConditionLocal = "true"};

    [{call compile _this},{
        [player] remoteExec [QFUNC(loadPlayer),2,false];
    },_playerWaitConditionLocal] call CBA_fnc_waitUntilAndExecute;
};

[_waitCondition,_fnc,[],60,_onTimeout] call CBA_fnc_waitUntilAndExecute;
