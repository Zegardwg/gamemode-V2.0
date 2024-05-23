/*

	=====================[ JOB DAGING ]===========================

*/

#include <YSI_Coding\y_hooks>

enum E_BUTCHERAREA
{
	STREAMER_TAG_AREA:Ambildaging,
	STREAMER_TAG_AREA:Ambildaging2,
	STREAMER_TAG_AREA:Potongdaging,
	STREAMER_TAG_AREA:Potongdaging2,
	STREAMER_TAG_AREA:Potongdaging3,
	STREAMER_TAG_AREA:Potongdaging4,
	STREAMER_TAG_AREA:Potongdaging5,
	STREAMER_TAG_AREA:packingdaging,
	STREAMER_TAG_AREA:packingdaging2,
	STREAMER_TAG_AREA:jualdaging,
	STREAMER_TAG_AREA:Dutyarea,
	STREAMER_TAG_CP:Dutycp,
	STREAMER_TAG_MAP_ICON:Icondaging,
	STREAMER_TAG_CP:Ambildagingcp,
	STREAMER_TAG_CP:Ambildagingcp2,
	STREAMER_TAG_CP:Potongdagingcp,
	STREAMER_TAG_CP:Potongdagingcp2,
	STREAMER_TAG_CP:Potongdagingcp3,
	STREAMER_TAG_CP:Potongdagingcp4,
	STREAMER_TAG_CP:Potongdagingcp5,
	STREAMER_TAG_CP:Packingdagingcp,
	STREAMER_TAG_CP:Packingdagingcp2,
	STREAMER_TAG_CP:Jualdagingcp
}
new Butcherarea[MAX_PLAYERS][E_BUTCHERAREA];

DeleteJobDagingMap(playerid)
{
	if(IsValidDynamicArea(Butcherarea[playerid][Dutyarea]))
	{
		DestroyDynamicArea(Butcherarea[playerid][Dutyarea]);
		Butcherarea[playerid][Dutyarea] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Dutycp]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Dutycp]);
		Butcherarea[playerid][Dutycp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicMapIcon(Butcherarea[playerid][Icondaging]))
	{
		DestroyDynamicMapIcon(Butcherarea[playerid][Icondaging]);
		Butcherarea[playerid][Icondaging] = STREAMER_TAG_MAP_ICON: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][Ambildaging]))
	{
		DestroyDynamicArea(Butcherarea[playerid][Ambildaging]);
		Butcherarea[playerid][Ambildaging] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][Ambildaging2]))
	{
		DestroyDynamicArea(Butcherarea[playerid][Ambildaging2]);
		Butcherarea[playerid][Ambildaging2] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][Potongdaging]))
	{
		DestroyDynamicArea(Butcherarea[playerid][Potongdaging]);
		Butcherarea[playerid][Potongdaging] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][Potongdaging2]))
	{
		DestroyDynamicArea(Butcherarea[playerid][Potongdaging2]);
		Butcherarea[playerid][Potongdaging2] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][Potongdaging3]))
	{
		DestroyDynamicArea(Butcherarea[playerid][Potongdaging3]);
		Butcherarea[playerid][Potongdaging3] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][Potongdaging4]))
	{
		DestroyDynamicArea(Butcherarea[playerid][Potongdaging4]);
		Butcherarea[playerid][Potongdaging4] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][Potongdaging5]))
	{
		DestroyDynamicArea(Butcherarea[playerid][Potongdaging5]);
		Butcherarea[playerid][Potongdaging5] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][packingdaging]))
	{
		DestroyDynamicArea(Butcherarea[playerid][packingdaging]);
		Butcherarea[playerid][packingdaging] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][packingdaging2]))
	{
		DestroyDynamicArea(Butcherarea[playerid][packingdaging2]);
		Butcherarea[playerid][packingdaging2] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(Butcherarea[playerid][jualdaging]))
	{
		DestroyDynamicArea(Butcherarea[playerid][jualdaging]);
		Butcherarea[playerid][jualdaging] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Ambildagingcp]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Ambildagingcp]);
		Butcherarea[playerid][Ambildagingcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Ambildagingcp2]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Ambildagingcp2]);
		Butcherarea[playerid][Ambildagingcp2] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Potongdagingcp]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Potongdagingcp]);
		Butcherarea[playerid][Potongdagingcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Potongdagingcp2]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Potongdagingcp2]);
		Butcherarea[playerid][Potongdagingcp2] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Potongdagingcp3]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Potongdagingcp3]);
		Butcherarea[playerid][Potongdagingcp3] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Potongdagingcp4]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Potongdagingcp4]);
		Butcherarea[playerid][Potongdagingcp4] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Potongdagingcp5]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Potongdagingcp5]);
		Butcherarea[playerid][Potongdagingcp5] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Packingdagingcp]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Packingdagingcp]);
		Butcherarea[playerid][Packingdagingcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Packingdagingcp2]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Packingdagingcp2]);
		Butcherarea[playerid][Packingdagingcp2] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(Butcherarea[playerid][Jualdagingcp]))
	{
		DestroyDynamicCP(Butcherarea[playerid][Jualdagingcp]);
		Butcherarea[playerid][Jualdagingcp] = STREAMER_TAG_CP: -1;
	}
}

