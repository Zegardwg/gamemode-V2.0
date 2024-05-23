//Trash Creating
#define MAX_TRASH 500

enum E_TRASH
{
	tmStock,
	Float:tmX,
	Float:tmY,
	Float:tmZ,
	Float:tmRX,
	Float:tmRY,
	Float:tmRZ,
	tmInt,
	tmVW,
	Sampah,
	//temp
	tmObj,
	Text3D:tmLabel,
	tmSeconds,
	tmTimer,
	STREAMER_TAG_AREA:tdArea,
	STREAMER_TAG_AREA:stdArea
};

new tmData[MAX_TRASH][E_TRASH],
Iterator:Trash<MAX_TRASH>;

GetNearbyTrash(playerid)
{
	for(new i = 0; i < MAX_TRASH; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, tmData[i][tmX], tmData[i][tmY], tmData[i][tmZ]))
	    {
	        return i;
	    }
	}
	return -1;
}

Trash_Save(id)
{
	new dquery[2048];
	format(dquery, sizeof(dquery), "UPDATE trashmaster SET stock='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d', sampah=%d WHERE id='%d'",
	tmData[id][tmStock],
	tmData[id][tmX],
	tmData[id][tmY],
	tmData[id][tmZ],
	tmData[id][tmRX],
	tmData[id][tmRY],
	tmData[id][tmRZ],
	tmData[id][tmInt],
	tmData[id][tmVW],
	tmData[id][Sampah],
	id);

	return mysql_tquery(g_SQL, dquery);
}

Trash_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamicArea(tmData[id][tdArea]))
			DestroyDynamicArea(tmData[id][tdArea]);

		if(IsValidDynamicArea(tmData[id][stdArea]))
			DestroyDynamicArea(tmData[id][stdArea]);

		if(IsValidDynamicObject(tmData[id][tmObj]))
			DestroyDynamicObject(tmData[id][tmObj]);

		if(IsValidDynamic3DTextLabel(tmData[id][tmLabel]))
			DestroyDynamic3DTextLabel(tmData[id][tmLabel]);

		new tstr[1024], status[128];

		if(tmData[id][tmStock] != 0)
		{
			status = "{00ff00}Full";
		}
		else if(tmData[id][tmStock] == 0)
		{
			status = "{ff0000}Empty";
		}
		else
		{
			status = "{ffffff}Unknown";
		}
		if(tmData[id][tmStock] > 0)
		{
			format(tstr, sizeof(tstr), "[TRASH ID: %d]\n{ffffff}Trash Status: %s\n{ffffff}Location: "GREEN_LIGHT"%s\n"WHITE_E"/unloadtrash - to unload trash", id, status, GetLocation(tmData[id][tmX], tmData[id][tmY], tmData[id][tmZ]));
			tmData[id][tmObj] = CreateDynamicObject(3035, tmData[id][tmX], tmData[id][tmY], tmData[id][tmZ], tmData[id][tmRX], tmData[id][tmRY], tmData[id][tmRZ], tmData[id][tmVW], tmData[id][tmInt], -1, 90.0, 90.0);
			tmData[id][tmLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, tmData[id][tmX], tmData[id][tmY], tmData[id][tmZ]+0.5, 10.0);
			tmData[id][tdArea] = CreateDynamicCircle(tmData[id][tmX], tmData[id][tmY], 2.0, tmData[id][tmVW], tmData[id][tmInt], -1);
			tmData[id][stdArea] = CreateDynamicCircle(tmData[id][tmX], tmData[id][tmY], 2.0, tmData[id][tmVW], tmData[id][tmInt], -1);
		}
		else
		{
			tmData[id][tmTimer] = SetTimerEx("RespawnTrash", 1000, true, "i", id);

			format(tstr, sizeof(tstr), "[TRASH ID: %d]\n{ffffff}Trash Status: %s\n"WHITE_E"Fill in: "GREEN_LIGHT"%s\n"WHITE_E"/unloadtrash - to unload trash", id, status, ConvertToMinutes(tmData[id][tmSeconds]));
			tmData[id][tmObj] = CreateDynamicObject(3035, tmData[id][tmX], tmData[id][tmY], tmData[id][tmZ], tmData[id][tmRX], tmData[id][tmRY], tmData[id][tmRZ], tmData[id][tmVW], tmData[id][tmInt], -1, 90.0, 90.0);
			tmData[id][tmLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, tmData[id][tmX], tmData[id][tmY], tmData[id][tmZ]+0.5, 10.0);
			UpdateDynamic3DTextLabelText(tmData[id][tmLabel], COLOR_YELLOW, tstr);
			tmData[id][tdArea] = CreateDynamicCircle(tmData[id][tmX], tmData[id][tmY], 2.0, tmData[id][tmVW], tmData[id][tmInt], -1);
			tmData[id][stdArea] = CreateDynamicCircle(tmData[id][tmX], tmData[id][tmY], 2.0, tmData[id][tmVW], tmData[id][tmInt], -1);
		}
	}
	return 1;
}

