#define MAX_SVPOINT 500

enum E_SVPOINT
{
	svType,
	Float:svPosX,
	Float:svPosY,
	Float:svPosZ,
	Float:svPosA,
	svVw,
	svInt,
	//Temp
	svPickup,
	Text3D:svLabel
}

new svData[MAX_SVPOINT][E_SVPOINT],
Iterator:SVPoint<MAX_SVPOINT>;

Svpoint_Save(svid)
{
	new cQuery[1024];
	format(cQuery, sizeof(cQuery), "UPDATE faction_vehpoint SET type = '%d', posx = '%f', posy = '%f', posz = '%f', posa = '%f', world = '%d', interior = '%d' WHERE id = '%d'",
	svData[svid][svType],
	svData[svid][svPosX],
	svData[svid][svPosY],
	svData[svid][svPosZ],
	svData[svid][svPosA],
	svData[svid][svVw],
	svData[svid][svInt],
	svid
	);
	return mysql_tquery(g_SQL, cQuery);
}

Svpoint_Refresh(svid)
{
	if(svid != -1)
	{
		if(IsValidDynamicPickup(svData[svid][svPickup]))
			DestroyDynamicPickup(svData[svid][svPickup]);

		if(IsValidDynamic3DTextLabel(svData[svid][svLabel]))
			DestroyDynamic3DTextLabel(svData[svid][svLabel]);

		new str[512], type[128];
		if(svData[svid][svType] == 1)
		{
			type = "Police Departement";
		}
		else if(svData[svid][svType] == 2)
		{
			type = "Goverment Services";
		}
		else if(svData[svid][svType] == 3)
		{
			type = "Medical Departement";
		}
		else if(svData[svid][svType] == 4)
		{
			type = "News Agency";
		}
		else if(svData[svid][svType] == 5)
		{
			type = "Cafe Food";
		}
		else 
		{
			type = "Unknown";
		}

		svData[svid][svPickup] = CreateDynamicPickup(1239, 23, svData[svid][svPosX], svData[svid][svPosY], svData[svid][svPosZ], svData[svid][svVw], svData[svid][svInt], _, 30.0);
		format(str, sizeof(str), "[FACTION VEHICLE ID: %d]\n"WHITE_E"Faction: "GREEN_LIGHT"%s\n"WHITE_E"Location: "GREEN_LIGHT"%s\n"WHITE_E"/fspawnveh - to spawn faction vehicle\n"WHITE_E"/fdespawnveh - to despawn faction vehicle", svid, type, GetLocation(svData[svid][svPosX], svData[svid][svPosY], svData[svid][svPosZ]));
		svData[svid][svLabel] = CreateDynamic3DTextLabel(str, COLOR_YELLOW, svData[svid][svPosX], svData[svid][svPosY], svData[svid][svPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, svData[svid][svVw], svData[svid][svInt]);
	}
	return 1;
}

function LoadSvpoint(playerid)
{
	static svid;

	new rows = cache_num_rows();
	if(rows)
	{
		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", svid);
			cache_get_value_name_int(i, "type", svData[svid][svType]);
			cache_get_value_name_float(i, "posx", svData[svid][svPosX]);
			cache_get_value_name_float(i, "posy", svData[svid][svPosY]);
			cache_get_value_name_float(i, "posz", svData[svid][svPosZ]);
			cache_get_value_name_float(i, "posa", svData[svid][svPosA]);
			cache_get_value_name_int(i, "world", svData[svid][svVw]);
			cache_get_value_name_int(i, "interior", svData[svid][svInt]);

			Svpoint_Refresh(svid);
			Iter_Add(SVPoint, svid);
		}
		printf("[Faction Vehicle Point] Number of Loaded: %d.", rows);
	}
}

CMD:createsvpoint(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);

	new svid = Iter_Free(SVPoint), type;
	if(sscanf(params, "d", type))
	{
		Usage(playerid, "/createvpoint [type]");
		Usage(playerid, "[TYPE]: 1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW 5.SACF");
		return 1;
	}
	if(type <= 0 || type >= 6)
		return Error(playerid, "Type only 1-5");

	if(svid >= MAX_SVPOINT)
		return Error(playerid, "Jumlah svpoint dikota sudah terlalu penuh!");

	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	svData[svid][svType] = type;

	svData[svid][svPosX] = x;
	svData[svid][svPosY] = y;
	svData[svid][svPosZ] = z;
	svData[svid][svPosA] = a;

	svData[svid][svVw] = GetPlayerVirtualWorld(playerid);
	svData[svid][svInt] = GetPlayerInterior(playerid);

	Svpoint_Refresh(svid);
	Iter_Add(SVPoint, svid);

	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO faction_vehpoint SET id = '%d', type = '%d'", svid, svData[svid][svType]);
	mysql_tquery(g_SQL, query, "OnSvpointCreated", "d", svid);

    SendStaffMessage(COLOR_RED, "Staff %s has created faction spawnveh point id : %d", pData[playerid][pAdminname], svid);
	return 1;
}

