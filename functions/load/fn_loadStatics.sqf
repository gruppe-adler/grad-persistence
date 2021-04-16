#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _staticsTag = _missionTag + "_statics";
private _staticsData = [_staticsTag] call FUNC(getSaveData);

{
    private _thisStaticHash = _x;
    private _vehVarName = [_thisStaticHash,"varName"] call CBA_fnc_hashGet;

    private _thisStatic = objNull;
    private _editorVehicleFound = false;
    if (!isNil "_vehVarName") then {
        // editor-placed object that already exists
        private _editorVehicle = call compile _vehVarName;
        if (!isNil "_editorVehicle") then {
            _thisStatic = _editorVehicle;
            _editorVehicleFound = true;
        };
    };

    if (!_editorVehicleFound) then {
        private _type = [_thisStaticHash,"type"] call CBA_fnc_hashGet;
        _thisStatic = createVehicle [_type,[0,0,0],[],0,"CAN_COLLIDE"];

        if (!isNil "_vehVarName") then {
            [_thisStatic,_vehVarName] remoteExec ["setVehicleVarName",0,_thisStatic];
        };
    };


    [{!isNull (_this select 0)}, {
        params ["_thisStatic","_thisStaticHash"];

        private _posASL = [_thisStaticHash,"posASL"] call CBA_fnc_hashGet;
        private _vectorDirAndUp = [_thisStaticHash,"vectorDirAndUp"] call CBA_fnc_hashGet;
        private _damage = [_thisStaticHash,"damage"] call CBA_fnc_hashGet;
        private _isGradMoneymenuStorage = [_thisStaticHash,"isGradMoneymenuStorage"] call CBA_fnc_hashGet;
        private _gradMoneymenuOwner = [_thisStaticHash,"gradMoneymenuOwner"] call CBA_fnc_hashGet;
        private _thisLbmMoney = [_thisStaticHash,"gradLbmMoney"] call CBA_fnc_hashGet;

        _thisStatic setVectorDirAndUp _vectorDirAndUp;
        _thisStatic setPosASL _posASL;
        _thisStatic setDamage _damage;

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

} forEach _staticsData;

// delete all editor vehicles that were killed in a previous save
private _killedVarnames = [_missionTag + "_killedVarnames"] call FUNC(getSaveData);
private _killedStaticsVarnames = _killedVarnames param [3,[]];
{
    private _editorVehicle = call compile _x;
    if (!isNil "_editorVehicle") then {deleteVehicle _editorVehicle};
} forEach _killedStaticsVarnames;
