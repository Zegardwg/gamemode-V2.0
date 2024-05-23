//Workshop System
#define MAX_WORKSHOP 50

enum E_WORKSHOP
{
	wName[50],
	wLeader[MAX_PLAYER_NAME],
	wPrice,
	wStatus,
	wMoney,
	wComponent,
	Float:wExtposX,
	Float:wExtposY,
	Float:wExtposZ,
	Float:wExtposA,
	//Not Save
	Text3D:wLabel,
	wPickup,
	wIcon
};

new wData[MAX_WORKSHOP][E_WORKSHOP],
	Iterator:Workshop<MAX_WORKSHOP>;

Workshop_Save(id)
{
	new dquery[2048];
	format(dquery, sizeof(dquery), "UPDATE workshop SET name='%s', leader='%s', price='%d', status='%d',extposx='%f', extposy='%f', extposz='%f', extposa='%f'",
	wData[id][wName],
	wData[id][wLeader],
	wData[id][wPrice],
	wData[id][wStatus],
	wData[id][wExtposX],
	wData[id][wExtposY],
	wData[id][wExtposZ],
	wData[id][wExtposA]);

	format(dquery, sizeof(dquery), "%s, money='%d', component='%d' WHERE ID='%d'",
	dquery,
	wData[id][wMoney],
	wData[id][wComponent],
	id);

	return mysql_tquery(g_SQL, dquery);
}


Workshop_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamic3DTextLabel(wData[id][wLabel]))
            DestroyDynamic3DTextLabel(wData[id][wLabel]);

        if(IsValidDynamicPickup(wData[id][wPickup]))
            DestroyDynamicPickup(wData[id][wPickup]);

        if(IsValidDynamicMapIcon(wData[id][wIcon]))
        	DestroyDynamicMapIcon(wData[id][wIcon]);

		new status[128];
		if(wData[id][wStatus] == 1)
		{
			status = "{FF0000}Closed";
		}
		else
		{
			status = "{00FF00}Opened";
		}
		new tstr[254];
        if(strcmp(wData[id][wLeader], "-"))
        {
			format(tstr, sizeof(tstr), "[WORKSHOP ID: %d]\n{ffffff}Workshop Name: {00ff00}%s\n{ffffff}Workshop Status: %s\n{ffffff}Owned by %s\n/wsstorage ", id, wData[id][wName], status, wData[id][wLeader]);
            wData[id][wPickup] = CreateDynamicPickup(1239, 23, wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]+0.2, 0, 0, _, 50.0);
            wData[id][wLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]+0.7, 5.0);
            wData[id][wIcon] = CreateDynamicMapIcon(wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ], 27, -1, -1, -1, -1, 100.0);
        }
		else
		{
			format(tstr, sizeof(tstr), "[WORKSHOP ID: %d]\n{00FF00}This workshop for sell\n{FFFFFF}Location: {FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n"WHITE_E"Type /buy to purchase", id, GetLocation(wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]), FormatMoney(wData[id][wPrice]));
            wData[id][wPickup] = CreateDynamicPickup(1239, 23, wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]+0.2, 0, 0, _, 50.0);
            wData[id][wLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]+0.7, 5.0);
            wData[id][wIcon] = CreateDynamicMapIcon(wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ], 27, -1, -1, -1, -1, 100.0);
		}
	}		
	return 1;
}

