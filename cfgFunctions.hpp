#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class GRAD_persistence {
    class common {
        file = MODULES_DIRECTORY\grad-persistence\functions\common;

        class clearMissionData {};
        class generateCountArray {};
        class getMissionTag {};
        class getSaveData {};
        class handleDisconnect {};
        class handleJIP {};
        class initModule {postInit = 1;};
        class showWarningMessage {};
        class tagEditorObjects {};
    };

    class load {
        file = MODULES_DIRECTORY\grad-persistence\functions\load;

        class addBackpacks {};
        class addItems {};
        class addMagazines {};
        class addWeaponItems {};
        class createVehicleCrew {};
        class loadAllPlayers {};
        class loadContainers {};
        class loadGroups {};
        class loadMission {};
        class loadPlayer {};
        class loadStatics {};
        class loadTasks {};
        class loadTeamAccounts {};
        class loadTurretMagazines {};
        class loadVariables {};
        class loadVehicleHits {};
        class loadVehicleInventory {};
        class loadVehicles {};
        class requestLoadPlayer {};
    };

    class save {
        file = MODULES_DIRECTORY\grad-persistence\functions\save;

        class deInstanceTFARRadios {};
        class getInventory {};
        class saveAllPlayers {};
        class saveContainers {};
        class saveGroups {};
        class saveMission {};
        class savePlayer {};
        class saveStatics {};
        class saveTasks {};
        class saveTeamAccounts {};
        class saveVariables {};
        class saveVehicles {};
    };
};
