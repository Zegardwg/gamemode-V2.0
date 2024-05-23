
#define MAX_MAPO_OBJECT 1000

enum    E_MAPO
{
	// loaded from db
	Float: mapoX,
	Float: mapoY,
	Float: mapoZ,
	Float: mapoRX,
	Float: mapoRY,
	Float: mapoRZ,
	mapoObject,
	mapoInt,
	mapoWorld,
	// temp
	mapoObjID,
	Text3D: mapoLabel
}

new MapoData[MAX_MAPO_OBJECT][E_MAPO],
	Iterator:MAPO<MAX_MAPO_OBJECT>;

function LoadMAPO()
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
  	{
 		new id, i = 0;
		while(i < rows)
		{
		    cache_get_value_name_int(i, "id", id);
		    cache_get_value_name_int(i, "objectmodel", MapoData[id][mapoObject]);
			cache_get_value_name_float(i, "posx", MapoData[id][mapoX]);
			cache_get_value_name_float(i, "posy", MapoData[id][mapoY]);
			cache_get_value_name_float(i, "posz", MapoData[id][mapoZ]);
			cache_get_value_name_float(i, "posrx", MapoData[id][mapoRX]);
			cache_get_value_name_float(i, "posry", MapoData[id][mapoRY]);
			cache_get_value_name_float(i, "posrz", MapoData[id][mapoRZ]);
			cache_get_value_name_int(i, "interior", MapoData[id][mapoInt]);
			cache_get_value_name_int(i, "world", MapoData[id][mapoWorld]);
			MapoData[id][mapoObjID] = CreateDynamicObject(MapoData[id][mapoObject], MapoData[id][mapoX], MapoData[id][mapoY], MapoData[id][mapoZ], MapoData[id][mapoRX], MapoData[id][mapoRY], MapoData[id][mapoRZ], MapoData[id][mapoWorld], MapoData[id][mapoInt], -1, 90.0, 90.0);
			MapoData[id][mapoLabel] = Text3D: -1;
			Iter_Add(MAPO, id);
	    	i++;
		}
		printf("[Mapping Object] Number of Loaded: %d.", i);
	}
}

Mapo_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE mappingingame SET objectmodel='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d' WHERE id='%d'",
	MapoData[id][mapoObject],
	MapoData[id][mapoX],
	MapoData[id][mapoY],
	MapoData[id][mapoZ],
	MapoData[id][mapoRX],
	MapoData[id][mapoRY],
	MapoData[id][mapoRZ],
	MapoData[id][mapoInt],
	MapoData[id][mapoWorld],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

Mapo_Refresh(id)
{
	if(IsValidDynamicObject(MapoData[id][mapoObjID]))
		DestroyDynamicObject(MapoData[id][mapoObjID]);

	if(IsValidDynamic3DTextLabel(MapoData[id][mapoLabel]))
		DestroyDynamic3DTextLabel(MapoData[id][mapoLabel]);

	static
	 str[128];

	MapoData[id][mapoObjID] = CreateDynamicObject(MapoData[id][mapoObject], MapoData[id][mapoX], MapoData[id][mapoY], MapoData[id][mapoZ], MapoData[id][mapoRX], MapoData[id][mapoRY], MapoData[id][mapoRZ], MapoData[id][mapoWorld], MapoData[id][mapoInt], -1, 90.0, 90.0);
	format(str, sizeof(str), "[ID: %d]\n Object Model: %d", id, MapoData[id][mapoObject]);
	MapoData[id][mapoLabel] = CreateDynamic3DTextLabel(str, COLOR_LIGHTGREEN, MapoData[id][mapoX], MapoData[id][mapoY], MapoData[id][mapoZ] + 0.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, MapoData[id][mapoWorld], MapoData[id][mapoInt], -1, 10.0);
}

CMD:mappinghelp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new line3[2480];
	strcat(line3, ""WHITE_E"Mapping Commands:"LB2_E"\n\n\
 	/cobject /dobject /eobject /showmtl /hidemtl\n\
 	/cmtext /dmtext /emtext /showmtid /hidemtid");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"MAPPING SYSTEM"YELLOW_E" COMMANDS", line3, "OK","");
	return 1;
}

