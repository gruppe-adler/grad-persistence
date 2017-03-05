#define PREFIX grad
#define COMPONENT persistence
#include "\x\cba\addons\main\script_macros_mission.hpp"

if (!isServer) exitWith {};

private _fnc_onPlayerConnected = {
    params ["_id","_uid","_name","_didJIP"];

    if (!_didJIP) exitWith {};
    if (_uid == "") exitWith {ERROR_1("Player %1 does not have a UID!?",_name)};

    _waitCondition = [missionConfigFile >> "CfgGradPersistence", "missionWaitCondition", ""] call BIS_fnc_returnConfigEntry;
    if (_waitCondition == "") then {_waitCondition = "true"};
    [{!isNull ([_this select 0] call BIS_fnc_getUnitByUID) && {call compile (_this select 1)}}, {
        params ["_uid","_waitCondition"];

        _unit = [_uid] call BIS_fnc_getUnitByUID;
        if !(_unit isKindOf "Man") exitWith {};

        _savePlayerInventory = ([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerDamage = ([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerPosition = ([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerMoney = ([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 1] call BIS_fnc_returnConfigEntry) == 1;

        if (_savePlayerInventory || _savePlayerDamage || _savePlayerPosition || _savePlayerMoney) then {
            INFO_1("Loading JIP player %1",name _unit);
            [_unit,_savePlayerInventory,_savePlayerDamage,_savePlayerPosition,_savePlayerMoney] call grad_persistence_fnc_loadPlayer;
        };
    }, [_uid,_waitCondition]] call CBA_fnc_waitUntilAndExecute;
};

addMissionEventhandler ["PlayerConnected",_fnc_onPlayerConnected];
