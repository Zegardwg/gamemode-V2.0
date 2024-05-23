//-------------[ Player Commands ]-------------//
CMD:spspspps(playerid, params[])
{
	if(pData[playerid][pStarterPack] != 0) return ErrorMsg(playerid, "Kamu sudah mengambil starterpack");
	{
		pData[playerid][pStarterPack] += 1;

		pData[playerid][pSnack] += 10;
		pData[playerid][pSprunk] += 10;
		GivePlayerMoneyEx(playerid, 1000);

		ShowItemBox(playerid, "Snack", "Received_10x", 2821, 4);
		ShowItemBox(playerid, "Water", "Received_10x", 2958, 4);
		ShowItemBox(playerid, "Uang", "Received_$1000", 1212, 4);
		ShowNotifSukses(playerid, "Anda Diberi Kompensasi 10 Snack, 10 Water, $1000", 5000);

		/*new cQuery[1024], modelid = 462, color1 = 1, color2 = 0, rental;
		new Float:x,Float:y,Float:z, Float:a;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		rental = gettime() + (1 * 86400);

		mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], modelid, color1, color2, 0, x, y, z, a, rental);
		mysql_tquery(g_SQL, cQuery, "OnVehStarterPack", "ddddddffffd", playerid, pData[playerid][pID], modelid, color1, color2, 0, x, y, z, a, rental);*/
	}
	return 1;
}

CMD:stuck(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    ShowPlayerDialog(playerid, DIALOG_BUG, DIALOG_STYLE_LIST, "FIX ME", "Freeze Bug\nBug VirtualWorld\nBug Interior\nBlueberry Bug\nBug Death", "Pilih", "Tidak");
	}
	return 1;
}

CMD:flist(playerid, params[])
{
	new lstr[1024];
	format(lstr, sizeof(lstr), "Nama Organisasi\tSedang di kota\nSan Andreas Police\t%d\nSan Andreas Goverment\t%d\nSan Andreas Medic\t%d\nSan Andreas News\t%d\nSan Andreas Pedagang\t%d\nSan Andreas Gojek\t%d\nMekanik Kota\t%d", polisidikota, pemerintahdikota, medisdikota, newsdikota, pedagangdikota, gojekdikota, mekanikdikota);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha{ffffff} - Organisasi Online", lstr, "Tutup", "");
	return 1;
}

CMD:mprice(playerid, params[])
{
	new str[3500];
    format(str, sizeof(str), "{FFFF00}==========[Dinas Pekerjaan Kota Valrise]==========\n\n");

    format(str, sizeof(str), "%s"WHITE_E"-----[Hasil Pertambangan]-----\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Alumunium : "RED_E"$20{acd7ff}/pcs "WHITE_E"=> "LG_E"$40{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Besi : "RED_E"$10{acd7ff}/pcs "WHITE_E"=> "LG_E"$20{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Emas : "RED_E"$30{acd7ff}/pcs "WHITE_E"=> "LG_E"$40{acd7ff}/pcs\n\n", str);

    format(str, sizeof(str), "%s"WHITE_E"-----[Hasil Memancing]-----\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ikan Tuna : "RED_E"$25{acd7ff}/pcs "WHITE_E"=> "LG_E"$25{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ikan Tongkol : "RED_E"$25{acd7ff}/pcs "WHITE_E"=> "LG_E"$25{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ikan Kakap : "RED_E"$25{acd7ff}/pcs "WHITE_E"=> "LG_E"$25{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ikan Kembung : "RED_E"$25{acd7ff}/pcs "WHITE_E"=> "LG_E"$25{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ikan Makarel : "RED_E"$25{acd7ff}/pcs "WHITE_E"=> "LG_E"$25{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ikan Tenggiri : "RED_E"$25{acd7ff}/pcs "WHITE_E"=> "LG_E"$25{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ikan BlueMarlin : "RED_E"$25{acd7ff}/pcs "WHITE_E"=> "LG_E"$25{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ikan Sail : "RED_E"$25{acd7ff}/pcs "WHITE_E"=> "LG_E"$25{acd7ff}/pcs\n\n", str);

    format(str, sizeof(str), "%s"WHITE_E"-----[Lainnya]-----\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Kayu Kemas : "RED_E"$18{acd7ff}/pcs "WHITE_E"=> "LG_E"$18{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Pakaian : "RED_E"$65{acd7ff}/pcs "WHITE_E"=> "LG_E"$65{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Bulu : "RED_E"$12{acd7ff}/pcs "WHITE_E"=> "LG_E"$12{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Ayam Kemas : "RED_E"$20{acd7ff}/pcs "WHITE_E"=> "LG_E"$40{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Essence : "RED_E"$20{acd7ff}/pcs "WHITE_E"=> "LG_E"$50{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Botol : "RED_E"$30{acd7ff}/pcs "WHITE_E"=> "LG_E"$40{acd7ff}/pcs\n", str);
    format(str, sizeof(str), "%s"WHITE_E"~> Harga Karet : "RED_E"$60{acd7ff}/pcs "WHITE_E"=> "LG_E"$120{acd7ff}/pcs\n", str);
    ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{15D4ED}Konoha{ffffff} - Harga Penjualan", str, "Tutup", "");
	return 1;
}

CMD:belivodka1(playerid, params[])
{
	if(GetPlayerMoney(playerid) < 60) return ErrorMsg(playerid, "Anda butuh $60 untuk membeli Vodka.");
	GivePlayerMoneyEx(playerid, -60);
	pData[playerid][pVodka] += 1;
	ShowItemBox(playerid, "Uang", "Removed_$60", 1212, 2);
	ShowItemBox(playerid, "Vodka", "Received_1x", 19823, 2);
	return 1;
}

CMD:beliciu1(playerid, params[])
{
	if(GetPlayerMoney(playerid) < 15) return ErrorMsg(playerid, "Anda butuh $15 untuk membeli Ciu.");
	GivePlayerMoneyEx(playerid, -15);
	pData[playerid][pCiu] += 1;
	ShowItemBox(playerid, "Uang", "Removed_$15", 1212, 2);
	ShowItemBox(playerid, "Ciu", "Received_1x", 1486, 2);
	return 1;
}

CMD:beliamer1(playerid, params[])
{
	if(GetPlayerMoney(playerid) < 35) return ErrorMsg(playerid, "Anda butuh $15 untuk membeli Ciu.");
	GivePlayerMoneyEx(playerid, -35);
	pData[playerid][pAmer] += 1;
	ShowItemBox(playerid, "Uang", "Removed_$35", 1212, 2);
	ShowItemBox(playerid, "Amer", "Received_1x", 1517, 2);
	return 1;
}

CMD:drinkvodka(playerid, params[])
{
    if(pData[playerid][pVodka] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Vodka!.");
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pVodka]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Vodka", "Removed_1x", 19823, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 19823, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 4;
		pData[playerid][pBladder] -= 20;
    }
    SetTimerEx("HideToysnya", 600, 0, "i", playerid);
    return 1;
}

CMD:drinkciu(playerid, params[])
{
    if(pData[playerid][pCiu] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Ciu!.");
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pCiu]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Ciu", "Removed_1x", 1486, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 1486, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 4;
		pData[playerid][pBladder] -= 10;
    }
    SetTimerEx("HideToysnya", 600, 0, "i", playerid);
    return 1;
}

CMD:drinkamer(playerid, params[])
{
    if(pData[playerid][pAmer] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Ame!.");
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pAmer]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Amer", "Removed_1x", 1517, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 1517, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 4;
		pData[playerid][pBladder] -= 15;
    }
    SetTimerEx("HideToysnya", 600, 0, "i", playerid);
    return 1;
}

function HideToysnya(playerid)
{
	RemovePlayerAttachedObject(playerid, 3);
	return 1;
}

CMD:drinkcappucino(playerid, params[])
{
    if(pData[playerid][pCappucino] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Cappucino!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pCappucino]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Cappucino", "Removed_1x", 19835, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Minum Cappucino..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum Cappucino..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    //SetPlayerAttachedObject(playerid, 3, 19835, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 25;
	    return 1;
    }
}

CMD:drinkstarling(playerid, params[])
{
    if(pData[playerid][pStarling] < 1) return ErrorMsg(playerid,"Anda tidak memiliki starling!.");
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pStarling]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Starling", "Removed_1x", 1455, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum Starling..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum Starling..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    //SetPlayerAttachedObject(playerid, 3, 1455, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 30;
	    return 1;
    }
}

CMD:drinkmilk(playerid, params[])
{
    if(pData[playerid][pMilxMax] < 1) return ErrorMsg(playerid,"Anda tidak memiliki milk!.");
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pMilxMax]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Milk_Max", "Removed_1x", 19570, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum Susu..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum MilxMax..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	   // SetPlayerAttachedObject(playerid, 3, 19570, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 30;
	    return 1;
    }
}

CMD:accent(playerid, params[])
{
	if(pData[playerid][pLevel] < 4) 
		return Error(playerid, "Untuk menggunakan command ini anda harus level 4 ke atas");

	new length = strlen(params), idx, String[256];
	while ((idx < length) && (params[idx] <= ' '))
	{
		idx++;
	}
	new offset = idx;
	new result[16];
	while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
	{
		result[idx - offset] = params[idx];
		idx++;
	}
	result[idx - offset] = EOS;
	if(!strlen(result))
	{
		Usage(playerid, "/accent [name]");
		return 1;
	}
	format(pData[playerid][pAccent2], 80, "%s", result);
	format(String, sizeof(String), "ACCENT: {ffffff}Your character's accent has been set to '{ffff00}%s{ffffff}'", pData[playerid][pAccent2]);
	SendClientMessageEx(playerid,COLOR_ARWIN,String);
	SendClientMessageEx(playerid,COLOR_ARWIN,"NOTE: Jika ingin menghapus accent gunakan command "YELLOW_E"'/offaccent'");
	return 1;
}

CMD:genori(playerid)
{
	new szMiscArray[512];
	szMiscArray = 
	"United States Of America\nSingapore\nIndonesia\nAfganistan\nAlbania\nPakistan\nPhillpines\nRussian\nQatar\nSpanish\nArgentina\nArabic\nAustralia\nBangladesh\nBrazil\nBulgaria\nCanada\nChina\nColombia\nCongo\nDenmark\nItalian\nGermany\nHongKong\nIndia\nIran\nIraq\nJamaica\nJapan\nKorea\nMexico";
	ShowPlayerDialog(playerid, DIALOG_ORIGIN, DIALOG_STYLE_LIST, "{00FFE5}Konoha {ffffff}- Negara Kelahiran", szMiscArray, "Select", "Batal");
	return 1;
}
CMD:offaccent(playerid, params[])
{
	if(pData[playerid][pLevel] ==  1) 
		return Error(playerid, "Untuk menggunakan command ini anda harus level 5 ke atas");
	if(pData[playerid][pLevel] ==  2) 
		return Error(playerid, "Untuk menggunakan command ini anda harus level 5 ke atas");
	if(pData[playerid][pLevel] ==  3) 
		return Error(playerid, "Untuk menggunakan command ini anda harus level 5 ke atas");
	if(pData[playerid][pLevel] ==  4) 
		return Error(playerid, "Untuk menggunakan command ini anda harus level 5 ke atas");
	if(pData[playerid][pTogAccent] == 1)
	{
		SendClientMessageEx(playerid, COLOR_ARWIN, "ACCENT: "WHITE_E"Accent OFF!");
		pData[playerid][pTogAccent] = 0;
	}	
	return 1;
}

