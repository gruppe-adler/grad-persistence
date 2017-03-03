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
        class handleJIP {postInit = 1;};
    };

    class load {
        file = MODULES_DIRECTORY\grad-persistence\functions\load;

        class addBackpacks {};
        class addItems {};
        class addMagazines {};
        class addWeaponItems {};
        class createVehicleCrew {};
        class loadAllPlayers {};
        class loadGroups {};
        class loadMission {};
        class loadPlayer {};
        class loadStatics {};
        class loadTurretMagazines {};
        class loadVehicleHits {};
        class loadVehicleInventory {};
        class loadVehicles {};
    };

    class save {
        file = MODULES_DIRECTORY\grad-persistence\functions\save;

        class deInstanceTFARRadios {};
        class getInventory {};
        class saveAllPlayers {};
        class saveGroups {};
        class saveMission {};
        class savePlayer {};
        class saveStatics {};
        class saveVehicles {};
    };
};