RefreshMapJobDaging(playerid)
{
	DeleteJobDagingMap(playerid);

	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(!pData[playerid][pJobdagingduty])
		{
			Butcherarea[playerid][Dutyarea] = CreateDynamicCircle(961.02, 2098.98, 1.0, -1, -1, playerid);
			Butcherarea[playerid][Dutycp] = CreateDynamicCP(961.02, 2098.98, 1011.02, 1.5, -1, -1, playerid, 30.0);
		}
		else
		{
			Butcherarea[playerid][Dutyarea] = CreateDynamicCircle(961.02, 2098.98, 1.0, -1, -1, playerid);
			Butcherarea[playerid][Dutycp] = CreateDynamicCP(961.02, 2098.98, 1011.02, 1.5, -1, -1, playerid, 30.0);

			Butcherarea[playerid][Ambildaging] = CreateDynamicCircle(948.23, 2104.04, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Ambildagingcp] = CreateDynamicCP(948.23, 2104.04, 1011.02, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][Ambildaging2] = CreateDynamicCircle(961.30, 2123.97, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Ambildagingcp2] = CreateDynamicCP(948.23, 2104.04, 1011.02, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][Potongdaging] = CreateDynamicCircle(961.30, 2123.97, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Potongdagingcp] = CreateDynamicCP(961.30, 2123.97, 1011.02, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][Potongdaging2] = CreateDynamicCircle(961.25, 2127.19, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Potongdagingcp2] = CreateDynamicCP(961.25, 2127.19, 1011.02, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][Potongdaging3] = CreateDynamicCircle(961.26, 2133.15, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Potongdagingcp3] = CreateDynamicCP(961.26, 2133.15, 1011.02, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][Potongdaging4] = CreateDynamicCircle(961.27, 2136.51, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Potongdagingcp4] = CreateDynamicCP(961.27, 2136.51, 1011.02, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][Potongdaging5] = CreateDynamicCircle(961.24, 2142.78, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Potongdagingcp5] = CreateDynamicCP(961.24, 2142.78, 1011.02, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][packingdaging] = CreateDynamicCircle(941.17, 2127.65, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Packingdagingcp] = CreateDynamicCP(941.17, 2127.65, 1011.03, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][packingdaging2] = CreateDynamicCircle(943.57, 2127.52, 1.0, -1, -1, playerid); 
			Butcherarea[playerid][Packingdagingcp2] = CreateDynamicCP(943.57, 2127.52, 1011.02, 1.5, -1, -1, -1, 30.0);
			Butcherarea[playerid][jualdaging] = CreateDynamicCircle(1996.39, -2065.53, 3.0, -1, -1, playerid);
			Butcherarea[playerid][Jualdagingcp] = CreateDynamicCP(1996.39, -2065.53, 13.54, 1.5, -1, -1, -1, 30.0);

			Butcherarea[playerid][Icondaging] = CreateDynamicMapIcon(300.12, 1141.13, 9.13, 19238, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		}
	}
	return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Dutyarea]))
		{
			if(areaid == Butcherarea[playerid][Dutyarea])
			{
				if(!pData[playerid][pJobdagingduty])
				{
					showinfotombol(playerid, "Untuk ~g~On Duty");
				}
				else
				{
					showinfotombol(playerid, "Untuk ~r~Off Duty");
				}
			}
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10 && pData[playerid][pJobdagingduty] == true)
	{
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Ambildaging]))
		{
			if(areaid == Butcherarea[playerid][Ambildaging])
			{
				showinfotombol(playerid, "Untuk Ambil Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Ambildaging2]))
		{
			if(areaid == Butcherarea[playerid][Ambildaging2])
			{
				showinfotombol(playerid, "Untuk Ambil Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Potongdaging]))
		{
			if(areaid == Butcherarea[playerid][Potongdaging])
			{
				showinfotombol(playerid, "Untuk Potong Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Potongdaging2]))
		{
			if(areaid == Butcherarea[playerid][Potongdaging2])
			{
				showinfotombol(playerid, "Untuk Potong Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Potongdaging3]))
		{
			if(areaid == Butcherarea[playerid][Potongdaging3])
			{
				showinfotombol(playerid, "Untuk Potong Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Potongdaging4]))
		{
			if(areaid == Butcherarea[playerid][Potongdaging4])
			{
				showinfotombol(playerid, "Untuk Potong Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Potongdaging5]))
		{
			if(areaid == Butcherarea[playerid][Potongdaging5])
			{
				showinfotombol(playerid, "Untuk Potong Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][packingdaging]))
		{
			if(areaid == Butcherarea[playerid][packingdaging])
			{
				showinfotombol(playerid, "Untuk Packing Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][packingdaging2]))
		{
			if(areaid == Butcherarea[playerid][packingdaging2])
			{
				showinfotombol(playerid, "Untuk Packing Daging");
			}
		}
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][jualdaging]))
		{
			if(areaid == Butcherarea[playerid][jualdaging])
			{
				showinfotombol(playerid, "Untuk Jual Daging");
			}
		}
	}
	return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(areaid == Butcherarea[playerid][Dutyarea])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][Ambildaging])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][Ambildaging2])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][Potongdaging])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][Potongdaging2])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][Potongdaging3])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][Potongdaging4])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][Potongdaging5])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][packingdaging])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][packingdaging2])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == Butcherarea[playerid][jualdaging])
	{
		HideInfoTombol(playerid);
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(IsPlayerInDynamicArea(playerid, Butcherarea[playerid][Dutyarea]))
		{
			if(!pData[playerid][pJobdagingduty])
			{
				pData[playerid][pJobdagingduty] = true;
				SetPlayerSkin(playerid, 168);
				ShowNotifSukses(playerid, "Anda Sekarang On duty", 10000);

				RefreshMapJobDaging(playerid);
			}
			else
			{
				pData[playerid][pJobdagingduty] = false;
				SetPlayerSkin(playerid, pData[playerid][pSkin]);
				ShowNotifSukses(playerid, "Anda Sekarang Off duty", 10000);
				RefreshMapJobDaging(playerid);
			}
		}
	}
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 10 && pData[playerid][pJobdagingduty] == true)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02))
        {
        	return callcmd::takemeat(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.26, 2133.15, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.24, 2142.78, 1011.02))
        {
        	return callcmd::cuttingmeat(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03))
        {
        	return callcmd::packingmeat(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1996.39, -2065.53, 13.54))
        {
        	return callcmd::sellmeat(playerid, "");
        }
	}
	else if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob2] == 10 && pData[playerid][pJobdagingduty] == true)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02))
        {
        	return callcmd::takemeat(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.26, 2133.15, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.24, 2142.78, 1011.02))
        {
        	return callcmd::cuttingmeat(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03))
        {
        	return callcmd::packingmeat(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1996.39, -2065.53, 13.54))
        {
        	return callcmd::sellmeat(playerid, "");
        }
	}
	return 1;
}

