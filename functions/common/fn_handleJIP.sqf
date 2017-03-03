#define PREFIX grad
#define COMPONENT persistence
#include "\x\cba\addons\main\script_macros_mission.hpp"

if (!isServer) exitWith {};

private _fnc_onPlayerConnected = {
    params ["_id","_uid","_name","_didJIP"];

    if (!_didJIP) exitWith {};
    if (_uid == "") exitWith {ERROR_1("Player %1 does not have a UID!?",_name)};

    [{!isNull ([_this] call BIS_fnc_getUnitByUID)}, {

        _unit = [_this] call BIS_fnc_getUnitByUID;
        if !(_unit isKindOf "Man") exitWith {};

        _savePlayerInventory = ([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerDamage = ([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerPosition = ([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerMoney = ([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 1] call BIS_fnc_returnConfigEntry) == 1;

        if (_savePlayerInventory || _savePlayerDamage || _savePlayerPosition || _savePlayerMoney) then {
            INFO_1("Loading JIP player %1",name _unit);
            [_unit,_savePlayerInventory,_savePlayerDamage,_savePlayerPosition,_savePlayerMoney] call grad_persistence_fnc_loadPlayer;
        };
    }, _uid] call CBA_fnc_waitUntilAndExecute;
};

addMissionEventhandler ["PlayerConnected",_fnc_onPlayerConnected];
