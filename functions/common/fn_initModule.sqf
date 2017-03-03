if (isServer) then {
    [] call grad_persistence_fnc_handleJIP;
    [] call grad_persistence_fnc_handleDisconnect;
    [] call grad_persistence_fnc_tagEditorObjects;
};
