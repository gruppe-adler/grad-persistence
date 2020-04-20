#include "script_component.hpp"

params [["_classnameOrObject",objNull]];

private _isBlacklisted = false;

if (_classnameOrObject isEqualType objNull) then {
    _isBlacklisted = _classnameOrObject getVariable [QGVAR(isExcluded),(toLower typeOf _classnameOrObject) in GVAR(blacklist)];
} else {
    _isBlacklisted = _classnameOrObject in GVAR(blacklist);
};

_isBlacklisted
