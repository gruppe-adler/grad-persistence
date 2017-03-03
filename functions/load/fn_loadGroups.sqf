if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_groupsTag = _missionTag + "_groups";
_groupsData = [_groupsTag] call grad_persistence_fnc_getSaveData;

{
    _x params ["_thisGroupSide","_thisGroupUnits"];
    _thisGroup = createGroup _thisGroupSide;

    {
        _thisUnitHash = _x;

        _type = [_thisUnitHash,"type"] call CBA_fnc_hashGet;
        _thisUnit = _thisGroup createUnit [_type, [0,0,0], [], 0, "CAN_COLLIDE"];

        [{!isNull (_this select 0)}, {
            params ["_thisUnit","_thisUnitHash"];

            _posASL = [_thisUnitHash,"posASL"] call CBA_fnc_hashGet;
            _dir = [_thisUnitHash,"dir"] call CBA_fnc_hashGet;
            _damage = [_thisUnitHash,"damage"] call CBA_fnc_hashGet;

            _thisUnit setDir _dir;
            _thisUnit setPosASL _posASL;
            _thisUnit setDamage _damage;
        }, [_thisUnit,_thisUnitHash]] call CBA_fnc_waitUntilAndExecute;

        false
    } count _thisGroupUnits;
    false
} count _groupsData;
