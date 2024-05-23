

CreateReflenishPickup()
{
	new strings[1024];
	CreateDynamicPickup(1239, 23, 1427.72, -961.60, 36.34, -1);
	format(strings, sizeof(strings), "Reflenish Job\n{FFFFFF}/loadmoney - to load money from bank");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1427.72, -961.60, 36.34, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Reflenish
}

CMD:loadmoney(playerid, params)
{
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pJobTime] > 0) 
			return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

		if(pData[playerid][pLoading] == true) 
			return ShowNotifError(playerid, "Anda Masih Load Money", 10000);

		if(pData[playerid][pActivityTime] > 5)
			return ShowNotifError(playerid, "Kamu masih memiliki activity progress", 10000);
		
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1427.72, -961.60, 36.34))
			return ShowNotifError(playerid, "Kamu tidak berada ditempat pengambilan uang", 10000);
		
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsAReflenishVeh(GetPlayerVehicleID(playerid)))
    		return ShowNotifError(playerid, "Kamu harus mengendarai kendaraan Boxville", 10000);

		if(VehRefleMoney[GetPlayerVehicleID(playerid)] > 0)
			return ShowNotifError(playerid, "Mobil mu sudah terisi dengan uang", 10000);
		
		RemovePlayerAttachedObject(playerid, 9);
		TogglePlayerControllable(playerid, 0);
		pData[playerid][pLoading] = true;
		pData[playerid][pRefleBar] = SetTimerEx("RefleLoadMoney", 1000, true, "d", playerid);
		pData[playerid][pRefleBar] = ShowProgressbar(playerid, "MEMASUKAN UANG", 20);
		//Showbar(playerid, 20, "MEMASUKAN UANG", "RefleLoadMoney");
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja Reflenish", 10000);
	return 1;
}

function RefleLoadMoney(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pRefleBar])) return 0;
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, 1427.72, -961.60, 36.34))
			{
				KillTimer(pData[playerid][pRefleBar]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLoading] = false;

				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);

				TogglePlayerControllable(playerid, 1);
				Info(playerid, "Kamu telah selesai meload money.");
				Info(playerid, "Lanjutkan dengan mencari atm di sekitar kota (/findatm)");
				InfoTD_MSG(playerid, 8000, "Load Succes!");
				VehRefleMoney[GetPlayerVehicleID(playerid)] = 3;
				pData[playerid][pEnergy] -= 3;
			}
			else
			{
				KillTimer(pData[playerid][pRefleBar]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLoading] = false;
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, 1427.72, -961.60, 36.34))
			{
				pData[playerid][pActivityTime] += 5;
			}
		}
	}
	return 1;
}

CMD:unloadmoney(playerid, params[])
{
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pJobTime] > 0) 
			return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

		if(pData[playerid][pLoading] == true) 
			return ShowNotifError(playerid, "Anda Masih Unload Money", 10000);

		if(pData[playerid][pActivityTime] > 5)
			return ShowNotifError(playerid, "Kamu masih memiliki activity progress", 10000);

		if(pData[playerid][pRefleHaveBox] == 1)
			return ShowNotifError(playerid, "Kamu sedang membawa paket uang ditangan", 10000);

		if(!IsAReflenishVeh(GetPVarInt(playerid, "LastVehicleID")))
			return ShowNotifError(playerid, "Kamu harus menaiki menaiki ulang truck yang sebelumnya kamu kendarai", 10000);

		new Float:x, Float:y, Float:z;
		GetVehicleBoot(GetPVarInt(playerid, "LastVehicleID"), x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
			return ShowNotifError(playerid, "Kamu harus berada di belakang kendaraan truck mu", 10000);

		if(VehRefleMoney[GetPVarInt(playerid, "LastVehicleID")] < 1)
			return ShowNotifError(playerid, "Kendaraan ini tidak membawa stok uang", 10000);

		pData[playerid][pActivityTime] += 5;

		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ClearAnimations(playerid);
		TogglePlayerControllable(playerid, 0);
		pData[playerid][pLoading] = true;

		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
		SetTimerEx("RefleUnloadMoney", 5000, false, "i", playerid);
		//Showbar(playerid, 5, "MENGAMBIL UANG", "RefleUnloadMoney");
		ShowProgressbar(playerid, "MENGAMBIL UANG", 5);
		Info(playerid, "Kamu sedang mengambil paket uang dari bagasi kendaraan");
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja reflenish", 10000);
	return 1;
}

