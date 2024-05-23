
#include <YSI_Coding\y_hooks>

#define MAX_GARKOT 500

enum E_GARKOT
{
	Float:gkX,
	Float:gkY,
	Float:gkZ,
	Float:gkA,
	Float:sgkX,
	Float:sgkY,
	Float:sgkZ,
	Float:sgkA,

	gkInt,
	gkVW,
	//temp
	gkPickup,
	sgkPickup,
	STREAMER_TAG_AREA:gkArea,
	STREAMER_TAG_OBJECT:gkObject,
	Text3D:gkText,
	STREAMER_TAG_AREA:sgkArea,
	STREAMER_TAG_OBJECT:sgkObject,
}

new gkData[MAX_GARKOT][E_GARKOT],
Iterator:Garkot<MAX_GARKOT>;

Garkot_Save(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE garkot SET posx='%f', posy='%f', posz='%f', posa='%f', spawnx='%f', spawny='%f', spawnz='%f', spawna='%f', interior='%d', world='%d' WHERE id='%d'",
	gkData[id][gkX],
	gkData[id][gkY],
	gkData[id][gkZ],
	gkData[id][gkA],
	gkData[id][sgkX],
	gkData[id][sgkY],
	gkData[id][sgkZ],
	gkData[id][sgkA],
	gkData[id][gkInt],
	gkData[id][gkVW],
	id);

	return mysql_tquery(g_SQL, cQuery);
}

Garkot_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamic3DTextLabel(gkData[id][gkText]))
			DestroyDynamic3DTextLabel(gkData[id][gkText]);

		if(IsValidDynamicPickup(gkData[id][gkPickup]))
			DestroyDynamicPickup(gkData[id][gkPickup]);

		if(IsValidDynamicArea(gkData[id][gkArea]))
			DestroyDynamicArea(gkData[id][gkArea]);

		if(IsValidDynamicObject(gkData[id][gkObject]))
			DestroyDynamicObject(gkData[id][gkObject]);

		if(IsValidDynamicPickup(gkData[id][sgkPickup]))
			DestroyDynamicPickup(gkData[id][sgkPickup]);

		if(IsValidDynamicArea(gkData[id][sgkArea]))
			DestroyDynamicArea(gkData[id][sgkArea]);

		if(IsValidDynamicObject(gkData[id][sgkObject]))
			DestroyDynamicObject(gkData[id][sgkObject]);
		
		new str[540];
		format(str, sizeof(str), "Public Park %d", id);
		gkData[id][gkText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]-0.1, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,  gkData[id][gkVW], gkData[id][gkInt]);
		gkData[id][gkObject] = CreateDynamicObject(1316, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]-1, 0.0, 0.0, 0.0, gkData[id][gkVW], gkData[id][gkInt], -1, 50.00, 50.00);
		SetDynamicObjectMaterial(gkData[id][gkObject], 0, 18646, "matcolours", "white", 0x9900FF00);
		gkData[id][gkArea] = CreateDynamicCircle(gkData[id][gkX], gkData[id][gkY], 2.0, gkData[id][gkVW], gkData[id][gkInt], -1);

		gkData[id][sgkObject] = CreateDynamicObject(1316, gkData[id][sgkX], gkData[id][sgkY], gkData[id][sgkZ]-1, 0.0, 0.0, 0.0, gkData[id][gkVW], gkData[id][gkInt], -1, 50.00, 50.00); 
		SetDynamicObjectMaterial(gkData[id][sgkObject], 0, 18646, "matcolours", "white", 0xFF990000); 
		gkData[id][sgkArea] = CreateDynamicCircle(gkData[id][sgkX], gkData[id][sgkY], 2.0, gkData[id][gkVW], gkData[id][gkInt], -1);
	}
	return 1;
}