CMD:simshow(playerid, params[])
{
	if(pData[playerid][pDriveLic] == 0) return ErrorMsg(playerid, "Anda tidak memiliki SIM!");

	new sext[40], AtmInfo[560];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
   	PlayerTextDrawSetString(playerid, SIMVALRISE[playerid][18], AtmInfo);
	format(AtmInfo,1000,"%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, SIMVALRISE[playerid][29], AtmInfo);
	format(AtmInfo,1000,"%s", sext);
	PlayerTextDrawSetString(playerid, SIMVALRISE[playerid][22], AtmInfo);

	for(new i = 0; i < 30; i++)
	{
		PlayerTextDrawShow(playerid, SIMVALRISE[playerid][i]);
	}
	SetTimerEx("simisimi",9000, false, "d", playerid);
	//Info(playerid, "Gunakan /simhide Untuk menghilangkan Textdraw");
	return 1;
}

CMD:gsim(playerid, params[])
{
	if(pData[playerid][pDriveLic] == 0) return ErrorMsg(playerid, "Anda tidak memiliki SIM!");

	new otherid;
	if(sscanf(params, "u", otherid)) return SyntaxMsg(playerid, "/gsim [playerid/PartOfName]");

	new sext[40], AtmInfo[560];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
   	PlayerTextDrawSetString(otherid, SIMVALRISE[playerid][18], AtmInfo);
	format(AtmInfo,1000,"%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(otherid, SIMVALRISE[playerid][29], AtmInfo);
	format(AtmInfo,1000,"%s", sext);
	PlayerTextDrawSetString(otherid, SIMVALRISE[playerid][22], AtmInfo);

	for(new i = 0; i < 30; i++)
	{
		PlayerTextDrawShow(otherid, SIMVALRISE[playerid][i]);
	}
	SetTimerEx("simisimi",9000, false, "d", otherid);
	return 1;
}

function simisimi(playerid)
{
	for(new i = 0; i < 30; i++)
	{
		PlayerTextDrawHide(playerid, SIMVALRISE[playerid][i]);
	}
	return 1;
}

CMD:simhide(playerid, params[])
{
	for(new i = 0; i < 30; i++)
	{
		PlayerTextDrawHide(playerid, SIMVALRISE[playerid][i]);
	}
	return 1;
}

CMD:givektp(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki KTP!");

	new otherid;
	if(sscanf(params, "u", otherid)) return SyntaxMsg(playerid, "/givektp [playerid/PartOfName]");

	new sext[40], AtmInfo[560];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
   	PlayerTextDrawSetString(otherid, KTPValrise[playerid][10], AtmInfo);
	format(AtmInfo,1000,"%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(otherid, KTPValrise[playerid][15], AtmInfo);
	format(AtmInfo,1000,"%s", sext);
	PlayerTextDrawSetString(otherid, KTPValrise[playerid][17], AtmInfo);
	format(AtmInfo,1000,"%s", pData[playerid][pTinggi]);
	PlayerTextDrawSetString(otherid, KTPValrise[playerid][19], AtmInfo);

	for(new i = 0; i < 28; i++)
	{
		PlayerTextDrawShow(otherid, KTPValrise[playerid][i]);
	}
	SetTimerEx("ktp",9000, false, "d", otherid);
	return 1;
}

CMD:showsks(playerid, params[])
{
	if(pData[playerid][pSKS] == 0) return ErrorMsg(playerid, "Anda tidak memiliki SKS!");

	new sext[40], AtmInfo[560];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
   	PlayerTextDrawSetString(playerid, SKSTD[playerid][23], AtmInfo);
   	format(AtmInfo,1000,"%d", pData[playerid][pPhone]);
	PlayerTextDrawSetString(playerid, SKSTD[playerid][24], AtmInfo);
   	format(AtmInfo,1000,"%s", sext);
	PlayerTextDrawSetString(playerid, SKSTD[playerid][26], AtmInfo);
	format(AtmInfo,1000,"%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, SKSTD[playerid][25], AtmInfo);
	format(AtmInfo,1000,"%s", GetJobName(pData[playerid][pJob]));
	PlayerTextDrawSetString(playerid, SKSTD[playerid][27], AtmInfo);
	format(AtmInfo,1000,"%s Cm", pData[playerid][pTinggi]);
	PlayerTextDrawSetString(playerid, SKSTD[playerid][28], AtmInfo);

	for(new i = 0; i < 34; i++)
	{
		PlayerTextDrawShow(playerid, SKSTD[playerid][i]);
	}
	SetTimerEx("sks",9000, false, "d", playerid);
	return 1;
}

function sks(playerid)
{
	for(new i = 0; i < 34; i++)
	{
		PlayerTextDrawHide(playerid, SKSTD[playerid][i]);
	}
	return 1;
}

CMD:showskck(playerid, params[])
{
	if(pData[playerid][pSKCK] == 0) return ErrorMsg(playerid, "Anda tidak memiliki SKCK!");

	new sext[40], AtmInfo[560];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
   	format(AtmInfo,1000,"Nama : %s", pData[playerid][pName]);
   	PlayerTextDrawSetString(playerid, SKCKTD[playerid][7], AtmInfo);
   	format(AtmInfo,1000,"Jenis Kelamin : %s", sext);
	PlayerTextDrawSetString(playerid, SKCKTD[playerid][8], AtmInfo);
	format(AtmInfo,1000,"Tempat tanggal lahir : LS, %s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, SKCKTD[playerid][9], AtmInfo);
	format(AtmInfo,1000,"Pekerjaan : %s", GetJobName(pData[playerid][pJob]));
	PlayerTextDrawSetString(playerid, SKCKTD[playerid][11], AtmInfo);

	for(new i = 0; i < 27; i++)
	{
		PlayerTextDrawShow(playerid, SKCKTD[playerid][i]);
	}
	SetTimerEx("skck",9000, false, "d", playerid);
	return 1;
}

function skck(playerid)
{
	for(new i = 0; i < 27; i++)
	{
		PlayerTextDrawHide(playerid, SKCKTD[playerid][i]);
	}
	return 1;
}

CMD:showbpjs(playerid, params[])
{
	if(pData[playerid][pBPJS] == 0) return ErrorMsg(playerid, "Anda tidak memiliki BPJS!");

	new AtmInfo[560];
   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
   	PlayerTextDrawSetString(playerid, BPJSTD[playerid][12], AtmInfo);
	format(AtmInfo,1000,"%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, BPJSTD[playerid][15], AtmInfo);

	for(new i = 0; i < 19; i++)
	{
		PlayerTextDrawShow(playerid, BPJSTD[playerid][i]);
	}
	SetTimerEx("bpjs",9000, false, "d", playerid);
	return 1;
}

function bpjs(playerid)
{
	for(new i = 0; i < 19; i++)
	{
		PlayerTextDrawHide(playerid, BPJSTD[playerid][i]);
	}
	return 1;
}

CMD:hidebpjs(playerid, params[])
{
	for(new i = 0; i < 19; i++)
	{
		PlayerTextDrawHide(playerid, BPJSTD[playerid][i]);
	}
	return 1;
}

CMD:ktpshow(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki KTP!");

	new sext[40], AtmInfo[560];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
   	PlayerTextDrawSetString(playerid, KTPValrise[playerid][10], AtmInfo);
	format(AtmInfo,1000,"%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, KTPValrise[playerid][15], AtmInfo);
	format(AtmInfo,1000,"%s", sext);
	PlayerTextDrawSetString(playerid, KTPValrise[playerid][17], AtmInfo);
	format(AtmInfo,1000,"%s", pData[playerid][pTinggi]);
	PlayerTextDrawSetString(playerid, KTPValrise[playerid][19], AtmInfo);

	for(new i = 0; i < 28; i++)
	{
		PlayerTextDrawShow(playerid, KTPValrise[playerid][i]);
	}
	SetTimerEx("ktp",9000, false, "d", playerid);
	//Info(playerid, "Gunakan /ktphide Untuk menghilangkan Textdraw");
	return 1;
}

function ktp(playerid)
{
	for(new i = 0; i < 28; i++)
	{
		PlayerTextDrawHide(playerid, KTPValrise[playerid][i]);
	}
	return 1;
}

CMD:ktphide(playerid, params[])
{
	for(new i = 0; i < 28; i++)
	{
		PlayerTextDrawHide(playerid, KTPValrise[playerid][i]);
	}
	return 1;
}

CMD:cursor(playerid, params[])
{
	SelectTextDraw(playerid, COLOR_BLUE);
	SuccesMsg(playerid, "Menggunakan Fitur Cursor");
	return 1;
}

CMD:setnumber(playerid, params[])
{
	if(pData[playerid][pVip] < 1)
		return Error(playerid, "Hanya player VIP yang bisa mengakses ini");
	
	if(pData[playerid][pVipNumber] >= gettime())
		return Error(playerid, "You must wait %d seconds before change number again.", pData[playerid][pVipNumber] - gettime());

	new number;
	if(sscanf(params, "d", number))
		return Usage(playerid, "/setnumber [number]");

	if(number < 1111 || number > 99999)
		return Error(playerid, "Only 3-6 number!");

	new cQuery[254];
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT phone FROM players WHERE phone = '%d'", number);
	mysql_tquery(g_SQL, cQuery, "VipSetNumber", "dd", playerid, number);
	return 1;
}

CMD:cc( playerid, params[], help) 
{
	for(new j; j < 96; j++ ) 
	{
		SendClientMessage(playerid, COLOR_WHITE, " ");
	}
	return 1;
}

CMD:dice(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, 1118.88, -10.27, 1002.08))
	    return Error(playerid, "You are not in range of the casino.");

	SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s rolls a dice which lands on the number %d.", ReturnName(playerid), random(6) + 1);
	return 1;
}

CMD:flipcoin(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, 1118.88, -10.27, 1002.08))
	    return Error(playerid, "You are not in range of the casino.");
	
	SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s flips a coin which lands on %s.", ReturnName(playerid), (random(2)) ? ("Heads") : ("Tails"));
	return 1;
}

CMD:dicebet(playerid, params[])
{
	new otherid, amount;

	if(!IsPlayerInRangeOfPoint(playerid, 50.0, 1118.88, -10.27, 1002.08))
	    return Error(playerid, "You are not in range of the casino.");

	if(pData[playerid][pLevel] < 3)
	    return Error(playerid, "You need to be at least level 3+ in order to dice bet.");

	if(sscanf(params, "dd", otherid, amount))
	    return Usage(playerid, "/dicebet [playerid] [amount]");

    if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 5.0))
	    return Error(playerid, "The player specified is disconnected or out of range.");

	if(otherid == playerid)
	    return Error(playerid, "You can't use this command on yourself.");

	if(pData[otherid][pLevel] < 3)
	    return Error(playerid, "That player must be at least level 3+ to bet with them.");

	if(amount < 1)
	    return Error(playerid, "The amount can't be below $1.");

	if(pData[playerid][pMoney] < amount)
	    return Error(playerid, "You don't have that much money to bet.");

	if(gettime() - pData[playerid][pLastBet] < 10)
	    return Error(playerid, "You can only use this command every 10 seconds. Please wait %d more seconds.", 10 - (gettime() - pData[playerid][pLastBet]));

	pData[otherid][pDiceOffer] = playerid;
	pData[otherid][pDiceBet] = amount;
	pData[otherid][pDiceRigged] = 0;
	pData[playerid][pLastBet] = gettime();

	Info(otherid, "* %s has initiated a dice bet with you for %s (/accept dicebet).", ReturnName(playerid), FormatMoney(amount));
	Info(playerid, "* You have initiated a dice bet against %s for %s.", ReturnName(otherid), FormatMoney(amount));
	return 1;
}

CMD:joinjob(playerid, params[])
{
	if(pData[playerid][pIDCard] <= 0)
		return Error(playerid, "Anda tidak memiliki ID-Card.");
		
	if(pData[playerid][pVip] > 0)
	{
		if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
		{
			if(pData[playerid][pJob] == 0)
			{
				if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 2165.21, -1673.13, 15.07))
				{
					pData[playerid][pGetJob] = 12;
					Info(playerid, "Anda telah berhasil mendaftarkan job Drug Dealer. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 1366.16, -1274.58, 13.54))
				{
					pData[playerid][pGetJob] = 13;
					Info(playerid, "Anda telah berhasil mendaftarkan job Weapon Dealer. /accept job untuk konfirmasi.");
				}
				else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
			}
			else if(pData[playerid][pJob2] == 0)
			{
				if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 2165.21, -1673.13, 15.07))
				{
					pData[playerid][pGetJob2] = 12;
					Info(playerid, "Anda telah berhasil mendaftarkan job Drug Dealer. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 1366.16, -1274.58, 13.54))
				{
					pData[playerid][pGetJob2] = 13;
					Info(playerid, "Anda telah berhasil mendaftarkan job Weapon Dealer. /accept job untuk konfirmasi.");
				}
				else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
			}
			else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
		}
		else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
	}
	else
	{
		if(pData[playerid][pJob] > 0)
			return Error(playerid, "Anda hanya bisa memiliki 1 pekerjaan!");
		
		if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 2165.21, -1673.13, 15.07))
		{
			pData[playerid][pGetJob] = 12;
			Info(playerid, "Anda telah berhasil mendaftarkan job Drug Dealer. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 1366.16, -1274.58, 13.54))
		{
			pData[playerid][pGetJob] = 13;
			Info(playerid, "Anda telah berhasil mendaftarkan job Weapon Dealer. /accept job untuk konfirmasi.");
		}
		else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	}
	return 1;
}

CMD:vip(playerid, params[])
{
	new text[1024];
	if(pData[playerid][pVip] == 0)
		return Error(playerid, "Hanya player VIP yang bisa mengakses chat ini");

	if(pData[playerid][pTogVip] == 1)
		return Error(playerid, "Kamu harus mengaktifkan VIP Chat telebih dahulu (/togvip)");
	
	if(sscanf(params,"s[1024]", text))
        return Usage(playerid, "/vip(chat) [text]");

    if(strval(text) > 1024)
        return Error(playerid,"Text too long.");

    new name[40];
	if(pData[playerid][pVip] == 1)
	{
		name = "Regular(1)";
	}
	else if(pData[playerid][pVip] == 2)
	{
		name = "Premium(2)";
	}
	else if(pData[playerid][pVip] == 3)
	{
		name = "High(3)";
	}
	else
	{
		name = "None";
	}
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(pData[i][pVip] > 0 && pData[i][pTogVip] == 0)
			{
				SendClientMessageEx(i, COLOR_FAMILY, ""FAMILY_E"[VIP CHAT] %s %s: %s", name, ReturnName(playerid), text);
			}
		}
	}
	return 1;
}

CMD:togvip(playerid, params[])
{
	if(pData[playerid][pVip] == 0)
		return Error(playerid, "Hanya player VIP yang bisa mengakses ini");

	if(pData[playerid][pTogVip] == 0)
	{
		pData[playerid][pTogVip] = 1;
		Info(playerid, "Kamu telah menonaktifkan vip chat");
	}
	else
	{
		pData[playerid][pTogVip] = 0;
		Info(playerid, "Kamu telah mengaktifkan vip chat");
	}
	return 1;
}

CMD:shareloc(playerid, params[])
{
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/shareloc [playerid/PartOfName]");

    if(pData[playerid][pPhone] < 1)
    	return ErrorMsg(playerid, "Anda tidak memiliki Handphone");

    if(pData[otherid][pPhone] < 1)
    	return ErrorMsg(playerid, "Pemain yang dituju tidak memiliki Handphone");

    if(otherid == playerid)
        return ErrorMsg(playerid, "Kamu tidak bisa meminta lokasi kepada anda sendiri.");

    pData[otherid][pLocOffer] = playerid;

    new Float:sX, Float:sY, Float:sZ;
	GetPlayerPos(playerid, sX, sY, sZ);
	SetPlayerCheckpoint(otherid, sX, sY, sZ, 5.0);
	SuccesMsg(playerid, "Berhasil mengirimkan lokasi");
	new lstr[500];
	format(lstr,sizeof(lstr), "Anda telah dikirimkan Lokasi oleh ~y~%s.", pData[playerid][pName]);
	InfoMsg(otherid, lstr);
	return 1;
}

CMD:shakehand(playerid, params[])
{
	new otherid, type;
	if(sscanf(params, "ui", otherid, type))
	    return Usage(playerid, "/shakehand [playerid] [type (1-6)]");

	if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
	    return Error(playerid, "The player specified is disconnected or out of range.");

	if(otherid == playerid)
	    return Error(playerid, "You can't shake your own hand.");

	if(!(1 <= type <= 6))
	    return Error(playerid, "Invalid type. Valid types range from 1 to 6.");

	pData[otherid][pShakeOffer] = playerid;
	pData[otherid][pShakeType] = type;

	Info(otherid, "%s has offered to shake your hand. (/accept handshake)", ReturnName(playerid));
	Info(playerid, "You have sent %s a handshake offer.", ReturnName(otherid));
	return 1;
}

CMD:calculate(playerid, params[])
{
	new option, Float:value1, Float:value2;
	if(pData[playerid][pPhone] == 0) 
		return Error(playerid, "Anda tidak memiliki Ponsel!");

	if(pData[playerid][pUsePhone] == 0) 
		return Error(playerid, "Handphone anda mati nyalakan terlebih dahulu (/togphone)");

	if(sscanf(params, "fcf", value1, option, value2))
	{
	    Usage(playerid, "/calculate [value 1] [option] [value 2]");
	    Usage(playerid, "List of options: (+) Menambah (-) Berkurang (*) Berkembang (/) Membagi");
	    return 1;
	}
	if(option == '/' && value2 == 0)
	{
	    return Error(playerid, "Anda tidak dapat membagi dengan angka nol.");
	}

	if(option == '+') 
	{
	    Info(playerid, "Hasil: %0.0f + %0.0f = %0.0f", value1, value2, value1 + value2);
	} 
	else if(option == '-') 
	{
	    Info(playerid, "* Hasil: %0.0f - %0.0f = %0.0f", value1, value2, value1 - value2);
	} 
	else if(option == '*' || option == 'x') 
	{
		Info(playerid, "* Hasil: %0.0f * %0.0f = %0.0f", value1, value2, value1 * value2);
	}
	else if(option == '/') 
	{
		Info(playerid, "* Hasil: %0.0f / %0.0f = %0.0f", value1, value2, value1 / value2);
	}
	return 1;
}

CMD:help(playerid, params[])
{
	new str[512], info[512];
	format(str, sizeof(str), "Account Commands\nOther Commands\nVehicle Commands\nJobs Commands\nFaction/Family Commands\nAuto RP Commands\nWorkshop Commands\nVending Commands\nBusiness Commands\nDealer Commands\nHouse Commands\nPrivate Farm Commands\nRobbing Commands\nDonate List\nServer Credits\n");
	strcat(info, str);
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Konoha Roleplay Help Menu", info, "Select", "Close");
	return 1;
}

CMD:dcp(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][pSideJob] > 1 || pData[playerid][pCP] > 1)
		return Error(playerid, "Harap selesaikan Pekerjaan mu terlebih dahulu");

	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	Servers(playerid, "Menghapus Checkpoint Sukses");
	return 1;
}

CMD:credits(playerid)
{
	new line1[1200], line2[300], line3[500];
	strcat(line3, ""LB_E"Owner/Developer: "YELLOW_E"Aji/Genzo, Genzo & Aji\n");
	strcat(line3, ""LB_E"Assistant Manager: "YELLOW_E"Bryan\n");
	strcat(line3, ""LB_E"Handle Administrator: "YELLOW_E"Ren\n");
	strcat(line3, ""LB_E"Handle Family: "YELLOW_E"- Konoha TEAM\n");
	strcat(line3, ""LB_E"Mapper: "YELLOW_E"Aji\n");
	format(line2, sizeof(line2), ""LB_E"Server Support: "YELLOW_E"%s & All Konoha Team\n\n\
	"GREEN_E"Terima kasih telah bergabung dengan kami! Copyright © 01/JANUARI/2023 | Konoha Roleplay");
	format(line1, sizeof(line1), "%s%s", line3, line2);
   	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Konoha Roleplay "WHITE_E"Server Credits", line1, "OK", "");
	return 1;
}

CMD:donate(playerid)
{
    new line3[3500];
    strcat(line3, ""RED_E"...:::... "DOOM_"Donate List Konoha Roleplay "RED_E"...:::...\n\n");

	strcat(line3, ""RED_E"..::.. "DOOM_"VIP PLAYER "RED_E"..::..\n\n");
    strcat(line3, ""DOOM_"1. VIP Regular(2 Weeks) >> "RED_E"300 Gold\n");
    strcat(line3, ""DOOM_"2. VIP Premium(2 Weeks) >> "RED_E"400 Gold\n");
    strcat(line3, ""DOOM_"3. VIP Platinum(2 Weeks) >> "RED_E"500 Gold\n\n");

	strcat(line3, ""RED_E"..:::.. "DOOM_"SERVER FEATURE "RED_E"..:::..\n\n");
	strcat(line3, ""DOOM_"1. Private Door >> "RED_E"200 Gold\n");
	strcat(line3, ""DOOM_"2. Private Gate >> "RED_E"150 Gold\n");
	strcat(line3, ""DOOM_"3. Dealer >> "RED_E"(1500 Gold)\n");
	strcat(line3, ""DOOM_"4. Bisnis >> "RED_E"(1000 Gold)\n");
	strcat(line3, ""DOOM_"4. Private Farmer >> "RED_E"(750 Gold)\n");

	strcat(line3, ""DOOM_"5. House >> "RED_E"\n");
	strcat(line3, ""DOOM_"-House Type Low"RED_E"(500 gold)\n");
	strcat(line3, ""DOOM_"-House Type Medium "RED_E"(600 gold)\n");
	strcat(line3, ""DOOM_"-House Type High "RED_E"(750 gold)\n");
	strcat(line3, ""DOOM_"6. Custom Skin PLayer >> "RED_E"(50)\n");
	strcat(line3, ""DOOM_"7. Custom House Interior >> "RED_E"(350)\n\n");
	
	strcat(line3, ""RED_E"..::::.. "DOOM_"SERVER VEHICLE "RED_E"..:::::..\n\n");
    strcat(line3, ""DOOM_"1. VEHICLE IN DEALER >> "RED_E"500 Gold\n");
	strcat(line3, ""DOOM_"2. VEHICLE NON DEALER >> "RED_E"750 Gold\n\n");

    strcat(line3, ""RED_E"..::.. "WHITE_E"CONTACT INFO "RED_E"..::..\n");
    strcat(line3, ""WHITE_E"CONTACT : "RED_E"Hubungi Developer di discord\n\n");

    strcat(line3, ""RED_E"..::.. "WHITE_E"NOTE "RED_E"..::..\n");
    strcat(line3, ""WHITE_E"Note: "RED_E"Pembayaran Via Dana/Gopay/LinkAja/Ovo/ShopeePay/Pulsa Telkomsel!\n\n");
 	strcat(line3, ""WHITE_E"CMD GOLDSHOP: "RED_E"Gunakan CMD /gshop untuk melihat beberapa list yg disediakan!\n\n");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Konoha Roleplay"WHITE_E"DONATE LIST", line3, "Okay", "");
	return 1;
}

