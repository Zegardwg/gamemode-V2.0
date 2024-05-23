stock AFKCheck(playerid)
{
	//if(pData[playerid][pVendor] != -1)
		//return 0;

	//if(pData[playerid][pFishing])
		//return 0;

	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:cx,
	    Float:cy,
	    Float:cz;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerCameraPos(playerid, cx, cy, cz);

	if(pData[playerid][pAFKPos][0] == x && pData[playerid][pAFKPos][1] == y && pData[playerid][pAFKPos][2] == z && pData[playerid][pAFKPos][3] == cx && pData[playerid][pAFKPos][4] == cy && pData[playerid][pAFKPos][5] == cz)
	{
		pData[playerid][pAFKTime]++;

	    if(!pData[playerid][pAFK] && pData[playerid][pAFKTime] >= 180)
	    {
			SendClientMessage(playerid, COLOR_LIGHTORANGE, "* You are now in {FFFF00}Away from Keyboard{F7A763} mode.");
		    pData[playerid][pAFK] = 1;
		    //SetPlayerColor(playerid, COLOR_GREY);
		}
	}
	else
	{
		if(pData[playerid][pAFK])
		{
		    if(PlayerData[playerid][pAFKTime] < 120) 
		    {
		    	SendClientMessageEx(playerid, COLOR_LIGHTORANGE, "* You are no longer in {FFFF00}Away from Keyboard {F7A763}after %d seconds.", PlayerData[playerid][pAFKTime]);
			} 
			else 
			{
			    SendClientMessageEx(playerid, COLOR_LIGHTORANGE, "* You are no longer in {FFFF00}Away from Keyboard {F7A763}after %d minutes.", PlayerData[playerid][pAFKTime] / 60);
			}
			//SetValidColor(playerid);
			pData[playerid][pAFK] = 0;
			TogglePlayerControllable(playerid, true);
		}

		pData[playerid][pAFKTime] = 0;
	}

	pData[playerid][pAFKPos][0] = x;
	pData[playerid][pAFKPos][1] = y;
	pData[playerid][pAFKPos][2] = z;
	pData[playerid][pAFKPos][3] = cx;
	pData[playerid][pAFKPos][4] = cy;
	pData[playerid][pAFKPos][5] = cz;
	return 1;
}

CMD:isafk(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
		return Usage(playerid, "/isafk [playerid/PartOfName]");

	if(targetid == INVALID_PLAYER_ID)
		return Error(playerid, "Invalid player specified!");

	SendClientMessageEx(playerid, COLOR_ARWIN, "AFK-INFO : {FFFFFF}Player {00FFFF}%s {FFFFFF}is %s", GetName(targetid), (pData[targetid][pAFK]) ? ("{FFFFFF}AFK") : ("{FF0000}not {FFFFFF}AFK"));
	return 1;
}