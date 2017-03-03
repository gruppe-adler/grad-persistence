#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class GRAD_persistence {
    class common {
        file = MODULES_DIRECTORY\grad-persistence\functions\common;

        class clearMissionData {};
        class getMissionTag {};
        class getSaveData {};
    };

    class load {
        file = MODULES_DIRECTORY\grad-persistence\functions\load;

        class createVehicleCrew {};
        class loadGroups {};
        class loadMission {};
        class loadVehicles {};
    };

    class save {
        file = MODULES_DIRECTORY\grad-persistence\functions\save;

        class saveGroups {};
        class saveMission {};
        class saveVehicles {};
    };
};
