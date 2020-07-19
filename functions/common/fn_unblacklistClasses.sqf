#include "script_component.hpp"

if (!isServer) exitWith {ERROR("fnc_unblacklistClasses needs to be executed on server.")};
if (isNil QGVAR(blacklist)) exitWith {ERROR("Blacklist has not been initialized. Use fnc_unblacklistClasses after postInit.")};

private _classesToUnBlacklist = _this select {_x isEqualType ""};
_classesToUnBlacklist = _classesToUnBlacklist apply {toLower _x};

GVAR(blacklist) = GVAR(blacklist) select {!(_x in _classesToUnBlacklist)};

publicVariable QGVAR(blacklist);
