params ["_items"];

_deInstancedItems = _items apply {
    if ([_x] call acre_api_fnc_isRadio) then {
        _x = [_x] call acre_api_fnc_getBaseRadio;
    };
    _x
};

_deInstancedItems
