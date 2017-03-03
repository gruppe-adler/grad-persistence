# GRAD Persistence

Enables you to:

* AI units
* vehicles
* static objects (including grad-fortifications)
* player equipment, inventory and health
* player money (needs grad-listBuymenu or grad-moneyMenu)

Limitations:

* magazines stored in containers refill
* weapon attachments on weapons in containers get removed from the weapon, but added to container cargo
* grad-fortifications owners are lost (--> you won't be able to pack up persistence after loading - demolition works though)

GRAD Persistence is multiplayer and JIP proof.


### Table of Contents
<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:0 orderedList:0 -->

- [Dependencies](#dependencies)
- [Installation](#installation)
	- [Manually](#manually)
	- [Via `npm`](#via-npm)
- [Configuration](#configuration)
- [Usage](#usage)
	- [grad_persistence_fnc_saveMission](#gradpersistencefncsavemission)
	- [grad_persistence_fnc_loadMission](#gradpersistencefncloadmission)
	- [grad_persistence_fnc_saveGroups](#gradpersistencefncsavegroups)
	- [grad_persistence_fnc_saveVehicles](#gradpersistencefncsavevehicles)
	- [grad_persistence_fnc_saveStatics](#gradpersistencefncsavestatics)
	- [grad_persistence_fnc_savePlayer](#gradpersistencefncsaveplayer)

<!-- /TOC -->

#### Dependencies
* [CBA_A3](https://github.com/CBATeam/CBA_A3)

# Installation
## Manually
1. Create a folder in your mission root folder and name it `modules`. Then create one inside there and call it `grad-persistence`.
2. Download the contents of this repository ( there's a download link at the side ) and put it into the directory you just created.
3. Append the following lines of code to the `description.ext`:

```sqf
class CfgFunctions {
    #include "modules\grad-persistence\cfgFunctions.hpp"
};
```

## Via `npm`
_for details about what npm is and how to use it, look it up on [npmjs.com](https://www.npmjs.com/)_

1. Install package `grad-persistence` : `npm install --save grad-persistence`
2. Append the following lines of code to the `description.ext`:

```sqf
#define MODULES_DIRECTORY node_modules

class CfgFunctions {
    #include "node_modules\grad-persistence\cfgFunctions.hpp"
};
```

# Configuration
You can configure this module in your `description.ext`. This is entirely optional however, since every setting has a default value.

Add the class `CfgGradPersistence` to your `description.ext`, then add any of these attributes to configure the module:

Attribute           | Default Value | Explanation
--------------------|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
missionTag          | missionName   | The tag that everything in this mission will be saved under. Two missions with the same tag on the same terrain overwrite each other. One mission can load the data of a different mission, if they are both saved under the same tag.
saveUnits           | 1             | Toggles saving of AI units. 0 to disable, 1 to save only units that were not placed in the editor, 2 to save all units
saveVehicles        | 1             | Toggles saving of vehicles, static weapons, containers (i.e. ammoboxes), certain objects. 0,1,2 same as `saveUnits`
saveStatics         | 1             | Toggles saving of static objects such as houses, walls, trees, etc. 0,1,2 same as `saveUnits`
savePlayerInventory | 1             | Toggles saving of player inventories. 0 to disable, 1 to enable.
savePlayerDamage    | 1             | Toggles saving of player health. 0 to disable, 1 to enable.
savePlayerPosition  | 1             | Toggles saving of player position. 0 to disable, 1 to enable.
savePlayerMoney     | 1             | Toggles saving of player money. Needs [GRAD ListBuymenu](https://github.com/gruppe-adler/grad-listBuymenu) or [GRAD Moneymenu](https://github.com/gruppe-adler/grad-moneyMenu)

Example:

```sqf
class CfgGradPersistence {
    missionTag = "my_persistent_mission";
    saveUnits = 2;
    saveVehicles = 0;
    saveStatics = 1;
    savePlayerInventory = 1;
    savePlayerDamage = 0;
    savePlayerPosition = 0;
    savePlayerMoney = 1;
};
```

# Usage
There are only two essential functions that you need to use. JIP players are handled automatically.

## grad_persistence_fnc_saveMission
Saves the current mission according to configuration. Has to be executed on server. Optionally shows a warning message before saving, so that players can leave their vehicles. (Players that are inside vehicles during saving will spawn dismounted, but inside the vehicle object.)

Syntax:  
`[showWarning, waitTime] call grad_persistence_fnc_saveMission`

Parameters:  
* showWarning (optional): Bool - Show warning message before saving (default: false)  
* waitTime (optional): Number - If warning message is shown, time in seconds before actual save happens (default: 10)

Example:  
`[true,30] call grad_persistence_fnc_saveMission`

## grad_persistence_fnc_loadMission
Loads the mission that was saved under the `missionTag` defined in `CfgGradPersistence`. Has to be executed on server.

Syntax:  
`[] call grad_persistence_fnc_loadMission`

## grad_persistence_fnc_saveGroups
In case you want to save specifically the AI units, you can use this (already included in grad_persistence_fnc_saveMission). Has to be executed on server.

Syntax:  
`[] call grad_persistence_fnc_saveGroups`

## grad_persistence_fnc_saveVehicles
In case you want to save specifically all vehicles, you can use this (already included in grad_persistence_fnc_saveMission). Has to be executed on server.

Syntax:  
`[] call grad_persistence_fnc_saveVehicles`

## grad_persistence_fnc_saveStatics
In case you want to save specifically all static objects, you can use this (already included in grad_persistence_fnc_saveMission). Has to be executed on server.

Syntax:  
`[] call grad_persistence_fnc_saveStatics`

## grad_persistence_fnc_savePlayer
In case you want to save one specific player, you can use this (already included in grad_persistence_fnc_savePlayer). Has to be executed on server.

Syntax:  
`[player,true] call grad_persistence_fnc_savePlayer`

Parameters:  
* player: Object - The unit you want to save
* true: Bool - This has to be true. Trust me.
