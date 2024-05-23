/*

	JOB PEMERAS SUSU CEWE

*/

#include <YSI_Coding\y_hooks>

new cow1,
	cow2,
	cow3,
	cow4,
	cow5,
	cow6,
	cow7,
	cow8,
	cow9,
	cow10,
	cow11,
	cow12,
	cow13,
	cow14;

enum E_PEMERASUSU
{
	STREAMER_TAG_AREA:Dutyarea,
	STREAMER_TAG_CP:Dutycp,
	STREAMER_TAG_MAP_ICON:Iconsapi,
	STREAMER_TAG_AREA:Olahsusu,
	STREAMER_TAG_CP:Olahcp
}
new PemerasArea[MAX_PLAYERS][E_PEMERASUSU];

DeleteJobPemerahMap(playerid)
{
	if(IsValidDynamicArea(PemerasArea[playerid][Dutyarea]))
	{
		DestroyDynamicArea(PemerasArea[playerid][Dutyarea]);
		PemerasArea[playerid][Dutyarea] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(PemerasArea[playerid][Olahsusu]))
	{
		DestroyDynamicArea(PemerasArea[playerid][Olahsusu]);
		PemerasArea[playerid][Olahsusu] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Dutycp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Dutycp]);
		PemerasArea[playerid][Dutycp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Olahcp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Olahcp]);
		PemerasArea[playerid][Olahcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Olahcp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Olahcp]);
		PemerasArea[playerid][Olahcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicMapIcon(PemerasArea[playerid][Iconsapi]))
	{
		DestroyDynamicMapIcon(PemerasArea[playerid][Iconsapi]);
		PemerasArea[playerid][Iconsapi] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshMapJobSapi(playerid)
{
	DeleteJobPemerahMap(playerid);

	if(pData[playerid][pJob] == 14)
	{
		if(!pData[playerid][pJobmilkduty])
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			destroyladangsapi();
		}
		else
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Olahsusu] = CreateDynamicCircle(315.27, 1154.77, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Olahcp] = CreateDynamicCP(315.27, 1154.77, 8.58, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Iconsapi] = CreateDynamicMapIcon(300.12, 1141.13, 9.13, 19238, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);

			createladangsapi();
		}
		return 1;
	}
	if(pData[playerid][pJob2] == 14)
	{
		if(!pData[playerid][pJobmilkduty])
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			destroyladangsapi();
		}
		else
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Olahsusu] = CreateDynamicCircle(315.27, 1154.77, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Olahcp] = CreateDynamicCP(315.27, 1154.77, 8.58, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Iconsapi] = CreateDynamicMapIcon(300.12, 1141.13, 9.13, 19238, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);

			createladangsapi();
		}
	}

	return 1;
}

