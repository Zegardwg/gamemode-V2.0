CMD:robinvite(playerid, params[])
{
	if(pData[playerid][pRobbing] != 0)
		return Error(playerid, "Kamu baru baru ini sudah melakukan perampokan, tunggu 1 hari untuk melakukannya kembali.");

	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/robinvite [playerid/PartOwName]");

    if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");

	if(!NearPlayer(playerid, otherid, 5.0))
	    return Error(playerid, "You must be near this player.");

	if(pData[playerid][pLevel] < 7)
		return Error(playerid, "Kamu harus level 7 untuk menginvite orang untuk robbing");

	if(pData[playerid][pFaction] != 0)
		return Error(playerid, "Anggota faction tidak bisa melakukan ini");

	if(pData[otherid][pFaction] != 0)
		return Error(playerid, "Kamu tidak bisa menginvite anggota faction");

	if(pData[otherid][pRobbing] != 0)
		return Error(playerid, "Orang tersebut baru baru ini sudah melakukan perampokan.");

	if(pData[otherid][pRobLeader] != -1)
		return Error(playerid, "Player tersebut sudah menjadi pemimpin di kelompok lain");

	if(pData[playerid][pMemberRob] != -1)
		return Error(playerid, "Kamu sudah bergabung kedalam kelompok lain");

	if(pData[playerid][pRobMember] >= 5)
		return Error(playerid, "kamu sudah menginvite 5 orang");

	pData[otherid][pRobOffer] = playerid;
	Servers(playerid, "Anda telah menginvite %s untuk menjadi anggota robbing.", pData[otherid][pName]);
	Servers(otherid, "%s telah menginvite anda untuk menjadi anggota robbing. Type: /accept rob", pData[playerid][pName]);
	return 1;
}

CMD:robbank(playerid, params[])
{
	if(pData[playerid][pLevel] < 7)
		return Error(playerid, "Kamu harus level 7 untuk melakukan robbank");

	if(pData[playerid][pFaction] != 0)
		return Error(playerid, "Anggota faction tidak bisa melakukan robbank");

	if(RobBankProgress[playerid] == 1)
		return Error(playerid, "Kamu sudah memulai robbank");

	if(pData[playerid][pRobMember] < 4)
		return Error(playerid, "Kamu harus menginvite 4 orang untuk melakukan ini");

	if(RobBankStatus > 2)
		return Error(playerid, "Bank belum lama ini bank baru saja di rob, anda harus menunggu beberapa hari lagi");

	new count;
	foreach(new i : Player)
	{
		if(pData[i][pFaction] == 1 && pData[i][pOnDuty])
		{
			count++;
		}
	}
	if(count < 3)
		return Error(playerid, "Harus ada 3 police yang on duty di kota");

	RobBankProgress[playerid] = 1;
	Info(playerid, "Ikuti checkpoint untuk pergi menuju Bank of Los Santos");
	SetPlayerCheckpoint(playerid, 1458.35, -1024.54, 23.82, 3.5);
	return 1;
}

CMD:placebomb(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, -990.65, 1468.51, 1332.02))
		return Error(playerid, "Kamu harus berada di pintu brankas bank!");

	if(pData[playerid][pActivityTime] > 5)
		return Error(playerid, "Kamu masih memiliki activity progress");

	if(pData[playerid][pBomb] == 0)
		return Error(playerid, "Kamu tidak memiliki bomb tempel");

	if(RobBankStatus > 1)
		return Error(playerid, "Brangkas bank sudah terbuka");

	if(RobBankObject[2] != 0)
		return Error(playerid, "sudah ada yang memasang bomb");

	if(RobBankStatus < 1)
		return Error(playerid, "Kamu belum melakukan tahap progres robbank");

	TogglePlayerControllable(playerid, 0);
	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
	SendNearbyMessage(playerid, 3.0, COLOR_PURPLE, "** %s memasang bom tempel pada pintu brankas bank", ReturnName(playerid));
	RobBankBar[playerid] = SetTimerEx("PlacedBoomVault", 1000, true, "id", playerid);
	PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Placed Bomb..");
	PlayerTextDrawShow(playerid, ActiveTD[playerid]);
	ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	return 1;
}

