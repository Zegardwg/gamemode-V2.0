#define MAX_PAYPHONE 500

enum E_PAYPHONE
{
	ppStatus,
	ppPrice,
	Float:ppX,
	Float:ppY,
	Float:ppZ,
	Float:ppRX,
	Float:ppRY,
	Float:ppRZ,
	ppVw,
	ppInt,
	//Temp
	ppAreaid,
	ppObj,
	Text3D:ppLabel
}

new ppData[MAX_PAYPHONE][E_PAYPHONE],
Iterator:Payphone<MAX_PAYPHONE>;

Payphone_Save(id)
{
	new cQuery[1024];
	format(cQuery, sizeof(cQuery), "UPDATE payphone SET status = '%d', price = '%d', posx = '%f', posy = '%f', posz = '%f', posrx = '%f', posry = '%f', posrz = '%f', world = '%d', interior = '%d' WHERE id = '%d'",
	ppData[id][ppStatus],
	ppData[id][ppPrice],
	ppData[id][ppX],
	ppData[id][ppY],
	ppData[id][ppZ],
	ppData[id][ppRX],
	ppData[id][ppRY],
	ppData[id][ppRZ],
	ppData[id][ppVw],
	ppData[id][ppInt],
	id
	);

	return mysql_tquery(g_SQL, cQuery);
}

Payphone_Refresh(id)
{
	if(id != -1)
	{

		if(IsValidDynamicObject(ppData[id][ppObj]))
			DestroyDynamicObject(ppData[id][ppObj]);

		if(IsValidDynamicArea(ppData[id][ppAreaid]))
			DestroyDynamicArea(ppData[id][ppAreaid]);

		if(IsValidDynamic3DTextLabel(ppData[id][ppLabel]))
			DestroyDynamic3DTextLabel(ppData[id][ppLabel]);

		new str[254], status[128];
		if(ppData[id][ppStatus] == 0)
		{
			status = ""GREEN_LIGHT"Not Used";
		}
		else
		{
			status = ""RED_E"Used";
		}
		ppData[id][ppObj] = CreateDynamicObject(1216, ppData[id][ppX], ppData[id][ppY], ppData[id][ppZ], ppData[id][ppRX], ppData[id][ppRY], ppData[id][ppRZ], ppData[id][ppVw], ppData[id][ppInt], -1, 90.0, 90.0);
		ppData[id][ppAreaid] = CreateDynamicSphere(ppData[id][ppX], ppData[id][ppY], ppData[id][ppZ], 5.5, ppData[id][ppVw], ppData[id][ppInt]);
		format(str, sizeof(str), "[PAYPHONE ID: %d]\n"WHITE_E"Payphone Status: %s\n"WHITE_E"Payphone Price: "GREEN_LIGHT"%s\n"WHITE_E"/payphone - to using this payphone", id, status, FormatMoney(ppData[id][ppPrice]));
		ppData[id][ppLabel] = CreateDynamic3DTextLabel(str, COLOR_YELLOW, ppData[id][ppX], ppData[id][ppY], ppData[id][ppZ] + 1.0, 15.0);
	}
	return 1;
}

function LoadPayphone()
{
	new rows = cache_num_rows();
	if(rows)
	{
		new ppid;
		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", ppid);
			cache_get_value_name_int(i, "status", ppData[ppid][ppStatus]);
			cache_get_value_name_int(i, "price", ppData[ppid][ppPrice]);
			cache_get_value_name_float(i, "posx", ppData[ppid][ppX]);
			cache_get_value_name_float(i, "posy", ppData[ppid][ppY]);
			cache_get_value_name_float(i, "posz", ppData[ppid][ppZ]);

			cache_get_value_name_float(i, "posrx", ppData[ppid][ppRX]);
			cache_get_value_name_float(i, "posry", ppData[ppid][ppRY]);
			cache_get_value_name_float(i, "posrz", ppData[ppid][ppRZ]);

			cache_get_value_name_int(i, "world", ppData[ppid][ppVw]);
			cache_get_value_name_int(i, "interior", ppData[ppid][ppInt]);

			Payphone_Refresh(ppid);
			Iter_Add(Payphone, ppid);
		}
		printf("[PAYPHONE] Number of loaded: %d.", rows);
	}
}

Player_ResetPayphone(playerid)
{
	new ppid = pData[playerid][pGetPAYPHONEID];
	if(ppid != -1)
	{
		ppData[ppid][ppStatus] = 0;

		Payphone_Refresh(ppid);
		Payphone_Save(ppid);

		pData[playerid][pGetPAYPHONEID] = -1;
	}
}

