/*
enum E_VTOYS
{
	vtModelid,
	Float:vtX,
	Float:vtY,
	Float:vtZ,
	Float:vtRX,
	Float:vtRY,
	Float:vtRZ,
	//Temp
	vtObj
}

new vToys[MAX_VEHICLES][6][E_VTOYS];
*/

MySQL_LoadVehicleToys(vehid)
{
	new tstr[512];
	mysql_format(g_SQL, tstr, sizeof(tstr), "SELECT * FROM toysveh WHERE Owner='%d' LIMIT 1", pvData[vehid][cID]);
	mysql_tquery(g_SQL, tstr, "LoadVehicleToys", "i", vehid);
}

function LoadVehicleToys(vehid)
{
	new rows = cache_num_rows(), vehicleid = pvData[vehid][cVeh];
	if(rows)
	{
		pvData[vehicleid][cToys] = true;
		cache_get_value_name_int(0, "Slot0_Model", vToys[vehicleid][0][vtModelid]);
  		cache_get_value_name_float(0, "Slot0_XPos", vToys[vehicleid][0][vtX]);
  		cache_get_value_name_float(0, "Slot0_YPos", vToys[vehicleid][0][vtY]);
  		cache_get_value_name_float(0, "Slot0_ZPos", vToys[vehicleid][0][vtZ]);
  		cache_get_value_name_float(0, "Slot0_XRot", vToys[vehicleid][0][vtRX]);
  		cache_get_value_name_float(0, "Slot0_YRot", vToys[vehicleid][0][vtRY]);
  		cache_get_value_name_float(0, "Slot0_ZRot", vToys[vehicleid][0][vtRZ]);
		
		cache_get_value_name_int(0, "Slot1_Model", vToys[vehicleid][1][vtModelid]);
  		cache_get_value_name_float(0, "Slot1_XPos", vToys[vehicleid][1][vtX]);
  		cache_get_value_name_float(0, "Slot1_YPos", vToys[vehicleid][1][vtY]);
  		cache_get_value_name_float(0, "Slot1_ZPos", vToys[vehicleid][1][vtZ]);
  		cache_get_value_name_float(0, "Slot1_XRot", vToys[vehicleid][1][vtRX]);
  		cache_get_value_name_float(0, "Slot1_YRot", vToys[vehicleid][1][vtRY]);
  		cache_get_value_name_float(0, "Slot1_ZRot", vToys[vehicleid][1][vtRZ]);
		
		cache_get_value_name_int(0, "Slot2_Model", vToys[vehicleid][2][vtModelid]);
  		cache_get_value_name_float(0, "Slot2_XPos", vToys[vehicleid][2][vtX]);
  		cache_get_value_name_float(0, "Slot2_YPos", vToys[vehicleid][2][vtY]);
  		cache_get_value_name_float(0, "Slot2_ZPos", vToys[vehicleid][2][vtZ]);
  		cache_get_value_name_float(0, "Slot2_XRot", vToys[vehicleid][2][vtRX]);
  		cache_get_value_name_float(0, "Slot2_YRot", vToys[vehicleid][2][vtRY]);
  		cache_get_value_name_float(0, "Slot2_ZRot", vToys[vehicleid][2][vtRZ]);
		
		cache_get_value_name_int(0, "Slot3_Model", vToys[vehicleid][3][vtModelid]);
  		cache_get_value_name_float(0, "Slot3_XPos", vToys[vehicleid][3][vtX]);
  		cache_get_value_name_float(0, "Slot3_YPos", vToys[vehicleid][3][vtY]);
  		cache_get_value_name_float(0, "Slot3_ZPos", vToys[vehicleid][3][vtZ]);
  		cache_get_value_name_float(0, "Slot3_XRot", vToys[vehicleid][3][vtRX]);
  		cache_get_value_name_float(0, "Slot3_YRot", vToys[vehicleid][3][vtRY]);
  		cache_get_value_name_float(0, "Slot3_ZRot", vToys[vehicleid][3][vtRZ]);
		
		AttachVehicleToys(vehid); // Attach player Toys.
		printf("[V_TOYS] Success loaded from %s(%d)", GetVehicleName(pvData[vehid][cVeh]), pvData[vehid][cVeh]);
	}
	return 1;
}

