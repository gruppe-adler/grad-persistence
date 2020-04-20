#include "script_component.hpp"

if (!isServer) exitWith {ERROR("fnc_blacklistObjects needs to be executed on server.")};

private _objectsToBlacklist = _this select {_x isEqualType objNull};

{
    // do not change variable name here for backwards compatibility
    _x setVariable [QGVAR(isExcluded),true,true];
} forEach _objectsToBlacklist;
