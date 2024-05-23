#define MAX_PFARM 500

enum E_PFARM
{
	pfOwner[MAX_PLAYER_NAME],
	pfPrice,
	Float:pfX,
	Float:pfY,
	Float:pfZ,
	Float:pfA,
	pfInt,
	pfVW,
	//Storage
	pfSeeds,
	pfPotato,
	pfOrange,
	pfWheat,
	pfVisit,
	//Temp,
	pfPickup,
	Text3D:pfLabel
}

new pfData[MAX_PFARM][E_PFARM],
Iterator: PFarm<MAX_PFARM>;

Pfarm_Save(id)
{
	new cQuery[2024];
	format(cQuery, sizeof(cQuery), "UPDATE privatefarm SET owner='%s', price='%d', posx='%f', posy='%f', posz='%f', posa='%f', interior='%d', world='%d', seeds='%d', potato='%d', orange='%d', wheat='%d', visit='%d' WHERE id='%d'",
	pfData[id][pfOwner],
	pfData[id][pfPrice],
	pfData[id][pfX],
	pfData[id][pfY],
	pfData[id][pfZ],
	pfData[id][pfA],
	pfData[id][pfInt],
	pfData[id][pfVW],
	pfData[id][pfSeeds],
	pfData[id][pfPotato],
	pfData[id][pfOrange],
	pfData[id][pfWheat],
	pfData[id][pfVisit],
	id);

	return mysql_tquery(g_SQL, cQuery);
}

Pfarm_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamicPickup(pfData[id][pfPickup]))
			DestroyDynamicPickup(pfData[id][pfPickup]);

		if(IsValidDynamic3DTextLabel(pfData[id][pfLabel]))
			DestroyDynamic3DTextLabel(pfData[id][pfLabel]);

		static string[1024];

		if(strcmp(pfData[id][pfOwner], "-"))
		{
			format(string, sizeof(string), "[PRIVATE FARM ID: %d]\n"WHITE_E"Location: "YELLOW_E"%s\n"WHITE_E"Owned by %s\n"WHITE_E"/pfmenu - to open storage", id, GetLocation(pfData[id][pfX], pfData[id][pfY], pfData[id][pfZ]), pfData[id][pfOwner]);
			pfData[id][pfPickup] = CreateDynamicPickup(1239, 23, pfData[id][pfX], pfData[id][pfY], pfData[id][pfZ], pfData[id][pfVW], pfData[id][pfInt], _, 5.0 );
			pfData[id][pfLabel] =  CreateDynamic3DTextLabel(string, COLOR_GREEN, pfData[id][pfX], pfData[id][pfY], pfData[id][pfZ]+0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, pfData[id][pfVW], pfData[id][pfInt]);
		}
		else
		{
			format(string, sizeof(string), "[PRIVATE FARM ID: %d]\n"GREEN_LIGHT"This private farm for sell\n"WHITE_E"Location: "YELLOW_E"%s\n"WHITE_E"Price: "YELLOW_E"%s\n"WHITE_E"/buy - for buy this private farm", id, GetLocation(pfData[id][pfX], pfData[id][pfY], pfData[id][pfZ]), FormatMoney(pfData[id][pfPrice]));
			pfData[id][pfPickup] = CreateDynamicPickup(1239, 23, pfData[id][pfX], pfData[id][pfY], pfData[id][pfZ], pfData[id][pfVW], pfData[id][pfInt], _, 5.0 );
			pfData[id][pfLabel] =  CreateDynamic3DTextLabel(string, COLOR_GREEN, pfData[id][pfX], pfData[id][pfY], pfData[id][pfZ]+0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, pfData[id][pfVW], pfData[id][pfInt]);
		}
	}
	return 1;
}