/*LoadWorkshop()
{
	mysql_tquery(g_SQL, "SELECT ID,name,leader,motd,color,extposx,extposy,extposz,extposa,intposx,intposy,intposz,intposa,wInt,safex,safey,safez,money,marijuana FROM WORKSHOPS ORDER BY ID", "LoadWorkshopData");
}*/
Player_OwnsWorkshop(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(wData[id][wLeader], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_WorkshopCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Workshop)
	{
		if(Player_OwnsWorkshop(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

function LoadWorkshop()
{
    new rows = cache_num_rows();
 	if(rows)
  	{
   		new wid, name[50], leader[MAX_PLAYER_NAME];
		for(new i; i < rows; i++)
		{
  			cache_get_value_name_int(i, "ID", wid);
	    	cache_get_value_name(i, "name", name);
			format(wData[wid][wName], 50, name);
		    cache_get_value_name(i, "leader", leader);
			format(wData[wid][wLeader], MAX_PLAYER_NAME, leader);
			cache_get_value_name_int(i, "price", wData[wid][wPrice]);
			cache_get_value_name_int(i, "status", wData[wid][wStatus]);
		    cache_get_value_name_float(i, "extposx", wData[wid][wExtposX]);
		    cache_get_value_name_float(i, "extposy", wData[wid][wExtposY]);
		    cache_get_value_name_float(i, "extposz", wData[wid][wExtposZ]);
		    cache_get_value_name_float(i, "extposa", wData[wid][wExtposA]);
			cache_get_value_name_int(i, "money", wData[wid][wMoney]);
			cache_get_value_name_int(i, "component", wData[wid][wComponent]);

			/*for (new j = 0; j < 10; j ++)
			{
				format(str, 24, "Weapon%d", j + 1);
				cache_get_value_name_int(i, str, wData[wid][wGun][j]);

				format(str, 24, "Ammo%d", j + 1);
				cache_get_value_name_int(i, str, wData[wid][wAmmo][j]);
			}*/
			Workshop_Refresh(wid);
			Iter_Add(Workshop, wid);
	    }
	    printf("[Workshop] Number of Workshop loaded: %d.", rows);
	}
}

//----------[ Workshop Commands ]-----------
CMD:createws(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new query[512];
	new wid = Iter_Free(Workshop);

	if(wid == -1) return Error(playerid, "You cant create more door!");
	new price;

	if(sscanf(params, "dd", price)) return Usage(playerid, "/createws [price]");

	format(wData[wid][wLeader], 128, "-");
	format(wData[wid][wName], 128, "No Name");

	wData[wid][wPrice] = price;
	GetPlayerPos(playerid, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]);

	GetPlayerFacingAngle(playerid, wData[wid][wExtposA]);

	wData[wid][wMoney] = 0;
	wData[wid][wStatus] = 1;
	wData[wid][wComponent] = 0;
  	
  	Workshop_Refresh(wid);

	Iter_Add(Workshop, wid);
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO workshop SET ID='%d', leader='%s', name='%s', price='%d'", wid, wData[wid][wLeader], wData[wid][wName], wData[wid][wPrice]);
	mysql_tquery(g_SQL, query, "OnWorkshopCreated", "i", wid);
	return 1;
}

function OnWorkshopCreated(wid)
{
	Workshop_Save(wid);
	return 1;
}

CMD:wsdelete(playerid, params[])
{
 	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

    new wid, query[128];
	if(sscanf(params, "i", wid)) return Usage(playerid, "/wsdelete [wid]");
	if(!Iter_Contains(Workshop, wid)) return Error(playerid, "The you specified ID of doesn't exist.");
	
    format(wData[wid][wName], 50, "None");
	format(wData[wid][wLeader], 50, "None");

	wData[wid][wExtposX] = 0;
	wData[wid][wExtposY] = 0;
	wData[wid][wExtposZ] = 0;
	wData[wid][wExtposA] = 0;

	wData[wid][wComponent] = 0;
	wData[wid][wMoney] = 0;
	
	DestroyDynamic3DTextLabel(wData[wid][wLabel]);
	DestroyDynamicPickup(wData[wid][wPickup]);
	DestroyDynamicMapIcon(wData[wid][wIcon]);
	
	Iter_Remove(Workshop, wid);
	
	mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET workshop=-1,workshoprank=0,duty=0 WHERE workshop=%d", wid);
	mysql_tquery(g_SQL, query);
	
	foreach(new ii : Player)
	{
 		if(pData[ii][pWorkshop] == wid)
   		{
			pData[ii][pWorkshop]= -1;
			pData[ii][pWorkshopRank] = 0;
		}
	}

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM workshop WHERE ID=%d", wid);
	mysql_tquery(g_SQL, query);
    SendStaffMessage(COLOR_RED, "Admin %s telah menghapus Workshop ID: %d.", pData[playerid][pAdminname], wid);
	return 1;
}

CMD:gotows(playerid, params[])
{
	new wid;
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", wid))
		return Usage(playerid, "/gotows [id]");
	if(!Iter_Contains(Workshop, wid)) return Error(playerid, "The Workshop you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ], wData[wid][wExtposA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to workshop id %d", wid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	return 1;
}

CMD:wsedit(playerid, params[])
{
    static
        wid,
        type[24],
        string[128],
		otherid;

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", wid, type, string))
    {
        Usage(playerid, "/wsedit [id] [name]");
        Names(playerid, "location, name, leader, position, money, component");
        return 1;
    }

    if((wid < 0 || wid >= MAX_WORKSHOP))
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Workshop, wid)) 
		return Error(playerid, "The you specified ID of doesn't exist.");

    if(!strcmp(type, "name", true))
    {
        new name[50];

        if(sscanf(string, "s[50]", name))
            return Usage(playerid, "/wsedit [id] [name] [Workshop Name]");

        format(wData[wid][wName], 50, name);
		Workshop_Save(wid);
		Workshop_Refresh(wid);

        SendStaffMessage(COLOR_LRED, "Admin %s has changed the Workshop name ID: %d to: %s.", pData[playerid][pAdminname], wid, name);
    }
    else if(!strcmp(type, "leader", true))
    {
        if(sscanf(string, "d", otherid))
            return Usage(playerid, "/wsedit [id] [leader] [playerid]");
		
		if(otherid == INVALID_PLAYER_ID)
			return Error(playerid, "invalid player wid");

        format(wData[wid][wLeader], 50, pData[otherid][pName]);
        pData[otherid][pWorkshop] = wid;
        pData[otherid][pWorkshopRank] = 6;
		Workshop_Save(wid);
		Workshop_Refresh(wid);

        SendStaffMessage(COLOR_LRED, "Admin %s has changed the Workshop leader ID: %d to: %s.", pData[playerid][pAdminname], wid, pData[otherid][pName]);
    }
    else if(!strcmp(type, "location", true))
    {
    	GetPlayerFacingAngle(playerid, wData[wid][wExtposA]);
        GetPlayerPos(playerid, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]);
        Workshop_Save(wid);
		Workshop_Refresh(wid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the Workshop safepos ID: %d.", pData[playerid][pAdminname], wid);
    }
    else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return Usage(playerid, "/wsedit [id] [money] [ammount]");

        wData[wid][wMoney] = money;
		
        Workshop_Save(wid);
		Workshop_Refresh(wid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the Workshop money ID: %d to %s.", pData[playerid][pAdminname], wid, FormatMoney(money));   
	}
	else if(!strcmp(type, "component", true))
    {
        new component;

        if(sscanf(string, "d", component))
            return Usage(playerid, "/wsedit [id] [component] [ammount]");

        wData[wid][wComponent] = component;
		
        Workshop_Save(wid);
		Workshop_Refresh(wid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the Workshop component ID: %d to %d.", pData[playerid][pAdminname], wid, component);   
	}
    return 1;
}

CMD:wshelp(playerid)
{
	if(pData[playerid][pWorkshop] == -1)
		return Error(playerid, "Kamu bukan anggota workshop");

	new str[3500];
	strcat(str, "Commands\tInformation\n");
	strcat(str, "/wsstorage\tUntuk membuka menu/locker list pada workshop\n"); 
	strcat(str, "/wsinvite\tUntuk menginvite seseorang menjadi anggota workshop\n");
	strcat(str, "/wskick\tUntuk mengeluarkan seseorang dari anggota workshop\n");
	strcat(str, "/wssetrank\tUntuk mengatur rank anggota workshop\n");
	strcat(str, "/wservice\tUntuk membuka menu modif kendaraan\n");
	strcat(str, "/lockws\tUntuk merubah status Open/Closed pada worskhop");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Workshop Commands", str, "Close","");
	return true;
}

CMD:wsstorage(playerid, params[])
{
	if(pData[playerid][pWorkshop] == -1)
		return Error(playerid, "Kamu bukan anggota workshop!");

	new wsid = pData[playerid][pWorkshop];

	if(IsPlayerInRangeOfPoint(playerid, 2.5, wData[wsid][wExtposX], wData[wsid][wExtposY], wData[wsid][wExtposZ]))
	{
		new string[254];
		format(string, sizeof(string), "Workshop Info\nToggle Duty\nMoney Storage ({00FF00}$%d)\nComponent Storage(%d)\nCreate Repairkit", wData[wsid][wMoney], wData[wsid][wComponent]);
		ShowPlayerDialog(playerid, WORKSHOP_MENU, DIALOG_STYLE_LIST, "Workshop Menu", string,"Next","Close");
	}
	else return Error(playerid, "Kamu bukan anggota workshop ini!");
	return 1;
}

CMD:lockws(playerid, params[])
{
	if(pData[playerid][pWorkshopRank] < 5)
		return Error(playerid, "Hanya rank 5 dan 6 yang bisa menutup workshop");

	foreach(new wid : Workshop)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
		{
			if(!Player_OwnsWorkshop(playerid, wid)) return Error(playerid, "You don't own this workshop.");
			if(!wData[wid][wStatus])
			{
				wData[wid][wStatus] = 1;
				Workshop_Save(wid);
				Workshop_Refresh(wid);

				InfoTD_MSG(playerid, 4000, "You have ~r~closed~w~ your workshop!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				wData[wid][wStatus] = 0;
				Workshop_Save(wid);
				Workshop_Refresh(wid);

				InfoTD_MSG(playerid, 4000,"You have ~g~opened~w~ your workshop!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

CMD:wsinvite(playerid, params[])
{
	if(pData[playerid][pWorkshop] == -1)
		return Error(playerid, "Kamu tidak bergabung workshop manapun");
		
	if(pData[playerid][pWorkshopRank] < 5)
		return Error(playerid, "You must workshop rank 5 - 6!");
	
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/wsinvite [playerid/PartOwName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
		
	if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");
	
	if(pData[otherid][pWorkshop] != -1)
		return Error(playerid, "Player tersebut sudah bergabung workshop lain!");
		
	if(pData[otherid][pFaction] != 0)
		return Error(playerid, "Kamu tidak bisa menginvite anggota faction");

	pData[otherid][pWsInvite] = pData[playerid][pWorkshop];
	pData[otherid][pWsOffer] = playerid;
	Servers(playerid, "Anda telah menginvite %s untuk menjadi anggota workshop.", pData[otherid][pName]);
	Servers(otherid, "%s telah menginvite anda untuk menjadi anggota workshop. Type: /accept workshop", pData[playerid][pName]);
	return 1;
}

CMD:wskick(playerid, params[])
{
	if(pData[playerid][pWorkshop] == -1)
		return Error(playerid, "You are not in Workshop!");
		
	if(pData[playerid][pWorkshopRank] < 5)
		return Error(playerid, "You must Workshop level 5 - 6!");
	
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/wskick [playerid/PartOwName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pWorkshopRank] > pData[playerid][pWorkshopRank])
		return Error(playerid, "You cant kick him.");
		
	pData[otherid][pWorkshopRank] = 0;
	pData[otherid][pWorkshop] = -1;
	Servers(playerid, "Anda telah mengeluarkan %s dari anggota Workshop.", pData[otherid][pName]);
	Servers(otherid, "%s telah mengeluarkan anda dari anggota Workshop.", pData[playerid][pName]);
	return 1;
}

CMD:wssetrank(playerid, params[])
{
	new rank, otherid;
	if(pData[playerid][pWorkshopRank] < 6)
		return Error(playerid, "You must Workshop leader!");
		
	if(sscanf(params, "ud", otherid, rank))
        return Usage(playerid, "/wssetrank [playerid/PartOwName] [rank 1-6]");
	
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pWorkshop] != pData[playerid][pWorkshop])
		return Error(playerid, "This player is not in your Workshop!");
	
	if(rank < 1 || rank > 6)
		return Error(playerid, "rank must 1 - 6 only");
	
	pData[otherid][pWorkshopRank] = rank;
	Servers(playerid, "You has set %s Workshop rank to level %d", pData[otherid][pName], rank);
	Servers(otherid, "%s has set your Workshop rank to level %d", pData[playerid][pName], rank);
	return 1;
}

CMD:wservice(playerid, params[])
{
	if(pData[playerid][pWorkshop] == -1)
		return Error(playerid, "Kamu bukan pekerja workshop");
	{
		if(pData[playerid][pOnDuty] == 0)
			return Error(playerid, "Kamu harus on duty");
		{
			if(pData[playerid][pMechVeh] == INVALID_VEHICLE_ID)
			{
				new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
				
				if(vehicleid == INVALID_VEHICLE_ID) return Error(playerid, "You not in near any vehicles.");
				if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
				
				Info(playerid, "Don't move from your position or you will failed to checking this vehicle!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pMechanic] = SetTimerEx("CheckCar", 1000, true, "dd", playerid, vehicleid);
				//Showbar(playerid, 20, "CHECK KENDARAAN", "CheckCar");
				ShowProgressbar(playerid, "CHECK KENDARAAN", 20);
				return 1;
			}
			
			if(GetNearestVehicleToPlayer(playerid, 3.5, false) == pData[playerid][pMechVeh])
			{
				new Dstring[800], Float:health, engine;
				new panels, doors, light, tires, body;
				GetVehicleHealth(pData[playerid][pMechVeh], health);
				if(health > 1000.0) health = 1000.0;
				if(health > 0.0) health *= -1;
				engine = floatround(health, floatround_round) / 10 + 100;
				
				GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
			    new cpanels = panels / 1000000;
			    new lights = light / 2;
			    new pintu;
			    if(doors != 0) pintu = 5;
			    if(doors == 0) pintu = 0;
			    body = cpanels + lights + pintu + 20;
				/*if(health >= 1000)
				{
					engine = 5;
				}
				else if(health >= 800)
				{
					engine = 10;
				}
				else if(health >= 700)
				{
					engine = 20;
				}
				else if(health >= 600)
				{
					engine = 30;
				}
				else if(health >= 500)
				{
					engine = 40;
				}
				else if(health <= 400)
				{
					engine = 50;
				}*/
				format(Dstring, sizeof(Dstring), "Service Name\tComponent\n");
				format(Dstring, sizeof(Dstring), "%sEngine Fix\t%d\n", Dstring, engine);
				format(Dstring, sizeof(Dstring), "%sBody Fix\t%d\n", Dstring, body);
				format(Dstring, sizeof(Dstring), "%sSpray Car\t12\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sPaint Job Car\t30\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sWheels Car\t25\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sSpoiler Car\t21\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sHood Car\t21\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sVents Car\t21\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sLights Car\t21\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sExhausts\t24\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sFront bumpers\t30\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sRear Bumpers\t30\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sRoofs Car\t21\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sSide skirts\t27\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sBullbars\t15\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sStereo\t45\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sHydraulics\t45\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sNitro 1\t75\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sNitro 2\t112\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sNitro 3\t150\n", Dstring);
				format(Dstring, sizeof(Dstring), "%sNeon\t135", Dstring);
				ShowPlayerDialog(playerid, WORKSHOP_SERVICE, DIALOG_STYLE_TABLIST_HEADERS, "Workshop Service", Dstring, "Service", "Cancel");
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pActivityTime] = 0;
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
	}
	return 1;
}

function WorkshopCreateRepairkit(playerid, wsid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMechanic])) return 0;
	if(pData[playerid][pWorkshop] == wsid)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.5, wData[wsid][wExtposX], wData[wsid][wExtposY], wData[wsid][wExtposZ]))
			{
				TogglePlayerControllable(playerid, 1);
				Info(playerid, "Kamu telah selesai membuat 1 repairkit.");
				InfoTD_MSG(playerid, 8000, "Succes Created!");
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pEnergy] -= 3;
				pData[playerid][pComponent] -= 100;
				pData[playerid][pRepairkit] += 1;
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.5, wData[wsid][wExtposX], wData[wsid][wExtposY], wData[wsid][wExtposZ]))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
			}
		}
	}
	return 1;
}