RemoveVehicleToys(vehicleid)
{
	if(pvData[vehicleid][cToys] == true)
	{
		MySQL_SaveVehicleToys(vehicleid);
		pvData[vehicleid][cToys] = false;

		for(new slotid = 0; slotid < 4; slotid++)
		{
			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtModelid] = 0;
			vToys[vehicleid][slotid][vtX] = 0.0;
			vToys[vehicleid][slotid][vtY] = 0.0;
			vToys[vehicleid][slotid][vtZ] = 0.0;

			vToys[vehicleid][slotid][vtRX] = 0.0;
			vToys[vehicleid][slotid][vtRY] = 0.0;
			vToys[vehicleid][slotid][vtRZ] = 0.0;
		}
	}
}

MySQL_ResetVehicleToys(vehid)
{
	new vehicleid = pvData[vehid][cVeh];
	if(pvData[vehicleid][cToys] == true)
	{
		for(new i = 0; i < 4; i++)
		{
			if(IsValidObject(vToys[vehicleid][i][vtObj]))
				DestroyObject(vToys[vehicleid][i][vtObj]);

			vToys[vehicleid][i][vtModelid] = 0;
			vToys[vehicleid][i][vtX] = 0.0;
			vToys[vehicleid][i][vtY] = 0.0;
			vToys[vehicleid][i][vtZ] = 0.0;
			vToys[vehicleid][i][vtRX] = 0.0;
			vToys[vehicleid][i][vtRY] = 0.0;
			vToys[vehicleid][i][vtRZ] = 0.0;
		}

		new string[128];
		foreach(new i : PVehicles)
		{
			if(vehicleid == pvData[vehid][cVeh])
			{
				mysql_format(g_SQL, string, sizeof(string), "DELETE FROM toysveh WHERE Owner = '%d'", pvData[vehid][cID]);
				mysql_tquery(g_SQL, string);
			}
		}
		pvData[vehicleid][cToys] = false;
	}
}

MySQL_CreateVehicleToys(vehicleid)
{
	foreach(new vehid : PVehicles)
	{
		if(vehicleid == pvData[vehid][cVeh])
		{
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `toysveh` (`Owner`) VALUES ('%d');", pvData[vehid][cID]);
			mysql_tquery(g_SQL, query);
			pvData[vehicleid][cToys] = true;

			for(new i = 0; i < 4; i++)
			{
				vToys[vehicleid][i][vtModelid] = 0;
				vToys[vehicleid][i][vtX] = 0.0;
				vToys[vehicleid][i][vtY] = 0.0;
				vToys[vehicleid][i][vtZ] = 0.0;
				vToys[vehicleid][i][vtRX] = 0.0;
				vToys[vehicleid][i][vtRY] = 0.0;
				vToys[vehicleid][i][vtRZ] = 0.0;
			}
		}
	}
}

