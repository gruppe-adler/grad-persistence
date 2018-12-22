#include "script_component.hpp"

params ["_allVariableClasses"];

private _missionTag = [] call FUNC(getMissionTag);
private _varsTag = _missionTag + "_vars";
private _varsData = [_varsTag] call FUNC(getSaveData);
_varsData resize 0;

{
    private _varNamespace = [_x,"varNamespace",false] call BIS_fnc_returnConfigEntry;

    if (_varNamespace isEqualType "" && {_varNamespace == "mission"}) then {

        private _varName = [_x,"varName",""] call BIS_fnc_returnConfigEntry;
        private _isPublic = ([_x,"public",0] call BIS_fnc_returnConfigEntry) == 1;
        private _currentValue = missionNamespace getVariable _varName;

        if (!isNil "_currentValue") then {
            private _thisVarsHash = [] call CBA_fnc_hashCreate;
            [_thisVarsHash,"varName",_varName] call CBA_fnc_hashSet;
            [_thisVarsHash,"public",_isPublic] call CBA_fnc_hashSet;
            [_thisVarsHash,"value",_currentValue] call CBA_fnc_hashSet;

            _varsData pushBack _thisVarsHash;
        };
    };
} forEach _allVariableClasses;

saveProfileNamespace