function LoadPfarm()
{
    static pfid;
	
	new rows = cache_num_rows(), owner[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", pfid);
			cache_get_value_name(i, "owner", owner);
			format(pfData[pfid][pfOwner], 128, owner);
			cache_get_value_name_int(i, "price", pfData[pfid][pfPrice]);
			cache_get_value_name_float(i, "posx", pfData[pfid][pfX]);
			cache_get_value_name_float(i, "posy", pfData[pfid][pfY]);
			cache_get_value_name_float(i, "posz", pfData[pfid][pfZ]);
			cache_get_value_name_float(i, "posa", pfData[pfid][pfA]);
			cache_get_value_name_int(i, "interior", pfData[pfid][pfInt]);
			cache_get_value_name_int(i, "world", pfData[pfid][pfVW]);
			cache_get_value_name_int(i, "seeds", pfData[pfid][pfSeeds]);
			cache_get_value_name_int(i, "potato", pfData[pfid][pfPotato]);
			cache_get_value_name_int(i, "orange", pfData[pfid][pfOrange]);
			cache_get_value_name_int(i, "wheat", pfData[pfid][pfWheat]);
			cache_get_value_name_int(i, "visit", pfData[pfid][pfVisit]);

			Pfarm_Refresh(pfid);
			Iter_Add(PFarm, pfid);
		}
		printf("[Private Farmer] Number of Loaded: %d.", rows);
	}
}

Player_OwnsPfarm(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(pfData[id][pfOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_PfarmCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : PFarm)
	{
		if(Player_OwnsPfarm(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

Pfarm_Reset(id)
{
	format(pfData[id][pfOwner], MAX_PLAYER_NAME, "-");
	pfData[id][pfSeeds] = 0;
	pfData[id][pfPotato] = 0;
	pfData[id][pfOrange] = 0;
	pfData[id][pfWheat] = 0;
	pfData[id][pfVisit] = 0;
	Pfarm_Refresh(id);
}

CMD:createpfarm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new query[512];
	new pfid = Iter_Free(PFarm);
	if(pfid == -1)
		return Error(playerid, "You cant create more private farm!");

	new price;
	if(sscanf(params, "d", price))
	{
		Usage(playerid, "/createpfarm [price]");
		return 1;
	}

	format(pfData[pfid][pfOwner], 128, "-");
	pfData[pfid][pfPrice] = price;
	GetPlayerPos(playerid, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]);
	GetPlayerFacingAngle(playerid, pfData[pfid][pfA]);
	pfData[pfid][pfInt] = GetPlayerInterior(playerid);
	pfData[pfid][pfVW] = GetPlayerVirtualWorld(playerid);
	pfData[pfid][pfSeeds] = 0;
	pfData[pfid][pfPotato] = 0;
	pfData[pfid][pfOrange] = 0;
	pfData[pfid][pfWheat] = 0;

	Pfarm_Refresh(pfid);
	Iter_Add(PFarm, pfid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO privatefarm SET id='%d', owner='%s', price='%d'", pfid, pfData[pfid][pfOwner], pfData[pfid][pfPrice]);
	mysql_tquery(g_SQL, query, "OnPfarmCreated", "i", pfid);
	return 1;
}

function OnPfarmCreated(id)
{
	Pfarm_Save(id);
	return 1;
}

CMD:editpfarm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	static
     pfid,
      type[24],
       string[128];

    if(sscanf(params, "ds[24]S()[128]", pfid, type, string))
    {
        Usage(playerid, "/editpfarm [id] [name]");
        Names(playerid, "location, owner, price, seeds, potato, orange, wheat, reset, delete");
        return 1;
    }

    if(!Iter_Contains(PFarm, pfid)) 
		return Error(playerid, "Invalid ID.");

	if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]);
		GetPlayerFacingAngle(playerid, pfData[pfid][pfA]);
		pfData[pfid][pfInt] = GetPlayerInterior(playerid);
		pfData[pfid][pfVW] = GetPlayerVirtualWorld(playerid);

		Pfarm_Refresh(pfid);
		Pfarm_Save(pfid);
		SendAdminMessage(COLOR_RED, "%s has adjusted the location of private farm ID: %d.", pData[playerid][pAdminname], pfid);
    }
    else if(!strcmp(type, "owner", true))
    {
    	new owners[MAX_PLAYER_NAME];

        if(sscanf(string, "s[32]", owners))
            return Usage(playerid, "/editpfarm [id] [owner] [player name] (use '-' to no owner)");

        format(pfData[pfid][pfOwner], MAX_PLAYER_NAME, owners);
        if(pfData[pfid][pfVisit] == 0)
        {
        	pfData[pfid][pfVisit] = gettime() + (86400 * 30);
        }
        Pfarm_Refresh(pfid);
        Pfarm_Save(pfid);
        SendAdminMessage(COLOR_RED, "%s has adjusted owner of private farm ID: %d to %s.", pData[playerid][pAdminname], pfid, owners);
    }
    else if(!strcmp(type, "price", true))
    {
    	new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editpfarm [id] [price]");

        pfData[pfid][pfPrice] = price;

        Pfarm_Refresh(pfid);
        Pfarm_Save(pfid);
        SendAdminMessage(COLOR_RED, "%s has adjusted price of private farm ID: %d to %s.", pData[playerid][pAdminname], pfid, FormatMoney(price));
    }
    else if(!strcmp(type, "seeds", true))
    {
    	new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editpfarm [id] [seeds]");

        pfData[pfid][pfSeeds] = price;

        Pfarm_Refresh(pfid);
        Pfarm_Save(pfid);
        SendAdminMessage(COLOR_RED, "%s has adjusted seeds of private farm ID: %d to %d.", pData[playerid][pAdminname], pfid, price);
    }
    else if(!strcmp(type, "potato", true))
    {
    	new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editpfarm [id] [potato]");

        pfData[pfid][pfPotato] = price;

        Pfarm_Refresh(pfid);
        Pfarm_Save(pfid);
        SendAdminMessage(COLOR_RED, "%s has adjusted potato of private farm ID: %d to %d.", pData[playerid][pAdminname], pfid, price);
    }
    else if(!strcmp(type, "orange", true))
    {
    	new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editpfarm [id] [orange]");

        pfData[pfid][pfOrange] = price;

        Pfarm_Refresh(pfid);
        Pfarm_Save(pfid);
        SendAdminMessage(COLOR_RED, "%s has adjusted orange of private farm ID: %d to %d.", pData[playerid][pAdminname], pfid, price);
    }
    else if(!strcmp(type, "wheat", true))
    {
    	new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editpfarm [id] [wheat]");

        pfData[pfid][pfWheat] = price;

        Pfarm_Refresh(pfid);
        Pfarm_Save(pfid);
        SendAdminMessage(COLOR_RED, "%s has adjusted wheat of private farm ID: %d to %d.", pData[playerid][pAdminname], pfid, price);
    }
    else if(!strcmp(type, "reset", true))
    {
        Pfarm_Reset(pfid);
        Pfarm_Save(pfid);
        SendAdminMessage(COLOR_RED, "%s has reset private farm ID: %d.", pData[playerid][pAdminname], pfid);
    }
   	else if(!strcmp(type, "delete", true))
    {
		DestroyDynamic3DTextLabel(pfData[pfid][pfLabel]);
        DestroyDynamicPickup(pfData[pfid][pfPickup]);
		
		pfData[pfid][pfPrice] = 0;
		pfData[pfid][pfX] = 0;
		pfData[pfid][pfY] = 0;
		pfData[pfid][pfZ] = 0;
		pfData[pfid][pfA] = 0;
		pfData[pfid][pfInt] = 0;
		pfData[pfid][pfVW] = 0;

		pfData[pfid][pfLabel] = Text3D: INVALID_3DTEXT_ID;
		pfData[pfid][pfPickup] = -1;
		
		Iter_Remove(PFarm, pfid);

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM privatefarm WHERE id=%d", pfid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete privatefarm ID: %d.", pData[playerid][pAdminname], pfid);
    }
    return 1;
}

