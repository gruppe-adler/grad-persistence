["savemission", {
    [true, 10] remoteExec ["grad_persistence_fnc_saveMission",2,false];
}, "adminLogged"] call CBA_fnc_registerChatCommand;

if (isServer) then {
    [] call grad_persistence_fnc_handleJIP;
    [] call grad_persistence_fnc_handleDisconnect;
    [] call grad_persistence_fnc_tagEditorObjects;

    if ([missionConfigFile >> "CfgGradPersistence", "loadOnMissionStart", 0] call BIS_fnc_returnConfigEntry == 1) then {
        _waitCondition = [missionConfigFile >> "CfgGradPersistence", "missionWaitCondition", ""] call BIS_fnc_returnConfigEntry;
        if (_waitCondition == "") then {_waitCondition = "true"};
        [{call compile _this}, {[] call grad_persistence_fnc_loadMission}, _waitCondition] call CBA_fnc_waitUntilAndExecute;
    };
};