function LoadGarkot()
{
    static gkid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", gkid);
			cache_get_value_name_float(i, "posx", gkData[gkid][gkX]);
			cache_get_value_name_float(i, "posy", gkData[gkid][gkY]);
			cache_get_value_name_float(i, "posz", gkData[gkid][gkZ]);
			cache_get_value_name_float(i, "posa", gkData[gkid][gkA]);
			cache_get_value_name_float(i, "spawnx", gkData[gkid][sgkX]);
			cache_get_value_name_float(i, "spawny", gkData[gkid][sgkY]);
			cache_get_value_name_float(i, "spawnz", gkData[gkid][sgkZ]);
			cache_get_value_name_float(i, "spawna", gkData[gkid][sgkA]);
			cache_get_value_name_int(i, "interior", gkData[gkid][gkInt]);
			cache_get_value_name_int(i, "world", gkData[gkid][gkVW]);

			Garkot_Refresh(gkid);
			Iter_Add(Garkot, gkid);
		}
		printf("[Public Park] Number of Loaded: %d.", rows);
	}
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		foreach(new id : Garkot)
		{
			if(IsPlayerInDynamicArea(playerid, gkData[id][gkArea]))
			{
				if(areaid == gkData[id][gkArea])
				{
					showinfotombol(playerid, "Mengambil Kendaraan");
				}
			}
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		foreach(new id : Garkot)
		{
			if(IsPlayerInDynamicArea(playerid, gkData[id][sgkArea]))
			{
				if(areaid == gkData[id][sgkArea])
				{
					if(IsPlayerAndroid(playerid))
					{
						showinfotombolH(playerid, "Memasukan Kendaraan");
						InfoTD_MSG(playerid, 4000, "Tekan Klakson Untuk memasukan kendaraan");
					}
					else
					{
						showinfotombolH(playerid, "Memasukan Kendaraan");
					}
				}
			}
		}
	}
	return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	foreach(new id : Garkot)
	{
		if(areaid == gkData[id][gkArea])
		{
			HideInfoTombol(playerid);
		}
		if(areaid == gkData[id][sgkArea])
		{
			HideInfoTombol(playerid);
		}
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_YES) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		foreach(new id : Garkot)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]))
			{
				return callcmd::pickveh(playerid, "");
			}	
		}
	}
	if(PRESSED(KEY_CROUCH) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		foreach(new id : Garkot)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[id][sgkX], gkData[id][sgkY], gkData[id][sgkZ]))
			{
				return callcmd::parkveh(playerid, "");
			}	
		}
	}
	return 1;
}

CMD:createpark(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new gkid = Iter_Free(Garkot), query[512];

	if(gkid == -1)
		return Error(playerid, "You cant create more park point!");

	GetPlayerPos(playerid, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ]);
	GetPlayerFacingAngle(playerid, gkData[gkid][gkA]);
	gkData[gkid][gkInt] = GetPlayerInterior(playerid);
	gkData[gkid][gkVW] = GetPlayerVirtualWorld(playerid);

	Garkot_Refresh(gkid);
	Iter_Add(Garkot, gkid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO garkot SET id='%d'", gkid);
	mysql_tquery(g_SQL, query, "OnParkCreated", "i", gkid);
	return 1;
}

function OnParkCreated(gkid)
{
	Garkot_Save(gkid);
	return 1;
}


CMD:editpark(playerid, params[])
{
    static
        gkid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", gkid, type, string))
    {
        Usage(playerid, "/editpark [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, delete, spawn");
        return 1;
    }

    if(gkid < 0 || gkid >= MAX_GARKOT)
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Garkot, gkid))
		return Error(playerid, "The garkot you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ]);
		GetPlayerFacingAngle(playerid, gkData[gkid][gkA]);
		gkData[gkid][gkInt] = GetPlayerInterior(playerid);
		gkData[gkid][gkVW] = GetPlayerVirtualWorld(playerid);
        Garkot_Save(gkid);
		Garkot_Refresh(gkid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of garkot ID: %d.", pData[playerid][pAdminname], gkid);
    }
    else if(!strcmp(type, "delete",true))
    {
    	DestroyDynamicPickup(gkData[gkid][gkPickup]);
		
		gkData[gkid][gkX] = 0;
		gkData[gkid][gkY] = 0;
		gkData[gkid][gkZ] = 0;
		gkData[gkid][gkA] = 0;
		gkData[gkid][gkInt] = 0;
		gkData[gkid][gkVW] = 0;

		gkData[gkid][gkPickup] = -1;
		
		Iter_Remove(Garkot, gkid);

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM garkot WHERE id=%d", gkid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete garkot ID: %d.", pData[playerid][pAdminname], gkid);
    }
    else if(!strcmp(type, "spawn", true))
    {
		GetPlayerPos(playerid, gkData[gkid][sgkX], gkData[gkid][sgkY],gkData[gkid][sgkZ]);
		GetPlayerFacingAngle(playerid, gkData[gkid][sgkA]);
        Garkot_Save(gkid);
		Garkot_Refresh(gkid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the spawn vehicle point of Park ID: %d.", pData[playerid][pAdminname], gkid);
    }
	return 1;
}

CMD:parkveh(playerid, params[])
{
	new vehid = GetPlayerVehicleID(playerid), count = 0;

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return Error(playerid, "Kamu harus mengendarai kendaraan");

	foreach(new gkid : Garkot)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[gkid][sgkX], gkData[gkid][sgkY],gkData[gkid][sgkZ]))
		{
			count++;
			foreach(new ii : PVehicles)
			{
				if(vehid == pvData[ii][cVeh])
				{
					if(pvData[ii][cOwner] == pData[playerid][pID])
					{
						if(!IsValidVehicle(pvData[ii][cVeh]))
							return Error(playerid, "Your vehicle is not spanwed!");
						
						Vehicle_GetStatus(ii);
						RemoveVehicleToys(pvData[ii][cVeh]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("TimerUntogglePlayer", 8000, 0, "i", playerid);
						if(IsValidVehicle(pvData[ii][cVeh]))
							DestroyVehicle(pvData[ii][cVeh]);

						pvData[ii][cParkid] = gkid;
						pvData[ii][cVeh] = 0;

						Info(playerid, "Kendaraan %s milikmu telah di parkirkan pada park point id: %d.", GetVehicleModelName(pvData[ii][cModel]), pData[playerid][pGetPARKID]);
					}
					else return Error(playerid, "Kendaraan ini bukan milikmu");
				}
			}
		}
	}

	if(count < 1)
		return Error(playerid, "Kamu harus berada didekat point public garage");

	return 1;
}

