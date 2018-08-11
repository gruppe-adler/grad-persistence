if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_staticsTag = _missionTag + "_statics";
_staticsData = [_staticsTag] call grad_persistence_fnc_getSaveData;

{
    _thisStaticHash = _x;
    _type = [_thisStaticHash,"type"] call CBA_fnc_hashGet;
    _thisStatic = createVehicle [_type,[0,0,0],[],0,"CAN_COLLIDE"];

    [{!isNull (_this select 0)}, {
        params ["_thisStatic","_thisStaticHash"];

        _posASL = [_thisStaticHash,"posASL"] call CBA_fnc_hashGet;
        _vectorDirAndUp = [_thisStaticHash,"vectorDirAndUp"] call CBA_fnc_hashGet;
        _damage = [_thisStaticHash,"damage"] call CBA_fnc_hashGet;
        _isGradFort = [_thisStaticHash,"isGradFort"] call CBA_fnc_hashGet;
        _isGradMoneymenuStorage = [_thisStaticHash,"isGradMoneymenuStorage"] call CBA_fnc_hashGet;
        _gradMoneymenuOwner = [_thisStaticHash,"gradMoneymenuOwner"] call CBA_fnc_hashGet;
        _thisLbmMoney = [_thisStaticHash,"gradLbmMoney"] call CBA_fnc_hashGet;

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

    }, [_thisStatic,_thisStaticHash]] call CBA_fnc_waitUntilAndExecute;

    false
} count _staticsData;
