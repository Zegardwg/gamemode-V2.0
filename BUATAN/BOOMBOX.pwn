#define MAX_BOOMBOX 50

enum E_BOOMBOX
{
	bbOwner[128],
	Float:bbPosX,
	Float:bbPosY,
	Float:bbPosZ,
	Float:bbPosA,
	bbInt,
	bbVw,
	bbObj,
	Text3D:bbLabel,
	bbAreaid,
	bbUrl[254]
};

new bbData[MAX_BOOMBOX][E_BOOMBOX],
Iterator:Boombox<MAX_BOOMBOX>;

Boombox_Nearest(playerid)
{
	foreach(new i : Boombox)
	{
		if(Iter_Contains(Boombox, i))
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0, bbData[i][bbPosX], bbData[i][bbPosY], bbData[i][bbPosZ]))
			{
				return i;
			}
		}
	}
	return -1;
}

Player_OwnsBoombox(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(bbData[id][bbOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

Boombox_Refresh(bbid)
{
	new str[1024];
	if(IsValidDynamicObject(bbData[bbid][bbObj]))
		DestroyDynamicObject(bbData[bbid][bbObj]);

	if(IsValidDynamic3DTextLabel(bbData[bbid][bbLabel]))
		DestroyDynamic3DTextLabel(bbData[bbid][bbLabel]);

	bbData[bbid][bbObj] = CreateDynamicObject(2226, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]-1.0, 0.0, 0.0, 0.0, bbData[bbid][bbVw], bbData[bbid][bbInt], -1, 80.0, 80.0);
	format(str, sizeof(str), "[BOOMBOX ID: %d]"WHITE_E"\nOwner: "YELLOW_E"%s"WHITE_E"\nLocation: "YELLOW_E"%s"WHITE_E"\n/boombox menu - to setting boombox audio", bbid, bbData[bbid][bbOwner], GetLocation(bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]));
	bbData[bbid][bbLabel] = CreateDynamic3DTextLabel(str, COLOR_GREEN, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]-0.5, 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, bbData[bbid][bbVw], bbData[bbid][bbInt]);
}

Boombox_Delete(bbid)
{
	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, 30.0, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]))
		{
			StopAudioStreamForPlayer(i);
		}
	}
	bbData[bbid][bbObj] = INVALID_OBJECT_ID;
	bbData[bbid][bbLabel] = Text3D:INVALID_3DTEXT_ID;
	bbData[bbid][bbAreaid] = -1;

	format(bbData[bbid][bbOwner], MAX_PLAYER_NAME, "-");
	format(bbData[bbid][bbUrl], 250, "-");
	return 1;
}

Player_ResetBoombox(playerid)
{
	for (new bbid = 0; bbid != MAX_BOOMBOX; bbid ++)
	{
		if(Iter_Contains(Boombox, bbid))
		{
			if(Player_OwnsBoombox(playerid, bbid))
			{
				if(IsValidDynamicObject(bbData[bbid][bbObj]))
					DestroyDynamicObject(bbData[bbid][bbObj]);

				if(IsValidDynamic3DTextLabel(bbData[bbid][bbLabel]))
					DestroyDynamic3DTextLabel(bbData[bbid][bbLabel]);

				Boombox_Delete(bbid);
				Iter_Remove(Boombox, bbid);
			}
		}
	}
}