CMD:togphone(playerid)
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][pPhone] == 0) 
		return ShowNotifError(playerid, "Kamu tidak memilik phone!", 10000);

	if(pData[playerid][pUsePhone] == 0)
	{
		pData[playerid][pUsePhone] = 1;
		Servers(playerid, "Berhasil menyalakan Handphone");
	}
	else
	{
		pData[playerid][pUsePhone] = 0;
		Servers(playerid, "Berhasil mematikan Handphone");
	}
	return 1;
}

CMD:email(playerid)
{
    if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "Kamu harus login!");

	ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, ""WHITE_E"Set Email", ""WHITE_E"Masukkan Email.\nIni akan digunakan sebagai ganti kata sandi.\n\n"RED_E"* "WHITE_E"Email mu tidak akan termunculkan untuk Publik\n"RED_E"* "WHITE_E"Email hanya berguna untuk verifikasi Password yang terlupakan dan berita lainnya\n\
	"RED_E"* "WHITE_E"Be sure to double-check and enter a valid email address!", "Enter", "Exit");
	return 1;
}

CMD:changepass(playerid)
{
    if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "Kamu harus login sebelum menggantinya!");

	ShowPlayerDialog(playerid, DIALOG_PASSWORD, DIALOG_STYLE_INPUT, ""WHITE_E"Change your password", "Masukkan Password untuk menggantinya!", "Change", "Exit");
	InfoTD_MSG(playerid, 3000, "~g~~h~Masukkan password yang sebelum nya anda pakai!");
	return 1;
}

CMD:savestats(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "Kamu belum login!");
		
	UpdatePlayerData(playerid);
	Servers(playerid, "Statistik Anda sukses disimpan kedalam Database!");
	return 1;
}

CMD:gshop(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new Dstring[512];
	format(Dstring, sizeof(Dstring), "Gold Shop\tPrice\n\
	Instant Change Name\t500 Gold\n");
	format(Dstring, sizeof(Dstring), "%sClear Warning\t500 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 1(14 Days)\t300 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 2(14 Days)\t400 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 3(14 Days)\t500 Gold\n", Dstring);
	ShowPlayerDialog(playerid, DIALOG_GOLDSHOP, DIALOG_STYLE_TABLIST_HEADERS, "Gold Shop", Dstring, "Buy", "Cancel");
	return 1;
}

CMD:gps(playerid, params[])
{
	ShowNotifError(playerid,"Sistem gps sudah di ubah, silahkan cek /phone", 8000);
	return 1;
}

CMD:death(playerid, params[])
{
    if(pData[playerid][pInjured] == 0)
        return Error(playerid, "Kamu belum injured.");
		
	if(pData[playerid][pJail] > 0)
		return Error(playerid, "Kamu tidak bisa menggunakan ini saat diJail!");
		
	if(pData[playerid][pArrest] > 0)
		return Error(playerid, "Kamu tidak bisa melakukan ini saat tertangkap polisi!");

    if((gettime()-GetPVarInt(playerid, "GiveUptime")) < 100)
        return Error(playerid, "Kamu harus menunggu 3 menit untuk kembali kerumah sakit");

    Servers(playerid, "Kamu telah terbangun dari pingsan.");
	pData[playerid][pHospitalTime] = 0;
	pData[playerid][pHospital] = 1;
    return 1;
}

CMD:piss(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

    if(pData[playerid][pInjured] == 1)
        return Error(playerid, "Kamu tidak bisa melakukan ini disaat yang tidak tepat!");
        
	new time = (100 - pData[playerid][pBladder]) * (300);
    SetTimerEx("UnfreezePee", time, 0, "i", playerid);
    SetPlayerSpecialAction(playerid, 68);
    return 1;
}

CMD:health(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new hstring[512], info[512];
	new hh = pData[playerid][pHead];
	new hp = pData[playerid][pPerut];
	new htk = pData[playerid][pRHand];
	new htka = pData[playerid][pLHand];
	new hkk = pData[playerid][pRFoot];
	new hkka = pData[playerid][pLFoot];
	new leveldrug[128];
	if(pData[playerid][pUseDrug] >= 1 && pData[playerid][pUseDrug] <= 10)
	{
		leveldrug = "{00ff00}LOW USER";
	}
	else if(pData[playerid][pUseDrug] >= 11 && pData[playerid][pUseDrug] <= 20)
	{
		leveldrug = ""YELLOW_E"MEDIUM USER";
	}
	else if(pData[playerid][pUseDrug] >= 21)
	{
		leveldrug = "{ff0000}HARD USER";
	}
	else
	{
		leveldrug = "{00ff00}NOT USER";
	}
	format(hstring, sizeof(hstring),"[Bagian Tubuh]\tKondisi\n{ffffff}Kepala\t{7fffd4}%d.0%\n{ffffff}Perut\t{7fffd4}%d.0%\n{ffffff}Tangan Kanan\t{7fffd4}%d.0%\n{ffffff}Tangan Kiri\t{7fffd4}%d.0%\n",hh,hp,htk,htka);
	strcat(info, hstring);
    format(hstring, sizeof(hstring),"{ffffff}Kaki Kanan\t{7fffd4}%d.0%\n{ffffff}Kaki Kiri\t{7fffd4}%d.0%\n{ffffff}Status Urine :\t%s\n",hkk,hkka,leveldrug);
    strcat(info, hstring);
	ShowPlayerDialog(playerid, DIALOG_HEALTH, DIALOG_STYLE_TABLIST_HEADERS,"Health Condition",info,"Oke","");
    return 1;
}

CMD:sleep(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][pInjured] == 1)
        return Error(playerid, "Kamu tidak bisa melakukan ini disaat yang tidak tepat!");
	
	if(pData[playerid][pInHouse] == -1)
		return Error(playerid, "Kamu tidak berada didalam rumah.");
	
	InfoTD_MSG(playerid, 10000, "Sleeping... Harap Tunggu");
	TogglePlayerControllable(playerid, 0);
	new time = (100 - pData[playerid][pEnergy]) * (400);
    SetTimerEx("UnfreezeSleep", time, 0, "i", playerid);
	switch(random(6))
	{
		case 0: ApplyAnimation(playerid, "INT_HOUSE", "BED_In_L",4.1,0,0,0,1,1);
		case 1: ApplyAnimation(playerid, "INT_HOUSE", "BED_In_R",4.1,0,0,0,1,1);
		case 2: ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_L",4.1,1,0,0,1,1);
		case 3: ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_R",4.1,1,0,0,1,1);
		case 4: ApplyAnimation(playerid, "INT_HOUSE", "BED_Out_L",4.1,0,1,1,0,0);
		case 5: ApplyAnimation(playerid, "INT_HOUSE", "BED_Out_R",4.1,0,1,1,0,0);
	}
	return 1;
}

/*CMD:salary(playerid, params[])
{
	new query[256], count;
	format(query, sizeof(query), "SELECT * FROM salary WHERE owner='%d'", pData[playerid][pID]);
	new Cache:result = mysql_query(g_SQL, query);
	new rows = cache_num_rows();
	if(rows) 
	{
		new str[2048];
		for(new i; i < rows; i++)
		{
			new info[64];
			cache_get_value_int(i, "id", pSalary[playerid][i][salaryId]);
			cache_get_value_int(i, "money", pSalary[playerid][i][salaryMoney]);
			cache_get_value(i, "info", info);
			format(pSalary[playerid][i][salaryInfo], 64, "%s", info);
			cache_get_value_int(i, "date", pSalary[playerid][i][salaryDate]);
			
			format(str, sizeof(str), "%s%s\t%s\t%s\n", str, ReturnDate(pSalary[playerid][i][salaryDate]), pSalary[playerid][i][salaryInfo], FormatMoney(pSalary[playerid][i][salaryMoney]));
			count++;
			if(count >= 10) break;
		}
		format(str, sizeof(str), "Date\tInfo\tCash\n", str);
		if(count >= 10)
		{
			format(str, sizeof(str), "%s\nNext >>>", str);
		}
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Salary Details", str, "Close", "");
	}
	else 
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Notice", "Kamu tidak memiliki salary saat ini!", "Ok", "");
	}
	cache_delete(result);
	return 1;
}*/

CMD:time(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "Kamu harus login!");
		
	new line2[1200];
	new paycheck = 3600 - pData[playerid][pPaycheck];
	if(paycheck < 1)
	{
		paycheck = 0;
	}
	
	format(line2, sizeof(line2), ""WHITE_E"Paycheck Time: "YELLOW_E"%d remaining\n"WHITE_E"Delay Job: "RED_E"%d Detik\n"WHITE_E"Delay Side Job: "RED_E"%d Detik\n"WHITE_E"Plant Time(Farmer): "RED_E"%d Detik\n"WHITE_E"Arrest Time: "RED_E"%d Detik\n"WHITE_E"Jail Time: "RED_E"%d Detik\n", paycheck, pData[playerid][pJobTime], pData[playerid][pSideJobTime], pData[playerid][pPlantTime], pData[playerid][pArrestTime], pData[playerid][pJailTime]);
   	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Konoha:RP"WHITE_E"Time", line2, "Oke", "");
	return 1;
}

CMD:idcard(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return Error(playerid, "Anda tidak memiliki id card!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[ID-Card] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
	return 1;
}

CMD:drivelic(playerid, params[])
{
	if(pData[playerid][pDriveLic] == 0) return Error(playerid, "Anda tidak memiliki Driving License/SIM!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[Drive-Lic] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pDriveLicTime]));
	return 1;
}

CMD:newidcard(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 910.90, 256.46, 1289.98)) return Error(playerid, "Anda harus berada di City Hall!");
	if(pData[playerid][pIDCard] != 0) return Error(playerid, "Anda sudah memiliki ID Card!");
	if(pData[playerid][pMoney] < 25) return Error(playerid, "Anda butuh $25 untuk membuat ID Card");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "ID-Card", mstr, "Tutup", "");
	pData[playerid][pIDCard] = 1;
	pData[playerid][pIDCardTime] = gettime() + (15 * 86400);
	GivePlayerMoneyEx(playerid, -25);
	Server_AddMoney(25);
	return 1;
}

CMD:newage(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 910.90, 256.46, 1289.98)) return Error(playerid, "Anda harus berada di City Hall!");
	//if(pData[playerid][pIDCard] != 0) return Error(playerid, "Anda sudah memiliki ID Card!");
	if(pData[playerid][pMoney] < 20) return Error(playerid, "Anda butuh $20 untuk mengganti tgl lahir anda!");
	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Anda harus login terlebih dahulu!");
	ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Change", "Cancel");
	return 1;
}

CMD:newdrivelic(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2033.43, -117.49, 1035.17)) return Error(playerid, "Anda harus berada di Driving School!");
    if(pData[playerid][pDriveLic] != 0) return Error(playerid, "Anda sudah memiliki Driving License!");
    if(pData[playerid][pMoney] < 500) return Error(playerid, "Anda butuh $500 untuk membuat Driving License.");
    Info(playerid, "Pergi keluar gedung dan kendarai mobil berwarna putih");
    pData[playerid][pGetSIM] = 1;
    GivePlayerMoneyEx(playerid, -500);
    Server_AddMoney(500);
    return 1;
}

CMD:newlumberlic(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 242.1874,118.5328,1003.2188)) return Error(playerid, "Anda harus berada di SFPD!");
	if(pData[playerid][pLumberLic] != 0) return Error(playerid, "Anda sudah memiliki Lumber Jack License!");
	if(pData[playerid][pMoney] < 100) return Error(playerid, "Anda butuh $100 untuk membuat Lumber Jack License.");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Fiero\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Lumber Jack License", mstr, "Tutup", "");
	pData[playerid][pLumberLic] = 1;
	pData[playerid][pLumberLicTime] = gettime() + (15 * 86400);
	GivePlayerMoneyEx(playerid, -5000);
	Server_AddMoney(5000);
	return 1;
}

CMD:newtrucklic(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 250.3115,118.5369,1003.2188)) return Error(playerid, "Anda harus berada di SFPD!");
	if(pData[playerid][pTruckLic] != 0) return Error(playerid, "Anda sudah memiliki Truck License!");
	if(pData[playerid][pMoney] < 5000) return Error(playerid, "Anda butuh $50.00 untuk membuat Truck License.");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Fiero\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Truck License", mstr, "Tutup", "");
	pData[playerid][pTruckLic] = 1;
	pData[playerid][pTruckLicTime] = gettime() + (15 * 86400);
	GivePlayerMoneyEx(playerid, -5000);
	Server_AddMoney(5000);
	return 1;
}

/*CMD:newdrivelic(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 252.22, 117.43, 1003.21)) return Error(playerid, "Anda harus berada di SAPD!");
	if(pData[playerid][pDriveLic] != 0) return Error(playerid, "Anda sudah memiliki Driving License!");
	if(pData[playerid][pMoney] < 200) return Error(playerid, "Anda butuh $200 untuk membuat Driving License.");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Driving License", mstr, "Tutup", "");
	pData[playerid][pDriveLic] = 1;
	pData[playerid][pDriveLicTime] = gettime() + (15 * 86400);
	GivePlayerMoneyEx(playerid, -200);
	Server_AddMoney(200);
	return 1;
}

CMD:buyplate(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 240.80, 112.95, 1003.21)) return Error(playerid, "Anda harus berada di SAPD!");
	
	new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tPlate\tPlate Time\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[playerid][pID])
		{
			if(strcmp(pvData[i][cPlate], "None"))
			{
				GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
				format(msg2, sizeof(msg2), "%s%d\t%s\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				found = true;
			}
			else
			{
				GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
				format(msg2, sizeof(msg2), "%s%d\t%s\t%s\tNone\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate]);
				found = true;
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_BUYPLATE, DIALOG_STYLE_TABLIST_HEADERS, "Vehicles Plate", msg2, "Buy", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles Plate", "Anda tidak memeliki kendaraan", "Close", "");
			
	return 1;
}*/

CMD:buyinsu(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -77.4220,-1136.6021,1.0781)) return Error(playerid, "Anda harus berada di Asuransi!");
		
	new vehid;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/buyinsu [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");
			
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID] && pvData[i][cClaim] == 0)
			{
				if(pData[playerid][pMoney] < 1500) return Error(playerid, "Anda butuh $15.00 untuk membeli Insurance.");
				GivePlayerMoneyEx(playerid, -1500);
				pvData[i][cInsu]++;
				Info(playerid, "Model: %s || Total Insurance: %d || Insurance Price: $15.00", GetVehicleModelName(pvData[i][cModel]), pvData[i][cInsu]);
			}
			else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:claimpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -77.4220,-1136.6021,1.0781))
		return Error(playerid, "Anda harus berada di Asuransi!");

	if(GetVehiclesInsurance(playerid) == 0)
		return Error(playerid, "Belum saat nya mengambil kendaraanmu (/v insu)");

	new vehid, _tmpstring[128], count = GetVehiclesInsurance(playerid), CMDSString[1024];
	CMDSString = "";
	
	Loop(itt, (count + 1), 1)
	{
	    vehid = ReturnPVehiclesInsuID(playerid, itt);
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), "%d\t%s\tClaimed\n", itt, GetVehicleModelName(pvData[vehid][cModel]));
		}
		else format(_tmpstring, sizeof(_tmpstring), "%d\t%s\tClaimed\n", itt, GetVehicleModelName(pvData[vehid][cModel]));
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, VEHICLE_INSURANCE, DIALOG_STYLE_LIST, "Claim Vehicles Insurance", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:sellpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -77.4220,-1136.6021,1.0781)) return Error(playerid, "Anda harus berada di Asuransi!");
	
	new vehid;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/sellpv [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");
			
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(!IsValidVehicle(pvData[i][cVeh])) return Error(playerid, "Your vehicle is not spanwed!");
				if(pvData[i][cRent] != 0) return Error(playerid, "You can't sell rental vehicle!");
				new pay = pvData[i][cPrice] / 3;
				GivePlayerMoneyEx(playerid, pay);
				
				Info(playerid, "Anda menjual kendaraan model %s(%d) dengan seharga "LG_E"%s", GetVehicleName(vehid), GetVehicleModel(vehid), FormatMoney(pay));
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
				mysql_tquery(g_SQL, query);

				MySQL_ResetVehicleToys(i);
				if(IsValidVehicle(pvData[i][cVeh])) 
					DestroyVehicle(pvData[i][cVeh]);

				pvData[i][cVeh] = 0;
				
				Iter_SafeRemove(PVehicles, i, i);
			}
			else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:newrek(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -982.49, 1448.46, 1340.62)) return Error(playerid, "Anda harus berada di Bank!");
	if(pData[playerid][pMoney] < 500) return Error(playerid, "Not enough money!");
	new query[128], rand = RandomEx(111111, 999999);
	new rek = rand+pData[playerid][pID];
	mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
	mysql_tquery(g_SQL, query, "BankRek", "id", playerid, rek);
	Info(playerid, "New rekening bank!");
	GivePlayerMoneyEx(playerid, -500);
	Server_AddMoney(500);
	return 1;
}

