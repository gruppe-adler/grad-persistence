params ["_tag",["_isHash",false],["_hashDefault",[]]];

private _data = profileNamespace getVariable [_tag,[]];
if (isNil {profileNamespace getVariable _tag}) then {

    _setData = if (_isHash) then {
        [[],_hashDefault] call CBA_fnc_hashCreate
    } else {
        []
    };

    profileNamespace setVariable [_tag,_setData];
    _data = profileNamespace getVariable [_tag,[]];
};


_data
