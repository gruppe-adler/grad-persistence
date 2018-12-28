#include "script_component.hpp"

private _playerWaitCondition = [missionConfigFile >> "CfgGradPersistence", "playerWaitCondition", ""] call BIS_fnc_returnConfigEntry;
if (_playerWaitCondition == "") then {_playerWaitCondition = "true"};

private _fnc_waitUntil = {
    _unit = ((_this select 0) select 0);
    !isNull _unit &&
    {[_unit,side _unit,typeOf _unit,roleDescription _unit] call compile (_this select 1)}
};

[_fnc_waitUntil, {
    params ["_args","_playerWaitCondition"];
    _args params [
        "_unit",
        ["_savePlayerInventory",([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1],
        ["_savePlayerDamage",([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1],
        ["_savePlayerPosition",([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1],
        ["_savePlayerMoney",([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 1] call BIS_fnc_returnConfigEntry) == 1]
    ];

    private _missionTag = [] call FUNC(getMissionTag);
    private _playersTag = _missionTag + "_players";
    private _playersDataHash = [_playersTag,true,false] call FUNC(getSaveData);

    private _uid = getPlayerUID _unit;
    if (_uid == "") exitWith {ERROR_1("UID for player %1 not found.",name _unit)};

    private _unitDataHash = [_playersDataHash,_uid] call CBA_fnc_hashGet;
    if (_unitDataHash isEqualType false) exitWith {INFO_1("Data for player %1 not found.",name _unit)};

    if (_savePlayerInventory) then {
        private _unitLoadout = [_unitDataHash,"inventory"] call CBA_fnc_hashGet;
        if !(_unitLoadout isEqualType false) then {
            _unit setUnitLoadout [_unitLoadout,false];
        };
    };

    if (_savePlayerDamage) then {
        private _unitHits = [_unitDataHash,"damage"] call CBA_fnc_hashGet;
        if (!(_unitHits isEqualType false) && {count _unitHits > 0}) then {
            _unitHits params ["_unitHitNames","_unitHitDamages"];
            {
                _unit setHit [_x,_unitHitDamages select _forEachIndex];
            } forEach _unitHitNames;
        };
    };

    if (_savePlayerPosition) then {
        private _unitPosASL = [_unitDataHash,"posASL"] call CBA_fnc_hashGet;
        private _unitDir = [_unitDataHash,"dir"] call CBA_fnc_hashGet;

        if (!(_unitPosASL isEqualType false) && !(_unitDir isEqualType false)) then {
            _unit setPosASL _unitPosASL;
            _unit setDir _unitDir;
        };
    };

    if (_savePlayerMoney) then {
        private _unitMoney = [_unitDataHash,"money"] call CBA_fnc_hashGet;
        if !(_unitMoney isEqualType false) then {
            _unit setVariable ["grad_lbm_myFunds",_unitMoney,true];
        };

        private _unitBankMoney = [_unitDataHash,"bankMoney"] call CBA_fnc_hashGet;
        if !(_unitBankMoney isEqualType false) then {
            _unit setVariable ["grad_moneymenu_myBankBalance",_unitBankMoney,true];
        };
    };

    private _vars = [_unitDataHash,"vars"] call CBA_fnc_hashGet;
    [_vars,_unit] call FUNC(loadObjectVars);

}, [_this,_playerWaitCondition]] call CBA_fnc_waitUntilAndExecute;