CMD:boombox(playerid, params[])
{
	new type[20];
	if(sscanf(params, "s[20]", type))
		return Usage(playerid, "/boombox [place | pickup | menu]");

	if(!strcmp(type, "place", true))
	{
		/*if(pData[playerid][pBoombox] == 0)
			return Error(playerid, "Kamu tidak memilik Boombox!");*/

		if(Inventory_Count(playerid, "Boombox") < 1)
			return ShowNotifError(playerid, "Kamu tidak memilik Boombox!", 10000);

		new bbid = Iter_Free(Boombox), Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

	 	format(bbData[bbid][bbOwner], 128, pData[playerid][pName]);
		bbData[bbid][bbPosX] = x;
		bbData[bbid][bbPosY] = y;
		bbData[bbid][bbPosZ] = z;
		bbData[bbid][bbPosA] = a;
		bbData[bbid][bbVw] = GetPlayerVirtualWorld(playerid);
		bbData[bbid][bbInt] = GetPlayerInterior(playerid);
		bbData[bbid][bbAreaid] = CreateDynamicSphere(x, y, z, 30.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		Boombox_Refresh(bbid);
		Iter_Add(Boombox, bbid);

		ApplyAnimation(playerid,"BOMBER","BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		Info(playerid, "Kamu telah berhasil menaruh boombox (Boombox ID: %d | Location: %s)", bbid, GetLocation(bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]));
		pData[playerid][pBoombox] = 0;
	}
	else if(!strcmp(type, "pickup", true))
	{
		new bbidn = -1;
		if((bbidn = Boombox_Nearest(playerid)) != -1)
		{
			if(!Player_OwnsBoombox(playerid, bbidn))
				return Error(playerid, "Kamu bukan pemilik boombox ini");

			if(IsValidDynamicObject(bbData[bbidn][bbObj]))
				DestroyDynamicObject(bbData[bbidn][bbObj]);

			if(IsValidDynamic3DTextLabel(bbData[bbidn][bbLabel]))
				DestroyDynamic3DTextLabel(bbData[bbidn][bbLabel]);

			Info(playerid, "Kamu berhasil mengambil boombox milikmu (Boombox ID: %d | Location: %s)", bbidn, GetLocation(bbData[bbidn][bbPosX], bbData[bbidn][bbPosY], bbData[bbidn][bbPosZ]));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s telah mematikan dan mengambil boombox miliknya", ReturnName(playerid));

			Boombox_Delete(bbidn);
			Iter_Remove(Boombox, bbidn);

			ApplyAnimation(playerid,"BOMBER","BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
			pData[playerid][pBoombox] = 1;
		}
	}
	else if(!strcmp(type, "menu", true))
	{
		new bbidn = -1;
		if((bbidn = Boombox_Nearest(playerid)) != -1)
		{
			if(!Player_OwnsBoombox(playerid, bbidn))
				return Error(playerid, "Kamu bukan pemilik boombox ini");

			pData[playerid][pGetBOOMBOXID] = bbidn;

			new str[254], hstr[254];
			format(hstr, sizeof(hstr), "Boombox Menu (ID: %d)", pData[playerid][pGetBOOMBOXID]);
			format(str, sizeof(str), "URL Music\nStop Music");
			ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, hstr, str, "Select", "Cancel");
		}
	}
	return 1;
}

/*
	pBoombox,
	pGetBOOMBOXID

	DIALOG_BOOMBOX,
	DIALOG_BOOMBOX_URL

	//ONPLAYERDISCONNECT
	Player_ResetBoombox(playerid);

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(IsPlayerConnected(playerid))
	{
		foreach(new bbid : Boombox)
		{
			if(Iter_Contains(Boombox, bbid))
			{
				if(areaid == bbData[bbid][bbAreaid])
				{
					Info(playerid, "Kamu telah memasuki area boombox (ID: %d)", bbid);
					PlayAudioStreamForPlayer(playerid, bbData[bbid][bbUrl], bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ], 30.0, 1);
				}
			}
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(IsPlayerConnected(playerid))
	{
		foreach(new bbid : Boombox)
		{
			if(Iter_Contains(Boombox, bbid))
			{
				if(areaid == bbData[bbid][bbAreaid])
				{
					StopAudioStreamForPlayer(playerid);
				}
			}
		}
	}
	return 1;
}






	if(dialogid == DIALOG_BOOMBOX)
	{
		new bbid = pData[playerid][pGetBOOMBOXID];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[254], hstr[254];
					format(hstr, sizeof(hstr), "Boombox URL (ID: %d)", bbid);
					format(str, sizeof(str), "Masukkan URL musik yang ingin kamu setel:");
					ShowPlayerDialog(playerid, DIALOG_BOOMBOX_URL, DIALOG_STYLE_INPUT, hstr, str, "Yes", "No");
				}
				case 1:
				{
					foreach(new i : Player)
					{
						if(IsPlayerInRangeOfPoint(i, 30.0, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]))
						{
							StopAudioStreamForPlayer(i);
						}
					}
					Info(playerid, "Kamu telah mematikan boombox milikmu (Boombox ID: %d | Location: %s)", bbid, GetLocation(bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]));
					SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "** %s telah mematikan boombox miliknya", ReturnName(playerid));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BOOMBOX_URL)
	{
		new bbid = pData[playerid][pGetBOOMBOXID], str[254], hstr[254];
		if(response)
		{
			if(isnull(inputtext))
			{
				format(hstr, sizeof(hstr), "Boombox URL (ID: %d)", bbid);
				format(str, sizeof(str), "ERROR: Kotak penginputan URL tidak boleh kosong!");
				ShowPlayerDialog(playerid, DIALOG_BOOMBOX_URL, DIALOG_STYLE_INPUT, hstr, str, "Yes", "No");
			}
			if(strlen(inputtext) > 250)
			{
				format(hstr, sizeof(hstr), "Boombox URL (ID: %d)", bbid);
				format(str, sizeof(str), "ERROR: Panjang URL tidak boleh melebihi dari 128 character!");
				ShowPlayerDialog(playerid, DIALOG_BOOMBOX_URL, DIALOG_STYLE_INPUT, hstr, str, "Yes", "No");
			}

			format(bbData[bbid][bbUrl], 250, inputtext);
			foreach(new i : Player)
			{
				if(IsPlayerInRangeOfPoint(i, 30.0, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]))
				{
					PlayAudioStreamForPlayer(i, inputtext, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ], 30.0, 1);
				}
			}
		}
		return 1;
	}
	return 1;
}



*/

