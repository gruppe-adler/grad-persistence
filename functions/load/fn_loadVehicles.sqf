if (!isServer) exitWith {};

_missionTag = [] call grad_persistence_fnc_getMissionTag;
_vehiclesTag = _missionTag + "_vehicles";
_vehiclesData = [_vehiclesTag] call grad_persistence_fnc_getSaveData;

{

    _thisVehicleHash = _x;
    _type = [_thisVehicleHash,"type"] call CBA_fnc_hashGet;
    _side = [_thisVehicleHash,"side"] call CBA_fnc_hashGet;
    _hasCrew = [_thisVehicleHash,"hasCrew"] call CBA_fnc_hashGet;

    //idk, weird shit happens when you use createVehicle and add crew
    _thisVehicle = if (!_hasCrew) then {
        createVehicle [_type, [0,0,0], [], 0, "CAN_COLLIDE"]
    } else {
        ([[0,0,0],0,_type,_side] call BIS_fnc_spawnVehicle) select 0
    };

    [{!isNull (_this select 0)}, {
        params ["_thisVehicle","_thisVehicleHash"];

        _posASL = [_thisVehicleHash,"posASL"] call CBA_fnc_hashGet;
        _vectorDirAndUp = [_thisVehicleHash,"vectorDirAndUp"] call CBA_fnc_hashGet;
        _hitPointDamage = [_thisVehicleHash,"hitpointDamage"] call CBA_fnc_hashGet;
        
        _thisVehicle setVectorDirAndUp _vectorDirAndUp;
        _thisVehicle setPosASL _posASL;

        _hitPointDamage params ["_hitNames","_hitDamages"];
        {
            _thisVehicle setHitPointDamage [_x,_hitDamages select _forEachIndex];
            /*_thisVehicle setHitPointDamage [_x,_hitDamages select _forEachIndex,false];*/   //use this in arma 1.67
        } forEach _hitNames;
    }, [_thisVehicle,_thisVehicleHash]] call CBA_fnc_waitUntilAndExecute;

    false
} count _vehiclesData;