function ShowWorkshopInfo(playerid)
{
	new rows = cache_num_rows();
 	if(rows)
  	{
 		new wname[50],
 			wleader[50],
			wmoney,
			string[512];
			
		cache_get_value_index(0, 0, wname);
		cache_get_value_index(0, 1, wleader);
		cache_get_value_index_int(0, 2, wmoney);

		format(string, sizeof(string), "Workshop ID: %d\nWorkshop Name: %s\nWorkshop Leader: %s\nWorkshop Money: %s",
		pData[playerid][pWorkshop], wname, wleader, FormatMoney(wmoney));
		
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Workshop Info", string, "Okay", "");
	}
}

function ShowWorkshopMember(playerid)
{
	new rows = cache_num_rows(), pid, username[50], frank, query[1048];
 	if(rows)
  	{
		for(new i = 0; i != rows; i++)
		{
			cache_get_value_index(i, 0, username);
			pid = GetID(username);
			
			format(query, sizeof(query), "%s"WHITE_E"%d. %s ", query, (i+1), username);
			
			if(IsPlayerConnected(pid))
				strcat(query, ""GREEN_E"(ONLINE)");
			else
				strcat(query, ""RED_E"(OFFLINE) ");
			
			cache_get_value_index_int(i, 1, frank);
			if(frank == 1)
			{
				strcat(query, ""WHITE_E"Trial Service(1)");
			}
			else if(frank == 2)
			{
				strcat(query, ""WHITE_E"Mechanic(2)");
			}
			else if(frank == 3)
			{
				strcat(query, ""WHITE_E"Pro Mechanic(3)");
			}
			else if(frank == 4)
			{
				strcat(query, ""WHITE_E"Staff(4)");
			}
			else if(frank == 5)
			{
				strcat(query, ""WHITE_E"Assistan Manager(5)");
			}
			else if(frank == 6)
			{
				strcat(query, ""WHITE_E"Manager(6)");
			}
			else
			{
				strcat(query, ""WHITE_E"None(0)");
			}
			strcat(query, "\n{FFFFFF}");
		}
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Workshop Member", query, "Okay", "");
	}
}



