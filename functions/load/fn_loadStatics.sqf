#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _staticsTag = _missionTag + "_statics";
private _staticsData = [_staticsTag] call FUNC(getSaveData);

{
    private _thisStaticHash = _x;
    private _type = [_thisStaticHash,"type"] call CBA_fnc_hashGet;
    private _thisStatic = createVehicle [_type,[0,0,0],[],0,"CAN_COLLIDE"];

    [{!isNull (_this select 0)}, {
        params ["_thisStatic","_thisStaticHash"];

        private _posASL = [_thisStaticHash,"posASL"] call CBA_fnc_hashGet;
        private _vectorDirAndUp = [_thisStaticHash,"vectorDirAndUp"] call CBA_fnc_hashGet;
        private _damage = [_thisStaticHash,"damage"] call CBA_fnc_hashGet;
        private _isGradFort = [_thisStaticHash,"isGradFort"] call CBA_fnc_hashGet;
        private _isGradMoneymenuStorage = [_thisStaticHash,"isGradMoneymenuStorage"] call CBA_fnc_hashGet;
        private _gradMoneymenuOwner = [_thisStaticHash,"gradMoneymenuOwner"] call CBA_fnc_hashGet;
        private _thisLbmMoney = [_thisStaticHash,"gradLbmMoney"] call CBA_fnc_hashGet;

        _thisStatic setVectorDirAndUp _vectorDirAndUp;
        _thisStatic setPosASL _posASL;
        _thisStatic setDamage _damage;

        if (_isGradFort && {isClass (missionConfigFile >> "CfgFunctions" >> "GRAD_fortifications")}) then {
            [_thisStatic,objNull] remoteExec ["grad_fortifications_fnc_initFort",0,true];
        };

        if (_isGradMoneymenuStorage && {!(_gradMoneymenuOwner isEqualType false)}) then {
            if !(objNull isEqualTo _gradMoneymenuOwner) then {
                [_thisStatic,_gradMoneymenuOwner] remoteExec ["grad_moneymenu_fnc_setStorage",0,true];
            } else {
                [_thisStatic] remoteExec ["grad_moneymenu_fnc_setStorage",0,true];
            };

            if (_thisLbmMoney isEqualType 0 && {_thisLbmMoney > 0}) then {
                _thisStatic setVariable ["grad_lbm_myFunds",_thisLbmMoney,true];
            };
        };

        private _vars = [_thisStaticHash,"vars"] call CBA_fnc_hashGet;
        [_vars,_thisStatic] call FUNC(loadObjectVars);

    }, [_thisStatic,_thisStaticHash]] call CBA_fnc_waitUntilAndExecute;

    false
} count _staticsData;
