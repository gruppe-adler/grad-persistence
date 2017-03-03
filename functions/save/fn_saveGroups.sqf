/*  Saves groups in format:
*   [[side of group, unitsData],[side of group, unitsData],[...]]
*
*   unitsData:
*   [unit hash, unit hash, unit hash, [...]]
*/

if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_groupsTag = _missionTag + "_groups";
_groupsData = [_groupsTag] call grad_persistence_fnc_getSaveData;
_groupsData resize 0;

_allGroups = allGroups;

{
    _thisGroup = _x;
    _thisGroupData = [side _x,[]];
    _thisUnitsData = _thisGroupData select 1;

    {
        if (!(isPlayer _x) && {!(isNull _x)} && {alive _x} && {vehicle _x == _x}) then {
            _thisUnitHash = [] call CBA_fnc_hashCreate;
            [_thisUnitHash,"type",typeOf _x] call CBA_fnc_hashSet;
            [_thisUnitHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
            [_thisUnitHash,"dir",getDir _x] call CBA_fnc_hashSet;
            [_thisUnitHash,"damage",damage _x] call CBA_fnc_hashSet;

            _thisUnitsData pushBack _thisUnitHash;
        };

        false
    } count (units _thisGroup);

    if (count (_thisGroupData select 1) > 0) then {
        _groupsData pushBack _thisGroupData;
    };

    false
} count _allGroups;

saveProfileNamespace;