CMD:hidebank(playerid)
{
	for(new i = 0; i < 59; i++)
	{
		TextDrawHideForPlayer(playerid, TDBANKAJI[i]);
	}
	CancelSelectTextDraw(playerid);
	return 1;
}

CMD:bank(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -983.95, 1448.46, 1340.62)) return Error(playerid, "Anda harus berada di bank point!");
	new tstr[128];
	format(tstr, sizeof(tstr), ""ORANGE_E"No Rek: "LB_E"%d", pData[playerid][pBankRek]);
	ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, tstr, "Deposit Money\nWithdraw Money\nCheck Balance\nTransfer Money\nSign Paycheck", "Select", "Cancel");
	return 1;
}

CMD:pay(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new money, otherid, mstr[128];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/pay <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "Player disconnect atau tidak berada didekat anda.");

 	if(otherid == playerid)
		return Error(playerid, "You can't send yourself money!");
	if(pData[playerid][pMoney] < money)
		return Error(playerid, "You don't have enough money to send!");
	if(money > 1000000 && pData[playerid][pAdmin] == 0)
		return Error(playerid, "You can't send more than $1,000,000 at once!");
	if(money < 1)
		return Error(playerid, "You can't send anyone less than $1!");
		
	/*GivePlayerMoneyEx(otherid, money);
	GivePlayerMoneyEx(playerid, -money);

	format(mstr, sizeof(mstr), "Server: "YELLOW_E"You have sent %s(%i) "GREEN_E"%s", pName[otherid], otherid, FormatMoney(money));
	SendClientMessage(playerid, COLOR_GREY, mstr);
	format(mstr, sizeof(mstr), "Server: "YELLOW_E"%s(%i) has sent you "GREEN_E"%s", pName[playerid], playerid, FormatMoney(money));
	SendClientMessage(otherid, COLOR_GREY, mstr);
	InfoTD_MSG(playerid, 3500, "~g~~h~Money Sent!");
	InfoTD_MSG(otherid, 3500, "~g~~h~Money received!");
	ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	
	new OtherIP[16];
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	GetPlayerIp(otherid, OtherIP, sizeof(OtherIP));
	SendStaffMessage(COLOR_RED, "[PAYINFO] "WHITE_E"%s(%d)[IP: %d] pay to %s(%d)[IP: %d] ammount "GREEN_E"%s", pName[playerid], playerid, PlayerIP, pName[otherid], otherid, OtherIP, FormatMoney(money));*/
	format(mstr, sizeof(mstr), ""WHITEP_E"Are you sure you want to send %s(%d) "GREEN_E"%s?", ReturnName(otherid), otherid, FormatMoney(money));
	ShowPlayerDialog(playerid, DIALOG_PAY, DIALOG_STYLE_MSGBOX, ""GREEN_E"Send Money", mstr, "Send", "Cancel");

	SetPVarInt(playerid, "gcAmount", money);
	SetPVarInt(playerid, "gcPlayer", otherid);
	return 1;
}

CMD:stats(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be logged in to check statistics!");
	    return 1;
	}
	
	DisplayStats(playerid, playerid);
	return 1;
}

CMD:settings(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be logged in to check statistics!");
	    return 1;
	}
	
	new str[1024], hbemode[64], togpm[64], toglog[64], togads[64], togwt[64];
	if(pData[playerid][pHBEMode] == 1)
	{
		hbemode = ""LG_E"Simple";
	}
	else if(pData[playerid][pHBEMode] == 2)
	{
		hbemode = ""LG_E"Modern";
	}
	else
	{
		hbemode = ""RED_E"Disable";
	}
	
	if(pData[playerid][pTogPM] == 0)
	{
		togpm = ""RED_E"Disable";
	}
	else
	{
		togpm = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogLog] == 0)
	{
		toglog = ""RED_E"Disable";
	}
	else
	{
		toglog = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogAds] == 0)
	{
		togads = ""RED_E"Disable";
	}
	else
	{
		togads = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogWT] == 0)
	{
		togwt = ""RED_E"Disable";
	}
	else
	{
		togwt = ""LG_E"Enable";
	}
	
	format(str, sizeof(str), "Settings\tStatus\n"WHITEP_E"Email:\t"GREY3_E"%s\n"WHITEP_E"Change Password\n"WHITEP_E"HUD HBE Mode:\t%s\n"WHITEP_E"Toggle PM:\t%s\n"WHITEP_E"Toggle Log Server:\t%s\n"WHITEP_E"Toggle Ads:\t%s\n"WHITEP_E"Toggle WT:\t%s",
	pData[playerid][pEmail], 
	hbemode, 
	togpm,
	toglog,
	togads,
	togwt
	);
	
	ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Settings", str, "Set", "Close");
	return 1;
}

CMD:items(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be logged in to check items!");
	    return true;
	}
	DisplayItems(playerid, playerid);
	return 1;
}

