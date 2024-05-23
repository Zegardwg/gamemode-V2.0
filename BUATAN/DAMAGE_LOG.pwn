#define MAX_DAMAGE 500

enum E_DLOG
{
	dlOwner,
	dlTarget[MAX_PLAYER_NAME + 1],
	dlBody,
	dlWeapon,
	Float:dlDamage,
};

new DamageData[MAX_DAMAGE][E_DLOG],
Iterator: DamageLog<MAX_DAMAGE>;

CreateDamageLog(playerid, Float:amount, weaponid, bodypart)
{
	new dlid = Iter_Free(DamageLog);

	if(dlid >= MAX_DAMAGE)
		return 1;
	
	DamageData[dlid][dlOwner] = playerid;
	DamageData[dlid][dlDamage] = amount;
	DamageData[dlid][dlWeapon] = weaponid;
	DamageData[dlid][dlBody] = bodypart;
	if(pData[playerid][pGetDamageID] != INVALID_PLAYER_ID)
	{
 		format(DamageData[dlid][dlTarget], MAX_PLAYER_NAME, pData[pData[playerid][pGetDamageID]][pName]);
 	}
 	else
 	{
 		format(DamageData[dlid][dlTarget], MAX_PLAYER_NAME, "Unknown");
 	}

 	pData[playerid][pGetDamageID] = INVALID_PLAYER_ID;

	Iter_Add(DamageLog, dlid);

	if(GetPlayerDamageLog(playerid) > 20)
	{
		Player_ResetDamageLog(playerid);
	}
	return 1;
}

Player_ResetDamageLog(playerid)
{
	for(new i = 0; i < MAX_DAMAGE; i++)
	{
		if(Iter_Contains(DamageLog, i))
		{
			if(DamageData[i][dlOwner] == playerid)
			{
				DamageData[i][dlOwner] = INVALID_PLAYER_ID;
				pData[playerid][pGetDamageID] = INVALID_PLAYER_ID;
				Iter_Remove(DamageLog, i);
			}
		}
	}
}

GetPlayerDamageLog(playerid)
{
	new tmpcount = 0;
	foreach(new dlid : DamageLog)
	{
		if(DamageData[dlid][dlOwner] == playerid)
		{
			tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerDamageLogID(playerid, hslot)
{
	new tmpcount = 0;
	if(hslot < 1 && hslot > MAX_DAMAGE) return 1;

	foreach(new dlid : DamageLog)
	{
		if(DamageData[dlid][dlOwner] == playerid)
		{
			tmpcount++;
			if(tmpcount == hslot)
			{
				return dlid;
			}
		}
	}
	return -1;
}

CMD:damagelogs(playerid, params[])
{
	if(GetPlayerDamageLog(playerid) <= 0)
		return SendClientMessage(playerid, -1, "No damage logs available.");

	new id, count = GetPlayerDamageLog(playerid), strings[5024], lstr[5024], partname[128], header[5024];
	new date[6];
	new timestamp = gettime();
	TimestampToDate(timestamp, date[2], date[1], date[0], date[3], date[4], date[5], 7);
	strcat(strings,"Name\tWeapon\tDamage\tDate & Time\n", sizeof(strings));
	format(header, sizeof(header), "Damage Logs of %s", ReturnName(playerid));
	Loop(itt, (count + 1), 1)
	{
		id = ReturnPlayerDamageLogID(playerid, itt);
		if(DamageData[id][dlBody] == 3)
		{
			partname = "Torso";
		}
		else if(DamageData[id][dlBody] == 4)
		{
			partname = "Groin";
		}
		else if(DamageData[id][dlBody] == 5)
		{
			partname = "Left Arm";
		}
		else if(DamageData[id][dlBody] == 6)
		{
			partname = "Right Arm";
		}
		else if(DamageData[id][dlBody] == 7)
		{
			partname = "Left Leg";
		}
		else if(DamageData[id][dlBody] == 8)
		{
			partname = "Right Leg";
		}
		else if(DamageData[id][dlBody] == 9)
		{
			partname = "Head";
		}
		else
		{
			partname = "Unknown";
		}
		if(itt == count)
		{
			format(lstr, sizeof(lstr), "%s\t%s\t%0.1f - %s\t %i/%02d/%02d %02d:%02d\n", DamageData[id][dlTarget], ReturnWeaponName(DamageData[id][dlWeapon]), DamageData[id][dlDamage], partname, date[2], date[0], date[1], date[3], date[4]);
		}
		else format(lstr ,sizeof(lstr), "%s\t%s\t%0.1f - %s\t %i/%02d/%02d %02d:%02d\n", DamageData[id][dlTarget], ReturnWeaponName(DamageData[id][dlWeapon]), DamageData[id][dlDamage], partname, date[2], date[0], date[1], date[3], date[4]);
		strcat(strings, lstr, sizeof(strings));
	}
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, header, strings, "Close", "");
	return 1;
}

CMD:adamagelogs(playerid, params[])
{
	new otherid;
	if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/adamagelogs [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	if(GetPlayerDamageLog(otherid) <= 0)
		return SendClientMessage(playerid, -1, "No damage logs available.");

	new id, count = GetPlayerDamageLog(otherid), strings[5024], lstr[5024], partname[128], header[5024];
	new date[6];
	new timestamp = gettime();
	TimestampToDate(timestamp, date[2], date[1], date[0], date[3], date[4], date[5], 7);
	strcat(strings,"Name\tWeapon\tDamage\tDate & Time\n", sizeof(strings));
	format(header, sizeof(header), "Damage Logs of %s", ReturnName(otherid));
	Loop(itt, (count + 1), 1)
	{
		id = ReturnPlayerDamageLogID(otherid, itt);
		if(DamageData[id][dlBody] == 3)
		{
			partname = "Torso";
		}
		else if(DamageData[id][dlBody] == 4)
		{
			partname = "Groin";
		}
		else if(DamageData[id][dlBody] == 5)
		{
			partname = "Left Arm";
		}
		else if(DamageData[id][dlBody] == 6)
		{
			partname = "Right Arm";
		}
		else if(DamageData[id][dlBody] == 7)
		{
			partname = "Left Leg";
		}
		else if(DamageData[id][dlBody] == 8)
		{
			partname = "Right Leg";
		}
		else if(DamageData[id][dlBody] == 9)
		{
			partname = "Head";
		}
		else
		{
			partname = "Unknown";
		}
		if(itt == count)
		{
			format(lstr, sizeof(lstr), "%s\t%s\t%0.1f - %s\t %i/%02d/%02d %02d:%02d\n", DamageData[id][dlTarget], ReturnWeaponName(DamageData[id][dlWeapon]), DamageData[id][dlDamage], partname, date[2], date[0], date[1], date[3], date[4]);
		}
		else format(lstr ,sizeof(lstr), "%s\t%s\t%0.1f - %s\t %i/%02d/%02d %02d:%02d\n", DamageData[id][dlTarget], ReturnWeaponName(DamageData[id][dlWeapon]), DamageData[id][dlDamage], partname, date[2], date[0], date[1], date[3], date[4]);
		strcat(strings, lstr, sizeof(strings));
	}
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, header, strings, "Close", "");
	return 1;
}