CMD:takemeat(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) 
		return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02))
		return ShowNotifError(playerid, "Kamu tidak berada ditempat pengambilan daging", 10000);

	/*if(pData[playerid][pMeatProgres] != 0) 
		return ShowNotifError(playerid, "Kamu sudah melewati tahap pengambilan daging", 10000);*/

	if(pData[playerid][pLoading] == true)
		return ShowNotifError(playerid, "Anda Masih Memiliki Activity Progress", 10000);

	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
		if(pData[playerid][pDagingMentah] == 20) return ErrorMsg(playerid, "Inventory Daging Anda Sudah Penuh MAX: 20 Daging mentah");

		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		TogglePlayerControllable(playerid, 0);
		pData[playerid][pLoading] = true;

		ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat

		pData[playerid][pMeatJob] = SetTimerEx("takemeat", 1000, true, "i", playerid);
		//Showbar(playerid, 5, "MENGAMBIL DAGING", "takemeat");
		ShowProgressbar(playerid, "MENGAMBIL DAGING", 5);
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja pemotong daging!", 10000);
	return 1;
}

CMD:cuttingmeat(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) 
		return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

	if(pData[playerid][pLoading] == true)
		return ShowNotifError(playerid, "Anda Masih Proses", 10000);

	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.26, 2133.15, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 1.5, 961.24, 2142.78, 1011.02))
		{
			if(GetPlayerWeapon(playerid) == WEAPON_KNIFE)
			{
				if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
				if(pData[playerid][pDagingPotong] == 20) return ErrorMsg(playerid, "Inventory Potongan Daging Anda Sudah Penuh MAX: 20 Potongan Daging Sapi");
				if(pData[playerid][pDagingMentah] < 1) return ErrorMsg(playerid, "Anda Tidak Punya Daging Sapi Mentah");

				RemovePlayerAttachedObject(playerid, 9);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				TogglePlayerControllable(playerid, 0);
				pData[playerid][pLoading] = true;

				ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 1, 0, 1);

				pData[playerid][pMeatJob] = SetTimerEx("cuttingmeat", 1000, true, "i", playerid);
				//Showbar(playerid, 5, "MEMOTONG DAGING", "cuttingmeat");
				ShowProgressbar(playerid, "MEMOTONG DAGING", 5);
			}
			else
			{
				RemovePlayerAttachedObject(playerid, 9);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				TogglePlayerControllable(playerid, 1);
				ShowNotifError(playerid, "Kamu harus membeli pisau di toko equipment untuk memotong daging", 10000);
				return 1;
			}
		}
		else return ShowNotifError(playerid, "Kamu tidak berada ditempat pemotongan daging", 10000);
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja pemotong daging!", 10000);
	return 1;
}