AttachVehicleToys(vehid)
{
	new vehicleid = pvData[vehid][cVeh];
	if(pvData[vehicleid][cToys] == false) 
		return 1;

	if(vToys[vehicleid][0][vtModelid] != 0)
	{
		vToys[vehicleid][0][vtObj] = CreateObject(vToys[vehicleid][0][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

		AttachObjectToVehicle(vToys[vehicleid][0][vtObj], 
			vehicleid,
			vToys[vehicleid][0][vtX], 
			vToys[vehicleid][0][vtY], 
			vToys[vehicleid][0][vtZ], 
			vToys[vehicleid][0][vtRX], 
			vToys[vehicleid][0][vtRY], 
			vToys[vehicleid][0][vtRZ]);
	}
	
	if(vToys[vehicleid][1][vtModelid] != 0)
	{
		vToys[vehicleid][1][vtObj] = CreateObject(vToys[vehicleid][1][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

		AttachObjectToVehicle(vToys[vehicleid][1][vtObj], 
			vehicleid,
			vToys[vehicleid][1][vtX], 
			vToys[vehicleid][1][vtY], 
			vToys[vehicleid][1][vtZ], 
			vToys[vehicleid][1][vtRX], 
			vToys[vehicleid][1][vtRY], 
			vToys[vehicleid][1][vtRZ]);
	}
	
	if(vToys[vehicleid][2][vtModelid] != 0)
	{
		if(IsValidObject(vToys[vehicleid][2][vtObj]))
			DestroyObject(vToys[vehicleid][2][vtObj]);

		vToys[vehicleid][2][vtObj] = CreateObject(vToys[vehicleid][2][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

		AttachObjectToVehicle(vToys[vehicleid][2][vtObj], 
			vehicleid,
			vToys[vehicleid][2][vtX], 
			vToys[vehicleid][2][vtY], 
			vToys[vehicleid][2][vtZ], 
			vToys[vehicleid][2][vtRX], 
			vToys[vehicleid][2][vtRY], 
			vToys[vehicleid][2][vtRZ]);
	}
	
	if(vToys[vehicleid][3][vtModelid] != 0)
	{
		vToys[vehicleid][3][vtObj] = CreateObject(vToys[vehicleid][3][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

		AttachObjectToVehicle(vToys[vehicleid][3][vtObj], 
			vehicleid,
			vToys[vehicleid][3][vtX], 
			vToys[vehicleid][3][vtY], 
			vToys[vehicleid][3][vtZ], 
			vToys[vehicleid][3][vtRX], 
			vToys[vehicleid][3][vtRY], 
			vToys[vehicleid][3][vtRZ]);
	}
	
	return 1;
}

MySQL_SaveVehicleToys(vehicleid)
{
	if(pvData[vehicleid][cToys] == false) 
		return true;

	foreach(new vehid : PVehicles)
	{
		if(vehicleid == pvData[vehid][cVeh])
		{
			new line4[1600], lstr[1024];
			mysql_format(g_SQL, lstr, sizeof(lstr),
			"UPDATE `toysveh` SET \
			`Slot0_Model` = %i, `Slot0_XPos` = %.3f, `Slot0_YPos` = %.3f, `Slot0_ZPos` = %.3f, `Slot0_XRot` = %.3f, `Slot0_YRot` = %.3f, `Slot0_ZRot` = %.3f,",
				vToys[vehicleid][0][vtModelid],
		        vToys[vehicleid][0][vtX],
		        vToys[vehicleid][0][vtY],
		        vToys[vehicleid][0][vtZ],
		        vToys[vehicleid][0][vtRX],
		        vToys[vehicleid][0][vtRY],
		        vToys[vehicleid][0][vtRZ]);
			strcat(line4, lstr);

			mysql_format(g_SQL, lstr, sizeof(lstr),
			" `Slot1_Model` = %i, `Slot1_XPos` = %.3f, `Slot1_YPos` = %.3f, `Slot1_ZPos` = %.3f, `Slot1_XRot` = %.3f, `Slot1_YRot` = %.3f, `Slot1_ZRot` = %.3f,",
				vToys[vehicleid][1][vtModelid],
		        vToys[vehicleid][1][vtX],
		        vToys[vehicleid][1][vtY],
		        vToys[vehicleid][1][vtZ],
		        vToys[vehicleid][1][vtRX],
		        vToys[vehicleid][1][vtRY],
		        vToys[vehicleid][1][vtRZ]);
		  	strcat(line4, lstr);

		    mysql_format(g_SQL, lstr, sizeof(lstr),
			" `Slot2_Model` = %i, `Slot2_XPos` = %.3f, `Slot2_YPos` = %.3f, `Slot2_ZPos` = %.3f, `Slot2_XRot` = %.3f, `Slot2_YRot` = %.3f, `Slot2_ZRot` = %.3f,",
				vToys[vehicleid][2][vtModelid],
		        vToys[vehicleid][2][vtX],
		        vToys[vehicleid][2][vtY],
		        vToys[vehicleid][2][vtZ],
		        vToys[vehicleid][2][vtRX],
		        vToys[vehicleid][2][vtRY],
		        vToys[vehicleid][2][vtRZ]);
		  	strcat(line4, lstr);

		    mysql_format(g_SQL, lstr, sizeof(lstr),
			" `Slot3_Model` = %i, `Slot3_XPos` = %.3f, `Slot3_YPos` = %.3f, `Slot3_ZPos` = %.3f, `Slot3_XRot` = %.3f, `Slot3_YRot` = %.3f, `Slot3_ZRot` = %.3f,",
				vToys[vehicleid][3][vtModelid],
		        vToys[vehicleid][3][vtX],
		        vToys[vehicleid][3][vtY],
		        vToys[vehicleid][3][vtZ],
		        vToys[vehicleid][3][vtRX],
		        vToys[vehicleid][3][vtRY],
		        vToys[vehicleid][3][vtRZ]);
		  	strcat(line4, lstr);

			mysql_format(g_SQL, lstr, sizeof(lstr),
			" `Slot4_Model` = %i, `Slot4_XPos` = %.3f, `Slot4_YPos` = %.3f, `Slot4_ZPos` = %.3f, `Slot4_XRot` = %.3f, `Slot4_YRot` = %.3f, `Slot4_ZRot` = %.3f,",
				vToys[vehicleid][4][vtModelid],
		        vToys[vehicleid][4][vtX],
		        vToys[vehicleid][4][vtY],
		        vToys[vehicleid][4][vtZ],
		        vToys[vehicleid][4][vtRX],
		        vToys[vehicleid][4][vtRY],
		        vToys[vehicleid][4][vtRZ]);
		  	strcat(line4, lstr);

			mysql_format(g_SQL, lstr, sizeof(lstr),
			" `Slot5_Model` = %i, `Slot5_XPos` = %.3f, `Slot5_YPos` = %.3f, `Slot5_ZPos` = %.3f, `Slot5_XRot` = %.3f, `Slot5_YRot` = %.3f, `Slot5_ZRot` = %.3f WHERE `Owner` = '%d'",
				vToys[vehicleid][5][vtModelid],
		        vToys[vehicleid][5][vtX],
		        vToys[vehicleid][5][vtY],
		        vToys[vehicleid][5][vtZ],
		        vToys[vehicleid][5][vtRX],
		        vToys[vehicleid][5][vtRY],
		        vToys[vehicleid][5][vtRZ],
				pvData[vehid][cID]);
		  	strcat(line4, lstr);

		    mysql_tquery(g_SQL, line4);
		}
	}
    return 1;
}

CMD:buyvtoys(playerid, params[])
{
	new string[248], vehicleid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 1790.4084,-2025.6746,13.5735))
		return Error(playerid, "Kamu harus berada di modshop point/mekanik city");

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
		return Error(playerid, "Kamu harus mengendarai kendaraan pribadi!");

	foreach(new i : PVehicles)
	{
		if(vehicleid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(vToys[vehicleid][0][vtModelid] == 0)
				{
					strcat(string, ""dot"Slot 1\n");
				}
				else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

				if(vToys[vehicleid][1][vtModelid] == 0)
				{
					strcat(string, ""dot"Slot 2\n");
				}
				else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

				if(vToys[vehicleid][2][vtModelid] == 0)
				{
					strcat(string, ""dot"Slot 3\n");
				}
				else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

				if(vToys[vehicleid][3][vtModelid] == 0)
				{
					strcat(string, ""dot"Slot 4\n");
				}
				else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

				ShowPlayerDialog(playerid, DIALOG_VTOYBUY, DIALOG_STYLE_LIST, ""RED_E"ValriseReality "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
			}
			else return Error(playerid, "Kendaraan ini bukan milikmu!");
		}
	}
	return 1;
}

CMD:vtoys(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{	
		new string[350];
		new x = GetPlayerVehicleID(playerid);
		foreach(new i: PVehicles)
		if(x == pvData[i][cVeh])
		{
			pData[playerid][VehicleID] = pvData[i][cVeh];
			if(vToys[pvData[i][cVeh]][0][vtModelid] == 0)
			{
			    strcat(string, ""dot"Slot 1\n");
			}
			else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

			if(vToys[pvData[i][cVeh]][1][vtModelid] == 0)
			{
			    strcat(string, ""dot"Slot 2\n");
			}
			else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

			if(vToys[pvData[i][cVeh]][2][vtModelid] == 0)
			{
			    strcat(string, ""dot"Slot 3\n");
			}
			else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

			if(vToys[pvData[i][cVeh]][3][vtModelid] == 0)
			{
			    strcat(string, ""dot"Slot 4\n");
			}
			else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");
			
			strcat(string, ""dot""RED_E"Reset All Object\n");
			strcat(string, ""dot""RED_E"Refresh All Object");
			ShowPlayerDialog(playerid, DIALOG_VTOY, DIALOG_STYLE_LIST, ""RED_E"ValriseReality: "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	else return Error(playerid, "Anda harus mengendarai kendaraan!");
	
	return 1;
}

/*

//ENUM DIALOG & PLAYER

    DIALOG_VTOY,
    DIALOG_VTOYEDIT,
    DIALOG_VTOYPOSX,
    DIALOG_VTOYPOSY,
    DIALOG_VTOYPOSZ,
    DIALOG_VTOYPOSRX,
    DIALOG_VTOYPOSRY,
    DIALOG_VTOYPOSRZ,
    DIALOG_VTOYBUY

pVtoySelect
pGetVTOYID

public OnPlayerEditVehicleObject(playerid, vehicleid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(vehicleid)
	{
		if(response == EDIT_RESPONSE_FINAL)
		{
			GameTextForPlayer(playerid, "~g~~h~Toy Position Updated~y~!", 4000, 5);
			new slotid = pData[playerid][pVtoySelect];

			vToys[vehicleid][slotid][vtX] = x;
			vToys[vehicleid][slotid][vtY] = y;
			vToys[vehicleid][slotid][vtZ] = z;

			vToys[vehicleid][slotid][vtRX] = rx;
			vToys[vehicleid][slotid][vtRY] = ry;
			vToys[vehicleid][slotid][vtRZ] = rz;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
			vehicleid,
			vToys[vehicleid][slotid][vtX], 
			vToys[vehicleid][slotid][vtY], 
			vToys[vehicleid][slotid][vtZ], 
			vToys[vehicleid][slotid][vtRX], 
			vToys[vehicleid][slotid][vtRY], 
			vToys[vehicleid][slotid][vtRZ]);

			foreach(new i : PVehicles)
			{
				if(vehicleid == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}
			TogglePlayerControllable(playerid, 1);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			GameTextForPlayer(playerid, "~r~~h~Selection Cancelled~y~!", 4000, 5);
			new slotid = pData[playerid][pVtoySelect];

			vToys[vehicleid][slotid][vtX] = x;
			vToys[vehicleid][slotid][vtY] = y;
			vToys[vehicleid][slotid][vtZ] = z;

			vToys[vehicleid][slotid][vtRX] = rx;
			vToys[vehicleid][slotid][vtRY] = ry;
			vToys[vehicleid][slotid][vtRZ] = rz;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
			vehicleid,
			vToys[vehicleid][slotid][vtX], 
			vToys[vehicleid][slotid][vtY], 
			vToys[vehicleid][slotid][vtZ], 
			vToys[vehicleid][slotid][vtRX], 
			vToys[vehicleid][slotid][vtRY], 
			vToys[vehicleid][slotid][vtRZ]);

			TogglePlayerControllable(playerid, 1);
		}
	}
	return 1;
}

//REMOVE PLAYER VEHICLE
if(pvData[pvData[i][cVeh]][cToys] == true)
			{
				MySQL_SaveVehicleToys(i);
				pvData[pvData[i][cVeh]][cToys] = false;

				for(new slotid = 0; slotid < 4; slotid++)
				{
					if(IsValidObject(vToys[pvData[i][cVeh]][slotid][vtObj]))
						DestroyObject(vToys[pvData[i][cVeh]][slotid][vtObj]);

					vToys[pvData[i][cVeh]][slotid][vtModelid] = 0;
					vToys[pvData[i][cVeh]][slotid][vtX] = 0.0;
					vToys[pvData[i][cVeh]][slotid][vtY] = 0.0;
					vToys[pvData[i][cVeh]][slotid][vtZ] = 0.0;

					vToys[pvData[i][cVeh]][slotid][vtRX] = 0.0;
					vToys[pvData[i][cVeh]][slotid][vtRY] = 0.0;
					vToys[pvData[i][cVeh]][slotid][vtRZ] = 0.0;
				}
			}

//MODELSELECTION
	if(listid == vtoyslist)
	{
		if(response)
		{
			new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];
			if(pvData[vehicleid][cToys] == false) MySQL_CreateVehicleToys(playerid);
				
			vToys[vehicleid][slotid][vtModelid] = modelid;
			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			InfoTD_MSG(playerid, 5000, "~g~~h~Object Attached!~n~~w~Adjust the position than click on the save icon!");
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli object ID %d.", ReturnName(playerid), modelid);
		}
		else return Servers(playerid, "Canceled buy vehicle toys");
	}
	return 1;
}
*/