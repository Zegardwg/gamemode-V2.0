#define MAX_FLAT_STORAGE  (5)

enum flatStorage {
  rItemID,
  rItemName[32 char],
  rItemModel,
  rItemQuantity
};
new FlatStorage[MAX_FLAT_ROOM][MAX_FLAT_STORAGE][flatStorage],
  Iterator:FlatStorages[MAX_FLAT_ROOM]<MAX_FLAT_STORAGE>;

function OnLoadFlatStorage(id) {
  new
    rows = cache_num_rows(),
    str[32],
    slot = cellmin;

  Iter_Init(FlatStorages);
  for (new i = 0; i != rows; i ++) if((slot = Iter_Free(FlatStorages[id])) != cellmin) {
    Iter_Add(FlatStorages[id], slot);

    cache_get_value_int(i, "itemID", FlatStorage[id][slot][rItemID]);
    cache_get_value_int(i, "itemModel", FlatStorage[id][slot][rItemModel]);
    cache_get_value_int(i, "itemQuantity", FlatStorage[id][slot][rItemQuantity]);

    cache_get_value(i, "itemName", str, sizeof(str));
    strpack(FlatStorage[id][slot][rItemName], str, 32 char);
  }
  return 1;
}

function OnFlatLoadWeapon(roomid)
{
  new
    rows = cache_num_rows();

  for (new i = 0; i != rows; i ++) {
    cache_get_value_int(i, "weaponid", FlatRoom[roomid][flatRoomWeapon][i]);
    cache_get_value_int(i, "ammo", FlatRoom[roomid][flatRoomAmmo][i]);
    cache_get_value_int(i, "durability", FlatRoom[roomid][flatRoomDurability][i]);
  }
  return 1;
}

function OnFlatStorageAdd(roomid, itemid)
{
  FlatStorage[roomid][itemid][rItemID] = cache_insert_id();
  return 1;
}

Flat_ShowItems(playerid, roomid)
{
  if(!Iter_Contains(FlatRooms, roomid))
    return 0;

  static
    string[MAX_FLAT_STORAGE * 32],
    name[32];

  string[0] = 0;

  for (new i = 0; i != MAX_FLAT_STORAGE; i ++)
  {
    if(!Iter_Contains(FlatStorages[roomid], i))
      format(string, sizeof(string), "%sEmpty Slot\n", string);

    else {
      strunpack(name, FlatStorage[roomid][i][rItemName]);

      if(FlatStorage[roomid][i][rItemQuantity] == 1) {
        format(string, sizeof(string), "%s%s\n", string, name);
      }
      else format(string, sizeof(string), "%s%s (%d)\n", string, name, FlatStorage[roomid][i][rItemQuantity]);
    }
  }
  Dialog_Show(playerid, Dialog_FlatItems, DIALOG_STYLE_LIST, "Item Storage", string, "Select", "Cancel");
  return 1;
}

Flat_OpenStorage(playerid, roomid)
{
  if(!Iter_Contains(FlatRooms, roomid))
    return 0;

  new
    items[2],
    string[MAX_FLAT_STORAGE * 32];

  items[0] = Iter_Count(FlatStorages[roomid]);
  for (new i = 0; i < 3; i ++) if(FlatRoom[roomid][flatRoomWeapon][i]) {
    items[1]++;
  }
  format(string, sizeof(string), "Item Storage (%d/%d)\nWeapon Storage (%d/3)\nMoney Safe (%s)", items[0], MAX_FLAT_STORAGE, items[1], FormatMoney(FlatRoom[roomid][flatRoomMoney]));
  Dialog_Show(playerid, Dialog_FlatStorage, DIALOG_STYLE_LIST, "Room Storage", string, "Select", "Cancel");
  return 1;
}

// Flat_GetItemID(roomid, item[])
// {
//   if(!Iter_Contains(FlatRooms, roomid))
//     return 0;

//   for (new i = 0; i < MAX_FLAT_STORAGE; i ++)
//   {
//     if(!Iter_Contains(FlatStorages[roomid], i))
//       continue;