CMD:showmtl(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new count = 0;
	foreach(new i : MAPO)
	{
		if(Iter_Contains(MAPO, i))
		{
			if(IsValidDynamic3DTextLabel(MapoData[i][mapoLabel]))
				DestroyDynamic3DTextLabel(MapoData[i][mapoLabel]);

			new str[128];
			format(str, sizeof(str), "[ID: %d]\n Object Model: %d", i, MapoData[i][mapoObject]);
			MapoData[i][mapoLabel] = CreateDynamic3DTextLabel(str, COLOR_LIGHTGREEN, MapoData[i][mapoX], MapoData[i][mapoY], MapoData[i][mapoZ] + 0.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, MapoData[i][mapoWorld], MapoData[i][mapoInt], -1, 10.0);
		}
		count++;
	}
	SendStaffMessage(COLOR_RED, "%s telah menampilkan %d id textlabel object mapping", pData[playerid][pAdminname], count);
	return 1;
}

CMD:hidemtl(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new count = 0;
	foreach(new i : MAPO)
	{
		if(Iter_Contains(MAPO, i))
		{
			if(IsValidDynamic3DTextLabel(MapoData[i][mapoLabel]))
				DestroyDynamic3DTextLabel(MapoData[i][mapoLabel]);
		}
		count++;
	}
	SendStaffMessage(COLOR_RED, "%s telah menyembunyikan %d id text label pada object mapping", pData[playerid][pAdminname], count);
	return 1;
}

CMD:cobject(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new objectid;
	if(sscanf(params, "i", objectid)) 
	{
		Usage(playerid, "/cobject [objectid]");
		return 1;
	}
	new id = Iter_Free(MAPO), query[512];
	if(id == -1) return Error(playerid, "Can't add any more Object.");

	new Float: x, Float: y, Float: z, Float: a;
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;

	MapoData[id][mapoObject] = objectid;
	MapoData[id][mapoX] = x;
	MapoData[id][mapoY] = y;
	MapoData[id][mapoZ] = z;
	MapoData[id][mapoRX] = MapoData[id][mapoRY] = MapoData[id][mapoRZ] = 0.0;
	MapoData[id][mapoInt] = GetPlayerInterior(playerid);
	MapoData[id][mapoWorld] = GetPlayerVirtualWorld(playerid);
	
	SendAdminMessage(COLOR_RED, "%s telah membuat object ID: %d.", pData[playerid][pAdminname], id);

	Mapo_Refresh(id);
	Iter_Add(MAPO, id);
	
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO mappingingame SET id='%d', objectmodel='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d'", id, MapoData[id][mapoObject], MapoData[id][mapoX], MapoData[id][mapoY], MapoData[id][mapoZ], MapoData[id][mapoRX], MapoData[id][mapoRY], MapoData[id][mapoRZ], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	mysql_tquery(g_SQL, query, "OnMapoCreated", "ii", playerid, id);
	return 1;
}

function OnMapoCreated(playerid, id)
{
	Mapo_Save(id);
	Servers(playerid, "You has created Mapping Object id: %d.", id);
	return 1;
}

Mapo_BeingEdited(mid)
{
	if(!Iter_Contains(MAPO, mid)) return 0;
	foreach(new i : Player) if(pData[i][EditingMAPOID] == mid) return 1;
	return 0;
}

CMD:eobject(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
    	return PermissionError(playerid);

    static
        mid,
        type[24],
         string[128];

    if(sscanf(params, "ds[24]S()[128]", mid, type, string))
    {
        Usage(playerid, "/eobject [id] [name]");
        Names(playerid, "position, object");
        return 1;
    }

    if(!Iter_Contains(MAPO, mid)) 
		return Error(playerid, "Invalid ID.");

	if(Mapo_BeingEdited(mid)) 
		return Error(playerid, "Can't edited specified object because its being edited.");

    if(!strcmp(type, "position", true))
    {
    	if(pData[playerid][EditingMAPOID] != -1) 
			return Error(playerid, "You're already editing.");

    	if(!IsPlayerInRangeOfPoint(playerid, 30.0, MapoData[mid][mapoX], MapoData[mid][mapoY], MapoData[mid][mapoZ])) 
			return Error(playerid, "You're not near the atm you want to edit.");

		pData[playerid][EditingMAPOID] = mid;
		EditDynamicObject(playerid, MapoData[mid][mapoObjID]);
    }
    else if(!strcmp(type, "object", true))
    {
    	if(pData[playerid][EditingMAPOID] != -1) 
			return Error(playerid, "You're already editing.");

    	if(!IsPlayerInRangeOfPoint(playerid, 30.0, MapoData[mid][mapoX], MapoData[mid][mapoY], MapoData[mid][mapoZ])) 
			return Error(playerid, "You're not near the atm you want to edit.");

        new omodel;
        if(sscanf(string, "d", omodel))
            return Usage(playerid, "/eobject [id] [object] [objectid]");

		MapoData[mid][mapoObject] = omodel;
		Mapo_Refresh(mid);
		Mapo_Save(mid);
    }
    return 1;
}