CMD:frisk(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/frisk [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa memeriksa dirimu sendiri.");

    pData[otherid][pFriskOffer] = playerid;

    Info(otherid, "%s has offered to frisk you (type \"/accept frisk or /deny frisk\").", ReturnName(playerid));
    Info(playerid, "You have offered to frisk %s.", ReturnName(otherid));
	return 1;
}

CMD:inspect(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/inspect [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa memeriksa dirimu sendiri.");

    pData[otherid][pInsOffer] = playerid;

    Info(otherid, "%s has offered to inspect you (type \"/accept inspect or /deny inspect\").", ReturnName(playerid));
    Info(playerid, "You have offered to inspect %s.", ReturnName(otherid));
	return 1;
}

CMD:reqloc(playerid, params[])
{
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/reqloc [playerid/PartOfName]");

    if(pData[playerid][pPhone] < 1)
    	return Error(playerid, "Anda tidak memiliki Handphone");

    if(pData[playerid][pUsePhone] == 0)
    	return Error(playerid, "Ponsel anda masih offline");

    if(pData[otherid][pPhone] < 1)
    	return Error(playerid, "Tujuan tidak memiliki Handphone");

    if(pData[otherid][pUsePhone] == 0)
    	return Error(playerid, "Ponsel yang anda tuju masih offline");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa meminta lokasi kepada anda sendiri.");

    pData[otherid][pLocOffer] = playerid;

    Info(otherid, "%s has offered to request share his location (type \"/accept reqloc or /deny reqloc\").", ReturnName(playerid));
    Info(playerid, "You have offered to share your location %s.", ReturnName(otherid));
	return 1;
}

CMD:accept(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            Usage(playerid, "/accept [name]");
            Names(playerid, "faction, family, workshop, drag, frisk, inspect, job, reqloc, rob, handshake, dicebet, weapon");
            return 1;
        }
		if(strcmp(params,"faction",true) == 0) 
		{
            if(IsPlayerConnected(pData[playerid][pFacOffer])) 
			{
                if(pData[playerid][pFacInvite] > 0) 
				{
                    pData[playerid][pFaction] = pData[playerid][pFacInvite];
					pData[playerid][pFactionRank] = 1;
					Info(playerid, "Anda telah menerima invite faction dari %s", pData[pData[playerid][pFacOffer]][pName]);
					Info(pData[playerid][pFacOffer], "%s telah menerima invite faction yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFacInvite] = 0;
					pData[playerid][pFacOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid faction id!");
					return 1;
				}
            }
            else 
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		if(strcmp(params,"family",true) == 0) 
		{
            if(IsPlayerConnected(pData[playerid][pFamOffer])) 
			{
                if(pData[playerid][pFamInvite] > -1) 
				{
                    pData[playerid][pFamily] = pData[playerid][pFamInvite];
					pData[playerid][pFamilyRank] = 1;
					Info(playerid, "Anda telah menerima invite family dari %s", pData[pData[playerid][pFamOffer]][pName]);
					Info(pData[playerid][pFamOffer], "%s telah menerima invite family yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFamInvite] = 0;
					pData[playerid][pFamOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid family id!");
					return 1;
				}
            }
            else 
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
        if(strcmp(params,"workshop",true) == 0)
		{
            if(IsPlayerConnected(pData[playerid][pWsOffer]))
			{
                if(pData[playerid][pWsInvite] > -1)
				{
                    pData[playerid][pWorkshop] = pData[playerid][pWsInvite];
					pData[playerid][pWorkshopRank] = 1;
					Info(playerid, "Anda telah menerima invite workshop dari %s", pData[pData[playerid][pWsOffer]][pName]);
					Info(pData[playerid][pWsOffer], "%s telah menerima invite workshop yang anda tawari", pData[playerid][pName]);
					pData[playerid][pWsInvite] = 0;
					pData[playerid][pWsOffer] = -1;
					UpdatePlayerData(playerid);
				}
				else
				{
					Error(playerid, "Invalid workshop id!");
					return 1;
				}
            }
            else
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		else if(strcmp(params,"drag",true) == 0)
		{
			new dragby = GetPVarInt(playerid, "DragBy");
			if(dragby == INVALID_PLAYER_ID || dragby == playerid)
				return Error(playerid, "Player itu Disconnect.");
        
			if(!NearPlayer(playerid, dragby, 5.0))
				return Error(playerid, "Kamu harus didekat Player.");
        
			pData[playerid][pDragged] = 1;
			pData[playerid][pDraggedBy] = dragby;

			pData[playerid][pDragTimer] = SetTimerEx("DragUpdate", 1000, true, "ii", dragby, playerid);
			SendNearbyMessage(dragby, 30.0, COLOR_PURPLE, "* %s grabs %s and starts dragging them, (/undrag).", ReturnName(dragby), ReturnName(playerid));
			return true;
		}
		else if(strcmp(params,"frisk",true) == 0)
		{
			if(pData[playerid][pFriskOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			if(!NearPlayer(playerid, pData[playerid][pFriskOffer], 5.0))
				return Error(playerid, "Kamu harus didekat Player.");
				
			DisplayItems(pData[playerid][pFriskOffer], playerid);
			Servers(playerid, "Anda telah berhasil menaccept tawaran frisk kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"inspect",true) == 0)
		{
			if(pData[playerid][pInsOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			if(!NearPlayer(playerid, pData[playerid][pInsOffer], 5.0))
				return Error(playerid, "Kamu harus didekat Player.");
				
			new hstring[512], info[512];
			new hh = pData[playerid][pHead];
			new hp = pData[playerid][pPerut];
			new htk = pData[playerid][pRHand];
			new htka = pData[playerid][pLHand];
			new hkk = pData[playerid][pRFoot];
			new hkka = pData[playerid][pLFoot];
			format(hstring, sizeof(hstring),"Bagian Tubuh\tKondisi\n{ffffff}Kepala\t{7fffd4}%d.0%\n{ffffff}Perut\t{7fffd4}%d.0%\n{ffffff}Tangan Kanan\t{7fffd4}%d.0%\n{ffffff}Tangan Kiri\t{7fffd4}%d.0%\n",hh,hp,htk,htka);
			strcat(info, hstring);
			format(hstring, sizeof(hstring),"{ffffff}Kaki Kanan\t{7fffd4}%d.0%\n{ffffff}Kaki Kiri\t{7fffd4}%d.0%\n",hkk,hkka);
			strcat(info, hstring);
			ShowPlayerDialog(pData[playerid][pInsOffer],DIALOG_HEALTH,DIALOG_STYLE_TABLIST_HEADERS,"Health Condition",info,"Oke","");
			Servers(playerid, "Anda telah berhasil menaccept tawaran Inspect kepada %s.", ReturnName(pData[playerid][pInsOffer]));
			pData[playerid][pInsOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"job",true) == 0) 
		{
			if(pData[playerid][pGetJob] > 0)
			{
				pData[playerid][pJob] = pData[playerid][pGetJob];
				Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
				pData[playerid][pGetJob] = 0;
				pData[playerid][pExitJob] = gettime() + (1 * 86400);
			}
			else if(pData[playerid][pGetJob2] > 0)
			{
				pData[playerid][pJob2] = pData[playerid][pGetJob2];
				Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
				pData[playerid][pGetJob2] = 0;
				pData[playerid][pExitJob] = gettime() + (1 * 86400);
			}
		}
		else if(strcmp(params,"reqloc",true) == 0)
		{
			if(pData[playerid][pLocOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pLocOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
				
			new Float:sX, Float:sY, Float:sZ;
			GetPlayerPos(playerid, sX, sY, sZ);
			SetPlayerCheckpoint(pData[playerid][pLocOffer], sX, sY, sZ, 5.0);
			Servers(playerid, "Anda telah berhasil menaccept tawaran Share Lokasi kepada %s.", ReturnName(pData[playerid][pLocOffer]));
			Servers(pData[playerid][pLocOffer], "Lokasi %s telah tertandai.", ReturnName(playerid));
			pData[playerid][pLocOffer] = INVALID_PLAYER_ID;
		}
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

			pData[playerid][pMemberRob] = offerid;
			pData[playerid][pRobOffer] = -1;
			
			pData[offerid][pRobLeader] = 1;
			pData[offerid][pRobMember] += 1;
		}
		else if(!strcmp(params, "handshake", true))
		{
		    new offeredby = pData[playerid][pShakeOffer];

		    if(offeredby == INVALID_PLAYER_ID)
		        return Error(playerid, "You haven't received any offers for a handshake.");

		    if(!NearPlayer(playerid, offeredby, 5.0))
		        return Error(playerid, "The player who initiated the offer is out of range.");

		    ClearAnimations(playerid);
			ClearAnimations(offeredby);

			SetPlayerToFacePlayer(playerid, offeredby);
			SetPlayerToFacePlayer(offeredby, playerid);

			switch(pData[playerid][pShakeType])
			{
			    case 1:
			    {
					ApplyAnimation(playerid,  "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
					ApplyAnimation(offeredby, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 2:
				{
					ApplyAnimation(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
					ApplyAnimation(offeredby, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 3:
				{
					ApplyAnimation(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
					ApplyAnimation(offeredby, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 4:
				{
					ApplyAnimation(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
					ApplyAnimation(offeredby, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 5:
				{
					ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
					ApplyAnimation(offeredby, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 6:
				{
				    ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
				    ApplyAnimation(offeredby, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
				}
		    }

		    Info(playerid, "* You have accepted %s's handshake offer.", ReturnName(offeredby));
		    Info(offeredby, "* %s has accepted your handshake offer.", ReturnName(playerid));

	  		pData[playerid][pShakeOffer] = INVALID_PLAYER_ID;
		}
		else if(!strcmp(params, "dicebet", true))
		{
		    new offeredby = pData[playerid][pDiceOffer], amount = pData[playerid][pDiceBet];

		    if(offeredby == INVALID_PLAYER_ID)
		        return Error(playerid, "You haven't received any offers for dice betting.");

		    if(!NearPlayer(playerid, offeredby, 5.0))
		        return Error(playerid, "The player who initiated the offer is out of range.");

		    if(pData[playerid][pMoney] < amount)
		        return Error(playerid, "You can't afford to accept this bet.");

		    if(pData[playerid][pMoney] < amount)
		        return Error(playerid, "That player can't afford to accept this bet.");

			new rand[2];

			if(pData[playerid][pDiceRigged])
			{
			    rand[0] = 4 + random(3);
			    rand[1] = random(3) + 1;
			}
			else
			{
				for(new x = 0; x < random(50)*random(50)+30; x++)
				{
					rand[0] = random(6) + 1;
				}
				for(new x = 0; x < random(50)*random(50)+30; x++)
				{
					rand[1] = random(6) + 1;
				}
			}

			SendNearbyMessage(offeredby, 20.0, COLOR_PURPLE, "* %s rolls a dice which lands on the number %d.", ReturnName(offeredby), rand[0]);
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s rolls a dice which lands on the number %d.", ReturnName(playerid), rand[1]);

			if(rand[0] > rand[1])
			{
			    GivePlayerMoneyEx(offeredby, amount);
			    GivePlayerMoneyEx(playerid, -amount);

			    Info(offeredby, "* You have won %s from your dice bet with %s.", FormatMoney(amount), ReturnName(playerid));
			    Info(playerid, "* You have lost %s from your dice bet with %s.", FormatMoney(amount), ReturnName(offeredby));
			}
			else if(rand[0] == rand[1])
			{
				Info(offeredby, "* The bet of %s was a tie. You kept your money as a result!", FormatMoney(amount));
			    Info(playerid, "* The bet of %s was a tie. You kept your money as a result!", FormatMoney(amount));
			}
			else
			{
			    GivePlayerMoneyEx(offeredby, -amount);
			    GivePlayerMoneyEx(playerid, amount);

			    Info(playerid, "* You have won %s from your dice bet with %s.", FormatMoney(amount), ReturnName(offeredby));
			    Info(offeredby, "* You have lost %s from your dice bet with %s.", FormatMoney(amount), ReturnName(playerid));
			}

		    pData[playerid][pDiceOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"weapon",true) == 0) 
		{
			if(pData[playerid][pWeaponOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pWeaponOffer]))
				return Error(playerid, "Player tersebut belum masuk!");

			if(pData[playerid][pMoney] < pData[playerid][pWeaponPriceOffer])
				return Error(playerid, "Uang kamu tidak mencukupi untuk membeli senjata tersebut!");

			if(pData[pData[playerid][pWeaponOffer]][pMaterial] < pData[playerid][pWeaponMatsOffer])
				return Error(playerid, "Jumlah material penjual tidak mencukupi");

			GivePlayerMoneyEx(pData[playerid][pWeaponOffer], pData[playerid][pWeaponPriceOffer]);
			GivePlayerMoneyEx(playerid, -pData[playerid][pWeaponPriceOffer]);

			GivePlayerWeaponEx(playerid, pData[playerid][pWeaponidOffer], pData[playerid][pWeaponAmmoOffer]);
			
			Info(pData[playerid][pWeaponOffer], "%s telah menerima senjata %s yang anda tawarkan", ReturnName(playerid), ReturnWeaponName(pData[playerid][pWeaponidOffer]));
			Info(playerid, "Kamu telah menerima senjata %s dengan harga "RED_E"%s"WHITE_E"", ReturnWeaponName(pData[playerid][pWeaponidOffer]), FormatMoney(pData[playerid][pWeaponPriceOffer]));

			if(pData[pData[playerid][pWeaponOffer]][pWeaponSkill] <= 40)
			{
				pData[pData[playerid][pWeaponOffer]][pWeaponSkill] += 1;
			}
			pData[pData[playerid][pWeaponOffer]][pMaterial] -= pData[playerid][pWeaponMatsOffer];
			pData[playerid][pWeaponidOffer] = 0;
			pData[playerid][pWeaponAmmoOffer] = 0;
			pData[playerid][pWeaponMatsOffer] = 0;
			pData[playerid][pWeaponPriceOffer] = 0;
			pData[playerid][pWeaponOffer] = INVALID_PLAYER_ID;
		}
	}
	return 1;
}

CMD:deny(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            Usage(playerid, "/deny [name]");
            Names(playerid, "faction, drag, frisk, inspect, job1, job2, reqloc, rob");
            return 1;
        }
		if(strcmp(params,"faction",true) == 0) 
		{
            if(pData[playerid][pFacOffer] > -1) 
			{
                if(pData[playerid][pFacInvite] > 0) 
				{
					Info(playerid, "Anda telah menolak faction dari %s", ReturnName(pData[playerid][pFacOffer]));
					Info(pData[playerid][pFacOffer], "%s telah menolak invite faction yang anda tawari", ReturnName(playerid));
					pData[playerid][pFacInvite] = 0;
					pData[playerid][pFacOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid faction id!");
					return 1;
				}
            }
            else 
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		else if(strcmp(params,"drag",true) == 0)
		{
			new dragby = GetPVarInt(playerid, "DragBy");
			if(dragby == INVALID_PLAYER_ID || dragby == playerid)
				return Error(playerid, "Player itu Disconnect.");

			Info(playerid, "Anda telah menolak drag.");
			Info(dragby, "Player telah menolak drag yang anda tawari.");
			
			DeletePVar(playerid, "DragBy");
			pData[playerid][pDragged] = 0;
			pData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"frisk",true) == 0)
		{
			if(pData[playerid][pFriskOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran frisk kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"inspect",true) == 0)
		{
			if(pData[playerid][pInsOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pInsOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Inspect kepada %s.", ReturnName(pData[playerid][pInsOffer]));
			pData[playerid][pInsOffer] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"job1",true) == 0) 
		{
			if(pData[playerid][pJob] == 0) return Error(playerid, "Anda tidak memiliki job apapun.");
			if(pData[playerid][pExitJob] != 0) return Error(playerid, "You must wait 1 days for exit from your current job!");
			if(pData[playerid][pJob] != 0)
			{
				pData[playerid][pJob] = 0;
				Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
				return 1;
			}
		}
		else if(strcmp(params,"job2",true) == 0) 
		{
			if(pData[playerid][pJob2] == 0) return Error(playerid, "Anda tidak memiliki job apapun.");
			if(pData[playerid][pJob2] != 0)
			{
				pData[playerid][pJob2] = 0;
				Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
				return 1;
			}
		}
		else if(strcmp(params,"reqloc",true) == 0) 
		{
			if(pData[playerid][pLocOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pLocOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Share Lokasi kepada %s.", ReturnName(pData[playerid][pLocOffer]));
			pData[playerid][pLocOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"rob",true) == 0) 
		{
			if(pData[playerid][pRobOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pRobOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Rob kepada %s.", ReturnName(pData[playerid][pRobOffer]));
			pData[playerid][pRobOffer] = INVALID_PLAYER_ID;
		}
	}
	return 1;
}

CMD:give(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
		new name[24], ammount, otherid;
        if(sscanf(params, "us[24]d", otherid, name, ammount))
		{
			Usage(playerid, "/give [playerid] [name] [ammount]");
			Names(playerid, "bandage, medicine, snack, sprunk, material, component, repairkit");
			Names(playerid, "marijuana, ephedrine, cocaine, meth, tdrug, gps, bomb");
			return 1;
		}
		if(otherid == INVALID_PLAYER_ID || otherid == playerid || !NearPlayer(playerid, otherid, 3.0))
			return Error(playerid, "Invalid playerid!");
			
		if(strcmp(name,"bandage",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pBandage] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			
			pData[playerid][pBandage] -= ammount;
			pData[otherid][pBandage] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan bandage sejumlah %d kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
        }
		else if(strcmp(name,"medicine",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pMedicine] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
		 		
			pData[playerid][pMedicine] -= ammount;
			pData[otherid][pMedicine] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan medicine sejumlah %d kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"snack",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pSnack] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[playerid][pSnack] -= ammount;
			pData[otherid][pSnack] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan snack sejumlah %d kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"sprunk",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pSprunk] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[playerid][pSprunk] -= ammount;
			pData[otherid][pSprunk] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan sprunk sejumlah %d kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"material",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pMaterial] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");
			
			new maxmat = pData[otherid][pMaterial] + ammount;
			
			if(maxmat > 500)
				return Error(playerid, "That player already have maximum material!");
			
			pData[playerid][pMaterial] -= ammount;
			pData[otherid][pMaterial] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan material sejumlah %d kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"component",true) == 0)
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pComponent] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");
			
			new maxcomp = pData[otherid][pComponent] + ammount;
			
			if(maxcomp > 500)
				return Error(playerid, "That player already have maximum component!");
			
			pData[playerid][pComponent] -= ammount;
			pData[otherid][pComponent] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan component sejumlah %d kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"repairkit",true) == 0)
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pRepairkit] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");
			
			pData[playerid][pRepairkit] -= ammount;
			pData[otherid][pRepairkit] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan repairkit sejumlah %d kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"marijuana",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pMarijuana] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[playerid][pMarijuana] -= ammount;
			pData[otherid][pMarijuana] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan %dg marijuana kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"ephedrine",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pEphedrine] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[playerid][pEphedrine] -= ammount;
			pData[otherid][pEphedrine] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan %dg ephedrine kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"cocaine",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pCocaine] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[playerid][pCocaine] -= ammount;
			pData[otherid][pCocaine] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan %dg cocaine kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"meth",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pMeth] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[playerid][pMeth] -= ammount;
			pData[otherid][pMeth] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan %dg meth kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"gps",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pGPS] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[playerid][pGPS] -= ammount;
			pData[otherid][pGPS] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan GPS kepada %s.", ReturnName(playerid), ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"bomb",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 		
			if(pData[playerid][pBomb] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[playerid][pBomb] -= ammount;
			pData[otherid][pBomb] += ammount;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan %d Patch Bomb kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
		}
		else if(strcmp(name,"tdrug",true) == 0) 
		{
			if(ammount < 1)
		 		return Error(playerid, "Tidak Dapat Memberikan Item Di Bawah Angka 1!");
		 	
			if(pData[playerid][pTdrug] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			if(pData[playerid][pUseTdrug] == 0)
			{
				pData[playerid][pTdrug] -= ammount;
				pData[otherid][pTdrug] += ammount;
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan %d Test Drugs kepada %s.", ReturnName(playerid), ammount, ReturnName(otherid));
				ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
			}
			else
			{
				pData[playerid][pTdrug] -= ammount;
				pData[playerid][pUseTdrug] = 0;
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s memberikan hasil Test Drugs kepada %s.", ReturnName(playerid), ReturnName(otherid));
				ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0, 1);

				new str[128], leveldrug[128];
				if(pData[playerid][pUseDrug] >= 1 && pData[playerid][pUseDrug] <= 10)
				{
					leveldrug = "{00ff00}LOW USER";
				}
				else if(pData[playerid][pUseDrug] >= 11 && pData[playerid][pUseDrug] <= 20)
				{
					leveldrug = ""YELLOW_E"MEDIUM USER";
				}
				else if(pData[playerid][pUseDrug] >= 21)
				{
					leveldrug = "{ff0000}HARD USER";
				}
				else
				{
					leveldrug = "{00ff00}NOT USER";
				}
				format(str, sizeof(str), "From : %s\nStatus : %s", ReturnName(playerid), leveldrug);
				ShowPlayerDialog(otherid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "TDrug Results", str, "Yes", "");
			}
		}
	}
	return 1;
}

CMD:gen12(playerid)
{
	pData[playerid][pHead] = 100;
    pData[playerid][pPerut] = 100;
    pData[playerid][pRHand] = 100;
    pData[playerid][pLHand] = 100;
    pData[playerid][pRFoot] = 100;
    pData[playerid][pLFoot] = 100;
    pData[playerid][pTdrug] += 1;
	return 1;
}

CMD:use(playerid, params[])
{
	if(pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            Usage(playerid, "/use [name]");
            Names(playerid, "bandage, snack, sprunk, gas, medicine, marijuana, cocaine, meth, tdrug");
            return 1;
        }
		if(strcmp(params,"bandage",true) == 0) 
		{
			if(pData[playerid][pBandage] < 1)
				return Error(playerid, "Anda tidak memiliki perban.");
			
			new Float:darahhh;
			GetPlayerHealth(playerid, darahhh);
			pData[playerid][pBandage]--;
			SetPlayerHealthEx(playerid, darahhh+15);
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s membalut luka menggunakan perban", ReturnName(playerid));
			InfoTD_MSG(playerid, 3000, "Restore +25 Health");
		}
		else if(strcmp(params,"snack",true) == 0) 
		{
			if(pData[playerid][pSnack] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");
			
			pData[playerid][pSnack]--;
			pData[playerid][pHunger] += 15;
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s mengambil snack dan langsung memakannya", ReturnName(playerid));
			InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"sprunk",true) == 0) 
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki sprunk.");
			
			pData[playerid][pSprunk]--;
			pData[playerid][pEnergy] += 15;
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s mengambil sprunk dan langsung meminumnya", ReturnName(playerid));
			InfoTD_MSG(playerid, 3000, "Restore +15 Energy");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		/*else if(strcmp(params,"sprunk",true) == 0) 
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");
			
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
			//SendNearbyMessage(playerid, 10.0, COLOR_PURPLE,"* %s opens a can of sprunk.", ReturnName(playerid));
			SetPVarInt(playerid, "UsingSprunk", 1);
			pData[playerid][pSprunk]--;
		}*/
		else if(strcmp(params,"gas",true) == 0) 
		{
			if(pData[playerid][pGas] < 1)
				return Error(playerid, "Anda tidak memiliki gas.");
				
			if(IsPlayerInAnyVehicle(playerid))
				return Error(playerid, "Anda harus berada diluar kendaraan!");
			
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
			
			new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			if(IsValidVehicle(vehicleid))
			{
				new fuel = GetVehicleFuel(vehicleid);
			
				if(GetEngineStatus(vehicleid))
					return Error(playerid, "Turn off vehicle engine.");
			
				if(fuel >= 100.0)
					return Error(playerid, "This vehicle gas is full.");
			
				if(!IsEngineVehicle(vehicleid))
					return Error(playerid, "This vehicle can't be refull.");

				if(!GetHoodStatus(vehicleid))
					return Error(playerid, "The hood must be opened before refull the vehicle.");

				pData[playerid][pGas]--;
				Info(playerid, "Don't move from your position or you will failed to refulling this vehicle.");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pActivity] = SetTimerEx("RefullCar", 1000, true, "id", playerid, vehicleid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Refulling...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				/*InfoTD_MSG(playerid, 10000, "Refulling...");
				//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s starts to refulling the vehicle.", ReturnName(playerid));*/
				return 1;
			}
		}
		else if(strcmp(params,"medicine",true) == 0) 
		{
			if(pData[playerid][pMedicine] < 1)
				return Error(playerid, "Anda tidak memiliki medicine.");
			
			pData[playerid][pMedicine]--;
			pData[playerid][pSick] = 0;
			pData[playerid][pBladder] = 5;
			pData[playerid][pSickTime] = 0;
			SetPlayerDrunkLevel(playerid, 0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil medicine dan langsung menggunakannya", ReturnName(playerid));
			
			//InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"marijuana",true) == 0) 
		{
			if(pData[playerid][pMarijuana] < 1)
				return Error(playerid, "You dont have marijuana.");
			
			new Float:health;
			GetPlayerHealth(playerid, health);
			if(health+25 > 95)
			{
				Error(playerid, "Over dosis!");
				TextDrawShowForPlayer(playerid, Text:RedScreen);
				SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				{
					ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
				}
				SetPlayerHealthEx(playerid, 95);
				pData[playerid][pUseDrug]++;
				pData[playerid][pMarijuana]--;
				return 1;
			}
			
			pData[playerid][pMarijuana]--;
			pData[playerid][pUseDrug] = 1;
			SetPlayerHealthEx(playerid, health+25);
			SetPlayerDrunkLevel(playerid, 4000);
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g marijuana dan langsung menghisapnya", ReturnName(playerid));
		}
		else if(strcmp(params,"cocaine",true) == 0) 
		{
			if(pData[playerid][pCocaine] < 1)
				return Error(playerid, "You dont have cocaine.");
			
			new Float:armor;
			GetPlayerArmour(playerid, armor);
			if(armor+25 > 95)
			{
				Error(playerid, "Over dosis!");
				TextDrawShowForPlayer(playerid, Text:RedScreen);
				SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				{
					ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
				}
				SetPlayerArmourEx(playerid, 95);
				pData[playerid][pUseDrug]++;
				pData[playerid][pCocaine]--;
				return 1;
			}
			
			pData[playerid][pCocaine]--;
			pData[playerid][pUseDrug] = 1;
			SetPlayerArmourEx(playerid, armor+20);
			SetPlayerDrunkLevel(playerid, 4000);
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g cocaine dan langsung menghisapnya", ReturnName(playerid));
		}
		else if(strcmp(params,"meth",true) == 0) 
		{
			if(pData[playerid][pMeth] < 1)
				return Error(playerid, "You dont have meth.");
			
			new Float:armor, Float:health;
			GetPlayerArmour(playerid, armor);
			GetPlayerHealth(playerid, health);
			if(armor+25 > 95)
			{
				Error(playerid, "Over dosis!");
				TextDrawShowForPlayer(playerid, Text:RedScreen);
				SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				{
					ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
				}
				SetPlayerArmourEx(playerid, 95);
				SetPlayerArmourEx(playerid, armor+20);
				pData[playerid][pUseDrug]++;
				pData[playerid][pMeth]--;
			}
			else if(health+25 > 95)
			{
				Error(playerid, "Over dosis!");
				TextDrawShowForPlayer(playerid, Text:RedScreen);
				SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				{
					ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
				}
				SetPlayerHealthEx(playerid, 95);
				SetPlayerHealthEx(playerid, health+20);
				pData[playerid][pUseDrug]++;
				pData[playerid][pMeth]--;
				return 1;
			}
			
			pData[playerid][pMeth]--;
			pData[playerid][pUseDrug] = 1;
			SetPlayerArmourEx(playerid, armor+20);
			SetPlayerHealthEx(playerid, health+20);
			SetPlayerDrunkLevel(playerid, 4000);
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g meth dan langsung menghisapnya", ReturnName(playerid));
		}
		else if(strcmp(params,"tdrug",true) == 0) 
		{
			if(pData[playerid][pTdrug] < 1)
				return Error(playerid, "You dont have test drug.");
			
			pData[playerid][pUseTdrug] = 1;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s menggunakan alat pengetest drugs", ReturnName(playerid));

			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
	}
	return 1;
}

CMD:enter(playerid, params[])
{
	if(pData[playerid][pInjured] == 0)
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dGarage] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
				{
					if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
						return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

					if(dData[did][dLocked])
						return Error(playerid, "Bangunan ini di Kunci untuk sementara.");
						
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "Pintu ini hanya untuk fraksi.");
					}
					if(dData[did][dFamily] > 0)
					{
						if(dData[did][dFamily] != pData[playerid][pFamily])
							return Error(playerid, "Pintu ini hanya untuk Family.");
					}
					
					if(dData[did][dVip] > pData[playerid][pVip])
						return Error(playerid, "VIP Level mu tidak cukup.");
					
					if(dData[did][dAdmin] > pData[playerid][pAdmin])
						return Error(playerid, "Admin level mu tidak cukup.");
						
					if(strlen(dData[did][dPass]))
					{
						if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
						if(strcmp(params, dData[did][dPass])) return Error(playerid, "Password Salah.");
						
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
					else
					{
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
				}
				else
				{
					if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
						return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

					if(dData[did][dLocked])
						return Error(playerid, "Pintu ini ditutup sementara");
						
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "Pintu ini hanya untuk faction.");
					}
					if(dData[did][dFamily] > 0)
					{
						if(dData[did][dFamily] != pData[playerid][pFamily])
							return Error(playerid, "Pintu ini hanya untuk family.");
					}
					
					if(dData[did][dVip] > pData[playerid][pVip])
						return Error(playerid, "Your VIP level not enough to enter this door.");
					
					if(dData[did][dAdmin] > pData[playerid][pAdmin])
						return Error(playerid, "Your admin level not enough to enter this door.");

					if(strlen(dData[did][dPass]))
					{
						if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
						if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
						
						if(dData[did][dCustom])
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
						TogglePlayerControllable(playerid, 0);
						SetTimerEx("TimerUntogglePlayer", 3000, 0, "d", playerid);
					}
					else
					{
						if(dData[did][dCustom])
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
						TogglePlayerControllable(playerid, 0);
						SetTimerEx("TimerUntogglePlayer", 3000, 0, "d", playerid);
					}
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dGarage] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
				{
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "Pintu ini hanya untuk faction.");
					}
				
					if(dData[did][dCustom])
					{
						SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					}
					else
					{
						SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					}
					pData[playerid][pInDoor] = -1;
					SetPlayerInterior(playerid, dData[did][dExtint]);
					SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, WorldWeather);
				}
				else
				{
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "Pintu ini hanya untuk faction.");
					}
					
					if(dData[did][dCustom])
						SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);

					else
						SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					
					pData[playerid][pInDoor] = -1;
					SetPlayerInterior(playerid, dData[did][dExtint]);
					SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, WorldWeather);
				}
			}
        }
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return Error(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked] >= 2)
					return Error(playerid, "Rumah ini sedang disegel oleh pemerintah");
				
				if(hData[hid][hLocked])
					return Error(playerid, "Rumah ini terkunci!");
				
				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);

			pData[playerid][pInHouse] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return Error(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked] >= 2)
					return Error(playerid, "Bisnis ini sedang disegel oleh pemerintah");
				
				if(bData[bid][bLocked])
					return Error(playerid, "Bisnis ini Terkunci!");

				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);
				
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);
			
			pData[playerid][pInBiz] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return Error(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have registered for this door!");
					
				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				//pData[playerid][pInBiz] = fid;
				SetPlayerWeather(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ]))
			{
				SetPlayerPositionEx(playerid, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ], fData[fid][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
				//pData[playerid][pInBiz] = -1;
			}
        }
	}
	return 1;
}

CMD:drag(playerid, params[])
{
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/drag [playerid/PartOfName] || /undrag [playerid]");

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player itu Disconnect.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa menarik diri mu sendiri.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Kamu harus didekat Player.");

    if(!pData[otherid][pInjured])
        return Error(playerid, "kamu tidak bisa drag orang yang tidak mati.");

    SetPVarInt(otherid, "DragBy", playerid);
    Info(otherid, "%s Telah menawari drag kepada anda, /accept drag untuk menerimanya /deny drag untuk membatalkannya.", ReturnName(playerid));
	Info(playerid, "Anda berhasil menawari drag kepada player %s", ReturnName(otherid));
    return 1;
}

CMD:undrag(playerid, params[])
{
	new otherid;
    if(sscanf(params, "u", otherid)) return Usage(playerid, "/undrag [playerid]");
	if(pData[otherid][pDragged])
    {
        DeletePVar(playerid, "DragBy");
        DeletePVar(otherid, "DragBy");
        pData[otherid][pDragged] = 0;
        pData[otherid][pDraggedBy] = INVALID_PLAYER_ID;

        KillTimer(pData[otherid][pDragTimer]);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s releases %s from their grip.", ReturnName(playerid), ReturnName(otherid));
    }
    return 1;
}

CMD:mask(playerid, params[])
{
	if(pData[playerid][pMask] <= 0)
		return Error(playerid, "Anda tidak memiliki topeng!");
		
	switch (pData[playerid][pMaskOn])
    {
        case 0:
        {
        	new sstring[64];
        	new Float:pX, Float:pY, Float:pZ;
        	GetPlayerPos(playerid, pX, pY, pZ);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a mask and puts it on.", ReturnName(playerid));
            pData[playerid][pMaskOn] = 1;
            format(sstring, sizeof(sstring), "%s", ReturnName(playerid));
		    pData[playerid][pMaskLabel] = Create3DTextLabel(sstring, -1, 0, 0, -0.25, 25, playerid, 10);
      		SetPlayerAttachedObject(playerid, 9, 19801, 2, 0.064999, 0.028999, 0.000000, 0.000000, 80.300003, 178.900009, 1.330000, 1.25, 1.125000);
		    Attach3DTextLabelToPlayer(pData[playerid][pMaskLabel], playerid, 0, 0, 0.39);
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 0);
			}
        }
        case 1:
        {
        	Delete3DTextLabel(pData[playerid][pMaskLabel]);
            pData[playerid][pMaskOn] = 0;
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes their mask off and puts it away.", ReturnName(playerid));
            RemovePlayerAttachedObject(playerid, 9);
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 1);
			}
        }
    }
	return 1;
}