//     if(!strcmp(FlatStorage[roomid][i][rItemName], item)) return i;
//   }
//   return -1;
// }

// Flat_GetFreeID(roomid)
// {
//   if(!Iter_Contains(FlatRooms, roomid))
//     return 0;

//   new freeid = cellmin;

//   if ((freeid = Iter_Free(FlatStorages[roomid])) != cellmin)
//     return freeid;

//   return cellmin;
// }

// Flat_AddItem(roomid, item[], model, quantity = 1, slotid = -1)
// {
//   if(!Iter_Contains(FlatRooms, roomid))
//     return 0;

//   new
//     itemid = Flat_GetItemID(roomid, item),
//     string[256];

//   if(itemid == -1)
//   {
//     itemid = Flat_GetFreeID(roomid);

//     if(itemid != cellmin)
//     {
//       if(slotid != -1)
//         itemid = slotid;

//       Iter_Add(FlatStorages[roomid], itemid);
//       FlatStorage[roomid][itemid][rItemModel] = model;
//       FlatStorage[roomid][itemid][rItemQuantity] = quantity;

//       strpack(FlatStorage[roomid][itemid][rItemName], item, 32 char);

//       format(string, sizeof(string), "INSERT INTO `flat_storage` (`ID`, `itemName`, `itemModel`, `itemQuantity`) VALUES ('%d', '%s', '%d', '%d')", FlatRoom[roomid][flatRoomID], item, model, quantity);
//       mysql_tquery(g_SQL, string, "OnFlatStorageAdd", "dd", roomid, itemid);

//       return itemid;
//     }
//     return -1;
//   }
//   else
//   {
//     format(string, sizeof(string), "UPDATE `flat_storage` SET `itemQuantity` = `itemQuantity` + %d WHERE `ID` = '%d' AND `itemID` = '%d'", quantity, FlatRoom[roomid][flatRoomID], FlatStorage[roomid][itemid][rItemID]);
//     mysql_tquery(g_SQL, string);

//     FlatStorage[roomid][itemid][rItemQuantity] += quantity;
//   }
//   return itemid;
// }

// Flat_RemoveItem(roomid, item[], quantity = 1)
// {
//   if(!Iter_Contains(FlatRooms, roomid))
//     return 0;

//   new
//     itemid = Flat_GetItemID(roomid, item),
//     string[128];

//   if(itemid != -1)
//   {
//     if(FlatStorage[roomid][itemid][rItemQuantity] > 0)
//     {
//       FlatStorage[roomid][itemid][rItemQuantity] -= quantity;
//     }
//     if(quantity == -1 || FlatStorage[roomid][itemid][rItemQuantity] < 1)
//     {
//       Iter_Remove(FlatStorages[roomid], itemid);
//       FlatStorage[roomid][itemid][rItemModel] = 0;
//       FlatStorage[roomid][itemid][rItemQuantity] = 0;

//       format(string, sizeof(string), "DELETE FROM `flat_storage` WHERE `ID` = '%d' AND `itemID` = '%d'", FlatRoom[roomid][flatRoomID], FlatStorage[roomid][itemid][rItemID]);
//       mysql_tquery(g_SQL, string);
//     }
//     else if(quantity != -1 && FlatStorage[roomid][itemid][rItemQuantity] > 0)
//     {
//       format(string, sizeof(string), "UPDATE `flat_storage` SET `itemQuantity` = `itemQuantity` - %d WHERE `ID` = '%d' AND `itemID` = '%d'", quantity, FlatRoom[roomid][flatRoomID], FlatStorage[roomid][itemid][rItemID]);
//       mysql_tquery(g_SQL, string);
//     }
//     return 1;
//   }
//   return 0;
// }

