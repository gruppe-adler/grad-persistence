#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_area",false],["_allVariableClasses",[]]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

private _allGradFortificationsVariableClasses = _allVariableClasses select {
    ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "gradFortificationsStatic"
};

private _missionTag = [] call FUNC(getMissionTag);
private _gradFortificationsTag = _missionTag + "_gradFortificationsStatics";
private _gradFortificationsData = [_gradFortificationsTag] call FUNC(getSaveData);
_gradFortificationsData resize 0;

private _gradFortificationsStatics = (allMissionObjects "Static") select {!isNil {_x getVariable "grad_fortifications_fortOwner"}};

{
    if (
            typeOf _x != "CBA_NamespaceDummy" &&
            {!([_x] call FUNC(isBlacklisted))} &&
            {if (_area isEqualType false) then {true} else {_x inArea _area}}
        ) then {

        _thisGradFortificationsStaticsHash = [] call CBA_fnc_hashCreate;

        [_thisGradFortificationsStaticsHash,"type",typeOf _x] call CBA_fnc_hashSet;
        [_thisGradFortificationsStaticsHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
        [_thisGradFortificationsStaticsHash,"vectorDirAndUp",[vectorDir _x, vectorUp _x]] call CBA_fnc_hashSet;
        [_thisGradFortificationsStaticsHash,"damage",damage _x] call CBA_fnc_hashSet;
        [_thisGradFortificationsStaticsHash,"isGradMoneymenuStorage",_x getVariable ["grad_moneymenu_isStorage",false]] call CBA_fnc_hashSet;
        [_thisGradFortificationsStaticsHash,"gradMoneymenuOwner",_x getVariable ["grad_moneymenu_owner",objNull]] call CBA_fnc_hashSet;
        [_thisGradFortificationsStaticsHash,"gradLbmMoney",_x getVariable ["grad_lbm_myFunds",objNull]] call CBA_fnc_hashSet;

        private _fortOwner = _x getVariable ["grad_fortifications_fortOwner",objNull];
        // save UID instead of object, because object is lost
        if (_fortOwner isEqualType objNull) then {
            _fortOwner = getPlayerUID _fortOwner;
        } else {
            // discard owner of type group, because group is lost
            if (_fortOwner isEqualType grpNull) then {
                _fortOwner = "";
            };
            // don't do anything if type side
        };
        [_thisGradFortificationsStaticsHash,"gradFortificationsOwner",_fortOwner] call CBA_fnc_hashSet;

        private _thisGradFortificationsStaticVars = [_allGradFortificationsVariableClasses,_x] call FUNC(saveObjectVars);
        [_thisGradFortificationsStaticsHash,"vars",_thisGradFortificationsStaticVars] call CBA_fnc_hashSet;

        _gradFortificationsData pushBack _thisGradFortificationsStaticsHash;
    };
} forEach _gradFortificationsStatics;


saveProfileNamespace;