function RespawnTrash(id)
{
	new string[1024];
	if(tmData[id][tmSeconds] > 1) 
	{
	    tmData[id][tmSeconds]--;
	    
		format(string, sizeof(string), "[TRASH ID: %d]\n{ffffff}Trash Status: {ff0000}Empty\n"WHITE_E"Fill in: "GREEN_LIGHT"%s\n"WHITE_E"/unloadtrash - to unload trash", id, ConvertToMinutes(tmData[id][tmSeconds]));
		UpdateDynamic3DTextLabelText(tmData[id][tmLabel], COLOR_YELLOW, string);
	}
	else if(tmData[id][tmSeconds] == 1) 
	{
	    KillTimer(tmData[id][tmTimer]);

	    tmData[id][tmSeconds] = 0;
	    tmData[id][tmTimer] = -1;
	    tmData[id][tmStock] = 1;

	    Trash_Refresh(id);
	    Trash_Save(id);
	}
	return 1;
}

function LoadTrash()
{
    new rows = cache_num_rows();
 	if(rows)
  	{
   		new trashid;
		for(new i; i < rows; i++)
		{
  			cache_get_value_name_int(i, "id", trashid);
		    cache_get_value_name_int(i, "stock", tmData[trashid][tmStock]);
		    cache_get_value_name_float(i, "posx", tmData[trashid][tmX]);
		    cache_get_value_name_float(i, "posy", tmData[trashid][tmY]);
		    cache_get_value_name_float(i, "posz", tmData[trashid][tmZ]);
		   	cache_get_value_name_float(i, "posrx", tmData[trashid][tmRX]);
		    cache_get_value_name_float(i, "posry", tmData[trashid][tmRY]);
		    cache_get_value_name_float(i, "posrz", tmData[trashid][tmRZ]);
		    cache_get_value_name_int(i, "interior", tmData[trashid][tmInt]);
			cache_get_value_name_int(i, "world", tmData[trashid][tmVW]);
			cache_get_value_name_int(i, "sampah", tmData[trashid][Sampah]);
			if(tmData[trashid][tmStock] == 0)
			{
				tmData[trashid][tmSeconds] = 360;
			}
			Trash_Refresh(trashid);
			Iter_Add(Trash, trashid);
	    }
	    printf("[Trash Object] Number of loaded: %d.", rows);
	}
}

CMD:createtrash(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new trashid = Iter_Free(Trash), query[512];

	if(trashid == -1)
		return Error(playerid, "Can't add any more trash.");

	new Float: x, Float: y, Float: z, Float: a;
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;

	tmData[trashid][tmStock] = 1;
	tmData[trashid][Sampah] = 0;
	tmData[trashid][tmX] = x;
	tmData[trashid][tmY] = y;
	tmData[trashid][tmZ] = z;
	tmData[trashid][tmRX] = tmData[trashid][tmRY] = tmData[trashid][tmRX] = 0.0;
	tmData[trashid][tmInt] = GetPlayerInterior(playerid);
	tmData[trashid][tmVW] = GetPlayerVirtualWorld(playerid);

	SendStaffMessage(COLOR_RED, "%s telah membuat trash ID: %d.", pData[playerid][pAdminname], trashid);

	Trash_Refresh(trashid);
	Iter_Add(Trash, trashid);
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO trashmaster SET id='%d', stock='%d', sampah='%d'", trashid, tmData[trashid][tmStock], tmData[trashid][Sampah]);
	mysql_tquery(g_SQL, query, "OnTrashCreated", "i", trashid);
	return 1;
}

function OnTrashCreated(trashid)
{
	Trash_Save(trashid);
	return 1;
}

