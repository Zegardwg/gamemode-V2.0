//House System
#define MAX_HOUSES	1000
#define LIMIT_PER_PLAYER 3
#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)

enum houseinfo
{
	hOwner[MAX_PLAYER_NAME],
	hOwner2[MAX_PLAYER_NAME],
	hAddress[128],
	hPrice,
	hType,
	hLocked,
	hMoney,
	hMarijuana,
	hEphedrine,
	hCocaine,
	hMeth,
	hComponent,
	hMaterial,
	hWeapon[10],
	hAmmo[10],
	hInt,
	Float:hExtposX,
	Float:hExtposY,
	Float:hExtposZ,
	Float:hExtposA,
	Float:hIntposX,
	Float:hIntposY,
	Float:hIntposZ,
	Float:hIntposA,
	hVisit,
	//Not Saved
	hPickup,
	hCP,
	hIcon,
	Text3D:hLabel
};

new hData[MAX_HOUSES][houseinfo],
	Iterator: Houses<MAX_HOUSES>;
	
Player_OwnsHouse(playerid, houseid)
{
	if(houseid == -1) return 0;
	if(!IsPlayerConnected(playerid)) return 0;
	if(!strcmp(hData[houseid][hOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_OwnsHouse2(playerid, houseid)
{
	if(houseid == -1) return 0;
	if(!IsPlayerConnected(playerid)) return 0;
	if(!strcmp(hData[houseid][hOwner], pData[playerid][pName], true) || !strcmp(hData[houseid][hOwner2], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_HouseCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Houses)
	{
		if(Player_OwnsHouse(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

HouseReset(houseid)
{
	format(hData[houseid][hOwner], MAX_PLAYER_NAME, "-");
	format(hData[houseid][hOwner2], MAX_PLAYER_NAME, "-");
	hData[houseid][hLocked] = 1;
    hData[houseid][hMoney] = 0;
    hData[houseid][hComponent] = 0;
    hData[houseid][hMaterial] = 0;

    hData[houseid][hMarijuana] = 0;
    hData[houseid][hEphedrine] = 0;
    hData[houseid][hCocaine] = 0;
    hData[houseid][hMeth] = 0;

	hData[houseid][hWeapon] = 0;
	hData[houseid][hAmmo] = 0;
	hData[houseid][hVisit] = 0;
	House_Type(houseid);
	
	for (new i = 0; i < 10; i ++)
    {
        hData[houseid][hWeapon][i] = 0;

		hData[houseid][hAmmo][i] = 0;
    }
}
	
/*GetHouseOwnerID(houseid)
{
	foreach(new i : Player)
	{
		if(!strcmp(hData[houseid][hOwner], pData[i][pName], true)) return i;
	}
	return INVALID_PLAYER_ID;
}*/

House_WeaponStorage(playerid, houseid)
{
    if(houseid == -1)
        return 0;

    static
        string[320];

    string[0] = 0;

    for (new i = 0; i < 5; i ++)
    {
        if(!hData[houseid][hWeapon][i])
            format(string, sizeof(string), "%sEmpty Slot\n", string);

        else
            format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(hData[houseid][hWeapon][i]), hData[houseid][hAmmo][i]);
    }
    ShowPlayerDialog(playerid, HOUSE_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}

House_OpenStorage(playerid, houseid)
{
    if(houseid == -1)
        return 0;

    new
        items[1],
        string[10 * 32];

    for (new i = 0; i < 5; i ++) if(hData[houseid][hWeapon][i]) 
	{
        items[0]++;
    }
    if(!Player_OwnsHouse2(playerid, houseid))
    {
    	format(string, sizeof(string), "Weapon Storage (%d/5)", items[0]);
    }
    else if(hData[houseid][hType] == 1)
    {
        format(string, sizeof(string), "Weapon Storage (%d/5)\nMoney Safe (%s/$1.000,000)\nComponent Safe (%d/5000)\nMaterial Safe (%d/5000)\n"RED_E"Marijuana Safe (%dg/1000g)\n"RED_E"Ephedrine Safe (%dg/1000g)\n"RED_E"Cocaine Safe (%dg/1000g)\n"RED_E"Meth Safe (%dg/1000g)"WHITE_E"", items[0], FormatMoney(hData[houseid][hMoney]), hData[houseid][hComponent], hData[houseid][hMaterial], hData[houseid][hMarijuana], hData[houseid][hEphedrine], hData[houseid][hCocaine], hData[houseid][hMeth]);
    }
    else if(hData[houseid][hType] == 2)
    {
    	format(string, sizeof(string), "Weapon Storage (%d/5)\nMoney Safe (%s/$3.000,000)\nComponent Safe (%d/10000)\nMaterial Safe (%d/10000)\n"RED_E"Marijuana Safe (%dg/3000g)\n"RED_E"Ephedrine Safe (%dg/3000g)\n"RED_E"Cocaine Safe (%dg/3000g)\n"RED_E"Meth Safe (%dg/3000g)"WHITE_E"", items[0], FormatMoney(hData[houseid][hMoney]), hData[houseid][hComponent], hData[houseid][hMaterial], hData[houseid][hMarijuana], hData[houseid][hEphedrine], hData[houseid][hCocaine], hData[houseid][hMeth]);
    }
    else if(hData[houseid][hType] == 3)
    {
    	format(string, sizeof(string), "Weapon Storage (%d/5)\nMoney Safe (%s/$5.000,000)\nComponent Safe (%d/15000)\nMaterial Safe (%d/15000)\n"RED_E"Marijuana Safe (%dg/5000g)\n"RED_E"Ephedrine Safe (%dg/5000g)\n"RED_E"Cocaine Safe (%dg/5000g)\n"RED_E"Meth Safe (%dg/5000g)"WHITE_E"", items[0], FormatMoney(hData[houseid][hMoney]), hData[houseid][hComponent], hData[houseid][hMaterial], hData[houseid][hMarijuana], hData[houseid][hEphedrine], hData[houseid][hCocaine], hData[houseid][hMeth]);
    }
    ShowPlayerDialog(playerid, HOUSE_STORAGE, DIALOG_STYLE_LIST, "House Storage", string, "Select", "Cancel");
    return 1;
}

GetOwnedHouses(playerid)
{
	new tmpcount;
	foreach(new hid : Houses)
	{
	    if(!strcmp(hData[hid][hOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
ReturnPlayerHousesID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new hid : Houses)
	{
	    if(!strcmp(pData[playerid][pName], hData[hid][hOwner], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return hid;
  			}
	    }
	}
	return -1;
}

House_Save(houseid)
{
	new cQuery[1536];
	format(cQuery, sizeof(cQuery), "UPDATE houses SET owner='%s', owner2='%s', address='%s', price='%d', type='%d', locked='%d', money='%d', component='%d', material='%d', marijuana='%d', ephedrine='%d', cocaine='%d', meth='%d'",
	hData[houseid][hOwner],
	hData[houseid][hOwner2],
	hData[houseid][hAddress],
	hData[houseid][hPrice],
	hData[houseid][hType],
	hData[houseid][hLocked],
	hData[houseid][hMoney],
	hData[houseid][hComponent],
    hData[houseid][hMaterial],
    hData[houseid][hMarijuana],
    hData[houseid][hEphedrine],
    hData[houseid][hCocaine],
    hData[houseid][hMeth]
	);
	
	for (new i = 0; i < 10; i ++) 
	{
        format(cQuery, sizeof(cQuery), "%s, houseWeapon%d='%d', houseAmmo%d='%d'", cQuery, i + 1, hData[houseid][hWeapon][i], i + 1, hData[houseid][hAmmo][i]);
    }
	
	format(cQuery, sizeof(cQuery), "%s, houseint='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', intposx='%f', intposy='%f', intposz='%f', intposa='%f', visit='%d' WHERE ID='%d'",
        cQuery,
        hData[houseid][hInt],
        hData[houseid][hExtposX],
        hData[houseid][hExtposY],
		hData[houseid][hExtposZ],
		hData[houseid][hExtposA],
		hData[houseid][hIntposX],
		hData[houseid][hIntposY],
		hData[houseid][hIntposZ],
		hData[houseid][hIntposA],
		hData[houseid][hVisit],
        houseid
    );
	return mysql_tquery(g_SQL, cQuery);
}

House_Type(houseid)
{
	if(hData[houseid][hType] == 1)
	{
	    switch(random(4))
		{
			case 0:
			{
				hData[houseid][hIntposX] = 377.15;
				hData[houseid][hIntposY] = 1417.41;
				hData[houseid][hIntposZ] = 1081.33;
				hData[houseid][hIntposA] = 85.69;
				hData[houseid][hInt] = 15;
			}
			case 1:
			{
				hData[houseid][hIntposX] = 387.22;
				hData[houseid][hIntposY] = 1471.70;
				hData[houseid][hIntposZ] = 1080.19;
				hData[houseid][hIntposA] = 85.69;
				hData[houseid][hInt] = 15;
			}
			case 2:
			{
				hData[houseid][hIntposX] = 261.12;
				hData[houseid][hIntposY] = 1284.30;
				hData[houseid][hIntposZ] = 1080.26;
				hData[houseid][hIntposA] = 85.69;
				hData[houseid][hInt] = 4;
			}
			case 3:
			{
				hData[houseid][hIntposX] = 260.85;
				hData[houseid][hIntposY] = 1237.24;
				hData[houseid][hIntposZ] = 1084.26;
				hData[houseid][hIntposA] = 85.69;
				hData[houseid][hInt] = 9;
			}
		}
	}
	if(hData[houseid][hType] == 2)
	{
	    switch(random(3))
		{
			case 0:
			{
				hData[houseid][hIntposX] = 446.99;
				hData[houseid][hIntposY] = 1397.07;
				hData[houseid][hIntposZ] = 1084.30;
				hData[houseid][hIntposA] = 353.78;
				hData[houseid][hInt] = 2;
			}
			case 1:
			{
				hData[houseid][hIntposX] = 22.88;
				hData[houseid][hIntposY] = 1403.33;
				hData[houseid][hIntposZ] = 1084.44;
				hData[houseid][hIntposA] = 353.78;
				hData[houseid][hInt] = 5;
			}
			case 2:
			{
				hData[houseid][hIntposX] = 2196.85;
				hData[houseid][hIntposY] = -1204.25;
				hData[houseid][hIntposZ] = 1049.02;
				hData[houseid][hIntposA] = 84.70;
				hData[houseid][hInt] = 6;
			}
		}
	}
	if(hData[houseid][hType] == 3)
	{
	    switch(random(3))
		{
			case 0:
			{
				hData[houseid][hIntposX] = 2324.53;
				hData[houseid][hIntposY] = -1149.54;
				hData[houseid][hIntposZ] = 1050.71;
				hData[houseid][hIntposA] = 353.78;
				hData[houseid][hInt] = 12;
			}
			case 1:
			{
				hData[houseid][hIntposX] = 225.68;
				hData[houseid][hIntposY] = 1021.45;
				hData[houseid][hIntposZ] = 1084.02;
				hData[houseid][hIntposA] = 353.78;
				hData[houseid][hInt] = 7;
			}
			case 2:
			{
				hData[houseid][hIntposX] = 234.19;
				hData[houseid][hIntposY] = 1063.73;
				hData[houseid][hIntposZ] = 1084.21;
				hData[houseid][hIntposA] = 353.78;
				hData[houseid][hInt] = 6;
			}
		}
	}
}

House_Refresh(houseid)
{
    if(houseid != -1)
    {
        if(IsValidDynamic3DTextLabel(hData[houseid][hLabel]))
            DestroyDynamic3DTextLabel(hData[houseid][hLabel]);

        if(IsValidDynamicPickup(hData[houseid][hPickup]))
            DestroyDynamicPickup(hData[houseid][hPickup]);
			
		if(IsValidDynamicCP(hData[houseid][hCP]))
            DestroyDynamicCP(hData[houseid][hCP]);

        if(IsValidDynamicMapIcon(hData[houseid][hIcon]))
        	DestroyDynamicMapIcon(hData[houseid][hIcon]);

        static
        string[255];
		
		new type[128];
		if(hData[houseid][hType] == 1)
		{
			type= "Low";
		}
		else if(hData[houseid][hType] == 2)
		{
			type= "Medium";
		}
		else if(hData[houseid][hType] == 3)
		{
			type= "High";
		}
		else
		{
			type= "Unknow";
		}

        if(strcmp(hData[houseid][hOwner], "-") && strcmp(hData[houseid][hOwner2], "-"))
		{
			if(hData[houseid][hLocked] != 2)
			{
				format(string, sizeof(string), "[ID: %d]\n{FFFFFF}House Location {FFFF00}%s\n{FFFFFF}House Type {FFFF00}%s\n"WHITE_E"Owned by %s & %s\nPress '{FF0000}ENTER{FFFFFF}' to enter", houseid, GetLocation(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]), type, hData[houseid][hOwner], hData[houseid][hOwner2]);
				hData[houseid][hPickup] = CreateDynamicPickup(1314, 23, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.2, 0, 0, _, 10.0);
				hData[houseid][hIcon] = CreateDynamicMapIcon(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ], 32, -1, -1, -1, -1, 50.0);
        	}
        	else
        	{
        		format(string, sizeof(string), "[ID: %d]\n{FFFFFF}House Location {FFFF00}%s\n{FFFFFF}House Type {FFFF00}%s\n"WHITE_E"Owned by %s & %s\n"RED_E"this house is being sealed by the government"WHITE_E"\nPress '{FF0000}ENTER{FFFFFF}' to enter", houseid, GetLocation(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]), type, hData[houseid][hOwner], hData[houseid][hOwner2]);
				hData[houseid][hPickup] = CreateDynamicPickup(1314, 23, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.2, 0, 0, _, 10.0);
				hData[houseid][hIcon] = CreateDynamicMapIcon(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ], 32, -1, -1, -1, -1, 50.0);
        	}
        }
        else if(strcmp(hData[houseid][hOwner], "-"))
		{
			if(hData[houseid][hLocked] != 2)
			{
				format(string, sizeof(string), "[ID: %d]\n{FFFFFF}House Location {FFFF00}%s\n{FFFFFF}House Type {FFFF00}%s\n"WHITE_E"Owned by %s\nPress '{FF0000}ENTER{FFFFFF}' to enter", houseid, GetLocation(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]), type, hData[houseid][hOwner]);
				hData[houseid][hPickup] = CreateDynamicPickup(1273, 23, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.2, 0, 0, _, 10.0);
				hData[houseid][hIcon] = CreateDynamicMapIcon(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ], 32, -1, -1, -1, -1, 50.0);
        	}
        	else
        	{
        		format(string, sizeof(string), "[ID: %d]\n{FFFFFF}House Location {FFFF00}%s\n{FFFFFF}House Type {FFFF00}%s\n"WHITE_E"Owned by %s\n"RED_E"this house is being sealed by the government"WHITE_E"\nPress '{FF0000}ENTER{FFFFFF}' to enter", houseid, GetLocation(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]), type, hData[houseid][hOwner]);
				hData[houseid][hPickup] = CreateDynamicPickup(1273, 23, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.2, 0, 0, _, 10.0);
				hData[houseid][hIcon] = CreateDynamicMapIcon(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ], 32, -1, -1, -1, -1, 50.0);
        	}
        }
        else
        {
        	format(string, sizeof(string), "[ID: %d]\n{00FF00}This house for sell\n{FFFFFF}House Location: {FFFF00}%s\n{FFFFFF}House Type: {FFFF00}%s\n{FFFFFF}House Price: {FFFF00}%s\n"WHITE_E"Type /buy to purchase", houseid, GetLocation(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]), type, FormatMoney(hData[houseid][hPrice]));
            hData[houseid][hPickup] = CreateDynamicPickup(1273, 23, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.2, 0, 0, _, 10.0);
            hData[houseid][hIcon] = CreateDynamicMapIcon(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ], 31, -1, -1, -1, -1, 50.0);
        }
		//hData[houseid][hCP] = CreateDynamicCP(hData[houseid][hIntposX], hData[houseid][hIntposY], hData[houseid][hIntposZ], 1.0, houseid, hData[houseid][hInt], -1, 3.0);
        hData[houseid][hLabel] = CreateDynamic3DTextLabel(string, COLOR_GREEN, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.5, 2.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    }
    return 1;
}

function LoadHouses()
{
    static
        str[128],
		hid;
		
	new rows = cache_num_rows(), owner[128], owner2[128], address[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", hid);
			cache_get_value_name(i, "owner", owner);
			format(hData[hid][hOwner], 128, owner);
			cache_get_value_name(i, "owner2", owner2);
			format(hData[hid][hOwner2], 128, owner2);
			cache_get_value_name(i, "address", address);
			format(hData[hid][hAddress], 128, address);
			cache_get_value_name_int(i, "price", hData[hid][hPrice]);
			cache_get_value_name_int(i, "type", hData[hid][hType]);
			cache_get_value_name_float(i, "extposx", hData[hid][hExtposX]);
			cache_get_value_name_float(i, "extposy", hData[hid][hExtposY]);
			cache_get_value_name_float(i, "extposz", hData[hid][hExtposZ]);
			cache_get_value_name_float(i, "extposa", hData[hid][hExtposA]);
			cache_get_value_name_float(i, "intposx", hData[hid][hIntposX]);
			cache_get_value_name_float(i, "intposy", hData[hid][hIntposY]);
			cache_get_value_name_float(i, "intposz", hData[hid][hIntposZ]);
			cache_get_value_name_float(i, "intposa", hData[hid][hIntposA]);
			cache_get_value_name_int(i, "houseint", hData[hid][hInt]);
			cache_get_value_name_int(i, "money", hData[hid][hMoney]);
			cache_get_value_name_int(i, "component", hData[hid][hComponent]);
			cache_get_value_name_int(i, "material", hData[hid][hMaterial]);
			cache_get_value_name_int(i, "marijuana", hData[hid][hMarijuana]);
			cache_get_value_name_int(i, "ephedrine", hData[hid][hEphedrine]);
			cache_get_value_name_int(i, "cocaine", hData[hid][hCocaine]);
			cache_get_value_name_int(i, "meth", hData[hid][hMeth]);
			cache_get_value_name_int(i, "locked", hData[hid][hLocked]);
			cache_get_value_name_int(i, "visit", hData[hid][hVisit]);

			for (new j = 0; j < 10; j ++)
			{
				format(str, 24, "houseWeapon%d", j + 1);
				cache_get_value_name_int(i, str, hData[hid][hWeapon][j]);

				format(str, 24, "houseAmmo%d", j + 1);
				cache_get_value_name_int(i, str, hData[hid][hAmmo][j]);
			}
			House_Refresh(hid);
			Iter_Add(Houses, hid);
		}
		printf("[Houses] Number of Loaded: %d.", rows);
	}
}

//----------[ House Commands ]--------
//House System
CMD:createhouse(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new hid = Iter_Free(Houses), address[128];
	if(hid == -1) return Error(playerid, "You cant create more door!");
	new price, type, query[512];
	if(sscanf(params, "dd", price, type)) return Usage(playerid, "/createhouse [price] [type, 1.small 2.medium 3.Big]");
	format(hData[hid][hOwner], 128, "-");
	format(hData[hid][hOwner2], 128, "-");
	GetPlayerPos(playerid, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]);
	GetPlayerFacingAngle(playerid, hData[hid][hExtposA]);
	hData[hid][hPrice] = price;
	hData[hid][hType] = type;
	address = GetLocation(hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]);
	format(hData[hid][hAddress], 128, address);
	hData[hid][hLocked] = 1;
	
	hData[hid][hMoney] = 0;
	hData[hid][hComponent] = 0;
    hData[hid][hMaterial] = 0;
    hData[hid][hMarijuana] = 0;
    hData[hid][hEphedrine] = 0;
    hData[hid][hCocaine] = 0;
    hData[hid][hMeth] = 0;

	hData[hid][hInt] = 0;
	hData[hid][hIntposX] = 0;
	hData[hid][hIntposY] = 0;
	hData[hid][hIntposZ] = 0;
	hData[hid][hIntposA] = 0;
	hData[hid][hVisit] = 0;
	House_Type(hid);
	
	for (new i = 0; i < 10; i ++) 
	{
        hData[hid][hWeapon][i] = 0;
        hData[hid][hAmmo][i] = 0;
    }
    House_Refresh(hid);
	Iter_Add(Houses, hid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO houses SET ID='%d', owner='%s', owner2='%s', price='%d', type='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', address='%s'", hid, hData[hid][hOwner], hData[hid][hOwner2], hData[hid][hPrice], hData[hid][hType], hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], hData[hid][hExtposA], hData[hid][hAddress]);
	mysql_tquery(g_SQL, query, "OnHousesCreated", "i", hid);
	return 1;
}

function OnHousesCreated(hid)
{
	House_Save(hid);
	return 1;
}

CMD:gotohouse(playerid, params[])
{
	new hid;
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", hid))
		return Usage(playerid, "/gotohouse [id]");
	if(!Iter_Contains(Houses, hid)) return Error(playerid, "The doors you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], hData[hid][hExtposA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to house id %d", hid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	return 1;
}

CMD:typehouses(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
	
	new count = 0;
	foreach(new hid : Houses)
	{
		if(hData[hid][hType] == 1)
		{
			House_Type(hid);
			House_Refresh(hid);
			House_Save(hid);
		}
		if(hData[hid][hType] == 2)
		{
			House_Type(hid);
			House_Refresh(hid);
			House_Save(hid);
		}
		if(hData[hid][hType] == 3)
		{
			House_Type(hid);
			House_Refresh(hid);
			House_Save(hid);
		}
		count++;
	}
	Servers(playerid, "Anda telah me reset house interior type sebanyak %d rumah.", count);
	return 1;
}

CMD:sphouseall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
	
	new type, price;
	if(sscanf(params, "dd", type, price))
	{
		Usage(playerid, "/sphouseall [type] [price] [1.Low 2.Medium 3.High]");
		return 1;
	}

	if(type < 0 || type > 3)
		return Error(playerid, "House type only 1-3");

	new count = 0;
	foreach(new hid : Houses)
	{
		if(Iter_Contains(Houses, hid))
		{
			if(hData[hid][hType] == type)
			{
				hData[hid][hPrice] = price;
				House_Refresh(hid);
				House_Save(hid);
			}
			count++;
		}
	}
	SendStaffMessage(COLOR_RED, "Staff %s telah mengeset harga semua rumah type %d menjadi %s.", pData[playerid][pAdminname], type, FormatMoney(price));
	return 1;
}

CMD:edithouse(playerid, params[])
{
    static
        hid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", hid, type, string))
    {
        Usage(playerid, "/edithouse [id] [name]");
        Names(playerid, "location, interior, locked, owner, owner2, price, type, reset, delete");
        return 1;
    }
    if((hid < 0 || hid >= MAX_HOUSES))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Houses, hid)) return Error(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]);
		GetPlayerFacingAngle(playerid, hData[hid][hExtposA]);
        House_Save(hid);
		House_Refresh(hid);

        SendAdminMessage(COLOR_LRED, "%s has adjusted the location of house ID: %d.", pData[playerid][pAdminname], hid);
    }
    else if(!strcmp(type, "interior", true))
    {
        GetPlayerPos(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ]);
		GetPlayerFacingAngle(playerid, hData[hid][hIntposA]);
		hData[hid][hInt] = GetPlayerInterior(playerid);

        House_Save(hid);
		House_Refresh(hid);

       /*foreach (new i : Player)
        {
            if(pData[i][pEntrance] == EntranceData[id][entranceID])
            {
                SetPlayerPos(i, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
                SetPlayerFacingAngle(i, EntranceData[id][entranceInt][3]);

                SetPlayerInterior(i, EntranceData[id][entranceInterior]);
                SetCameraBehindPlayer(i);
            }
        }*/
        SendAdminMessage(COLOR_RED, "%s has adjusted the interior spawn of house ID: %d.", pData[playerid][pAdminname], hid);
    }
    else if(!strcmp(type, "locked", true))
    {
        new locked;

        if(sscanf(string, "d", locked))
            return Usage(playerid, "/edithouse [id] [locked] [0/1]");

        if(hData[hid][hLocked] >= 2)
        	return Error(playerid, "Kamu mengubah status locked rumah yang disegel");

        if(locked < 0 || locked > 1)
            return Error(playerid, "You must specify at least 0 or 1.");

        hData[hid][hLocked] = locked;
        House_Save(hid);
		House_Refresh(hid);

        if(locked) {
            SendAdminMessage(COLOR_RED, "%s has locked house ID: %d.", pData[playerid][pAdminname], hid);
        }
        else {
            SendAdminMessage(COLOR_RED, "%s has unlocked house ID: %d.", pData[playerid][pAdminname], hid);
        }
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/edithouse [id] [Price] [Amount]");

        hData[hid][hPrice] = price;

        House_Save(hid);
		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the price of house ID: %d to %d.", pData[playerid][pAdminname], hid, price);
    }
	else if(!strcmp(type, "type", true))
    {
        new htype;

        if(sscanf(string, "d", htype))
            return Usage(playerid, "/edithouse [id] [Type] [1.small 2.medium 3.Big]");

        if(htype < 0 || htype > 3)
        	return Error(playerid, "House type only 1 - 3");
        
        hData[hid][hType] = htype;
		House_Type(hid);
        House_Save(hid);
		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the type of house ID: %d to %d.", pData[playerid][pAdminname], hid, htype);
    }
    else if(!strcmp(type, "owner", true))
    {
        new owners[MAX_PLAYER_NAME];

        if(sscanf(string, "s[32]", owners))
            return Usage(playerid, "/edithouse [id] [owner] [player name] (use '-' to no owner)");

        format(hData[hid][hOwner], MAX_PLAYER_NAME, owners);
  		hData[hid][hVisit] = gettime() + (86400 * 30);
  		
        House_Save(hid);
		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of house ID: %d to %s", pData[playerid][pAdminname], hid, owners);
    }
    else if(!strcmp(type, "owner2", true))
    {
        new ownerss[MAX_PLAYER_NAME];

        if(sscanf(string, "s[32]", ownerss))
            return Usage(playerid, "/edithouse [id] [owner2] [player name] (use '-' to no owner)");

        format(hData[hid][hOwner2], MAX_PLAYER_NAME, ownerss);
  
        House_Save(hid);
		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner2 of house ID: %d to %s", pData[playerid][pAdminname], hid, ownerss);
    }
    else if(!strcmp(type, "reset", true))
    {
        HouseReset(hid);
		House_Save(hid);
		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has reset house ID: %d.", pData[playerid][pAdminname], hid);
    }
	else if(!strcmp(type, "delete", true))
	{
		HouseReset(hid);
		
		DestroyDynamic3DTextLabel(hData[hid][hLabel]);
        DestroyDynamicPickup(hData[hid][hPickup]);
        DestroyDynamicCP(hData[hid][hCP]);
        DestroyDynamicMapIcon(hData[hid][hIcon]);
		
		hData[hid][hExtposX] = 0;
		hData[hid][hExtposY] = 0;
		hData[hid][hExtposZ] = 0;
		hData[hid][hExtposA] = 0;
		hData[hid][hPrice] = 0;
		hData[hid][hInt] = 0;
		hData[hid][hIntposX] = 0;
		hData[hid][hIntposY] = 0;
		hData[hid][hIntposZ] = 0;
		hData[hid][hIntposA] = 0;
		hData[hid][hLabel] = Text3D: INVALID_3DTEXT_ID;
		hData[hid][hPickup] = -1;
		
		Iter_Remove(Houses, hid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM houses WHERE ID=%d", hid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete house ID: %d.", pData[playerid][pAdminname], hid);
	}
    return 1;
}

