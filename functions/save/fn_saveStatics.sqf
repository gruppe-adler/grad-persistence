#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false],["_allVariableClasses",[]]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

private _allStaticVariableClasses = _allVariableClasses select {
    ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "static"
};

private _missionTag = [] call FUNC(getMissionTag);
private _staticsTag = _missionTag + "_statics";
private _staticsData = [_staticsTag] call FUNC(getSaveData);
private _foundStaticsVarnames = GVAR(allFoundVarNames) select 3;
_staticsData resize 0;

private _statics = allMissionObjects "Static";
private _saveStaticsMode = [missionConfigFile >> "CfgGradPersistence", "saveStatics", 1] call BIS_fnc_returnConfigEntry;

{
    if (
            typeOf _x != "CBA_NamespaceDummy" &&
            {!([_x] call FUNC(isBlacklisted))} &&
            {
                _saveStaticsMode == 2 ||
                (_x getVariable [QGVAR(isEditorObject),false]) isEqualTo (_saveStaticsMode == 1)
            } &&
            // exclude grad-fortifications
            {isNil {_x getVariable "grad_fortifications_fortOwner"}} &&
            {if (_area isEqualType false) then {true} else {_x inArea _area}}
        ) then {

        _thisStaticHash = [] call CBA_fnc_hashCreate;

        private _vehVarName = vehicleVarName _x;
        if (_vehVarName != "") then {
            [_thisStaticHash,"varName",_vehVarName] call CBA_fnc_hashSet;
            _foundStaticsVarnames deleteAt (_foundStaticsVarnames find _vehVarName);
        };

        [_thisStaticHash,"type",typeOf _x] call CBA_fnc_hashSet;
        [_thisStaticHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
        [_thisStaticHash,"vectorDirAndUp",[vectorDir _x, vectorUp _x]] call CBA_fnc_hashSet;
        [_thisStaticHash,"damage",damage _x] call CBA_fnc_hashSet;
        [_thisStaticHash,"isGradMoneymenuStorage",_x getVariable ["grad_moneymenu_isStorage",false]] call CBA_fnc_hashSet;
        [_thisStaticHash,"gradMoneymenuOwner",_x getVariable ["grad_moneymenu_owner",objNull]] call CBA_fnc_hashSet;
        [_thisStaticHash,"gradLbmMoney",_x getVariable ["grad_lbm_myFunds",objNull]] call CBA_fnc_hashSet;

        private _thisStaticVars = [_allStaticVariableClasses,_x] call FUNC(saveObjectVars);
        [_thisStaticHash,"vars",_thisStaticVars] call CBA_fnc_hashSet;

        _staticsData pushBack _thisStaticHash;
    };
} forEach _statics;

// all _foundVehiclesVarnames that were not saved must have been removed or killed --> add to killedVarNames array
private _killedVarnames = [_missionTag + "_killedVarnames"] call FUNC(getSaveData);
private _killedStaticsVarnames = _killedVarnames param [3,[]];
_killedStaticsVarnames append _foundStaticsVarnames;
_killedStaticsVarnames arrayIntersect _killedStaticsVarnames;
_killedVarnames set [3,_killedStaticsVarnames];


saveProfileNamespace;