ReturnPVehParkID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_PRIVATE_VEHICLE) return -1;
	foreach(new vehid : PVehicles)
	{
		if(pvData[vehid][cOwner] == pData[playerid][pID])
		{
			if(pvData[vehid][cParkid] == pData[playerid][pGetPARKID] && pvData[vehid][cClaim] == 0)
			{
	     		tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return vehid;
		  		}
	  		}
	    }
	}
	return -1;
}  

GetPVehINPARK(playerid)
{
	new tmpcount;
	foreach(new vehid : PVehicles)
	{
		if(pvData[vehid][cOwner] == pData[playerid][pID])
		{
			if(pvData[vehid][cParkid] == pData[playerid][pGetPARKID] && pvData[vehid][cClaim] == 0)
			{
     			tmpcount++;
     		}
	    }
	}
	return tmpcount;
}

CMD:pickveh(playerid, params[])
{
	new msg2[512], count = 0;
	format(msg2, sizeof(msg2), "ID\tModel\n");
	foreach(new gkid : Garkot)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ]))
		{
			count++;
			foreach(new i : PVehicles)
			{
				if(pvData[i][cOwner] == pData[playerid][pID])
				{
					if(gkData[gkid][gkX] == 0) return ShowNotifError(playerid, "Park point ini belum ada spawn point!", 8000);
					pData[playerid][pGetPARKID] = gkid;
					
					if(GetPVehINPARK(playerid) <= 0)
						return Error(playerid, "Tidak ada kendaraanmu yang terparkir disini");

					if(pvData[i][cParkid] == gkid && pvData[i][cClaim] == 0)
					{
						format(msg2, sizeof(msg2), "%s%d\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]));
					}
					new string[1024];
					format(string, sizeof(string), "Park Menu (ID: %d)", pData[playerid][pGetPARKID]);
					ShowPlayerDialog(playerid, GARKOT_PICKUP, DIALOG_STYLE_TABLIST_HEADERS, string, msg2, "Select", "Close");
				}
			}
		}
	}

	if(count < 1)
		return Error(playerid, "Kamu harus berada didekat point public garage");

	return 1;
}

CMD:gotopark(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return PermissionError(playerid);

	new gkid;
	if(sscanf(params, "d", gkid))
		return Usage(playerid, "/gotopark [park id]");

	if(!Iter_Contains(Garkot, gkid))
		return Error(playerid, "Invalid Park ID!");
	
	SetPlayerPos(playerid, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ] + 3.0);
	SetPlayerFacingAngle(playerid, gkData[gkid][gkA]);
	Info(playerid, "Anda telah diteleport menuju park id %d", gkid);
	return 1;
}

ReturnGarkotNearestID(playerid, slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_GARKOT) return -1;
	foreach(new id : Garkot)
	{
	    if(GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]) < 1000)
	    {
     		tmpcount++;
       		if(tmpcount == slot)
       		{
        		return id;
  			}
		}
	}
	return -1;
}

GetGarkotNearest(playerid)
{
	new tmpcount;
	foreach(new id : Garkot)
	{
		if(GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]) < 1000)
	    {
     		tmpcount++;
     	}
	}
	return tmpcount;
}

/*
------[DIALOG.pwn]------
	if(dialogid == GARKOT_PICKUP)
	{
		if(response)
		{
			new i = ReturnPVehParkID(playerid, (listitem + 1));
			new gkid = pData[playerid][pGetPARKID];

			pvData[i][cParkid] = -1;
			OnPlayerVehicleRespawn(i);

			pvData[i][cPosX] = gkData[gkid][gkVehX];
			pvData[i][cPosY] = gkData[gkid][gkVehY];
			pvData[i][cPosZ] = gkData[gkid][gkVehZ];
			pvData[i][cPosA] = gkData[gkid][gkVehA];
			SetValidVehicleHealth(pvData[i][cVeh], 2500);
			SetVehiclePos(pvData[i][cVeh], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ] + 3.0);
			SetVehicleZAngle(pvData[i][cVeh], pvData[i][cPosA]);
			SetVehicleFuel(pvData[i][cVeh], 1000);
			Info(playerid, "Kendaraan %s milikmu telah di keluarkan dari park point id: %d.", GetVehicleModelName(pvData[i][cModel]), gkid);
		}
	}
	return 1;
}

*/
