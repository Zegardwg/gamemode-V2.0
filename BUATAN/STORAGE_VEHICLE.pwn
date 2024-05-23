/*

	STORAGE VEHICLE 

*/

#include <YSI_Coding\y_hooks>

enum E_VEHICLE_STORAGE_DATA {
	vehInvIndex,
    vehInvName[32],
    vehInvModel,
    vehInvQuantity
};

new VehicleStorageData[MAX_PRIVATE_VEHICLE][MAX_VEHICLE_STORAGE][E_VEHICLE_STORAGE_DATA];

function VehicleInventoryLoaded(index)
{
    for (new i = 0; i != cache_num_rows(); i ++)
    {
	    for (new slot = 0; slot != MAX_VEHICLE_STORAGE; slot ++) if(!pvData[index][vehTrunkType][slot])
	    {
    	    pvData[index][vehTrunkType][slot]   	= e_TRUNK_INVENTORY;

	        cache_get_value_name(i, "itemName", VehicleStorageData[index][slot][vehInvName]);

	        cache_get_value_name_int(i, "itemID", VehicleStorageData[index][slot][vehInvIndex]);
	        cache_get_value_name_int(i, "itemModel", VehicleStorageData[index][slot][vehInvModel]);
	        cache_get_value_name_int(i, "itemQuantity", VehicleStorageData[index][slot][vehInvQuantity]);

	        break;
	    }
    }
    return 1;
}

function VehicleInventoryCreated(index, slot)
{
	VehicleStorageData[index][slot][vehInvIndex] = cache_insert_id();
	return 1;
}

