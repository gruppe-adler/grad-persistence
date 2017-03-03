if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_staticsTag = _missionTag + "_statics";
_staticsData = [_staticsTag] call grad_persistence_fnc_getSaveData;
_staticsData resize 0;

_statics = allMissionObjects "Static";

{
    if (typeOf _x != "CBA_NamespaceDummy" && {!(_x getVariable ["grad_persistence_isEditorObject",false])}) then {

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