CMD:edittrash(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	static
	 trashid,
	  type[24],
	   string[128];

	if(sscanf(params, "ds[24]S()[128]", trashid, type, string))
	{
		Usage(playerid, "/edittrash [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} position, stock, delete");
        return 1;
	}

	if(!Iter_Contains(Trash, trashid)) 
		return Error(playerid, "Invalid ID.");

	if(!strcmp(type, "position", true))
	{
		if(pData[playerid][EditingTRASHID] != -1) 
			return Error(playerid, "You're already editing.");

    	if(!IsPlayerInRangeOfPoint(playerid, 30.0, tmData[trashid][tmX], tmData[trashid][tmY], tmData[trashid][tmZ])) 
			return Error(playerid, "You're not near the trash you want to edit.");

		pData[playerid][EditingTRASHID] = trashid;
		EditDynamicObject(playerid, tmData[trashid][tmObj]);
	}
	if(!strcmp(type, "stock", true))
	{
		new ammount;
		if(sscanf(string, "d", ammount))
			return Usage(playerid, "/edittrash [id] [stock] [ammount] (0.Empty 1.Full)");

		if(ammount < 0 || ammount > 1)
			return Error(playerid, "Ammoun only 0 or 1");

		if(ammount == 0)
        {
        	tmData[trashid][tmSeconds] = 360;
			tmData[trashid][tmStock] = 0;
		}
		if(ammount == 1)
		{
			KillTimer(tmData[trashid][tmTimer]);
		    tmData[trashid][tmSeconds] = 0;
	    	tmData[trashid][tmTimer] = -1;
			tmData[trashid][tmStock] = 1;
		}
		Trash_Save(trashid);
		Trash_Refresh(trashid);
		SendStaffMessage(COLOR_RED, "Staff %s mengubah status Trash ID %d menjadi %d.", pData[playerid][pAdminname], trashid, ammount);
	}
	else if(!strcmp(type, "delete", true))
	{
		new query[512];
		if(IsValidDynamicObject(tmData[trashid][tmObj]))
			DestroyDynamicObject(tmData[trashid][tmObj]);

		if(IsValidDynamic3DTextLabel(tmData[trashid][tmLabel]))
			DestroyDynamic3DTextLabel(tmData[trashid][tmLabel]);

		if(IsValidDynamicArea(tmData[trashid][stdArea]))
		DestroyDynamicArea(tmData[trashid][stdArea]);

		tmData[trashid][tmX] = tmData[trashid][tmY] = tmData[trashid][tmZ] = 0.0;
		tmData[trashid][tmRX] = tmData[trashid][tmRY] = tmData[trashid][tmRZ] = 0.0;
		tmData[trashid][tmInt] = tmData[trashid][tmVW] = 0;
		tmData[trashid][tmObj] = -1;
		tmData[trashid][tmLabel] = Text3D: -1;

		KillTimer(tmData[trashid][tmTimer]);
	    tmData[trashid][tmSeconds] = 0;
    	tmData[trashid][tmTimer] = -1;

		Iter_Remove(Trash, trashid);
		
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM trashmaster WHERE id=%d", trashid);
		mysql_tquery(g_SQL, query);
		SendStaffMessage(COLOR_RED, "Staff %s menghapus Trash ID %d.", pData[playerid][pAdminname], trashid);
	}
	return 1;
}

CMD:gototrash(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		PermissionError(playerid);

	new trashid;
	if(sscanf(params, "d", trashid))
		return Usage(playerid, "/gototrash [trashid]");

	if(!Iter_Contains(Trash, trashid))
		return Error(playerid, "The trash you specified ID of doesn't exist.");

	SetPlayerPos(playerid, tmData[trashid][tmX], tmData[trashid][tmY], tmData[trashid][tmZ]+1.5);
	SetPlayerInterior(playerid, tmData[trashid][tmInt]);
	SetPlayerVirtualWorld(playerid, tmData[trashid][tmVW]);

	Info(playerid, "Kamu telah diteleport menuju trashid %d", trashid);
	return 1;
}

//-------[SIDE JOB TRASHMASTER]-------

new HaveTrash[MAX_PLAYERS];
new VehTrashLog[MAX_VEHICLES]; //TEMPORER VEHICLE TRASH STORAGE
new TrashVeh[20];

