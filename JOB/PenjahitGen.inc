#include <YSI\y_hooks>
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if (newkeys & KEY_WALK) 
    {
        if (AreaPembuatanBenang(playerid) >= 0) 
        {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 23) return Error(playerid, "Kamu bukan seorang Penjahit.");
            if(pData[playerid][pBulu] < 1) return ErrorMsg(playerid, "Anda tidak memiliki Bulu!");
            if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");

            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 1, 1, 1, 0, 1);
            ShowProgressbar(playerid, "Membuat Benang", 4);
            SetTimerEx("membuatbenang", 4000, false, "d", playerid);
            //StartPlayerLoadingBar(playerid, 500, "Membuat Benang", 10, "membuatbenang", COLOR_GREEN);
        }
    }
    if (newkeys & KEY_WALK) {
        if (AreaPembuatanKain(playerid) >= 0) {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 23) return Error(playerid, "Kamu bukan seorang Penjahit.");
            if(pData[playerid][pBenang] < 1) return ErrorMsg(playerid, "Anda tidak memiliki Benang!");
            if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");

            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 1, 1, 1, 0, 1);
            ShowProgressbar(playerid, "Membuat Kain", 4);
            SetTimerEx("membuatkain", 4000, false, "d", playerid);
            //StartPlayerLoadingBar(playerid, 500, "Membuat Kain", 10, "membuatkain", COLOR_GREEN);
        }
    }
    if (newkeys & KEY_WALK) {
        if (AreaPembuatanPakaian(playerid) >= 0) {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 23) return Error(playerid, "Kamu bukan seorang Penjahit.");
            if(pData[playerid][pKain] < 2) return ErrorMsg(playerid, "Anda tidak memiliki Kain (Min:2)!");
            if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");

            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 1, 1, 1, 0, 1);
            ShowProgressbar(playerid, "Membuat Pakaian", 4);
            SetTimerEx("membuatpakaian", 4000, false, "d", playerid);
            //StartPlayerLoadingBar(playerid, 500, "Membuat Pakaian", 10, "membuatpakaian", COLOR_GREEN);
        }
    }
    return 1;
}

AreaPembuatanBenang(playerid)
{
	for(new i = 0; i < 3; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 1761.4487, -1763.1624, 15.0254))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 1756.2449, -1763.2015, 15.0254))
	    {
	        return i;
	    }
	}
	return -1;
}

AreaPembuatanKain(playerid)
{
	for(new i = 0; i < 4; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 1776.4194, -1767.3145, 15.0254))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 1766.7698, -1767.3145, 15.0254))
	    {
	        return i;
	    }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 1757.9785, -1767.3145, 15.025))
	    {
	        return i;
	    }
	}
	return -1;
}

AreaPembuatanPakaian(playerid)
{
	for(new i = 0; i < 4; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 1776.3232, -1776.6011, 15.0254))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 1766.6154, -1776.6011, 15.0254))
	    {
	        return i;
	    }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 1757.6498, -1776.6011, 15.0254))
	    {
	        return i;
	    }
	}
	return -1;
}

CMD:jualpakaiangen(playerid, params[])
{
    new total = pData[playerid][pPakaian];
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih memiliki activity progress!");
    if(pData[playerid][pPakaian] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Pakaian Yang Akan Dijual");
    ShowProgressbar(playerid, "Menjual Pakaian..", total);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pPakaian] * 65;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pPakaian] -= total;
	new str[500];
	format(str, sizeof(str), "ADD_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, total);
	format(str, sizeof(str), "REMOVED_%dx", total);
	ShowItemBox(playerid, "Pakaian", str, 2399, total);
    Inventory_Update(playerid);
	return 1;
}

function membuatbenang(playerid)
{
	ClearAnimations(playerid);
	pData[playerid][pBenang] += 2;
	pData[playerid][pBulu]--;
	ShowItemBox(playerid, "Benang", "Added_2x", 1901, 2);
    ShowItemBox(playerid, "Bulu", "Removed_1x", 19274, 2);
	return 1;
}

function membuatkain(playerid)
{
	ClearAnimations(playerid);
	pData[playerid][pKain] += 2;
	pData[playerid][pBenang]--;
	ShowItemBox(playerid, "Benang", "Removed_1x", 1901, 2);
	ShowItemBox(playerid, "Kain", "Added_2x", 19873, 3);
	return 1;
}

function membuatpakaian(playerid)
{
	ClearAnimations(playerid);
	pData[playerid][pPakaian] += 1;
	pData[playerid][pKain] -= 2;
	ShowItemBox(playerid, "Kain", "Removed_2x", 19873, 2);
	ShowItemBox(playerid, "Pakaian", "Added_1x", 2705, 3);
	return 1;
}