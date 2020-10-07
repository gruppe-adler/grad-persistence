#include "script_component.hpp"

["gradpersistenceSave", {
    [true, 10] remoteExec ["grad_persistence_fnc_saveMission",2,false];
}, "adminLogged"] call CBA_fnc_registerChatCommand;

["gradpersistenceLoad", {
    [] remoteExec ["grad_persistence_fnc_loadMission",2,false];
}, "adminLogged"] call CBA_fnc_registerChatCommand;

["gradpersistenceLoadPlayers", {
    [] remoteExec ["grad_persistence_fnc_loadAllPlayers",2,false];
}, "adminLogged"] call CBA_fnc_registerChatCommand;

["gradpersistenceLoadPlayer", {
    params [["_player",""]];
    if (_player == "") exitWith {
        systemChat "Use '#gradPersistenceLoadPlayer <name>' or '#gradPersistenceLoadPlayer <UID>'";
    };
    _this remoteExecCall ["grad_persistence_fnc_loadPlayerChatcommandServer",2,false];
}, "adminLogged"] call CBA_fnc_registerChatCommand;

if (isServer) then {

    // server side player loading disabled in favor of player side load request
    /* [] call grad_persistence_fnc_handleJIP; */

    [] call grad_persistence_fnc_handleDisconnect;
    [] call grad_persistence_fnc_tagEditorObjects;

    if ([missionConfigFile >> "CfgGradPersistence", "loadOnMissionStart", 0] call BIS_fnc_returnConfigEntry == 1) then {
        _waitCondition = [missionConfigFile >> "CfgGradPersistence", "missionWaitCondition", ""] call BIS_fnc_returnConfigEntry;
        if (_waitCondition == "") then {_waitCondition = "true"};
        [{call compile _this}, {[] call grad_persistence_fnc_loadMission}, _waitCondition] call CBA_fnc_waitUntilAndExecute;
    };

    private _blacklistFromConfig = [missionConfigFile >> "CfgGradPersistence","blacklist",[]] call BIS_fnc_returnConfigEntry;
    if (isNil QGVAR(blacklist)) then {GVAR(blacklist) = _blacklistFromConfig} else {GVAR(blacklist) append _blacklistFromConfig};
    GVAR(blacklist) = GVAR(blacklist) apply {toLower _x};
};

if (hasInterface) then {
    if ([missionConfigFile >> "CfgGradPersistence", "loadOnMissionStart", 0] call BIS_fnc_returnConfigEntry == 1) then {
        _waitCondition = [missionConfigFile >> "CfgGradPersistence", "missionWaitCondition", ""] call BIS_fnc_returnConfigEntry;
        if (_waitCondition == "") then {_waitCondition = "true"};
        [{call compile _this}, {[] call grad_persistence_fnc_requestLoadPlayer}, _waitCondition] call CBA_fnc_waitUntilAndExecute;
    };
};


GVAR(acreLoaded) = isClass (configfile >> "CfgPatches" >> "acre_api");
GVAR(tfarLoaded) = isClass (configfile >> "CfgPatches" >> "tfar_core");
