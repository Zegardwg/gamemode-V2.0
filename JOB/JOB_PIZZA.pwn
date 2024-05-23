

CreateGetPizza()
{
	new strings[128];
	CreateDynamicPickup(1239, 23, 2094.06, -1801.22, 13.38, -1, -1, -1, 5.0);
	format(strings, sizeof(strings), "[GET PIZZA]\n{FFFFFF}/getpizza\n to delivery pizza");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 2094.06, -1801.22, 13.38, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
}

new PizzaVeh[5];

AddPizzaVehicle()
{
	PizzaVeh[0] = AddStaticVehicleEx(448, 2097.49, -1793.08, 12.98, 90.87, 3, 6, VEHICLE_RESPAWN);
	PizzaVeh[1] = AddStaticVehicleEx(448, 2097.34, -1795.00, 12.98, 88.48, 3, 6, VEHICLE_RESPAWN);
	PizzaVeh[2] = AddStaticVehicleEx(448, 2097.40, -1797.18, 12.98, 91.37, 3, 6, VEHICLE_RESPAWN);
	PizzaVeh[3] = AddStaticVehicleEx(448, 2097.64, -1799.52, 12.98, 96.78, 3, 6, VEHICLE_RESPAWN);
}

IsAPizzaVeh(carid)
{
	for(new v = 0; v < sizeof(PizzaVeh); v++) {
	    if(carid == PizzaVeh[v]) return 1;
	}
	return 0;
}

CMD:getpizza(playerid)
{
	if(pData[playerid][pJob] == 9 || pData[playerid][pJob2] == 9)
	{
		if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

		if(pData[playerid][pLoading] == true)
			return ShowNotifError(playerid, "Anda Maih mengambil pizza", 10000);

		if(pData[playerid][pPizzaLoad] == 1) return ShowNotifError(playerid, "Kamu harus menyelesaikan pengantaran terlebih dahulu!", 10000);
		{
			if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2094.06, -1801.22, 13.38)) return ShowNotifError(playerid,"Kamu harus berada ditempat pengambilan pizza!", 10000);
			{
			    new vehicleid = GetPlayerVehicleID(playerid);
    			if(!(IsAPizzaVeh(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
	   				return ShowNotifError(playerid,"Kamu harus mengendarai kendaraan pizza untuk mengambil pizza!", 10000);
				{
					pData[playerid][pLoading] = true;
					TogglePlayerControllable(playerid, 0);
					pData[playerid][pPizza] = SetTimerEx("JobPizza", 1000, true, "i", playerid);
					//Showbar(playerid, 5, "MENGAMBIL PIZZA", "JobPizza");
					ShowProgressbar(playerid, "MENGAMBIL PIZZA", 5);
				}			
			}			
		}
	}
	else return ShowNotifError(playerid,"Kamu bukan pekerja Pizza!", 10000);
	return 1;
}

CMD:droppizza(playerid, params[])
{
	if(pData[playerid][pJob] == 9 || pData[playerid][pJob2] == 9)
    {
    	if(pData[playerid][pPizzaCP] == -1)
    		return Error(playerid, "Kamu belum belum memiliki tujuan untuk mengantar pizza");

        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        	return Error(playerid, "Kamu harus turun dari kendaraan");

    	if(!IsAPizzaVeh(GetPVarInt(playerid, "LastvehicleID")))
    		return Error(playerid, "Kendaraan yang terakhir kamu kendarai bukanlah kendaraan pizza");
    	{
        	new randpizza = pData[playerid][pPizzaCP];
            if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[randpizza][hExtposX], hData[randpizza][hExtposY], hData[randpizza][hExtposZ]))
            {
            	ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
            	RemovePlayerAttachedObject(playerid, 9);
            	DisablePlayerCheckpoint(playerid);
            	pData[playerid][pPizzaCP] = -1;
            	pData[playerid][pPizzaLoad] = 0;

            	pData[playerid][pJobTime] = 30;
            	pData[playerid][pHunger] -= 10;
				pData[playerid][pEnergy] -= 15;
				
            	GivePlayerMoneyEx(playerid, jobpizzaprice);
            	Info(playerid, "Kamu berhasil mengantar pizza dan mendapatkan uang sejumlah {00ff00}%s", FormatMoney(jobpizzaprice));
            }
        }
    }
    else return Error(playerid, "Kamu bukan pekerja pizza");
    return 1;
}

function JobPizza(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pPizza])) return 0;
	if(pData[playerid][pJob] == 9 || pData[playerid][pJob2] == 9)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 2094.06, -1801.22, 13.38))
			{
				SetPlayerAttachedObject( playerid, 9, 1582, 1, 0.002953, 0.469660, -0.009797, 269.851104, 34.443557, 0.000000, 0.804894, 1.000000, 0.822361 );
				Info(playerid,"Kamu telah mengambil pizza, lihat map untuk mengetahui tujuan");
				GameTextForPlayer(playerid, "~w~SELESAI!", 5000, 3);
				TogglePlayerControllable(playerid, 1);
				KillTimer(pData[playerid][pPizza]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLoading] = false;
				new rand = RandomEx(0, 100);
				pData[playerid][pPizzaLoad] = 1;
				pData[playerid][pPizzaCP] = rand;
				SetPlayerRaceCheckpoint(playerid, 1, hData[rand][hExtposX], hData[rand][hExtposY], hData[rand][hExtposZ], 0.0, 0.0, 0.0,  1.5);	
				ClearAnimations(playerid);
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 2094.06, -1801.22, 13.38))
			{
				pData[playerid][pActivityTime] += 20;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
			}
		}
	}
	return 1;
}