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
private _foundUnitsVarnames = GVAR(allFoundVarNames) select 0;
_groupsData resize 0;

private _allGroups = allGroups;
private _saveGroupsMode = [missionConfigFile >> "CfgGradPersistence", "saveUnits", 1] call BIS_fnc_returnConfigEntry;

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
                {!([_thisUnit] call FUNC(isBlacklisted))} &&
                {!((group _thisUnit) getVariable [QGVAR(isExcluded),false])} &&
                {
                    _saveGroupsMode == 2 ||
                    (_thisUnit getVariable [QGVAR(isEditorObject),false]) isEqualTo (_saveGroupsMode == 1)
                } &&
                {if (_area isEqualType false) then {true} else {_thisUnit inArea _area}}
            ) then {

            _thisUnitHash = [] call CBA_fnc_hashCreate;

            private _vehVarName = vehicleVarName _thisUnit;
            if (_vehVarName != "") then {
                [_thisUnitHash,"varName",_vehVarName] call CBA_fnc_hashSet;
                _foundUnitsVarnames deleteAt (_foundUnitsVarnames find _vehVarName);
            };

            [_thisUnitHash,"type",typeOf _thisUnit] call CBA_fnc_hashSet;
            [_thisUnitHash,"posASL",getPosASL _thisUnit] call CBA_fnc_hashSet;
            [_thisUnitHash,"dir",getDir _thisUnit] call CBA_fnc_hashSet;
            [_thisUnitHash,"damage",damage _thisUnit] call CBA_fnc_hashSet;

            private _thisUnitVars = [_allUnitsVariableClasses,_thisUnit] call FUNC(saveObjectVars);
            [_thisUnitHash,"vars",_thisUnitVars] call CBA_fnc_hashSet;

            _thisUnitsData pushBack _thisUnitHash;
        };

    } forEach (units _thisGroup);

    // only save if group has units that were saved
    if (count (_thisGroupData select 1) > 0) then {
        _groupsData pushBack _thisGroupData;
        _thisGroupData set [2,[_allGroupsVariableClasses,_thisGroup] call FUNC(saveObjectVars)];
    };

    false
} count _allGroups;

// all _foundVehiclesVarnames that were not saved must have been removed or killed --> add to killedVarNames array
private _killedVarnames = [_missionTag + "_killedVarnames"] call FUNC(getSaveData);
private _killedUnitsVarnames = _killedVarnames param [0,[]];
_killedUnitsVarnames append _foundUnitsVarnames;
_killedUnitsVarnames arrayIntersect _killedUnitsVarnames;
_killedVarnames set [0,_killedUnitsVarnames];

saveProfileNamespace;