createladangsapi()
{
	new object_world = -1, object_int = -1;

	/*tmpobjid = CreateDynamicObject(3276, 268.098236, 1126.563354, 9.966876, 0.000000, 2.099997, 93.699981, object_world, object_int, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3276, 267.349334, 1138.146850, 10.080492, 0.000000, -2.400002, 93.700004, object_world, object_int, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3276, 266.599517, 1149.742309, 10.567505, 0.000000, -2.400002, 93.700004, object_world, object_int, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3276, 221.026809, 1121.700927, 13.247010, 0.000000, -1.600003, -59.600028, object_world, object_int, -1, 300.00, 300.00); */

	cow1 = CreateDynamicObject(19833, 253.927902, 1140.457641, 10.066599, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	cow2 = CreateDynamicObject(19833, 253.927902, 1130.417602, 9.526599, 0.000000, 0.000000, 95.800003, object_world, object_int, -1, 300.00, 300.00); 
	cow3 = CreateDynamicObject(19833, 245.680389, 1129.579833, 9.946600, 0.000000, 0.000000, -29.899995, object_world, object_int, -1, 300.00, 300.00); 
	cow4 = CreateDynamicObject(19833, 237.748306, 1134.141479, 10.526604, 0.000000, 0.000000, 85.899993, object_world, object_int, -1, 300.00, 300.00); 
	cow5 = CreateDynamicObject(19833, 238.098693, 1139.028808, 10.746607, 0.000000, 0.000000, 128.600006, object_world, object_int, -1, 300.00, 300.00); 
	cow6 = CreateDynamicObject(19833, 233.163864, 1145.209228, 11.486613, 0.000000, 0.000000, -154.399993, object_world, object_int, -1, 300.00, 300.00); 
	cow7 = CreateDynamicObject(19833, 231.071533, 1133.838745, 10.976607, 0.000000, 0.000000, -101.399978, object_world, object_int, -1, 300.00, 300.00); 
	cow8 = CreateDynamicObject(19833, 233.103103, 1129.363769, 10.686608, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
	cow9 = CreateDynamicObject(19833, 237.083068, 1125.641357, 10.506606, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
	cow10 = CreateDynamicObject(19833, 247.684814, 1152.292846, 10.876612, 0.000000, 0.000000, 137.499984, object_world, object_int, -1, 300.00, 300.00); 
	cow11 = CreateDynamicObject(19833, 244.711456, 1142.905395, 10.536610, 0.000000, 0.000000, 69.499938, object_world, object_int, -1, 300.00, 300.00); 
	cow12 = CreateDynamicObject(19833, 261.201599, 1146.604125, 9.896611, 0.000000, 0.000000, -27.000057, object_world, object_int, -1, 300.00, 300.00); 
	cow13 = CreateDynamicObject(19833, 260.699554, 1137.599853, 9.486606, 0.000000, 0.000000, -79.700073, object_world, object_int, -1, 300.00, 300.00); 
	cow14 = CreateDynamicObject(19833, 262.818328, 1125.940917, 9.226603, 0.000000, 0.000000, -141.400070, object_world, object_int, -1, 300.00, 300.00); 

	return 1;
}

destroyladangsapi()
{
	DestroyDynamicObject(cow1);
	DestroyDynamicObject(cow2);
	DestroyDynamicObject(cow3);
	DestroyDynamicObject(cow4);
	DestroyDynamicObject(cow5);
	DestroyDynamicObject(cow6);
	DestroyDynamicObject(cow7);
	DestroyDynamicObject(cow8);
	DestroyDynamicObject(cow9);
	DestroyDynamicObject(cow10);
	DestroyDynamicObject(cow11);
	DestroyDynamicObject(cow12);
	DestroyDynamicObject(cow13);
	DestroyDynamicObject(cow14);


	return 1;
}

function spawncow1(playerid)
{
	new object_world = -1, object_int = -1;
    cow1 = CreateDynamicObject(19833, 253.927902, 1140.457641, 10.066599, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow2(playerid)
{
	new object_world = -1, object_int = -1;
    cow2 = CreateDynamicObject(19833, 253.927902, 1130.417602, 9.526599, 0.000000, 0.000000, 95.800003, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow3(playerid)
{
	new object_world = -1, object_int = -1;
    cow3 = CreateDynamicObject(19833, 245.680389, 1129.579833, 9.946600, 0.000000, 0.000000, -29.899995, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow4(playerid)
{
	new object_world = -1, object_int = -1;
    cow4 = CreateDynamicObject(19833, 237.748306, 1134.141479, 10.526604, 0.000000, 0.000000, 85.899993, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow5(playerid)
{
	new object_world = -1, object_int = -1;
    cow5 = CreateDynamicObject(19833, 238.098693, 1139.028808, 10.746607, 0.000000, 0.000000, 128.600006, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow6(playerid)
{
	new object_world = -1, object_int = -1;
    cow6 = CreateDynamicObject(19833, 233.163864, 1145.209228, 11.486613, 0.000000, 0.000000, -154.399993, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow7(playerid)
{
	new object_world = -1, object_int = -1;
    cow7 = CreateDynamicObject(19833, 231.071533, 1133.838745, 10.976607, 0.000000, 0.000000, -101.399978, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow8(playerid)
{
	new object_world = -1, object_int = -1;
    cow8 = CreateDynamicObject(19833, 233.103103, 1129.363769, 10.686608, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow9(playerid)
{
	new object_world = -1, object_int = -1;
    cow9 = CreateDynamicObject(19833, 237.083068, 1125.641357, 10.506606, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow10(playerid)
{
	new object_world = -1, object_int = -1;
    cow10 = CreateDynamicObject(19833, 247.684814, 1152.292846, 10.876612, 0.000000, 0.000000, 137.499984, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow11(playerid)
{
	new object_world = -1, object_int = -1;
    cow11 = CreateDynamicObject(19833, 244.711456, 1142.905395, 10.536610, 0.000000, 0.000000, 69.499938, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow12(playerid)
{
	new object_world = -1, object_int = -1;
    cow12 = CreateDynamicObject(19833, 261.201599, 1146.604125, 9.896611, 0.000000, 0.000000, -27.000057, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow13(playerid)
{
	new object_world = -1, object_int = -1;
    cow13 = CreateDynamicObject(19833, 260.699554, 1137.599853, 9.486606, 0.000000, 0.000000, -79.700073, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow14(playerid)
{
	new object_world = -1, object_int = -1;
    cow14 = CreateDynamicObject(19833, 262.818328, 1125.940917, 9.226603, 0.000000, 0.000000, -141.400070, object_world, object_int, -1, 300.00, 300.00); 
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(IsPlayerInDynamicArea(playerid, PemerasArea[playerid][Dutyarea]))
		{
			if(areaid == PemerasArea[playerid][Dutyarea])
			{
				if(!pData[playerid][pJobmilkduty])
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
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14 && pData[playerid][pJobmilkduty] == true)
	{
		if(IsPlayerInDynamicArea(playerid, PemerasArea[playerid][Olahsusu]))
		{
			if(areaid == PemerasArea[playerid][Olahsusu])
			{
				showinfotombol(playerid, "Mengolah Susu");
			}
		}
	}
	return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(areaid == PemerasArea[playerid][Dutyarea])
	{
		HideInfoTombol(playerid);
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 14)
	{
		if(IsPlayerInDynamicArea(playerid, PemerasArea[playerid][Dutyarea]))
		{
			if(!pData[playerid][pJobmilkduty])
			{
				pData[playerid][pJobmilkduty] = true;
				ShowNotifSukses(playerid, "Anda Sekarang On duty", 10000);

				RefreshMapJobSapi(playerid);

				Info(playerid, "Silahkan pergi untuk memeras susu,klik Y untuk memeras");
			}
			else
			{
				pData[playerid][pJobmilkduty] = false;
				ShowNotifSukses(playerid, "Anda Sekarang Off duty", 10000);
				RefreshMapJobSapi(playerid);
			}
		}
	}
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 14 && pData[playerid][pJobmilkduty] == true)
    {
    	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
    	if(GetPVarInt(playerid, "delay") > gettime()) return ShowNotifError(playerid, "Mohon Tunggu 10 Detik Untuk Menggunakan kembali.", 10000);
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 253.927902, 1140.457641, 10.066599))
        {
        	//GANTI
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	//if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk1", 1000, true, "i", playerid);
            //Showbar(playerid, 20, "MENGAMBIL SUSU", "takemilk1");
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 253.927902, 1130.417602, 9.526599))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk2", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 245.680389, 1129.579833, 9.946600))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk3", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 237.748306, 1134.141479, 10.526604))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk4", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 238.098693, 1139.028808, 10.746607))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk5", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 233.163864, 1145.209228, 11.486613))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk6", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 231.071533, 1133.838745, 10.976607))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk7", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 233.103103, 1129.363769, 10.686608))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk8", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 237.083068, 1125.641357, 10.506606))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk9", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 247.684814, 1152.292846, 10.876612))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk10", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 244.711456, 1142.905395, 10.536610))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk11", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 261.201599, 1146.604125, 9.896611))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk12", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 260.699554, 1137.599853, 9.486606))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk13", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 262.818328, 1125.940917, 9.226603))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk14", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if(IsPlayerInRangeOfPoint(playerid, 4.0, 315.27, 1154.77, 8.58))
        {
        	return callcmd::olahsusu(playerid, "");
        }
    }
    else if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob2] == 14)
	{
		if(IsPlayerInDynamicArea(playerid, PemerasArea[playerid][Dutyarea]))
		{
			if(!pData[playerid][pJobmilkduty])
			{
				pData[playerid][pJobmilkduty] = true;
				ShowNotifSukses(playerid, "Anda Sekarang On duty", 10000);

				RefreshMapJobSapi(playerid);

				Info(playerid, "Silakan Dekatkan Sapi di ladang sapi Lalu KLIK Y");
			}
			else
			{
				pData[playerid][pJobmilkduty] = false;
				ShowNotifSukses(playerid, "Anda Sekarang Off duty", 10000);
				RefreshMapJobSapi(playerid);
			}
		}
	}
    else if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob2] == 14 && pData[playerid][pJobmilkduty] == true)
    {
    	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
    	if(GetPVarInt(playerid, "delay") > gettime()) return ShowNotifError(playerid, "Mohon Tunggu 10 Detik Untuk Menggunakan kembali.", 10000);
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 253.927902, 1140.457641, 10.066599))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk1", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 253.927902, 1130.417602, 9.526599))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk2", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 245.680389, 1129.579833, 9.946600))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk3", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 237.748306, 1134.141479, 10.526604))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk4", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 238.098693, 1139.028808, 10.746607))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk5", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 233.163864, 1145.209228, 11.486613))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk6", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 231.071533, 1133.838745, 10.976607))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk7", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 233.103103, 1129.363769, 10.686608))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk8", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 237.083068, 1125.641357, 10.506606))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk9", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 247.684814, 1152.292846, 10.876612))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk10", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 244.711456, 1142.905395, 10.536610))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk11", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 261.201599, 1146.604125, 9.896611))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk12", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 260.699554, 1137.599853, 9.486606))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk13", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 262.818328, 1125.940917, 9.226603))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk14", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MENGAMBIL SUSU", 20);
        }
        if(IsPlayerInRangeOfPoint(playerid, 4.0, 315.27, 1154.77, 8.58))
        {
        	return callcmd::olahsusu(playerid, "");
        }
    }
    return 1;
}

