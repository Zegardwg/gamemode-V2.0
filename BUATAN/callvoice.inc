CMD:gencallvoice(playerid, params[])
{
	// if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
	// 	return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new ph;
	// if(pData[playerid][pPhone] == 0) return Error(playerid, "Anda tidak memiliki Ponsel!");
	// if(pData[playerid][pPhoneStatus] == 0) return Error(playerid, "Handphone anda sedang dimatikan");
	// if(pData[playerid][pPhoneCredit] <= 0) return Error(playerid, "Anda tidak memiliki Ponsel credits!");
	
	if(sscanf(params, "d", ph))
	{
		Usage(playerid, "/call [phone number] 933 - Taxi Call | 911 - SAPD Crime Call | 922 - SAMD Medic Call");
		foreach(new ii : Player)
		{	
			if(pData[ii][pMechDuty] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREEN, "Mekanik Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
			}
		}
		return 1;
	}
	if(ph == 911)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Warning: This number for emergency crime only! please wait for SAPD respon!");
		SendFactionMessage(1, COLOR_BLUE, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency crime! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	
		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 922)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Warning: This number for emergency medical only! please wait for SAMD respon!");
		SendFactionMessage(3, COLOR_PINK2, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency medical! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	
		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 933)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Your calling has sent to the taxi driver. please wait for respon!");
		pData[playerid][pCallTime] = gettime() + 60;
		foreach(new tx : Player)
		{
			if(pData[tx][pJob] == 1 || pData[tx][pJob2] == 1)
			{
				SendClientMessageEx(tx, COLOR_YELLOW, "[TAXI CALL] "WHITE_E"%s calling the taxi for order! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
			}
		}
	}
	
	if(ph == pData[playerid][pPhone])
	{
	    HideMenuHP(playerid);
		
     	for(new i = 0; i < 29; i++)
		{
			TextDrawShowForPlayer(playerid, TelponNotif[i]);
		}
		//TextDrawShowForPlayer(playerid, CLOSE5);
		PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][0]);
		PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][1]);
		PlayerTextDrawShow(playerid, BatalTelpon[playerid]);
		SelectTextDraw(playerid, COLOR_LBLUE);
	}
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii))
			{
       			HideMenuHP(playerid);

			    for(new i = 0; i < 29; i++)
				{
					TextDrawShowForPlayer(playerid, TelponNotif[i]);
				}
				PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][0]);
				PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][1]);
				PlayerTextDrawShow(playerid, BatalTelpon[playerid]);
				SelectTextDraw(playerid, COLOR_LBLUE);
				
				new tstr[256];
				format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
				PlayerTextDrawSetString(playerid, NamaDanFuncall[playerid][0], tstr);
				return 1;
			}
			if(pData[ii][pUsePhone] == 0)
			{
       			HideMenuHP(playerid);
				
			    for(new i = 0; i < 29; i++)
				{
					TextDrawShowForPlayer(playerid, TelponNotif[i]);
				}
				PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][0]);
				PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][1]);
				PlayerTextDrawShow(playerid, BatalTelpon[playerid]);
				SelectTextDraw(playerid, COLOR_LBLUE);
				
				new tstr[256];
				format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
				PlayerTextDrawSetString(playerid, NamaDanFuncall[playerid][0], tstr);
				return 1;
			}
			// if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
			// 	return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

			if(pData[ii][pCall] == INVALID_PLAYER_ID)
			{
				pData[playerid][pCall] = ii;
				
				//SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE to %d] "WHITE_E"phone begins to ring, please wait for answer!", ph);
    			HideMenuHP(playerid);
				
				for(new i = 0; i < 29; i++)
				{
					TextDrawShowForPlayer(playerid, TelponNotif[i]);
				}
				PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][0]);
				PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][1]);
				PlayerTextDrawShow(playerid, BatalTelpon[playerid]);
				new tstr[256];
				format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
				PlayerTextDrawSetString(playerid, NamaDanFuncall[playerid][0], tstr);
				SelectTextDraw(playerid, COLOR_LBLUE);
				
				//SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE form %d] "WHITE_E"Your phonecell is ringing, type '/p' to answer it!", pData[playerid][pPhone]);
    			HideMenuHP(playerid);
				
    			for(new i = 0; i < 29; i++)
				{
					TextDrawShowForPlayer(ii, TelponNotif[i]);
				}
				PlayerTextDrawShow(ii, NamaDanFuncall[ii][0]);
				PlayerTextDrawSetString(ii, NamaDanFuncall[ii][1], "Panggilan...");
				PlayerTextDrawShow(ii, NamaDanFuncall[ii][1]);
				PlayerTextDrawShow(ii, AngkatTelpon[ii]);
				PlayerTextDrawShow(ii, RijekTelpon[ii]);
				ToggleCall[ii] = 1;
				PlayerPlaySound(playerid, 3600, 0,0,0);
				PlayerPlaySound(ii, 6003, 0,0,0);
				Info(playerid, "gunakan /cursor jika textdraw tidak bisa diklik.");
				Info(ii, "gunakan /cursor jika textdraw tidak bisa diklik.");
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				format(tstr, sizeof(tstr), "%s", pData[playerid][pName]);
				PlayerTextDrawSetString(ii, NamaDanFuncall[ii][0], tstr);
				//SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
				return 1;
			}
			else
			{
			    HideMenuHP(playerid);
				
    			for(new i = 0; i < 29; i++)
				{
					TextDrawShowForPlayer(playerid, TelponNotif[i]);
				}
				PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][0]);
				PlayerTextDrawSetString(playerid, NamaDanFuncall[playerid][1], "Sibuk...");
				PlayerTextDrawShow(playerid, NamaDanFuncall[playerid][1]);
				PlayerTextDrawShow(playerid, BatalTelpon[playerid]);
				SelectTextDraw(playerid, COLOR_LBLUE);
				
				new tstr[256];
				format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
				PlayerTextDrawSetString(playerid, NamaDanFuncall[playerid][0], tstr);
				return 1;
			}
		}
	}
	return 1;
}