CMD:dobject(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/dobject [id]");
	if(!Iter_Contains(MAPO, id)) return Error(playerid, "Invalid ID.");
	if(Mapo_BeingEdited(id))  return Error(playerid, "Can't deleted specified object because its being edited.");
	
	DestroyDynamicObject(MapoData[id][mapoObjID]);
	DestroyDynamic3DTextLabel(MapoData[id][mapoLabel]);
	
	pData[playerid][EditingMAPOID] = -1;
	MapoData[id][mapoX] = MapoData[id][mapoY] = MapoData[id][mapoZ] = MapoData[id][mapoRX] = MapoData[id][mapoRY] = MapoData[id][mapoRZ] = 0.0;
	MapoData[id][mapoInt] = MapoData[id][mapoWorld] = 0;
	MapoData[id][mapoObjID] = -1;
	MapoData[id][mapoLabel] = Text3D: -1;
	Iter_Remove(MAPO, id);
	DestroyDynamicObject(MapoData[id][mapoObjID]);
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM mappingingame WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus ID Object %d.", id);
	return 1;
}

CMD:gotoobj(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotoobject [id]");
	if(!Iter_Contains(MAPO, id)) return Error(playerid, "MAPO ID tidak ada.");
	
	SetPlayerPosition(playerid, MapoData[id][mapoX], MapoData[id][mapoY], MapoData[id][mapoZ], 2.0);
    SetPlayerInterior(playerid, MapoData[id][mapoInt]);
    SetPlayerVirtualWorld(playerid, MapoData[id][mapoWorld]);
	Servers(playerid, "Teleport ke ID MAPO %d", id);
	return 1;
}

/*
==========[ENUM PLAYER]============
EditingMAPOID



===========[ON PLAYER CONNECT]==========
pData[playerid][EditingMAPOID] = -1; //untuk reset value edit position di system mapping ic


=================[ON GAME MODE INIT]=================
mysql_tquery(g_SQL, "SELECT * FROM `mappingingame`", "LoadMAPO");


======================[ONPLAYER EDIT DYNAMIC OBJECT]======


	if(pData[playerid][EditingMAPOID] != -1 && Iter_Contains(MAPO, pData[playerid][EditingMAPOID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new mapoid = pData[playerid][EditingMAPOID];
	        MapoData[mapoid][mapoX] = x;
	        MapoData[mapoid][mapoY] = y;
	        MapoData[mapoid][mapoZ] = z;
	        MapoData[mapoid][mapoRX] = rx;
	        MapoData[mapoid][mapoRY] = ry;
	        MapoData[mapoid][mapoRZ] = rz;

	        SetDynamicObjectPos(objectid, MapoData[mapoid][mapoX], MapoData[mapoid][mapoY], MapoData[mapoid][mapoZ]);
	        SetDynamicObjectRot(objectid, MapoData[mapoid][mapoRX], MapoData[mapoid][mapoRY], MapoData[mapoid][mapoRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_X, MapoData[mapoid][mapoX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_Y, MapoData[mapoid][mapoY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_Z, MapoData[mapoid][mapoZ] + 0.3);

		    Mapo_Save(mapoid);
	        pData[playerid][EditingMAPOID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new mapoid = pData[playerid][EditingMAPOID];
	        SetDynamicObjectPos(objectid, MapoData[mapoid][mapoX], MapoData[mapoid][mapoY], MapoData[mapoid][mapoZ]);
	        SetDynamicObjectRot(objectid, MapoData[mapoid][mapoRX], MapoData[mapoid][mapoRY], MapoData[mapoid][mapoRZ]);
	        pData[playerid][EditingMAPOID] = -1;
	    }
	}
	return 1;
}

*/




