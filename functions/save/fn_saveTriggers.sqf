#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false],["_allVariableClasses",[]]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

private _allTriggerVariableClasses = _allVariableClasses select {
    ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "trigger"
};

private _missionTag = [] call FUNC(getMissionTag);
private _triggersTag = _missionTag + "_triggers";
private _triggersData = [_triggersTag] call FUNC(getSaveData);
_triggersData resize 0;

private _triggers = (allMissionObjects "EmptyDetector") select {!([_x] call FUNC(isBlacklisted))};
if (_area isEqualType []) then {
    _triggers = _triggers select {_x inArea _area};
};

{
    private _thisTriggerHash = [] call CBA_fnc_hashCreate;

    private _vehVarName = vehicleVarName _x;
    if (_vehVarName != "") then {
        [_thisTriggerHash,"varName",_vehVarName] call CBA_fnc_hashSet;
    };

    [_thisTriggerHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
    [_thisTriggerHash,"activated",triggerActivated _x] call CBA_fnc_hashSet;
    [_thisTriggerHash,"activation",triggerActivation _x] call CBA_fnc_hashSet;
    [_thisTriggerHash,"area",triggerArea _x] call CBA_fnc_hashSet;
    [_thisTriggerHash,"statements",triggerStatements _x] call CBA_fnc_hashSet;
    [_thisTriggerHash,"timeout",triggerTimeout _x] call CBA_fnc_hashSet;
    [_thisTriggerHash,"text",triggerText _x] call CBA_fnc_hashSet;
    [_thisTriggerHash,"type",triggerType _x] call CBA_fnc_hashSet;

    if (!isNil {_x getVariable QGVAR(reExecute)}) then {
        [_thisTriggerHash,"reExecute",_x getVariable QGVAR(reExecute)] call CBA_fnc_hashSet;
    };

    private _thisTriggerVars = [_allTriggerVariableClasses,_x] call FUNC(saveObjectVars);
    [_thisTriggerHash,"vars",_thisTriggerVars] call CBA_fnc_hashSet;

    _triggersData pushBack _thisTriggerHash;
} forEach _triggers;

saveProfileNamespace;
