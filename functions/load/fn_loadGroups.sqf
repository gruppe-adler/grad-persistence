#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call grad_persistence_fnc_getMissionTag;
private _groupsTag = _missionTag + "_groups";
private _groupsData = [_groupsTag] call grad_persistence_fnc_getSaveData;

{
    _x params ["_thisGroupSide","_thisGroupUnits","_thisGroupVars"];
    private _thisGroup = createGroup _thisGroupSide;

    {
        _thisUnitHash = _x;

        private _vehVarName = [_thisUnitHash,"varName"] call CBA_fnc_hashGet;

        private _thisUnit = objNull;
        private _editorVehicleFound = false;
        if (!isNil "_vehVarName") then {
            // editor-placed object that already exists
            private _editorVehicle = call compile _vehVarName;
            if (!isNil "_editorVehicle") then {
                _thisUnit = _editorVehicle;
                _editorVehicleFound = true;
            };
        };

        if (!_editorVehicleFound) then {
            private _type = [_thisUnitHash,"type"] call CBA_fnc_hashGet;
            _thisUnit = _thisGroup createUnit [_type, [0,0,0], [], 0, "CAN_COLLIDE"];

            if (!isNil "_vehVarName") then {
                [_thisVehicle,_vehVarName] remoteExec ["setVehicleVarName",0,_thisVehicle];
            };
        };

        [{!isNull (_this select 0)}, {
            params ["_thisUnit","_thisUnitHash"];

            private _posASL = [_thisUnitHash,"posASL"] call CBA_fnc_hashGet;
            private _dir = [_thisUnitHash,"dir"] call CBA_fnc_hashGet;
            private _damage = [_thisUnitHash,"damage"] call CBA_fnc_hashGet;
            private _vars = [_thisUnitHash,"vars"] call CBA_fnc_hashGet;

            _thisUnit setDir _dir;
            _thisUnit setPosASL _posASL;
            _thisUnit setDamage _damage;

            [_vars,_thisUnit] call FUNC(loadObjectVars);
        },[_thisUnit,_thisUnitHash]] call CBA_fnc_waitUntilAndExecute;

    } forEach _thisGroupUnits;

    [_thisGroupVars,_thisGroup] call FUNC(loadObjectVars);

} forEach _groupsData;

// delete all editor vehicles that were killed in a previous save
private _killedVarnames = [_missionTag + "_killedVarnames"] call FUNC(getSaveData);
private _killedUnitsVarnames = _killedVarnames param [0,[]];
{
    private _editorVehicle = call compile _x;
    if (!isNil "_editorVehicle") then {deleteVehicle _editorVehicle};
} forEach _killedUnitsVarnames;
