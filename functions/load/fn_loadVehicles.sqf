#include "script_component.hpp"

if (!isServer) exitWith {};

private _missionTag = [] call grad_persistence_fnc_getMissionTag;
private _vehiclesTag = _missionTag + "_vehicles";
private _vehiclesData = [_vehiclesTag] call grad_persistence_fnc_getSaveData;

{

    private _thisVehicleHash = _x;
    private _type = [_thisVehicleHash,"type"] call CBA_fnc_hashGet;
    private _side = [_thisVehicleHash,"side"] call CBA_fnc_hashGet;
    private _hasCrew = [_thisVehicleHash,"hasCrew"] call CBA_fnc_hashGet;
    private _vehVarName = [_thisVehicleHash,"varName"] call CBA_fnc_hashGet;

    private _thisVehicle = objNull;
    private _editorVehicleFound = false;
    if (!isNil "_vehVarName") then {
        // editor-placed object that already exists
        private _editorVehicle = call compile _vehVarName;
        if (!isNil "_editorVehicle") then {
            if (_editorVehicle isEqualType objNull) then {
                _thisVehicle = _editorVehicle;
                _editorVehicleFound = true;
            } else {
                ERROR_1("Vehicle varName %1 resolved to %2 (not type OBJECT). Spawning new vehicle instead.", _vehVarName, _editorVehicle);
            };
        };
    };

    if (!_editorVehicleFound) then {
        //idk, weird shit happens when you use createVehicle and add crew
        _thisVehicle = if (!_hasCrew) then {
            createVehicle [_type, [0,0,0], [], 0, "CAN_COLLIDE"]
        } else {
            ([[0,0,0],0,_type,_side] call BIS_fnc_spawnVehicle) param [0, objNull, [objNull]]
        };

        if (!isNil "_vehVarName") then {
            [_thisVehicle,_vehVarName] remoteExec ["setVehicleVarName",0,_thisVehicle];
            missionNamespace setVariable [_vehVarName,_thisVehicle,true];
        };

    };

    [{!isNull (_this select 0)}, {
        params ["_thisVehicle","_thisVehicleHash"];

        private _posASL = [_thisVehicleHash,"posASL"] call CBA_fnc_hashGet;
        private _fuel = [_thisVehicleHash,"fuel"] call CBA_fnc_hashGet;
        private _vectorDirAndUp = [_thisVehicleHash,"vectorDirAndUp"] call CBA_fnc_hashGet;
        private _hitPointDamage = [_thisVehicleHash,"hitpointDamage"] call CBA_fnc_hashGet;
        private _turretMagazines = [_thisVehicleHash,"turretMagazines"] call CBA_fnc_hashGet;
        private _inventory = [_thisVehicleHash,"inventory"] call CBA_fnc_hashGet;
        private _isGradFort = [_thisVehicleHash,"isGradFort"] call CBA_fnc_hashGet;

        _thisVehicle setVectorDirAndUp _vectorDirAndUp;
        _thisVehicle setPosASL _posASL;
        _thisVehicle setFuel _fuel;

        [_thisVehicle,_turretMagazines] call grad_persistence_fnc_loadTurretMagazines;
        [_thisVehicle,_hitPointDamage] call grad_persistence_fnc_loadVehicleHits;
        [_thisVehicle,_inventory] call grad_persistence_fnc_loadVehicleInventory;

        if (_isGradFort && {isClass (missionConfigFile >> "CfgFunctions" >> "GRAD_fortifications")}) then {
            [_thisVehicle,objNull] remoteExec ["grad_fortifications_fnc_initFort",0,true];
        };

        private _vars = [_thisVehicleHash,"vars"] call CBA_fnc_hashGet;
        [_vars,_thisVehicle] call FUNC(loadObjectVars);

    }, [_thisVehicle,_thisVehicleHash], 10, {ERROR_1("Vehicle nullcheck timeout. Vehiclehash: %1",_this select 1)}] call CBA_fnc_waitUntilAndExecute;


} forEach _vehiclesData;

// delete all editor vehicles that were killed in a previous save
private _killedVarnames = [_missionTag + "_killedVarnames"] call FUNC(getSaveData);
private _killedVehiclesVarnames = _killedVarnames param [1,[]];
{
    private _editorVehicle = call compile _x;
    if (!isNil "_editorVehicle") then {deleteVehicle _editorVehicle};
} forEach _killedVehiclesVarnames;
