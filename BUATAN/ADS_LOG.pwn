#define MAX_ADSLOG 100

enum E_ADSLOG
{
	adsOwner,
	adsPhone,
	adsText[524]
}

new AdsData[MAX_ADSLOG][E_ADSLOG],
Iterator: AdsLog<MAX_ADSLOG>;

Add_AdsLog(playerid, const adstext[])
{
	new adsid = Iter_Free(AdsLog);
	if(adsid < MAX_ADSLOG)
	{
		AdsData[adsid][adsOwner] = playerid;
		AdsData[adsid][adsPhone] = pData[playerid][pPhone];
		format(AdsData[adsid][adsText], 524, adstext);
		Iter_Add(AdsLog, adsid);
	}
	return 1;
}

Delete_AdsLog(adsid)
{
	if(adsid != -1)
	{
		AdsData[adsid][adsOwner] = INVALID_PLAYER_ID;
		AdsData[adsid][adsPhone] = 0;
		format(AdsData[adsid][adsText], 524, "\0");

		Iter_Remove(AdsLog, adsid);
	}
	return 1;
}

Player_ResetAdsLog(playerid)
{
	for(new adsid = 0; adsid < MAX_ADSLOG; adsid++)
	{
		if(AdsData[adsid][adsOwner] == playerid)
		{
			Delete_AdsLog(adsid);
		}
	}
}

GetAdsLog()
{
	new tmpcount;
	foreach(new adsid : AdsLog)
	{
		if(AdsData[adsid][adsOwner] != INVALID_PLAYER_ID)
		{
			tmpcount++;
		}
	}
	return tmpcount;
}

ReturnAdsLogID(slot)
{
	if(slot < 1 && slot > MAX_ADSLOG)
		return -1;

	new tmpcount;
	foreach(new adsid : AdsLog)
	{
		if(AdsData[adsid][adsOwner] != INVALID_PLAYER_ID)
		{
			tmpcount++;
			if(tmpcount == slot)
			{
				return adsid;
			}
		}
	}
	return -1;
}

ShowAdsLog(playerid)
{
	if(GetAdsLog() <= 0)
		return Error(playerid, "Advertisement Logs sedang kosong.");

	new id, count = GetAdsLog(), lstr[3024];

	Loop(itt, (count + 1), 1)
	{
		id = ReturnAdsLogID(itt);
		if(itt == count)
		{
			format(lstr, sizeof(lstr), "%s%d. %s\n", lstr, itt, AdsData[id][adsText]);
		}
		else format(lstr, sizeof(lstr), "%s%d. %s\n", lstr, itt, AdsData[id][adsText]);
	}
	ShowPlayerDialog(playerid, ADSLOG_LIST, DIALOG_STYLE_LIST, "Advertisement Logs", lstr, "Select", "Cancel");
	return 1;
}