CMD:stuck1(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    if(gettime() - pData[playerid][pLastStuck] < 5)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 5 seconds.");

	new
	    Float:x,
    	Float:y,
    	Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z + 0.5);

	ClearAnimations(playerid);
   	StopLoopingAnim(playerid);
	TogglePlayerControllable(playerid, 1);

	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
	SendClientMessage(playerid, COLOR_GREY, "You are no longer stuck.");

	pData[playerid][pLastStuck] = gettime();
	return 1;
}

//Text and Chat Commands
CMD:try(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return Usage(playerid, "/try [action]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s, %s", params[64], (random(2) == 0) ? ("and success") : ("but fail"));
    }
    else {
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s, %s", ReturnName(playerid), params, (random(2) == 0) ? ("and success") : ("but fail"));
    }
	printf("[TRY] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ado(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164], Float:x, Float:y, Float:z;

    if(isnull(params))
	{
        Usage(playerid, "/ado [text]");
		Info(playerid, "Use /ado off to disable or delete the ado tag.");
		return 1;
	}
    if(strlen(params) > 128)
        return Error(playerid, "Max text can only maximmum 128 characters.");

    if (!strcmp(params, "off", true))
    {
        if (!pData[playerid][pAdoActive])
            return Error(playerid, "You're not actived your 'ado' text.");

        if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

        Servers(playerid, "You're removed your ado text.");
        pData[playerid][pAdoActive] = false;
        return 1;
    }

    FixText(params);
    format(flyingtext, sizeof(flyingtext), "* %s *\n(( %s ))", ReturnName(playerid), params);

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [ADO]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [ADO]: %s", params);
    }

    GetPlayerPos(playerid, x, y, z);
    if(pData[playerid][pAdoActive])
    {
        if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            UpdateDynamic3DTextLabelText(pData[playerid][pAdoTag], COLOR_PURPLE, flyingtext);
        else
            pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
    else
    {
        pData[playerid][pAdoActive] = true;
        pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
	printf("[ADO] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ab(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164], Float:x, Float:y, Float:z;

    if(isnull(params))
	{
        Usage(playerid, "/ab [text]");
		Info(playerid, "Use /ab off to disable or delete the ado tag.");
		return 1;
	}
    if(strlen(params) > 128)
        return Error(playerid, "Max text can only maximmum 128 characters.");

    if (!strcmp(params, "off", true))
    {
        if (!pData[playerid][pBActive])
            return Error(playerid, "You're not actived your 'ab' text.");

        if (IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pBTag]);

        Servers(playerid, "You're removed your ab text.");
        pData[playerid][pBActive] = false;
        return 1;
    }

    FixText(params);
    format(flyingtext, sizeof(flyingtext), "* %s *\n(( OOC : %s ))", ReturnName(playerid), params);

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AB]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AB]: %s", params);
    }

    GetPlayerPos(playerid, x, y, z);
    if(pData[playerid][pBActive])
    {
        if (IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            UpdateDynamic3DTextLabelText(pData[playerid][pBTag], COLOR_PURPLE, flyingtext);
        else
            pData[playerid][pBTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
    else
    {
        pData[playerid][pBActive] = true;
        pData[playerid][pBTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
	printf("[AB] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ame(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164];

    if(isnull(params))
        return Usage(playerid, "/ame [action]");

    if(strlen(params) > 128)
        return Error(playerid, "Max action can only maximmum 128 characters.");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AME]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AME]: %s", params);
    }
    format(flyingtext, sizeof(flyingtext), "* %s %s*", ReturnName(playerid), params);
    SetPlayerChatBubble(playerid, flyingtext, COLOR_PURPLE, 10.0, 10000);
	printf("[AME] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:me(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return Usage(playerid, "/me [action]");
	
	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s", ReturnName(playerid), params);
    }
	printf("[ME] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:do(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return Usage(playerid, "/do [description]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s (( %s ))", params[64], ReturnName(playerid));
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnName(playerid));
    }
	printf("[DO] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:toglog(playerid)
{
	if(!pData[playerid][pTogLog])
	{
		pData[playerid][pTogLog] = 1;
		Info(playerid, "Anda telah menonaktifkan log server.");
	}
	else
	{
		pData[playerid][pTogLog] = 0;
		Info(playerid, "Anda telah mengaktifkan log server.");
	}
	return 1;
}

CMD:togpm(playerid)
{
	if(!pData[playerid][pTogPM])
	{
		pData[playerid][pTogPM] = 1;
		Info(playerid, "Anda telah menonaktifkan PM");
	}
	else
	{
		pData[playerid][pTogPM] = 0;
		Info(playerid, "Anda telah mengaktifkan PM");
	}
	return 1;
}

CMD:togads(playerid)
{
	if(!pData[playerid][pTogAds])
	{
		pData[playerid][pTogAds] = 1;
		Info(playerid, "Anda telah menonaktifkan Ads/Iklan.");
	}
	else
	{
		pData[playerid][pTogAds] = 0;
		Info(playerid, "Anda telah mengaktifkan Ads/Iklan.");
	}
	return 1;
}

CMD:togwt(playerid)
{
	if(!pData[playerid][pTogWT])
	{
		pData[playerid][pTogWT] = 1;
		Info(playerid, "Anda telah menonaktifkan Walkie Talkie.");
	}
	else
	{
		pData[playerid][pTogWT] = 0;
		Info(playerid, "Anda telah mengaktifkan Walkie Talkie.");
	}
	return 1;
}

CMD:pmzzs(playerid, params[])
{	
	if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "You must be logged in to use this command!");

    static text[128], otherid;
    if(sscanf(params, "us[128]", otherid, text))
        return Usage(playerid, "/pm [playerid/PartOfName] [message]");

    /*if(pData[playerid][pTogPM])
        return Error(playerid, "You must enable private messaging first.");*/

    /*if(pData[otherid][pAdminDuty])
        return Error(playerid, "You can't pm'ing admin duty now!");*/
		
	if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player yang anda tuju tidak valid.");

    if(otherid == playerid)
        return Error(playerid, "Tidak dapan PM diri sendiri.");

    if(pData[otherid][pTogPM] && pData[playerid][pAdmin] < 1)
        return Error(playerid, "Player tersebut menonaktifkan pm.");

    if(IsPlayerInRangeOfPoint(otherid, 50, 2184.32, -1023.32, 1018.68))
				return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

    //GameTextForPlayer(otherid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~New message!", 3000, 3);
    PlayerPlaySound(otherid, 1085, 0.0, 0.0, 0.0);

    SendClientMessageEx(otherid, COLOR_YELLOW, "(( PM from %s (%d): %s ))", pData[playerid][pName], playerid, text);
    SendClientMessageEx(playerid, COLOR_YELLOW, "(( PM to %s (%d): %s ))", pData[otherid][pName], otherid, text);
	//Info(otherid, "/togpm for tog enable/disable PM");

    foreach(new i : Player) if((pData[i][pAdmin]) && pData[playerid][pSPY] > 0)
    {
        SendClientMessageEx(i, COLOR_LIGHTGREEN, "[SPY PM] %s (%d) to %s (%d): %s", pData[playerid][pName], playerid, pData[otherid][pName], otherid, text);
    }
    return 1;
}

CMD:whisper(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new text[128], otherid;
    if(sscanf(params, "us[128]", otherid, text))
        return Usage(playerid, "/(w)hisper [playerid/PartOfName] [text]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player itu Disconnect or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't whisper yourself.");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(text) > 64) 
	{
        SendClientMessageEx(otherid, COLOR_YELLOW, "** Whisper from %s (%d): %.64s", ReturnName(playerid), playerid, text);
        SendClientMessageEx(otherid, COLOR_YELLOW, "...%s **", text[64]);

        SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s (%d): %.64s", ReturnName(otherid), otherid, text);
        SendClientMessageEx(playerid, COLOR_YELLOW, "...%s **", text[64]);
    }
    else 
	{
        SendClientMessageEx(otherid, COLOR_YELLOW, "** Whisper from %s (%d): %s **", ReturnName(playerid), playerid, text);
        SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s (%d): %s **", ReturnName(otherid), otherid, text);
    }
    SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s mutters something in %s's ear.", ReturnName(playerid), ReturnName(otherid));
	
	foreach(new i : Player) if((pData[i][pAdmin]) && pData[i][pSPY] > 0)
    {
        SendClientMessageEx(i, COLOR_YELLOW2, "[SPY Whisper] %s (%d) to %s (%d): %s", pData[playerid][pName], playerid, pData[otherid][pName], otherid, text);
    }
    return 1;
}

CMD:l(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return Usage(playerid, "/(l)ow [low text]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
	if(IsPlayerInAnyVehicle(playerid))
	{
		foreach(new i : Player)
		{
			if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
			{
				if(strlen(params) > 64) 
				{
					SendClientMessageEx(i, COLOR_WHITE, "[car] %s says: %.64s ..", ReturnName(playerid), params);
					SendClientMessageEx(i, COLOR_WHITE, "...%s", params[64]);
				}
				else 
				{
					SendClientMessageEx(i, COLOR_WHITE, "[car] %s says: %s", ReturnName(playerid), params);
				}
				printf("[CAR] %s(%d) : %s", pData[playerid][pName], playerid, params);
			}
		}
	}
	else
	{
		if(strlen(params) > 64) 
		{
			SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[low] %s says: %.64s ..", ReturnName(playerid), params);
			SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "...%s", params[64]);
		}
		else 
		{
			SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[low] %s says: %s", ReturnName(playerid), params);
		}
		printf("[LOW] %s(%d) : %s", pData[playerid][pName], playerid, params);
	}
    return 1;
}

CMD:s(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return Usage(playerid, "/(s)hout [shout text] /ds for in the door");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 40.0, COLOR_WHITE, "%s shouts: %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 40.0, COLOR_WHITE, "...%s!", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s shouts: %s!", ReturnName(playerid), params);
    }
	new flyingtext[128];
	format(flyingtext, sizeof(flyingtext), "%s!", params);
    SetPlayerChatBubble(playerid, flyingtext, COLOR_WHITE, 10.0, 10000);
	printf("[SHOUTS] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:b(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "OOC Zone, Ketik biasa saja");

    if(isnull(params))
        return Usage(playerid, "/b [local OOC]");
		
	if(pData[playerid][pAdminDuty] == 1)
    {
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), params);
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", params[64]);
		}
		else
        {
            SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", ReturnName(playerid), params);
            return 1;
        }
	}
	else
	{
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{FFFF00}%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), params);
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", params[64]);
		}
		else
        {
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{FFFF00}%s:"WHITE_E" (( %s ))", ReturnName(playerid), params);
            return 1;
        }
	}
	//printf("[OOC] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:t(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(isnull(params))
		return Usage(playerid, "/t [typo text]");

	if(strlen(params) < 10)
	{
		SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s : %.10s*", ReturnName(playerid), params);
	}
	//printf("[OOC] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:nonono(playerid, params[])
{
	if(pData[playerid][pPhone] == 0) 
		return ShowNotifError(playerid, "Kamu tidak memilik phone!", 10000);
	
	if(pData[playerid][pUsePhone] == 0) 
		return Error(playerid, "Handphone anda sedang dimatikan");

	if(pData[playerid][pGpsIns] < 1 && pData[playerid][pTwtIns] < 1 && pData[playerid][pAonaIns] < 1)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "MyTax\nInvoice\nContact\nMBanking\nApp Store", "Select", "Exit");
	}
	else if(pData[playerid][pGpsIns] < 1 && pData[playerid][pTwtIns] < 1 && pData[playerid][pAonaIns] > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "MyTax\nInvoice\nContact\nMBanking\nApp Store\nAds Of News Agency", "Select", "Exit");
	}
	else if(pData[playerid][pGpsIns] > 0 && pData[playerid][pTwtIns] < 1 && pData[playerid][pAonaIns] < 1)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "MyTax\nInvoice\nContact\nMBanking\nApp Store\nGps", "Select", "Exit");
	}
	else if(pData[playerid][pGpsIns] < 1 && pData[playerid][pTwtIns] > 0 && pData[playerid][pAonaIns] < 1)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "MyTax\nInvoice\nContact\nMBanking\nApp Store\nTwitter", "Select", "Exit");
	}
	else if(pData[playerid][pGpsIns] > 0 && pData[playerid][pTwtIns] > 0 && pData[playerid][pAonaIns] < 1)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "MyTax\nInvoice\nContact\nMBanking\nApp Store\nGps\nTwitter", "Select", "Exit");
	}
	else if(pData[playerid][pGpsIns] < 1 && pData[playerid][pTwtIns] > 0 && pData[playerid][pAonaIns] > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "MyTax\nInvoice\nContact\nMBanking\nApp Store\nAds of News Agency\nTwitter", "Select", "Exit");
	}
	else if(pData[playerid][pGpsIns] > 0 && pData[playerid][pTwtIns] < 1 && pData[playerid][pAonaIns] > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "MyTax\nInvoice\nContact\nMBanking\nApp Store\nAds of News Agency\nGps", "Select", "Exit");
	}
	else if(pData[playerid][pGpsIns] > 0 && pData[playerid][pTwtIns] > 0 && pData[playerid][pAonaIns] > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "MyTax\nInvoice\nContact\nMBanking\nApp Store\nTwitter\nGps\nAds of New Agency", "Select", "Exit");
	}
	return 1;
}

