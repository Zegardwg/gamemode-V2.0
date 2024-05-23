
#define MAX_ATM 50

enum    E_ATM
{
	// loaded from db
	Float: atmX,
	Float: atmY,
	Float: atmZ,
	Float: atmRX,
	Float: atmRY,
	Float: atmRZ,
	atmInt,
	atmWorld,
	atmStock,
	atmStatus,
	// temp
	atmObjID,
	Text3D: atmLabel
}

new AtmData[MAX_ATM][E_ATM],
	Iterator:ATMS<MAX_ATM>;
	
GetClosestATM(playerid, Float: range = 3.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : ATMS)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, AtmData[i][atmX], AtmData[i][atmY], AtmData[i][atmZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist && GetPlayerInterior(playerid) == AtmData[i][atmInt] && GetPlayerVirtualWorld(playerid) == AtmData[i][atmWorld])
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}

function LoadATM()
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
  	{
 		new id, i = 0;
		while(i < rows)
		{
		    cache_get_value_name_int(i, "id", id);
			cache_get_value_name_float(i, "posx", AtmData[id][atmX]);
			cache_get_value_name_float(i, "posy", AtmData[id][atmY]);
			cache_get_value_name_float(i, "posz", AtmData[id][atmZ]);
			cache_get_value_name_float(i, "posrx", AtmData[id][atmRX]);
			cache_get_value_name_float(i, "posry", AtmData[id][atmRY]);
			cache_get_value_name_float(i, "posrz", AtmData[id][atmRZ]);
			cache_get_value_name_int(i, "interior", AtmData[id][atmInt]);
			cache_get_value_name_int(i, "world", AtmData[id][atmWorld]);
			cache_get_value_name_int(i, "stock", AtmData[id][atmStock]);
			cache_get_value_name_int(i, "status", AtmData[id][atmStatus]);
			Atm_Refresh(id);
			Iter_Add(ATMS, id);
	    	i++;
		}
		printf("[Dynamic ATM] Number of Loaded: %d.", i);
	}
}

Atm_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamicObject(AtmData[id][atmObjID]))
			DestroyDynamicObject(AtmData[id][atmObjID]);

		if(IsValidDynamic3DTextLabel(AtmData[id][atmLabel]))
			DestroyDynamic3DTextLabel(AtmData[id][atmLabel]);

		new str[1024];
		if(AtmData[id][atmStatus] == 0)
		{
			AtmData[id][atmObjID] = CreateDynamicObject(19324, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], AtmData[id][atmRX], AtmData[id][atmRY], AtmData[id][atmRZ], AtmData[id][atmWorld], AtmData[id][atmInt], -1, 90.0, 90.0);
			format(str, sizeof(str), "[ID: %d]\n"WHITE_E"Atm Status: "GREEN_LIGHT"Good\n"LG_E"'ALT' "WHITE_E"- to use this atm", id);
		}
		else
		{
			AtmData[id][atmObjID] = CreateDynamicObject(2943, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], AtmData[id][atmRX], AtmData[id][atmRY], AtmData[id][atmRZ], AtmData[id][atmWorld], AtmData[id][atmInt], -1, 90.0, 90.0);
			format(str, sizeof(str), "[ID: %d]\n"WHITE_E"Atm Status: "RED_E"Not Good\n"LG_E"'ALT' "WHITE_E"- to use this atm", id);
		}
		AtmData[id][atmLabel] = CreateDynamic3DTextLabel(str, COLOR_YELLOW, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ] + 0.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, AtmData[id][atmWorld], AtmData[id][atmInt], -1, 10.0);
	}
	return 1;
}

Atm_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE atms SET posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d', stock='%d', status='%d' WHERE id='%d'",
	AtmData[id][atmX],
	AtmData[id][atmY],
	AtmData[id][atmZ],
	AtmData[id][atmRX],
	AtmData[id][atmRY],
	AtmData[id][atmRZ],
	AtmData[id][atmInt],
	AtmData[id][atmWorld],
	AtmData[id][atmStock],
	AtmData[id][atmStatus],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

Atm_BeingEdited(id)
{
	if(!Iter_Contains(ATMS, id)) return 0;
	foreach(new i : Player) if(pData[i][EditingATMID] == id) return 1;
	return 0;
}

