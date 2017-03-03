params ["_vehicle","_hitPointDamage"];
_hitPointDamage params ["_hitNames","_hitDamages"];

{
    _thisVehicle setHitPointDamage [_x,_hitDamages select _forEachIndex];
    /*_thisVehicle setHitPointDamage [_x,_hitDamages select _forEachIndex,false];*/   //use this in arma 1.67
} forEach _hitNames;