Flat_RemoveAllItems(roomid)
{
  if (!Iter_Contains(FlatRooms, roomid))
    return 0;

  for (new i = 0; i != MAX_FLAT_STORAGE; i ++) {
    FlatStorage[roomid][i][rItemModel] = 0;
    FlatStorage[roomid][i][rItemQuantity] = 0;
  }
  Iter_Clear(FlatStorages[roomid]);

  mysql_tquery(g_SQL, sprintf("DELETE FROM `flat_storage` WHERE `ID` = '%d'", FlatRoom[roomid][flatRoomID]));

  for (new i = 0; i < 3; i ++) {
    FlatRoom[roomid][flatRoomWeapon][i] = 0;
    FlatRoom[roomid][flatRoomAmmo][i] = 0;
    FlatRoom[roomid][flatRoomDurability][i] = 0;
  }
  mysql_tquery(g_SQL, sprintf("DELETE FROM `flat_weapon` WHERE `flatroomid` = '%d'", FlatRoom[roomid][flatRoomID]));
  return 1;
}

Flat_WeaponStorage(playerid, roomid)
{
  if(!Iter_Contains(FlatRooms, roomid))
    return 0;

  new
    string[320];

  for (new i = 0; i < 3; i ++)
  {
    if(!FlatRoom[roomid][flatRoomWeapon][i]) format(string, sizeof(string), "%sEmpty Slot\n", string);
    else format(string, sizeof(string), "%s%s ("YELLOW_E"Ammo: %d"WHITE_E") ("YELLOW_E"Durability: %d"WHITE_E")\n", string, ReturnWeaponName(FlatRoom[roomid][flatRoomWeapon][i]), FlatRoom[roomid][flatRoomAmmo][i], FlatRoom[roomid][flatRoomDurability][i]);
  }
  Dialog_Show(playerid, FlatWeapons, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
  return 1;
}

// Dialogs
Dialog:FlatWeapons(playerid, response, listitem, inputtext[]) {
  new
    roomid;

  if((roomid = FlatRoom_Inside(playerid)) != -1 && (FlatRoom_IsOwner(playerid, roomid) || pData[playerid][pAdmin] > 5))
  {
    if(response)
    {
      if(FlatRoom[roomid][flatRoomWeapon][listitem] != 0)
      {
        if(pData[playerid][pOnDuty] > 1)
          return Error(playerid, "Duty faction tidak dapat mengambil senjata.");

        if(PlayerHasWeapon(playerid, FlatRoom[roomid][flatRoomWeapon][listitem]))
          return Error(playerid, "Kamu sudah memiliki senjata yang sama.");

        GivePlayerWeaponEx(playerid, FlatRoom[roomid][flatRoomWeapon][listitem], FlatRoom[roomid][flatRoomAmmo][listitem]);

        SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(FlatRoom[roomid][flatRoomWeapon][listitem]));

        mysql_tquery(g_SQL, sprintf("DELETE FROM `flat_weapon` WHERE `flatroomid` = '%d' AND `ammo`='%d' AND `weaponid`='%d' AND `durability`='%d';", FlatRoom[roomid][flatRoomID], FlatRoom[roomid][flatRoomAmmo][listitem], FlatRoom[roomid][flatRoomWeapon][listitem], FlatRoom[roomid][flatRoomDurability][listitem]));

        FlatRoom[roomid][flatRoomWeapon][listitem]      = 0;
        FlatRoom[roomid][flatRoomAmmo][listitem]         = 0;
        FlatRoom[roomid][flatRoomDurability][listitem]   = 0;
        
        Flat_WeaponStorage(playerid, roomid);
      }
      else
      {
        new
          weaponid = GetPlayerWeapon(playerid),
          ammo = GetPlayerAmmoEx(playerid);

        if(pData[playerid][pOnDuty] > 1)
            return Error(playerid, "Duty faction tidak dapat menyimpan senjata.");

        if(!weaponid)
            return Error(playerid, "You are not holding any weapon!");

        FlatRoom[roomid][flatRoomWeapon][listitem] = weaponid;
        FlatRoom[roomid][flatRoomAmmo][listitem] = ammo;

        mysql_tquery(g_SQL, sprintf("INSERT INTO `flat_weapon` (`flatroomid`, `weaponid`, `ammo`) VALUES ('%d','%d','%d');", FlatRoom[roomid][flatRoomID], weaponid, ammo));

        ResetWeapon(playerid, weaponid);
        Flat_WeaponStorage(playerid, roomid);
        
        SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));
      }
    }
    else Flat_OpenStorage(playerid, roomid);
  }
  return 1;
}