/*
=======================ENUM DIALOG===============

	WORKSHOP_COMPONENT,
	WORKSHOP_WITHDRAWCOMPONENT,
	WORKSHOP_DEPOSITCOMPONENT,



==================DIALOG WS COMPONENT================

	if(dialogid == WORKSHOP_COMPONENT)
	{
		if(response)
		{
			new wid = pData[playerid][pWorkshop];
			if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop!");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pWorkshopRank] < 5)
							return Error(playerid, "Hanya rank 5 dan 6 yang bisa mengambil ini!");
							
						new str[128];
						format(str, sizeof(str), ""WHITE_E"Component Balance: "GREEN_E"%d\n\n"WHITE_E"Please enter how much component you wish to withdraw from the safe:", wData[wid][wComponent]);
						ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), ""WHITE_E"Component Balance: "GREEN_E"%d\n\n"WHITE_E"Please enter how much component you wish to deposit into the safe:", wData[wid][wComponent]);
						ShowPlayerDialog(playerid, WORKSHOP_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::wsstorage(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == WORKSHOP_WITHDRAWCOMPONENT)
	{
		new wid = pData[playerid][pWorkshop];
		if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop!");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Component Balance: "GREEN_E"%d\n\n"WHITE_E"Please enter how much component you wish to withdraw from the safe:", wData[wid][wComponent]);
				ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > wData[wid][wComponent])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nComponent Balance: "GREEN_E"%d\n\n"WHITE_E"Please enter how much component you wish to withdraw from the safe:", wData[wid][wComponent]);
				ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
				return 1;
			}
			wData[wid][wComponent] -= amount;
			pData[playerid][pComponent] += amount;

			Workshop_Save(wid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d component from storage.", ReturnName(playerid), amount);
			callcmd::wsstorage(playerid, "\0");
			return 1;
		}
		else callcmd::wsstorage(playerid, "\0");
		return 1;
	}
	if(dialogid == WORKSHOP_DEPOSITCOMPONENT)
	{
		new wid = pData[playerid][pWorkshop];
		if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop.");
		if(wData[wid][wComponent] > 5000) return Error(playerid, "Penyimpanan sudah penuh!");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Component Balance: "GREEN_E"%d\n\n"WHITE_E"Please enter how much component you wish to deposit into the safe:", wData[wid][wComponent]);
				ShowPlayerDialog(playerid, WORKSHOP_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nComponent Balance: "GREEN_E"%d\n\n"WHITE_E"Please enter how much component you wish to deposit into the safe:", wData[wid][wComponent]);
				ShowPlayerDialog(playerid, WORKSHOP_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
				return 1;
			}
			wData[wid][wComponent] += amount;
			pData[playerid][pComponent] -= amount;

			Workshop_Save(wid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d component into storage.", ReturnName(playerid), amount);
		}
		else callcmd::wsstorage(playerid, "\0");
		return 1;
	}


	--------[ACCEPT WORKSHOP]-----------

        if(strcmp(params,"workshop",true) == 0)
		{
            if(IsPlayerConnected(pData[playerid][pWsOffer]))
			{
                if(pData[playerid][pWsInvite] > -1)
				{
                    pData[playerid][pWorkshop] = pData[playerid][pWsInvite];
					pData[playerid][pWorkshopRank] = 1;
					Info(playerid, "Anda telah menerima invite workshop dari %s", pData[pData[playerid][pWsOffer]][pName]);
					Info(pData[playerid][pWsOffer], "%s telah menerima invite workshop yang anda tawari", pData[playerid][pName]);
					pData[playerid][pWsInvite] = 0;
					pData[playerid][pWsOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid workshop id!");
					return 1;
				}
            }
            else
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }


*/