CMD:gotopfarm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return PermissionError(playerid);

	new pfid;
	if(sscanf(params, "d", pfid))
	{
		Usage(playerid, "/gotopfarm [id]");
		return 1;
	}

	if(!Iter_Contains(PFarm, pfid))
		return Error(playerid, "Invalid ID!");

	SetPlayerPos(playerid, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]+0.5);
	SetPlayerFacingAngle(playerid, pfData[pfid][pfA]);
	SetPlayerInterior(playerid, pfData[pfid][pfInt]);
	SetPlayerVirtualWorld(playerid, pfData[pfid][pfVW]);
	return 1;
}

CMD:pfmenu(playerid, params[])
{
	foreach(new pfid : PFarm)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
		{
			pData[playerid][pGetPFARM] = pfid;
			if(!Player_OwnsPfarm(playerid, pData[playerid][pGetPFARM]))
				return Error(playerid, "Kamu bukan pemilik private farmer ini.");

			new str[128], string[1024];
			format(str, sizeof(str), "Farm Menu (ID : %d)", pfid);
			format(string, sizeof(string), "Seeds Storage ("GREEN_LIGHT"%d/1000kg"WHITE_E")\nPotato Storage ("GREEN_LIGHT"%d/500kg"WHITE_E")\nOrange Storage ("GREEN_LIGHT"%d/500kg"WHITE_E")\nWheat Storage ("GREEN_LIGHT"%d/500kg"WHITE_E")", pfData[pfid][pfSeeds], pfData[pfid][pfPotato], pfData[pfid][pfOrange], pfData[pfid][pfWheat]);
		    ShowPlayerDialog(playerid, PFARM_MENU, DIALOG_STYLE_LIST, str, string,"Next","Close");
		}
	}
    return 1;
}

