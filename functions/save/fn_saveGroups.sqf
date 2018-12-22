/*  Saves groups in format:
*   [[side of group, unitsData],[side of group, unitsData],[...]]
*
*   unitsData:
*   [unit hash, unit hash, unit hash, [...]]
*/

#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false],["_allVariableClasses",[]]];

private _allGroupsVariableClasses = _allVariableClasses select {
    ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "group"
};

private _allUnitsVariableClasses = _allVariableClasses select {
    ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "unit"
};


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
    private _thisGroup = _x;
    private _thisGroupData = [side _x,[],[]];
    private _thisUnitsData = _thisGroupData select 1;

    {
        private _thisUnit = _x;

        if (
                !(isPlayer _thisUnit) &&
                {!(isNull _thisUnit)} &&
                {alive _thisUnit} &&
                {vehicle _thisUnit == _thisUnit} &&
                {(_thisUnit getVariable [QGVAR(isEditorObject),false]) isEqualTo (([missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry) == 3)} &&
                {!(_thisUnit getVariable [QGVAR(isExcluded),false])} &&
                {!((group _thisUnit) getVariable [QGVAR(isExcluded),false])} &&
                {if (_area isEqualType false) then {true} else {_thisUnit inArea _area}}
            ) then {

            _thisUnitHash = [] call CBA_fnc_hashCreate;
            [_thisUnitHash,"type",typeOf _thisUnit] call CBA_fnc_hashSet;
            [_thisUnitHash,"posASL",getPosASL _thisUnit] call CBA_fnc_hashSet;
            [_thisUnitHash,"dir",getDir _thisUnit] call CBA_fnc_hashSet;
            [_thisUnitHash,"damage",damage _thisUnit] call CBA_fnc_hashSet;

            private _thisUnitVars = [];
            {
                private _varName = [_x,"varName",""] call BIS_fnc_returnConfigEntry;
                private _value = _thisUnit getVariable _varName;
                if (!isNil "_value") then {
                    private _isPublic = [_x,"public",false] call BIS_fnc_returnConfigEntry;
                    _thisUnitVars pushBack [_varName,_value,_isPublic];
                };
            } forEach _allUnitsVariableClasses;

            [_thisUnitHash,"vars",_thisUnitVars] call CBA_fnc_hashSet;

            _thisUnitsData pushBack _thisUnitHash;
        };

    } forEach (units _thisGroup);

    // only save if group has units that were saved
    if (count (_thisGroupData select 1) > 0) then {
        _groupsData pushBack _thisGroupData;
        _thisGroupVars = _thisGroupData select 2;

        {
            private _varName = [_x,"varName",""] call BIS_fnc_returnConfigEntry;
            private _value = _thisGroup getVariable _varName;
            if (!isNil "_value") then {
                private _isPublic = [_x,"public",false] call BIS_fnc_returnConfigEntry;
                _thisGroupVars pushBack [_varName,_value,_isPublic];
            };
        } forEach _allGroupsVariableClasses;
    };

    false
} count _allGroups;

saveProfileNamespace;