CMD:robvault(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, -984.89, 1468.56, 1332.02))
		return Error(playerid, "Kamu harus berada di dekat vault bank");

	if(RobBankProgress[playerid] == 7)
	{
		pData[playerid][pRobLeader] = 0;
		Error(playerid, "Kamu sudah tidak bisa lagi mengambil uang dari dalam brankas");
		return 1;
	}

	if(pData[playerid][pRobLeader] < 1)
		return Error(playerid, "Hanya pemimpin rob yang bisa mengambil uang di brangkas");

	if(RobBankStatus < 2)
		return Error(playerid, "Pintu brankas bank belum terbuka");

	if(pData[playerid][pActivityTime] > 5)
		return Error(playerid, "Kamu masih memiliki activity progress");

	TogglePlayerControllable(playerid, 0);
	ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,1,0,0,1,0,1);
	SendNearbyMessage(playerid, 3.0, COLOR_PURPLE, "** %s mengambil uang dari dalam brankas", ReturnName(playerid));
	RobBankBar[playerid] = SetTimerEx("RobVault", 1000, true, "id", playerid);
	PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loaded Money..");
	PlayerTextDrawShow(playerid, ActiveTD[playerid]);
	ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	return 1;
}

CMD:resetrobbank(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return Error(playerid, "Only admin level 5 or 6");

	if(IsValidDynamicObject(RobBankObject[1]))
		DestroyDynamicObject(RobBankObject[1]);

	if(IsValidDynamicObject(RobBankObject[2]))
		DestroyDynamicObject(RobBankObject[2]);

	if(IsValidDynamic3DTextLabel(RobBankText[1]))
		DestroyDynamic3DTextLabel(RobBankText[1]);

	RobBankObject[1] = CreateDynamicObject(2634, -990.080994, 1468.404053, 1332.555054, 0.000000, 0.000000, 90.000000);
	RobBankObject[2] = 0;
	RobBankStatus = 0;
	SendStaffMessage(COLOR_RED, "%s telah mereset value pada robbank system", pData[playerid][pAdminname]);

	foreach(new i : Player)
	{
		{
			if(pData[i][pRobMember] > 0)
			{
				pData[i][pRobMember] = 0;
			}
		}
	}
	return 1;
}

CMD:fullrobbank(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return Error(playerid, "Only admin level 5 or 6");

	RobBankProgress[playerid] = 1;
	pData[playerid][pRobMember] = 5;
	pData[playerid][pMemberRob] = 1;
	pData[playerid][pRobLeader] = 1;
	RobBankStatus = 0;
	Info(playerid, "Value Robbank Full");
	return 1;
}

function PlacedBoomVault(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(RobBankBar[playerid])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, -990.65, 1468.51, 1332.02))
			{
				TogglePlayerControllable(playerid, 1);
				RobBankObject[2] = CreateObject(1654, -990.23676, 1468.92651, 1332.40747, 0.00000, 0.00000, -97.38002);
				RobBankProgress[playerid] = 2;
				pData[playerid][pBomb] -= 1;
				InfoTD_MSG(playerid, 5000, "Placed Bomb Succes!");
				Info(playerid, "Bomb akan meledak dalam 15 detik, pergi menjauh!");
				SetTimerEx("BombMeledak", 15000, false, "i", playerid);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
				KillTimer(RobBankBar[playerid]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pEnergy] -= 3;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			}
			else
			{
				KillTimer(RobBankBar[playerid]);
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, -990.65, 1468.51, 1332.02))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
			}
		}
	}
	return 1;
}

function BombMeledak(playerid)
{
	if(RobBankStatus == 1)
	{
		new Float:x, Float:y, Float:z;
		GetObjectPos(RobBankObject[2], x, y, z);
		CreateExplosion(x, y, z, 11, 3.5);

		DestroyDynamicObject(RobBankObject[2]);

		if(IsValidDynamicObject(RobBankObject[1]))
			DestroyDynamicObject(RobBankObject[1]);

		if(IsValidDynamic3DTextLabel(RobBankText[1]))
			DestroyDynamic3DTextLabel(RobBankText[1]);

		RobBankStatus = 2;
		SendClientMessageToAll(COLOR_RED, "[BREAKING NEWS]"YELLOW_E" telah terjadi perampokan di Bank of Los Santos!");
	}
	return 1;
}