/*
	//TARO DI [ ON GAMEMODE INIT]//
	mysql_tquery(g_SQL, "SELECT * FROM `workshop`", "LoadWorkshop");

*/

/*
	//=== [taro di native] ===//
	cache_get_value_int(0, "workshop", pData[playerid][pWorkshop]);
	cache_get_value_int(0, "workshoprank", pData[playerid][pWorkshopRank]);

	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`workshop` = '%d', ", cQuery, pData[playerid][pWorkshop]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`workshoprank` = '%d', ", cQuery, pData[playerid][pWorkshopRank]);

	//jangan lupa FUNCTION.pwn juga di tambanhin
	cache_get_value_name_int(0, "workshop", pData[playerid][pWorkshop]);
	cache_get_value_name_int(0, "workshoprank", pData[playerid][pWorkshopRank]);

*/

/*
	//taro di ENUM PLAYER DATA
	pWorkshop,
	pWorkshopRank,
	pWsInvite,
	pWsOffer

	//taro di dialog
	WORKSHOP_MENU,
	WORKSHOP_NAME,
	WORKSHOP_INFO,
	WORKSHOP_MONEY,
	WORKSHOP_WITHDRAWMONEY,
	WORKSHOP_DEPOSITMONEY,
	WORKSHOP_SERVICE
*/

