#include "script_component.hpp"

if (!isServer) exitWith {ERROR("fnc_blacklistClasses needs to be executed on server.")};

private _classesToBlacklist = _this select {_x isEqualType ""};
_classesToBlacklist = _classesToBlacklist apply {toLower _x};

if (isNil QGVAR(blacklist)) then {
    GVAR(blacklist) = _classesToBlacklist
} else {
    GVAR(blacklist) append _classesToBlacklist
};

publicVariable QGVAR(blacklist);