GetOwnedPfarm(playerid)
{
	new tmpcount;
	foreach(new pfid : PFarm)
	{
	    if(!strcmp(pfData[pfid][pfOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerPfarmID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new pfid : PFarm)
	{
	    if(!strcmp(pData[playerid][pName], pfData[pfid][pfOwner], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return pfid;
  			}
	    }
	}
	return -1;
}

CMD:mypfarm(playerid)
{
	if(GetOwnedPfarm(playerid) == 0) return Error(playerid, "Anda tidak memiliki private farmer.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new pfid, _tmpstring[1204], count = GetOwnedPfarm(playerid), CMDSString[1204];
	CMDSString = "";
	Loop(itt, (count + 1), 1)
	{
	    pfid = ReturnPlayerPfarmID(playerid, itt);
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   {ffffff}(ID: %d)\n", itt, GetLocation(pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]), pfid);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  {ffffff}(ID: %d)\n", itt, GetLocation(pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]), pfid);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_PFARM, DIALOG_STYLE_LIST, "{FF0000}ValriseReality {0000FF}Private Farm", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:pfarm(playerid, params[])
{
	if(isnull(params)) return Usage(playerid, "/pfarm [plant/harvest/destroy]");
	
	if(!strcmp(params, "plant", true))
	{
		if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
		{
			foreach(new pfid : PFarm)
			{
				if(IsPlayerInRangeOfPoint(playerid, 80.0, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
				{
					if(Player_OwnsPfarm(playerid, pfid))
					{
						if(GetPlayerInterior(playerid) > 0) return Error(playerid, "You cant plant at here!");
						if(GetPlayerVirtualWorld(playerid) > 0) return Error(playerid, "You cant plant at here!");
							
						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");
							
						new mstr[512], tstr[64];
						format(tstr, sizeof(tstr), ""WHITE_E" Farm ID: %d", pfid);
						format(mstr, sizeof(mstr), "Plant\tSeed\n\
						"WHITE_E"Potato\t"GREEN_E"5 Seed\n\
						"WHITE_E"Wheat\t"GREEN_E"18 Seed\n\
						"WHITE_E"Orange\t"GREEN_E"11 Seed");
						ShowPlayerDialog(playerid, PFARM_PLANT, DIALOG_STYLE_TABLIST_HEADERS, tstr, mstr, "Plant", "Close");
					}
				}
			}
		}
		else return Error(playerid, "You are not farmer!");
	}
	else if(!strcmp(params, "harvest", true))
	{
		if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
		{
			foreach(new pfid : PFarm)
			{
				if(IsPlayerInRangeOfPoint(playerid, 80.0, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
				{
					if(Player_OwnsPfarm(playerid, pfid))
					{
						new id = GetClosestPlant(playerid);
						if(id == -1) return Error(playerid, "You must closes on the plant!");
						if(PlantData[id][PlantTime] > 1) return Error(playerid, "This plant is not ready!");
						if(PlantData[id][PlantHarvest] == true) return Error(playerid, "This plant already harvesting by someone!");
						if(GetPlayerWeapon(playerid) != WEAPON_KNIFE) return Error(playerid, "You need holding a knife(pisau)!");
						
						pData[playerid][pHarvestID] = id;
						pData[playerid][pHarvest] = SetTimerEx("HarvestPlant", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Harvesting...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						SetPlayerArmedWeapon(playerid, WEAPON_KNIFE);
						ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);

						PlantData[id][PlantHarvest] = true;
					}
				}
			}
		}
		else return Error(playerid, "You are not farmer!");
	}
	else if(!strcmp(params, "destroy", true))
	{
		if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
		{
			foreach(new pfid : PFarm)
			{
				if(IsPlayerInRangeOfPoint(playerid, 80.0, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
				{
					if(Player_OwnsPfarm(playerid, pfid))
					{
						new id = GetClosestPlant(playerid);
						if(id == -1) return Error(playerid, "You must closes on the plant!");
						if(PlantData[id][PlantHarvest] == true) return Error(playerid, "This plant already harvesting by someone!");
						
						new query[128];
						PlantData[id][PlantType] = 0;
						PlantData[id][PlantTime] = 0;
						PlantData[id][PlantX] = 0.0;
						PlantData[id][PlantY] = 0.0;
						PlantData[id][PlantZ] = 0.0;
						PlantData[id][PlantHarvest] = false;
						KillTimer(PlantData[id][PlantTimer]);
						PlantData[id][PlantTimer] = -1;
						DestroyDynamicObject(PlantData[id][PlantObjID]);
						DestroyDynamicCP(PlantData[id][PlantCP]);
						DestroyDynamic3DTextLabel(PlantData[id][PlantLabel]);
						mysql_format(g_SQL, query, sizeof(query), "DELETE FROM plants WHERE id='%d'", id);
						mysql_query(g_SQL, query);
						Iter_SafeRemove(Plants, id, id);
						ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
						Info(playerid, "You has destroyed this plant!");
					}
				}
			}
		}
		else return Error(playerid, "You cant destroy a plant!");
	}
	return 1;
}

CMD:givepfarm(playerid, params[])
{
	new pfid, otherid;
	if(sscanf(params, "ud", otherid, pfid)) return Usage(playerid, "/givepfarm [playerid/name] [id] | /givepfarm - for show info");
	if(pfid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "Player tersebut telah disconnect/tidak berada didekat dirimu.");
	
	if(!Player_OwnsPfarm(playerid, pfid)) return Error(playerid, "Kamu tidak memiliki Private Farmer ini.");
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_PfarmCount(otherid) + 1 > 2) return Error(playerid, "Target Player tidak dapat memiliki Private Farmer lebih.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_PfarmCount(otherid) + 1 > 3) return Error(playerid, "Target Player tidak dapat memiliki Private Farmer lebih.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_PfarmCount(otherid) + 1 > 4) return Error(playerid, "Target Player tidak dapat memiliki Private Farmer lebih.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_PfarmCount(otherid) + 1 > 1) return Error(playerid, "Target Player tidak dapat memiliki Private Farmer lebih.");
		#endif
	}
	GetPlayerName(otherid, pfData[pfid][pfOwner], MAX_PLAYER_NAME);
	
	Pfarm_Refresh(pfid);
	Pfarm_Save(pfid);
	Info(playerid, "Anda memberikan Private Farmer id: %d kepada %s", pfid, ReturnName(otherid));
	Info(otherid, "%s memberikan Private Farmer id: %d kepada anda", ReturnName(playerid), pfid);
	return 1;
}



/*


	//PRIVATE FARMER
	PFARM_MENU,
	PFARM_PLANT,
	PFARM_SEEDS,
	PFARM_DEPOSIT_SEEDS,
	PFARM_WITHDRAW_SEEDS,

	PFARM_POTATO,
	PFARM_DEPOSIT_POTATO,
	PFARM_WITHDRAW_POTATO,

	PFARM_ORANGE,
	PFARM_DEPOSIT_ORANGE,
	PFARM_WITHDRAW_ORANGE,

	PFARM_WHEAT,
	PFARM_DEPOSIT_WHEAT,
	PFARM_WITHDRAW_WHEAT,

	PFARM_MARIJUANA,
	PFARM_DEPOSIT_MARIJUANA,
	PFARM_WITHDRAW_MARIJUANA,


------[ENUM PLAYER]-----

	//Private Farmer
 	pGetPFARM



---------[CMD PLANT]------

			foreach(new pfid : PFarm)
			{
				if(IsPlayerInRangeOfPoint(playerid, 50.0, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
				{
					if(GetPlayerInterior(playerid) > 0) return Error(playerid, "You cant plant at here!");
					if(GetPlayerVirtualWorld(playerid) > 0) return Error(playerid, "You cant plant at here!");
						
					if(!Iter_Contains(PFarm, pfid))
						return Error(playerid, "Invalid ID.");

					if(!Player_OwnsPfarm(playerid, pfid))
						return Error(playerid, "Kamu bukan pemilik private farmer ini.");
						
					format(tstr, sizeof(tstr), ""WHITE_E"My Seed: "GREEN_E"%d"WHITE_E" Farm ID: %d", pData[playerid][pSeed], pfid);
					format(mstr, sizeof(mstr), "Plant\tSeed\n\
					"WHITE_E"Potato\t"GREEN_E"5 Seed\n\
					"WHITE_E"Wheat\t"GREEN_E"18 Seed\n\
					"WHITE_E"Orange\t"GREEN_E"11 Seed\n\
					"RED_E"[ILEGAL]Marijuana\t"GREEN_E"50 Seed");
					ShowPlayerDialog(playerid, PFARM_PLANT, DIALOG_STYLE_TABLIST_HEADERS, tstr, mstr, "Plant", "Close");
				}
			}
		}


--------[PLAYER.pwn /buy]-----------

	//Buy Private Farmer
	foreach(new pfid : PFarm)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
		{
			if(pfData[pfid][pfPrice] > pData[playerid][pMoney]) return Error(playerid, "Not enough money, you can't afford this private farmer.");
			if(strcmp(pfData[pfid][pfOwner], "-")) return Error(playerid, "Someone already owns this private farmer.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_PfarmCount(playerid) + 1 > 2) return Error(playerid, "Anda tidak dapat membeli private farmer lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_PfarmCount(playerid) + 1 > 3) return Error(playerid, "Anda tidak dapat membeli private farmer lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_PfarmCount(playerid) + 1 > 4) return Error(playerid, "Anda tidak dapat membeli private farmer lagi.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_PfarmCount(playerid) + 1 > 1) return Error(playerid, "Anda tidak dapat membeli private farmer lagi.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -pfData[pfid][pfPrice]);
			Server_AddMoney(-pfData[pfid][pfPrice]);
			GetPlayerName(playerid, pfData[pfid][pfOwner], MAX_PLAYER_NAME);
			pfData[pfid][pfVisit] = gettime() + (86400 * 15);
			
			Pfarm_Refresh(pfid);
			Pfarm_Save(pfid);
		}
	}
	

	-------[DIALOG.pwn]------
	//----------[ PFARM DIALOG ] -------------
	if(dialogid == PFARM_MENU)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_SEEDS, DIALOG_STYLE_LIST, string, "Deposit Seeds\nWithdraw Seeds", "Yes", "No");
				}
				case 1:
				{
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_POTATO, DIALOG_STYLE_LIST, string, "Deposit Potato\nWithdraw Potato", "Yes", "No");
				}
				case 2:
				{
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_ORANGE, DIALOG_STYLE_LIST, string, "Deposit Orange\nWithdraw Orange", "Yes", "No");
				}
				case 3:
				{
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_WHEAT, DIALOG_STYLE_LIST, string, "Deposit Wheat\nWithdraw Wheat", "Yes", "No");
				}
				case 4:
				{
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_MARIJUANA, DIALOG_STYLE_LIST, string, "Deposit Marijuana\nWithdraw Marijuana", "Yes", "No");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_SEEDS)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Seeds kamu: %d.\n\nMasukkan berapa banyak Seeds yang akan kamu simpan di farmer ini", pData[playerid][pSeed]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_SEEDS, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Seeds Vault: %d\n\nMasukkan berapa banyak Seeds yang akan kamu ambil dari farmer ini", pfData[pfid][pfSeeds]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_SEEDS, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_POTATO)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Potato kamu: %d.\n\nMasukkan berapa banyak Potato yang akan kamu simpan di farmer ini", pData[playerid][pPotato]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_POTATO, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Potato Vault: %d\n\nMasukkan berapa banyak Potato yang akan kamu ambil dari farmer ini", pfData[pfid][pfPotato]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_POTATO, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_ORANGE)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Orange kamu: %d.\n\nMasukkan berapa banyak Orange yang akan kamu simpan di farmer ini", pData[playerid][pOrange]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_ORANGE, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Orange Vault: %d\n\nMasukkan berapa banyak Orange yang akan kamu ambil dari farmer ini", pfData[pfid][pfOrange]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_ORANGE, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_WHEAT)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Wheat kamu: %d.\n\nMasukkan berapa banyak Wheat yang akan kamu simpan di farmer ini", pData[playerid][pWheat]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_WHEAT, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Wheat Vault: %d\n\nMasukkan berapa banyak Wheat yang akan kamu ambil dari farmer ini", pfData[pfid][pfWheat]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_WHEAT, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_MARIJUANA)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Marijuana kamu: %d.\n\nMasukkan berapa banyak Marijuana yang akan kamu simpan di farmer ini", pData[playerid][pMarijuana]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_MARIJUANA, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Marijuana Vault: %d\n\nMasukkan berapa banyak Marijuana yang akan kamu ambil dari farmer ini", pfData[pfid][pfMarijuana]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_MARIJUANA, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_SEEDS)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfSeeds])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfSeeds] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pSeed] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" seeds from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_SEEDS, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Seeds\nWithdraw Seeds","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_SEEDS)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pSeed] + amount;

			if(amount < 1 || amount > pData[playerid][pSeed])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 500)
				return Error(playerid, "Anda tidak bisa memasukan seeds lebih dari batas slot");

			pfData[pfid][pfSeeds] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pSeed] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" seeds into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_SEEDS, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Seeds\nWithdraw Seeds","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_POTATO)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfPotato])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfPotato] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pPotato] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" potato from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_POTATO, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Potato\nWithdraw Potato","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_POTATO)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pPotato] + amount;

			if(amount < 1 || amount > pData[playerid][pPotato])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 500)
				return Error(playerid, "Anda tidak bisa memasukan potato lebih dari batas slot");

			pfData[pfid][pfPotato] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pPotato] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" potato into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_POTATO, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Potato\nWithdraw Potato","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_ORANGE)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfOrange])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfOrange] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pOrange] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" orange from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_ORANGE, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Orange\nWithdraw Orange","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_ORANGE)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pOrange] + amount;

			if(amount < 1 || amount > pData[playerid][pOrange])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 500)
				return Error(playerid, "Anda tidak bisa memasukan orange lebih dari batas slot");

			pfData[pfid][pfOrange] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pOrange] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" orange into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_ORANGE, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Orange\nWithdraw Orange","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_WHEAT)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfWheat])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfWheat] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pWheat] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" wheat from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_WHEAT, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Wheat\nWithdraw Wheat","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_WHEAT)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pOrange] + amount;

			if(amount < 1 || amount > pData[playerid][pWheat])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 500)
				return Error(playerid, "Anda tidak bisa memasukan wheat lebih dari batas slot");

			pfData[pfid][pfWheat] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pWheat] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" wheat into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_WHEAT, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Wheat\nWithdraw Wheat","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_MARIJUANA)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfMarijuana])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfMarijuana] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pMarijuana] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" marijuana from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_MARIJUANA, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Marijuana\nWithdraw Marijuana","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_MARIJUANA)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pMarijuana] + amount;

			if(amount < 1 || amount > pData[playerid][pMarijuana])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 500)
				return Error(playerid, "Anda tidak bisa memasukan marijuana lebih dari batas slot");

			pfData[pfid][pfMarijuana] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pMarijuana] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" marijuana into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_MARIJUANA, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Marijuana\nWithdraw Marijuana","Next","Back");
		return 1;
	}





	-------------------[PFARM PLANT]--------

	if(dialogid == PFARM_PLANT)
	{
		if(response)
		{
			foreach(new pfid : PFarm)
			{
				switch(listitem)
				{
					case 0:
					{
						if(pData[playerid][pSeed] < 5)
							return Error(playerid, "Not enough seed!");

						if(!Player_OwnsPfarm(playerid, pfid))
							return Error(playerid, "Kamu bukan pemilik private farmer ini.");
						
						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");

						new pid = GetNearPlant(playerid);
						if(pid != -1)
							return Error(playerid, "You too closes with other plant!");

						new id = Iter_Free(Plants);
						if(id == -1)
							return Error(playerid, "Cant plant any more plant!");

						if(pData[playerid][pPlantTime] > 0)
							return Error(playerid, "You must wait 10 minutes for plant again!");

						if(IsPlayerInRangeOfPoint(playerid, 50.0, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
						{

							pData[playerid][pSeed] -= 5;
							new Float:x, Float:y, Float:z, query[512];
							GetPlayerPos(playerid, x, y, z);

							PlantData[id][PlantType] = 1;
							PlantData[id][PlantTime] = 1800;
							PlantData[id][PlantX] = x;
							PlantData[id][PlantY] = y;
							PlantData[id][PlantZ] = z;
							PlantData[id][PlantHarvest] = false;
							PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
							Iter_Add(Plants, id);
							mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
							mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
							pData[playerid][pPlant]++;
							Info(playerid, "Planting Potato.");
						}
						else return Error(playerid, "You must in private farmer area!");
					}
					case 1:
					{
						if(pData[playerid][pSeed] < 18)
							return Error(playerid, "Not enough seed!");

						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");

						if(!Player_OwnsPfarm(playerid, pfid))
							return Error(playerid, "Kamu bukan pemilik private farmer ini.");

						new pid = GetNearPlant(playerid);
						if(pid != -1)
							return Error(playerid, "You too closes with other plant!");

						new id = Iter_Free(Plants);
						if(id == -1)
							return Error(playerid, "Cant plant any more plant!");

						if(pData[playerid][pPlantTime] > 0)
							return Error(playerid, "You must wait 10 minutes for plant again!");

						if(IsPlayerInRangeOfPoint(playerid, 50.0, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
						{

							pData[playerid][pSeed] -= 18;
							new Float:x, Float:y, Float:z, query[512];
							GetPlayerPos(playerid, x, y, z);

							PlantData[id][PlantType] = 2;
							PlantData[id][PlantTime] = 3600;
							PlantData[id][PlantX] = x;
							PlantData[id][PlantY] = y;
							PlantData[id][PlantZ] = z;
							PlantData[id][PlantHarvest] = false;
							PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
							Iter_Add(Plants, id);
							mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
							mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
							pData[playerid][pPlant]++;
							Info(playerid, "Planting Wheat.");
						}
						else return Error(playerid, "You must in private farmer area!");
					}
					case 2:
					{
						if(pData[playerid][pSeed] < 11)
							return Error(playerid, "Not enough seed!");

						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");

						if(!Player_OwnsPfarm(playerid, pfid))
							return Error(playerid, "Kamu bukan pemilik private farmer ini.");

						new pid = GetNearPlant(playerid);
						if(pid != -1)
							return Error(playerid, "You too closes with other plant!");

						new id = Iter_Free(Plants);
						if(id == -1)
							return Error(playerid, "Cant plant any more plant!");

						if(pData[playerid][pPlantTime] > 0)
							return Error(playerid, "You must wait 10 minutes for plant again!");

						if(IsPlayerInRangeOfPoint(playerid, 50.0, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
						{

							pData[playerid][pSeed] -= 11;
							new Float:x, Float:y, Float:z, query[512];
							GetPlayerPos(playerid, x, y, z);

							PlantData[id][PlantType] = 3;
							PlantData[id][PlantTime] = 2700;
							PlantData[id][PlantX] = x;
							PlantData[id][PlantY] = y;
							PlantData[id][PlantZ] = z;
							PlantData[id][PlantHarvest] = false;
							PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
							Iter_Add(Plants, id);
							mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
							mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
							pData[playerid][pPlant]++;
							Info(playerid, "Planting Orange.");
						}
						else return Error(playerid, "You must in private farmer area!");
					}
					case 3:
					{
						if(pData[playerid][pSeed] < 50)
							return Error(playerid, "Not enough seed!");

						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");
						
						if(!Player_OwnsPfarm(playerid, pfid))
							return Error(playerid, "Kamu bukan pemilik private farmer ini.");

						new pid = GetNearPlant(playerid);
						if(pid != -1)
							return Error(playerid, "You too closes with other plant!");

						new id = Iter_Free(Plants);
						if(id == -1)
							return Error(playerid, "Cant plant any more plant!");

						if(pData[playerid][pPlantTime] > 0)
							return Error(playerid, "You must wait 10 minutes for plant again!");

						if(IsPlayerInRangeOfPoint(playerid, 50.0, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
						{

							pData[playerid][pSeed] -= 50;
							new Float:x, Float:y, Float:z, query[512];
							GetPlayerPos(playerid, x, y, z);

							PlantData[id][PlantType] = 4;
							PlantData[id][PlantTime] = 4500;
							PlantData[id][PlantX] = x;
							PlantData[id][PlantY] = y;
							PlantData[id][PlantZ] = z;
							PlantData[id][PlantHarvest] = false;
							PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
							Iter_Add(Plants, id);
							mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
							mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
							pData[playerid][pPlant]++;
							Info(playerid, "Planting Marijuana.");
						}
						else return Error(playerid, "You must in private farmer area!");
					}
				}
			}
		}
	}

*/