CMD:createpayphone(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new ppid = Iter_Free(Payphone), price;

	if(ppid >= MAX_PAYPHONE)
		return Error(playerid, "Payphone dikota sudah penuh!");

	if(sscanf(params, "d", price))
		return Usage(playerid, "/payphone [price]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	ppData[ppid][ppStatus] = 0;
	ppData[ppid][ppPrice] = price;

	ppData[ppid][ppX] = x;
	ppData[ppid][ppY] = y;
	ppData[ppid][ppZ] = z;

	ppData[ppid][ppRX] = 0;
	ppData[ppid][ppRY] = 0;
	ppData[ppid][ppRZ] = 0;

	ppData[ppid][ppVw] = GetPlayerVirtualWorld(playerid);
	ppData[ppid][ppInt] = GetPlayerInterior(playerid);

	Payphone_Refresh(ppid);
	Iter_Add(Payphone, ppid);

	new cQuery[1024];
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO payphone SET id = '%d'", ppid);
	mysql_tquery(g_SQL, cQuery, "OnPayphoneCreated", "d", ppid);

	SendStaffMessage(COLOR_RED, "Staff %s has created payphone id: %d", pData[playerid][pAdminname], ppid);
	return 1;
}

function OnPayphoneCreated(id)
{
	Payphone_Save(id);
	return 1;
}

CMD:editpayphone(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5) 
		return PermissionError(playerid);

    static ppid, type[24], string[128];

    if(sscanf(params, "ds[24]S()[128]", ppid, type, string))
    {
        Usage(playerid, "/editpayphone [id] [name]");
        Names(playerid, "status, price, position, delete");
        return 1;
    }

    if(!Iter_Contains(Payphone, ppid))
    	return Error(playerid, "Invalid payphone id!");

    if(!strcmp(type, "status", true))
    {
    	new statusid;
    	if(sscanf(string, "d", statusid))
    		return Usage(playerid, "/editpayphone [ppid] [status] [statusid] (0. Not Uset | 1. Not Used)");

    	ppData[ppid][ppStatus] = statusid;
    	Payphone_Save(ppid);
    	Payphone_Refresh(ppid);

    	SendStaffMessage(COLOR_RED, "Staff %s has edited status payphone id: %d to %d", pData[playerid][pAdminname], ppid, statusid);
    }
    else if(!strcmp(type, "price", true))
    {
    	new ammount;
    	if(sscanf(string, "d", ammount))
    		return Usage(playerid, "/editpayphone [ppid] [price] [ammount]");

    	ppData[ppid][ppPrice] = ammount;
    	Payphone_Save(ppid);
    	Payphone_Refresh(ppid);

    	SendStaffMessage(COLOR_RED, "Staff %s has edited price payphone id: %d to %s", pData[playerid][pAdminname], ppid, FormatMoney(ammount));
    }
    else if(!strcmp(type, "position", true))
    {
    	if(!IsPlayerInRangeOfPoint(playerid, 30.0, ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]))
    		return Error(playerid, "Kamu harus berjarak 30m dari payphone tersebut");
    	
    	pData[playerid][pGetPAYPHONEID] = ppid;
    	EditDynamicObject(playerid, ppData[ppid][ppObj]);
    }
    else if(!strcmp(type, "delete", true))
    {
    	if(IsValidDynamicObject(ppData[ppid][ppObj]))
			DestroyDynamicObject(ppData[ppid][ppObj]);

		if(IsValidDynamicArea(ppData[ppid][ppAreaid]))
			DestroyDynamicArea(ppData[ppid][ppAreaid]);

		if(IsValidDynamic3DTextLabel(ppData[ppid][ppLabel]))
			DestroyDynamic3DTextLabel(ppData[ppid][ppLabel]);

		ppData[ppid][ppObj] = -1;
		ppData[ppid][ppAreaid] = -1;
		ppData[ppid][ppLabel] = Text3D: -1;

		ppData[ppid][ppStatus] = 0;
		ppData[ppid][ppPrice] = 0;
		ppData[ppid][ppX] = 0;
		ppData[ppid][ppY] = 0;
		ppData[ppid][ppZ] = 0;

		ppData[ppid][ppRX] = 0;
		ppData[ppid][ppRY] = 0;
		ppData[ppid][ppRZ] = 0;

    	Iter_Remove(Payphone, ppid);

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM payphone WHERE id = '%d'", ppid);
		mysql_tquery(g_SQL, query);

		SendStaffMessage(playerid, "Staff %s has deleted payphone id: %d", pData[playerid][pAdminname], ppid);
    }
    return 1;
}

