#include "script_component.hpp"

params [["_allVarClasses",[]],["_varObj",objNull]];

private _varsData = [];

{
    private _varName = [_x,"varName",""] call BIS_fnc_returnConfigEntry;
    private _value = _varObj getVariable _varName;
    if (!isNil "_value") then {
        private _isPublic = [_x,"public",false] call BIS_fnc_returnConfigEntry;
        _varsData pushBack [_varName,_value,_isPublic];
    };
} forEach _allVarClasses;

_varsData
