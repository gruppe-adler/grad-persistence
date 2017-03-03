params ["_vehicle","_turretMagazines"];

//remove default magazines
{
    _x params ["_magazineClass","_turretPath"];
    _vehicle removeMagazineTurret [_magazineClass,_turretPath];
    false
} count (magazinesAllTurrets _vehicle);

{
    _x params ["_magazineClass","_turretPath","_ammoCount"];
    _vehicle addMagazineTurret [_magazineClass,_turretPath,_ammoCount];
} count _turretMagazines;
