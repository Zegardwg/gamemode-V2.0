/*

	//NPC FAMILY
	NPCFAM_EDITPROD,
	NPCFAM_PRICESET,
	NPCFAM_BUYPROD,
	NPCFAM_MENU,
	NPCFAM_MONEY,
	NPCFAM_MONEY_WITHDRAW,
	NPCFAM_MONEY_DEPOSIT,
	NPCFAM_MATERIAL,
	NPCFAM_MATERIAL_WITHDRAW,
	NPCFAM_MATERIAL_DEPOSIT,
	NPCFAM_MARIJUANA,
	NPCFAM_MARIJUANA_WITHDRAW,
	NPCFAM_MARIJUANA_DEPOSIT,
	NPCFAM_COCAINE,
	NPCFAM_COCAINE_WITHDRAW,
	NPCFAM_COCAINE_DEPOSIT,
	NPCFAM_METH,
	NPCFAM_METH_WITHDRAW,
	NPCFAM_METH_DEPOSIT

	mysql_tquery(g_SQL, "SELECT * FROM `npcfamily`", "LoadNpcfam");

	pGetNPCFAMID
*/

#define MAX_NPCFAM 50

enum E_NPCFAM
{
	nfOwner,
	nfType,

	Float:nfPosX,
	Float:nfPosY,
	Float:nfPosZ,
	Float:nfPosA,
	nfVw,
	nfInt,
	nfMoney,
	nfMaterial,
	nfMarijuana,
	nfCocaine,
	nfMeth,
	nfPrice[10],
	//Temp
	nfPickup,
	Text3D:nfLabel
}

new nfData[MAX_NPCFAM][E_NPCFAM],
Iterator:NPCFam<MAX_NPCFAM>;

Npcfam_Save(id)
{
	new cQuery[1024];
	format(cQuery, sizeof(cQuery), "UPDATE npcfamily SET owner = '%d', type = '%d', posx = '%f', posy = '%f', posz = '%f', posa = '%f', world= '%d', interior = '%d', money = '%d', material = '%d', marijuana = '%d', cocaine = '%d', meth = '%d', price0 = '%d', price1 = '%d', price3 = '%d', price4 = '%d', price5 = '%d', price6 = '%d', price7 = '%d' WHERE id = '%d'",
	nfData[id][nfOwner],
	nfData[id][nfType],
	nfData[id][nfPosX],
	nfData[id][nfPosY],
	nfData[id][nfPosZ],
	nfData[id][nfPosA],
	nfData[id][nfVw],
	nfData[id][nfInt],
	nfData[id][nfMoney],
	nfData[id][nfMaterial],
	nfData[id][nfMarijuana],
	nfData[id][nfCocaine],
	nfData[id][nfMeth],
	nfData[id][nfPrice][0],
	nfData[id][nfPrice][1],
	nfData[id][nfPrice][2],
	nfData[id][nfPrice][3],
	nfData[id][nfPrice][4],
	nfData[id][nfPrice][5],
	nfData[id][nfPrice][6],
	id
	);

	return mysql_tquery(g_SQL, cQuery);
}

Npcfam_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamicPickup(nfData[id][nfPickup]))
			DestroyDynamicPickup(nfData[id][nfPickup]);

		if(IsValidDynamic3DTextLabel(nfData[id][nfLabel]))
			DestroyDynamic3DTextLabel(nfData[id][nfLabel]);

		new str[1024], type[128];
		if(nfData[id][nfType] == 1)
		{
			type = "Drugs";
		}
		else
		{
			type = "Weapon";
		}


		format(str, sizeof(str), "[NPCFAM ID: %d]\n"WHITE_E"Owner: "GREEN_LIGHT"%s\n"WHITE_E"Type: "GREEN_LIGHT"%s\n"WHITE_E"Location: "GREEN_LIGHT"%s\n"WHITE_E"/buy - to buy this product", id, fData[nfData[id][nfOwner]][fName], type, GetLocation(nfData[id][nfPosX], nfData[id][nfPosY], nfData[id][nfPosZ]));
		nfData[id][nfPickup] = CreateDynamicPickup(1239, 23, nfData[id][nfPosX], nfData[id][nfPosY], nfData[id][nfPosZ], nfData[id][nfVw], nfData[id][nfInt], _, 10.0);
		nfData[id][nfLabel] = CreateDynamic3DTextLabel(str, COLOR_YELLOW, nfData[id][nfPosX], nfData[id][nfPosY], nfData[id][nfPosZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, nfData[id][nfVw], nfData[id][nfInt]);
	}
	return 1;
}

