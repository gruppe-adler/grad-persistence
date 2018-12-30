#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call FUNC(getMissionTag);
private _triggersTag = _missionTag + "_triggers";
private _triggersData = [_triggersTag] call FUNC(getSaveData);

private _reExecute = ([missionConfigFile >> "CfgGradPersistence", "saveTriggers", 0] call BIS_fnc_returnConfigEntry) == 2;

{
    private _thisTriggerHash = _x;
    private _vehVarName = [_thisTriggerHash,"varName"] call CBA_fnc_hashGet;

    private _thisTrigger = objNull;
    private _editorVehicleFound = false;
    if (!isNil "_vehVarName") then {
        // editor-placed object that already exists
        private _editorVehicle = call compile _vehVarName;
        if (!isNil "_editorVehicle") then {
            _thisTrigger = _editorVehicle;
            _editorVehicleFound = true;
        };
    };

    if (!_editorVehicleFound) then {
        _thisTrigger = createTrigger ["EmptyDetector",[0,0,0]];

        if (!isNil "_vehVarName") then {
            [_thisTrigger,_vehVarName] remoteExec ["setVehicleVarName",0,_thisTrigger];
        };
    };



    [{!isNull (_this select 0)}, {
        params ["_thisTrigger","_thisTriggerHash","_reExecute"];

        private _posASL = [_thisTriggerHash,"posASL"] call CBA_fnc_hashGet;
        private _activated = [_thisTriggerHash,"activated"] call CBA_fnc_hashGet;
        private _activation = [_thisTriggerHash,"activation"] call CBA_fnc_hashGet;
        private _area = [_thisTriggerHash,"area"] call CBA_fnc_hashGet;
        private _statements = [_thisTriggerHash,"statements"] call CBA_fnc_hashGet;
        private _timeout = [_thisTriggerHash,"timeout"] call CBA_fnc_hashGet;
        private _text = [_thisTriggerHash,"text"] call CBA_fnc_hashGet;
        private _type = [_thisTriggerHash,"type"] call CBA_fnc_hashGet;
        private _triggerReExecute = [_thisTriggerHash,"reExecute"] call CBA_fnc_hashGet;

        _thisTrigger setPosASL _posASL;
        _thisTrigger setTriggerArea _area;
        _thisTrigger setTriggerText _text;
        _thisTrigger setTriggerType _type;
        _thisTrigger setTriggerActivation _activation;

        if (_activated) then {
            if (
                (!isNil "_triggerReExecute" && {_triggerReExecute}) ||
                {isNil "_triggerReExecute" && {_reExecute}}
            ) then {
                _thisTrigger setTriggerStatements ["true",_statements select 1,_statements select 2];
            } else {
                _thisTrigger setTriggerStatements ["true","true","true"];
            };

            [{triggerActivated (_this select 0)},{
                params ["_thisTrigger","_statements","_timeout"];
                _thisTrigger setTriggerStatements _statements;
                _thisTrigger setTriggerTimeout _timeout;

            },[_thisTrigger,_statements,_timeout]] call CBA_fnc_waitUntilAndExecute;
        } else {
            _thisTrigger setTriggerStatements _statements;
            _thisTrigger setTriggerTimeout _timeout;
        };

        private _vars = [_thisTriggerHash,"vars"] call CBA_fnc_hashGet;
        [_vars,_thisTrigger] call FUNC(loadObjectVars);

    }, [_thisTrigger,_thisTriggerHash,_reExecute]] call CBA_fnc_waitUntilAndExecute;
} forEach _triggersData;
