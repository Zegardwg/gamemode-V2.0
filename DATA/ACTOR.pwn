#define MAX_ACTOR 500

enum E_ACTOR
{
	actName[128],
	actSkin,
	actBizid,
	actVuln,
	Float:actX,
	Float:actY,
	Float:actZ,
	Float:actA,
	actInt,
	actVW,
	actAnim,
	//TEMP
	actObj,
	Text3D:actLabel
}

new ActData[MAX_ACTOR][E_ACTOR],
Iterator:Actors<MAX_ACTOR>;

Actor_Save(id)
{
	new dquery[2048];
	format(dquery, sizeof(dquery), "UPDATE actors SET name='%s', skinid='%d', bizid='%d', posx='%f', posy='%f', posz='%f', posa='%f', vuln='%d', interior='%d', world='%d', anim='%d' WHERE id='%d'",
	ActData[id][actName],
	ActData[id][actSkin],
	ActData[id][actBizid],
	ActData[id][actX],
	ActData[id][actY],
	ActData[id][actZ],
	ActData[id][actA],
	ActData[id][actVuln],
	ActData[id][actInt],
	ActData[id][actVW],
	ActData[id][actAnim],
	id);

	return mysql_tquery(g_SQL, dquery);
}

Actor_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamicActor(ActData[id][actObj]))
			DestroyDynamicActor(ActData[id][actObj]);

		if(IsValidDynamic3DTextLabel(ActData[id][actLabel]))
			DestroyDynamic3DTextLabel(ActData[id][actLabel]);

		new string[1024];		
		format(string, sizeof(string), "%s (%d)", ActData[id][actName], id);
		ActData[id][actObj] = CreateDynamicActor(ActData[id][actSkin], ActData[id][actX], ActData[id][actY], ActData[id][actZ], 0.0, ActData[id][actVuln], 100.0, ActData[id][actVW], ActData[id][actInt], -1);
		ActData[id][actLabel] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ActData[id][actX], ActData[id][actY], ActData[id][actZ]+1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ActData[id][actVW], ActData[id][actInt]);
		SetDynamicActorInvulnerable(ActData[id][actObj], 1);
		SetDynamicActorFacingAngle(ActData[id][actObj], ActData[id][actA]);

		switch(ActData[id][actAnim])
		{
			case 0:
			{
				//Disable Animations
				ClearDynamicActorAnimations(ActData[id][actObj]);
			}
			case 1:
			{
				//Injured
				ApplyDynamicActorAnimation(ActData[id][actObj], "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0);
			}
			case 2:
			{
				//Handsup
				ApplyDynamicActorAnimation(ActData[id][actObj], "SHOP", "SHP_Rob_HandsUp", 4.1, 1, 0, 0, 0, 0);
			}
			case 3:
			{
				//sit
				ApplyDynamicActorAnimation(ActData[id][actObj], "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0);
			}
			case 4:
			{
				//lean
				ApplyDynamicActorAnimation(ActData[id][actObj], "GANGS", "leanIDLE", 4.1, 1, 0, 0, 0, 0);
			}
			case 5:
			{
				//dance
				ApplyDynamicActorAnimation(ActData[id][actObj], "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0);
			}
			case 6:
			{
				//dealstance
				ApplyDynamicActorAnimation(ActData[id][actObj], "DEALER", "DEALER_IDLE", 4.1, 1, 0, 0, 0, 0);
			}
			case 7:
			{
				//riotchant
				ApplyDynamicActorAnimation(ActData[id][actObj], "RIOT", "RIOT_CHANT", 4.1, 1, 0, 0, 0, 0);
			}
			case 8:
			{
				//wave
				ApplyDynamicActorAnimation(ActData[id][actObj], "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0);
			}
			case 9:
			{
				//hide
				ApplyDynamicActorAnimation(ActData[id][actObj], "ped", "cower", 4.1, 1, 0, 0, 0, 0);
			}
			case 10:
			{
				//crossarms
				ApplyDynamicActorAnimation(ActData[id][actObj], "DEALER", "DEALER_IDLE", 4.1, 1, 0, 0, 0, 0);
			}
			case 11:
			{
				//laugh
				ApplyDynamicActorAnimation(ActData[id][actObj], "RAPPING", "Laugh_01", 4.1, 1, 0, 0, 0, 0);
			}
			case 12:
			{
				//talk
				ApplyDynamicActorAnimation(ActData[id][actObj], "PED", "IDLE_CHAT", 4.1, 1, 0, 0, 0, 0);
			}
			case 13:
			{
				//fucku
				ApplyDynamicActorAnimation(ActData[id][actObj], "PED", "fucku", 4.1, 1, 0, 0, 0, 0);
			}
			case 14:
			{
				//tired
				ApplyDynamicActorAnimation(ActData[id][actObj], "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0);
			}
			case 15:
			{
				//chairsit
				ApplyDynamicActorAnimation(ActData[id][actObj], "PED", "SEAT_idle", 4.1, 1, 0, 0, 0, 0);
			}
		}
	}
	return 1;
}

function LoadActor()
{
	new rows = cache_num_rows();
 	if(rows)
  	{
   		new actid, actname[128];
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", actid);
			cache_get_value_name(i, "name", actname);
			format(ActData[actid][actName], 128, actname);
			cache_get_value_name_int(i, "bizid", ActData[actid][actBizid]);
			cache_get_value_name_int(i, "skinid", ActData[actid][actSkin]);
			cache_get_value_name_float(i, "posx", ActData[actid][actX]);
			cache_get_value_name_float(i, "posy", ActData[actid][actY]);
			cache_get_value_name_float(i, "posz", ActData[actid][actZ]);
			cache_get_value_name_float(i, "posa", ActData[actid][actA]);
			cache_get_value_name_int(i, "vuln", ActData[actid][actVuln]);
			cache_get_value_name_int(i, "interior", ActData[actid][actInt]);
			cache_get_value_name_int(i, "world", ActData[actid][actVW]);
			cache_get_value_name_int(i, "anim", ActData[actid][actAnim]);
			Actor_Refresh(actid);
			Iter_Add(Actors, actid);
		}
		printf("[Actor] Number of Actor loaded: %d.", rows);
	}
}

GetBisnisActor(bid)
{
	new tmpcount = 0;
	foreach(new actid : Actors)
	{
		if(ActData[actid][actBizid] == bid)
		{
			tmpcount++;
		}
	}
	return tmpcount;
}

DeleteActorBusiness(bid)
{
	if(GetBisnisActor(bid) <= 0)
		return 1;

	if(bid != -1)
	{
		new query[512];
		for(new actid = 0; actid < MAX_ACTORS; actid++)
		{
			if(Iter_Contains(Actors, actid))
			{
				if(ActData[actid][actBizid] == bid)
				{
					if(IsValidDynamicActor(ActData[actid][actObj]))
						DestroyDynamicActor(ActData[actid][actObj]);

					if(IsValidDynamic3DTextLabel(ActData[actid][actLabel]))
						DestroyDynamic3DTextLabel(ActData[actid][actLabel]);

					ActData[actid][actX] = ActData[actid][actY] = ActData[actid][actZ] = ActData[actid][actA] = 0;
					ActData[actid][actInt] = ActData[actid][actVW] = 0;

					Iter_Remove(Actors, actid);

					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM actors WHERE id=%d", actid);
					mysql_tquery(g_SQL, query);
					SendStaffMessage(COLOR_RED, "Actor ID: %d milik business ID: %d telah dihapus.", actid, bid);
				}
			}
		}
	}
	return 1;
}

CreateActorBusiness(bid, skinid, Float:x, Float:y, Float:z, Float:a)
{	
	if(GetBisnisActor(bid) > 0)
		return 1;

	if(bid != -1)
	{
		new actid = Iter_Free(Actors), query[512];

		if(actid >= MAX_ACTORS)
			return 1;

		format(ActData[actid][actName], 128, "Business Cashier");
		if(bData[bid][bType] == 1) //Fast Food
		{
			ActData[actid][actSkin] = skinid;
			ActData[actid][actX] = x;
			ActData[actid][actY] = y;
			ActData[actid][actZ] = z;
			ActData[actid][actA] = a;
			ActData[actid][actVuln] = 1;
			ActData[actid][actAnim] = 0;
			ActData[actid][actBizid] = bid;
			ActData[actid][actInt] = bData[bid][bInt];
			ActData[actid][actVW] = bid;
		}
		else if(bData[bid][bType] == 2) //Market
		{
			ActData[actid][actSkin] = skinid;
			ActData[actid][actX] = x;
			ActData[actid][actY] = y;
			ActData[actid][actZ] = z;
			ActData[actid][actA] = a;
			ActData[actid][actVuln] = 1;
			ActData[actid][actAnim] = 0;
			ActData[actid][actBizid] = bid;
			ActData[actid][actInt] = bData[bid][bInt];
			ActData[actid][actVW] = bid;
		}
		else if(bData[bid][bType] == 3) //Clothes
		{
			ActData[actid][actSkin] = skinid;
			ActData[actid][actX] = x;
			ActData[actid][actY] = y;
			ActData[actid][actZ] = z;
			ActData[actid][actA] = a;
			ActData[actid][actVuln] = 1;
			ActData[actid][actAnim] = 0;
			ActData[actid][actBizid] = bid;
			ActData[actid][actInt] = bData[bid][bInt];
			ActData[actid][actVW] = bid;
		}
		else if(bData[bid][bType] == 4) //Equipment
		{
			ActData[actid][actSkin] = skinid;
			ActData[actid][actX] = x;
			ActData[actid][actY] = y;
			ActData[actid][actZ] = z;
			ActData[actid][actA] = a;
			ActData[actid][actVuln] = 1;
			ActData[actid][actAnim] = 0;
			ActData[actid][actBizid] = bid;
			ActData[actid][actInt] = bData[bid][bInt];
			ActData[actid][actVW] = bid;
		}
		else if(bData[bid][bType] == 5) //Gun Shop
		{
			ActData[actid][actSkin] = skinid;
			ActData[actid][actX] = x;
			ActData[actid][actY] = y;
			ActData[actid][actZ] = z;
			ActData[actid][actA] = a;
			ActData[actid][actVuln] = 1;
			ActData[actid][actAnim] = 0;
			ActData[actid][actBizid] = bid;
			ActData[actid][actInt] = bData[bid][bInt];
			ActData[actid][actVW] = bid;
		}
		else if(bData[bid][bType] == 6) //Gym
		{
			ActData[actid][actSkin] = skinid;
			ActData[actid][actX] = x;
			ActData[actid][actY] = y;
			ActData[actid][actZ] = z;
			ActData[actid][actA] = a;
			ActData[actid][actVuln] = 1;
			ActData[actid][actAnim] = 0;
			ActData[actid][actBizid] = bid;
			ActData[actid][actInt] = bData[bid][bInt];
			ActData[actid][actVW] = bid;
		}
		SendAdminMessage(COLOR_RED, "Actor ID: %d telah dibuat pada bisnis ID: %d", actid, bid);

		Actor_Refresh(actid);
		Iter_Add(Actors, actid);
		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO actors SET id='%d', vuln='%d'", actid, ActData[actid][actVuln]);
		mysql_tquery(g_SQL, query, "OnActorCreated", "i", actid);
	}
	return 1;
}

CMD:createactor(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new actid = Iter_Free(Actors), skinid, query[512];

	if(actid == -1)
		return Error(playerid, "Actor Full");

	if(sscanf(params, "d", skinid))
		return Usage(playerid, "/createactor [skinid]");

	if(skinid < 0 || skinid > 299)
        return Error(playerid, "Invalid skin ID. Skins range from 0 to 299.");

	new Float:x, Float:y, Float:z, Float:a;
	format(ActData[actid][actName], 128, "None");
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	ActData[actid][actSkin] = skinid;
	ActData[actid][actBizid] = -1;
	ActData[actid][actX] = x;
	ActData[actid][actY] = y;
	ActData[actid][actZ] = z;
	ActData[actid][actA] = a;
	ActData[actid][actVuln] = 1;
	ActData[actid][actAnim] = 0;
	ActData[actid][actInt] = GetPlayerInterior(playerid);
	ActData[actid][actVW] = GetPlayerVirtualWorld(playerid);

	SendStaffMessage(COLOR_RED, "%s telah membuat actor ID: %d.", pData[playerid][pAdminname], actid);
	Actor_Refresh(actid);
	Iter_Add(Actors, actid);
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO actors SET id='%d', vuln='%d'", actid, ActData[actid][actVuln]);
	mysql_tquery(g_SQL, query, "OnActorCreated", "i", actid);
	return 1;
}

CMD:gotoactor(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
	 return PermissionError(playerid);

	new actid;
	if(sscanf(params, "d", actid))
		return Usage(playerid, "/gotoactor [id]");

	if(!Iter_Contains(Actors, actid)) 
		return Error(playerid, "Invalid ID.");

	SetPlayerPos(playerid, ActData[actid][actX], ActData[actid][actY], ActData[actid][actZ]+3.5);
	SetPlayerInterior(playerid, ActData[actid][actInt]);
	SetPlayerVirtualWorld(playerid, ActData[actid][actVW]);
	return 1;
}

CMD:editactor(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	static
     actid,
      type[24],
       string[128];

	if(sscanf(params, "ds[24]S()[128]", actid, type, string))
	{
		Usage(playerid, "/editactor [id] [type]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAME]:{FFFFFF}position, skin, anim, name, delete");
		return 1;
	}

	if(!Iter_Contains(Actors, actid))
		return Error(playerid, "Invalid Actor ID");

	if(!strcmp(type, "position", true))
	{
		if(ActData[actid][actBizid] != -1)
			return Error(playerid, "Kamu tidak bisa merubah posisi actor bisnis");

		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		ActData[actid][actX] = x;
		ActData[actid][actY] = y;
		ActData[actid][actZ] = z;
		ActData[actid][actA] = a;
		ActData[actid][actInt] = GetPlayerInterior(playerid);
		ActData[actid][actVW] = GetPlayerVirtualWorld(playerid);

		Actor_Refresh(actid);
		Actor_Save(actid);
	}
	if(!strcmp(type, "skin", true))
	{
		new skinid;
		if(sscanf(string, "d", skinid))
			return Usage(playerid, "/editactor [id] [skin] [skinid]");

		if(skinid < 0 || skinid > 299)
        	return Error(playerid, "Invalid skin ID. Skins range from 0 to 299.");

		ActData[actid][actSkin] = skinid;
		Actor_Refresh(actid);
		Actor_Save(actid);
	}
	if(!strcmp(type, "anim", true))
	{
		new animid;
		if(sscanf(string, "d", animid))
		{
			Usage(playerid, "/editactor [id] [anim] [animid]");
			new str[1024];
			format(str, sizeof(str), ""YELLOW_E"0."WHITE_E" Disable Animations\n");
			format(str, sizeof(str), "%s"YELLOW_E"1."WHITE_E" Injured\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"2."WHITE_E" Handsup\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"3."WHITE_E" Sit\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"4."WHITE_E" Lean\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"5."WHITE_E" Dance\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"6."WHITE_E" Dealstance\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"7."WHITE_E" Riotchant\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"8."WHITE_E" Wave\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"9."WHITE_E" Hide\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"10."WHITE_E" Crossarms\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"11."WHITE_E" Laugh\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"12."WHITE_E" Talk\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"13."WHITE_E" Fucku\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"14."WHITE_E" Tired\n", str);
			format(str, sizeof(str), "%s"YELLOW_E"15."WHITE_E" Chairsit\n", str);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{ff0000}Anim ID Actor", str, "Yes", "");
			return 1;
		}

		if(animid < 0 || animid > 15)
			return Error(playerid, "Anim only 0-15!");

		ActData[actid][actAnim] = animid;
		Actor_Refresh(actid);
		Actor_Save(actid);
	}
	if(!strcmp(type, "name", true))
    {
    	if(ActData[actid][actBizid] != -1)
			return Error(playerid, "Kamu tidak bisa merubah nama actor bisnis");

        new text[128];
        if(sscanf(string, "s[128]", text))
            return Usage(playerid, "/editactor [id] [name] [actor name]");

        if(strlen(text) > 20)
            return Error(playerid, "Text tidak boleh lebih dari 20 character!");

        format(ActData[actid][actName], 128, text);
        Actor_Save(actid);
        Actor_Refresh(actid);

        SendStaffMessage(playerid,"Staff %s merubah name actor id : %d menjadi '%s'", pData[playerid][pAdminname], actid, ActData[actid][actName]);
    }
	if(!strcmp(type, "delete", true))
	{
		if(ActData[actid][actBizid] != -1)
			return Error(playerid, "Kamu tidak dapat menghapus actor yang terkait dengan bisnis!");
		
		new query[512];
		if(IsValidDynamicActor(ActData[actid][actObj]))
			DestroyDynamicActor(ActData[actid][actObj]);

		if(IsValidDynamic3DTextLabel(ActData[actid][actLabel]))
			DestroyDynamic3DTextLabel(ActData[actid][actLabel]);

		ActData[actid][actX] = ActData[actid][actY] = ActData[actid][actZ] = ActData[actid][actA] = 0;
		ActData[actid][actInt] = ActData[actid][actVW] = 0;

		Iter_Remove(Actors, actid);

		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM actors WHERE id=%d", actid);
		mysql_tquery(g_SQL, query);
		SendStaffMessage(COLOR_RED, "Staff %s menghapus Actor ID %d.", pData[playerid][pAdminname], actid);
	}
	return 1;
}

function OnActorCreated(actid)
{
	Actor_Save(actid);
	return 1;
}