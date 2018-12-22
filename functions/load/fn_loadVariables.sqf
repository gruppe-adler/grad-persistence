#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _varsTag = _missionTag + "_vars";
private _varsData = [_varsTag] call FUNC(getSaveData);

{
    private _thisVarsHash = _x;
    private _varName = [_thisVarsHash,"varName"] call CBA_fnc_hashGet;
    private _value = [_thisVarsHash,"value"] call CBA_fnc_hashGet;
    private _isPublic = [_thisVarsHash,"public"] call CBA_fnc_hashGet;

    missionNamespace setVariable [_varName,_value,_isPublic];

} forEach _varsData;