CMD:payphone(playerid, params[])
{
	new count = 0;
	foreach(new ppid : Payphone)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]))
		{
			if(ppData[ppid][ppStatus] != 0)
				return Error(playerid, "Payphone sedang di gunakan");

			if(pData[playerid][pMoney] < ppData[ppid][ppPrice])
				return Error(playerid, "Kamu harus memiliki uang untuk mengakses payphone");

			count++;
			pData[playerid][pGetPAYPHONEID] = ppid;

			static ph;
			if(sscanf(params, "d", ph))
				return Usage(playerid, "/call [phone number] 933 - Taxi Call | 911 - SAPD Crime Call | 922 - SAMD Medic Call");

			if(ph == 911)
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

				pData[playerid][pCallTime] = gettime() + 60;
				SendFactionMessage(1, COLOR_BLUE, "[EMERGENCY CALL]"WHITE_E" Payphone %d calling emergency call! (Location: "YELLOW_E"%s"WHITE_E")", ppid, GetLocation(ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]));
				Info(playerid, "Warning: This number for emergency crime only! please wait for SAPD respon!");

				pData[playerid][pGetPAYPHONEID] = -1;

				GivePlayerMoneyEx(playerid, -ppData[ppid][ppPrice]);
			}
			if(ph == 922)
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

				pData[playerid][pCallTime] = gettime() + 60;
				SendFactionMessage(3, COLOR_PINK, "[EMERGENCY CALL]"WHITE_E" Payphone %d calling emergency call! (Location: "YELLOW_E"%s"WHITE_E")", ppid, GetLocation(ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]));
				Info(playerid, "Warning: This number for emergency crime only! please wait for SAMD respon!");

				pData[playerid][pGetPAYPHONEID] = -1;

				GivePlayerMoneyEx(playerid, -ppData[ppid][ppPrice]);
			}
			if(ph == 933)
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
				
				Info(playerid, "Your calling has sent to the taxi driver. please wait for respon!");

				pData[playerid][pCallTime] = gettime() + 60;
				pData[playerid][pGetPAYPHONEID] = -1;

				GivePlayerMoneyEx(playerid, -ppData[ppid][ppPrice]);
				foreach(new tx : Player)
				{
					if(pData[tx][pJob] == 1 || pData[tx][pJob2] == 1)
					{
						SendClientMessageEx(tx, COLOR_YELLOW, "[TAXI CALL]"WHITE_E" Payphone %d calling the taxi for order! (Location: "YELLOW_E"%s"WHITE_E")", ppid, GetLocation(ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]));
					}
				}
			}

			if(ph == pData[playerid][pPhone]) 
				return Info(playerid, "Nomor sedang sibuk!");

			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == ph)
				{
					if(pData[playerid][pCallTime] >= gettime())
						return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
					
					if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) 
						return Error(playerid, "This number is not actived!");

					if(pData[ii][pUsePhone] == 0) 
						return Error(playerid, "Tidak dapat menelepon, Ponsel tersebut yang dituju sedang Offline");

					if(pData[ii][pCall] == INVALID_PLAYER_ID)
					{

						ppData[ppid][ppStatus] = 1;
						Payphone_Refresh(ppid);
						Payphone_Save(ppid);

						pData[playerid][pCall] = ii;
						pData[playerid][pCallTime] = gettime() + 10;
						GivePlayerMoneyEx(playerid, -ppData[ppid][ppPrice]);
						SendClientMessageEx(playerid, COLOR_YELLOW, "[CALLING to %d] "WHITE_E"payphone begins to ring, please wait for answer!", ph);
						SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE from Payphone %d] "WHITE_E"Your phonecell is ringing, type '/p' to answer it!", ppid);

						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
						PlayerPlaySound(playerid, 3600, 0,0,0);
						PlayerPlaySound(ii, 6003, 0,0,0);

						SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a payphone and calling someone.", ReturnName(playerid));
						return 1;
					}
					else
					{
						Error(playerid, "Nomor ini sedang sibuk.");
						return 1;
					}
				}
			}
		}
	}

	if(count < 1)
		return Error(playerid, "Kamu tidak berada didekat payphone manapun");

	return 1;
}

