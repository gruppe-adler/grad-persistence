#include "script_component.hpp"

if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_groupsTag = _missionTag + "_groups";
_groupsData = [_groupsTag] call grad_persistence_fnc_getSaveData;

{
    _x params ["_thisGroupSide","_thisGroupUnits","_thisGroupVars"];
    private _thisGroup = createGroup _thisGroupSide;

    {
        _thisUnitHash = _x;

        _type = [_thisUnitHash,"type"] call CBA_fnc_hashGet;
        _thisUnit = _thisGroup createUnit [_type, [0,0,0], [], 0, "CAN_COLLIDE"];

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