CMD:createatm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new id = Iter_Free(ATMS), query[512];
	if(id == -1) return Error(playerid, "Can't add any more ATM.");
 	new Float: x, Float: y, Float: z;
 	GetPlayerPos(playerid, x, y, z);
 	/*GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;*/
	
	AtmData[id][atmX] = x;
	AtmData[id][atmY] = y;
	AtmData[id][atmZ] = z;
	AtmData[id][atmRX] = AtmData[id][atmRY] = AtmData[id][atmRZ] = 0.0;
	AtmData[id][atmInt] = GetPlayerInterior(playerid);
	AtmData[id][atmWorld] = GetPlayerVirtualWorld(playerid);
	AtmData[id][atmStock] = 2000000;
	AtmData[id][atmStatus] = 0;
	
	Atm_Refresh(id);
	Iter_Add(ATMS, id);
	
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO atms SET id='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d', stock='%d', status='%d'", id, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], AtmData[id][atmRX], AtmData[id][atmRY], AtmData[id][atmRZ], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), AtmData[id][atmStock], AtmData[id][atmStatus]);
	mysql_tquery(g_SQL, query, "OnAtmCreated", "ii", playerid, id);
	return 1;
}

function OnAtmCreated(playerid, id)
{
	Atm_Save(id);
	Servers(playerid, "You has created ATM id: %d.", id);
	return 1;
}

CMD:editatm(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	if(pData[playerid][EditingATMID] != -1) return Error(playerid, "You're already editing.");

	static
    id,
     type[24],
      string[128];

    if(sscanf(params, "ds[24]S()[128]", id, type, string))
    {
        Usage(playerid, "/editatm [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} position, stock, status");
        return 1;
    }

	if(!Iter_Contains(ATMS, id))
		return Error(playerid, "Invalid ID.");

	if(!strcmp(type, "position", true))
	{
		if(!IsPlayerInRangeOfPoint(playerid, 30.0, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]))
			return Error(playerid, "You're not near the atm you want to edit.");

		pData[playerid][EditingATMID] = id;
		EditDynamicObject(playerid, AtmData[id][atmObjID]);
	}
    else if(!strcmp(type, "stock", true))
    {
    	new ammount;

        if(sscanf(string, "d", ammount))
            return Usage(playerid, "/editatm [id] [stock] [Ammount]");

        if(ammount < 0 || ammount > 2000000)
        	return Error(playerid, "jumlah stock tidak bisa kurang dari angka $0 dan lebih dari angka $2.000.000");

		AtmData[id][atmStock] = ammount;
		
        Atm_Save(id);
		SendAdminMessage(COLOR_RED, "%s has adjusted atm stock ID: %d to %s.", pData[playerid][pAdminname], id, FormatMoney(ammount));
	}
	else if(!strcmp(type, "status", true))
	{
		new statusid;
		if(sscanf(string, "d", statusid))
			return Usage(playerid, "/editatm [id] [statusid] (0. Good || 1. Not Good)");

		if(statusid < 0 || statusid > 1)
			return Error(playerid, "status id only 0 or 1");

		AtmData[id][atmStatus] = statusid;

		Atm_Refresh(id);
		Atm_Save(id);

		SendAdminMessage(COLOR_RED, "%s has adjusted atm status ID: %d to %d.", pData[playerid][pAdminname], id, statusid);
	}
	return 1;
}

CMD:removeatm(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/removeatm [id]");
	if(!Iter_Contains(ATMS, id)) return Error(playerid, "Invalid ID.");
	
	if(Atm_BeingEdited(id)) return Error(playerid, "Can't remove specified atm because its being edited.");
	DestroyDynamicObject(AtmData[id][atmObjID]);
	DestroyDynamic3DTextLabel(AtmData[id][atmLabel]);
	
	AtmData[id][atmX] = AtmData[id][atmY] = AtmData[id][atmZ] = AtmData[id][atmRX] = AtmData[id][atmRY] = AtmData[id][atmRZ] = 0.0;
	AtmData[id][atmInt] = AtmData[id][atmWorld] = 0;
	AtmData[id][atmObjID] = -1;
	AtmData[id][atmLabel] = Text3D: -1;
	Iter_Remove(ATMS, id);
	
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM atms WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus ID Atm %d.", id);
	return 1;
}

CMD:gotoatm(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotoatm [id]");
	if(!Iter_Contains(ATMS, id)) return Error(playerid, "ATM ID tidak ada.");
	
	SetPlayerPosition(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], 2.0);
    SetPlayerInterior(playerid, AtmData[id][atmInt]);
    SetPlayerVirtualWorld(playerid, AtmData[id][atmWorld]);
	Servers(playerid, "Teleport ke ID ATM %d", id);
	return 1;
}

CMD:atm(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
	if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
	new id = -1;
	id = GetClosestATM(playerid);
	
	if(id > -1)
	{
		if(AtmData[id][atmStatus] == 1)
			return Error(playerid, "Atm sedang rusak tidak dapat digunakan");

		for(new i = 0; i < 23; i++)
		{
			TextDrawShowForPlayer(playerid, ATMValrise[i]);
		}
		SelectTextDraw(playerid, COLOR_LBLUE);
		//new tstr[128];
		//format(tstr, sizeof(tstr), ""ORANGE_E"ATM Stock: "LB_E"%s", FormatMoney(AtmData[id][atmStock]));
		//ShowPlayerDialog(playerid, DIALOG_ATM, DIALOG_STYLE_LIST, tstr, "Check Balance\nWithdraw Money\nTransfer Money\nSign Paycheck", "Select", "Cancel");
	}
	return 1;
}

