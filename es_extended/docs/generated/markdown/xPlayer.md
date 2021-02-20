## class xPlayer
*server/classes/player.lua*



**addAccountMoney** **(** <span style="color:#46a0f0">string</span> accountName, <span style="color:#d300eb">number</span> money **)**

* <span style="color:#46a0f0">string</span> accountName *<span style="color: #888">Account name</span>*

* <span style="color:#d300eb">number</span> money *<span style="color: #888">Amount</span>*


> 
*Add player account money*

---
**addAccountMoney** **(** <span style="color:#46a0f0">string</span> accountName, <span style="color:#d300eb">number</span> money **)**

* <span style="color:#46a0f0">string</span> accountName *<span style="color: #888">Account name</span>*

* <span style="color:#d300eb">number</span> money *<span style="color: #888">Amount</span>*


> 
*Add player account money*

---
**addInventoryItem** **(** <span style="color:#46a0f0">string</span> name, <span style="color:#d300eb">number</span> count **)**

* <span style="color:#46a0f0">string</span> name *<span style="color: #888">Account name</span>*

* <span style="color:#d300eb">number</span> count *<span style="color: #888">Amount</span>*


> 
*Add player inventory item*

---
**addMoney** **(** <span style="color:#d300eb">number</span> money **)**

* <span style="color:#d300eb">number</span> money *<span style="color: #888">Amount</span>*


> 
*Add amount for player 'money' account*

---
**addWeapon** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> ammo **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*

* <span style="color:#d300eb">number</span> ammo *<span style="color: #888">Ammo</span>*


> 
*Add weapon to player*

---
**addWeaponAmmo** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> ammoCount **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*

* <span style="color:#d300eb">number</span> ammoCount *<span style="color: #888">Ammo count</span>*


> 
*Add ammo to player weapon*

---
**addWeaponComponent** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#46a0f0">string</span> weaponComponent **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*

* <span style="color:#46a0f0">string</span> weaponComponent *<span style="color: #888">Weapon component</span>*


> 
*Add weapon to player*

---
<span style="color:#f0ac46">boolean</span> **canCarryItem** **(**  **)**


> 
*Check if player can carry count of given item*

---
<span style="color:#f0ac46">boolean</span> **canSwapItem** **(** <span style="color:#46a0f0">string</span> firstItem, <span style="color:#d300eb">number</span> firstItemCount, <span style="color:#46a0f0">string</span> testItem, <span style="color:#d300eb">number</span> testItemCount **)**

* <span style="color:#46a0f0">string</span> firstItem *<span style="color: #888">Item to be swapped with testItem</span>*

* <span style="color:#d300eb">number</span> firstItemCount *<span style="color: #888">Count of item to swap with testItem</span>*

* <span style="color:#46a0f0">string</span> testItem *<span style="color: #888">Item intended to replace firstItem</span>*

* <span style="color:#d300eb">number</span> testItemCount *<span style="color: #888">Count of item intended to replace firstItem</span>*


> 
*Check if player can sawp item with other item*

---
<span style="color:#ccc">any</span> **get** **(** <span style="color:#46a0f0">string</span> k **)**

* <span style="color:#46a0f0">string</span> k *<span style="color: #888">Field name</span>*


> 
*Get field on this xPlayer instance*

---
<span style="color:#32a83e">custom</span> **getAccount** **(** <span style="color:#46a0f0">string</span> account **)**

* <span style="color:#46a0f0">string</span> account *<span style="color: #888">Account name</span>*


> 
*Get player account*

---
<span style="color:#32a83e">custom</span> **getAccounts** **(** <span style="color:#f0ac46">boolean</span> minimal **)**

* <span style="color:#f0ac46">boolean</span> minimal *<span style="color: #888">Compact output</span>*


> 
*Get player accounts*

---
<span style="color:#ccc">any</span> **getCoords** **(** <span style="color:#f0ac46">boolean</span> asVector **)**

* <span style="color:#f0ac46">boolean</span> asVector *<span style="color: #888">Get coords as vector or table ?</span>*


> 
*Update player coords on server*

---
<span style="color:#46a0f0">string</span> **getGroup** **(**  **)**


> 
*Get player group*

---
<span style="color:#46a0f0">string</span> **getIdentifier** **(**  **)**


> 
*Get player identifier*

---
<span style="color:#32a83e">custom</span> **getInventory** **(** <span style="color:#f0ac46">boolean</span> minimal **)**

* <span style="color:#f0ac46">boolean</span> minimal *<span style="color: #888">Compact output</span>*


> 
*Get player inventory*