CMD:packingmeat(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0)
		return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

	if(pData[playerid][pLoading] == true)
		return ShowNotifError(playerid, "Anda Masih Proses", 10000);

	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03))
		{
			if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
			if(pData[playerid][pDagingKemas] == 20) return ErrorMsg(playerid, "Inventory Kotak Daging Anda Sudah Penuh MAX: 20 Kotak Daging Sapi");
			if(pData[playerid][pDagingPotong] < 1) return ErrorMsg(playerid, "Anda Tidak Punya Potongan Daging Sapi");

			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			TogglePlayerControllable(playerid, 0);
			pData[playerid][pLoading] = true;

			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);

			pData[playerid][pMeatJob] = SetTimerEx("packingmeat", 1000, true, "i", playerid);
			//Showbar(playerid, 5, "PACKING DAGING", "packingmeat");
			ShowProgressbar(playerid, "PACKING DAGING", 5);
		}
		else return ShowNotifError(playerid, "Kamu tidak berada ditempat pengemasan daging", 10000);
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja pemotong daging!", 10000);
	return 1;
}

CMD:sellmeat(playerid, params[])
{
	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1996.39, -2065.53, 13.54))
			return ShowNotifError(playerid, "Kamu tidak berada ditempat penjualan daging", 10000);
		{
			if(pData[playerid][pDagingKemas] < 20) return ErrorMsg(playerid, "Anda Kurang Membawa kotak daging sapi, MAX : 20 Kemasan Daging Sapi");
			{
				RemovePlayerAttachedObject(playerid, 9);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				TogglePlayerControllable(playerid, 1);
				AddPlayerSalary(playerid, "Job(Butcher)", jobbutcherprice);
				ShowNotifInfo(playerid, "Job(Butcher) telah masuk ke pending salary anda!", 10000);
				//Inventory_Remove(playerid, "Kemasan Daging Sapi", 20);
				pData[playerid][pDagingKemas] -= 20;
				pData[playerid][pMeatProgres] = 0;
				pData[playerid][pJobTime] = 250;
				Daging += 20;
				Server_Save();
			}
		}
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja pemotong daging!", 10000);
	return 1;
}