function RefleUnloadMoney(playerid)
{
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pRefleHaveBox] == 0)
		{
			SetPlayerAttachedObject(playerid, 9, 1550, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
			pData[playerid][pLoading] = false;
			TogglePlayerControllable(playerid, 1);
			pData[playerid][pActivityTime] = 5;
			pData[playerid][pRefleHaveBox] = 1;
			VehRefleMoney[GetPVarInt(playerid, "LastVehicleID")] -= 1;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
			ClearAnimations(playerid);
			Info(playerid, "Kamu telah selesai mengambil paket uang dari kendaraanmu (/fillatm) untuk mengisi stok kedalam mesin atm");
		}
	}
	return 1;
}

CMD:fillatm(playerid, params[])
{
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pJobTime] > 0) 
			return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

		if(pData[playerid][pLoading] == true) 
			return ShowNotifError(playerid, "Anda Masih Fill Atm", 10000);

		if(pData[playerid][pActivityTime] > 5)
			return ShowNotifError(playerid, "Kamu masih memiliki activity progress", 10000);

		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return ShowNotifError(playerid, "Kamu harus turun dari dalam kendaraan", 10000);
		
		if(pData[playerid][pRefleHaveBox] == 0)
			return ShowNotifError(playerid, "Kamu harus mengambil paket uang dari kendaraan mu (/unloadmoney)", 10000);
		{
			foreach(new atmid : ATMS)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.5, AtmData[atmid][atmX], AtmData[atmid][atmY], AtmData[atmid][atmZ]))
				{
					if(AtmData[atmid][atmStatus] == 1)
					{
						RemovePlayerAttachedObject(playerid, 9);
						VehRefleMoney[GetPVarInt(playerid, "LastVehicleID")] += 1;
						pData[playerid][pRefleHaveBox] = 0;
						ShowNotifError(playerid, "Mesin ATM sedang rusak (/repairatm) untuk memperbaikinya", 10000);
						return 1;
					}

					if(AtmData[atmid][atmStock] >= 2000000)
						return ShowNotifError(playerid, "Mesin ATM ini masih memiliki stock yang banyak", 10000);

					Info(playerid, "Kamu sedang mengisi uang kedalam mesin atm");
					RemovePlayerAttachedObject(playerid, 9);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
					ClearAnimations(playerid);

					ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,1,0,0,1,0,1);
					pData[playerid][pRefleBar] = SetTimerEx("RefleFillAtm", 1000, true, "i", playerid);
					pData[playerid][pRefleBar] = ShowProgressbar(playerid, "MEMASUKAN UANG", 20);
					//Showbar(playerid, 20, "MEMASUKAN UANG", "RefleFillAtm");
					pData[playerid][pLoading] = true;
					pData[playerid][pRefleATMID] = atmid;
				}
			}
		}
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja reflenish", 10000);
	return 1;
}

