params ["_weaponData","_container"];

{
    _x params ["_weaponClassName","_muzzle","_light","_optic","_magazineArray"];
    _container addWeaponCargoGlobal [[_weaponClassName] call BIS_fnc_baseWeapon, 1];
    if (_muzzle != "") then {_container addItemCargoGlobal [_muzzle, 1]};
    if (_light != "") then {_container addItemCargoGlobal [_light, 1]};
    if (_optic != "") then {_container addItemCargoGlobal [_optic, 1]};
    if (count _magazineArray > 1) then {_container addMagazine _magazineArray};

    //these might be magazines or bipods or nonexistant
    if (count _x > 5) then {
        _something = _x select 5;
        if (_something isEqualType []) then {
            if (count _something > 1) then {_container addMagazine _something};
        } else {
            if (_something != "") then {_container addItemCargoGlobal [_something,1]};
        };
    };

    if (count _x > 6) then {
        _something = _x select 6;
        if (_something isEqualType []) then {
            if (count _something > 1) then {_container addMagazine _something};
        } else {
            if (_something != "") then {_container addItemCargoGlobal [_something,1]};
        };
    };
} count _weaponData;
