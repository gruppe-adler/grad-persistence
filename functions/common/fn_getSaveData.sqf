params ["_tag"];

_data = profileNamespace getVariable [_tag,[]];
if (isNil {profileNamespace getVariable _tag}) then {
    profileNamespace setVariable [_tag,[]];
    saveProfileNamespace;
    _data = profileNamespace getVariable [_tag,[]];
};

_data