function RefleFillAtm(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pRefleBar])) return 0;
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(pData[playerid][pRefleTotalWork] == 3)
			{
				new atmid = pData[playerid][pRefleATMID];
				TogglePlayerControllable(playerid, 1);
				InfoTD_MSG(playerid, 8000, "Fill Succes!");
				KillTimer(pData[playerid][pRefleBar]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pEnergy] -= 3;
				pData[playerid][pRefleHaveBox] = 0;
				pData[playerid][pRefleTotalWork] = 0;
				pData[playerid][pJobTime] = 200;
				AtmData[atmid][atmStock] = 1000000;
				GivePlayerMoneyEx(playerid, jobreflenishprice);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pLoading] = false;
				ClearAnimations(playerid);
				Info(playerid, "Kamu telah mengisi stock uang kedalam mesin atm, dan mendapatkan "GREEN_LIGHT"%s", FormatMoney(jobreflenishprice));
				Info(playerid, "Lanjutkan pekerjaan dengan mencari atm di sekitar kota (/findatm)");
				Atm_Refresh(atmid);
				Atm_Save(atmid);
			}
			else if(pData[playerid][pRefleHaveBox] == 1)
			{
				new atmid = pData[playerid][pRefleATMID];
				TogglePlayerControllable(playerid, 1);
				InfoTD_MSG(playerid, 8000, "Fill Succes!");
				KillTimer(pData[playerid][pRefleBar]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pEnergy] -= 3;
				pData[playerid][pRefleTotalWork] += 1;
				pData[playerid][pRefleHaveBox] = 0;
				AtmData[atmid][atmStock] = 1000000;
				GivePlayerMoneyEx(playerid, jobreflenishprice);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pLoading] = false;
				ClearAnimations(playerid);
				Info(playerid, "Kamu telah mengisi stock uang kedalam atm, dan mendapatkan "GREEN_LIGHT"%s", FormatMoney(jobreflenishprice));
				Info(playerid, "Lanjutkan pekerjaan dengan mencari atm di sekitar kota (/findatm)");\
				Atm_Refresh(atmid);
				Atm_Save(atmid);
			}
			else
			{
				KillTimer(pData[playerid][pRefleBar]);
				pData[playerid][pActivityTime] = 0;
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
		}
	}
	return 1;
}

CMD:repairatm(playerid, params[])
{
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pJobTime] > 0) 
			return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

		if(pData[playerid][pLoading] == true) 
			return ShowNotifError(playerid, "Anda Masih Fill Atm", 10000);

		if(pData[playerid][pActivityTime] > 5)
			return ShowNotifError(playerid, "Kamu masih memiliki activity progress", 10000);

		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return ShowNotifError(playerid, "Kamu harus turun dari dalam kendaraan", 10000);

		foreach(new atmid : ATMS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, AtmData[atmid][atmX], AtmData[atmid][atmY], AtmData[atmid][atmZ]))
			{
				if(AtmData[atmid][atmStatus] == 0)
					return ShowNotifError(playerid, "ATM ini tidak dalam keadaan rusak", 10000);

				Info(playerid, "Kamu sedang memperbaiki mesin atm");
				RemovePlayerAttachedObject(playerid, 9);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				ClearAnimations(playerid);
				pData[playerid][pLoading] = true;

				ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,1,0,0,1,0,1);
				pData[playerid][pRefleBar] = SetTimerEx("RefleRepairATM", 1000, true, "i", playerid);
				pData[playerid][pRefleBar] = ShowProgressbar(playerid, "MEMPERBAIKI MESIN ATM", 20);
				//Showbar(playerid, 20, "MEMPERBAIKI MESIN ATM", "RefleRepairATM");
				pData[playerid][pRefleATMID] = atmid;
			}
		}
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja Reflenish", 10000);
	return 1;
}

