params ["_items"];

_deInstancedItems = _items apply {
    if (_x isKindOf ["ItemRadio", configFile >> "CfgWeapons"]) then {
        [configFile >> "CfgWeapons" >> _x >> "tf_parent", "text", _x] call CBA_fnc_getConfigEntry;
    } else {
        _x
    }
};

_deInstancedItems
