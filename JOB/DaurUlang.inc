function anim1(playerid)
{
    SetPlayerAttachedObject(playerid, 9, 2912, 5, 0.056, 0.039, -0.015, -18.100, -108.600, 93.000, 1,1,1);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	return 1;
}


CMD:ambilbox(playerid, params[])
{
    if(pData[playerid][pJob] != 26) return 1;
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
	if(pData[playerid][pDutyBox] == 0) return ErrorMsg(playerid, "Anda belum Mulai Pekerjaan!");
	if(pData[playerid][pBox] > 50) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 50 Box");
	if(pData[playerid][pDapatBox] > 1) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 1 Box");
	ShowProgressbar(playerid, "Mengambil..", 5);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("anim1", 5000, false, "d", playerid);
	pData[playerid][pHunger] -= 2;
	pData[playerid][pDapatBox] += 1;
	return 1;
}

CMD:penyortiran(playerid, params[])
{
    if(pData[playerid][pJob] != 26) return 1;
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
	if(pData[playerid][pDutyBox] == 0) return ErrorMsg(playerid, "Anda belum Mulai Pekerjaan!");
	if(pData[playerid][pBox] > 80) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 80Box");
	if(pData[playerid][pDapatBox] < 1)
		return InfoMsg(playerid, "Anda tidak memiliki Box");
	if(pData[playerid][pDapatBox] < 1)
		return InfoMsg(playerid, "Anda tidak memiliki Box.");
	ShowProgressbar(playerid, "MENYORTIR..", 5);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	pData[playerid][pHunger] -= 2;
	pData[playerid][pBox] += 1;
	pData[playerid][pDapatBox] -= 1;
	new str[500];
	format(str, sizeof(str), "Received_%dx", 1);
	ShowItemBox(playerid, "box", str, 1271, 4);
	RemovePlayerAttachedObject(playerid, 9);
	return 1;
}

CMD:Daurulang(playerid, params[])
{
	if(pData[playerid][pBox] < 1)
		return InfoMsg(playerid, "Anda tidak memiliki Box.");
	SetTimerEx("daurulang1", 4000, false, "d", playerid);
 	ShowProgressbar(playerid, "Daur Ulang..", 4);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
    Inventory_Update(playerid);
	return 1;
}

function daurulang1(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 26)
	{
		new rand = RandomEx(1,3);
	    if(rand == 1)
	    {
	        pData[playerid][pBotol] += 1;
		  	pData[playerid][pBox] -= 1;
			ShowItemBox(playerid, "Botol", "ADD_1x", 1486, 2);
			SuccesMsg(playerid, "Anda mendapatkan 1botol");
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 2)
		{
		    pData[playerid][pKaret] += 5;
		  	pData[playerid][pBox] -= 1;
			ShowItemBox(playerid, "karet", "Received_5x", 1316, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 4)
		{
		    pData[playerid][pBesi] += 5;
		  	pData[playerid][pBox] -= 1;
			ShowItemBox(playerid, "Besi", "Received_5x", 1510, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
	}
	return 1;
}	
	

CMD:mulaikerjabox1(playerid, params[])
{
	if(pData[playerid][pJob] != 26) return 1;
	new string[1000];
    format(string, sizeof(string), "Pekerjaan\nMulai pekerjaan\nSelesaikan Pekerjaan");
	ShowPlayerDialog(playerid, DIALOG_MULAIBOX, DIALOG_STYLE_TABLIST_HEADERS, ""PINK_E"{15D4ED}ValriseReality {ffffff}Roleplay  "WHITE_E"- Recycler Rise job", string, "Pilih", "Batal");
	return 1;
}

CMD:jualkaret1(playerid, params[])
{
	if(pData[playerid][pVip] > 0)
	{
	    new total = pData[playerid][pKaret];
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pKaret] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki karet");
	    ShowProgressbar(playerid, "Menjual Karet..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pKaret] * 120;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pKaret] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Karet", str, 1316, 4);
	    Inventory_Update(playerid);
    }
    else
    {
        new total = pData[playerid][pKaret];
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pKaret] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki karet");
	    ShowProgressbar(playerid, "Menjual Karet..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pKaret] * 60;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pKaret] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Karet", str, 1316, 4);
	    Inventory_Update(playerid);
    }
	return 1;
}

CMD:jualbotol(playerid, params[])
{
	if(pData[playerid][pVip] > 0)
	{
	    new total = pData[playerid][pBotol];
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pBotol] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki botol");
	    ShowProgressbar(playerid, "Menjual botol..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pBotol] * 40;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pBotol] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "botol", str, 1316, 4);
	    Inventory_Update(playerid);
    }
    else
    {
        new total = pData[playerid][pBotol];
	    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	    if( pData[playerid][pBotol] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki botol");
	    ShowProgressbar(playerid, "Menjual botol..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pBotol] * 30;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pBotol] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "botol", str, 1316, 4);
	    Inventory_Update(playerid);
    }
	return 1;
}