function RobVault(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(RobBankBar[playerid])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.5, -984.89, 1468.56, 1332.02))
			{
				TogglePlayerControllable(playerid, 1);
				RobBankProgress[playerid] += 1;
				Server_AddMoney(-100000);
				InfoTD_MSG(playerid, 5000, "Get Money $100.000");
				Info(playerid, "Kamu berhasil mendapatkan "GREEN_LIGHT"$100.000{ffffff} dari brankas, ambil lagi!");
				GivePlayerMoneyEx(playerid, 100000);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
				KillTimer(RobBankBar[playerid]);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pEnergy] -= 3;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			}
			else
			{
				KillTimer(RobBankBar[playerid]);
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.5, -984.89, 1468.56, 1332.02))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
			}
		}
	}
	return 1;
}


/*

---------------[DELETE OBJECT 2634 IN BANK MAPPING PAWNOINFO.RU]------------------


----------[TARUH DI NATIVE]--------
pData[playerid][pRobOffer] = -1;



-------------[PLAYER ACCEPT ROB]
		else if(strcmp(params,"rob",true) == 0)
		{
			new offerid = pData[playerid][pRobOffer];
			if(offerid == -1)
				return Error(playerid, "Belum ada yang mengivnite mu untuk melakukan robbing");

			if(!IsPlayerConnected(offerid))
				return Error(playerid, "Player tersebut belum masuk!");

			if(!NearPlayer(playerid, offerid, 5.0))
				return Error(playerid, "Kamu harus didekat Player yang menginvite mu.");

			Servers(playerid, "Anda telah berhasil menaccept tawaran bergabung kedalam Robbery %s.", ReturnName(pData[playerid][pRobOffer]));
			Servers(offerid, "%s Menerima ajakan Robbing anda.", ReturnName(playerid));
			pData[playerid][pMemberRob] = 1;
			pData[offerid][pRobLeader] = 1;
			pData[offerid][pRobMember] += 1;
			pData[playerid][pRobOffer] = -1;
		}


---------------[TARUH DIATAS ENUM PLAYER]---------

//ROB BANK

new RobBankObject[5],
	Text3D: RobBankText[5],
	RobBankStatus,
	RobBankProgress[MAX_PLAYERS],
	RobBankBar[MAX_PLAYERS];



-------------[TARUH DI IN GAME MODE INIT]

RobBankObject[1] = CreateDynamicObject(2634, -990.080994, 1468.404053, 1332.555054, 0.000000, 0.000000, 90.000000);







---------[ON PLAYER ENTER CHEHCKPOINT]------------



    if(RobBankProgress[playerid] == 1)
    {
    	if(playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_DRIVER)
    	{
    		if(IsPlayerInRangeOfPoint(playerid, 3.5, -1495.13, 920.22, 7.23))
    		{
    			RobBankStatus = 1;
    			RobBankText[1] = CreateDynamic3DTextLabel(""YELLOW_E"[ROBBANK]\n"WHITE_E"/placebomb", COLOR_YELLOW, -990.65, 1468.51, 1332.02, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Placed Bomb
    			DisablePlayerCheckpoint(playerid);
    			Info(playerid, "Kamu sudah sampai didepan Bank of Index, lanjutkan dengan pergi kedalam inside bank");
    		}
    	}
    }
    if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //TAKE GAS
    {
    	if(playerState == PLAYER_STATE_DRIVER)
    	{
    		if(HaulingType[playerid] == 1)
    		{
			    if(IsPlayerInRangeOfPoint(playerid, 7.0, -1017.83 , -686.28, 32.00))
			    {
			    	new randgas = Iter_Random(GStation);
			    	AttachTrailerToVehicle(VehHauling[playerid], GetPlayerVehicleID(playerid));
			    	DisablePlayerCheckpoint(playerid);
			    	SetPVarInt(playerid, "RandGAS", randgas);
			    	SetPlayerCheckpoint(playerid, gsData[randgas][gsPosX], gsData[randgas][gsPosY], gsData[randgas][gsPosZ], 4.5);
			    	Info(playerid, "Sukses terpasang! jika kamu tidak membawa trailer sampai tujuan, mission akan gagal");
			    }
		    }
	    }
	}

*/