//===============================[MATERIAL TEXT]===============

#define MAX_MATEXT 500

enum E_MATEXT
{
	Float:mtX,
	Float:mtY,
	Float:mtZ,
	Float:mtRX,
	Float:mtRY,
	Float:mtRZ,
	mtInt,
	mtVW,
	//Inti
	mtText[254],
	mtSize,
	mtColor,
	mtBold,
	//Temp
	mtObj,
	Text3D:mtLabel
}

new mtData[MAX_MATEXT][E_MATEXT],
Iterator: Matext<MAX_MATEXT>;

Matext_Save(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE matext SET text='%s', size='%d', color='%d', bold='%d', x='%f', y='%f', z='%f', rx='%f', ry='%f', rz='%f', interior='%d', world='%d' WHERE id='%d'",
	mtData[id][mtText],
	mtData[id][mtSize],
	mtData[id][mtColor],
	mtData[id][mtBold],
	mtData[id][mtX],
	mtData[id][mtY],
	mtData[id][mtZ],
	mtData[id][mtRX],
	mtData[id][mtRY],
	mtData[id][mtRZ],
	mtData[id][mtInt],
	mtData[id][mtVW],
	id);

	return mysql_tquery(g_SQL, cQuery);
}

Matext_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamicObject(mtData[id][mtObj]))
			DestroyDynamicObject(mtData[id][mtObj]);

		static color;

		switch(mtData[id][mtColor])
		{
		    case 1: color = 0xFFFFFFFF;//Putih
		    case 2: color = 0xFF6347FF;//Biru
		    case 3: color = 0xFFFF6347;//Merah
		    case 4: color = 0xFFFFFF00;//Kuning
		}
		mtData[id][mtObj] = CreateDynamicObject(19482, mtData[id][mtX], mtData[id][mtY], mtData[id][mtZ] - 0.0, mtData[id][mtRX], mtData[id][mtRY], mtData[id][mtRZ], mtData[id][mtVW], mtData[id][mtInt], -1, 90.0, 90.0);
		SetDynamicObjectMaterial(mtData[id][mtObj], 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
        SetDynamicObjectMaterialText(mtData[id][mtObj], 0, mtData[id][mtText], 130, "Arial", mtData[id][mtSize], mtData[id][mtBold], color, 0x00000000, 0);
	}
	return 1;
}

Matext_Label(id)
{
	if(id != -1)
	{
		static label[254];

		if(IsValidDynamic3DTextLabel(mtData[id][mtLabel]))
			DestroyDynamic3DTextLabel(mtData[id][mtLabel]);

	    format(label, sizeof(label), "Material Text\nID : %d", id);
        mtData[id][mtLabel] = CreateDynamic3DTextLabel(label, COLOR_LIGHTGREEN, mtData[id][mtX], mtData[id][mtY], mtData[id][mtZ] + 1.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, mtData[id][mtVW], mtData[id][mtInt], -1, 10.0);
	}
	return 1;
}

function LoadMatext()
{
    static mtid;
	
	new rows = cache_num_rows(), string[254];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", mtid);
			cache_get_value_name(i, "text", string);
			format(mtData[mtid][mtText], 254, string);
			cache_get_value_name_int(i, "size", mtData[mtid][mtSize]);
			cache_get_value_name_int(i, "color", mtData[mtid][mtColor]);
			cache_get_value_name_int(i, "bold", mtData[mtid][mtBold]);
			cache_get_value_name_float(i, "x", mtData[mtid][mtX]);
			cache_get_value_name_float(i, "y", mtData[mtid][mtY]);
			cache_get_value_name_float(i, "z", mtData[mtid][mtZ]);
			cache_get_value_name_float(i, "rx", mtData[mtid][mtRX]);
			cache_get_value_name_float(i, "ry", mtData[mtid][mtRY]);
			cache_get_value_name_float(i, "rz", mtData[mtid][mtRZ]);
			cache_get_value_name_int(i, "interior", mtData[mtid][mtInt]);
			cache_get_value_name_int(i, "world", mtData[mtid][mtVW]);
			Matext_Refresh(mtid);
			Iter_Add(Matext, mtid);
		}
		printf("[Material Text] Number of Loaded: %d.", rows);
	}
}