function LoadNpcfam()
{
	static nfid;
	
	new rows = cache_num_rows();
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", nfid);
			cache_get_value_name_int(i, "owner", nfData[nfid][nfOwner]);
			cache_get_value_name_int(i, "type", nfData[nfid][nfType]);

			cache_get_value_name_float(i, "posx", nfData[nfid][nfPosX]);
			cache_get_value_name_float(i, "posy", nfData[nfid][nfPosY]);
			cache_get_value_name_float(i, "posz", nfData[nfid][nfPosZ]);
			cache_get_value_name_float(i, "posa", nfData[nfid][nfPosA]);

			cache_get_value_name_int(i, "world", nfData[nfid][nfVw]);
			cache_get_value_name_int(i, "interior", nfData[nfid][nfInt]);

			cache_get_value_name_int(i, "money", nfData[nfid][nfMoney]);
			cache_get_value_name_int(i, "material", nfData[nfid][nfMaterial]);
			cache_get_value_name_int(i, "marijuana", nfData[nfid][nfMarijuana]);
			cache_get_value_name_int(i, "cocaine", nfData[nfid][nfCocaine]);
			cache_get_value_name_int(i, "meth", nfData[nfid][nfMeth]);

			cache_get_value_name_int(i, "price0", nfData[nfid][nfPrice][0]);
			cache_get_value_name_int(i, "price1", nfData[nfid][nfPrice][1]);
			cache_get_value_name_int(i, "price2", nfData[nfid][nfPrice][2]);
			cache_get_value_name_int(i, "price3", nfData[nfid][nfPrice][3]);
			cache_get_value_name_int(i, "price4", nfData[nfid][nfPrice][4]);
			cache_get_value_name_int(i, "price5", nfData[nfid][nfPrice][5]);
			cache_get_value_name_int(i, "price6", nfData[nfid][nfPrice][6]);
			cache_get_value_name_int(i, "price7", nfData[nfid][nfPrice][7]);
			Npcfam_Refresh(nfid);
			Iter_Add(NPCFam, nfid);
		}
		printf("[NPC Family] Number of Loaded: %d.", rows);
	}
}