function takemeat(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMeatJob])) return 0;
	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.24, 2142.78, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.26, 2133.15, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02))
			{
				//SetPlayerAttachedObject(playerid, 9, 2804, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
				ShowNotifInfo(playerid, "Anda telah berhasil mengambil daging", 5000);
				//Inventory_Add(playerid, "Daging Sapi Mentah", 2805, 1);
				pData[playerid][pDagingMentah]++;
				ShowItemBox(playerid, "Daging_Sapi_Mentah", "Received_1x", 2805, 3);
				ShowNotifSukses(playerid, "Taking Succes!", 5000);
				TogglePlayerControllable(playerid, 1);
				KillTimer(pData[playerid][pMeatJob]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLoading] = false;
				ClearAnimations(playerid);
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.24, 2142.78, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.26, 2133.15, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02))
			{
				pData[playerid][pActivityTime] += 20;
			}
		}
	}
	return 1;
}

function cuttingmeat(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMeatJob])) return 0;
	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.24, 2142.78, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.26, 2133.15, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02))
			{
				//SetPlayerAttachedObject(playerid, 9, 2805, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
				ShowNotifInfo(playerid, "Anda telah berhasil memotong daging", 5000);
				pData[playerid][pDagingMentah]--;
				pData[playerid][pDagingPotong]++;
				ShowItemBox(playerid, "Daging_Sapi_Mentah", "Removed_1x", 2805, 3);
				ShowItemBox(playerid, "Potongan_Daging_Sapi", "Received_1x", 2805, 3);
				//Inventory_Add(playerid, "Potongan Daging Sapi", 2805, 1);
				//Inventory_Remove(playerid, "Daging Sapi Mentah", 1);
				ShowNotifSukses(playerid, "Cutting Succes!", 5000);
				TogglePlayerControllable(playerid, 1);
				KillTimer(pData[playerid][pMeatJob]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLoading] = false;
				ClearAnimations(playerid);
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.24, 2142.78, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.26, 2133.15, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02))
			{
				pData[playerid][pActivityTime] += 20;
			}
		}
	}
	return 1;
}

function packingmeat(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMeatJob])) return 0;
	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.24, 2142.78, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.26, 2133.15, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02))
			{
				ShowNotifInfo(playerid, "Anda telah berhasil mempacking daging", 5000);
				pData[playerid][pDagingPotong]--;
				pData[playerid][pDagingKemas]++;
				ShowItemBox(playerid, "Potongan_Daging_Sapi", "Removed_1x", 2805, 3);
				ShowItemBox(playerid, "Kemasan_Daging_Sapi", "Received_1x", 2805, 3);
				//Inventory_Add(playerid, "Kemasan Daging Sapi", 2805, 1);
				//Inventory_Remove(playerid, "Potongan Daging Sapi", 1);
				ShowNotifSukses(playerid, "Packing Succes!", 5000);
				TogglePlayerControllable(playerid, 1);
				KillTimer(pData[playerid][pMeatJob]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLoading] = false;
				ClearAnimations(playerid);
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 948.23, 2104.04, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 941.17, 2127.65, 1011.03)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 943.57, 2127.52, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.24, 2142.78, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.27, 2136.51, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.26, 2133.15, 1011.02)
			|| IsPlayerInRangeOfPoint(playerid, 3.0, 961.25, 2127.19, 1011.02) || IsPlayerInRangeOfPoint(playerid, 3.0, 961.30, 2123.97, 1011.02))
			{
				pData[playerid][pActivityTime] += 20;
			}
		}
	}
	return 1;
}