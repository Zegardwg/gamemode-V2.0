CMD:pmdc(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		return ShowNotifError(playerid, "Kamu bukan anggota SAPD!", 10000);

	new vehid = GetPlayerVehicleID(playerid), str[254];
	if(IsPlayerInRangeOfPoint(playerid, 3.5, 234.44, 111.30, 1003.22))
	{
		format(str, sizeof(str), "Vehicle Info\nBisnis Info\nHouse Info\nPhone Track\nRequest Backup\n911 Calls");
		ShowPlayerDialog(playerid, PMDC_MENU, DIALOG_STYLE_LIST, "MDC Menu", str, "Select", "Cancel");
		return 1;
	}
	else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(IsSAPDCar(vehid))
		{
			format(str, sizeof(str), "Vehicle Info\nBisnis Info\nHouse Info\nPhone Track\nRequest Backup\n 911 Calls");
			ShowPlayerDialog(playerid, PMDC_MENU, DIALOG_STYLE_LIST, "MDC Menu", str, "Select", "Cancel");
			return 1;
		}
	}
	else return ShowNotifError(playerid, "Kamu tidak berada di point mdc/didalam kendaraan sapd", 10000);
	return 1;
}
CMD:emdc(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
		return ShowNotifError(playerid, "Kamu bukan anggota SAMD!", 10000);

	new vehid = GetPlayerVehicleID(playerid), str[254];
	if(IsPlayerInRangeOfPoint(playerid, 3.5, 2872.5708,1236.8047,-64.3797))
	{
		format(str, sizeof(str), "911 Calls");
		ShowPlayerDialog(playerid, EMDC_MENU, DIALOG_STYLE_LIST, "MDC Menu", str, "Select", "Cancel");
		return 1;
	}
	else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(IsSAMDCar(vehid))
		{
			format(str, sizeof(str), "911 Calls");
			ShowPlayerDialog(playerid, EMDC_MENU, DIALOG_STYLE_LIST, "MDC Menu", str, "Select", "Cancel");
			return 1;
		}
	}
	else return ShowNotifError(playerid, "Kamu tidak berada di point mdc/didalam kendaraan samd", 10000);
	return 1;
}

ReturnMdcVehicleID(playerid, hslot)
{
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;

	new tmpcount;
	foreach(new i : PVehicles)
	{
		if(IsValidVehicle(pvData[i][cVeh]))
		{
			if(!strcmp(pvData[i][cPlate], pData[playerid][pTargetMDC]))
			{
				tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return i;
	  			}
	  		}
		}
	}
	return -1;
}

ReturnMdcBisnisID(playerid, hslot)
{
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;

	new tmpcount;
	for(new i = 0; i < MAX_BISNIS; i++)
	{
		if(Iter_Contains(Bisnis, i))
		{
			if(!strcmp(bData[i][bOwner], pData[playerid][pTargetMDC]))
			{
	     		tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return i;
	  			}
	  		}
		}
	}
	return -1;
}

ReturnMdcHouseID(playerid, hslot)
{
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;

	new tmpcount;
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		if(Iter_Contains(Houses, i))
		{
			if(!strcmp(hData[i][hOwner], pData[playerid][pTargetMDC]))
			{
	     		tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return i;
	  			}
	  		}
		}
	}
	return -1;
}


forward trackph(playerid, to_player);
public trackph(playerid, to_player)
{

	{
	   	if(pData[playerid][pActivityTime] >= 100)
	   	{
	    	InfoTD_MSG(playerid, 8000, "Searching done!");
			KillTimer(pData[playerid][pActivityTime]);
			pData[playerid][pLoading] = false;
			pData[playerid][pActivityTime] = 0;
			ShowPhone(playerid);
		}
 		else if(pData[playerid][pActivityTime] < 100)
		{
  			pData[playerid][pActivityTime] += 5;
 			PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
	   	}
	}
	return 1;
}

forward ShowPhone(playerid);
public ShowPhone(playerid)
{
	new number;
	new str[648];
	new otherid;
	new zone[MAX_ZONE_NAME];
	new sext[40];
	new Float:sX, Float:sY, Float:sZ;
	GetPlayerPos(otherid, sX, sY, sZ);
	SetPlayerCheckpoint(playerid, sX, sY, sZ, 5.0);
	pData[playerid][pSuspectTimer] = 120;
	Info(playerid, "You Has Succesfull Track Ph Number %d", number);
	if(pData[otherid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }

	GetPlayer3DZone(otherid, zone, sizeof(zone));

	format(str, sizeof(str), "{037bfc}Name: {ffffff}%s\n{037bfc}Gender: {ffffff}%s\n{037bfc}Brithday Date: {ffffff}%s\n\n{ffffff}Last Location At {037bfc}%s", ReturnName(otherid), sext, pData[otherid][pAge], zone);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{ffffff}Phone Info", str, "Close","");
	return 1;
}