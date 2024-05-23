//Job Taxi

new TaxiVeh[15];

AddTaxiVehicle()
{
	TaxiVeh[0] = AddStaticVehicleEx(420, 655.94, -465.01, 16.11, 271.12, 6, 6, VEHICLE_RESPAWN);
	TaxiVeh[1] = AddStaticVehicleEx(420, 655.85, -460.39, 16.10, 269.50, 6, 6, VEHICLE_RESPAWN);
	TaxiVeh[2] = AddStaticVehicleEx(420, 655.72, -456.19, 16.11, 270.72, 6, 6, VEHICLE_RESPAWN);
	TaxiVeh[3] = AddStaticVehicleEx(438, 655.48, -452.21, 16.33, 270.93, 6, 6, VEHICLE_RESPAWN);
	TaxiVeh[4] = AddStaticVehicleEx(438, 655.48, -448.03, 16.33, 270.76, 6, 6, VEHICLE_RESPAWN);
}

IsATaxiVeh(carid)
{
	for(new v = 0; v < sizeof(TaxiVeh); v++) {
	    if(carid == TaxiVeh[v]) return 1;
	}
	return 0;
}

//Taxi
CMD:taxiduty(playerid, params[])
{
	if(pData[playerid][pJob] == 1 || pData[playerid][pJob2] == 1)
	{
		new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
		
		if(modelid != 438 && modelid != 420)
			return Error(playerid, "Kamu harus berada didalam Taxi.");
			
		if(pData[playerid][pTaxiDuty] == 0)
		{
			pData[playerid][pTaxiDuty] = 1;
			SetPlayerColor(playerid, COLOR_YELLOW);
			SendClientMessageToAllEx(COLOR_YELLOW, "[TAXI]"WHITE_E"[ %s sedang On duty ] {ffffff}Gunakan {7fffd4}[ /call 933 ] {ffffff}untuk memanggil taksi", ReturnName(playerid));
		}
		else
		{
			pData[playerid][pTaxiDuty] = 0;
			SetPlayerColor(playerid, COLOR_WHITE);
			Servers(playerid, "Anda off duty!");
		}
	}
	else return Error(playerid, "Anda bukan pekerja taxi driver.");
	return 1;
}

CheckPassengers(vehicleid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInAnyVehicle(i))
		{
			if(GetPlayerVehicleID(i) == vehicleid && i != GetVehicleDriver(vehicleid))
			{

				return 1;

			}
		}
	}
	return 0;
}

CMD:fare(playerid, params[])
{
	if(pData[playerid][pTaxiDuty] == 0)
		return Error(playerid, "Anda harus On duty taxi.");
		
	new vehicleid = GetPlayerVehicleID(playerid);
	new modelid = GetVehicleModel(vehicleid);
		
	if(modelid != 438 && modelid != 420)
		return Error(playerid, "Anda harus mengendarai taxi.");
		
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return Error(playerid, "Anda bukan driver.");
	
	
	if(pData[playerid][pFare] == 0)
	{
		if(CheckPassengers(vehicleid) != 1) return Error(playerid,"Tidak ada penumpang!");
		GetPlayerPos(playerid, Float:pData[playerid][pFareOldX], Float:pData[playerid][pFareOldY], Float:pData[playerid][pFareOldZ]);
		pData[playerid][pFareTimer] = SetTimerEx("FareUpdate", 1000, true, "ii", playerid, GetVehiclePassenger(vehicleid));
		pData[playerid][pFare] = 1;
		pData[playerid][pTotalFare] = 5;
		new formatted[128];
		format(formatted,128,"%s", FormatMoney(pData[playerid][pTotalFare]));
		TextDrawShowForPlayer(playerid, TDEditor_TD[11]);
		TextDrawShowForPlayer(playerid, DPvehfare[playerid]);
		TextDrawSetString(DPvehfare[playerid], formatted);
		Info(playerid, "Anda telah mengaktifkan taxi fare, silahkan menuju ke tempat tujuan!");
		//passanger
		TextDrawShowForPlayer(GetVehiclePassenger(vehicleid), TDEditor_TD[11]);
		TextDrawShowForPlayer(GetVehiclePassenger(vehicleid), DPvehfare[GetVehiclePassenger(vehicleid)]);
		TextDrawSetString(DPvehfare[GetVehiclePassenger(vehicleid)], formatted);
		Info(GetVehiclePassenger(vehicleid), "Taxi fare telah aktif!");
	}
	else
	{
		TextDrawHideForPlayer(playerid, TDEditor_TD[11]);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
		KillTimer(pData[playerid][pFareTimer]);
		Info(playerid, "Anda telah menonaktifkan taxi fare pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
		//passanger
		Info(GetVehiclePassenger(vehicleid), "Taxi fare telah di non aktifkan pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
		TextDrawHideForPlayer(GetVehiclePassenger(vehicleid), TDEditor_TD[11]);
		TextDrawHideForPlayer(GetVehiclePassenger(vehicleid), DPvehfare[GetVehiclePassenger(vehicleid)]);
		pData[playerid][pFare] = 0;
		pData[playerid][pTotalFare] = 0;
	}
	return 1;
}

function FareUpdate(playerid, passanger)
{	
	new formatted[128];
	GetPlayerPos(playerid,pData[playerid][pFareNewX],pData[playerid][pFareNewY],pData[playerid][pFareNewZ]);
	new Float:totdistance = GetDistanceBetweenPoints(pData[playerid][pFareOldX],pData[playerid][pFareOldY],pData[playerid][pFareOldZ], pData[playerid][pFareNewX],pData[playerid][pFareNewY],pData[playerid][pFareNewZ]);
    if(totdistance > 300.0)
    {
		new argo = RandomEx(50, 150);
	    pData[playerid][pTotalFare] = pData[playerid][pTotalFare]+argo;
		format(formatted,128,"%s", FormatMoney(pData[playerid][pTotalFare]));
		TextDrawShowForPlayer(playerid, DPvehfare[playerid]);
		TextDrawSetString(DPvehfare[playerid], formatted);
		GetPlayerPos(playerid,Float:pData[playerid][pFareOldX],Float:pData[playerid][pFareOldY],Float:pData[playerid][pFareOldZ]);
		//passanger
		TextDrawShowForPlayer(passanger, DPvehfare[passanger]);
		TextDrawSetString(DPvehfare[passanger], formatted);
	}
	return 1;
}