function RefleRepairATM(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pRefleBar])) return 0;
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(pData[playerid][pRefleTotalWork] == 3)
			{
				new atmid = pData[playerid][pRefleATMID];
				TogglePlayerControllable(playerid, 1);
				InfoTD_MSG(playerid, 8000, "Repair Succes!");
				KillTimer(pData[playerid][pRefleBar]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pEnergy] -= 3;
				AtmData[atmid][atmStatus] = 0;
				pData[playerid][pRefleTotalWork] = 0;
				pData[playerid][pJobTime] = 60;
				GivePlayerMoneyEx(playerid, jobreflenishprice);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pLoading] = false;
				ClearAnimations(playerid);
				Info(playerid, "Kamu telah memperbaiki ATM dan mendapatkan "GREEN_LIGHT"%s", FormatMoney(jobreflenishprice));
				Info(playerid, "Lanjutkan pekerjaan dengan mencari atm di sekitar kota (/findatm)");
				Atm_Refresh(atmid);
				Atm_Save(atmid);
			}
			else if(pData[playerid][pRefleTotalWork] <= 2)
			{
				new atmid = pData[playerid][pRefleATMID];
				TogglePlayerControllable(playerid, 1);
				InfoTD_MSG(playerid, 8000, "Repair Succes!");
				KillTimer(pData[playerid][pRefleBar]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pEnergy] -= 3;
				AtmData[atmid][atmStatus] = 0;
				pData[playerid][pRefleTotalWork] += 1;
				GivePlayerMoneyEx(playerid, jobreflenishprice);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pLoading] = false;
				ClearAnimations(playerid);
				Info(playerid, "Kamu telah memperbaiki ATM ini dan mendapatkan "GREEN_LIGHT"%s", FormatMoney(jobreflenishprice));
				Info(playerid, "Lanjutkan pekerjaan dengan mencari atm di sekitar kota (/findatm)");
				Atm_Refresh(atmid);
				Atm_Save(atmid);
			}
			else
			{
				KillTimer(pData[playerid][pRefleBar]);
				pData[playerid][pLoading] = false;
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
	}
	return 1;
}

/*CMD:findatm(playerid, params[])
{
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		if(pData[playerid][pGpsIns] == 0)
			return ShowNotifError(playerid, "Kamu tidak memiliki gps");

		if(GetATMStatus() <= 0)
			return ShowNotifError(playerid, "Tidak ada atm yang kekurangan stock/rusak.");

		new id, count = GetATMStatus(), mission[2024], lstr[3024], status[128], stok[128];
				
		strcat(mission,"NO\tLOCATION\tSTOCK\tSTATUS\n",sizeof(mission));
		Loop(itt, (count + 1), 1)
		{
			id = ReturnRestockATMID(itt);

			if(AtmData[id][atmStock] >= 1000000)
			{
				stok = ""GREEN_LIGHT"Full{ffffff}";
			}
			else
			{
				stok = ""RED_E"Needed{ffffff}";
			}
			if(AtmData[id][atmStatus] == 0)
			{
				status = ""GREEN_LIGHT"Good";
			}
			else
			{
				status = ""RED_E"Damaged";
			}
			if(itt == count)
			{
				format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", itt, GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), stok, status);
			}
			else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", itt, GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), stok, status);	
			strcat(mission,lstr,sizeof(mission));
		}
		ShowPlayerDialog(playerid, DIALOG_FIND_ATM, DIALOG_STYLE_TABLIST_HEADERS,"ATM Checker",mission,"Start","Cancel");
	}
	else return Error(playerid, "Kamu bukan pekerja reflenish");
	return 1;
}*/

GetATMStatus()
{
	new tmpcount;
	foreach(new id : ATMS)
	{
	    if(AtmData[id][atmStock] < 1000000 || AtmData[id][atmStatus] != 0)
	    {
     		tmpcount++;
	    }
	}
	return tmpcount;
}

ReturnRestockATMID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_ATM) return -1;
	foreach(new id : ATMS)
	{
		if(AtmData[id][atmStock] < 1000000 || AtmData[id][atmStatus] != 0)
		{
	     	tmpcount++;
	       	if(tmpcount == slot)
	       	{
	        	return id;
	  		}
		}
	}
	return -1;
}

/*
	//ENUM PLAYER

    pRefleBar,
    pRefleHaveBox,
    pRefleATMID,
    pRefleTotalWork,

*/

CMD:tsss(playerid, params[])
{
	Info(playerid, "Vehid : %d Stock : %d", GetPVarInt(playerid, "LastVehicleID"), VehRefleMoney[GetPVarInt(playerid, "LastVehicleID")]);
	return 1;
}