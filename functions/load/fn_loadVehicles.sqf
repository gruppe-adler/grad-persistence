#include "script_component.hpp"

if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_vehiclesTag = _missionTag + "_vehicles";
_vehiclesData = [_vehiclesTag] call grad_persistence_fnc_getSaveData;

{

    private _thisVehicleHash = _x;
    private _type = [_thisVehicleHash,"type"] call CBA_fnc_hashGet;
    private _side = [_thisVehicleHash,"side"] call CBA_fnc_hashGet;
    private _hasCrew = [_thisVehicleHash,"hasCrew"] call CBA_fnc_hashGet;

    //idk, weird shit happens when you use createVehicle and add crew
    _thisVehicle = if (!_hasCrew) then {
        createVehicle [_type, [0,0,0], [], 0, "CAN_COLLIDE"]
    } else {
        ([[0,0,0],0,_type,_side] call BIS_fnc_spawnVehicle) select 0
    };

    [{!isNull (_this select 0)}, {
        params ["_thisVehicle","_thisVehicleHash"];

        private _posASL = [_thisVehicleHash,"posASL"] call CBA_fnc_hashGet;
        private _vectorDirAndUp = [_thisVehicleHash,"vectorDirAndUp"] call CBA_fnc_hashGet;
        private _hitPointDamage = [_thisVehicleHash,"hitpointDamage"] call CBA_fnc_hashGet;
        private _turretMagazines = [_thisVehicleHash,"turretMagazines"] call CBA_fnc_hashGet;
        private _inventory = [_thisVehicleHash,"inventory"] call CBA_fnc_hashGet;
        private _isGradFort = [_thisVehicleHash,"isGradFort"] call CBA_fnc_hashGet;

        _thisVehicle setVectorDirAndUp _vectorDirAndUp;
        _thisVehicle setPosASL _posASL;

        [_thisVehicle,_turretMagazines] call grad_persistence_fnc_loadTurretMagazines;
        [_thisVehicle,_hitPointDamage] call grad_persistence_fnc_loadVehicleHits;
        [_thisVehicle,_inventory] call grad_persistence_fnc_loadVehicleInventory;

        if (_isGradFort && {isClass (missionConfigFile >> "CfgFunctions" >> "GRAD_fortifications")}) then {
            [_thisVehicle,objNull] remoteExec ["grad_fortifications_fnc_initFort",0,true];
        };

        private _vars = [_thisVehicleHash,"vars"] call CBA_fnc_hashGet;
        [_vars,_thisVehicle] call FUNC(loadObjectVars);

    }, [_thisVehicle,_thisVehicleHash]] call CBA_fnc_waitUntilAndExecute;

    false
} count _vehiclesData;