AddTrashVehicle()
{
	TrashVeh[0] = AddStaticVehicleEx(408, 2458.38, -2116.32, 14.11, 2.46, 1, 1, VEHICLE_RESPAWN);
	TrashVeh[1] = AddStaticVehicleEx(408, 2465.29, -2116.22, 14.09, 1.79, 1, 1, VEHICLE_RESPAWN);
	TrashVeh[2] = AddStaticVehicleEx(408, 2472.31, -2116.53, 14.08, 359.74, 1, 1, VEHICLE_RESPAWN);
	TrashVeh[3] = AddStaticVehicleEx(408, 2479.58, -2116.34, 14.10, 359.75, 1, 1, VEHICLE_RESPAWN);
}

IsATrashVeh(carid)
{
	for(new v = 0; v < sizeof(TrashVeh); v++) {
	    if(carid == TrashVeh[v]) return 1;
	}
	return 0;
}

CMD:unloadtrash(playerid, params[])
{
	if(pData[playerid][pSideJob] == 5)
	{
	 	if(!IsATrashVeh(GetPVarInt(playerid, "LastVehicleID")))
	 		return ShowNotifError(playerid, "Kendaraan yang terakhir kamu kendarai bukanlah kendaraan trashmaster", 10000);

	 	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	 		return ShowNotifError(playerid, "Anda harus keluar dari kendaraan", 10000);

	 	if(VehTrashLog[GetPVarInt(playerid, "LastVehicleID")] >= 10)
	 	{
	 		DisablePlayerRaceCheckpoint(playerid);
	 		Info(playerid, "Kendaraanmu sudah penuh dengan sampah, kamu harus membuang sampah terlebih dahulu");
	 		Info(playerid, "Ikuti checkpoint yang sudah ditandai untuk membuang sampah");
	 		SetPlayerRaceCheckpoint(playerid, 1, 2436.29, -2113.88, 13.54, 0.0, 0.0, 0.0, 3.5);
	 		return 1;
	 	}

	 	if(HaveTrash[playerid] == 1)
	 		return ShowNotifError(playerid, "Kamu sedang memegang sampah", 10000);

	 	foreach(new trashid : Trash)
	 	{
	 		if(IsPlayerInRangeOfPoint(playerid, 1.5, tmData[trashid][tmX], tmData[trashid][tmY], tmData[trashid][tmZ]))
	 		{
	 			if(!IsPlayerInRangeOfPoint(playerid, 1.5, tmData[trashid][tmX], tmData[trashid][tmY], tmData[trashid][tmZ]))
	 				return ShowNotifError(playerid, "Kamu harus berada di dekat tempat sampah", 10000);

	 			if(tmData[trashid][tmStock] <= 0)
	 				return ShowNotifError(playerid, "Trash ini tidak memiliki sampah", 10000);

	 			if(pData[playerid][pLoading] == true)
	 				return ShowNotifError(playerid, "Kamu masih unload trash", 10000);

	 			if(pData[playerid][pActivityTime] > 5)
	 				return ShowNotifError(playerid, "Kamu masih memiliki activity progress", 10000);

	 			pData[playerid][pActivityTime] = 100;
	 			pData[playerid][pLoading] = true;
	 			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
	 			pData[playerid][pSampah] = SetTimerEx("UnloadTrash", 5000, false, "ii", playerid, trashid);
	 			//Showbar(playerid, 5, "MENGAMBIL SAMPAH", "UnloadTrash");
	 			ShowProgressbar(playerid, "MENGAMBIL SAMPAH", 5);
	 		}
	 	}
	}
	else return ShowNotifError(playerid, "Kamu belum memulai pekerjaan sidejob trash master", 10000);
	return 1;
}

/*function UnloadTrash(playerid, id)
{
	pData[playerid][pActivityTime] = 0;
	HaveTrash[playerid] = 1;
	tmData[id][tmSeconds] = 360;
	tmData[id][tmStock] = 0;
	SetPlayerAttachedObject(playerid, 9, 1264, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
	TogglePlayerControllable(playerid, 1);
	ClearAnimations(playerid);
	pData[playerid][pLoading] = false;
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
	GameTextForPlayer(playerid, "~w~SELESAI!", 3000, 3);
	Info(playerid, "Kamu berhasil mengambil sampah");
	Info(playerid, "Kamu taruh sampah di truck sampah /loadtrash");
	Trash_Refresh(id);
	Trash_Save(id);
}*/