Npcfam_BuyMenu(playerid, nfid)
{
    if(nfid <= -1 )
        return 0;

    static string[1024], hstr[512];
    new fid = nfData[nfid][nfOwner];

    switch(nfData[nfid][nfType])
    {
        case 1:
        {
            format(string, sizeof(string), "Produk\tStock\tHarga\n{ffffff}Marijuana\t%d gram\t{7fff00}%s\n{ffffff}Cocaine\t%d gram\t{7fff00}%s\n{ffffff}Meth\t%d gram\t{7fff00}%s",
                nfData[nfid][nfMarijuana],
                FormatMoney(nfData[nfid][nfPrice][0]),
                nfData[nfid][nfCocaine],
                FormatMoney(nfData[nfid][nfPrice][1]),
                nfData[nfid][nfMeth],
                FormatMoney(nfData[nfid][nfPrice][2])
            );
            ShowPlayerDialog(playerid, NPCFAM_BUYPROD, DIALOG_STYLE_TABLIST_HEADERS, fData[fid][fName], string, "Buy", "Cancel");
        }
        case 2:
        {
            format(string, sizeof(string), "Produk\tAmmo\tHarga\n{ffffff}Colt45 (Mat: 250)\t70\t{7fff00}%s\n{ffffff}Desert Eagle (Mat: 500) \t34\t{7fff00}%s\n{ffffff}Shotgun (Mat: 400)\t20\t{7fff00}%s\n{ffffff}AK-47 (Mat: 750) \t200\t{7fff00}%s\n{ffffff}Micro SMG/Uzi (Mat: 300) \t200\t{7fff00}%s\n{ffffff}Patched Bomb (Mat: 500) \t1\t{7fff00}%s",
                FormatMoney(nfData[nfid][nfPrice][0]),
                FormatMoney(nfData[nfid][nfPrice][1]),
                FormatMoney(nfData[nfid][nfPrice][2]),
                FormatMoney(nfData[nfid][nfPrice][3]),
                FormatMoney(nfData[nfid][nfPrice][4]),
                FormatMoney(nfData[nfid][nfPrice][5]),
                FormatMoney(nfData[nfid][nfPrice][6])
            );
            format(hstr, sizeof(hstr), "%s (Material: %d)", fData[fid][fName], nfData[nfid][nfMaterial]);
            ShowPlayerDialog(playerid, NPCFAM_BUYPROD, DIALOG_STYLE_TABLIST_HEADERS, hstr, string, "Buy", "Cancel");
        }
    }
    return 1;
}

Npcfam_ProductMenu(playerid, nfid)
{
    if(nfid <= -1)
        return 0;

    static string[1024], hstr[512];
    new fid = nfData[nfid][nfOwner];

    switch(nfData[nfid][nfType])
    {
        case 1:
        {
            format(string, sizeof(string), "Produk\tStock\tHarga\n{ffffff}Marijuana\t%d gram\t{7fff00}%s\n{ffffff}Cocaine\t%d gram\t{7fff00}%s\n{ffffff}Meth\t%d gram\t{7fff00}%s",
                nfData[nfid][nfMarijuana],
                FormatMoney(nfData[nfid][nfPrice][0]),
                nfData[nfid][nfCocaine],
                FormatMoney(nfData[nfid][nfPrice][1]),
                nfData[nfid][nfMeth],
                FormatMoney(nfData[nfid][nfPrice][2])
            );
            ShowPlayerDialog(playerid, NPCFAM_EDITPROD, DIALOG_STYLE_TABLIST_HEADERS, fData[fid][fName], string, "Set", "Cancel");
        }
        case 2:
        {
            format(string, sizeof(string), "Produk\tAmmo\tHarga\n{ffffff}Colt45 (Mat: 250)\t70\t{7fff00}%s\n{ffffff}Desert Eagle (Mat: 500) \t34\t{7fff00}%s\n{ffffff}Shotgun (Mat: 400)\t20\t{7fff00}%s\n{ffffff}Rifle (Mat: 750)\t30\t{7fff00}%s\n{ffffff}AK-47 (Mat: 750) \t200\t{7fff00}%s\n{ffffff}Micro SMG/Uzi (Mat: 300) \t200\t{7fff00}%s\n{ffffff}Patched Bomb (Mat: 500) \t1\t{7fff00}%s",
                FormatMoney(nfData[nfid][nfPrice][0]),
                FormatMoney(nfData[nfid][nfPrice][1]),
                FormatMoney(nfData[nfid][nfPrice][2]),
                FormatMoney(nfData[nfid][nfPrice][3]),
                FormatMoney(nfData[nfid][nfPrice][4]),
                FormatMoney(nfData[nfid][nfPrice][5]),
                FormatMoney(nfData[nfid][nfPrice][6])
            );

            format(hstr, sizeof(hstr), "%s (Material: %d)", fData[fid][fName], nfData[nfid][nfMaterial]);
            ShowPlayerDialog(playerid, NPCFAM_EDITPROD, DIALOG_STYLE_TABLIST_HEADERS, hstr, string, "Set", "Cancel");
        }
    }
    return 1;
}

