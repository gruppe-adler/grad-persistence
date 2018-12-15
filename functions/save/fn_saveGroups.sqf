/*  Saves groups in format:
*   [[side of group, unitsData],[side of group, unitsData],[...]]
*
*   unitsData:
*   [unit hash, unit hash, unit hash, [...]]
*/

#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

private _missionTag = [] call FUNC(getMissionTag);
private _groupsTag = _missionTag + "_groups";
private _groupsData = [_groupsTag] call FUNC(getSaveData);
_groupsData resize 0;

private _allGroups = allGroups;

{
    _thisGroup = _x;
    _thisGroupData = [side _x,[]];
    _thisUnitsData = _thisGroupData select 1;

    {
        if (
                !(isPlayer _x) &&
                {!(isNull _x)} &&
                {alive _x} &&
                {vehicle _x == _x} &&
                {(_x getVariable [QGVAR(isEditorObject),false]) isEqualTo (([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) == 3)} &&
                {!(_x getVariable [QGVAR(isExcluded),false])} &&
                {!((group _x) getVariable [QGVAR(isExcluded),false])} &&
                {if (_area isEqualType false) then {true} else {_x inArea _area}}
            ) then {

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