Vehicle_ShowTrunk(playerid, vehicleid)
{
	new output[300],
		amounts[MAX_INVENTORY],
		string[256];

	format(output, sizeof(output), "Item\tAmmo/Quantity\tDurability\n");
	for(new i = 0; i != MAX_VEHICLE_STORAGE; i++)
	{
		switch(_:pvData[vehicleid][vehTrunkType][i])
		{
			case e_TRUNK_INVENTORY:
			{
				amounts[i] = VehicleStorageData[vehicleid][i][vehInvQuantity];
				strunpack(string, VehicleStorageData[vehicleid][i][vehInvName]);
				format(output, sizeof(output), "%s%s\t%d\t \n", output, string, amounts[i]);
			}
			default: format(output, sizeof(output), "%s{AFAFAF}Empty Slot\t \t \n", output);
		}
	}

	ShowPlayerDialog(playerid, DIALOG_VSTORAGE, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Trunk", output, "Select", "Close");
	return 1;
}

Vehicle_AddItem(playerid, index, slot, items[], model)
{
	if(!PlayerHasItem(playerid, items))
	{
		ShowPlayerDialog(playerid, DIALOG_VSOPTIONS, DIALOG_STYLE_LIST, "Your item(s)", "Store Drugs\nStore Seeds\nStore Foods", "Select", "<<");
		return Error(playerid, "Kamu tidak memiliki item %s", items);
	}

	new quantity = Inventory_Count(playerid, items),
		nearest_vehicle = GetPVarInt(playerid, "CarStorage");

	if(Vehicle_Nearest(playerid) != nearest_vehicle)
		return Error(playerid, "Terlalu jauh dari posisi kendaraan yang kamu operasikan, gagal meletakkan item!"), SetTrunkStatus(nearest_vehicle, false);

    pvData[index][vehTrunkType][slot] = e_TRUNK_INVENTORY;

    format(VehicleStorageData[index][slot][vehInvName], 32, items);
    VehicleStorageData[index][slot][vehInvModel] = model; 
    VehicleStorageData[index][slot][vehInvQuantity] = quantity;

    new query[400];
    mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `carstorage` (`itemVehicle`,`itemName`,`itemModel`,`itemQuantity`) VALUES('%d', '%s', '%d', '%d');", pvData[index][cID], items, model, quantity);
    mysql_tquery(g_SQL, query, "VehicleInventoryCreated", "dd", index, slot);

	SetTrunkStatus(nearest_vehicle, false);
    Servers(playerid, "Sukses meletakkan %s kedalam bagasi!", items);

	Inventory_Remove(playerid, items, quantity);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_VSTORAGE)
	{
		if(response)
		{
			new vehid = GetPVarInt(playerid, "CarStorageIndex"),
			nearest_vehicle = GetPVarInt(playerid, "CarStorage");

			if(!Vehicle_IsOwner(playerid, vehid)) {
				SetTrunkStatus(nearest_vehicle, false);
				return Servers(playerid, "Hanya dapat melihat isi bagasi, tidak dapat mengoperasikan isi didalamnya!");
			}

			if(listitem >= MAX_VEHICLE_STORAGE)
				return Error(playerid, "Invalid list-item");

			SetPVarInt(playerid, "VehicleTrunkList", listitem);

			switch(_:pvData[vehid][vehTrunkType][listitem])
			{
				case e_TRUNK_INVENTORY:
				{
					if(!VehicleStorageData[vehid][listitem][vehInvModel])
						return Error(playerid, "Tidak ada item dilist ini!");

					if(Vehicle_Nearest(playerid) != nearest_vehicle)
						return Error(playerid, "Terlalu jauh dari posisi kendaraan yang kamu operasikan, gagal meletakkan item!"), SetTrunkStatus(nearest_vehicle, false);

					if(Inventory_Add(playerid, VehicleStorageData[vehid][listitem][vehInvName], VehicleStorageData[vehid][listitem][vehInvModel], VehicleStorageData[vehid][listitem][vehInvQuantity]) == -1)
						return 1;

					mysql_tquery(g_SQL, sprintf("DELETE FROM `carstorage` WHERE `itemID`='%d';", VehicleStorageData[vehid][listitem][vehInvIndex]));

					SetTrunkStatus(nearest_vehicle, false);

					Servers(playerid, "Sukses mengambil %s (%d) dari dalam bagasi!", VehicleStorageData[vehid][listitem][vehInvName], VehicleStorageData[vehid][listitem][vehInvQuantity]);

					pvData[vehid][vehTrunkType][listitem] = e_TRUNK_NOTHING;
					VehicleStorageData[vehid][listitem][vehInvName][0] = EOS;
					VehicleStorageData[vehid][listitem][vehInvIndex] = VehicleStorageData[vehid][listitem][vehInvModel] = VehicleStorageData[vehid][listitem][vehInvQuantity] = 0;
				}
				default: ShowPlayerDialog(playerid, DIALOG_VSOPTIONS, DIALOG_STYLE_LIST, "Your item(s)", "Store Drugs\nStore Seeds\nStore Foods", "Select", "<<");
			}
		}
		else SetTrunkStatus(GetPVarInt(playerid, "CarStorage"), false);
		return 1;
	}
	if(dialogid == DIALOG_VSOPTIONS)
	{
		if(response)
		{

			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_VSTDURGS, DIALOG_STYLE_LIST, "Select Drugs", "Marijuana\nCocaine\nMuriatic\nEphedrine\nMeth", "Store", "<<");
				case 1: ShowPlayerDialog(playerid, DIALOG_VSTSEEDS, DIALOG_STYLE_LIST, "Select Seeds", "Seeds", "Store", "<<");
				case 2: ShowPlayerDialog(playerid, DIALOG_VSTFOODS, DIALOG_STYLE_LIST, "Select Foods", "Snack\nBig Burger\nSteak\nMilk\nRoti\nWater", "Store", "<<");
				case 3: ShowPlayerDialog(playerid, DIALOG_VSTITEMS, DIALOG_STYLE_LIST, "Select Items", "Clip Pistol\nClip Rifle\nBomb", "Store", "<<");

			}
		}
		else callcmd::bagasi(playerid, "");

		return 1;
	}
	if(dialogid == DIALOG_VSTDURGS)
	{
		if(response)
		{
			new 
			slot = GetPVarInt(playerid, "VehicleTrunkList"),
			index = GetPVarInt(playerid, "CarStorageIndex");

			switch(listitem)
			{
				case 0: Vehicle_AddItem(playerid, index, slot, "Marijuana", 1580);
				case 1: Vehicle_AddItem(playerid, index, slot, "Cocaine", 1580);
				case 2: Vehicle_AddItem(playerid, index, slot, "Muriatic", 1580);
				case 3: Vehicle_AddItem(playerid, index, slot, "Ephedrine", 1580);
				case 4: Vehicle_AddItem(playerid, index, slot, "Meth", 1580);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VSTSEEDS)
	{
		if(response)
		{
			new 
			slot = GetPVarInt(playerid, "VehicleTrunkList"),
			index = GetPVarInt(playerid, "CarStorageIndex");

			switch(listitem)
			{
				case 0: Vehicle_AddItem(playerid, index, slot, "Seeds", 1578);
			}
		}
	}
	if(dialogid == DIALOG_VSTITEMS)
	{
		if(response)
		{

			new 
			slot = GetPVarInt(playerid, "VehicleTrunkList"),
			index = GetPVarInt(playerid, "CarStorageIndex");
			
			switch(listitem)
			{
				case 0: Vehicle_AddItem(playerid, index, slot, "Clip Pistol", 19995);
				case 1: Vehicle_AddItem(playerid, index, slot, "Clip Rifle", 19995);
				case 2: Vehicle_AddItem(playerid, index, slot, "Bomb", 363);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VSTFOODS)
	{
		if(response)
		{
			new 
			slot = GetPVarInt(playerid, "VehicleTrunkList"),
			index = GetPVarInt(playerid, "CarStorageIndex");

			switch(listitem)
			{
				case 0: Vehicle_AddItem(playerid, index, slot, "Snack", 2768);
				case 1: Vehicle_AddItem(playerid, index, slot, "Big Burger", 2703);
				case 2: Vehicle_AddItem(playerid, index, slot, "Steak", 19882);
				case 3: Vehicle_AddItem(playerid, index, slot, "Milk", 19570);
				case 4: Vehicle_AddItem(playerid, index, slot, "Roti", 19579);
				case 5: Vehicle_AddItem(playerid, index, slot, "Water", 1484);
			}
		}
		return 1;
	}
	return 1;
}

CMD:bagasi(playerid, params[])
{
	new nearest_vehicle, vehicleid;

	if(pData[playerid][pInjured]) 
		return Error(playerid, "Keadaan terluka (injured) tidak dapat mengoperasikan perintah ini.");

	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return Error(playerid, "~r~ERROR: ~w~Kemudikan kendaraan untuk mengoperasikan bagasi!.");

		if((vehicleid = GetPlayerVehicleID(playerid)) != INVALID_VEHICLE_ID)
		{
			if(IsABike(vehicleid))
				return Error(playerid, "Kendaraan ini tidak memiliki bagasi!.");
		}
	}
	else
	{
		new index;

		if((nearest_vehicle = Vehicle_Nearest(playerid)) != -1)
		{
			SetPVarInt(playerid, "CarStorage", nearest_vehicle);
			SetPVarInt(playerid, "CarStorageIndex", index);

			Vehicle_ShowTrunk(playerid, index);
			SetTrunkStatus(nearest_vehicle, true);
		}
		else Error(playerid, "Kamu tidak berada dekat dengan kendaraan lainnya!");
	}
	return 1;
}