Npcfam_Reset(nfid)
{
	nfData[nfid][nfPosX] = 0;
	nfData[nfid][nfPosY] = 0;
	nfData[nfid][nfPosZ] = 0;
	nfData[nfid][nfPosA] = 0;

	nfData[nfid][nfMoney] = 0;
	nfData[nfid][nfMaterial] = 0;
	nfData[nfid][nfMarijuana] = 0;
	nfData[nfid][nfCocaine] = 0;
	nfData[nfid][nfMeth] = 0;

	nfData[nfid][nfPrice][0] = 0;
	nfData[nfid][nfPrice][1] = 0;
	nfData[nfid][nfPrice][2] = 0;
	nfData[nfid][nfPrice][3] = 0;
	nfData[nfid][nfPrice][4] = 0;
	nfData[nfid][nfPrice][5] = 0;
	nfData[nfid][nfPrice][6] = 0;
	nfData[nfid][nfPrice][7] = 0;

	Npcfam_Refresh(nfid);

	DestroyDynamicPickup(nfData[nfid][nfPickup]);
	DestroyDynamic3DTextLabel(nfData[nfid][nfLabel]);

	nfData[nfid][nfOwner] = -1;
	nfData[nfid][nfPickup] = -1;
	nfData[nfid][nfLabel] = Text3D: INVALID_3DTEXT_ID;
}

NpcfamCount(fid)
{
    new tmpcount;
    foreach(new nfid : NPCFam)
    {
        if(nfData[nfid][nfOwner] == fid)
        {
        	tmpcount++;
        }
    }
    return tmpcount;
}

CMD:createnpcfam(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new nfid = Iter_Free(NPCFam), famid, type;
	if(sscanf(params, "dd", famid, type))
		return Usage(playerid, "/createnpcfam [famid] [type] (Type: 1. Drug 2. Weapon)");

	if(!Iter_Contains(FAMILYS, famid))
		return Error(playerid, "Invalid Family ID!");

	if(type < 1 || type > 2)
		return Error(playerid, "Type only 1 or 2");

	if(NpcfamCount(famid) >= 2)
		return Error(playerid, "Family hanya bisa memiliki 2 NPC!");
	
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y , z);

	nfData[nfid][nfOwner] = famid;
	nfData[nfid][nfType] = type;

	nfData[nfid][nfPosX] = x;
	nfData[nfid][nfPosY] = y;
	nfData[nfid][nfPosZ] = z;
	nfData[nfid][nfPosA] = a;

	nfData[nfid][nfVw] = GetPlayerVirtualWorld(playerid);
	nfData[nfid][nfInt] = GetPlayerInterior(playerid);

	nfData[nfid][nfMoney] = 0;
	nfData[nfid][nfMaterial] = 0;
	nfData[nfid][nfMarijuana] = 0;
	nfData[nfid][nfCocaine] = 0;
	nfData[nfid][nfMeth] = 0;
	
	nfData[nfid][nfPrice][0] = 0;
	nfData[nfid][nfPrice][1] = 0;
	nfData[nfid][nfPrice][2] = 0;
	nfData[nfid][nfPrice][3] = 0;
	nfData[nfid][nfPrice][4] = 0;
	nfData[nfid][nfPrice][5] = 0;
	nfData[nfid][nfPrice][6] = 0;
	nfData[nfid][nfPrice][7] = 0;

	Npcfam_Refresh(nfid);
	Iter_Add(NPCFam, nfid);

	new cQuery[1024];
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO npcfamily SET id = '%d', owner = '%d', type = '%d'", nfid, nfData[nfid][nfOwner], nfData[nfid][nfType]);
	mysql_tquery(g_SQL, cQuery, "OnNpcfamCreated", "d", nfid);

	SendAdminMessage(COLOR_RED, "%s has created NPC Family ID: %d.", pData[playerid][pAdminname], nfid);
	return 1;
}

