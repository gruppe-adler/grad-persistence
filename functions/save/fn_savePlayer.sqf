#include "script_component.hpp"

params [
    "_unit",
    ["_save",false],
    ["_savePlayerInventory",([missionConfigFile >> "CfgGradPersistence", "savePlayerInventory", 1] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerDamage",([missionConfigFile >> "CfgGradPersistence", "savePlayerDamage", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerPosition",([missionConfigFile >> "CfgGradPersistence", "savePlayerPosition", 0] call BIS_fnc_returnConfigEntry) == 1],
    ["_savePlayerMoney",([missionConfigFile >> "CfgGradPersistence", "savePlayerMoney", 0] call BIS_fnc_returnConfigEntry) == 1],
    "_uid",
    "_allPlayerVariableClasses"
];


if (!isServer) exitWith {};
if (_unit getVariable [QGVAR(isExcluded),false]) exitWith {};

if (isNil "_allPlayerVariableClasses") then {
    private _allVariableClasses = "true" configClasses (missionConfigFile >> "CfgGradPersistence" >> "customVariables");
    _allPlayerVariableClasses = _allVariableClasses select {
        ([_x,"varNamespace",""] call BIS_fnc_returnConfigEntry) == "player"
    };
};

private _missionTag = [] call FUNC(getMissionTag);
private _playersTag = _missionTag + "_players";
private _playersDataHash = [_playersTag,true,false] call FUNC(getSaveData);

if (isNil "_uid") then {
    _uid = getPlayerUID _unit;
};
if (_uid == "") exitWith {};

private _unitDataHash = [[],false] call CBA_fnc_hashCreate;

if (_savePlayerInventory) then {

    private _loadout = getUnitLoadout _unit;
    if ((count _loadout) == 0) exitWith {ERROR_1("Unit %1: no loadout array.",_unit)};

    if (GVAR(acreLoaded)) then {
        // on release of ACRE2 v2.7.3 replace with:
        // _loadout = [_loadout] call acre_api_fnc_filterUnitLoadout;

        if ((_loadout select 9) select 2 == "ItemRadioAcreFlagged") then {
            (_loadout select 9) set [2,""];
        };

        private _fnc_replaceRadioAcre = {
            params ["_item"];
            if (!(_item isEqualType []) && {[_item] call acre_api_fnc_isRadio}) then {
                _this set [0, [_item] call acre_api_fnc_getBaseRadio];
            };
        };
        if !((_loadout select 3) isEqualTo []) then {
            {_x call _fnc_replaceRadioAcre} forEach ((_loadout select 3) select 1);
        };
        if !((_loadout select 4) isEqualTo []) then {
            {_x call _fnc_replaceRadioAcre} forEach ((_loadout select 4) select 1);
        };
        if !((_loadout select 5) isEqualTo []) then {
            {_x call _fnc_replaceRadioAcre} forEach ((_loadout select 5) select 1);
        };
    };

    if (GVAR(tfarLoaded)) then {
        private _assignedRadio = (_loadout select 9) select 2;
        if (_assignedRadio call TFAR_fnc_isRadio) then {
            (_loadout select 9) set [2,[configFile >> "CfgWeapons" >> _assignedRadio >> "tf_parent", "text", _assignedRadio] call CBA_fnc_getConfigEntry];
        };

        private _fnc_replaceRadioTfar = {
            params ["_item"];
            if (!(_item isEqualType []) && {_item call TFAR_fnc_isRadio}) then {
                diag_log ["ASDASD replaced item:",_item," with: ",[configFile >> "CfgWeapons" >> _item >> "tf_parent", "text", _item] call CBA_fnc_getConfigEntry];
                _this set [0,[configFile >> "CfgWeapons" >> _item >> "tf_parent", "text", _item] call CBA_fnc_getConfigEntry];
            };
        };
        if !((_loadout select 3) isEqualTo []) then {
            {_x call _fnc_replaceRadioTfar} forEach ((_loadout select 3) select 1);
        };
        if !((_loadout select 4) isEqualTo []) then {
            {_x call _fnc_replaceRadioTfar} forEach ((_loadout select 4) select 1);
        };
        if !((_loadout select 5) isEqualTo []) then {
            {_x call _fnc_replaceRadioTfar} forEach ((_loadout select 5) select 1);
        };
    };

    [_unitDataHash, "inventory", _loadout] call CBA_fnc_hashSet;
};

if (_savePlayerDamage) then {
    private _allHitPointsDamage = getAllHitPointsDamage _unit;
    private _damage = if (count _allHitPointsDamage > 2) then {
        [_allHitPointsDamage select 0,_allHitPointsDamage select 2]
    } else {
        [[],[]]
    };
    [_unitDataHash,"damage",_damage] call CBA_fnc_hashSet;
};

if (_savePlayerPosition) then {
    [_unitDataHash,"posASL",getPosASL _unit] call CBA_fnc_hashSet;
    [_unitDataHash,"dir",getDir _unit] call CBA_fnc_hashSet;
};

if (_savePlayerMoney) then {
    [_unitDataHash,"money",_unit getVariable ["grad_lbm_myFunds",0]] call CBA_fnc_hashSet;
    [_unitDataHash,"bankMoney",_unit getVariable ["grad_moneymenu_myBankBalance",0]] call CBA_fnc_hashSet;
};

private _thisUnitVars = [_allPlayerVariableClasses,_unit] call FUNC(saveObjectVars);
[_unitDataHash,"vars",_thisUnitVars] call CBA_fnc_hashSet;

[_playersDataHash,_uid,_unitDataHash] call CBA_fnc_hashSet;

if (_save) then {
    saveProfileNamespace;
};
