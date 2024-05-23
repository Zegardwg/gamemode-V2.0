/*

	SAN ANDREAS CAFE FOOD

*/
#include <YSI_Coding\y_hooks>

enum E_SACFAREA
{
	STREAMER_TAG_CP:Masaksacf
}
new Sacfarea[MAX_PLAYERS][E_SACFAREA];

DeleteSacfMap(playerid)
{
	if(IsValidDynamicCP(Sacfarea[playerid][Masaksacf]))
	{
		DestroyDynamicCP(Sacfarea[playerid][Masaksacf]);
		Sacfarea[playerid][Masaksacf] = STREAMER_TAG_CP: -1;
	}
}

RefreshMapSacf(playerid)
{
	DeleteSacfMap(playerid);

	if(pData[playerid][pFaction] == 5)
	{
		if(!pData[playerid][pOndutysacf])
		{
			Sacfarea[playerid][Masaksacf] = CreateDynamicCP(1200.3564,-890.8854,44.2015, 1.5, -1, -1, -1, 30.0);
		}
		else
		{
			Sacfarea[playerid][Masaksacf] = CreateDynamicCP(0.0, 0.0, 0.0, 0.0, -1, -1, -1, 0.0);
		}
	}
	return 1;
}

hook OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pFaction] == 5 && pData[playerid][pOndutysacf] == true)
	{
		if(IsPlayerInDynamicCP(playerid, Sacfarea[playerid][Masaksacf]))
		{
			if(checkpointid == Sacfarea[playerid][Masaksacf])
			{
				showinfotombol(playerid, "Untuk Memasak");
			}
		}
	}
	return 1;
}

hook OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP:checkpointid)
{
	if(checkpointid == Sacfarea[playerid][Masaksacf])
	{
		HideInfoTombol(playerid);
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pFaction] == 5 && pData[playerid][pOndutysacf] == true)
    {
    	if(IsPlayerInRangeOfPoint(playerid, 1.5, 1200.3564,-890.8854,44.2015))
    	{
    		return callcmd::cooking(playerid, "");
    	}
    }
    return 1;
}