CMD:robatm(playerid, params[])
{
	if(pData[playerid][pLevel] < 7)
		return Error(playerid, "Kamu harus level 7 untuk melakukan ini");

	if(pData[playerid][pRobbing] != 0)
		return Error(playerid, "Kamu baru baru ini sudah melakukan perampokan, tunggu 1 hari untuk melakukannya kembali.");

	if(pData[playerid][pRobMember] < 2)
		return Error(playerid, "Kamu harus menginvite 2 orang untuk melakukan ini");

	if(pData[playerid][pRobLeader] < 1)
		return Error(playerid, "Hanya pemimpin rob yang bisa melakukan ini");

	if(pData[playerid][pFaction] != 0)
		return Error(playerid, "Anggota faction tidak bisa melakukan ini");

	new count;
	foreach(new i : Player)
	{
		if(pData[i][pFaction] == 1 && pData[i][pOnDuty])
		{
			count++;
		}
	}
	if(count < 2)
		return Error(playerid, "Harus ada 2 police yang on duty di kota");

	if(pData[playerid][pActivityTime] > 5)
		return Error(playerid, "Kamu masih memiliki activity progress");

	new id = -1;
	id = GetClosestATM(playerid);

	if(id > -1)
	{
		if(AtmData[id][atmStatus] == 1)
			return Error(playerid, "Atm rusak tidak bisa di rob");

		if(AtmData[id][atmStock] <= 0)
			return Error(playerid, "Atm ini tidak memilik stock uang yang cukup");

		if(pData[playerid][pRobAtmProgres] == -1)
		{
			foreach(new i : Player)
			{
				if(pData[i][pFaction] == 1)
				{
					DisablePlayerRaceCheckpoint(i);
					SendFactionMessage(1, COLOR_RADIO, "[ATM INFO] there is an atm robbery in the area %s!", GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
					SetPlayerRaceCheckpoint(i, 1, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], 0.0, 0.0, 0.0, 3.5);
					Info(i, "Lokasi perampokan ATM telah ditandai!");
				}
			}
		}
		TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid,"BOMBER","BOM_Plant", 4.0, 1, 0, 0, 1, 0, 1);
		pData[playerid][pRobAtmBar] = SetTimerEx("RobbingAtm", 1000, true, "id", playerid, id);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Robbing Atm..");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	}
	return 1;
}

function RobbingAtm(playerid, atmid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pRobAtmBar])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.5, AtmData[atmid][atmX], AtmData[atmid][atmY], AtmData[atmid][atmZ]))
			{
				if(pData[playerid][pRobAtmProgres] == -1)
				{
					TogglePlayerControllable(playerid, 1);
					Info(playerid, "Kamu berhasil membobol mesin ATM!");
					Info(playerid, "Gunakan /robatm sekali lagi untuk mengambil uang di mesin atm!");
					pData[playerid][pRobAtmProgres] = 0;

					KillTimer(pData[playerid][pRobAtmBar]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				}
				else
				{
					TogglePlayerControllable(playerid, 1);
					GivePlayerMoneyEx(playerid, AtmData[atmid][atmStock]);
					Info(playerid, "Kamu berhasil mendapatkan uang "GREEN_E"%s"WHITE_E" dari mesin ATM", FormatMoney(AtmData[atmid][atmStock]));
					AtmData[atmid][atmStock] = 0;
					AtmData[atmid][atmStatus] = 1;
					Atm_Refresh(atmid);
					Atm_Save(atmid);

					if(pData[playerid][pRobLeader] == 1)
					{
						foreach(new ii : Player) 
						{
							if(pData[ii][pMemberRob] == playerid)
							{
								Servers(ii, "* Pemimpin Perampokan anda telah berhasil mengambil uang dari mesin atm!");
								pData[ii][pMemberRob] = -1;
								pData[ii][pRobLeader] = -1;
								pData[ii][pRobMember] = 0;

								pData[ii][pRobbing] = 1;
								pData[ii][pRobbingTime] = gettime() + (86400 * 1);
							}
						}
					}
					pData[playerid][pMemberRob] = -1;
					pData[playerid][pRobLeader] = -1;
					pData[playerid][pRobMember] = 0;

					pData[playerid][pRobbing] = 1;
					pData[playerid][pRobbingTime] = gettime() + (86400 * 1);

					KillTimer(pData[playerid][pRobAtmBar]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				}
			}
			else
			{
				KillTimer(pData[playerid][pRobAtmBar]);
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.5, AtmData[atmid][atmX], AtmData[atmid][atmY], AtmData[atmid][atmZ]))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
			}
		}
	}
	return 1;
}