forward DownloadTwitter(playerid);
public DownloadTwitter(playerid)
{
	pData[playerid][pTwtIns] = 1;
	pData[playerid][pPhoneCredit] -= 6;
	Info(playerid, "Twitter successfully downloaded");
}

forward DownloadGps(playerid);
public DownloadGps(playerid)
{
	pData[playerid][pGpsIns] = 1;
	pData[playerid][pPhoneCredit] -= 8;
	Info(playerid, "Gps successfully downloaded");
}

forward DownloadAona(playerid);
public DownloadAona(playerid)
{
	pData[playerid][pAonaIns] = 1;
	pData[playerid][pPhoneCredit] -= 8;
	Info(playerid, "Gps successfully downloaded");
}

CMD:p(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
		return Error(playerid, "Anda sudah sedang menelpon seseorang!");
		
	if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");
		
	foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			pData[ii][pPhoneCredit]--;
			
			pData[playerid][pCall] = ii;
			SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
			SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s answers their cellphone.", ReturnName(playerid));
			return 1;
		}
	}
	return 1;
}

CMD:hu(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new caller = pData[playerid][pCall];
	if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
	{
		new ppid = pData[playerid][pGetPAYPHONEID], ppoid = pData[caller][pGetPAYPHONEID];

		if(pData[playerid][pGetPAYPHONEID] != -1)
		{
			pData[caller][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
			SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
			
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their payphone.", ReturnName(playerid));
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

			ppData[ppid][ppStatus] = 0;
			pData[playerid][pGetPAYPHONEID] = -1;

			Payphone_Refresh(ppid);
			Payphone_Save(ppid);
			if(pData[caller][pGetPAYPHONEID] != -1)
			{
				ppData[ppoid][ppStatus] = 0;
				pData[caller][pGetPAYPHONEID] = -1;

				Payphone_Refresh(ppoid);
				Payphone_Save(ppoid);
			}
		}
		else if(pData[caller][pGetPAYPHONEID] != -1)
		{
			pData[caller][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
			SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their payphone.", ReturnName(caller));
			
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

			ppData[ppoid][ppStatus] = 0;
			pData[caller][pGetPAYPHONEID] = -1;

			Payphone_Refresh(ppoid);
			Payphone_Save(ppoid);
			return 1;
		}
		else
		{
			pData[caller][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
			SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
			
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			return 1;
		}
	}
	return 1;
}

CMD:sms(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new ph, text[50];
	//if(pData[playerid][pPhone] == 0) return Error(playerid, "Anda tidak memiliki Ponsel!");

	if(pData[playerid][pPhone] == 0) 
		return ShowNotifError(playerid, "Kamu tidak memilik phone!", 10000);
	
	if(pData[playerid][pPhoneCredit] <= 0) return Error(playerid, "Anda tidak memiliki Ponsel credits!");
	if(pData[playerid][pInjured] != 0) return Error(playerid, "You cant do at this time.");

	if(sscanf(params, "ds[50]", ph, text))
        return Usage(playerid, "/sms [phone number] [message max 50 text]");
	
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][pUsePhone] == 0) return Error(playerid, "Tidak dapat SMS, Ponsel tersebut yang dituju sedang Offline");

			if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
				return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

			if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");
			SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", ph, text);
			SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], text);
			Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
			PlayerPlaySound(ii, 6003, 0,0,0);
			pData[ii][pSMS] = pData[playerid][pPhone];
			
			pData[playerid][pPhoneCredit] -= 1;
			return 1;
		}
	}
	return 1;
}

CMD:setfreq(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	//if(Inventory_Count(playerid, "Portable Radio") < 1)
		//return ShowNotifError(playerid, "Kamu tidak memilik walkie talkie!", 10000);
	
	new channel;
	if(sscanf(params, "d", channel))
		return Usage(playerid, "/setfreq [channel 1 - 1000]");
	
	if(pData[playerid][pTogWT] == 1) return Error(playerid, "Your walkie talkie is turned off.");
	if(channel == pData[playerid][pWT]) return Error(playerid, "You are already in this channel.");
	
	if(channel > 0 && channel <= 1000)
	{
		foreach(new i : Player)
		{
		    if(pData[i][pWT] == channel)
		    {
				SendClientMessageEx(i, COLOR_LIME, "[WT] "WHITE_E"%s has joined in to this channel!", ReturnName(playerid));
		    }
		}
		Info(playerid, "You have set your walkie talkie channel to "LIME_E"%d", channel);
		pData[playerid][pWT] = channel;
	}
	else
	{
		Error(playerid, "Invalid channel id! 1 - 1000");
	}
	return 1;
}

CMD:wt(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pInjured] != 0)
	 	return Error(playerid, "Kamu tidak bisa melakukan ini ketika sedang injured");

	//if(Inventory_Count(playerid, "Portable Radio") < 1)
		//return ShowNotifError(playerid, "Kamu tidak memilik walkie talkie!", 10000);
		
	if(pData[playerid][pTogWT] == 1)
		return Error(playerid, "Your walkie talkie is turned off!");
	
	new msg[128];
	if(sscanf(params, "s[128]", msg)) return Usage(playerid, "/wt [message]");
	foreach(new i : Player)
	{
	    if(pData[i][pTogWT] == 0)
	    {
	        if(pData[i][pWT] == pData[playerid][pWT])
	        {
					SendClientMessageEx(i, COLOR_LIME, "[WT] "WHITE_E"%s: %s", ReturnName(playerid), msg);
		       
		    }
	    }
	}
	return 1;
}

/*CMD:savestats(playerid, params[])
{
	UpdateWeapons(playerid);
	UpdatePlayerData(playerid);
	Info(playerid, "Your data have been saved!");
	return 1;
}*/

CMD:ads(playerid, params[])
{
	if(pData[playerid][pVip] != 0)
	{
		if(GetPVarInt(playerid, "delay") > gettime()) 
			return ShowNotifError(playerid, "Mohon Tunggu 10 Menit Untuk Menggunakan kembali.", 10000);

		if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
			return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

		if(pData[playerid][pPhone] == 0) 
			return Error(playerid, "Anda tidak memiliki Ponsel!");
		
		if(isnull(params))
		{
			Usage(playerid, "/ads [text] | 1 character pay $2");
			return 1;
		}
		if(strlen(params) >= 100 ) return Error(playerid, "Maximum character is 100 text." );
		new payout = strlen(params) * 2;
		if(pData[playerid][pMoney] < payout) return Error(playerid, "Not enough money.");
		
		GivePlayerMoneyEx(playerid, -payout);
		Server_AddMoney(payout);
		SetPVarInt(playerid, "delay", gettime() + 600);
		foreach(new ii : Player)
		{
			if(pData[ii][pTogAds] == 0)
			{
				SendClientMessageEx(ii, COLOR_ORANGE2, "[IKLAN] "GREEN_E"%s.", params);
				SendClientMessageEx(ii, COLOR_ORANGE2, "Contact Info: ["GREEN_E"%s"ORANGE_E2"] Ph: ["GREEN_E"%d"ORANGE_E2"] Bank Rek: ["GREEN_E"%d"ORANGE_E2"]", pData[playerid][pName], pData[playerid][pPhone], pData[playerid][pBankRek]);
			}
		}
		Add_AdsLog(playerid, params);
	}
	else
	{
		if(GetPVarInt(playerid, "delay") > gettime()) 
			return ShowNotifError(playerid, "Mohon Tunggu 10 Menit Untuk Menggunakan kembali.", 10000);

		if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
			return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

		if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2360.01, -284.87, 1303.75)) 
			return Error(playerid, "You must in SANA Station!");
		
		if(pData[playerid][pPhone] == 0) 
			return Error(playerid, "Anda tidak memiliki Ponsel!");
		
		if(isnull(params))
		{
			Usage(playerid, "/ads [text] | 1 character pay $2");
			return 1;
		}
		if(strlen(params) >= 100 ) return Error(playerid, "Maximum character is 100 text." );
		new payout = strlen(params) * 2;
		if(pData[playerid][pMoney] < payout) return Error(playerid, "Not enough money.");
		
		GivePlayerMoneyEx(playerid, -payout);
		Server_AddMoney(payout);
		SetPVarInt(playerid, "delay", gettime() + 600);
		foreach(new ii : Player)
		{
			if(pData[ii][pTogAds] == 0)
			{
				SendClientMessageEx(ii, COLOR_ORANGE2, "[IKLAN] "GREEN_E"%s.", params);
				SendClientMessageEx(ii, COLOR_ORANGE2, "Contact Info: ["GREEN_E"%s"ORANGE_E2"] Ph: ["GREEN_E"%d"ORANGE_E2"] Bank Rek: ["GREEN_E"%d"ORANGE_E2"]", pData[playerid][pName], pData[playerid][pPhone], pData[playerid][pBankRek]);
			}
		}
		Add_AdsLog(playerid, params);
	}
	return 1;
}


