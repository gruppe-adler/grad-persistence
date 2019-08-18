#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _containersTag = _missionTag + "_containers";
private _containersData = [_containersTag] call FUNC(getSaveData);

{

    private _thisContainerHash = _x;
    private _side = [_thisContainerHash,"side"] call CBA_fnc_hashGet;
    private _vehVarName = [_thisContainerHash,"varName"] call CBA_fnc_hashGet;

    private _thisContainer = objNull;
    private _editorVehicleFound = false;
    if (!isNil "_vehVarName") then {
        // editor-placed object that already exists
        private _editorVehicle = call compile _vehVarName;
        if (!isNil "_editorVehicle") then {
            _thisContainer = _editorVehicle;
            _editorVehicleFound = true;
        };
    };

    if (!_editorVehicleFound) then {
        private _type = [_thisContainerHash,"type"] call CBA_fnc_hashGet;
        _thisContainer = createVehicle [_type, [0,0,0], [], 0, "CAN_COLLIDE"];

        if (!isNil "_vehVarName") then {
            [_thisVehicle,_vehVarName] remoteExec ["setVehicleVarName",0,_thisVehicle];
        };
    };

    [{!isNull (_this select 0)}, {
        params ["_thisContainer","_thisContainerHash"];

        private _posASL = [_thisContainerHash,"posASL"] call CBA_fnc_hashGet;
        private _vectorDirAndUp = [_thisContainerHash,"vectorDirAndUp"] call CBA_fnc_hashGet;
        private _damage = [_thisContainerHash,"damage"] call CBA_fnc_hashGet;
        private _inventory = [_thisContainerHash,"inventory"] call CBA_fnc_hashGet;
        private _isGradFort = [_thisContainerHash,"isGradFort"] call CBA_fnc_hashGet;
        private _isGradMoneymenuStorage = [_thisContainerHash,"isGradMoneymenuStorage"] call CBA_fnc_hashGet;
        private _gradMoneymenuOwner = [_thisContainerHash,"gradMoneymenuOwner"] call CBA_fnc_hashGet;
        private _thisLbmMoney = [_thisContainerHash,"gradLbmMoney"] call CBA_fnc_hashGet;

        _thisContainer setVectorDirAndUp _vectorDirAndUp;
        _thisContainer setPosASL _posASL;
        _thisContainer setDamage _damage;

        [_thisContainer,_inventory] call FUNC(loadVehicleInventory);

        if (_isGradFort && {isClass (missionConfigFile >> "CfgFunctions" >> "GRAD_fortifications")}) then {
            [_thisContainer,objNull] remoteExec ["grad_fortifications_fnc_initFort",0,true];
        };

        if (_isGradMoneymenuStorage) then {
            if !(objNull isEqualTo _gradMoneymenuOwner) then {
                [_thisContainer,_gradMoneymenuOwner] remoteExec ["grad_moneymenu_fnc_setStorage",0,true];
            } else {
                [_thisContainer] remoteExec ["grad_moneymenu_fnc_setStorage",0,true];
            };

            if (_thisLbmMoney isEqualType 0 && {_thisLbmMoney > 0}) then {
                _thisContainer setVariable ["grad_lbm_myFunds",_thisLbmMoney,true];
            };
        };

        private _vars = [_thisContainerHash,"vars"] call CBA_fnc_hashGet;
        [_vars,_thisContainer] call FUNC(loadObjectVars);

    }, [_thisContainer,_thisContainerHash]] call CBA_fnc_waitUntilAndExecute;

} forEach _containersData;

// delete all editor vehicles that were killed in a previous save
private _killedVarnames = [_missionTag + "_killedVarnames"] call FUNC(getSaveData);
private _killedContainersVarnames = _killedVarnames param [2,[]];
{
    private _editorVehicle = call compile _x;
    if (!isNil "_editorVehicle") then {deleteVehicle _editorVehicle};
} forEach _killedContainersVarnames;