function OnSvpointCreated(svid)
{
	Svpoint_Save(svid);
	return 1;
}

CMD:deletesvpoint(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);

	new svid;
	if(sscanf(params, "d", svid))
		return Usage(playerid, "/deletesvpoint [svid]");

	if(!Iter_Contains(SVPoint, svid))
		return Error(playerid, "Invalid spawn vehicle point ID!");

	if(IsValidDynamicPickup(svData[svid][svPickup]))
			DestroyDynamicPickup(svData[svid][svPickup]);

	if(IsValidDynamic3DTextLabel(svData[svid][svLabel]))
		DestroyDynamic3DTextLabel(svData[svid][svLabel]);

	svData[svid][svPosX] = 0.0;
	svData[svid][svPosY] = 0.0;
	svData[svid][svPosZ] = 0.0;
	svData[svid][svPosA] = 0.0;

	Iter_Remove(SVPoint, svid);

	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM faction_vehpoint WHERE id = '%d'", svid);
	mysql_tquery(g_SQL, query);

    SendStaffMessage(COLOR_RED, "Staff %s has deleted faction spawnveh point id : %d", pData[playerid][pAdminname], svid);
	return 1;
}

CMD:gotosvpoint(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);

    new svid;
    if(sscanf(params, "d", svid))
        return Usage(playerid, "/gotosvpoint [svid]");

    if(!Iter_Contains(SVPoint, svid))
        return Error(playerid, "Invalid Sv Point ID!");

    SetPlayerPos(playerid, svData[svid][svPosX], svData[svid][svPosY], svData[svid][svPosZ]);
    SetPlayerVirtualWorld(playerid, svData[svid][svVw]);
    SetPlayerInterior(playerid, svData[svid][svInt]);

    Info(playerid, "Kamu telah diteleport menuju Sv Point ID: %d", svid);
    return 1;
}

