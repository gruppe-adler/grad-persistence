#define PREFIX grad
#define COMPONENT persistence
#include "\x\cba\addons\main\script_macros_mission.hpp"

private _waitCondition = {!isNull player};
private _onTimeout = {
    ERROR("Player nullcheck timed out.");
};
private _fnc = {
    [{
        if !(player isKindOf "Man") exitWith {};
        [player] remoteExec [QFUNC(loadPlayer),2,false];
    },[],1] call CBA_fnc_waitAndExecute;
};

[_waitCondition,_fnc,[],60,_onTimeout] call CBA_fnc_waitUntilAndExecute;