/*
CMD:buyhouse(playerid, params[])
{
	foreach(new hid : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2]))
		{
			if(hData[hid][hPrice] > pData[playerid][pMoney]) return Error(playerid, "Not enough money, you can't afford this houses.");
			if(strcmp(hData[hid][hOwner], "-")) return Error(playerid, "Someone already owns this house.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 2) return Error(playerid, "You can't buy any more houses.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 3) return Error(playerid, "You can't buy any more houses.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 4) return Error(playerid, "You can't buy any more houses.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more houses.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -hData[hid][hPrice]);
			GetPlayerName(playerid, hData[hid][hOwner], MAX_PLAYER_NAME);
			hData[hid][hVisit] = gettime();
			
			House_Refresh(hid);
			House_Save(hid);
		}
	
	}
	return 1;
}*/
CMD:lockhouse(playerid, params[])
{
	foreach(new hid : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
		{
			if(!Player_OwnsHouse2(playerid, hid)) 
				return Error(playerid, "You don't own this house.");

			if(hData[hid][hLocked] >= 2)
        		return Error(playerid, "Rumah ini sedang disegel pemerintah");

			if(!hData[hid][hLocked])
			{
				hData[hid][hLocked] = 1;
				House_Save(hid);

				InfoTD_MSG(playerid, 4000, "You have ~r~locked~w~ your house!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				hData[hid][hLocked] = 0;
				House_Save(hid);

				InfoTD_MSG(playerid, 4000,"You have ~g~unlocked~w~ your house!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

CMD:givehouse(playerid, params[])
{
	new hid, otherid;
	if(sscanf(params, "ud", otherid, hid)) return Usage(playerid, "/givehouse [playerid/name] [id] | /myhouse - for show info");
	if(hid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
	
	if(!Player_OwnsHouse(playerid, hid)) 
		return Error(playerid, "You dont own this id house.");

	if(hData[hid][hLocked] >= 2)
        return Error(playerid, "Kamu tidak dapat memberi rumah yang sedang disegel pemerintah");
	
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 2) return Error(playerid, "Target player cant own any more houses.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 3) return Error(playerid, "Target player cant own any more houses.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 4) return Error(playerid, "Target player cant own any more houses.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 1) return Error(playerid, "Target player cant own any more houses.");
		#endif
	}
	GetPlayerName(otherid, hData[hid][hOwner], MAX_PLAYER_NAME);

	House_Refresh(hid);
	House_Save(hid);
	Info(playerid, "Anda memberikan rumah id: %d kepada %s", hid, ReturnName(otherid));
	Info(otherid, "%s memberikan rumah id: %d kepada anda", ReturnName(playerid), hid);
	return 1;
}

CMD:sellhouse(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 910.90, 256.46, 1289.98)) return Error(playerid, "Anda harus berada di City Hall!");
	if(GetOwnedHouses(playerid) == -1) return Error(playerid, "You don't have a houses.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedHouses(playerid), CMDSString[1024];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerHousesID(playerid, itt);
		if(hData[hid][hLocked] == 0)
		{
			lock = ""GREEN_LIGHT"Unlocked"WHITE_E"";
		}
		else if(hData[hid][hLocked] == 1)
		{
			lock = ""RED_E"Locked"WHITE_E"";
		}
		else
		{
			lock = ""RED_E"Sealed"WHITE_E"";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, hData[hid][hAddress], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, hData[hid][hAddress], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_SELL_HOUSES, DIALOG_STYLE_LIST, "Sell Houses", CMDSString, "Sell", "Cancel");
	return 1;
}

CMD:myhouse(playerid)
{
	if(GetOwnedHouses(playerid) == 0) return Error(playerid, "You don't have a houses.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedHouses(playerid), CMDSString[1024];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerHousesID(playerid, itt);
		if(hData[hid][hLocked] == 0)
		{
			lock = ""GREEN_LIGHT"Unlocked"WHITE_E"";
		}
		else if(hData[hid][hLocked] == 1)
		{
			lock = ""RED_E"Locked"WHITE_E"";
		}
		else
		{
			lock = ""RED_E"Sealed"WHITE_E"";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s)\n", itt, hData[hid][hAddress], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s)\n", itt, hData[hid][hAddress], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_HOUSES, DIALOG_STYLE_LIST, "{FF0000}Relative:RP {0000FF}Houses", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:hm(playerid, params[])
{
	if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse]))
		if(pData[playerid][pFaction] != 1)
			return Error(playerid, "Kamu bukan pemilik rumah.");

	if(hData[pData[playerid][pInHouse]][hLocked] >= 2)
		return Error(playerid, "Rumah ini sedang disegel oleh pemerintah");

	House_OpenStorage(playerid, pData[playerid][pInHouse]);
    return 1;
}

CMD:givehousekey(playerid, params[])
{
	new hid, otherid;
	if(sscanf(params, "ud", otherid, hid)) return Usage(playerid, "/givehousekey [playerid/name] [houseid] | /myhouse - for show info");
	if(hid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid playerid!");

	if(!Player_OwnsHouse(playerid, hid)) 
		return Error(playerid, "You dont own this id house.");

	if(hData[hid][hLocked] >= 2)
		return Error(playerid, "Kamu tidak dapat memberi kunci rumah yang sedang disegel");
	
	GetPlayerName(otherid, hData[hid][hOwner2], MAX_PLAYER_NAME);

	House_Refresh(hid);
	House_Save(hid);
	Info(playerid, "Anda memberikan kunci rumah id: %d kepada %s", hid, ReturnName(otherid));
	Info(otherid, "%s memberikan kunci rumah id: %d kepada anda", ReturnName(playerid), hid);
	return 1;
}

CMD:takehousekey(playerid, params[])
{
	new otherid, hid;
	if(sscanf(params, "ud", otherid, hid))
		return Usage(playerid, "/takehousekey [playerid/name] [houseid] | /myhouse - for show info");

	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");

    if(otherid == playerid)
		return Error(playerid, "Invalid playerid!");
	
	if(!Player_OwnsHouse(playerid, hid))
		return Error(playerid, "You dont own this id house.");

	if(!strcmp(hData[hid][hOwner2], "-"))
		return Error(playerid, "Rumah ini tidak memiliki pemilik kedua");

	if(strcmp(hData[hid][hOwner2], pData[otherid][pName], true))
		return Error(playerid, "Player tersebut tidak memegang kunci rumah anda");

	format(hData[hid][hOwner2], MAX_PLAYER_NAME, "-");

	House_Refresh(hid);
	House_Save(hid);
	Info(playerid, "Anda telah mengambil kunci rumah id: %d dari %s", hid, ReturnName(otherid));
	Info(otherid, "%s mengambil kunci rumah id: %d dari anda", ReturnName(playerid), hid);
	return 1;
}
//--------------[ House Dialog ]----------
