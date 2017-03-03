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
    };

    class load {
        file = MODULES_DIRECTORY\grad-persistence\functions\load;

        class addBackpacks {};
        class addItems {};
        class addMagazines {};
        class addWeaponItems {};
        class createVehicleCrew {};
        class loadGroups {};
        class loadMission {};
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
        class saveGroups {};
        class saveMission {};
        class saveStatics {};
        class saveVehicles {};
    };
};