CMD:cmtext(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new mtid = Iter_Free(Matext), query[512];
	if(mtid == -1)
		return Error(playerid, "You cant create more matext!");

	new text[254];
	if(sscanf(params, "s", text))
		return Usage(playerid, "/cmtext [text]");

	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	x += 1.0 * floatsin(-a, degrees);
	y += 1.0 * floatcos(-a, degrees);

	format(mtData[mtid][mtText], 254, text);
	mtData[mtid][mtX] = x;
	mtData[mtid][mtY] = y;
	mtData[mtid][mtZ] = z;
	mtData[mtid][mtRX] = 0.0;
	mtData[mtid][mtRY] = 0.0;
	mtData[mtid][mtRZ] = a;
	mtData[mtid][mtSize] = 30; //Default Size adalah 30
    mtData[mtid][mtColor] = 1;
    mtData[mtid][mtBold] = 0;
    mtData[mtid][mtInt] = GetPlayerInterior(playerid);
    mtData[mtid][mtVW] = GetPlayerVirtualWorld(playerid);

    Matext_Refresh(mtid);
    Matext_Label(mtid);
    Iter_Add(Matext, mtid);
   	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO matext SET id='%d', text='%s'", mtid, mtData[mtid][mtText]);
	mysql_tquery(g_SQL, query, "OnMatextCreated", "i", mtid);
	return 1;
}

function OnMatextCreated(id)
{
	Matext_Save(id);
	return 1;
}

Matext_BeingEdited(mtid)
{
	if(!Iter_Contains(Matext, mtid)) return 0;
	foreach(new i : Player) if(pData[i][EditingMATEID] == mtid) return 1;
	return 0;
}

CMD:emtext(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

    static mtid, type[24], string[128];

	if(sscanf(params, "ds[24]S()[128]", mtid, type, string))
    {
        Usage(playerid, "/emtext [id] [name]");
        Names(playerid, "position, text, size, color, bold");
        return 1;
    }

    if(!Iter_Contains(Matext, mtid))
    	return Error(playerid, "Invalid ID");

    if(!IsPlayerInRangeOfPoint(playerid, 50.0, mtData[mtid][mtX], mtData[mtid][mtY], mtData[mtid][mtZ]))
    	return Error(playerid, "Kamu harus berjarak 50 meter dari id tersebut");
    
    if(Matext_BeingEdited(mtid)) 
		return Error(playerid, "Can't edited specified matext because its being edited.");

    if(!strcmp(type, "position", true))
    {
    	pData[playerid][EditingMATEID] = mtid;
    	Matext_Label(mtid);
    	EditDynamicObject(playerid, mtData[mtid][mtObj]);
    }
    else if(!strcmp(type, "text", true))
    {
    	new txt[254];
    	if(sscanf(string, "s[254]", txt))
    		return Usage(playerid, "/emtext [id] [text] [write text]");

    	format(mtData[mtid][mtText], 254, txt);
    	Matext_Refresh(mtid);
    	Matext_Save(mtid);

    	SendStaffMessage(COLOR_RED, "%s adjusted text of matext ID: %d to (%s)", pData[playerid][pAdminname], mtid, txt);
    }
    else if(!strcmp(type, "size", true))
    {
    	new sze;
    	if(sscanf(string, "d", sze))
    		return Usage(playerid, "/emtext [id] [size] [size number] (default size 30)");

    	mtData[mtid][mtSize] = sze;
    	Matext_Refresh(mtid);
    	Matext_Save(mtid);

    	SendStaffMessage(COLOR_RED, "%s adjusted size text of matext ID: %d to %dpx", pData[playerid][pAdminname], mtid, sze);
    }
    else if(!strcmp(type, "color", true))
    {
    	new colorid;
    	if(sscanf(string, "d", colorid))
    	{
    		Usage(playerid, "/emtext [id] [color] [colorid]");
    		Names(playerid, "1. White | 2. Blue | 3. Red | 4. Yellow");
    		return 1;
    	}

   		if(colorid < 0 || colorid > 4)
    	return Error(playerid, "Color ID only 1-4!");

    	mtData[mtid][mtColor] = colorid;
	    Matext_Refresh(mtid);
	    Matext_Save(mtid);

		SendStaffMessage(COLOR_RED, "%s adjusted color text of matext ID: %d to %d", pData[playerid][pAdminname], mtid, colorid);
    }
    else if(!strcmp(type, "bold", true))
    {
    	new boldid;
    	if(sscanf(string, "d", boldid))
    		return Usage(playerid, "/emtext [id] [bold] (0.No || 1.Yes)");

    	if(boldid < 0 || boldid > 1)
    		return Error(playerid, "Type bold only 0 or 1!");

    	mtData[mtid][mtBold] = boldid;
    	Matext_Refresh(mtid);
    	Matext_Save(mtid);

    	SendStaffMessage(COLOR_RED, "%s adjusted bold text of matext ID: %d to %d", pData[playerid][pAdminname], mtid, boldid);
    }
    return 1;
}

