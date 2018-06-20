if (!isServer) exitWith {};

params [["_area",false]];

if (_area isEqualType []) then {
    _area params ["_center","_a","_b",["_angle",0],["_isRectangle",false],["_c",-1]];
    if (isNil "_b") then {_b = _a};
    _area = [_center,_a,_b,_angle,_isRectangle,_c];
};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_staticsTag = _missionTag + "_statics";
_staticsData = [_staticsTag] call grad_persistence_fnc_getSaveData;
_staticsData resize 0;

_statics = allMissionObjects "Static";

{
    if (
            typeOf _x != "CBA_NamespaceDummy" &&
            {!(_x getVariable ["grad_persistence_isEditorObject",false]) || [missionConfigFile >> "CfgGradPersistence", "excludeEditorObjects", 0] call BIS_fnc_returnConfigEntry == 0} &&
            {!(_x getVariable ["grad_persistence_isExcluded",false])} &&
            {if (_area isEqualType false) then {true} else {_x inArea _area}}
        ) then {

        _thisStaticHash = [] call CBA_fnc_hashCreate;
        [_thisStaticHash,"type",typeOf _x] call CBA_fnc_hashSet;
        [_thisStaticHash,"posASL",getPosASL _x] call CBA_fnc_hashSet;
        [_thisStaticHash,"vectorDirAndUp",[vectorDir _x, vectorUp _x]] call CBA_fnc_hashSet;
        [_thisStaticHash,"damage",damage _x] call CBA_fnc_hashSet;
        [_thisStaticHash,"isGradFort",!isNil {_x getVariable "grad_fortifications_fortOwner"}] call CBA_fnc_hashSet;

        _staticsData pushBack _thisStaticHash;
    };

    false
} count _statics;

saveProfileNamespace;