function UnloadTrash(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pSampah])) return 0;
	if(pData[playerid][pSideJob] == 5)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			foreach(new trashid : Trash)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.5, tmData[trashid][tmX], tmData[trashid][tmY], tmData[trashid][tmZ]))
				{
					pData[playerid][pActivityTime] = 0;
					HaveTrash[playerid] = 1;
					tmData[id][tmSeconds] = 360;
					tmData[id][tmStock] = 0;
					SetPlayerAttachedObject(playerid, 9, 1264, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					TogglePlayerControllable(playerid, 1);
					ClearAnimations(playerid);
					pData[playerid][pLoading] = false;
					ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
					GameTextForPlayer(playerid, "~w~SELESAI!", 3000, 3);
					Info(playerid, "Kamu berhasil mengambil sampah");
					Info(playerid, "Kamu taruh sampah di truck sampah /loadtrash");
					Trash_Refresh(id);
					Trash_Save(id);
				}
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			foreach(new trashid : Trash)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.5, tmData[trashid][tmX], tmData[trashid][tmY], tmData[trashid][tmZ]))
				{
					pData[playerid][pActivityTime] += 5;
				}
			}
		}
	}
	return 1;
}

CMD:loadtrash(playerid, params[])
{
	if(pData[playerid][pSideJob] == 5)
	{
		if(!IsATrashVeh(GetPVarInt(playerid, "LastVehicleID")))
	 		return ShowNotifError(playerid, "Kendaraan yang terakhir kamu kendarai bukanlah kendaraan trashmaster", 10000);

		if(HaveTrash[playerid] == 0)
	 		return ShowNotifError(playerid, "Kamu belum memegang sampah", 10000);

		new Float:x, Float:y, Float:z;
		GetVehicleBoot(GetPVarInt(playerid, "LastVehicleID"), x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid, 4.5, x, y, z))
			return ShowNotifError(playerid, "Kamu harus berada di bagian belakang kendaraan trashmaster yang kamu bawa", 10000);
		{
			HaveTrash[playerid] = 0;
			VehTrashLog[GetPVarInt(playerid, "LastVehicleID")] += 1;
			RemovePlayerAttachedObject(playerid, 9);
			Info(playerid, "Kamu berhasil menaruh sampah kedalam kendaraan, total muatan sampah di kendaraan: "GREEN_E"%d/5", VehTrashLog[GetPVarInt(playerid, "LastVehicleID")]);
		}
	}
	else return ShowNotifError(playerid, "Kamu belum memulai pekerjaan sidejob trash master", 10000);
	return 1;
}

CMD:throwgarbage(playerid, params[])
{
	if(pData[playerid][pSideJob] == 5)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.5, 2436.29, -2113.88, 13.54))
		{
			new vehid = GetPlayerVehicleID(playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				return ShowNotifError(playerid, "Kamu harus menaiki kendaraan", 10000);

			if(!IsATrashVeh(vehid))
				return ShowNotifError(playerid, "Kendaraan ini bukanlah kendaraan trash master", 10000);

			if(VehTrashLog[vehid] <= 0)
				return ShowNotifError(playerid, "Kendaraan ini tidak mengangkut sampah", 10000);

			new pay = VehTrashLog[vehid] * sjtrashmaster;
			Info(playerid, "Kamu mendapatkan uang sejumlah "GREEN_LIGHT"%s"WHITE_E"dengan menjual"GREEN_LIGHT"%d"WHITE_E" muatan sampah di kendaraan", FormatMoney(pay), VehTrashLog[vehid]);
			VehTrashLog[vehid] = 0;
			pData[playerid][pSideJob] = 0;
			pData[playerid][pSideJobTime] = 250;

			DisablePlayerCheckpoint(playerid);
			AddPlayerSalary(playerid, "Sidejob(Trash Master)", pay);
			Info(playerid, "Sidejob(Trash Master) telah masuk ke pending salary anda!");
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehid);
		}
		else return ShowNotifError(playerid, "Kamu tidak berada ditempat pembuangan sampah", 10000);
	}
	else return ShowNotifError(playerid, "Kamu belum memulai pekerjaan sidejob trash master", 10000);
	return 1;
}

CMD:checktrash(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	foreach(new tid : Trash)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.5, tmData[tid][tmX], tmData[tid][tmY], tmData[tid][tmZ]))
		{
			Info(playerid, "Near trash ID || D : %d || I : %i", tid, tid);
		}
	}
	return 1;
}