Svpoint_Listmenu(playerid, svid)
{
	if(svid <= -1)
        return 0;

    static
    	str[512];

   	switch(svData[svid][svType])
    {
    	case 1: //SAPD
    	{
    		format(str, sizeof(str), "Model\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
    			GetVehicleModelName(596),
    			GetVehicleModelName(407),
    			GetVehicleModelName(544),
    			GetVehicleModelName(599),
    			GetVehicleModelName(601),
    			GetVehicleModelName(528),
    			GetVehicleModelName(560),
    			GetVehicleModelName(523),
    			GetVehicleModelName(525),
    			GetVehicleModelName(497),
    			GetVehicleModelName(411)
    			);
    		ShowPlayerDialog(playerid, SVPOINT_SAPD, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Point (SAPD)", str, "Select", "Cancel");
    	}
    	case 2: //SAGS
    	{
    		format(str, sizeof(str), "Model\n%s\n%s\n%s\n%s\n%s\n%s\n",
    			GetVehicleModelName(405),
    			GetVehicleModelName(409),
    			GetVehicleModelName(411),
    			GetVehicleModelName(521),
    			GetVehicleModelName(437),
    			GetVehicleModelName(487)
    			);
    		ShowPlayerDialog(playerid, SVPOINT_SAGS, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Point (SAGS)", str, "Select", "Cancel");
	    }
	    case 3: //SAMD
	    {
	    	format(str, sizeof(str), "Model\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",
	    		GetVehicleModelName(407),
    			GetVehicleModelName(544),
    			GetVehicleModelName(416),
    			GetVehicleModelName(442),
    			GetVehicleModelName(426),
    			GetVehicleModelName(586),
    			GetVehicleModelName(563),
    			GetVehicleModelName(487)
    			);
	    	ShowPlayerDialog(playerid, SVPOINT_SAMD, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Point (SAMD)", str, "Select", "Cancel");
	    }
	    case 4: //SANEW
	    {
	    	format(str, sizeof(str), "Model\n%s\n%s\n%s\n%s\n%s\n%s",
    			GetVehicleModelName(582),
    			GetVehicleModelName(418),
    			GetVehicleModelName(413),
    			GetVehicleModelName(405),
    			GetVehicleModelName(461),
    			GetVehicleModelName(488)
    			);
	    	ShowPlayerDialog(playerid, SVPOINT_SANEWS, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Point (SANA)", str, "Select", "Cancel");
	    }
	    case 5: //SACF
	    {
	    	format(str, sizeof(str), "Model\n%s\n%s\n%s\n%s\n%s\n%s",
    			GetVehicleModelName(588),
    			GetVehicleModelName(448),
    			GetVehicleModelName(423)
    			);
	    	ShowPlayerDialog(playerid, SVPOINT_SACF, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Point (SACF)", str, "Select", "Cancel");
	    }
    }
	return 1;
}

#define MAX_FACTIONVEH 500

enum E_FACTIONVEH
{
    fvVeh,
    fvFaction,
    Float:fvPosX,
    Float:fvPosY,
    Float:fvPosZ,
    Float:fvPosA,
    fvColor1,
    fvColor2,
    Text3D:fvLabel
}

new fvData[MAX_FACTIONVEH][E_FACTIONVEH],
Iterator:FactionVeh<MAX_FACTIONVEH>;

IsSAPDCar(carid)
{
    for(new i = 0; i < MAX_FACTIONVEH; i++)
    {
        if(Iter_Contains(FactionVeh, i))
        {
            if(carid == fvData[i][fvVeh])
            {
                if(fvData[i][fvFaction] == 1)
                {
                    return 1;
                }
            }
        }
    }
    return 0;
}

IsSAGSCar(carid)
{
    for(new i = 0; i < MAX_FACTIONVEH; i++)
    {
        if(Iter_Contains(FactionVeh, i))
        {
            if(carid == fvData[i][fvVeh])
            {
                if(fvData[i][fvFaction] == 2)
                {
                    return 1;
                }
            }
        }
    }
    return 0;
}

IsSAMDCar(carid)
{
    for(new i = 0; i < MAX_FACTIONVEH; i++)
    {
        if(Iter_Contains(FactionVeh, i))
        {
            if(carid == fvData[i][fvVeh])
            {
                if(fvData[i][fvFaction] == 3)
                {
                    return 1;
                }
            }
        }
    }
    return 0;
}

IsSANACar(carid)
{
    for(new i = 0; i < MAX_FACTIONVEH; i++)
    {
        if(Iter_Contains(FactionVeh, i))
        {
            if(carid == fvData[i][fvVeh])
            {
                if(fvData[i][fvFaction] == 4)
                {
                    return 1;
                }
            }
        }
    }
    return 0;
}

CMD:fspawnveh(playerid, params[])
{
    foreach(new svid : SVPoint)
    {
        if(Iter_Contains(SVPoint, svid))
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.5, svData[svid][svPosX], svData[svid][svPosY], svData[svid][svPosZ]))
            {
                if(pData[playerid][pFaction] != svData[svid][svType])
                    return Error(playerid, "Kamu bukan anggota fraksi ini!");

                pData[playerid][pGetSVPOINTID] = svid;
                Svpoint_Listmenu(playerid, svid);
            }
        }
    }
    return 1;
}

CMD:fdespawnveh(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    foreach(new svid : SVPoint)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.5, svData[svid][svPosX], svData[svid][svPosY], svData[svid][svPosZ]))
        {
            if(pData[playerid][pFaction] != svData[svid][svType])
                return Error(playerid, "Kamu bukan anggota fraksi ini!");

            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                return Error(playerid, "Kamu harus mengendarai kendaraan fraksi");

            pData[playerid][pGetSVPOINTID] = svid;

            foreach(new fvid : FactionVeh)
            {
                if(vehicleid == fvData[fvid][fvVeh])
                {
                    if(fvData[fvid][fvFaction] != svData[svid][svType])
                        return Error(playerid, "Kendaraan tersebut bukan berasal dari spawn point ini!");

                    Info(playerid, "Kamu telah memasukan kendaraan %s kedalam garasi", GetVehicleName(fvData[fvid][fvVeh]));
                    
                    RemovePlayerFromVehicle(playerid);

                    Delete3DTextLabel(fvData[fvid][fvLabel]);
                    fvData[fvid][fvLabel] = Text3D: -1;
                    
                    if(IsValidVehicle(fvData[fvid][fvVeh]))
                        DestroyVehicle(fvData[fvid][fvVeh]);

                    fvData[fvid][fvVeh] = 0;
                    fvData[fvid][fvFaction] = 0; 

                    Iter_Remove(FactionVeh, fvid);
                    return 1;
                }
            }
        }
    }
    return 1;
}