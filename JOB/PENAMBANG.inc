function nambang1(playerid)
{
	new dapetbatu = RandomEx(2,6);
    pData[playerid][pBatu] += dapetbatu;
    new str[500];
	format(str, sizeof(str), "Received_%dx", dapetbatu);
	ShowItemBox(playerid, "Batu", str, 905, 4);
	return 1;
}
CMD:nambangdentotz1(playerid, params[])
{
	if(pData[playerid][pJob] == 20 || pData[playerid][pJob2] == 20)
	{
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
		if(pData[playerid][pBatu] > 250) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 250 Batu");
		ShowProgressbar(playerid, "Menambang..", 5);
		ApplyAnimation(playerid,"GRENADE","WEAPON_throw",4.0, 1, 0, 0, 0, 0, 1);
		SetPlayerAttachedObject(playerid, 3, 18635, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		SetTimerEx("nambang1", 5000, false, "d", playerid);
		pData[playerid][pHunger] -= 2;
	}
	return 1;
}
enum E_PENAMBANG
{
    STREAMER_TAG_MAP_ICON:LockerMap,
    STREAMER_TAG_MAP_ICON:NambangMap,
    STREAMER_TAG_MAP_ICON:CuciMap,
    STREAMER_TAG_MAP_ICON:PeleburanMap,
    STREAMER_TAG_MAP_ICON:PenjualanMap,
	STREAMER_TAG_CP:LockerTambang,
	STREAMER_TAG_CP:TakeCarTambang,
	STREAMER_TAG_CP:Nambang,
	STREAMER_TAG_CP:Nambang2,
	STREAMER_TAG_CP:Nambang3,
	STREAMER_TAG_CP:Nambang4,
	STREAMER_TAG_CP:Nambang5,
	STREAMER_TAG_CP:Nambang6,
	STREAMER_TAG_CP:CuciBatu,
	STREAMER_TAG_CP:Peleburan,
	STREAMER_TAG_CP:Penjualan,
}
new PenambangArea[MAX_PLAYERS][E_PENAMBANG];

DeletePenambangCP(playerid)
{
	if(IsValidDynamicCP(PenambangArea[playerid][LockerTambang]))
	{
		DestroyDynamicCP(PenambangArea[playerid][LockerTambang]);
		PenambangArea[playerid][LockerTambang] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang]);
		PenambangArea[playerid][Nambang] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang2]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang2]);
		PenambangArea[playerid][Nambang2] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang3]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang3]);
		PenambangArea[playerid][Nambang3] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang4]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang4]);
		PenambangArea[playerid][Nambang4] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang5]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang5]);
		PenambangArea[playerid][Nambang5] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang6]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang6]);
		PenambangArea[playerid][Nambang6] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][CuciBatu]))
	{
		DestroyDynamicCP(PenambangArea[playerid][CuciBatu]);
		PenambangArea[playerid][CuciBatu] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Peleburan]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Peleburan]);
		PenambangArea[playerid][Peleburan] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(PenambangArea[playerid][LockerMap]))
	{
		DestroyDynamicMapIcon(PenambangArea[playerid][LockerMap]);
		PenambangArea[playerid][LockerMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PenambangArea[playerid][NambangMap]))
	{
		DestroyDynamicMapIcon(PenambangArea[playerid][NambangMap]);
		PenambangArea[playerid][NambangMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PenambangArea[playerid][CuciMap]))
	{
		DestroyDynamicMapIcon(PenambangArea[playerid][CuciMap]);
		PenambangArea[playerid][CuciMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PenambangArea[playerid][PeleburanMap]))
	{
		DestroyDynamicMapIcon(PenambangArea[playerid][PeleburanMap]);
		PenambangArea[playerid][PeleburanMap] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshJobTambang(playerid)
{
	DeletePenambangCP(playerid);

	if(pData[playerid][pJob] == 20 || pData[playerid][pJob2] == 20)
	{
		PenambangArea[playerid][Nambang] = CreateDynamicCP(698.8157,881.3616,-38.2358, 1.0, -1, -1, playerid, 5.0);
		PenambangArea[playerid][Nambang2] = CreateDynamicCP(700.6220,888.0744,-36.8952, 1.0, -1, -1, playerid, 5.0);
		PenambangArea[playerid][Nambang3] = CreateDynamicCP(701.1542,897.5233,-36.8892, 1.0, -1, -1, playerid, 5.0);
		PenambangArea[playerid][Nambang4] = CreateDynamicCP(698.3236,904.3176,-37.7373, 1.0, -1, -1, playerid, 5.0);
		PenambangArea[playerid][Nambang5] = CreateDynamicCP(693.0031,911.1717,-38.0931, 1.0, -1, -1, playerid, 5.0);
		PenambangArea[playerid][Nambang6] = CreateDynamicCP(689.9236,917.0135,-38.6226, 1.0, -1, -1, playerid, 5.0);
		PenambangArea[playerid][CuciBatu] = CreateDynamicCP(-796.5180,-1927.7703,6.0931, 2.0, -1, -1, playerid, 30.0);
        PenambangArea[playerid][Peleburan] = CreateDynamicCP(2152.539062,-2263.646972,13.300081, 2.0, -1, -1, playerid, 30.0);
		PenambangArea[playerid][NambangMap] = CreateDynamicMapIcon(693.7296,909.6602,-38.5426, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		PenambangArea[playerid][CuciMap] = CreateDynamicMapIcon(-795.9457,-1928.1815,5.7338, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		PenambangArea[playerid][PeleburanMap] = CreateDynamicMapIcon(2152.539062,-2263.646972,13.300081, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
	}
	return 1;
}

CMD:cucibatudentotz(playerid, params[])
{
    if(pData[playerid][pJob] == 20 || pData[playerid][pJob2] == 20)
    {
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if(pData[playerid][pBatuCucian] > 500) return ErrorMsg(playerid, "Anda tidak dapat membawa 500 batu cucian!");
	    if(pData[playerid][pBatu] < 5) return ErrorMsg(playerid, "Anda Tidak Memiliki 5 Batu");
		pData[playerid][pBatu] -= 5;
		pData[playerid][pBatuCucian] += 5;
		RemovePlayerAttachedObject(playerid, 3);
		ShowItemBox(playerid, "Batu_Cucian", "Received_5x", 2936, 2);
		ShowItemBox(playerid, "Batu", "Removed_5x", 905, 2);
		ShowProgressbar(playerid, "Mencuci Batu..", 3);
	    Inventory_Update(playerid);
	    ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	}
	return 1;
}

CMD:peleburanbatudentotz(playerid, params[])
{
    if(pData[playerid][pJob] == 20 || pData[playerid][pJob2] == 20)
    {
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if(pData[playerid][pBatuCucian] < 5) return ErrorMsg(playerid, "Anda Tidak Memiliki 5 Batu Cucian");
	 	SetTimerEx("leburkanbatuan", 4000, false, "d", playerid);
	 	ShowProgressbar(playerid, "Meleburkan Batuan..", 4);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	    Inventory_Update(playerid);
   	}
	return 1;
}

function leburkanbatuan(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 20 || pData[playerid][pJob2] == 20)
	{
		new rand = RandomEx(1,5);
	    if(rand == 1)
	    {
	        pData[playerid][pEmas] += 3;
		  	pData[playerid][pBatuCucian] -= 5;
			ShowItemBox(playerid, "Emas", "Received_3x", 19941, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_5x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 2)
		{
		    pData[playerid][pBesi] += 5;
		  	pData[playerid][pBatuCucian] -= 5;
			ShowItemBox(playerid, "Besi", "Received_5x", 1510, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_5x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 3)
		{
		    pData[playerid][pAluminium] += 5;
		  	pData[playerid][pBatuCucian] -= 5;
			ShowItemBox(playerid, "Aluminium", "Received_5x", 19809, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_5x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 4)
		{
		    pData[playerid][pBesi] += 5;
		  	pData[playerid][pBatuCucian] -= 5;
			ShowItemBox(playerid, "Besi", "Received_5x", 1510, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_5x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 5)
		{
		    pData[playerid][pBerlian] += 1;
		  	pData[playerid][pBatuCucian] -= 5;
			ShowItemBox(playerid, "Berlian", "Received_1x", 19941, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_5x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
	}
	return 1;
}

CMD:jualemasdentotz(playerid, params[])
{
	if(pData[playerid][pVip] > 0)
	{
	    new total = pData[playerid][pEmas];
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pEmas] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Emas");
	    ShowProgressbar(playerid, "Menjual Emas..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pEmas] * 50;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pEmas] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Emas", str, 19941, 4);
	    Inventory_Update(playerid);
    }
    else
    {
        new total = pData[playerid][pEmas];
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pEmas] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Emas");
	    ShowProgressbar(playerid, "Menjual Emas..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pEmas] * 30;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pEmas] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Emas", str, 19941, 4);
	    Inventory_Update(playerid);
    }
	return 1;
}
CMD:jualtembagadentotz(playerid, params[])
{
    if(pData[playerid][pVip] > 0)
	{
	    new total = pData[playerid][pAluminium];
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pAluminium] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Tembaga");
	    ShowProgressbar(playerid, "Menjual Tembaga..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pAluminium] * 40;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pAluminium] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Tembaga", str, 19809, 4);
	    Inventory_Update(playerid);
	}
	else
	{
	    new total = pData[playerid][pAluminium];
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pAluminium] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Tembaga");
	    ShowProgressbar(playerid, "Menjual Tembaga..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pAluminium] * 20;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pAluminium] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Tembaga", str, 19809, 4);
	    Inventory_Update(playerid);
	}
	return 1;
}
CMD:jualbesidentotz(playerid, params[])
{
    if(pData[playerid][pVip] > 0)
	{
	    new total = pData[playerid][pBesi];
	    if(pData[playerid][pJob] != 20) return 1;
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pBesi] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Besi");
	    ShowProgressbar(playerid, "Menjual Besi..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pBesi] * 20;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pBesi] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Besi", str, 1510, 4);
	    Inventory_Update(playerid);
	}
	else
	{
	    new total = pData[playerid][pBesi];
	    if(pData[playerid][pJob] != 20) return 1;
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pBesi] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Besi");
	    ShowProgressbar(playerid, "Menjual Besi..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pBesi] * 10;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pBesi] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Besi", str, 1510, 4);
	    Inventory_Update(playerid);
	}
	return 1;
}

CMD:jualberliandentotz(playerid, params[])
{
    new total = pData[playerid][pBerlian];
    if(pData[playerid][pJob] != 20) return 1;
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if( pData[playerid][pBerlian] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Berlian");
    ShowProgressbar(playerid, "Menjual Berlian", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pBerlian] * 280;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pBerlian] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 4);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Berlian", str, 19941, 4);
    Inventory_Update(playerid);
	return 1;
}

function TungguNambang1(playerid)
{
	pData[playerid][pTimeTambang1] = 0;
	return 1;
}
function TungguNambang2(playerid)
{
	pData[playerid][pTimeTambang2] = 0;
	return 1;
}
function TungguNambang3(playerid)
{
	pData[playerid][pTimeTambang3] = 0;
	return 1;
}
function TungguNambang4(playerid)
{
	pData[playerid][pTimeTambang4] = 0;
	return 1;
}
function TungguNambang5(playerid)
{
	pData[playerid][pTimeTambang5] = 0;
	return 1;
}
function TungguNambang6(playerid)
{
	pData[playerid][pTimeTambang6] = 0;
	return 1;
}