/*
	//TARO DI CMD /buy (UNTUK BELI WORKSHOP)
	//workshop buy
	//Buy Worskhop
	foreach(new wid : Workshop)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
		{

			if(wData[wid][wPrice] > pData[playerid][pMoney]) 
				return Error(playerid, "Not enough money, you can't afford this workshop.");

			if(strcmp(wData[wid][wLeader], "-")) 
				return Error(playerid, "Someone already owns this workshop.");

			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif
			}

			if(pData[playerid][pWorkshop] > -1) 
				return Error(playerid, "Kamu harus keluar dari anggota workshop lain!");

			GivePlayerMoneyEx(playerid, -wData[wid][wPrice]);
			Server_AddMoney(wData[wid][wPrice]);
			GetPlayerName(playerid, wData[wid][wLeader], MAX_PLAYER_NAME);
			Workshop_Save(wid);
			Workshop_Refresh(wid);

			pData[playerid][pWorkshop] = wid;
			pData[playerid][pWorkshopRank] = 6;
			UpdatePlayerData(playerid);
		}
	}
*/
















/* 
	//-------------[ WORKSHOP DIALOG ] ------
	if(dialogid == WORKSHOP_MENU)
	{
		if(!response) return 1;
		new wid = pData[playerid][pWorkshop];

		new status[128];
		if(wData[wid][wStatus] == 1)
		{
			status = "{FF0000}Closed";
		}
		else
		{
			status = "{00FF00}Opened";
		}
		switch(listitem) 
		{
			case 0:
			{
				new mstr[248], lstr[512];
				format(mstr,sizeof(mstr),""WHITE_E"Workshop ID %d", wid);
				format(lstr,sizeof(lstr),""WHITE_E"Workshop Name:\t"RED_E"%s\n"WHITE_E"Workshop Status:\t%s\nWorkshop Member\t", wData[wid][wName], status);
				ShowPlayerDialog(playerid, WORKSHOP_INFO, DIALOG_STYLE_TABLIST, mstr, lstr,"Back","Close");
			}
			case 1:
			{
				if(pData[playerid][pOnDuty] == 1)
				{
					pData[playerid][pOnDuty] = 0;
					SetPlayerColor(playerid, COLOR_WHITE);
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengganti pakaian kerja dengan pakaian biasa", ReturnName(playerid));
				}
				else
				{
					pData[playerid][pOnDuty] = 1;
					SetPlayerColor(playerid, COLOR_WHITE);
					if(pData[playerid][pGender] == 1)
					{
						SetPlayerSkin(playerid, 268);
						pData[playerid][pFacSkin] = 268;
					}
					else
					{
						SetPlayerSkin(playerid, 69); //194
						pData[playerid][pFacSkin] = 69; //194
					}
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil pakaian kerja dari dalam locker dan langsung memakainya", ReturnName(playerid));
				}
			}
			case 2:
			{
				//Workshop Money
				ShowPlayerDialog(playerid, WORKSHOP_MONEY, DIALOG_STYLE_LIST, "Workshop Money", "Withdraw Money\nDeposit Money", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == WORKSHOP_INFO)
	{
		new wid = pData[playerid][pWorkshop];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pWorkshopRank] < 6)
					return Error(playerid,"Hanya rank 6 yang bisa mengubah nama.");

					new mstr[248];
					format(mstr,sizeof(mstr),""WHITE_E"Nama Workshop: "RED_E"%s\n\n"WHITE_E"Masukkan nama workshop yang kamu inginkan\nMaksimal 32 karakter untuk nama workshop", wData[wid][wName]);
					ShowPlayerDialog(playerid, WORKSHOP_NAME, DIALOG_STYLE_INPUT,"Workshop Name", mstr,"Done","Back");
				}
				case 1:
				{
					return callcmd::lockws(playerid, "\0");
				}
				case 2:
				{
					if(pData[playerid][pWorkshop] == -1)
						return Error(playerid, "Kamu bukan anggota workshop!");

					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,workshoprank FROM players WHERE workshop = %d", pData[playerid][pWorkshop]);
					mysql_tquery(g_SQL, query, "ShowWorkshopMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == WORKSHOP_NAME)
	{
		if(response)
		{
			new wid = pData[playerid][pWorkshop];

			if(!Player_OwnsWorkshop(playerid, wid)) return Error(playerid, "You don't own this workshop.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Workshop tidak di perbolehkan kosong!\n\n"WHITE_E"Nama Workshop: "RED_E"%s\n\n"WHITE_E"Masukkan nama Workshop yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", wData[wid][wName]);
				ShowPlayerDialog(playerid, WORKSHOP_NAME, DIALOG_STYLE_INPUT,"Workshop Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Workshop harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama Workshop: "RED_E"%s\n\n"WHITE_E"Masukkan nama Workshop yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", wData[wid][wName]);
				ShowPlayerDialog(playerid, WORKSHOP_NAME, DIALOG_STYLE_INPUT,"Workshop Name", mstr,"Done","Back");
				return 1;
			}
			format(wData[wid][wName], 32, ColouredText(inputtext));

			Workshop_Refresh(wid);
			Workshop_Save(wid);

			Servers(playerid, "Workshop name set to: \"%s\".", wData[wid][wName]);
		}
		else return callcmd::wsstorage(playerid, "\0");
		return 1;
	}
	if(dialogid == WORKSHOP_MONEY)
	{
		if(response)
		{
			new wid = pData[playerid][pWorkshop];
			if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop!");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pWorkshopRank] < 5)
							return Error(playerid, "Hanya rank 5 dan 6 yang bisa mengambil ini!");
							
						new str[128];
						format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(wData[wid][wMoney]));
						ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(wData[wid][wMoney]));
						ShowPlayerDialog(playerid, WORKSHOP_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::wsstorage(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == WORKSHOP_WITHDRAWMONEY)
	{
		new wid = pData[playerid][pWorkshop];
		if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop!");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(wData[wid][wMoney]));
				ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > wData[wid][wMoney])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nMoney Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(wData[wid][wMoney]));
				ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
				return 1;
			}
			wData[wid][wMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Workshop_Save(wid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from storage.", ReturnName(playerid), FormatMoney(amount));
			callcmd::wsstorage(playerid, "\0");
			return 1;
		}
		else callcmd::wsstorage(playerid, "\0");
		return 1;
	}
	if(dialogid == WORKSHOP_DEPOSITMONEY)
	{
		new wid = pData[playerid][pWorkshop];
		if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop.");
		if(wData[wid][wMoney] > 50000) return Error(playerid, "Penyimpanan sudah penuh!");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(wData[wid][wMoney]));
				ShowPlayerDialog(playerid, WORKSHOP_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMoney])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nMoney Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(wData[wid][wMoney]));
				ShowPlayerDialog(playerid, WORKSHOP_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
				return 1;
			}
			wData[wid][wMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Workshop_Save(wid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into storage.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::wsstorage(playerid, "\0");
		return 1;
	}
*/










































	/* 
	//--------[ DIALOG SERVICE WORKSHOP]
	if(dialogid == WORKSHOP_SERVICE)
	{
		new wid = pData[playerid][pWorkshop];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new Float:health, comp;
						GetVehicleHealth(pData[playerid][pMechVeh], health);
						if(health > 1000.0) health = 1000.0;
						if(health > 0.0) health *= -1;
						comp = floatround(health, floatround_round) / 10 + 100;
						
						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("EngineFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Engine...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new panels, doors, light, tires, comp;
						
						GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
						new cpanels = panels / 1000000;
						new lights = light / 2;
						new pintu;
						if(doors != 0) pintu = 5;
						if(doors == 0) pintu = 0;
						comp = cpanels + lights + pintu + 20;
						
						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki body kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("BodyFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Body...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 40) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 3:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 4:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 85) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 5:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SPOILER,DIALOG_STYLE_LIST,"Choose below","Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 6:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 7:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 8:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 9:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 10:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_FRONT_BUMPERS, DIALOG_STYLE_LIST, "Front bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 11:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_REAR_BUMPERS, DIALOG_STYLE_LIST, "Rear bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 12:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 13:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SIDE_SKIRTS, DIALOG_STYLE_LIST, "Side skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
					Info(playerid, "Side blm ada.");
				}
				case 14:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_BULLBARS, DIALOG_STYLE_LIST, "Bull bars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 15:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						pData[playerid][pMechColor1] = 1086;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 16:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						pData[playerid][pMechColor1] = 1087;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 17:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
						pData[playerid][pMechColor1] = 1009;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 250) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 250;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"250 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 18:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						pData[playerid][pMechColor1] = 1008;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 375) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 375;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"375 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 19:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
						pData[playerid][pMechColor1] = 1010;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 500) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 500;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"500 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 20:
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_NEON,DIALOG_STYLE_LIST,"Neon","RED\nBLUE\nGREEN\nYELLOW\nPINK\nWHITE\nREMOVE","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
			}
		}
	}
	*/