---
<span style="color:#32a83e">custom</span> **getInventoryItem** **(** <span style="color:#46a0f0">string</span> name **)**

* <span style="color:#46a0f0">string</span> name *<span style="color: #888">Account name</span>*


> 
*Get player inventory item*

---
<span style="color:#32a83e">custom</span> **getJob** **(**  **)**


> 
*Get player job*

---
<span style="color:#32a83e">custom</span> **getLoadout** **(** <span style="color:#f0ac46">boolean</span> minimal **)**

* <span style="color:#f0ac46">boolean</span> minimal *<span style="color: #888">Compact output</span>*


> 
*Get player inventory*

---
<span style="color:#d300eb">number</span> **getMaxWeight** **(**  **)**


> 
*Get max player weight*

---
<span style="color:#d300eb">number</span> **getMoney** **(**  **)**


> 
*Get amount for player 'money' account*

---
<span style="color:#46a0f0">string</span> **getName** **(**  **)**


> 
*Get player name*

---
<span style="color:#32a83e">custom</span> **getWeapon** **(** <span style="color:#46a0f0">string</span> weaponName **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*


> 
*Get player weapon*

---
<span style="color:#d300eb">number</span> **getWeaponTint** **(** <span style="color:#46a0f0">string</span> weaponName **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*


> 
*Get player weapon tint index*

---
<span style="color:#d300eb">number</span> **getWeight** **(**  **)**


> 
*Get player weight*

---
<span style="color:#f0ac46">boolean</span> **hasWeapon** **(** <span style="color:#46a0f0">string</span> weaponName **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*


> 
*Check if player has weapon*

---
<span style="color:#f0ac46">boolean</span> **hasWeaponComponent** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#46a0f0">string</span> weaponComponent **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*

* <span style="color:#46a0f0">string</span> weaponComponent *<span style="color: #888">Weapon component</span>*


> 
*Check if player weapon has component*

---
**kick** **(** <span style="color:#46a0f0">string</span> reason **)**

* <span style="color:#46a0f0">string</span> reason *<span style="color: #888">Reason to kick player for</span>*


> 
*Kick player*

---
<span style="color:#d300eb">number</span> **maxCarryItem** **(**  **)**


> 
*Get max count of specific item player can carry*

---
**removeInventoryItem** **(** <span style="color:#46a0f0">string</span> name, <span style="color:#d300eb">number</span> count **)**

* <span style="color:#46a0f0">string</span> name *<span style="color: #888">Account name</span>*

* <span style="color:#d300eb">number</span> count *<span style="color: #888">Amount</span>*


> 
*Remove player inventory item*

---
**removeInventoryItem** **(** <span style="color:#46a0f0">string</span> name, <span style="color:#d300eb">number</span> count **)**

* <span style="color:#46a0f0">string</span> name *<span style="color: #888">Account name</span>*

* <span style="color:#d300eb">number</span> count *<span style="color: #888">Amount</span>*


> 
*Remove player inventory item*

---
**removeMoney** **(** <span style="color:#d300eb">number</span> money **)**

* <span style="color:#d300eb">number</span> money *<span style="color: #888">Amount</span>*


> 
*Remove amount for player 'money' account*

---
**removeWeapon** **(** <span style="color:#46a0f0">string</span> weaponName **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*


> 
*Remove player weapon*

---
**removeWeaponAmmo** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> ammoCount **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*

* <span style="color:#d300eb">number</span> ammoCount *<span style="color: #888">Ammo count</span>*


> 
*Remove player weapon ammo*

---
**removeWeaponComponent** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#46a0f0">string</span> weaponComponent **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*

* <span style="color:#46a0f0">string</span> weaponComponent *<span style="color: #888">Weapon component</span>*


> 
*Remove player weapon component*

---
<span style="color:#32a83e">custom</span> **serialize** **(**  **)**


> 
*Serialize player data*
>Can be extended by listening for esx:player:serialize event
>
>AddEventHandler('esx:player:serialize', function(add)
>add({somefield = somevalue})
>end)

---
<span style="color:#32a83e">custom</span> **serializeDB** **(**  **)**


> 
*Serialize player data for saving in database*
>Can be extended by listening for esx:player:serialize:db event
>
>AddEventHandler('esx:player:serialize:db', function(add)
>add({somefield = somevalue})
>end)

---
**set** **(** <span style="color:#46a0f0">string</span> k, <span style="color:#ccc">any</span> v **)**

* <span style="color:#46a0f0">string</span> k *<span style="color: #888">Field name</span>*

* <span style="color:#ccc">any</span> v *<span style="color: #888">Field value</span>*


> 
*Set field on this xPlayer instance*

---
**setAccountMoney** **(** <span style="color:#46a0f0">string</span> accountName, <span style="color:#d300eb">number</span> money **)**

* <span style="color:#46a0f0">string</span> accountName *<span style="color: #888">Account name</span>*

* <span style="color:#d300eb">number</span> money *<span style="color: #888">Amount</span>*


> 
*Set player account money*

---
**setCoords** **(** <span style="color:#32a83e">custom</span> coords **)**

* <span style="color:#32a83e">custom</span> coords *<span style="color: #888">Coords</span>*


> 
*Update player coords on both server and client*

---
**setGroup** **(** <span style="color:#46a0f0">string</span> newGroup **)**

* <span style="color:#46a0f0">string</span> newGroup *<span style="color: #888">New group</span>*


> 
*Set player group*

---
**setJob** **(** <span style="color:#46a0f0">string</span> job, <span style="color:#d300eb">number</span> grade **)**

* <span style="color:#46a0f0">string</span> job *<span style="color: #888">New job</span>*

* <span style="color:#d300eb">number</span> grade *<span style="color: #888">New job grade</span>*


> 
*Set player job*

---
**setMaxWeight** **(** <span style="color:#d300eb">number</span> newWeight **)**

* <span style="color:#d300eb">number</span> newWeight *<span style="color: #888">New weight</span>*


> 
*Set max player weight*

---
**setMoney** **(** <span style="color:#d300eb">number</span> money **)**

* <span style="color:#d300eb">number</span> money *<span style="color: #888">Amount</span>*


> 
*Set amount for player 'money' account*

---
**setName** **(** <span style="color:#46a0f0">string</span> newName **)**

* <span style="color:#46a0f0">string</span> newName *<span style="color: #888">New name</span>*


> 
*Set player name*

---
**setWeaponTint** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> weaponTintIndex **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*

* <span style="color:#d300eb">number</span> weaponTintIndex *<span style="color: #888">Weapon tint index</span>*


> 
*Update player weapon ammo*

---
**showHelpNotification** **(** <span style="color:#46a0f0">string</span> msg, <span style="color:#f0ac46">boolean</span> thisFrame, <span style="color:#f0ac46">boolean</span> beep, <span style="color:#32a83e">custom</span> duration **)**

* <span style="color:#46a0f0">string</span> msg *<span style="color: #888">Notification body</span>*

* <span style="color:#f0ac46">boolean</span> thisFrame *<span style="color: #888">Show for 1 frame only</span>*

* <span style="color:#f0ac46">boolean</span> beep *<span style="color: #888">Weither to beep or not</span>*

* <span style="color:#32a83e">custom</span> duration *<span style="color: #888">duration</span>*


> 
*Show notification to player*

---
**showNotification** **(** <span style="color:#46a0f0">string</span> msg, <span style="color:#f0ac46">boolean</span> flash, <span style="color:#f0ac46">boolean</span> saveToBrief, <span style="color:#32a83e">custom</span> hudColorIndex **)**

* <span style="color:#46a0f0">string</span> msg *<span style="color: #888">Notification body</span>*

* <span style="color:#f0ac46">boolean</span> flash *<span style="color: #888">Weither to flash or not</span>*

* <span style="color:#f0ac46">boolean</span> saveToBrief *<span style="color: #888">Save to brief (pause menu)</span>*

* <span style="color:#32a83e">custom</span> hudColorIndex *<span style="color: #888">color</span>*


> 
*Show notification to player*

---
**triggerEvent** **(** <span style="color:#46a0f0">string</span> eventName, <span style="color:#ccc">any</span> ...rest **)**

* <span style="color:#46a0f0">string</span> eventName *<span style="color: #888">Event name</span>*

* <span style="color:#ccc">any</span> ...rest *<span style="color: #888">Event arguments</span>*


> 
*Trigger event to player*

---
**updateCoords** **(** <span style="color:#32a83e">custom</span> coords **)**

* <span style="color:#32a83e">custom</span> coords *<span style="color: #888">Coords</span>*


> 
*Update player coords on server*

---
**updateWeaponAmmo** **(** <span style="color:#46a0f0">string</span> weaponName, <span style="color:#d300eb">number</span> ammoCount **)**

* <span style="color:#46a0f0">string</span> weaponName *<span style="color: #888">Weapon name</span>*

* <span style="color:#d300eb">number</span> ammoCount *<span style="color: #888">Ammo count</span>*


> 
*Update player weapon ammo*

