#include "script_component.hpp"

params ["_vars","_object"];

{
    _x params ["_varName","_value","_isPublic"];
    _object setVariable [_varName,_value,_isPublic];
} forEach _vars;
