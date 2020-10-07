#include "script_component.hpp"

params [["_player",""]];

private _fnc_reply = {
    params [["_message",""]];
    _message remoteExec ["systemChat",remoteExecutedOwner,false];
};

private _playerUnit = _player call BIS_fnc_getUnitByUID;
private _name = "";
if (isNull _playerUnit) then {
    {
        _name = _x getVariable ["ACE_name",name _x];
        if (toLower _name == toLower _player) exitWith {
            _playerUnit = _x;
        };
    } forEach allPlayers;
} else {
    _name = _playerUnit getVariable ["ACE_name",name _playerUnit];
};

if (isNull _playerUnit) exitWith {
    (format ["Player %1 not found.",_player]) call _fnc_reply;
};

if (!alive _playerUnit) exitWith {
    (format ["Player %1 is dead and was not loaded.",_player]) call _fnc_reply;
};

(format ["Loading player %1...",_name]) call _fnc_reply;

[_playerUnit] call FUNC(loadPlayer);