function takemilk1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow1", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow1);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk2(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow2", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow2);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk3(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow3", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow3);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk4(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow4", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow4);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk5(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow5", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow5);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk6(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow6", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow6);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk7(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow7", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow7);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk8(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow8", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow8);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk9(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow9", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow9);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk10(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow10", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow10);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk11(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow11", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow11);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk12(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow12", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow12);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk13(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow13", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow13);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

function takemilk14(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			SetTimerEx("spawncow14", 10000, false, "i", playerid);
			ShowNotifInfo(playerid, "Anda telah berhasil mengambil susu.", 10000);
			ShowNotifSukses(playerid, "Taking Succes!", 10000);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow14);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 0, 0, 1, 0, 1); // anim taking meat
			pData[playerid][pActivityTime] += 5;
		}
	}

	return 1;
}

CMD:olahsusu(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 315.27, 1154.77, 8.58))
		{
			if(pData[playerid][pLoading] == true) return ShowNotifError(playerid, "Anda masih olah susu!", 10000);
			if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
			if(pData[playerid][pSusu] < 1) return ErrorMsg(playerid, "Kamu harus mengambil susu terlebih dahulu!");

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			TogglePlayerControllable(playerid, 0);

			Info(playerid, "Kamu sedang mengolah susu!");
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);

			pData[playerid][pLoading] = true;

			pData[playerid][pMilkJob] = SetTimerEx("olahsusu", 1000, true, "i", playerid);
			//Showbar(playerid, 20, "OLAH SUSU", "olahsusu");
			ShowProgressbar(playerid, "OLAH SUSU", 20);
		}
		else return ShowNotifError(playerid, "Kamu tidak berada ditempat pemeras susu", 5000);
	}
	else return ShowNotifError(playerid, "Kamu bukan pekerja pemeras susu!", 5000);

	return 1;
}

function olahsusu(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 14 || pData[playerid][pJob2] == 14)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			ShowNotifInfo(playerid, "Anda telah berhasil mengolah susu", 10000);
			ShowNotifSukses(playerid, "Olah Milk Succes!", 10000);
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pLoading] = false;
			ShowItemBox(playerid, "Susu", "Removed_1x", 19570, 3);
			ShowItemBox(playerid, "Susu_Olahan", "Received_1x", 19569, 3);
			ClearAnimations(playerid);
			pData[playerid][pSusu] --;
			pData[playerid][pSusuolah]++;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
		}
	}
	return 1;
}