//------------------[ Bisnis and Buy Commands ]-------
CMD:buy(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	//Material
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -258.23, -2189.83, 28.97))
	{
		if(pData[playerid][pMaterial] >= 500) return Error(playerid, "Anda sudah membawa 500 Material!");
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah material:\nMaterial Stock: "GREEN_E"%d\n"WHITE_E"Material Price"GREEN_E"%s / item", Material, FormatMoney(MaterialPrice));
		ShowPlayerDialog(playerid, DIALOG_MATERIAL, DIALOG_STYLE_INPUT, "Buy Material", mstr, "Buy", "Cancel");
	}
	//Component
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 601.71, 867.77, -42.96))
	{
		if(pData[playerid][pComponent] >= 500) return Error(playerid, "Anda sudah membawa 500 Component!");
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah component:\nComponent Stock: "GREEN_E"%d\n"WHITE_E"Component Price"GREEN_E"%s / item", Component, FormatMoney(ComponentPrice));
		ShowPlayerDialog(playerid, DIALOG_COMPONENT, DIALOG_STYLE_INPUT, "Buy Component", mstr, "Buy", "Cancel");
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1996.39, -2065.53, 13.54))
	{
		if(pData[playerid][pDaging] >= 500) return Error(playerid, "Anda sudah membawa 500 Daging!");
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah daging:\nDaging Stock: "GREEN_E"%d\n"WHITE_E"Harga Daging"GREEN_E"%s / item", Daging, FormatMoney(DagingPrice));
		ShowPlayerDialog(playerid, DIALOG_DAGING, DIALOG_STYLE_INPUT, "Beli Daging", mstr, "Buy", "Cancel");
	}
	//Apotek
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 2856.2964,1250.2919,-64.3797))
	{
		if(pData[playerid][pFaction] != 3)
			return Error(playerid, "Medical only!");
			
		new mstr[258];
		format(mstr, sizeof(mstr), "Product\tPrice\n\
		Medicine\t"GREEN_E"%s\n\
		Medkit\t"GREEN_E"%s\n\
		Bandage\t"GREEN_E"$100\n\
		Obat Stress\t"GREEN_E"$750\n\
		", FormatMoney(MedicinePrice), FormatMoney(MedkitPrice));
		ShowPlayerDialog(playerid, DIALOG_APOTEK, DIALOG_STYLE_TABLIST_HEADERS, "Apotek", mstr, "Buy", "Cancel");
	}
	//Food and Seed
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -382.97, -1426.43, 26.31))
	{
		new mstr[128];
		format(mstr, sizeof(mstr), "Product\tPrice\n\
		Food\t"GREEN_E"%s\n\
		Seed\t"GREEN_E"%s\n\
		", FormatMoney(FoodPrice), FormatMoney(SeedPrice));
		ShowPlayerDialog(playerid, DIALOG_FOOD, DIALOG_STYLE_TABLIST_HEADERS, "Food", mstr, "Buy", "Cancel");
	}
	//Drugs
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 2653.3169,-2410.5852,3001.0859))
	{
		if(pData[playerid][pMarijuana] >= 100) return Error(playerid, "Anda sudah membawa 100 kg Marijuana!");
		
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah marijuana:\nMarijuana Stock: "GREEN_E"%d\n"WHITE_E"Marijuana Price"GREEN_E"%s / item", Marijuana, FormatMoney(MarijuanaPrice));
		ShowPlayerDialog(playerid, DIALOG_DRUGS, DIALOG_STYLE_INPUT, "Buy Drugs", mstr, "Buy", "Cancel");
	}
	//NPC Family
	foreach(new nfid : NPCFam)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, nfData[nfid][nfPosX], nfData[nfid][nfPosY], nfData[nfid][nfPosZ]))
		{
			if(pData[playerid][pLevel] < 3)
				return Error(playerid, "Kamu harus level 3 untuk mengakses ini");
			
			pData[playerid][pGetNPCFAMID] = nfid;
			Npcfam_BuyMenu(playerid, nfid);
		}
	}
	//Buy Vending
	foreach(new venid : Vending)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]))
		{

			if(vmData[venid][venPrice] > pData[playerid][pMoney]) 
				return Error(playerid, "Not enough money, you can't afford this vending.");

			if(strcmp(vmData[venid][venOwner], "-")) 
				return Error(playerid, "Someone already owns this vending.");

			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 2) return Error(playerid, "You can't buy any more vending machine.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 3) return Error(playerid, "You can't buy any more vending machine.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 4) return Error(playerid, "You can't buy any more vending machine.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more vending machine.");
				#endif
			}

			GivePlayerMoneyEx(playerid, -vmData[venid][venPrice]);
			Server_AddMoney(vmData[venid][venPrice]);

			GetPlayerName(playerid, vmData[venid][venOwner], MAX_PLAYER_NAME);
			vmData[venid][venVisit] = gettime() + (86400 * 30);
			
			Vending_Save(venid);
			Vending_Refresh(venid);
		}
	}
	//Buy Workshop
	foreach(new wid : Workshop)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
		{

			if(wData[wid][wPrice] > pData[playerid][pMoney]) 
				return Error(playerid, "Not enough money, you can't afford this workshop.");

			if(strcmp(wData[wid][wLeader], "-")) 
				return Error(playerid, "Someone already owns this workshop.");

			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif
			}

			if(pData[playerid][pWorkshop] != -1) 
				return Error(playerid, "Kamu harus keluar dari anggota workshop lain!");

			GivePlayerMoneyEx(playerid, -wData[wid][wPrice]);
			Server_AddMoney(wData[wid][wPrice]);
			GetPlayerName(playerid, wData[wid][wLeader], MAX_PLAYER_NAME);
			Workshop_Save(wid);
			Workshop_Refresh(wid);

			pData[playerid][pWorkshop] = wid;
			pData[playerid][pWorkshopRank] = 6;
			UpdatePlayerData(playerid);
		}
	}
	//Buy House
	foreach(new hid : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
		{
			if(hData[hid][hPrice] > pData[playerid][pMoney]) return Error(playerid, "Not enough money, you can't afford this houses.");
			if(strcmp(hData[hid][hOwner], "-")) return Error(playerid, "Someone already owns this house.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 2) return Error(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 3) return Error(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 4) return Error(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 1) return Error(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -hData[hid][hPrice]);
			Server_AddMoney(hData[hid][hPrice]);
			GetPlayerName(playerid, hData[hid][hOwner], MAX_PLAYER_NAME);
			hData[hid][hVisit] = gettime() + (86400 * 30);
			
			House_Refresh(hid);
			House_Save(hid);
		}
	}
	//Buy Private Farmer
	foreach(new pfid : PFarm)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]))
		{
			if(pfData[pfid][pfPrice] > pData[playerid][pMoney]) return Error(playerid, "Not enough money, you can't afford this private farmer.");
			if(strcmp(pfData[pfid][pfOwner], "-")) return Error(playerid, "Someone already owns this private farmer.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_PfarmCount(playerid) + 1 > 2) return Error(playerid, "Anda tidak dapat membeli private farmer lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_PfarmCount(playerid) + 1 > 3) return Error(playerid, "Anda tidak dapat membeli private farmer lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_PfarmCount(playerid) + 1 > 4) return Error(playerid, "Anda tidak dapat membeli private farmer lagi.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_PfarmCount(playerid) + 1 > 1) return Error(playerid, "Anda tidak dapat membeli private farmer lagi.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -pfData[pfid][pfPrice]);
			Server_AddMoney(-pfData[pfid][pfPrice]);
			GetPlayerName(playerid, pfData[pfid][pfOwner], MAX_PLAYER_NAME);
			pfData[pfid][pfVisit] = gettime() + (86400 * 30);
			
			Pfarm_Refresh(pfid);
			Pfarm_Save(pfid);
		}
	}
	//Buy Dealer
	foreach(new deid : Dealer)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, drData[deid][dPosX], drData[deid][dPosY], drData[deid][dPosZ]))
		{
			if(drData[deid][dPrice] > pData[playerid][pMoney]) return Error(playerid, "Not enough money, you can't afford this dealer.");
			if(strcmp(drData[deid][dOwner], "-")) return Error(playerid, "Someone already owns this dealer.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 2) return Error(playerid, "Anda tidak dapat membeli dealer lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 3) return Error(playerid, "Anda tidak dapat membeli dealer lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 4) return Error(playerid, "Anda tidak dapat membeli dealer lagi.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 1) return Error(playerid, "Anda tidak dapat membeli dealer lagi.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -drData[deid][dPrice]);
			Server_AddMoney(-drData[deid][dPrice]);
			GetPlayerName(playerid, drData[deid][dOwner], MAX_PLAYER_NAME);
			drData[deid][dVisit] = gettime() + (86400 * 30);
			
			Dealer_Refresh(deid);
			Dealer_Save(deid);
		}
	}
	//Buy Bisnis
	foreach(new bid : Bisnis)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
		{
			if(bData[bid][bPrice] > pData[playerid][pMoney]) return Error(playerid, "Not enough money, you can't afford this bisnis.");
			if(strcmp(bData[bid][bOwner], "-")) return Error(playerid, "Someone already owns this bisnis.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 2) return Error(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 3) return Error(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 4) return Error(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 1) return Error(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -bData[bid][bPrice]);
			Server_AddMoney(-bData[bid][bPrice]);
			GetPlayerName(playerid, bData[bid][bOwner], MAX_PLAYER_NAME);
			bData[bid][bVisit] = gettime() + (86400 * 30);
			
			Bisnis_Refresh(bid);
			Bisnis_Save(bid);
		}
	}
	//Ayamfill
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -1101.9401,-1654.8589,76.3672))
	{
		if(pData[playerid][pFaction] != 5)
			return Error(playerid, "Pedagang only!");

		if(pData[playerid][AyamFillet] >= 100) return Error(playerid, "Anda sudah membawa 100 kg AyamFillet!");

		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah ayam:\nAyam Stock: "GREEN_E"%d\n"WHITE_E"Ayam Price"GREEN_E"%s / item", AyamFill, FormatMoney(AyamFillPrice));
		ShowPlayerDialog(playerid, DIALOG_AYAMFILL, DIALOG_STYLE_INPUT, "Buy Ayam", mstr, "Buy", "Cancel");
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -1106.8861,-1637.5360,76.3672))
	{
		if(pData[playerid][pBulu] >= 100) return Error(playerid, "Anda sudah membawa 100 Bulu!");

		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah bulu:\nBulu Stock: "GREEN_E"%d\n"WHITE_E"Bulu Price"GREEN_E"%s / item", BuluAyam, FormatMoney(BuluAyamPrice));
		ShowPlayerDialog(playerid, DIALOG_BULUAYAM, DIALOG_STYLE_INPUT, "Bulu Ayam", mstr, "Buy", "Cancel");
	}
	//Buy Bisnis menu
	if(pData[playerid][pInBiz] >= 0 && IsPlayerInRangeOfPoint(playerid, 2.5, bData[pData[playerid][pInBiz]][bPointX], bData[pData[playerid][pInBiz]][bPointY], bData[pData[playerid][pInBiz]][bPointZ]))
	{
		Bisnis_BuyMenu(playerid, pData[playerid][pInBiz]);
	}
	return 1;
}

CMD:licenses(playerid, params[])
{
	new String[512], text1[1401], text2[1401], text4[1401];
	if(pData[playerid][pDriveLic]) { text1 = "{FFFFFF}[{00BF00}Passed{FFFFFF}]"; } else { text1 = "{FFFFFF}[{FFF00F}Not Passed{FFFFFF}]"; }
	if(pData[playerid][pTruckLic]) { text4 = "{FFFFFF}[{00BF00}Passed{FFFFFF}]"; } else { text4 = "{FFFFFF}[{FFF00F}Not Passed{FFFFFF}]"; }
	if(pData[playerid][pLumberLic]) { text2 = "{FFFFFF}[{00BF00}Passed{FFFFFF}]"; } else { text2 = "{FFFFFF}[{FFF00F}Not Passed{FFFFFF}]"; }
	SendClientMessageEx(playerid, COLOR_RED, "========Your Licenses========");
	format(String, sizeof(String), "{FFFFFF}** Driver's license: %s.", text1);
	SendClientMessageEx(playerid, COLOR_WHITE, String);
	format(String, sizeof(String), "{FFFFFF}** Truck license: %s.", text4);
	SendClientMessageEx(playerid, COLOR_WHITE, String);
	format(String, sizeof(String), "{FFFFFF}** Lumber Jack license: %s.", text2);
	SendClientMessageEx(playerid, COLOR_WHITE, String);
	SendClientMessageEx(playerid, COLOR_RED, "=============================");
	SendClientMessage(playerid, COLOR_RED, "NOTE: {FFFFFF}use '/showlic' to show licenses to other player!");
	return 1;
}

CMD:showlic(playerid, params[])
{
	new String[512], text1[1401], text2[1401], text3[1401], text4[1401];
	if(pData[playerid][pDriveLic]) 
	{ 
		text1 = "{FFFFFF}[{00BF00}Passed{FFFFFF}]"; 
	} 
	else 
	{ 
		text1 = "{FFFFFF}[{FFF00F}Not Passed{FFFFFF}]"; 
	}

	if(pData[playerid][pWeapLic]) 
	{ 
		text2 = "{FFFFFF}[{00BF00}Passed{FFFFFF}]"; 
	} 
	else 
	{ 
		text2 = "{FFFFFF}[{FFF00F}Not Passed{FFFFFF}]"; 
	}

	if(pData[playerid][pTruckLic]) 
	{ 
		text3 = "{FFFFFF}[{00BF00}Passed{FFFFFF}]"; 
	} 
	else 
	{ 
		text3 = "{FFFFFF}[{FFF00F}Not Passed{FFFFFF}]"; 
	}

	if(pData[playerid][pLumberLic]) 
	{ 
		text4 = "{FFFFFF}[{00BF00}Passed{FFFFFF}]"; 
	} 
	else 
	{ 
		text4 = "{FFFFFF}[{FFF00F}Not Passed{FFFFFF}]"; 
	}
	SendNearbyMessage(playerid, 20.0, COLOR_YELLOW, "========Licenses========");
	format(String, sizeof(String), "{FFFFFF}** Driver's license: %s.", text1);
	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, String);
	format(String, sizeof(String), "{FFFFFF}** Weapon's license: %s.", text2);
	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, String);
	format(String, sizeof(String), "{FFFFFF}** Truck license: %s.", text3);
	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, String);
	format(String, sizeof(String), "{FFFFFF}** Lumber Jack license: %s.", text4);
	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, String);
	SendNearbyMessage(playerid, 20.0, COLOR_YELLOW, "==========================");
	return 1;
}

CMD:jobcenter(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 2.0, 906.96, 256.46, 1289.98)) ShowNotifError(playerid, "Kamu tidak di balaikota", 5000);
	{
		ShowPlayerDialog(playerid, DIALOG_JOBCENTER, DIALOG_STYLE_LIST, "JOB CENTER", "JOB 1\nJOB 2", "Select", "Close");
	}
	return 1;
}

CMD:balkotcenter(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 2.0, 1376.4336,1573.7515,17.0003)) ShowNotifError(playerid, "Kamu tidak di balai kota", 5000);
	{
		ShowPlayerDialog(playerid, DIALOG_BALKOT, DIALOG_STYLE_LIST, "BALKOT CENTER", "Mengambil Id Card\nMenggubah Umur\nJual Rumah\nJual Bisnis\nJual Dealer\nPay Tax", "Select", "Close");
	}
	return 1;
}

CMD:menuplayer(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_MENU_PLAYER, DIALOG_STYLE_LIST, "Menu Player", "Inventory\nDokumen Pribadi\nPhone", "Select", "Close");
	return 1;
}

CMD:menufarmer(playerid, params[])
{
	//Food and Seed
	if(IsPlayerInRangeOfPoint(playerid, 3.5, -382.97, -1426.43, 26.31))
	{
		new mstr[128];
		format(mstr, sizeof(mstr), "Product\n\
		Buy Food\n\
		Buy Seed\n\
		Buy Gandum\n\
		");
		ShowPlayerDialog(playerid, DIALOG_FOOD, DIALOG_STYLE_TABLIST_HEADERS, "Job Farmer", mstr, "Select", "Cancel");
	}
	else return ShowNotifError(playerid, "Kamu tidak di penjualan atau pembelian farmer!", 10000);
	return 1;
}

CMD:menumilk(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 313.61, 1147.21, 8.58))
	{
		new mstr[128];
		format(mstr, sizeof(mstr), "Product Susu\n\
			Buy Susu\n\
			Sell Susu\n\
		");
		ShowPlayerDialog(playerid, DIALOG_MILK, DIALOG_STYLE_TABLIST_HEADERS, "Job Milk", mstr, "Select", "Cancel");
	}
	else return ShowNotifError(playerid, "Kamu tidak di penjualan atau pembelian susu!", 10000);
	return 1;
}

CMD:fonline(playerid, params[])
{
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 1)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
		else if(pData[i][pFaction] == 2)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
		else if(pData[i][pFaction] == 3)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
		else if(pData[i][pFaction] == 4)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
		else if(pData[i][pFaction] == 5)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Faction Online", lstr, "Close", "");

	return 1;
}

CMD:buyveh(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 907.71, -1735.62, -55.57)) return Error(playerid, "Anda harus berada di showroom kendaraan Konoha!");
	{
		ShowPlayerDialog(playerid, DIALOG_BUY_VEHICLE, DIALOG_STYLE_LIST, "DEALER KENDARAAN - {004BFF}Konoha", "BELI KENDARAAN\nRENTAL KENDARAAN", "Select", "Cancel");
	} 
	return 1;
}

stock KeyYGen(playerid, string[], time)//Time in Sec.
{
	new validtime = time*1000;

	if (pData[playerid][altruq])
	{
	    KillTimer(pData[playerid][altruqq]);
	}
	PlayerTextDrawSetString(playerid, PRESSKEY_GENZO[playerid][3], string);
	//PlayerTextDrawSetString(playerid, PRESSKEY_GENZO[playerid][2], "Y");
	PlayerTextDrawShow(playerid, PRESSKEY_GENZO[playerid][0]);
	PlayerTextDrawShow(playerid, PRESSKEY_GENZO[playerid][1]);
	PlayerTextDrawShow(playerid, PRESSKEY_GENZO[playerid][2]);
	PlayerTextDrawShow(playerid, PRESSKEY_GENZO[playerid][3]);
    PlayerPlaySound(playerid, 1057 , 0.0, 0.0, 0.0);
	pData[playerid][altruq] = true;
	pData[playerid][altruqq] = SetTimerEx("HideTdAltRuq", validtime, false, "d", playerid);
	return 1;
}

function HideTdAltRuq(playerid)
{
	if (!pData[playerid][altruq])
	    return 0;

	pData[playerid][altruq] = false;
	return HideAltruq(playerid);
}

stock HideAltruq(playerid)
{
    PlayerTextDrawHide(playerid, PRESSKEY_GENZO[playerid][0]);
	PlayerTextDrawHide(playerid, PRESSKEY_GENZO[playerid][1]);
	PlayerTextDrawHide(playerid, PRESSKEY_GENZO[playerid][2]);
	PlayerTextDrawHide(playerid, PRESSKEY_GENZO[playerid][3]);
	return 1;
}

stock Altgenzotd(playerid, string[], time)//Time in Sec.
{
	new validtime = time*1000;

	if (pData[playerid][altruq])
	{
	    KillTimer(pData[playerid][altruqq]);
	}
	PlayerTextDrawSetString(playerid, PRESSALT_GENZO[playerid][3], string);
	PlayerTextDrawShow(playerid, PRESSALT_GENZO[playerid][0]);
	PlayerTextDrawShow(playerid, PRESSALT_GENZO[playerid][1]);
	PlayerTextDrawShow(playerid, PRESSALT_GENZO[playerid][2]);
	PlayerTextDrawShow(playerid, PRESSALT_GENZO[playerid][3]);
    PlayerPlaySound(playerid, 1057 , 0.0, 0.0, 0.0);
	pData[playerid][altruq] = true;
	pData[playerid][altruqq] = SetTimerEx("HideatlGenzo", validtime, false, "d", playerid);
	return 1;
}

function HideatlGenzo(playerid)
{
	if (!pData[playerid][altruq])
	    return 0;

	pData[playerid][altruq] = false;
	return HideAltGen(playerid);
}

stock HideAltGen(playerid)
{
    PlayerTextDrawHide(playerid, PRESSALT_GENZO[playerid][0]);
	PlayerTextDrawHide(playerid, PRESSALT_GENZO[playerid][1]);
	PlayerTextDrawHide(playerid, PRESSALT_GENZO[playerid][2]);
	PlayerTextDrawHide(playerid, PRESSALT_GENZO[playerid][3]);
	return 1;
}