/*

=========== ENUM PLAYER ======
pGetPAYPHONEID

pData[playerid][pGetPAYPHONEID] = -1;

============ PLAYER.pwn ======

CMD:hu(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new caller = pData[playerid][pCall];
	if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
	{
		new ppid = pData[playerid][pGetPAYPHONEID], ppoid = pData[caller][pGetPAYPHONEID];

		if(pData[playerid][pGetPAYPHONEID] != -1)
		{
			pData[caller][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
			SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
			
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their payphone.", ReturnName(playerid));
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

			ppData[ppid][ppStatus] = 0;
			pData[playerid][pGetPAYPHONEID] = -1;

			Payphone_Refresh(ppid);
			Payphone_Save(ppid);
			if(pData[caller][pGetPAYPHONEID] != -1)
			{
				ppData[ppoid][ppStatus] = 0;
				pData[caller][pGetPAYPHONEID] = -1;

				Payphone_Refresh(ppoid);
				Payphone_Save(ppoid);
			}
		}
		else if(pData[caller][pGetPAYPHONEID] != -1)
		{
			pData[caller][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
			SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their payphone.", ReturnName(caller));
			
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

			ppData[ppoid][ppStatus] = 0;
			pData[caller][pGetPAYPHONEID] = -1;

			Payphone_Refresh(ppoid);
			Payphone_Save(ppoid);
			return 1;
		}
		else
		{
			pData[caller][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
			SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
			
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			return 1;
		}
	}
	return 1;
}

==============ONPLAYER TEXT====

	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);

		new lstr[1024], caller = pData[playerid][pCall];
		if(pData[playerid][pGetPAYPHONEID] != -1)
		{
			SendClientMessageEx(pData[playerid][pCall], COLOR_YELLOW, "[CELLPHONE] "WHITE_E"%s.", text);
			format(lstr, sizeof(lstr), "[PayPhone] %s says: %s", ReturnName(playerid), text);
		}
		else if(pData[caller][pGetPAYPHONEID] != -1)
		{
			SendClientMessageEx(caller, COLOR_YELLOW, "[PAYPHONE] "WHITE_E"%s.", text);
			format(lstr, sizeof(lstr), "[CellPhone] %s says: %s", ReturnName(playerid), text);
		}
		else
		{
			SendClientMessageEx(pData[playerid][pCall], COLOR_YELLOW, "[CELLPHONE] "WHITE_E"%s.", text);
			format(lstr, sizeof(lstr), "[CellPhone] %s says: %s", ReturnName(playerid), text);
		}
		ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		return 0;
	}

============= ONPLAYERLEAVEDYNAMICAREA ============

foreach(new ppid : Payphone)
		{
			if(Iter_Contains(Payphone, ppid))
			{
				if(areaid == ppData[ppid][ppAreaid])
				{
					if(pData[playerid][pGetPAYPHONEID] != -1)
					{
						new caller = pData[playerid][pCall];
						if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
						{
							pData[caller][pCall] = INVALID_PLAYER_ID;
							SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
							SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
							
							pData[playerid][pCall] = INVALID_PLAYER_ID;
							SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their payphone.", ReturnName(playerid));
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							
							Info(playerid, "Kamu terlalu jauh dari jarak payphone, dan panggilan dimatikan");
							
							pData[playerid][pGetPAYPHONEID] = -1;
							ppData[ppid][ppStatus] = 0;

							Payphone_Refresh(ppid);
							Payphone_Save(ppid);
						}
					}
				}
			}
		}


================== ONPLAYEREDIT DYNAMIC OBJECT ========

	if(pData[playerid][pGetPAYPHONEID] != -1 && Iter_Contains(Payphone, pData[playerid][pGetPAYPHONEID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
		{
			new ppid = pData[playerid][pGetPAYPHONEID];

	        ppData[ppid][ppX] = x;
	        ppData[ppid][ppY] = y;
	        ppData[ppid][ppZ] = z;

	        ppData[ppid][ppRX] = rx;
	        ppData[ppid][ppRY] = ry;
	        ppData[ppid][ppRZ] = rz;

	        SetDynamicObjectPos(objectid, ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]);
	        SetDynamicObjectRot(objectid, ppData[ppid][ppRX], ppData[ppid][ppRY], ppData[ppid][ppRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_X, ppData[ppid][ppX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_Y, ppData[ppid][ppY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_Z, ppData[ppid][ppZ] + 1.0);

		    Payphone_Save(ppid);
	        pData[playerid][pGetPAYPHONEID] = -1;
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			new ppid = pData[playerid][pGetPAYPHONEID];

	        SetDynamicObjectPos(objectid, ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]);
	        SetDynamicObjectRot(objectid, ppData[ppid][ppRX], ppData[ppid][ppRY], ppData[ppid][ppRZ]);

	        pData[playerid][pGetPAYPHONEID] = -1;
		}
	}
*/