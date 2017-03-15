# GRAD Persistence

Enables you to save:

* AI units
* vehicles
* static objects (including grad-fortifications)
* player equipment, inventory and health
* player money (needs grad-listBuymenu or grad-moneyMenu)

Limitations:

* magazines stored in containers refill
* weapon attachments on weapons in containers get removed from the weapon, but added to container cargo
* grad-fortifications owners are lost (--> you won't be able to pack up fortifications after loading - demolition works though)

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
	- [grad_persistence_fnc_clearMissionData](#gradpersistencefncclearmissiondata)

<!-- /TOC -->

### Dependencies
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

Attribute            | Default Value | Explanation
---------------------|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
missionTag           | missionName   | The tag that everything in this mission will be saved under. Two missions with the same tag will overwrite each other when saving, even on different terrains. One mission can load the data of a different mission, if they are both saved under the same tag.
loadOnMissionStart   | 1             | Toggles automatic loading on start of mission.
missionWaitCondition | "true"        | Condition before data will be automatically loaded. Also applies to automatic loading of JIP players.
playerWaitCondition  | "true"        | Condition before a player will be loaded. Passed parameters are `[unit,side of unit,unit classname,unit roleDescription]`
saveUnits            | 1             | Toggles saving of AI units. 0 to disable, 1 to save only units that were not placed in the editor, 2 to save all units
saveVehicles         | 1             | Toggles saving of vehicles, static weapons, containers (i.e. ammoboxes), certain objects. 0,1,2 same as `saveUnits`
saveStatics          | 1             | Toggles saving of static objects such as houses, walls, trees, etc. 0,1,2 same as `saveUnits`
savePlayerInventory  | 1             | Toggles saving of player inventories. 0 to disable, 1 to enable.
savePlayerDamage     | 0             | Toggles saving of player health. 0 to disable, 1 to enable.
savePlayerPosition   | 0             | Toggles saving of player position. 0 to disable, 1 to enable.
savePlayerMoney      | 0             | Toggles saving of player money. Needs [GRAD ListBuymenu](https://github.com/gruppe-adler/grad-listBuymenu) or [GRAD Moneymenu](https://github.com/gruppe-adler/grad-moneyMenu)

Example:

```sqf
class CfgGradPersistence {
    missionTag = "my_persistent_mission";
	loadOnMissionStart = 1;
    missionWaitCondition = "true";
	playerWaitCondition = "(_this select 0) getVariable ["missionStuffComplete",false]";
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
With `loadOnMissionStart` the mission is loaded automatically. JIP and disconnecting players are saved automatically. Saving the mission needs to be done manually. Either with `grad_persistence_fnc_saveMission` or with the admin chat-command `#savemission`. This only works for logged admins, not for voted admins.

# Functions
There are only two important functions. `grad_persistence_fnc_saveMission`and `grad_persistence_fnc_loadMission`.

## grad_persistence_fnc_saveMission
Saves the current mission according to configuration. Has to be executed on server. Optionally shows a warning message before saving, so that players can leave their vehicles. (Players that are inside vehicles during saving will spawn dismounted, but inside the vehicle object.)

### Syntax  
`[showWarning, waitTime, area] call grad_persistence_fnc_saveMission`

| Parameter              | Explanation                                                                   |
|------------------------|-------------------------------------------------------------------------------|
| showWarning (optional) | Bool - Show warning message before saving (default: false)                    |
| waitTime (optional)    | Number - Time in seconds before actual save happens (default: 10)             |
| area (optional)        | Trigger/Marker/Location/Area-Array - Only save objects that are in this area. |

Area array has the following format:  
`[center,a,b,angle,isRectangle,c]`

| Parameter              | Explanation                                                |
|------------------------|------------------------------------------------------------|
| center                 | Pos2D or Pos3D - Center of area                            |
| a                      | Number - Radius 1 of area.                                 |
| b (optional)           | Number - Radius 2 of area. (default: a)                    |
| angle (optional)       | Number - The angle that this area is rotated. (default: 0) |
| isRectangle (optional) | Bool - Is this area a rectangle? (default: false)          |
| c (optional)           | Number - Height of this area. (default: unlimited)         |

### Example
```sqf
[true,30] call grad_persistence_fnc_saveMission;
[false,0,trigger_1] call grad_persistence_fnc_saveMission;
[false,0,"marker_5"] call grad_persistence_fnc_saveMission;
[true,10,[[2563,1423],60]] call grad_persistence_fnc_saveMission;
[true,10,[[534,2421,0],70,100,15,true,200]] call grad_persistence_fnc_saveMission;
```

## grad_persistence_fnc_loadMission
Loads the mission that was saved under the `missionTag` defined in `CfgGradPersistence`. Has to be executed on server.

### Syntax  
`[] call grad_persistence_fnc_loadMission`

## grad_persistence_fnc_saveGroups
In case you want to save specifically the AI units, you can use this (already included in grad_persistence_fnc_saveMission). Has to be executed on server.

### Syntax  
`[area] call grad_persistence_fnc_saveGroups`

| Parameter       | Explanation                                                                                                                           |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------|
| area (optional) | Trigger/Marker/Location/Area-Array - Only save objects that are in this area. See `grad_persistence_fnc_saveMission` for explanation. |

## grad_persistence_fnc_saveVehicles
In case you want to save specifically all vehicles, you can use this (already included in grad_persistence_fnc_saveMission). Has to be executed on server.

### Syntax  
`[area] call grad_persistence_fnc_saveVehicles`

| Parameter       | Explanation                                                                                                                           |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------|
| area (optional) | Trigger/Marker/Location/Area-Array - Only save objects that are in this area. See `grad_persistence_fnc_saveMission` for explanation. |

## grad_persistence_fnc_saveStatics
In case you want to save specifically all static objects, you can use this (already included in grad_persistence_fnc_saveMission). Has to be executed on server.

### Syntax  
`[area] call grad_persistence_fnc_saveStatics`

| Parameter       | Explanation                                                                                                                           |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------|
| area (optional) | Trigger/Marker/Location/Area-Array - Only save objects that are in this area. See `grad_persistence_fnc_saveMission` for explanation. |

## grad_persistence_fnc_savePlayer
In case you want to save one specific player, you can use this (already included in grad_persistence_fnc_savePlayer). Has to be executed on server.

### Syntax  
`[somePlayerHere,true] call grad_persistence_fnc_savePlayer`

| Parameter | Explanation                           |
|-----------|---------------------------------------|
| player    | Object - The unit you want to save.   |
| true      | Bool - This has to be true. Trust me. |


## grad_persistence_fnc_clearMissionData
Deletes all saved data of a specific missionTag.

### Syntax  
`[missionTag] call grad_persistence_fnc_clearMissionData`

| Parameter | Explanation                           |
|-----------|---------------------------------------|
| missionTag (optional)    | String - The mission tag of the mission data that is to be deleted. Defaults to current mission's missionTag.   |

### Example
```sqf
["my_persistent_mission"] call grad_persistence_fnc_clearMissionData;
```