// Dialog:FlatTake(playerid, response, listitem, inputtext[]) {
//   new
//     roomid,
//     string[32];

//   if((roomid = FlatRoom_Inside(playerid)) != -1 && (FlatRoom_IsOwner(playerid, roomid) || pData[playerid][pAdmin] > 5))
//   {
//     strunpack(string, FlatStorage[roomid][pData[playerid][pStorageItem]][rItemName]);

//     if(response)
//     {
//       new amount = strval(inputtext);

//       if(amount < 1 || amount > FlatStorage[roomid][pData[playerid][pStorageItem]][rItemQuantity])
//         return Dialog_Show(playerid, FlatTake, DIALOG_STYLE_INPUT, "Flat Take", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:", "Take", "Back", string, FlatStorage[roomid][pData[playerid][pInventoryItem]][rItemQuantity]);

//       for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], string, true)) {
//         if((Inventory_Count(playerid, g_aInventoryItems[i][e_InventoryItem])+amount) > g_aInventoryItems[i][e_InventoryMax])
//           return Dialog_Show(playerid, FlatTake, DIALOG_STYLE_INPUT, "Flat Take", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:\n(You can take %d %s now!)", "Take", "Back", string, FlatStorage[roomid][pData[playerid][pInventoryItem]][rItemQuantity], (g_aInventoryItems[i][e_InventoryMax]-Inventory_Count(playerid, g_aInventoryItems[i][e_InventoryItem])), string);
//       }

//       new id = Inventory_Add(playerid, string, FlatStorage[roomid][pData[playerid][pStorageItem]][rItemModel], amount);

//       if(id == -1)
//           return Error(playerid, "You don't have any inventory slots left.");

//       Flat_RemoveItem(roomid, string, amount);
//       SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their room storage.", ReturnName(playerid), string);

//       Flat_ShowItems(playerid, roomid);
//     }
//     else Flat_OpenStorage(playerid, roomid);
//   }
//   return 1;
// }

