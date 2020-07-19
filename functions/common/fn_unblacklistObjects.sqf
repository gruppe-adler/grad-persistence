#include "script_component.hpp"

if (!isServer) exitWith {ERROR("fnc_unblacklistObjects needs to be executed on server.")};

private _objectsToUnblacklist = _this select {_x isEqualType objNull};

{
    // do not change variable name here for backwards compatibility
    _x setVariable [QGVAR(isExcluded),false,true];
} forEach _objectsToUnblacklist;