CMD:dmtext(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new id, query[512];
	if(sscanf(params, "i", id)) 
		return Usage(playerid, "/dmtext [id]");

	if(!Iter_Contains(Matext, id)) 
		return Error(playerid, "Invalid ID.");

	if(Matext_BeingEdited(id)) 
		return Error(playerid, "Can't deleted specified matext because its being edited.");
	
	DestroyDynamicObject(mtData[id][mtObj]);
	DestroyDynamic3DTextLabel(mtData[id][mtLabel]);
	
	pData[playerid][EditingMATEID] = -1;
	mtData[id][mtX] = mtData[id][mtY] = mtData[id][mtZ] = 0.0;
	mtData[id][mtRX] = mtData[id][mtRY] = mtData[id][mtRZ] = 0.0;
	mtData[id][mtInt] = mtData[id][mtVW] = 0;
	mtData[id][mtObj] = -1;
	mtData[id][mtLabel] = Text3D: -1;

	Iter_Remove(Matext, id);
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM matext WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus Matext ID %d.", id);
	return 1;
}

CMD:showmtid(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new count = 0;
	foreach(new mtid : Matext)
	{
		if(Iter_Contains(Matext, mtid))
		{
			Matext_Label(mtid);
		}
		count++;
	}
	SendStaffMessage(COLOR_RED, "%s telah menampilkan %d id textlabel material text", pData[playerid][pAdminname], count);
	return 1;
}

CMD:hidemtid(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new count = 0;
	foreach(new mtid : Matext)
	{
		if(Iter_Contains(Matext, mtid))
		{
			if(IsValidDynamic3DTextLabel(mtData[mtid][mtLabel]))
				DestroyDynamic3DTextLabel(mtData[mtid][mtLabel]);
		}
		count++;
	}
	SendStaffMessage(COLOR_RED, "%s telah menyembunyikan %d id text label pada material text", pData[playerid][pAdminname], count);
	return 1;
}

/*
	//MATEXT EDIT

	if(pData[playerid][EditingMATEID] != -1 && Iter_Contains(Matext, pData[playerid][EditingMATEID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new mtid = pData[playerid][EditingMATEID];
	        mtData[mtid][mtX] = x;
	        mtData[mtid][mtY] = y;
	        mtData[mtid][mtZ] = z;
	        mtData[mtid][mtRX] = rx;
	        mtData[mtid][mtRY] = ry;
	        mtData[mtid][mtRZ] = rz;

	        SetDynamicObjectPos(objectid, mtData[mtid][mtX], mtData[mtid][mtY], mtData[mtid][mtZ]);
	        SetDynamicObjectRot(objectid, mtData[mtid][mtRX], mtData[mtid][mtRY], mtData[mtid][mtRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_X, mtData[mtid][mtX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_Y, mtData[mtid][mtY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_Z, mtData[mtid][mtZ] + 1.5);

		    Matext_Save(mtid);
	        pData[playerid][EditingMATEID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new mtid = pData[playerid][EditingMATEID];
	        SetDynamicObjectPos(objectid, mtData[mtid][mtX], mtData[mtid][mtY], mtData[mtid][mtZ]);
	        SetDynamicObjectRot(objectid, mtData[mtid][mtRX], mtData[mtid][mtRY], mtData[mtid][mtRZ]);
	        pData[playerid][EditingMATEID] = -1;
	    }
	}

*/