Dialog:Dialog_FlatStorage(playerid, response, listitem, inputtext[]) {
  new
    roomid = -1;

  if((roomid = FlatRoom_Inside(playerid)) != -1 && (FlatRoom_IsOwner(playerid, roomid) || pData[playerid][pAdmin] >= 3))
  {
    if(response)
    {
      if(listitem == 0) {
        Flat_ShowItems(playerid, roomid);
      }
      else if(listitem == 1) {
        if(pData[playerid][pLevel] < 2)
          return Error(playerid, "You're not allowed to access this storage if you're not level 2.");

        if (!pData[playerid][pCS])
          return Error(playerid, "You must have an active character story to access this option.");

        Flat_WeaponStorage(playerid, roomid);
      }
      else if(listitem == 2) {
        Dialog_Show(playerid, FlatMoney, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
      }
    }
  }
  return 1;
}

// Dialog:Dialog_FlatItems(playerid, response, listitem, inputtext[]) {
//   new
//     roomid,
//     string[64];

//   if((roomid = FlatRoom_Inside(playerid)) != -1 && (FlatRoom_IsOwner(playerid, roomid) || pData[playerid][pAdmin] > 5))
//   {
//     if(response)
//     {
//       if(Iter_Contains(FlatStorages[roomid], listitem))
//       {
//         pData[playerid][pStorageItem] = listitem;
//         pData[playerid][pInventoryItem] = listitem;

//         strunpack(string, FlatStorage[roomid][listitem][rItemName]);

//         format(string, sizeof(string), "%s (Quantity: %d)", string, FlatStorage[roomid][listitem][rItemQuantity]);
//         Dialog_Show(playerid, Flat_StorageOptions, DIALOG_STYLE_LIST, string, "Take Item\nStore Item", "Select", "Back");
//       }
//       else {
//         OpenInventory(playerid);

//         pData[playerid][pStorageSelect] = 5;
//       }
//     }
//     else Flat_OpenStorage(playerid, roomid);
//   }
//   return 1;
// }

// Dialog:Flat_StorageOptions(playerid, response, listitem, inputtext[]) {
//   new
//     roomid = -1,
//     itemid = -1,
//     string[32];

//   if((roomid = FlatRoom_Inside(playerid)) != -1 && (FlatRoom_IsOwner(playerid, roomid) || pData[playerid][pAdmin] >= 3))
//   {
//     itemid = pData[playerid][pStorageItem];

//     strunpack(string, FlatStorage[roomid][itemid][rItemName]);

//     if(response)
//     {
//       switch (listitem)
//       {
//         case 0:
//         {
//           if(FlatStorage[roomid][itemid][rItemQuantity] == 1)
//           {
//             if(!strcmp(string, "Backpack") && Inventory_HasItem(playerid, "Backpack"))
//               return Error(playerid, "You already have a backpack in your inventory.");

//             for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], string, true)) {
//               if((Inventory_Count(playerid, g_aInventoryItems[i][e_InventoryItem])+1) > g_aInventoryItems[i][e_InventoryMax])
//                 return Error(playerid, "You're limited %d for %s.", g_aInventoryItems[i][e_InventoryMax], string);
//             }

//             new id = Inventory_Add(playerid, string, FlatStorage[roomid][itemid][rItemModel], 1);

//             if(id == -1)
//               return Error(playerid, "You don't have any inventory slots left.");

//             Flat_RemoveItem(roomid, string);
//             SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their room storage.", ReturnName(playerid), string);

//             Flat_ShowItems(playerid, roomid);
//             Log_Write("logs/storage_log.txt", "[%s] %s has taken \"%s\" from room ID: %d.", ReturnDate(), ReturnName(playerid), string, roomid);
//           }
//           else
//           {
//             Dialog_Show(playerid, FlatTake, DIALOG_STYLE_INPUT, "Flat Take", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:", "Take", "Back", string, FlatStorage[roomid][itemid][rItemQuantity]);
//           }
//         }
//         case 1:
//         {
//           new id = Inventory_GetItemID(playerid, string);

//           if(!strcmp(string, "Backpack")) {
//             Flat_ShowItems(playerid, roomid);

//             return Error(playerid, "You can only store one backpack in your room.");
//           }
//           else if(id == -1) {
//             Flat_ShowItems(playerid, roomid);

//             return Error(playerid, "You don't have anymore of this item to store!");
//           }
//           else if(InventoryData[playerid][id][invQuantity] == 1)
//           {
//             Flat_AddItem(roomid, string, InventoryData[playerid][id][invModel]);
//             Inventory_Remove(playerid, string);

//             SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their room storage.", ReturnName(playerid), string);
//             Log_Write("logs/storage_log.txt", "[%s] %s has stored \"%s\" into their room ID: %d.", ReturnDate(), ReturnName(playerid), string, roomid);
//             Flat_ShowItems(playerid, roomid);
//           }
//           else if(InventoryData[playerid][id][invQuantity] > 1) {
//             pData[playerid][pInventoryItem] = id;

//             Dialog_Show(playerid, FlatDeposit, DIALOG_STYLE_INPUT, "Flat Deposit", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:", "Store", "Back", string, InventoryData[playerid][id][invQuantity]);
//           }
//         }
//       }
//     }
//     else
//     {
//       Flat_ShowItems(playerid, roomid);
//     }
//   }
//   return 1;
// }

// Dialog:FlatDeposit(playerid, response, listitem, inputtext[]) {
//   new
//     roomid,
//     string[32];

//   if((roomid = FlatRoom_Inside(playerid)) != -1 && (FlatRoom_IsOwner(playerid, roomid)))
//   {
//     strunpack(string, InventoryData[playerid][pData[playerid][pInventoryItem]][invItem]);

//     if(response)
//     {
//       new amount = strval(inputtext);

//       if(amount < 1 || amount > InventoryData[playerid][pData[playerid][pInventoryItem]][invQuantity])
//         return Dialog_Show(playerid, FlatDeposit, DIALOG_STYLE_INPUT, "Flat Deposit", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:", "Store", "Back", string, InventoryData[playerid][pData[playerid][pInventoryItem]][invQuantity]);

//       Flat_AddItem(roomid, string, InventoryData[playerid][pData[playerid][pInventoryItem]][invModel], amount);
//       Inventory_Remove(playerid, string, amount);

//       SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their room storage.", ReturnName(playerid), string);
//       Log_Write("logs/storage_log.txt", "[%s] %s has stored \"%s\" (%d) into their room ID: %d.", ReturnDate(), ReturnName(playerid), string, amount, roomid);

//       Flat_ShowItems(playerid, roomid);
//     }
//     else Flat_OpenStorage(playerid, roomid);
//   }	
//   return 1;
// }

Dialog:FlatMoney(playerid, response, listitem, inputtext[]) {
  new
    roomid;

  if((roomid = FlatRoom_Inside(playerid)) != -1 && FlatRoom_IsOwner(playerid, roomid) || pData[playerid][pAdmin] > 5)
  {
    if(response)
    {
      switch (listitem)
      {
        case 0: Dialog_Show(playerid, FlatWithdrawCash, DIALOG_STYLE_INPUT, "Withdraw from safe", "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", "Withdraw", "Back", FormatMoney(FlatRoom[roomid][flatRoomMoney]));
        case 1: Dialog_Show(playerid, FlatDepositCash, DIALOG_STYLE_INPUT, "Deposit into safe", "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", "Deposit", "Back", FormatMoney(FlatRoom[roomid][flatRoomMoney]));
      }
    }
    else Flat_OpenStorage(playerid, roomid);
  }
  return 1;
}

Dialog:FlatWithdrawCash(playerid, response, listitem, inputtext[]) {
  new
    roomid;

  if((roomid = FlatRoom_Inside(playerid)) != -1 && (FlatRoom_IsOwner(playerid, roomid) || pData[playerid][pAdmin] > 5))
  {
    if(response)
    {
      new amount = strval(inputtext);

      if(isnull(inputtext))
        return Dialog_Show(playerid, FlatWithdrawCash, DIALOG_STYLE_INPUT, "Withdraw from safe", "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", "Withdraw", "Back", FormatMoney(FlatRoom[roomid][flatRoomMoney]));

      if(amount < 1 || amount > FlatRoom[roomid][flatRoomMoney])
        return Dialog_Show(playerid, FlatWithdrawCash, DIALOG_STYLE_INPUT, "Withdraw from safe", "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", "Withdraw", "Back", FormatMoney(FlatRoom[roomid][flatRoomMoney]));

      FlatRoom[roomid][flatRoomMoney] -= amount;
      GivePlayerMoneyEx(playerid, amount);

      FlatRoom_Save(roomid);
      Flat_OpenStorage(playerid, roomid);

      SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s has withdrawn %s from their room safe.", ReturnName(playerid), FormatMoney(amount));
    }
    else Dialog_Show(playerid, FlatMoney, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
  }
  return 1;
}

Dialog:FlatDepositCash(playerid, response, listitem, inputtext[]) {
  new
    roomid;

  if((roomid = FlatRoom_Inside(playerid)) != -1 && FlatRoom_IsOwner(playerid, roomid))
  {
    if(response)
    {
      new amount = strval(inputtext);

      if(isnull(inputtext))
        return Dialog_Show(playerid, FlatDepositCash, DIALOG_STYLE_INPUT, "Deposit into safe", "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", "Deposit", "Back", FormatMoney(FlatRoom[roomid][flatRoomMoney]));

      if(amount < 1 || amount > GetPlayerMoney(playerid))
        return Dialog_Show(playerid, FlatDepositCash, DIALOG_STYLE_INPUT, "Deposit into safe", "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", "Deposit", "Back", FormatMoney(FlatRoom[roomid][flatRoomMoney]));

      FlatRoom[roomid][flatRoomMoney] += amount;
      GivePlayerMoneyEx(playerid, -amount);

      FlatRoom_Save(roomid);
      Flat_OpenStorage(playerid, roomid);

      SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s has deposited %s into their room safe.", ReturnName(playerid), FormatMoney(amount));
    }
    else Dialog_Show(playerid, FlatMoney, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
  }
  return 1;
}