function OnNpcfamCreated(id)
{
	Npcfam_Save(id);
	return 1;
}

CMD:npcfam(playerid, params[])
{
	if(pData[playerid][pFamily] != -1)
	{
		if(pData[playerid][pFamilyRank] > 4)
		{
			new nfid, names[128];
			if(sscanf(params, "ds[128]", nfid, names))
			{
				Usage(playerid, "/npcfam [nfid] [names]");
				Names(playerid, "location, menu");
				return 1;
			}

			if(!Iter_Contains(NPCFam, nfid))
				return Error(playerid, "Invalid NPC Family id!");

			if(pData[playerid][pFamily] != nfData[nfid][nfOwner])
				return Error(playerid, "NPC tersebut bukan miliki family mu!");

			if(!strcmp(names, "location", true))
			{
				new Float:x, Float:y, Float:z, Float:a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);

				nfData[nfid][nfPosX] = x;
				nfData[nfid][nfPosY] = y;
				nfData[nfid][nfPosZ] = z;
				nfData[nfid][nfPosA] = a;

				nfData[nfid][nfVw] = GetPlayerVirtualWorld(playerid);
				nfData[nfid][nfInt] = GetPlayerInterior(playerid);

				Npcfam_Refresh(nfid);
				Npcfam_Save(nfid);

				Info(playerid, "Lokasi NPC Family %s (NPCID: %d) berhasil dipindahkan", fData[pData[playerid][pFamily]][fName], nfid);
			}
			else if(!strcmp(names, "menu", true))
			{
				if(!IsPlayerInRangeOfPoint(playerid, 3.5, nfData[nfid][nfPosX], nfData[nfid][nfPosY], nfData[nfid][nfPosZ]))
					return Error(playerid, "Kamu harus berada dekat denga NPC Family mu!");

				pData[playerid][pGetNPCFAMID] = nfid;
				
				new str[254];
				if(nfData[nfid][nfType] == 1)
				{
					format(str, sizeof(str), "Money (%s)\nMarijuana (%d gram)\nCocaine (%d gram)\nMeth (%d gram)\nProduct Menu", FormatMoney(nfData[nfid][nfMoney]), nfData[nfid][nfMaterial], nfData[nfid][nfMarijuana], nfData[nfid][nfCocaine], nfData[nfid][nfMeth]);
					ShowPlayerDialog(playerid, NPCFAM_MENU, DIALOG_STYLE_LIST, "NPC FAMILY (Drugs)", str, "Select", "Cancel");
				}
				else if(nfData[nfid][nfType] == 2)
				{
					format(str, sizeof(str), "Money (%s)\nMaterial (%d)\nProduct Menu", FormatMoney(nfData[nfid][nfMoney]), nfData[nfid][nfMaterial], nfData[nfid][nfMarijuana], nfData[nfid][nfCocaine], nfData[nfid][nfMeth]);
					ShowPlayerDialog(playerid, NPCFAM_MENU, DIALOG_STYLE_LIST, "NPC FAMILY (Weapon)", str, "Select", "Cancel");
				}	
			}
		}
		else return Error(playerid, "Hanya rank 5-6 yang bisa melakukan ini");
	}
	else return Error(playerid, "Kamu tidak bergabung family manapun");
	return 1;
}

CMD:deletenpcfam(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new nfid;
	if(sscanf(params, "d", nfid))
		return Usage(playerid, "/deletenpfam [nfid]");

	if(!Iter_Contains(NPCFam, nfid))
		return Error(playerid, "Invalid NPC Family id");

	Npcfam_Reset(nfid);

	Iter_Remove(NPCFam, nfid);
	
	new query[1024];
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM npcfamily WHERE id = '%d'", nfid);
	mysql_tquery(g_SQL, query);
    SendAdminMessage(COLOR_RED, "%s has delete NPC Family ID: %d.", pData[playerid][pAdminname], nfid);
    return 1;
}

