#define PREFIX grad
#define COMPONENT persistence
#include "\x\cba\addons\main\script_macros_mission.hpp"

if (!isServer) exitWith {};

private _fnc_onDisconnect = {
        params ["_unit","_id","_uid","_name"];

        _savePlayerInventory = ([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerDamage = ([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerPosition = ([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1;
        _savePlayerMoney = ([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 0] call BIS_fnc_returnConfigEntry) == 1;

        if (!_savePlayerMoney && {!_savePlayerDamage} && {!_savePlayerPosition} && {!_savePlayerMoney}) exitWith {false};

        if !(missionNamespace getVariable [QGVAR(thisMissionCleared),false]) then {
            INFO_1("Player %1 disconnected. Saving data.", _name);
            [_unit,true,_savePlayerInventory,_savePlayerDamage,_savePlayerPosition,_savePlayerMoney,_uid] call grad_persistence_fnc_savePlayer;
        };

        [{
            params ["_unit","_name"];
            INFO_1("Deleting %1s unit.",_name);
            deleteVehicle _unit;
        }, [_unit,_name], 1] call CBA_fnc_waitAndExecute;

        true
};

addMissionEventHandler ["HandleDisconnect",_fnc_onDisconnect];
