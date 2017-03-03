params ["_vehicle","_side"];

_vehicleConfig = (configFile >> "CfgVehicles" >> typeOf _vehicle);
if (!isClass _vehicleConfig) exitWith {};

_crewType = [_side, _vehicleConfig] call BIS_fnc_selectCrew;
_hasDriver = ([_vehicleConfig,"hasDriver",0] call BIS_fnc_returnConfigEntry) == 1;
_group = createGroup _side;

if (_hasDriver) then {
    _unit = _group createUnit [_crewType, [0,0,0], [], 0, "CAN_COLLIDE"];

    [{!isNull (_this select 0)}, {
        params ["_unit","_vehicle"];
        _unit assignAsDriver _vehicle;
        [_unit] orderGetin true;
        _unit moveInDriver _vehicle;
    }, [_unit,_vehicle]] call CBA_fnc_waitUntilAndExecute;
};

{
    _unit = _group createUnit [_crewType, [0,0,0], [], 0, "CAN_COLLIDE"];

    [{!isNull (_this select 0)}, {
        params ["_unit","_vehicle","_turret"];
        _unit assignAsGunner _vehicle;
        [_unit] orderGetin true;
        _unit moveInTurret [_vehicle, _turret];
    }, [_unit,_vehicle,_x]] call CBA_fnc_waitUntilAndExecute;
} forEach (allTurrets _vehicle);