CMD:fdelete(playerid, params[])
{
 	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

    new fid, query[128];
	if(sscanf(params, "i", fid)) return Usage(playerid, "/fdelete [fid]");
	if(!Iter_Contains(FAMILYS, fid)) return Error(playerid, "The you specified ID of doesn't exist.");
	
    format(fData[fid][fName], 50, "None");
	format(fData[fid][fLeader], 50, "None");
	format(fData[fid][fMotd], 50, "None");
	fData[fid][fColor] = 0;
	fData[fid][fExtposX] = 0;
	fData[fid][fExtposY] = 0;
	fData[fid][fExtposZ] = 0;
	fData[fid][fExtposA] = 0;
	
	fData[fid][fIntposX] = 0;
	fData[fid][fIntposY] = 0;
	fData[fid][fIntposZ] = 0;
	fData[fid][fIntposA] = 0;
	fData[fid][fInt] = 0;
	
	fData[fid][fMoney] = 0;
	fData[fid][fMarijuana] = 0;
	fData[fid][fComponent] = 0;
	fData[fid][fMaterial] = 0;
	fData[fid][fSafeposX] = 0;
	fData[fid][fSafeposY] = 0;
	fData[fid][fSafeposZ] = 0;
	
	DestroyDynamic3DTextLabel(fData[fid][fLabelext]);
	DestroyDynamicPickup(fData[fid][fPickext]);
	DestroyDynamic3DTextLabel(fData[fid][fLabelint]);
	DestroyDynamicPickup(fData[fid][fPickint]);
	DestroyDynamic3DTextLabel(fData[fid][fLabelsafe]);
	DestroyDynamicPickup(fData[fid][fPicksafe]);
	Iter_Remove(FAMILYS, fid);
	
	mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET family=-1,familyrank=0 WHERE family=%d", fid);
	mysql_tquery(g_SQL, query);
	
	foreach(new ii : Player)
	{
 		if(pData[ii][pFamily] == fid)
   		{
			pData[ii][pFamily]= -1;
			pData[ii][pFamilyRank] = 0;
		}
	}

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM familys WHERE ID=%d", fid);
	mysql_tquery(g_SQL, query);
    SendStaffMessage(COLOR_RED, "Admin %s telah menghapus family ID: %d.", pData[playerid][pAdminname], fid);

    for(new nfid = 0; nfid < MAX_NPCFAM; nfid++)
	{
		if(Iter_Contains(NPCFam, nfid))
		{
			if(nfData[nfid][nfOwner] == fid)
			{
				Npcfam_Reset(nfid);

				Iter_Remove(NPCFam, nfid);
				
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM npcfamily WHERE id = '%d'", nfid);
				mysql_tquery(g_SQL, query);
			    SendAdminMessage(COLOR_RED, "%s has delete NPC Family ID: %d.", pData[playerid][pAdminname], nfid);
			}
		}
	}
	return 1;
}

CMD:gotonpcfam(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);

    new nfid;
    if(sscanf(params, "d", nfid))
        return Usage(playerid, "/gotonpfam [nfid]");

    if(!Iter_Contains(NPCFam, nfid))
        return Error(playerid, "Invalid NPCFAM ID!");

    SetPlayerPos(playerid, nfData[nfid][nfPosX], nfData[nfid][nfPosY], nfData[nfid][nfPosZ]);
    SetPlayerVirtualWorld(playerid, nfData[nfid][nfVw]);
    SetPlayerInterior(playerid, nfData[nfid][nfInt]);

    Info(playerid, "Berhasil diteleport menuju NPCFAM ID: %d", nfid);
    return 1;
}