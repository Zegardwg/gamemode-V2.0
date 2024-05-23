//----------------[ Dialog System ]--------------

//----------[ Dialog Login Register]----------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	printf("[OnDialogResponse]: %s(%d) has used dialog id: %d Listitem: %d", pData[playerid][pUCP], playerid, dialogid, listitem);
	if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);

		new hashed_pass[65];
		SHA256_PassHash(inputtext, pData[playerid][pSalt], hashed_pass, 65);

		if (strcmp(hashed_pass, pData[playerid][pPassword]) == 0)
		{
			new query1[256];
			//mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", pData[playerid][pName]);
			//mysql_pquery(g_SQL, query, "AssignPlayerData", "d", playerid);
			CheckPlayerChar(playerid);
			printf("[LOGIN] %s(%d) berhasil login dengan password(%s)", pData[playerid][pUCP], playerid, inputtext);
			Servers(playerid, "Silahkan pilih karakter yang akan anda mainkan");

			mysql_format(g_SQL, query1, sizeof(query1), "INSERT INTO loglogin (username,reg_id,password,time) VALUES('%s','%d','%s',CURRENT_TIMESTAMP())", pData[playerid][pUCP], pData[playerid][pID], inputtext);
			mysql_tquery(g_SQL, query1);
			
		}
		else
		{
			pData[playerid][LoginAttempts]++;

			if (pData[playerid][LoginAttempts] >= 3)
			{
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "UCP - Login", "Kamu Telah Salah Memasukkan Password Sebanyak (3 kali).", "Okay", "");
				KickEx(playerid);
			}
			else 
			{
				new lstring[300];
				format(lstring, sizeof lstring, "{ffffff}Welcome back to {15D4ED}Konoha\n{ffffff}Account: {15D4ED}%s\n{ffffff}Attemps: {FF0000}%i/3{ffffff}\nPassword: {3BBD44}(input below)\n\n{FF0000}Wrong password!", pData[playerid][pUCP], pData[playerid][LoginAttempts]);
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login - Konoha", lstring, "Masuk", "Keluar");
				Error(playerid, "Password yang anda masukan salah!");
			}
		}
        return 1;
    }
    if(dialogid == DIALOG_REGISTER)
    {
		if (!response) return Kick(playerid);
	
		if (strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Konoha", "Kata sandi minimal 5 Karakter!\nMohon isi Password dibawah ini:", "Register", "Tolak");
		
		if(!IsValidPassword(inputtext))
		{
			Error(playerid, "Sandi valid : A-Z, a-z, 0-9, _, [ ], ( )");
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Konoha", "Kata sandi yang anda gunakan mengandung karakter yang valid!\nMohon isi Password dibawah ini:", "Register", "Tolak");
			return 1;
		}
		
		for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
		SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

		new query[842], PlayerIP[16];
		GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
		pData[playerid][pExtraChar] = 0;
		mysql_format(g_SQL, query, sizeof query, "UPDATE playerucp SET password = '%s', salt = '%e', extrac = '%d' WHERE ucp = '%e'", pData[playerid][pPassword], pData[playerid][pSalt], pData[playerid][pExtraChar], pData[playerid][pUCP]);
		mysql_tquery(g_SQL, query, "CheckPlayerChar", "i", playerid);//rung bar
		return 1;
	}
	if(dialogid == DIALOG_VERIFYCODE)
	{
		if(response)
		{
			new str[200];
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "UCP: {00FFE5}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT", pData[playerid][pUCP]);
				return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Cancel");
			}
			if(!IsNumeric(inputtext))
			{
				format(str, sizeof(str), "UCP: {00FFE5}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT\n\n{FF0000}PIN hanya berisi 6 Digit angka bukan huruf", pData[playerid][pUCP]);
				return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Cancel");	
			}
			if(strval(inputtext) == pData[playerid][pVerifyCode])
			{
				new lstring[512];
				format(lstring, sizeof lstring, "{ffffff}Welcome to {00FFE5}"SERVER_NAME"\n{ffffff}UCP: {00FFE5}%s\n{ffffff}Password: \nSilahkan buat password baru kamu!:", pData[playerid][pUCP]);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Konoha", lstring, "Register", "Quit");
				return 1;
			}

			format(str, sizeof(str), "UCP: {00FFE5}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT\n\n{FF0000}PIN salah!", pData[playerid][pUCP]);
			return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Cancel");	
		}
		else 
		{
			Kick(playerid);
		}
	}
	if(dialogid == DIALOG_CHARLIST)
    {
		if(response)
		{
			if(PlayerChar[playerid][listitem][0] == EOS)
				return ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Pembuatan Karakter", "Selamat Datang di {00FFE5}Konoha\n{ffffff}sebelum bermain anda harus membuat karakter terlebih dahulu\n{ffffff}Masukan nama karakter dengan kultur/nama orang Indonesia\n\nCth: Dadang_Sutarman, Doni_Suwandi.", "Input", "");
			pData[playerid][pChar] = listitem;
			SetPlayerName(playerid, PlayerChar[playerid][listitem]);	
			new cQuery[256];
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT * FROM `players` WHERE `username` = '%s' LIMIT 1;", PlayerChar[playerid][pData[playerid][pChar]]);
			mysql_tquery(g_SQL, cQuery, "AssignPlayerData", "d", playerid);		
		}
	}
	if(dialogid == DIALOG_MAKE_CHAR)
	{
	    if(response)
	    {
		    if(strlen(inputtext) < 1 || strlen(inputtext) > 24)
				return ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Pembuatan Karakter", "Selamat Datang di {00FFE5}Konoha\n{ffffff}sebelum bermain anda harus membuat karakter terlebih dahulu\n{ffffff}Masukan nama karakter dengan kultur/nama orang Indonesia\n\nCth: Dadang_Sutarman, Doni_Suwandi.", "Input", "");
			if(!IsValidRoleplayName(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Pembuatan Karakter", "Selamat Datang di {00FFE5}Konoha\n{ffffff}sebelum bermain anda harus membuat karakter terlebih dahulu\n{ffffff}Masukan nama karakter dengan kultur/nama orang Indonesia\n\nCth: Dadang_Sutarman, Doni_Suwandi.", "Input", "");
			//if()	
			new characterQuery[178];
			mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s'", inputtext);
			mysql_tquery(g_SQL, characterQuery, "CekNamaDobelJing", "ds", playerid, inputtext);
		    format(pData[playerid][pUCP], 22, GetName(playerid));
		}
	}
	if(dialogid == DIALOG_PASSWORD)
	{
		if(response)
		{
			if(!(3 < strlen(inputtext) < 20))
			{
				Error(playerid, "Please insert a valid password! Must be between 4-20 characters.");
				callcmd::changepass(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Password can contain only A-Z, a-z, 0-9, _, [ ], ( )");
				callcmd::changepass(playerid);
				return 1;
			}
			new query[512];
			for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
			SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE playerucp SET password='%s', salt='%e' WHERE ucp='%e'", pData[playerid][pPassword], pData[playerid][pSalt], pData[playerid][pUCP]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your password has been updated to "YELLOW_E"'%s'", inputtext);
		}
	}
	if(dialogid == DIALOG_AGE)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tanggal Lahir", "Mohon masukan tanggal lahir sesuai format hh/bb/tttt cth:(23/03/2002)", "Input", "");
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;
				
			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tanggal Lahir", "Kesalahan! Tidak sah\nMohon masukan tanggal lahir sesuai format hh/bb/tttt cth:(23/03/2002)", "Input", "");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tanggal Lahir", "Kesalahan! Tidak sah\nMohon masukan tanggal lahir sesuai format hh/bb/tttt cth:(23/03/2002)", "Input", "");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Bulan Lahir", "Kesalahan! Tidak sah\nMohon masukan tanggal lahir sesuai format hh/bb/tttt cth:(23/03/2002)", "Input", "");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tanggal Lahir", "Kesalahan! Tidak sah\nMohon masukan tanggal lahir sesuai format hh/bb/tttt cth:(23/03/2002)", "Input", "");
			}
			else 
			{
				format(pData[playerid][pAge], 50, inputtext);
				//ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
				new szMiscArray[512];
				szMiscArray = 
				"United States Of America\nSingapore\nIndonesia\nAfganistan\nAlbania\nPakistan\nPhillpines\nRussian\nQatar\nSpanish\nArgentina\nArabic\nAustralia\nBangladesh\nBrazil\nBulgaria\nCanada\nChina\nColombia\nCongo\nDenmark\nItalian\nGermany\nHongKong\nIndia\nIran\nIraq\nJamaica\nJapan\nKorea\nMexico";
				ShowPlayerDialog(playerid, DIALOG_ORIGIN, DIALOG_STYLE_LIST, "{00FFE5}Konoha {ffffff}- Negara Kelahiran", szMiscArray, "Select", "Batal");
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tanggal Lahir", "Mohon masukan tanggal lahir sesuai format hh/bb/tttt cth:(23/03/2002)", "Input", "");
		return 1;
	}
	if(dialogid == DIALOG_ORIGIN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pAccent1] = 0;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 1:
				{	
					pData[playerid][pAccent1] = 1;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 2:
				{
					pData[playerid][pAccent1] = 2;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 3:
				{
					pData[playerid][pAccent1] = 3;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 4:
				{
					pData[playerid][pAccent1] = 4;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 5:
				{
					pData[playerid][pAccent1] = 5;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 6:
				{
					pData[playerid][pAccent1] = 6;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 7:
				{	
					pData[playerid][pAccent1] = 7;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 8:
				{
					pData[playerid][pAccent1] = 8;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 9:
				{
					pData[playerid][pAccent1] = 9;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 10:
				{
					pData[playerid][pAccent1] = 10;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 11:
				{
					pData[playerid][pAccent1] = 11;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 12:
				{
					pData[playerid][pAccent1] = 12;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 13:
				{	
					pData[playerid][pAccent1] = 13;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 14:
				{
					pData[playerid][pAccent1] = 14;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 15:
				{
					pData[playerid][pAccent1] = 15;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 16:
				{
					pData[playerid][pAccent1] = 16;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 17:
				{
					pData[playerid][pAccent1] = 17;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 18:
				{
					pData[playerid][pAccent1] = 18;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 19:
				{	
					pData[playerid][pAccent1] = 19;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 20:
				{
					pData[playerid][pAccent1] = 20;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 21:
				{
					pData[playerid][pAccent1] = 21;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 22:
				{
					pData[playerid][pAccent1] = 22;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 23:
				{
					pData[playerid][pAccent1] = 23;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 24:
				{
					pData[playerid][pAccent1] = 24;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 25:
				{	
					pData[playerid][pAccent1] = 25;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 26:
				{
					pData[playerid][pAccent1] = 26;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 27:
				{
					pData[playerid][pAccent1] = 27;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 28:
				{
					pData[playerid][pAccent1] = 28;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 29:
				{
					pData[playerid][pAccent1] = 29;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
				case 30:
				{
					pData[playerid][pAccent1] = 30;
					new String[256];
					format(String, sizeof(String), "Negara Kelahiran: {ffffff}Aksen karakter Anda telah diset ke '{ffff00}%s{ffffff}'", GetPlayerAccent(playerid));
					SendClientMessageEx(playerid,COLOR_ARWIN,String);
					ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Masukan Tinggi Badan (cm)!", "Input", "");
				}
			}
		}
	}
	if(dialogid == DIALOG_TINGGI)
    {
		if(!response) return 1;
		if(response)
		{
			new tinggi;
			
			if(sscanf(inputtext, "p</>d", tinggi)) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah MIN 110 & MAX 200\nMasukan Tinggi Badan (cm)!", "Input", "");
			}
			else if(tinggi < 110 || tinggi > 200) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah MIN 110 & MAX 200\nMasukan Tinggi Badan (cm)!", "Input", "");
			}
			else
			{
				format(pData[playerid][pTinggi], 50, inputtext);
				ShowPlayerDialog(playerid, DIALOG_BERAT, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Berat Badan", "Masukan Berat Badan (kg)!", "Input", "");
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT,  "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah MIN 110 & MAX 200\nMasukan Tinggi Badan (cm)!", "Input", "");
		return 1;
	}
	/*if(dialogid == DIALOG_TINGGI)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah\nMasukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
		if(response)
		{
			new tinggi;
			
			if(sscanf(inputtext, "p</>d", tinggi)) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah\nMasukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
			}
			else if(tinggi < 110 || tinggi > 200) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah\nMasukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
			}
			else
			{
				format(pData[playerid][pTinggi], 50, inputtext);
				ShowPlayerDialog(playerid, DIALOG_BERAT, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Berat Badan", "Masukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT,  "{00FFE5}Konoha - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah\nMasukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
		return 1;
	}*/
	if(dialogid == DIALOG_BERAT)
    {
		if(!response) return 1;
		if(response)
		{
			new berat;

			if(sscanf(inputtext, "p</>d", berat)) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Berat Badan", "Kesalahan! Tidak sah MIN 40 & MAX 150\nMasukan Berat Badan (kg)!", "Input", "");
			}
			else if(berat < 40 || berat > 150) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Berat Badan", "Kesalahan! Tidak sah MIN 40 & MAX 150\nMasukan Berat Badan (kg)!", "Input", "");
			}
			else
			{
			    format(pData[playerid][pBerat], 50, inputtext);
				ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "{00FFE5}Konoha - {ffffff}Jenis Kelamin", "1. Laki-Laki\n2. Perempuan", "Pilih", "");
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_BERAT, DIALOG_STYLE_INPUT,  "{00FFE5}Konoha - {ffffff}Berat Badan", "Kesalahan! Tidak sah MIN 40 & MAX 150\nMasukan Berat Badan (kg)!", "Input", "");
		return 1;
	}
	/*if(dialogid == DIALOG_BERAT)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_BERAT, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Berat Badan", "Kesalahan! Tidak sah\nMasukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
		if(response)
		{
			new berat;

			if(sscanf(inputtext, "p</>d", berat)) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Berat Badan", "Kesalahan! Tidak sah\nMasukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
			}
			else if(berat < 40 || berat > 150) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Berat Badan", "Kesalahan! Tidak sah\nMasukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
			}
			else
			{
				format(pData[playerid][pBerat], 50, inputtext);
				ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Kelamin", "1. Laki-Laki\n2. Perempuan", "Oke", "Batal");
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_BERAT, DIALOG_STYLE_INPUT,  "{00FFE5}Konoha - {ffffff}Berat Badan", "Kesalahan! Tidak sah\nMasukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
		return 1;
	}*/
	if(dialogid == DIALOG_GENDER)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "{00FFE5}Konoha - {ffffff}Jenis Kelamin", "1. Laki-Laki\n2. Perempuan", "Pilih", "");
		if(response)
		{
			pData[playerid][pGender] = listitem + 1;
			switch (listitem)
			{
				case 0:
				{
					SendClientMessageEx(playerid,COLOR_WHITE,"[i]: Registrasi Berhasil! Terima kasih telah bergabung dengan Server kami ><!");
					Servers(playerid, "Buka inventory dan gunakan "YELLOW_E"`Backpack`{ffffff} untuk mendapatkan staterpack!");
					pData[playerid][pSpawnList] = 1;
					switch (pData[playerid][pGender])
					{ //tahap skin
						case 1:
						{
					 		pData[playerid][pSkin] = 120;
					 		SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1682.5914,-2241.6711,13.6469,182.4905, 0, 0, 0, 0, 0, 0);
					 		pData[playerid][pStarterPack] = 1;
							SpawnPlayer(playerid);
						}
						case 2:
						{
					 		pData[playerid][pSkin] = 93;
					 		SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1682.5914,-2241.6711,13.6469,182.4905, 0, 0, 0, 0, 0, 0);
					 		pData[playerid][pStarterPack] = 1;
							SpawnPlayer(playerid);
						}
					}
		//			ShowPlayerDialog(playerid, DIALOG_SPAWN_1, DIALOG_STYLE_LIST, "Select Your Location", "» Unity Station\n» Palomino\n» Airport Los Santos", "Select", "Cancel");

				}
				case 1:
				{
					SendClientMessageEx(playerid,COLOR_WHITE,"[i]: Registrasi Berhasil! Terima kasih telah bergabung dengan Server kami ><!");
					Servers(playerid, "Buka inventory dan gunakan "YELLOW_E"`Backpack`{ffffff} untuk mendapatkan staterpack!");
					pData[playerid][pSpawnList] = 1;
					switch (pData[playerid][pGender])
					{ //tahap skin
						case 1:
						{
					 		pData[playerid][pSkin] = 120;
					 		SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1682.5914,-2241.6711,13.6469,182.4905, 0, 0, 0, 0, 0, 0);
					 		pData[playerid][pStarterPack] = 1;
							SpawnPlayer(playerid);
						}
						case 2:
						{
					 		pData[playerid][pSkin] = 93;
					 		SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1682.5914,-2241.6711,13.6469,182.4905, 0, 0, 0, 0, 0, 0);
					 		pData[playerid][pStarterPack] = 1;
							SpawnPlayer(playerid);
						}
					}
				//ShowPlayerDialog(playerid, DIALOG_FIRST_SPAWN, DIALOG_STYLE_LIST, "Pilih lokasi spawn pertama anda", "Market Station\nUnity Station\nGlen Park", "Select", "Cancel");
				}
				//pData[playerid][pSkin] = (listitem) ? (233) : (98);
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "{00FFE5}Konoha - {ffffff}Jenis Kelamin", "1. Laki-Laki\n2. Perempuan", "Pilih", "");
		return 1;
	}
	/*if(dialogid == DIALOG_GENDER)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					pData[playerid][pGender] = 1;
				}
				case 1: 
				{
					pData[playerid][pGender] = 2;
				}
			}
			ShowPlayerDialog(playerid, DIALOG_FIRST_SPAWN, DIALOG_STYLE_LIST, "Pilih lokasi spawn pertama anda", "Market Station\nUnity Station\nGlen Park", "Select", "Cancel");
		}
		else ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
		return 1;
	}*/
	if(dialogid == DIALOG_FIRST_SPAWN)
	{
		if(response)
		{
			switch(listitem+1)
			{
				case 1:
				{
					pData[playerid][pSkin] = 137;

					pData[playerid][pPosX] = 822.71;
					pData[playerid][pPosY] = -1347.60;
					pData[playerid][pPosZ] = 13.52;
					pData[playerid][pPosA] = 88.1;

					SetPlayerSkin(playerid,pData[playerid][pSkin]);
					SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 822.71, -1347.60, 13.52, 88.17, 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
				}
				case 2:
				{
					pData[playerid][pSkin] = 137;

					pData[playerid][pPosX] = 1743.01;
					pData[playerid][pPosY] = -1860.74;
					pData[playerid][pPosZ] = 13.57;
					pData[playerid][pPosA] = 357.33;
					
					SetPlayerSkin(playerid,pData[playerid][pSkin]);
					SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1743.01, -1860.74, 13.57, 357.33, 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
				}
				case 3:
				{
					pData[playerid][pSkin] = 137;

					pData[playerid][pPosX] = 1817.25;
					pData[playerid][pPosY] = -1371.02;
					pData[playerid][pPosZ] = 15.07;
					pData[playerid][pPosA] = 269.88;

					SetPlayerSkin(playerid,pData[playerid][pSkin]);
					SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1817.25, -1371.02, 15.07, 269.88, 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
				}
			}

			new str[128];
			if(pData[playerid][pGender] == 1)
			{
				str = "Male/Laki-Laki";
			}
			else if(pData[playerid][pGender] == 2)
			{
				str = "Female/Perempuan";
			}
			else
			{
				str = "Unknown";
			}
			SendClientMessageEx(playerid,COLOR_WHITE,""LB_E"SERVER: "WHITE_E"Registrasi Berhasil! Terima kasih "YELLOW_E"%s"WHITE_E" telah bergabung ke dalam server!", pData[playerid][pName]);
			SendClientMessageEx(playerid,COLOR_WHITE,""LB_E"SERVER: "WHITE_E"Tanggal Lahir : "YELLOW_E"%s "WHITE_E"| Gender : "YELLOW_E"%s"WHITE_E"", pData[playerid][pAge], str);
			SendClientMessageEx(playerid,COLOR_WHITE,""LB_E"SERVER: "WHITE_E"Gunakan "YELLOW_E"/claimsp"WHITE_E" untuk mendapatkan starter pack");
		}
		else return ShowPlayerDialog(playerid, DIALOG_FIRST_SPAWN, DIALOG_STYLE_LIST, "Pilih lokasi spawn pertama anda", "Market Station\nUnity Station\nGlen Park", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DIALOG_EMAIL)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				Error(playerid, "This field cannot be left empty!");
				callcmd::email(playerid);
				return 1;
			}
			if(!(2 < strlen(inputtext) < 40))
			{
				Error(playerid, "Please insert a valid email! Must be between 3-40 characters.");
				callcmd::email(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Email can contain only A-Z, a-z, 0-9, _, [ ], ( )  and @");
				callcmd::email(playerid);
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET email='%e' WHERE reg_id='%d'", inputtext, pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your e-mail has been set to "YELLOW_E"%s!"WHITE_E"(relogin for /stats update)", inputtext);
			return 1;
		}
		return 1;
	}
	if(dialogid == DIALOG_STATS)
	{
		if(response)
		{
			return callcmd::settings(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_SETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::email(playerid);
				}
				case 1:
				{
					return callcmd::changepass(playerid);
				}
				case 2:
				{	
					ShowPlayerDialog(playerid, DIALOG_HBEMODE, DIALOG_STYLE_LIST, "HBE Mode", ""LG_E"Simple\n"LG_E"Modern\n"RED_E"Disable", "Set", "Close");
				}
				case 3:
				{
					return callcmd::togpm(playerid);
				}
				case 4:
				{
					return callcmd::toglog(playerid);
				}
				case 5:
				{
					return callcmd::togads(playerid);
				}
				case 6:
				{
					return callcmd::togwt(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_HBEMODE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					for(new i = 0; i < 32; i++)
					{
						TextDrawHideForPlayer(playerid, HBEAJIX[i]);
					}
					
					pData[playerid][pHBEMode] = 1;
					
					for(new i = 0; i < 15; i++)
					{
						TextDrawShowForPlayer(playerid, GenzoHBE[i]);
					}
				}
				case 1:
				{
					for(new i = 0; i < 15; i++)
					{
						TextDrawHideForPlayer(playerid, GenzoHBE[i]);
					}

					pData[playerid][pHBEMode] = 2;

					for(new i = 0; i < 32; i++)
					{
						TextDrawShowForPlayer(playerid, HBEAJIX[i]);
					}
					
				}
				case 2:
				{
					pData[playerid][pHBEMode] = 0;
					
					for(new i = 0; i < 15; i++)
					{
						TextDrawHideForPlayer(playerid, GenzoHBE[i]);
					}

					for(new i = 0; i < 32; i++)
					{
						TextDrawHideForPlayer(playerid, HBEAJIX[i]);
					}

					for(new txd; txd < 8; txd++)
					{
						TextDrawHideForPlayer(playerid, GenzoVeh[txd]);
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_CHANGEAGE)
    {
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;
				
			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tahun Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Bulan Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else 
			{
				format(pData[playerid][pAge], 50, inputtext);
				Info(playerid, "New Age for your character is "YELLOW_E"%s.", pData[playerid][pAge]);
				GivePlayerMoneyEx(playerid, -20);
				Server_AddMoney(20);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDSHOP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
					ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, "Change Name", "Input new nickname:\nExample: Charles_Sanders\n", "Change", "Cancel");
				}
				case 1:
				{
					if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 500;
					pData[playerid][pWarn] = 0;
					Info(playerid, "Warning have been reseted for 500 gold. Total Warning: 0");
				}
				case 2:
				{
					if(pData[playerid][pGold] < 300) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 300;
					pData[playerid][pVip] = 1;
					pData[playerid][pVipTime] = gettime() + (14 * 86400);
					Info(playerid, "You has bought VIP level 1 for 300 gold(14 days).");
				}
				case 3:
				{
					if(pData[playerid][pGold] < 400) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 400;
					pData[playerid][pVip] = 2;
					pData[playerid][pVipTime] = gettime() + (14 * 86400);
					Info(playerid, "You has bought VIP level 2 for 400 gold(14 days).");
				}
				case 4:
				{
					if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 500;
					pData[playerid][pVip] = 3;
					pData[playerid][pVipTime] = gettime() + (14 * 86400);
					Info(playerid, "You has bought VIP level 3 for 500 gold(14 days).");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDNAME)
	{
		if(response)
		{
			if(strlen(inputtext) < 4) return Error(playerid, "New name can't be shorter than 4 characters!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(strlen(inputtext) > 20) return Error(playerid, "New name can't be longer than 20 characters!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(!IsValidRoleplayName(inputtext))
			{
				Error(playerid, "Name contains invalid characters, please doublecheck!");
				ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", inputtext);
			mysql_tquery(g_SQL, query, "ChangeName", "is", playerid, inputtext);
		}
		return 1;
	}
	//--------------[VENDING MACHINE]-------------------
	if(dialogid == VENDING_MENU)
	{
		new venid = pData[playerid][pGetVENID];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(!Player_OwnsVending(playerid, venid))
						return Error(playerid, "Kamu bukan pemilik vending machine ini.");

					if(pData[playerid][pGetVENID] == -1)
						return Error(playerid, "Kamu harus relog");

					new str[128];
					format(str, sizeof(str), ""WHITE_E"Drink Price: "GREEN_E"%d "WHITE_E" (batas harga hanya $1 sampai $25)", vmData[venid][venDrinkPrice]);
					ShowPlayerDialog(playerid, VENDING_DRINK_PRICE, DIALOG_STYLE_INPUT, "Edit Price", str, "Edit", "Back");
				}
				case 1:
				{
					if(!Player_OwnsVending(playerid, venid))
						return Error(playerid, "Kamu bukan pemilik vending machine ini.");

					if(pData[playerid][pGetVENID] == -1)
						return Error(playerid, "Kamu harus relog");
					
					//Vending Money
					ShowPlayerDialog(playerid, VENDING_MONEY, DIALOG_STYLE_LIST, "Vending Money", "Withdraw Money\nDeposit Money", "Select", "Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == VENDING_DRINK_PRICE)
	{
		new venid = pData[playerid][pGetVENID];
		if(Player_OwnsVending(playerid, pData[playerid][pGetVENID]))
		{
			if(response)
			{
				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %d:", vmData[venid][venDrinkPrice]);
					ShowPlayerDialog(playerid, VENDING_DRINK_PRICE, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 500)
				{
					new str[128];
					format(str,sizeof(str), "Drink Price: %d (batas harga hanya $1 sampai $500)", vmData[venid][venDrinkPrice]);
					ShowPlayerDialog(playerid, VENDING_DRINK_PRICE, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
					return 1;
				}
				vmData[venid][venDrinkPrice] = strval(inputtext);
				Vending_Save(venid);
				VendingLabel_Refresh(venid);

				Servers(playerid, "You have adjusted the price of %d to: %s!", vmData[venid][venDrinkPrice], FormatMoney(strval(inputtext)));
			}
			else
			{
				callcmd::vmedit(playerid, "\0");
			}
		}
		return 1;
	}
	if(dialogid == VENDING_MONEY)
	{
		if(response)
		{
			new venid = pData[playerid][pGetVENID];
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(!Player_OwnsVending(playerid, venid))
							return Error(playerid, "Kamu bukan pemilik vending machine ini.");

						new str[128];
						format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(vmData[venid][venMoney]));
						ShowPlayerDialog(playerid, VENDING_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
					}
					case 1: 
					{
						if(!Player_OwnsVending(playerid, venid))
							return Error(playerid, "Kamu bukan pemilik vending machine ini.");

						new str[128];
						format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(vmData[venid][venMoney]));
						ShowPlayerDialog(playerid, VENDING_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::vmedit(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == VENDING_WITHDRAWMONEY)
	{
		new venid = pData[playerid][pGetVENID];
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(vmData[venid][venMoney]));
				ShowPlayerDialog(playerid, VENDING_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > vmData[venid][venMoney])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nMoney Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(vmData[venid][venMoney]));
				ShowPlayerDialog(playerid, VENDING_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
				return 1;
			}
			vmData[venid][venMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Vending_Save(venid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from vending storage.", ReturnName(playerid), FormatMoney(amount));
			return 1;
		}
		else callcmd::vmedit(playerid, "\0");
		return 1;
	}
	if(dialogid == VENDING_DEPOSITMONEY)
	{
		new venid = pData[playerid][pGetVENID];
		if(vmData[venid][venMoney] > 50000) return Error(playerid, "Penyimpanan sudah penuh!");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(vmData[venid][venMoney]));
				ShowPlayerDialog(playerid, VENDING_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMoney])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nMoney Balance: "GREEN_E"%s\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(vmData[venid][venMoney]));
				ShowPlayerDialog(playerid, VENDING_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
				return 1;
			}
			vmData[venid][venMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Vending_Save(venid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into vending storage.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::vmedit(playerid, "\0");
		return 1;
	}
	if(dialogid == VENDING_DEPOSITSPRUNK)
	{
		new venid = pData[playerid][pGetVENID];
		if(vmData[venid][venProduct] > 100) return Error(playerid, "Penyimpanan sprunk sudah penuh!");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"Sprunk Balance: "GREEN_E"%d\n\n"WHITE_E"Silakan masukkan berapa banyak sprunk yang ingin Anda setorkan ke dalam vending:", vmData[venid][venProduct]);
				ShowPlayerDialog(playerid, VENDING_DEPOSITSPRUNK, DIALOG_STYLE_INPUT, "Deposit Sprunk", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pSprunk])
			{
				new str[1024];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Sprunk milikmu tidak mencukupi.\n\nSprunk Balance: "GREEN_E"%d\n\n"WHITE_E"Silakan masukkan berapa banyak sprunk yang ingin Anda setorkan ke dalam vending:", vmData[venid][venProduct]);
				ShowPlayerDialog(playerid, VENDING_DEPOSITSPRUNK, DIALOG_STYLE_INPUT, "Deposit Sprunk", str, "Deposit", "Back");
				return 1;
			}
			vmData[venid][venProduct] += amount;
			pData[playerid][pSprunk] -= amount;

			Vending_Save(venid);
			VendingLabel_Refresh(venid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d sprunk into vending storage.", ReturnName(playerid), amount);
		}
		else callcmd::vmedit(playerid, "\0");
		return 1;
	}
	if(dialogid == DIALOG_MY_VENDING)
	{
		if(response) 
		{
			new venid = ReturnPlayerVendingID(playerid, (listitem + 1));
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ], 0.0, 0.0, 0.0, 4.5);
			Info(playerid, "Vending Machine milikmu yang berlokasi di %s telah di tandai", GetLocation(vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]));
		}
		return 1;
	}
	//-------------[WORKSHOP DIALOG]-----------
	if(dialogid == WORKSHOP_MENU)
	{
		if(!response) return 1;
		new wid = pData[playerid][pWorkshop];

		new status[128];
		if(wData[wid][wStatus] == 1)
		{
			status = "{FF0000}Closed";
		}
		else
		{
			status = "{00FF00}Opened";
		}
		switch(listitem) 
		{
			case 0:
			{
				new mstr[248], lstr[512];
				format(mstr,sizeof(mstr),""WHITE_E"Workshop ID %d", wid);
				format(lstr,sizeof(lstr),""WHITE_E"Workshop Name:\t"RED_E"%s\n"WHITE_E"Workshop Status:\t%s\nWorkshop Member\t", wData[wid][wName], status);
				ShowPlayerDialog(playerid, WORKSHOP_INFO, DIALOG_STYLE_TABLIST, mstr, lstr,"Select","Close");
			}
			case 1:
			{
				if(pData[playerid][pOnDuty] == 1)
				{
					pData[playerid][pOnDuty] = 0;
					SetPlayerColor(playerid, COLOR_WHITE);
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengganti pakaian kerja dengan pakaian biasa", ReturnName(playerid));
				}
				else
				{
					pData[playerid][pOnDuty] = 1;
					SetPlayerColor(playerid, COLOR_WHITE);
					if(pData[playerid][pGender] == 1)
					{
						SetPlayerSkin(playerid, 268);
						pData[playerid][pFacSkin] = 268;
					}
					else
					{
						SetPlayerSkin(playerid, 69); //194
						pData[playerid][pFacSkin] = 69; //194
					}
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil pakaian kerja dari dalam locker dan langsung memakainya", ReturnName(playerid));
				}
			}
			case 2:
			{
				//Workshop Money
				ShowPlayerDialog(playerid, WORKSHOP_MONEY, DIALOG_STYLE_LIST, "Workshop Money", "Withdraw Money\nDeposit Money", "Select", "Back");
			}
			case 3:
			{
				//Workshop Component
				ShowPlayerDialog(playerid, WORKSHOP_COMPONENT, DIALOG_STYLE_LIST, "Workshop Component", "Withdraw Component\nDeposit Component", "Select", "Back");
			}
			case 4:
			{
				if(pData[playerid][pComponent] < 100)
				return Error(playerid, "Kamu harus memiliki 100 component untuk membuat ini");

				if(pData[playerid][pActivityTime] > 5)
					return Error(playerid, "Kamu masih memiliki activity progress");

				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
				pData[playerid][pMechanic] = SetTimerEx("WorkshopCreateRepairkit", 1000, true, "id", playerid, pData[playerid][pWorkshop]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating Repairkit..");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
		}
		return 1;
	}
	if(dialogid == WORKSHOP_INFO)
	{
		new wid = pData[playerid][pWorkshop];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pWorkshopRank] < 6)
					return Error(playerid,"Hanya rank 6 yang bisa mengubah nama.");

					new mstr[248];
					format(mstr,sizeof(mstr),""WHITE_E"Nama Workshop: "RED_E"%s\n\n"WHITE_E"Masukkan nama workshop yang kamu inginkan\nMaksimal 32 karakter untuk nama workshop", wData[wid][wName]);
					ShowPlayerDialog(playerid, WORKSHOP_NAME, DIALOG_STYLE_INPUT,"Workshop Name", mstr,"Done","Back");
				}
				case 1:
				{
					return callcmd::lockws(playerid, "\0");
				}
				case 2:
				{
					if(pData[playerid][pWorkshop] == -1)
						return Error(playerid, "Kamu bukan anggota workshop!");

					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,workshoprank FROM players WHERE workshop = %d", pData[playerid][pWorkshop]);
					mysql_tquery(g_SQL, query, "ShowWorkshopMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == WORKSHOP_NAME)
	{
		if(response)
		{
			new wid = pData[playerid][pWorkshop];

			if(!Player_OwnsWorkshop(playerid, wid)) return Error(playerid, "You don't own this workshop.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Workshop tidak di perbolehkan kosong!\n\n"WHITE_E"Nama Workshop: "RED_E"%s\n\n"WHITE_E"Masukkan nama Workshop yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", wData[wid][wName]);
				ShowPlayerDialog(playerid, WORKSHOP_NAME, DIALOG_STYLE_INPUT,"Workshop Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Workshop harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama Workshop: "RED_E"%s\n\n"WHITE_E"Masukkan nama Workshop yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", wData[wid][wName]);
				ShowPlayerDialog(playerid, WORKSHOP_NAME, DIALOG_STYLE_INPUT,"Workshop Name", mstr,"Done","Back");
				return 1;
			}
			format(wData[wid][wName], 32, ColouredText(inputtext));

			Workshop_Refresh(wid);
			Workshop_Save(wid);

			Servers(playerid, "Workshop name set to: \"%s\".", wData[wid][wName]);
		}
		else return callcmd::wsstorage(playerid, "\0");
		return 1;
	}
	if(dialogid == WORKSHOP_MONEY)
	{
		if(response)
		{
			new wid = pData[playerid][pWorkshop];
			if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop!");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pWorkshopRank] < 5)
							return Error(playerid, "Hanya rank 5 dan 6 yang bisa mengambil ini!");
							
						new str[128];
						format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s/$1.500,000\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(wData[wid][wMoney]));
						ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s/$1.500,000\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(wData[wid][wMoney]));
						ShowPlayerDialog(playerid, WORKSHOP_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::wsstorage(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == WORKSHOP_WITHDRAWMONEY)
	{
		new wid = pData[playerid][pWorkshop];
		if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop!");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s/$1.500,000\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(wData[wid][wMoney]));
				ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > wData[wid][wMoney])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nMoney Balance: "GREEN_E"%s/$1.500,000\n\n"WHITE_E"Please enter how much money you wish to withdraw from the safe:", FormatMoney(wData[wid][wMoney]));
				ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
				return 1;
			}
			wData[wid][wMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Workshop_Save(wid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from storage.", ReturnName(playerid), FormatMoney(amount));
			callcmd::wsstorage(playerid, "\0");
			return 1;
		}
		else callcmd::wsstorage(playerid, "\0");
		return 1;
	}
	if(dialogid == WORKSHOP_DEPOSITMONEY)
	{
		new wid = pData[playerid][pWorkshop];
		if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop.");
		if(wData[wid][wMoney] > 1500000) return Error(playerid, "Penyimpanan sudah penuh!");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Money Balance: "GREEN_E"%s/$1.500,000\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(wData[wid][wMoney]));
				ShowPlayerDialog(playerid, WORKSHOP_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMoney])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nMoney Balance: "GREEN_E"%s/$1.500,000\n\n"WHITE_E"Please enter how much money you wish to deposit into the safe:", FormatMoney(wData[wid][wMoney]));
				ShowPlayerDialog(playerid, WORKSHOP_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
				return 1;
			}
			wData[wid][wMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Workshop_Save(wid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into storage.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::wsstorage(playerid, "\0");
		return 1;
	}
	if(dialogid == WORKSHOP_COMPONENT)
	{
		if(response)
		{
			new wid = pData[playerid][pWorkshop];
			if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop!");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pWorkshopRank] < 5)
							return Error(playerid, "Hanya rank 5 dan 6 yang bisa mengambil ini!");
							
						new str[128];
						format(str, sizeof(str), ""WHITE_E"Component Balance: "GREEN_E"%d/10.000\n\n"WHITE_E"Please enter how much component you wish to withdraw from the safe:", wData[wid][wComponent]);
						ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), ""WHITE_E"Component Balance: "GREEN_E"%d/10.000\n\n"WHITE_E"Please enter how much component you wish to deposit into the safe:", wData[wid][wComponent]);
						ShowPlayerDialog(playerid, WORKSHOP_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::wsstorage(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == WORKSHOP_WITHDRAWCOMPONENT)
	{
		new wid = pData[playerid][pWorkshop];
		if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop!");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Component Balance: "GREEN_E"%d/10.000\n\n"WHITE_E"Please enter how much component you wish to withdraw from the safe:", wData[wid][wComponent]);
				ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > wData[wid][wComponent])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nComponent Balance: "GREEN_E"%d/10.000\n\n"WHITE_E"Please enter how much component you wish to withdraw from the safe:", wData[wid][wComponent]);
				ShowPlayerDialog(playerid, WORKSHOP_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
				return 1;
			}
			wData[wid][wComponent] -= amount;
			pData[playerid][pComponent] += amount;

			Workshop_Save(wid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d component from storage.", ReturnName(playerid), amount);
			callcmd::wsstorage(playerid, "\0");
			return 1;
		}
		else callcmd::wsstorage(playerid, "\0");
		return 1;
	}
	if(dialogid == WORKSHOP_DEPOSITCOMPONENT)
	{
		new wid = pData[playerid][pWorkshop];
		if(wid == -1) return Error(playerid, "Kamu bukan anggota workshop.");
		if(wData[wid][wComponent] > 10000) return Error(playerid, "Penyimpanan sudah penuh!");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), ""WHITE_E"Component Balance: "GREEN_E"%d/10.000\n\n"WHITE_E"Please enter how much component you wish to deposit into the safe:", wData[wid][wComponent]);
				ShowPlayerDialog(playerid, WORKSHOP_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), ""RED_E"ERROR: "WHITE_E"Insufficient funds.\n\nComponent Balance: "GREEN_E"%d/10.000\n\n"WHITE_E"Please enter how much component you wish to deposit into the safe:", wData[wid][wComponent]);
				ShowPlayerDialog(playerid, WORKSHOP_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
				return 1;
			}
			wData[wid][wComponent] += amount;
			pData[playerid][pComponent] -= amount;

			Workshop_Save(wid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d component into storage.", ReturnName(playerid), amount);
		}
		else callcmd::wsstorage(playerid, "\0");
		return 1;
	}
	//-----------[ Bisnis Dialog ]------------
	if(dialogid == DIALOG_SELL_BISNISS)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell bisnis id: %d", GetPVarInt(playerid, "SellingBisnis"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_BISNIS, DIALOG_STYLE_MSGBOX, "Sell Bisnis", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_BISNIS)
	{
		if(response)
		{
			new bid = GetPVarInt(playerid, "SellingBisnis"), price;

			if(bData[bid][bLocked] >= 2)
				return Error(playerid, "Kamu tidak dapat menjual rumah yang sedang disegel oleh pemerintah");

			price = bData[bid][bPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual bisnis id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", bid, FormatMoney(price));
			Bisnis_Reset(bid);
			Bisnis_Save(bid);
			Bisnis_Refresh(bid);
		}
		DeletePVar(playerid, "SellingBisnis");
		return 1;
	}
	if(dialogid == DIALOG_MY_BISNIS)
	{
		if(!response) return true;
		SetPVarInt(playerid, "ClickedBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_LIST, "{FF0000}Konoha:RP {0000FF}Bisnis", "Show Information\nTrack Bisnis", "Select", "Cancel");
		return 1;
	}
	if(dialogid == BISNIS_INFO)
	{
		if(!response) return true;
		new bid = GetPVarInt(playerid, "ClickedBisnis");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(bData[bid][bLocked] == 0)
				{
					lock = ""GREEN_LIGHT"Dibuka{ffffff}";
				}
				else if(bData[bid][bLocked] == 1)
				{
					lock = ""RED_E"Dikunci{ffffff} ";
				}
				else
				{
					lock = ""RED_E"Disegel"WHITE_E"";
				}
				
				if(bData[bid][bType] == 1)
				{
					type = "Fast Food";
				}
				else if(bData[bid][bType] == 2)
				{
					type = "Market";
				}
				else if(bData[bid][bType] == 3)
				{
					type = "Clothes";
				}
				else if(bData[bid][bType] == 4)
				{
					type = "Equipment";
				}
				else if(bData[bid][bType] == 5)
				{
					type = "Gun Shop";
				}
				else if(bData[bid][bType] == 6)
				{
					type = "Gym";
				}
				else
				{
					type = "Unknown";
				}
				format(line9, sizeof(line9), "Bisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Price: %s\nBisnis Type: %s\nBisnis Status: %s\nBisnis Product: %d",
				bid, bData[bid][bOwner], bData[bid][bName], FormatMoney(bData[bid][bPrice]), type, lock, bData[bid][bProd]);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Bisnis Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackBisnis] = 1;
				SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan bisnis anda!");
			}
		}
		return 1;
	}
	//----------[ PFARM DIALOG ] -------------
	if(dialogid == PFARM_MENU)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_SEEDS, DIALOG_STYLE_LIST, string, "Deposit Seeds\nWithdraw Seeds", "Yes", "No");
				}
				case 1:
				{
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_POTATO, DIALOG_STYLE_LIST, string, "Deposit Potato\nWithdraw Potato", "Yes", "No");
				}
				case 2:
				{
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_ORANGE, DIALOG_STYLE_LIST, string, "Deposit Orange\nWithdraw Orange", "Yes", "No");
				}
				case 3:
				{
					new string[1024];
					format(string, sizeof(string), "Farm ID : %d", pfid);
					ShowPlayerDialog(playerid, PFARM_WHEAT, DIALOG_STYLE_LIST, string, "Deposit Wheat\nWithdraw Wheat", "Yes", "No");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MY_PFARM)
	{
		if(response) 
		{
			new pfid = ReturnPlayerPfarmID(playerid, (listitem + 1));
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ], 0.0, 0.0, 0.0, 4.5);
			Info(playerid, "Private Farm milikmu yang berlokasi di %s telah di tandai", GetLocation(pfData[pfid][pfX], pfData[pfid][pfY], pfData[pfid][pfZ]));
		}
		return 1;
	}
	if(dialogid == PFARM_SEEDS)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Seeds kamu: %d.\n\nMasukkan berapa banyak Seeds yang akan kamu simpan di farmer ini", pData[playerid][pSeed]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_SEEDS, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Seeds Vault: %d\n\nMasukkan berapa banyak Seeds yang akan kamu ambil dari farmer ini", pfData[pfid][pfSeeds]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_SEEDS, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_POTATO)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Potato kamu: %d.\n\nMasukkan berapa banyak Potato yang akan kamu simpan di farmer ini", pData[playerid][pPotato]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_POTATO, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Potato Vault: %d\n\nMasukkan berapa banyak Potato yang akan kamu ambil dari farmer ini", pfData[pfid][pfPotato]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_POTATO, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_ORANGE)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Orange kamu: %d.\n\nMasukkan berapa banyak Orange yang akan kamu simpan di farmer ini", pData[playerid][pOrange]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_ORANGE, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Orange Vault: %d\n\nMasukkan berapa banyak Orange yang akan kamu ambil dari farmer ini", pfData[pfid][pfOrange]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_ORANGE, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_WHEAT)
	{
		new pfid = pData[playerid][pGetPFARM];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Wheat kamu: %d.\n\nMasukkan berapa banyak Wheat yang akan kamu simpan di farmer ini", pData[playerid][pWheat]);
					ShowPlayerDialog(playerid, PFARM_DEPOSIT_WHEAT, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Wheat Vault: %d\n\nMasukkan berapa banyak Wheat yang akan kamu ambil dari farmer ini", pfData[pfid][pfWheat]);
					ShowPlayerDialog(playerid, PFARM_WITHDRAW_WHEAT, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_SEEDS)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfSeeds])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfSeeds] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pSeed] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" seeds from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_SEEDS, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Seeds\nWithdraw Seeds","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_SEEDS)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pSeed] + amount;

			if(amount < 1 || amount > pData[playerid][pSeed])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 1000)
				return Error(playerid, "Anda tidak bisa memasukan seeds lebih dari batas slot");

			pfData[pfid][pfSeeds] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pSeed] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" seeds into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_SEEDS, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Seeds\nWithdraw Seeds","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_POTATO)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfPotato])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfPotato] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pPotato] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" potato from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_POTATO, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Potato\nWithdraw Potato","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_POTATO)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pPotato] + amount;

			if(amount < 1 || amount > pData[playerid][pPotato])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 500)
				return Error(playerid, "Anda tidak bisa memasukan potato lebih dari batas slot");

			pfData[pfid][pfPotato] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pPotato] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" potato into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_POTATO, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Potato\nWithdraw Potato","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_ORANGE)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfOrange])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfOrange] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pOrange] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" orange from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_ORANGE, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Orange\nWithdraw Orange","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_ORANGE)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pOrange] + amount;

			if(amount < 1 || amount > pData[playerid][pOrange])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 250)
				return Error(playerid, "Anda tidak bisa memasukan orange lebih dari batas slot");

			pfData[pfid][pfOrange] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pOrange] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" orange into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_ORANGE, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Orange\nWithdraw Orange","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_WITHDRAW_WHEAT)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));

			if(amount < 1 || amount > pfData[pfid][pfWheat])
				return Error(playerid, "Invalid amount specified!");

			pfData[pfid][pfWheat] -= amount;
			Pfarm_Save(pfid);

			pData[playerid][pWheat] += amount;

			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have withdrawn "GREEN_E"%d"WHITE_E" wheat from the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_WHEAT, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Wheat\nWithdraw Wheat","Next","Back");
		return 1;
	}
	if(dialogid == PFARM_DEPOSIT_WHEAT)
	{
		if(response)
		{
			new pfid = pData[playerid][pGetPFARM];
			new amount = floatround(strval(inputtext));
			new maxdp = pData[playerid][pOrange] + amount;

			if(amount < 1 || amount > pData[playerid][pWheat])
				return Error(playerid, "Invalid amount specified!");

			if(maxdp > 500)
				return Error(playerid, "Anda tidak bisa memasukan wheat lebih dari batas slot");

			pfData[pfid][pfWheat] += amount;
			Pfarm_Save(pfid);

			pData[playerid][pWheat] -= amount;
			
			SendClientMessageEx(playerid, COLOR_GREEN,"FARM: "WHITE_E"You have deposit "GREEN_E"%d"WHITE_E" wheat into the farm vault.", amount);
		}
		else
			ShowPlayerDialog(playerid, PFARM_WHEAT, DIALOG_STYLE_LIST,"Farmer Vault","Deposit Wheat\nWithdraw Wheat","Next","Back");
		return 1;
	}
	//----------[ DEALER DIALOG ] -------------
	if(dialogid == DEALER_MENU)
	{
		new deid = pData[playerid][pGetDEID];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new mstr[248], lstr[512];
					format(mstr,sizeof(mstr),"Dealer ID %d", deid);
					format(lstr,sizeof(lstr),"Dealer Name:\t%s\nDealer Product:\t%d\nDealer Money Vault:\t%s", drData[deid][dName], drData[deid][dStock], FormatMoney(drData[deid][dMoney]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, mstr, lstr,"Back","Close");
				}
				case 1:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Nama sebelumnya: %s\n\nMasukkan nama dealer yang kamu inginkan\nMaksimal 32 karakter untuk nama bisnis", drData[deid][dName]);
					ShowPlayerDialog(playerid, DEALER_NAME, DIALOG_STYLE_INPUT,"Dealer Name", mstr,"Done","Back");
				}
				case 2: ShowPlayerDialog(playerid, DEALER_VAULT, DIALOG_STYLE_LIST,"Dealer Vault","Deposit\nWithdraw","Next","Back");
				case 3:
				{
					Dealer_ProductMenu(playerid, deid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DEALER_NAME)
	{
		if(response)
		{
			new deid = pData[playerid][pGetDEID];

			if(!Player_OwnsDealer(playerid, pData[playerid][pGetDEID])) return Error(playerid, "You don't own this dealer.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Dealer tidak di perbolehkan kosong!\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", drData[deid][dName]);
				ShowPlayerDialog(playerid, DEALER_NAME, DIALOG_STYLE_INPUT,"Dealer Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Dealer harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", drData[deid][dName]);
				ShowPlayerDialog(playerid, DEALER_NAME, DIALOG_STYLE_INPUT,"Dealer Name", mstr,"Done","Back");
				return 1;
			}
			format(drData[deid][dName], 32, ColouredText(inputtext));

			Dealer_Refresh(deid);
			Dealer_Save(deid);

			Servers(playerid, "Dealer name set to: \"%s\".", drData[deid][dName]);
		}
		else return callcmd::dem(playerid, "\0");
		return 1;
	}
	if(dialogid == DEALER_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam dealer ini", FormatMoney(pData[playerid][pMoney]));
					ShowPlayerDialog(playerid, DEALER_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Dealer Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam dealer ini", FormatMoney(drData[pData[playerid][pGetDEID]][dMoney]));
					ShowPlayerDialog(playerid, DEALER_WITHDRAW, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == DEALER_WITHDRAW)
	{
		if(response)
		{
			new deid = pData[playerid][pGetDEID];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > drData[deid][dMoney])
				return Error(playerid, "Invalid amount specified!");

			drData[deid][dMoney] -= amount;
			Dealer_Save(deid);

			GivePlayerMoneyEx(playerid, amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"DEALER: "WHITE_E"You have withdrawn "GREEN_E"%s "WHITE_E"from the dealer vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DEALER_VAULT, DIALOG_STYLE_LIST,"Dealer Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == DEALER_DEPOSIT)
	{
		if(response)
		{
			new deid = pData[playerid][pGetDEID];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > pData[playerid][pMoney])
				return Error(playerid, "Invalid amount specified!");

			drData[deid][dMoney] += amount;
			Dealer_Save(deid);

			GivePlayerMoneyEx(playerid, -amount);
			
			SendClientMessageEx(playerid, COLOR_LBLUE,"DEALER: "WHITE_E"You have deposit "GREEN_E"%s "WHITE_E"into the dealer vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DEALER_VAULT, DIALOG_STYLE_LIST,"Dealer Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == DEALER_EDITPROD)
	{
		if(Player_OwnsDealer(playerid, pData[playerid][pGetDEID]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, DEALER_SETPRICE, DIALOG_STYLE_INPUT, "Dealer: Set Price", str, "Modify", "Back");
			}
			else
				return callcmd::dem(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == DEALER_SETPRICE)
	{
		static
        item[40];
		new deid = pData[playerid][pGetDEID];
		if(Player_OwnsDealer(playerid, pData[playerid][pGetDEID]))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, DEALER_SETPRICE, DIALOG_STYLE_INPUT, "Dealer: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 500 || strval(inputtext) > 500000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($500 to $500.000):", item);
					ShowPlayerDialog(playerid, DEALER_SETPRICE, DIALOG_STYLE_INPUT, "Dealer: Set Price", str, "Modify", "Back");
					return 1;
				}
				drData[deid][dP][pData[playerid][pProductModify]] = strval(inputtext);
				Dealer_Save(deid);

				Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				Dealer_ProductMenu(playerid, deid);
			}
			else
			{
				Dealer_ProductMenu(playerid, deid);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MY_DEALER)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedDealer", ReturnPlayerDealerID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DEALER_INFO, DIALOG_STYLE_LIST, "{FF0000}Konoha:RP {0000FF}Dealer", "Show Information\nTrack Dealer", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DEALER_INFO)
	{
		if(!response) return 1;
		new deid = GetPVarInt(playerid, "ClickedDealer");
		switch(listitem)
		{
			case 0:
			{
				new line9[900], type[128];
				if(drData[deid][dType] == 1)
				{
					type = "Bikes Vehicles";
				}
				else if(drData[deid][dType] == 2)
				{
					type = "Cars";
				}
				else if(drData[deid][dType] == 3)
				{
					type = "Unique Cars";
				}
				else if(drData[deid][dType] == 4)
				{
					type = "Job Cars";
				}
				else if(drData[deid][dType] == 5)
				{
					type = "Rental Jobs";
				}
				else
				{
					type = "Unknown";
				}
				format(line9, sizeof(line9), "Dealer ID: %d\nDealer Owner: %s\nDealer Address: %s\nDealer Type: %s",
				deid, drData[deid][dOwner], GetLocation(drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]), type);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Dealer Info", line9, "Close","");
			}
			case 1:
			{
				SetPlayerRaceCheckpoint(playerid, 1, drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ], 0.0, 0.0, 0.0, 3.5);
				Info(playerid, "Ikuti checkpoint untuk menemukan dealer anda!");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SELL_DEALER)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingDealer", ReturnPlayerDealerID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell bisnis id: %d", GetPVarInt(playerid, "SellingDealer"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_DEALER2, DIALOG_STYLE_MSGBOX, "Sell Dealer", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_DEALER2)
	{
		if(response)
		{
			new deid = GetPVarInt(playerid, "SellingDealer"), price;
			price = drData[deid][dPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual dealer id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", deid, FormatMoney(price));
			Dealer_Reset(deid);
			Dealer_Save(deid);
			Dealer_Refresh(deid);
		}
		DeletePVar(playerid, "SellingDealer");
		return 1;
	}
	if(dialogid == BISNIS_MENU)
	{
		new bid = pData[playerid][pInBiz];
		new lock[128];
		if(bData[bid][bLocked] == 1)
		{
			lock = "Locked";
		}
		else
		{
			lock = "Unlocked";
		}
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new mstr[248], lstr[512];
					format(mstr,sizeof(mstr),"Bisnis ID %d", bid);
					format(lstr,sizeof(lstr),"Bisnis Name:\t%s\nBisnis Locked:\t%s\nBisnis Product:\t%d\nBisnis Vault:\t%s", bData[bid][bName], lock, bData[bid][bProd], FormatMoney(bData[bid][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_TABLIST, mstr, lstr,"Back","Close");
				}
				case 1:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Nama sebelumnya: %s\n\nMasukkan nama bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama bisnis", bData[bid][bName]);
					ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				}
				case 2: ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Bisnis Vault","Deposit\nWithdraw","Next","Back");
				case 3:
				{
					Bisnis_ProductMenu(playerid, bid);
				}
				case 4:
				{
					new str[524];
					format(str, sizeof(str), "Disable Animation\nTalk Animation\nCrossarms Animation");
					ShowPlayerDialog(playerid, BISNIS_ACTOR, DIALOG_STYLE_LIST, "Bisnis Actor", str, "Select", "Cancel");
				}
				case 5:
				{
					new str[254];
					format(str, sizeof(str), "Your Url Now : %s\n\nMasukan URL Musik yang ingin kamu setel untuk bisnismu (Gunakan '-' untuk menonaktifkan music bisnismu):", bData[bid][bUrl]);
					ShowPlayerDialog(playerid, BISNIS_SONG_URL, DIALOG_STYLE_INPUT, "Bisnis Song URL", str, "Yes", "No");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];

			if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return Error(playerid, "You don't own this bisnis.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis tidak di perbolehkan kosong!\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				return 1;
			}
			format(bData[bid][bName], 32, ColouredText(inputtext));

			Bisnis_Refresh(bid);
			Bisnis_Save(bid);

			Servers(playerid, "Bisnis name set to: \"%s\".", bData[bid][bName]);
		}
		else return callcmd::bm(playerid, "\0");
		return 1;
	}
	if(dialogid == BISNIS_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam bisnis ini", FormatMoney(pData[playerid][pMoney]));
					ShowPlayerDialog(playerid, BISNIS_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Business Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam bisnis ini", FormatMoney(bData[pData[playerid][pInBiz]][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_WITHDRAW, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_SONG_URL)
	{
		new bid = pData[playerid][pInBiz], str[254];
		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "ERROR : Kotak penginputan tidak boleh kosong!");
				ShowPlayerDialog(playerid, BISNIS_SONG_URL, DIALOG_STYLE_INPUT, "Bisnis Song URL", str, "Yes", "No");
			}
			if(strlen(inputtext) > 250)
			{
				format(str, sizeof(str), "ERROR : URL Musik tidak boleh lebih dari 250 character!");
				ShowPlayerDialog(playerid, BISNIS_SONG_URL, DIALOG_STYLE_INPUT, "Bisnis Song URL", str, "Yes", "No");
			}

			bData[bid][bAreaid] = CreateDynamicSphere(bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], 30.0, bid, bData[bid][bInt]);
			format(bData[bid][bUrl], 250, inputtext);
			Info(playerid, "Kamu telah merubah link musik bisnis mu menjadi: %s", bData[bid][bUrl]);
			Bisnis_Save(bid);
			Bisnis_Refresh(bid);
		}
		return 1;
	}
	if(dialogid == BISNIS_ACTOR)
	{
		new bid = pData[playerid][pInBiz];
		if(GetBisnisActor(bid) <= 0)
			return Error(playerid, "Bisnis ini tidak memiliki actor!");

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					for(new actid = 0; actid < MAX_ACTORS; actid++)
					{
						if(Iter_Contains(Actors, actid))
						{
							if(ActData[actid][actBizid] == bid)
							{
								ActData[actid][actAnim] = 0; //Disable
								Actor_Refresh(actid);
								Info(playerid, "Kamu telah mematikan animasi actor id: %d", actid);
							}
						}
					}
				}
				case 1:
				{
					for(new actid = 0; actid < MAX_ACTORS; actid++)
					{
						if(Iter_Contains(Actors, actid))
						{
							if(ActData[actid][actBizid] == bid)
							{
								ActData[actid][actAnim] = 12; //Talk
								Actor_Refresh(actid);
								Info(playerid, "Kamu telah merubah animasi actor id: %d menjadi Talk", actid);
							}
						}
					}
				}
				case 2:
				{
					for(new actid = 0; actid < MAX_ACTORS; actid++)
					{
						if(Iter_Contains(Actors, actid))
						{
							if(ActData[actid][actBizid] == bid)
							{
								ActData[actid][actAnim] = 10; //Cross Arms
								Actor_Refresh(actid);
								Info(playerid, "Kamu telah merubah animasi actor id: %d menjadi Cross Arms", actid);
							}
						}
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > bData[bid][bMoney])
				return Error(playerid, "Invalid amount specified!");

			bData[bid][bMoney] -= amount;
			Bisnis_Save(bid);

			GivePlayerMoneyEx(playerid, amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have withdrawn "GREEN_E"%s "WHITE_E"from the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == BISNIS_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > pData[playerid][pMoney])
				return Error(playerid, "Invalid amount specified!");

			bData[bid][bMoney] += amount;
			Bisnis_Save(bid);

			GivePlayerMoneyEx(playerid, -amount);
			
			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have deposit "GREEN_E"%s "WHITE_E"into the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == BISNIS_BUYPROD)
	{
		static
        bizid = -1,
        price;

		if((bizid = pData[playerid][pInBiz]) != -1 && response)
		{
			price = bData[bizid][bP][listitem];

			if(price <= 0)
				return Error(playerid, "Harga product ini belum di set oleh pemiliknya");
			
			if(pData[playerid][pMoney] < price)
				return Error(playerid, "Not enough money!");

			if(bData[bizid][bProd] < 1)
				return Error(playerid, "This business is out of stock product.");
				
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(bData[bizid][bType] == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pChicken]++;
						//Inventory_Add(playerid, "Fried Chicken", 19847, 1);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pPizzaP]++;
						//Inventory_Add(playerid, "Pizza Stack", 19580, 1);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pBurgerP]++;
						//Inventory_Add(playerid, "Patty Burger", 2703, 1);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli minuman seharga %s.", ReturnName(playerid), FormatMoney(price));
						pData[playerid][pSprunk]++;
					}
				}
			}
			else if(bData[bizid][bType] == 2)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli snack seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pSnack] += 1;
						ShowItemBox(playerid, "Snack", "Received_1x", 2821, 2);
						//Inventory_Add(playerid, "Snack", 2768, 1);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Sprunk seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pSprunk] += 1;
						ShowItemBox(playerid, "Water", "Received_1x", 2958, 2);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGas]++;
						//Inventory_Add(playerid, "Fuel Can", 1650, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Gas Fuel seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						ShowItemBox(playerid, "Fuel Can", "Received_1x", 1650, 2);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						new query[128], rand = RandomEx(1111, 9888);
						new phone = rand+pData[playerid][pID];
						mysql_format(g_SQL, query, sizeof(query), "SELECT phone FROM players WHERE phone='%d'", phone);
						mysql_tquery(g_SQL, query, "PhoneNumber", "id", playerid, phone);
						pData[playerid][pPhone] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli phone seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						//Inventory_Add(playerid, "Phone", 18867, 1);
					}
					case 4:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneCredit] += 30;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 20 phone credit seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 5:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneBook] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah phone book seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 6:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWT] = 1;
						//Inventory_Add(playerid, "Portable Radio", 19942, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah walkie talkie seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 7:
					{
						if(pData[playerid][pBoombox] > 0)
							return Error(playerid, "Kamu sudah memiliki boombox");
						
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBoombox] = 1;
						//Inventory_Add(playerid, "Boombox", 2226, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah boombox seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 8:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMuriatic]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 1g muriatic acid seharga %s.", ReturnName(playerid), FormatMoney(price));
						//Inventory_Add(playerid, "Muriatic", 1580, 1);
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
			else if(bData[bizid][bType] == 3)
			{
				switch(listitem)
				{
					case 0:
					{
						switch(pData[playerid][pGender])
						{
							case 1: ShowModelSelectionMenu(playerid, MaleSkins, "Choose your skin");
							case 2: ShowModelSelectionMenu(playerid, FemaleSkins, "Choose your skin");
						}
					}
					case 1:
					{
						new string[248];
						if(pToys[playerid][0][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 1\n");
						}
						else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

						if(pToys[playerid][1][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 2\n");
						}
						else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

						if(pToys[playerid][2][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 3\n");
						}
						else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

						if(pToys[playerid][3][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 4\n");
						}
						else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

						/*if(pToys[playerid][4][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 5\n");
						}
						else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

						if(pToys[playerid][5][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 6\n");
						}
						else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");*/

						ShowPlayerDialog(playerid, DIALOG_TOYBUY, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
					case 2:
					{
						if(pData[playerid][pLevel] < 3)
							return Error(playerid, "You must be level 3!");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMask] = 1;
						//Inventory_Add(playerid, "Mask", 19036, 1);
						pData[playerid][pMaskID] = random(90000) + 10000;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli mask seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHelmet] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Helmet seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
			else if(bData[bizid][bType] == 4)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 1, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Brass Knuckles seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 1:
					{
						if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7 || pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 4, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Knife seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Job farmer or job butcher only!");
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 5, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Baseball Bat seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 6, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Shovel seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Job miner only!");
					}
					case 4:
					{
						if(pData[playerid][pJob] == 3 || pData[playerid][pJob2] == 3)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 9, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Chainsaw seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Job lumber jack only!");
					}
					case 5:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 15, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Cane seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 6:
					{
						if(pData[playerid][pFishTool] > 2) return Error(playerid, "You only can get 3 fish tool!");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pFishTool]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli pancingan seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 7:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWorm] += 2;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 2 umpan cacing seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
			else if(bData[bizid][bType] == 5)
			{
				if(pData[playerid][pLevel] < 3)
					return Error(playerid, "Kamu harus level 3 untuk mengakses ini");

				switch(listitem)
				{
					case 0:
					{
						if(pData[playerid][pWeapLic] > 0)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, WEAPON_KATANA, 150); //Katana
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Katana seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Kamu tidak memiliki weapon license");
					}
					case 1:
					{
						if(pData[playerid][pWeapLic] > 0)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, WEAPON_SILENCED, 150); //Silenced
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Silenced Pistol seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Kamu tidak memiliki weapon license");
					}
					case 2:
					{
						if(pData[playerid][pWeapLic] > 0)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, WEAPON_COLT45, 150); //Colt 45
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Colt45 9MM seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Kamu tidak memiliki weapon license");
					}
					case 3:
					{
						if(pData[playerid][pWeapLic] > 0)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, WEAPON_SHOTGUN, 20); //Shotgun
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Shotgun seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Kamu tidak memiliki weapon license");
					}
					case 4:
					{
						if(pData[playerid][pWeapLic] > 0)
						{
							GivePlayerMoneyEx(playerid, -price);
							pData[playerid][pAmmoPistol] += 1;
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Clip Pistol seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Kamu tidak memiliki weapon license");
					}
					case 5:
					{
						if(pData[playerid][pWeapLic] > 0)
						{
							GivePlayerMoneyEx(playerid, -price);
							pData[playerid][pAmmoSG] += 1;
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Clip SG seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Kamu tidak memiliki weapon license");
					}
					case 6:
					{
						if(pData[playerid][pWeapLic] > 0)
						{
							GivePlayerMoneyEx(playerid, -price);
							pData[playerid][pAmmoSMG] += 1;
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Clip SMG seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Kamu tidak memiliki weapon license");
					}
				}
			}
			else if(bData[bizid][bType] == 6)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerFightingStyle(playerid, 4); //Normal
						pData[playerid][pFightingStyle] = 4;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Normal Style seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerFightingStyle(playerid, 5); //Boxing
						pData[playerid][pFightingStyle] = 5;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Boxing Style seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerFightingStyle(playerid, 6); //Kung Fu
						pData[playerid][pFightingStyle] = 6;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Kung Fu Style seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerFightingStyle(playerid, 7); //Kneehead
						pData[playerid][pFightingStyle] = 7;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Kneehead Style seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 4:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerFightingStyle(playerid, 15); //Grabkick
						pData[playerid][pFightingStyle] = 15;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Grabkick Style seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 5:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerFightingStyle(playerid, 16); //Elbow
						pData[playerid][pFightingStyle] = 16;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Elbow Style seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_EDITPROD)
	{
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
			}
			else return callcmd::bm(playerid, "\0");
		}
		return 1;
	}
    if(dialogid == BISNIS_PRICESET)
    {
        static
        item[40];
        new bizid = pData[playerid][pInBiz];
        if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
        {
            if(response)
            {
                strunpack(item, pData[playerid][pEditingItem]);
                if(isnull(inputtext))
                {
                    new str[128];
                    format(str,sizeof(str), "Please enter the new product price for %s:", item);
                    ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
                    return 1;
                }
                if(strval(inputtext) < 0 || strval(inputtext) > 10000)
                {
                    new str[128];
                    format(str,sizeof(str), "Please enter the new product price for %s ($0 to $10.000):", item);
                    ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
                    return 1;
                }

                bData[bizid][bP][pData[playerid][pProductModify]] = strval(inputtext);
                Bisnis_Save(bizid);

                Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
                Bisnis_ProductMenu(playerid, bizid);
            }
            else
            {
                Bisnis_ProductMenu(playerid, bizid);
            }
        }
        return 1;
    }
	//------------[ VEHICLE STORAGE]-------
	/*if(dialogid == VEHICLE_STORAGE)
	{
		new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					Vehicle_WeaponStorage(playerid, vehid);
				}
				case 1:
				{
					ShowPlayerDialog(playerid, VEHICLE_MONEY, DIALOG_STYLE_LIST, "Money Storage", "Deposit Money\nWithdraw Money", "Select", "Back");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Deposit Component\nWithdraw Component", "Select", "Back");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Deposit Material\nWithdraw Material", "Select", "Back");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Seeds Storage", "Deposit Seeds\nWithdraw Seeds", "Select", "Back");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Deposit Marijuana\nWithdraw Marijuana", "Select", "Back");
				}
			}
		}
		return 1;
	}*/
	if(dialogid == VEHICLE_STORAGE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, VEHICLE_MONEY, DIALOG_STYLE_LIST, "Money Storage", "Deposit Money\nWithdraw Money", "Select", "Back");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Deposit Component\nWithdraw Component", "Select", "Back");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Deposit Material\nWithdraw Material", "Select", "Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == VEHICLE_WEAPONS)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						if(pvData[i][cGun][listitem] != 0)
						{
							if(PlayerHasWeapon(playerid, pvData[i][cGun][listitem]))
								return Error(playerid, "Kamu sudah memiliki senjata tersebut");

							GivePlayerWeaponEx(playerid, pvData[i][cGun][listitem], pvData[i][cAmmo][listitem]);

							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from vehicle storage.", ReturnName(playerid), ReturnWeaponName(pvData[i][cGun][listitem]));

							pvData[i][cGun][listitem] = 0;
							pvData[i][cAmmo][listitem] = 0;

							Vehicle_WeaponStorage(playerid, vehid);
						}
						else
						{
							new
								weaponid = GetPlayerWeaponEx(playerid),
								ammo = GetPlayerAmmoEx(playerid);

							if(!weaponid)
								return Error(playerid, "You are not holding any weapon!");

							ResetWeapon(playerid, weaponid);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into vehicle storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

							pvData[i][cGun][listitem] = weaponid;
							pvData[i][cAmmo][listitem] = ammo;
							
							Vehicle_WeaponStorage(playerid, vehid);
						}
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		return 1;
	}
	if(dialogid == VEHICLE_MONEY)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						switch (listitem)
						{
							case 0: 
							{
								new str[128];
								format(str, sizeof(str), "Money Balance: %s/$100.000\n\nMasukan berapa banyak uang yang ingin kamu taruh:", FormatMoney(pvData[i][cMoney]));
								ShowPlayerDialog(playerid, VEHICLE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
							}
							case 1: 
							{
								new str[128];
								format(str, sizeof(str), "Money Balance: %s\n\nMasukan berapa banyak uang yang ingin kamu withdraw:", FormatMoney(pvData[i][cMoney]));
								ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
							}
						}
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		return 1;
	}
	if(dialogid == VEHICLE_DEPOSITMONEY)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Money Balance: %s\n\nMasukan berapa banyak uang yang ingin kamu deposit:", FormatMoney(pvData[i][cMoney]));
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
							return 1;
						}
						if(amount < 1 || amount > pData[playerid][pMoney])
						{
							new str[128];
							format(str, sizeof(str), "Error: Kamu tidak memiliki uang sebanyak itu.\n\nMoney Balance: %s/$100.000\n\nMasukan berapa banyak uang yang ingin kamu deposit:", FormatMoney(pvData[i][cMoney]));
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Money", str, "Deposit", "Back");
							return 1;
						}
						new maxmoney = pvData[i][cMoney] + amount;
						if(maxmoney > 100000)
						{
							new str[128];
							format(str, sizeof(str), "Error: Anda tidak bisa memasukan uang lebih dari batas slot.\n\nMoney Balance: %s/$100.000\n\nMasukan berapa banyak uang yang ingin kamu deposit:", FormatMoney(pvData[i][cMoney]));
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
							return 1;
						}
						pvData[i][cMoney] += amount;
						GivePlayerMoneyEx(playerid, -amount);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into their vehicle storage.", ReturnName(playerid), FormatMoney(amount));
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_MONEY, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Money\nWithdraw Money", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_WITHDRAWMONEY)
	{	
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Money Balance: %s\n\nMasukan berapa banyak uang yang ingin kamu withdraw:", FormatMoney(pvData[i][cMoney]));
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
							return 1;
						}
						if(amount < 1 || amount > pvData[i][cMoney])
						{
							new str[128];
							format(str, sizeof(str), "Error: Dana tidak mencukupi.\n\nMoney Balance: %s\n\nMasukan berapa banyak uang yang ingin kamu withdraw:", FormatMoney(pvData[i][cMoney]));
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Money", str, "Withdraw", "Back");
							return 1;
						}
						pvData[i][cMoney] -= amount;
						GivePlayerMoneyEx(playerid, amount);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from their vehicle storage.", ReturnName(playerid), FormatMoney(amount));
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_MONEY, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Money\nWithdraw Money", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_COMPONENT)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						switch (listitem)
						{
							case 0: 
							{
								new str[128];
								format(str, sizeof(str), "Component balance: %d/2500\n\nMasukan berapa banyak component yang ingin kamu taruh:", pvData[i][cComponent]);
								ShowPlayerDialog(playerid, VEHICLE_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
							}
							case 1: 
							{
								new str[128];
								format(str, sizeof(str), "Component balance: %d\n\nMasukan berapa banyak component yang ingin kamu ambil:", pvData[i][cComponent]);
								ShowPlayerDialog(playerid, VEHICLE_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
							}
						}
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		return 1;
	}
	if(dialogid == VEHICLE_DEPOSITCOMPONENT)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Component balance: %d/2500\n\nMasukan berapa banyak component yang ingin kamu deposit:", pvData[i][cComponent]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
							return 1;
						}
						if(amount < 1 || amount > pData[playerid][pComponent])
						{
							new str[128];
							format(str, sizeof(str), "Error: Component yang anda miliki tidak mencukupi.\n\nComponent Balance: %d/2500\n\nMasukan berapa banyak component yang ingin kamu deposit:", pvData[i][cComponent]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
							return 1;
						}
						new maxmat = pvData[i][cComponent] + amount;
						if(maxmat > 2500)
						{
							new str[128];
							format(str, sizeof(str), "Error: Anda tidak bisa memasukan component lebih dari batas slot.\n\nComponent Balance: %d/2500\n\nMasukan berapa banyak component yang ingin kamu deposit:", pvData[i][cComponent]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit Component", str, "Deposit", "Back");
							return 1;
						}
						pvData[i][cComponent] += amount;
						pData[playerid][pComponent] -= amount;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d component into their vehicle storage.", ReturnName(playerid), amount);
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Component\nWithdraw Component", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_WITHDRAWCOMPONENT)
	{	
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Component Balance: %d\n\nMasukan berapa banyak component yang ingin kamu withdraw:", pvData[i][cComponent]);
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
							return 1;
						}
						if(amount < 1 || amount > pvData[i][cComponent])
						{
							new str[128];
							format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nMasukan berapa banyak component yang ingin kamu withdraw:", pvData[i][cComponent]);
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw Component", str, "Withdraw", "Back");
							return 1;
						}
						pData[playerid][pComponent] += amount;
						pvData[i][cComponent] -= amount;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d component from their vehicle storage.", ReturnName(playerid), amount);
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Component\nWithdraw Component", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_MATERIAL)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						switch (listitem)
						{
							case 0: 
							{
								new str[128];
								format(str, sizeof(str), "Material balance: %d/2500\n\nMasukan berapa banyak material yang ingin kamu taruh:", pvData[i][cMaterial]);
								ShowPlayerDialog(playerid, VEHICLE_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit Material", str, "Deposit", "Back");
							}
							case 1: 
							{
								new str[128];
								format(str, sizeof(str), "Material balance: %d\n\nMasukan berapa banyak material yang ingin kamu ambil:", pvData[i][cMaterial]);
								ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw Material", str, "Withdraw", "Back");
							}
						}
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		return 1;
	}
	if(dialogid == VEHICLE_DEPOSITMATERIAL)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Material balance: %d\n\nMasukan berapa banyak material yang ingin kamu deposit:", pvData[i][cMaterial]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit Material", str, "Deposit", "Back");
							return 1;
						}
						if(amount < 1 || amount > pData[playerid][pMaterial])
						{
							new str[128];
							format(str, sizeof(str), "Error: Material yang anda miliki tidak mencukupi.\n\nMaterial Balance: %d/2500\n\nMasukan berapa banyak material yang ingin kamu deposit:", pvData[i][cMaterial]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit Material", str, "Deposit", "Back");
							return 1;
						}
						new maxmat = pvData[i][cMaterial] + amount;
						if(maxmat > 2500)
						{
							new str[128];
							format(str, sizeof(str), "Error: Anda tidak bisa memasukan material lebih dari batas slot.\n\nMaterial Balance: %d/2500\n\nMasukan berapa banyak material yang ingin kamu deposit:", pvData[i][cMaterial]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit Material", str, "Deposit", "Back");
							return 1;
						}
						pvData[i][cMaterial] += amount;
						pData[playerid][pMaterial] -= amount;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d material into their vehicle storage.", ReturnName(playerid), amount);
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Material\nWithdraw Material", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_WITHDRAWMATERIAL)
	{	
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Material Balance: %d\n\nMasukan berapa banyak material yang ingin kamu withdraw:", pvData[i][cMaterial]);
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw Material", str, "Withdraw", "Back");
							return 1;
						}
						if(amount < 1 || amount > pvData[i][cMaterial])
						{
							new str[128];
							format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d/2500\n\nMasukan berapa banyak material yang ingin kamu withdraw:", pvData[i][cMaterial]);
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw Material", str, "Withdraw", "Back");
							return 1;
						}
						pData[playerid][pMaterial] += amount;
						pvData[i][cMaterial] -= amount;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d material from their vehicle storage.", ReturnName(playerid), amount);
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Material\nWithdraw Material", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_SEED)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						switch (listitem)
						{
							case 0: 
							{
								new str[128];
								format(str, sizeof(str), "Seed balance: %d/1000\n\nMasukan berapa banyak seed yang ingin kamu taruh:", pvData[i][cSeed]);
								ShowPlayerDialog(playerid, VEHICLE_DEPOSITSEED, DIALOG_STYLE_INPUT, "Deposit Seed", str, "Deposit", "Back");
							}
							case 1: 
							{
								new str[128];
								format(str, sizeof(str), "Seed balance: %d\n\nMasukan berapa banyak seed yang ingin kamu ambil:", pvData[i][cSeed]);
								ShowPlayerDialog(playerid, VEHICLE_WITHDRAWSEED, DIALOG_STYLE_INPUT, "Withdraw Seed", str, "Withdraw", "Back");
							}
						}
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		return 1;
	}
	if(dialogid == VEHICLE_DEPOSITSEED)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Seed balance: %d/1000\n\nMasukan berapa banyak seed yang ingin kamu deposit:", pvData[i][cSeed]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITSEED, DIALOG_STYLE_INPUT, "Deposit Seed", str, "Deposit", "Back");
							return 1;
						}
						if(amount < 1 || amount > pData[playerid][pSeed])
						{
							new str[128];
							format(str, sizeof(str), "Error: Seed yang anda miliki tidak mencukupi.\n\nSeed Balance: %d/1000\n\nMasukan berapa banyak seed yang ingin kamu deposit:", pvData[i][cSeed]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITSEED, DIALOG_STYLE_INPUT, "Deposit Seed", str, "Deposit", "Back");
							return 1;
						}
						new maxseed = pvData[i][cSeed] + amount;
						if(maxseed > 1000)
						{
							new str[128];
							format(str, sizeof(str), "Error: Anda tidak bisa memasukan seed lebih dari batas slot.\n\nSeed Balance: %d/1000\n\nMasukan berapa banyak seed yang ingin kamu deposit:", pvData[i][cSeed]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITSEED, DIALOG_STYLE_INPUT, "Deposit Seed", str, "Deposit", "Back");
							return 1;
						}
						pvData[i][cSeed] += amount;
						pData[playerid][pSeed] -= amount;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d seed into their vehicle storage.", ReturnName(playerid), amount);
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Seed\nWithdraw Seed", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_WITHDRAWSEED)
	{	
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Seed Balance: %d\n\nMasukan berapa banyak seed yang ingin kamu withdraw:", pvData[i][cSeed]);
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWSEED, DIALOG_STYLE_INPUT, "Withdraw Seed", str, "Withdraw", "Back");
							return 1;
						}
						if(amount < 1 || amount > pvData[i][cSeed])
						{
							new str[128];
							format(str, sizeof(str), "Error: Insufficient funds.\n\nSeed Balance: %d\n\nMasukan berapa banyak seed yang ingin kamu withdraw:", pvData[i][cSeed]);
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWSEED, DIALOG_STYLE_INPUT, "Withdraw Seed", str, "Withdraw", "Back");
							return 1;
						}
						pData[playerid][pSeed] += amount;
						pvData[i][cSeed] -= amount;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d seed from their vehicle storage.", ReturnName(playerid), amount);
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Seed\nWithdraw Seed", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_MARIJUANA)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						switch (listitem)
						{
							case 0: 
							{
								new str[128];
								format(str, sizeof(str), "Marijuana balance: %dkg/100kg\n\nMasukan berapa banyak marijuana yang ingin kamu taruh:", pvData[i][cMarijuana]);
								ShowPlayerDialog(playerid, VEHICLE_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit Marijuana", str, "Deposit", "Back");
							}
							case 1: 
							{
								new str[128];
								format(str, sizeof(str), "Marijuana balance: %dkg\n\nMasukan berapa banyak marijuana yang ingin kamu ambil:", pvData[i][cMarijuana]);
								ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw Marijuana", str, "Withdraw", "Back");
							}
						}
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		return 1;
	}
	if(dialogid == VEHICLE_DEPOSITMARIJUANA)
	{
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Marijuana balance: %dkg/100kg\n\nMasukan berapa banyak marijuana yang ingin kamu deposit:", pvData[i][cMarijuana]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit Marijuana", str, "Deposit", "Back");
							return 1;
						}
						if(amount < 1 || amount > pData[playerid][pMarijuana])
						{
							new str[128];
							format(str, sizeof(str), "Error: Marijuana yang anda miliki tidak mencukupi.\n\nMarijuana Balance: %dkg/100kg\n\nMasukan berapa banyak marijuana yang ingin kamu deposit:", pvData[i][cMarijuana]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit Marijuana", str, "Deposit", "Back");
							return 1;
						}
						new maxmarijuana = pvData[i][cMarijuana] + amount;
						if(maxmarijuana > 500)
						{
							new str[128];
							format(str, sizeof(str), "Error: Anda tidak bisa memasukan marijuana lebih dari batas slot.\n\nMarijuana Balance: %dkg/100kg\n\nMasukan berapa banyak marijuana yang ingin kamu deposit:", pvData[i][cMarijuana]);
							ShowPlayerDialog(playerid, VEHICLE_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit Marijuana", str, "Deposit", "Back");
							return 1;
						}
						pvData[i][cMarijuana] += amount;
						pData[playerid][pMarijuana] -= amount;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d marijuana into their vehicle storage.", ReturnName(playerid), amount);
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Marijuana\nWithdraw Marijuana", "Select", "Back");
		return 1;
	}
	if(dialogid == VEHICLE_WITHDRAWMARIJUANA)
	{	
		if(response)
		{
			new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			foreach(new i : PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
					if(pvData[i][cOwner] == pData[playerid][pID])
					{
						new amount = strval(inputtext);
						if(isnull(inputtext))
						{
							new str[128];
							format(str, sizeof(str), "Marijuana Balance: %dkg\n\nMasukan berapa banyak marijuana yang ingin kamu withdraw:", pvData[i][cMarijuana]);
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw Marijuana", str, "Withdraw", "Back");
							return 1;
						}
						if(amount < 1 || amount > pvData[i][cMarijuana])
						{
							new str[128];
							format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %dkg\n\nMasukan berapa banyak marijuana yang ingin kamu withdraw:", pvData[i][cMarijuana]);
							ShowPlayerDialog(playerid, VEHICLE_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw Marijuana", str, "Withdraw", "Back");
							return 1;
						}
						pData[playerid][pMarijuana] += amount;
						pvData[i][cMarijuana] -= amount;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d marijuana from their vehicle storage.", ReturnName(playerid), amount);
					}
					else return Error(playerid, "kendaraan ini bukan milikmu.");
				}
			}
		}
		else return ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Vehicle Storage", "Deposit Marijuana\nWithdraw Marijuana", "Select", "Back");
		return 1;
	}
	//-----------[ House Dialog ]------------------
	if(dialogid == DIALOG_SELL_HOUSES)
	{
		if(!response) 
			return 1;
		
		new str[248];
		SetPVarInt(playerid, "SellingHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell house id: %d", GetPVarInt(playerid, "SellingHouse"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "Sell House", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_HOUSE)
	{
		if(response)
		{
			new hid = GetPVarInt(playerid, "SellingHouse"), price;

			if(hData[hid][hLocked] >= 2)
        		return Error(playerid, "Kamu tidak dapat menjual rumah yang sedang disegel oleh pemerintah");

			price = hData[hid][hPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual rumah id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", hid, FormatMoney(price));
			HouseReset(hid);
			House_Save(hid);
			House_Refresh(hid);
		}
		DeletePVar(playerid, "SellingHouse");
		return 1;
	}
	if(dialogid == DIALOG_MY_HOUSES)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, HOUSE_INFO, DIALOG_STYLE_LIST, "{FF0000}Konoha:RP {0000FF}Houses", "Show Information\nTrack House", "Select", "Cancel");
		return 1;
	}
	if(dialogid == HOUSE_INFO)
	{
		if(!response) return 1;
		new hid = GetPVarInt(playerid, "ClickedHouse");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(hData[hid][hLocked] == 0)
				{
					lock = ""GREEN_LIGHT"Unlocked"WHITE_E"";
				}
				else if(hData[hid][hLocked] == 1)
				{
					lock = ""RED_E"Locked"WHITE_E"";
				}
				else
				{
					lock = ""RED_E"Sealed"WHITE_E"";
				}
				if(hData[hid][hType] == 1)
				{
					type = "Low";
			
				}
				else if(hData[hid][hType] == 2)
				{
					type = "Medium";
				}
				else if(hData[hid][hType] == 3)
				{
					type = "High";
				}
				else
				{
					type = "Unknown";
				}
				format(line9, sizeof(line9), "House ID: %d\nHouse Owner: %s\nHouse Address: %s\nHouse Price: %s\nHouse Type: %s\nHouse Status: %s",
				hid, hData[hid][hOwner], hData[hid][hAddress], FormatMoney(hData[hid][hPrice]), type, lock);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "House Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackHouse] = 1;
				SetPlayerRaceCheckpoint(playerid,1, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan rumah anda!");
			}
		}
		return 1;
	}
	if(dialogid == HOUSE_STORAGE)
	{
		new hid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) 
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this house.");
		if(response)
		{
			if(listitem == 0) 
			{
				House_WeaponStorage(playerid, hid);
			}
			else if(listitem == 1) 
			{
				ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			else if(listitem == 2) 
			{
				ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			else if(listitem == 3) 
			{
				ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			else if(listitem == 4) 
			{
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			else if(listitem == 5) 
			{
				ShowPlayerDialog(playerid, HOUSE_EPHEDRINE, DIALOG_STYLE_LIST, "Ephedrine Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			else if(listitem == 6) 
			{
				ShowPlayerDialog(playerid, HOUSE_COCAINE, DIALOG_STYLE_LIST, "Cocaine Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			else if(listitem == 7) 
			{
				ShowPlayerDialog(playerid, HOUSE_METH, DIALOG_STYLE_LIST, "Meth Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == HOUSE_WEAPONS)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) 
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this house.");
				
		if(response)
		{
			if(hData[houseid][hWeapon][listitem] != 0)
			{
				if(PlayerHasWeapon(playerid, hData[houseid][hWeapon][listitem]))
					return Error(playerid, "Kamu sudah memiliki senjata tersebut");

				GivePlayerWeaponEx(playerid, hData[houseid][hWeapon][listitem], hData[houseid][hAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(hData[houseid][hWeapon][listitem]));

				hData[houseid][hWeapon][listitem] = 0;
				hData[houseid][hAmmo][listitem] = 0;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				hData[houseid][hWeapon][listitem] = weaponid;
				hData[houseid][hAmmo][listitem] = ammo;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
		}
		else
		{
			House_OpenStorage(playerid, houseid);
		}
		return 1;
	}
	//HOUSE MONEY STORAGE
	if(dialogid == HOUSE_MONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext), maxmoney;
			if(hData[houseid][hType] == 1)
			{
				maxmoney = 1000000;
			}
			else if(hData[houseid][hType] == 2)
			{
				maxmoney = 3000000;
			}
			else if(hData[houseid][hType] == 3)
			{
				maxmoney = 5000000;
			}

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s/%s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]), FormatMoney(maxmoney));
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s/%s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]), FormatMoney(maxmoney));
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(hData[houseid][hMoney] + amount > maxmoney)
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s/%s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]), FormatMoney(maxmoney));
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//HOUSE COMPONENT STORAGE
	if(dialogid == HOUSE_COMPONENT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", hData[houseid][hComponent]);
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", hData[houseid][hComponent]);
					ShowPlayerDialog(playerid, HOUSE_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWCOMPONENT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", hData[houseid][hComponent]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", hData[houseid][hComponent]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hComponent] -= amount;
			pData[playerid][pComponent] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d component from their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITCOMPONENT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext), maxcomp;
			if(hData[houseid][hType] == 1)
			{
				maxcomp = 5000;
			}
			else if(hData[houseid][hType] == 2)
			{
				maxcomp = 10000;
			}
			else if(hData[houseid][hType] == 3)
			{
				maxcomp = 15000;
			}

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %d/%d\n\nPlease enter how much component you wish to deposit into the safe:", hData[houseid][hComponent], maxcomp);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d/%d\n\nPlease enter how much component you wish to deposit into the safe:", hData[houseid][hComponent], maxcomp);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(hData[houseid][hComponent] + amount > maxcomp)
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d/%d\n\nPlease enter how much component you wish to deposit into the safe:", hData[houseid][hComponent], maxcomp);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hComponent] += amount;
			pData[playerid][pComponent] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d component into their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//HOUSE MATERIAL STORAGE
	if(dialogid == HOUSE_MATERIAL)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", hData[houseid][hMaterial]);
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", hData[houseid][hMaterial]);
					ShowPlayerDialog(playerid, HOUSE_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWMATERIAL)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", hData[houseid][hMaterial]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", hData[houseid][hMaterial]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}

			hData[houseid][hMaterial] -= amount;
			pData[playerid][pMaterial] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d material from their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITMATERIAL)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext), maxmat;
			if(hData[houseid][hType] == 1)
			{
				maxmat = 5000;
			}
			else if(hData[houseid][hType] == 2)
			{
				maxmat = 10000;
			}
			else if(hData[houseid][hType] == 3)
			{
				maxmat = 15000;
			}

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %d/%d\n\nPlease enter how much material you wish to deposit into the safe:", hData[houseid][hMaterial], maxmat);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d/%d\n\nPlease enter how much material you wish to deposit into the safe:", hData[houseid][hMaterial], maxmat);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(hData[houseid][hMaterial] + amount > maxmat)
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d/%d\n\nPlease enter how much material you wish to deposit into the safe:", hData[houseid][hMaterial], maxmat);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hMaterial] += amount;
			pData[playerid][pMaterial] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d material into their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_MARIJUANA)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much marijuana you wish to withdraw from the safe:", hData[houseid][hMarijuana]);
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much marijuana you wish to deposit into the safe:", hData[houseid][hMarijuana]);
					ShowPlayerDialog(playerid, HOUSE_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWMARIJUANA)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much marijuana you wish to withdraw from the safe:", hData[houseid][hMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg\n\nPlease enter how much marijuana you wish to withdraw from the safe:", hData[houseid][hMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hMarijuana] -= amount;
			pData[playerid][pMarijuana] += amount;
			//Inventory_Add(playerid, "Marijuana", 1580, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %dg marijuana from their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITMARIJUANA)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext), maxmarijuana;
			if(hData[houseid][hType] == 1)
			{
				maxmarijuana = 1000;
			}
			else if(hData[houseid][hType] == 2)
			{
				maxmarijuana = 3000;
			}
			else if(hData[houseid][hType] == 3)
			{
				maxmarijuana = 5000;
			}
			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %dg/%dg\n\nPlease enter how much marijuana you wish to deposit into the safe:", hData[houseid][hMarijuana], maxmarijuana);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg/%dg\n\nPlease enter how much marijuana you wish to deposit into the safe:", hData[houseid][hMarijuana], maxmarijuana);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(hData[houseid][hMarijuana] + amount > maxmarijuana)
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg/%dg\n\nPlease enter how much marijuana you wish to deposit into the safe:", hData[houseid][hMaterial], maxmarijuana);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hMarijuana] += amount;
			//pData[playerid][pMarijuana] -= amount;
			Inventory_Remove(playerid, "Marijuana", amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %dg marijuana into their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_EPHEDRINE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Ephedrine you wish to withdraw from the safe:", hData[houseid][hEphedrine]);
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWEPHEDRINE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Ephedrine you wish to deposit into the safe:", hData[houseid][hEphedrine]);
					ShowPlayerDialog(playerid, HOUSE_DEPOSITEPHEDRINE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWEPHEDRINE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Ephedrine you wish to withdraw from the safe:", hData[houseid][hEphedrine]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWEPHEDRINE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hEphedrine])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg\n\nPlease enter how much Ephedrine you wish to withdraw from the safe:", hData[houseid][hEphedrine]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWEPHEDRINE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hEphedrine] -= amount;
			pData[playerid][pEphedrine] += amount;
			//Inventory_Add(playerid, "Ephedrine", 1580, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %dg Ephedrine from their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_EPHEDRINE, DIALOG_STYLE_LIST, "Ephedrine Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITEPHEDRINE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext), maxephedrine;
			if(hData[houseid][hType] == 1)
			{
				maxephedrine = 1000;
			}
			else if(hData[houseid][hType] == 2)
			{
				maxephedrine = 3000;
			}
			else if(hData[houseid][hType] == 3)
			{
				maxephedrine = 5000;
			}
			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %dg/%dg\n\nPlease enter how much Ephedrine you wish to deposit into the safe:", hData[houseid][hEphedrine], maxephedrine);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITEPHEDRINE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pEphedrine])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg/%dg\n\nPlease enter how much Ephedrine you wish to deposit into the safe:", hData[houseid][hEphedrine], maxephedrine);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITEPHEDRINE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(hData[houseid][hEphedrine] + amount > maxephedrine)
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg/%dg\n\nPlease enter how much Ephedrine you wish to deposit into the safe:", hData[houseid][hMaterial], maxephedrine);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITEPHEDRINE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hEphedrine] += amount;
			//pData[playerid][pEphedrine] -= amount;
			Inventory_Remove(playerid, "Ephedrine", amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %dg Ephedrine into their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_EPHEDRINE, DIALOG_STYLE_LIST, "Ephedrine Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_COCAINE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Cocaine you wish to withdraw from the safe:", hData[houseid][hCocaine]);
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWCOCAINE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Cocaine you wish to deposit into the safe:", hData[houseid][hCocaine]);
					ShowPlayerDialog(playerid, HOUSE_DEPOSITCOCAINE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWCOCAINE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Cocaine you wish to withdraw from the safe:", hData[houseid][hCocaine]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWCOCAINE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hCocaine])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg\n\nPlease enter how much Cocaine you wish to withdraw from the safe:", hData[houseid][hCocaine]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWCOCAINE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hCocaine] -= amount;
			pData[playerid][pCocaine] += amount;
			//Inventory_Add(playerid, "Cocaine", 1580, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %dg Cocaine from their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_COCAINE, DIALOG_STYLE_LIST, "Cocaine Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITCOCAINE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext), maxcocaine;
			if(hData[houseid][hType] == 1)
			{
				maxcocaine = 1000;
			}
			else if(hData[houseid][hType] == 2)
			{
				maxcocaine = 3000;
			}
			else if(hData[houseid][hType] == 3)
			{
				maxcocaine = 5000;
			}
			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %dg/%dg\n\nPlease enter how much Cocaine you wish to deposit into the safe:", hData[houseid][hCocaine], maxcocaine);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITCOCAINE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pCocaine])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg/%dg\n\nPlease enter how much Cocaine you wish to deposit into the safe:", hData[houseid][hCocaine], maxcocaine);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITCOCAINE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(hData[houseid][hCocaine] + amount > maxcocaine)
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg/%dg\n\nPlease enter how much Cocaine you wish to deposit into the safe:", hData[houseid][hMaterial], maxcocaine);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITCOCAINE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hCocaine] += amount;
			//pData[playerid][pCocaine] -= amount;
			Inventory_Remove(playerid, "Cocaine", amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %dg Cocaine into their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_COCAINE, DIALOG_STYLE_LIST, "Cocaine Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_METH)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Meth you wish to withdraw from the safe:", hData[houseid][hMeth]);
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWMETH, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Meth you wish to deposit into the safe:", hData[houseid][hMeth]);
					ShowPlayerDialog(playerid, HOUSE_DEPOSITMETH, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWMETH)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %dg\n\nPlease enter how much Meth you wish to withdraw from the safe:", hData[houseid][hMeth]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMETH, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMeth])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg\n\nPlease enter how much Meth you wish to withdraw from the safe:", hData[houseid][hMeth]);
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMETH, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hMeth] -= amount;
			pData[playerid][pMeth] += amount;
			//Inventory_Add(playerid, "Meth", 1580, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %dg Meth from their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_METH, DIALOG_STYLE_LIST, "Meth Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITMETH)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse2(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext), maxmeth;
			if(hData[houseid][hType] == 1)
			{
				maxmeth = 1000;
			}
			else if(hData[houseid][hType] == 2)
			{
				maxmeth = 3000;
			}
			else if(hData[houseid][hType] == 3)
			{
				maxmeth = 5000;
			}
			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %dg/%dg\n\nPlease enter how much Meth you wish to deposit into the safe:", hData[houseid][hMeth], maxmeth);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMETH, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMeth])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg/%dg\n\nPlease enter how much Meth you wish to deposit into the safe:", hData[houseid][hMeth], maxmeth);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMETH, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(hData[houseid][hMeth] + amount > maxmeth)
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %dg/%dg\n\nPlease enter how much Meth you wish to deposit into the safe:", hData[houseid][hMaterial], maxmeth);
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMETH, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hMeth] += amount;
			//pData[playerid][pMeth] -= amount;
			Inventory_Remove(playerid, "Meth", amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %dg Meth into their house safe.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_METH, DIALOG_STYLE_LIST, "Meth Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//------------[ Private Player Vehicle Dialog ]--------
	if(dialogid == DIALOG_PVEHMENU)
	{
		if(!response)
			return 1;
		{
			SetPVarInt(playerid, "ClickedPVeh", ReturnPVehiclesID(playerid, (listitem + 1)));

			new string[1024];
			format(string, sizeof(string), "Track Vehicle");
			ShowPlayerDialog(playerid, DIALOG_PVEHMENULIST, DIALOG_STYLE_LIST, "Vehicles Menu", string, "Select", "Close");
		}
	}
	if(dialogid == DIALOG_PVEHMENULIST)
	{
		new id = GetPVarInt(playerid, "ClickedPVeh");
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pvData[id][cParkid] != -1)
					{
						new gkid = pvData[id][cParkid];
						DisablePlayerRaceCheckpoint(playerid);
						SetPlayerRaceCheckpoint(playerid, 1, gkData[gkid][gkX], gkData[gkid][gkY], gkData[gkid][gkZ], 0.0, 0.0, 0.0, 3.5);
						Info(playerid, "Kendaraan %s (ID: %d) yang berlokasi di Public Park %s (PARKID: %d) telah ditandai", GetVehicleModelName(pvData[id][cModel]), pvData[id][cVeh], GetLocation(gkData[gkid][gkX], gkData[gkid][gkY], gkData[gkid][gkZ]), pvData[id][cParkid]);
					}
					else
					{
						new Float:x, Float:y, Float:z;
						GetVehiclePos(pvData[id][cVeh], x, y, z);
						DisablePlayerRaceCheckpoint(playerid);
						SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
						Info(playerid, "Kendaraan %s (ID: %d) yang berlokasi di %s telah ditandai", GetVehicleModelName(pvData[id][cModel]), pvData[id][cVeh], GetLocation(x, y, z));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOTOVEH)
	{
		if(response) 
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			GetVehiclePos(carid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your teleport to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetPlayerPosition(playerid, posisiX, posisiY, posisiZ+3.0, 4.0, 0);
		}
		return 1;
	}
	if(dialogid == DIALOG_GETVEH)
	{
		if(response) 
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			GetPlayerPos(playerid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your get spawn vehicle to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetVehiclePos(carid, posisiX, posisiY, posisiZ+0.5);
		}
		return 1;
	}
	if(dialogid == DIALOG_DELETEVEH)
	{
		if(response) 
		{
			new carid = strval(inputtext);
			
			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)			
			{
				if(carid == pvData[i][cVeh])
				{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					DestroyVehicle(pvData[i][cVeh]);
					Iter_SafeRemove(PVehicles, i, i);
					Servers(playerid, "Your deleted private vehicle id %d (database id: %d).", pvData[i][cVeh], pvData[i][cID]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPLATE)
	{
		if(response) 
		{
			new carid = strval(inputtext);
			
			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)
			{
				if(carid == pvData[i][cVeh])
				{
					if(pData[playerid][pMoney] < 500) return Error(playerid, "Anda butuh $500 untuk membeli Plate baru.");
					GivePlayerMoneyEx(playerid, -500);
					new rand = RandomEx(1111, 9999);
					format(pvData[i][cPlate], 32, "IDX-%d", rand);
					SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
					pvData[i][cPlateTime] = gettime() + (15 * 86400);
					Info(playerid, "Model: %s || New plate: %s || Plate Time: %s || Plate Price: $500", GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				}
			}
		}
		return 1;
	}
	//--------------[ Player Toy Dialog ]-------------
	if(dialogid == DIALOG_TOY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot"Hide/Show Toy\n"GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot"Hide/Show Toy\n"GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot"Hide/Show Toy\n"GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot"Hide/Show Toy\n"GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 4:
				{
					if(pData[playerid][PurchasedToy] == true)
					{
						for(new i = 0; i < 4; i++)
						{
							pToys[playerid][i][toy_model] = 0;
							pToys[playerid][i][toy_bone] = 1;
							pToys[playerid][i][toy_hide] = 0;
							pToys[playerid][i][toy_x] = 0.0;
							pToys[playerid][i][toy_y] = 0.0;
							pToys[playerid][i][toy_z] = 0.0;
							pToys[playerid][i][toy_rx] = 0.0;
							pToys[playerid][i][toy_ry] = 0.0;
							pToys[playerid][i][toy_rz] = 0.0;
							pToys[playerid][i][toy_sx] = 1.0;
							pToys[playerid][i][toy_sy] = 1.0;
							pToys[playerid][i][toy_sz] = 1.0;
							
							if(IsPlayerAttachedObjectSlotUsed(playerid, i))
							{
								RemovePlayerAttachedObject(playerid, i);
							}
						}
						new string[128];
						mysql_format(g_SQL, string, sizeof(string), "DELETE FROM toys WHERE Owner = '%s'", pData[playerid][pName]);
						mysql_tquery(g_SQL, string);
						pData[playerid][PurchasedToy] = false;
						GameTextForPlayer(playerid, "~r~~h~All Toy Rested!~y~!", 3000, 4);
					}
				}
				/*case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"GloryPeace:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"GloryPeace:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"GloryPeace:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"GloryPeace:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}*/
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYEDIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // edit
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat mengedit toys yang sedang hide!");

					//if(IsPlayerAndroid(playerid))
					//	return Error(playerid, "You're connected from android. This feature only for PC users!");
						
					EditAttachedObject(playerid, pData[playerid][toySelected]);
					InfoTD_MSG(playerid, 4000, "~b~~h~You are now editing your toy.");
				}
				case 1: // change bone
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat mengedit toys yang sedang hide!");

					new finstring[750];

					strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
					strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");

					ShowPlayerDialog(playerid, DIALOG_TOYPOSISI, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP"WHITE_E"Player Toys", finstring, "Select", "Cancel");
				}
				case 2: //Hide or Show toy
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
					{
						pToys[playerid][pData[playerid][toySelected]][toy_hide] = 0;

						SetPlayerAttachedObject(playerid,
						pData[playerid][toySelected],
						pToys[playerid][pData[playerid][toySelected]][toy_model],
						pToys[playerid][pData[playerid][toySelected]][toy_bone],
						pToys[playerid][pData[playerid][toySelected]][toy_x],
						pToys[playerid][pData[playerid][toySelected]][toy_y],
						pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx],
						pToys[playerid][pData[playerid][toySelected]][toy_ry],
						pToys[playerid][pData[playerid][toySelected]][toy_rz],
						pToys[playerid][pData[playerid][toySelected]][toy_sx],
						pToys[playerid][pData[playerid][toySelected]][toy_sy],
						pToys[playerid][pData[playerid][toySelected]][toy_sz]);

						//MySQL_SavePlayerToys(playerid);
						SetPVarInt(playerid, "UpdatedToy", 1);
						GameTextForPlayer(playerid, "~r~~h~Toy Showed~y~!", 3000, 4);
					}
					else
					{
						pToys[playerid][pData[playerid][toySelected]][toy_hide] = 1;
						if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
						{
							RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
						}
						//MySQL_SavePlayerToys(playerid);
						SetPVarInt(playerid, "UpdatedToy", 1);
						GameTextForPlayer(playerid, "~r~~h~Toy Hide~y~!", 3000, 4);
					}
				}
				case 3: // remove toy
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
					{
						RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
					}

					pToys[playerid][pData[playerid][toySelected]][toy_model] = 0;
					pToys[playerid][pData[playerid][toySelected]][toy_hide] = 0;

					GameTextForPlayer(playerid, "~r~~h~Toy Removed~y~!", 3000, 4);
					SetPVarInt(playerid, "UpdatedToy", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 4:	//share toy pos
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat membagikan kordinat toys yang sedang di hide!");

					SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[TOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f",
					ReturnName(playerid), pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
					pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
				}
				case 5: //Pos X
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat mengedit toys yang sedang di hide!");

					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosX: %f\nInput new Toy PosX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_x]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSX, DIALOG_STYLE_INPUT, "Toy PosX", mstr, "Edit", "Cancel");
				}
				case 6: //Pos Y
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat mengedit toys yang sedang di hide!");

					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosY: %f\nInput new Toy PosY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_y]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSY, DIALOG_STYLE_INPUT, "Toy PosY", mstr, "Edit", "Cancel");
				}
				case 7: //Pos Z
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat mengedit toys yang sedang di hide!");

					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosZ: %f\nInput new Toy PosZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_z]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSZ, DIALOG_STYLE_INPUT, "Toy PosZ", mstr, "Edit", "Cancel");
				}
				case 8: //Pos RX
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat mengedit toys yang sedang di hide!");

					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRX: %f\nInput new Toy PosRX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rx]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRX, DIALOG_STYLE_INPUT, "Toy PosRX", mstr, "Edit", "Cancel");
				}
				case 9: //Pos RY
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat mengedit toys yang sedang di hide!");

					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRY: %f\nInput new Toy PosRY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_ry]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Cancel");
				}
				case 10: //Pos RZ
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_hide] != 0)
						return Error(playerid, "Kamu tidak dapat mengedit toys yang sedang di hide!");

					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rz]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSISI)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
			{
				RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
			}
			listitem = pData[playerid][toySelected];
			SetPlayerAttachedObject(playerid,
					listitem,
					pToys[playerid][listitem][toy_model],
					pToys[playerid][listitem][toy_bone],
					pToys[playerid][listitem][toy_x],
					pToys[playerid][listitem][toy_y],
					pToys[playerid][listitem][toy_z],
					pToys[playerid][listitem][toy_rx],
					pToys[playerid][listitem][toy_ry],
					pToys[playerid][listitem][toy_rz],
					pToys[playerid][listitem][toy_sx],
					pToys[playerid][listitem][toy_sy],
					pToys[playerid][listitem][toy_sz]);
			GameTextForPlayer(playerid, "~g~~h~Bone Changed~y~!", 3000, 4);
			SetPVarInt(playerid, "UpdatedToy", 1);
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSISIBUY)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			SetPlayerAttachedObject(playerid, pData[playerid][toySelected], pToys[playerid][pData[playerid][toySelected]][toy_model], listitem);
			//EditAttachedObject(playerid, pData[playerid][toySelected]);
			InfoTD_MSG(playerid, 5000, "~g~~h~Object Attached!~n~~w~Adjust the position than click on the save icon!");
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYBUY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYVIP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_x] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_y] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_z] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_rx] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_ry] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_rz] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	//-----------[ Player Commands Dialog ]----------
	if(dialogid == DIALOG_HELP)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, "Commands\tInformation\n");
				strcat(str, "/settings\tUntuk membuka menu setting akunmu\n");
				strcat(str, "/email\tUntuk mengaitkan email pada akunmu\n");
				strcat(str, "/changepass\tUntuk mengganti password pada akunmu\n");
				strcat(str, "/stats\tUntuk melihat statistik akunmu\n");
				strcat(str, "/savestats\tUntuk menyimpan statistik akunmu");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Account Commands", str, "Close", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, ""LG_E"PLAYER: /help /afk /drag /undrag /pay /stats /items /frisk /use /give /idcard /drivelic /togphone /reqloc /shareloc\n");
				strcat(str, ""LG_E"PLAYER: /weapon /settings /ask /answer /mask /helmet /death /accept /deny /revive /buy /health /destroycp /phone\n");
				strcat(str, ""LG_E"PLAYER: /handshake /animhelp /calculate /accent /gps /inventory(/inv) /fonline /setsuara /givektp /ktpshow\n");
				strcat(str, ""LG_E"CHAT: /dcp(destroycp) /b /l /t /s /pm /togpm /vip /togvip /w /o /me /ame /do /ado /try /ab /simshow /gsim");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Other Commands", str, "Close", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, "Commands\tInformation\n");
				strcat(str, ""LG_E"VEHICLE: /v engine - Toggle Engine || /v li - Toggle lights\n");
				strcat(str, ""LB_E"VEHICLE: /v hood - Toggle Hood || /v boot - Toggle boot\n");
				strcat(str, ""LG_E"VEHICLE: /v lock - Toggle Lock || /v unlock - Toggle Unlock\n");
				strcat(str, ""LB_E"VEHICLE: /v tow - Tow Vehicle || /v untow - Untow Vehicle\n");
				strcat(str, ""LG_E"VEHICLE: /v park - Save Park || /v my(/mypv) - List Private Vehicle\n");
				strcat(str, ""LG_E"VEHICLE: /v insu - Vehicle Insurance || /claimpv - Claim Insurance\n");
				strcat(str, ""LG_E"VEHICLE: /buyplate - Buy Plate || /buyinsu - Buy Insurance\n");
				strcat(str, ""LG_E"VEHICLE: /v storage - Vehicle Storage || /speedlimit - Change Speed Vehicle\n");
				strcat(str, ""LG_E"VEHICLE: /eject - Eject player from vehicle || /repairveh - repair vehicle with repairkit\n");
				strcat(str,"/claimpv\tUntuk mengambil kendaraan di dalam insuransi\n");
				strcat(str,"/buyinsu\tUntuk membeli tiket insuransi kendaraan\n");
				strcat(str,"/speedlimit\tUntuk merubah batas kecepatan kendaraan\n");
				strcat(str, "/eject\tUntuk menendang keluar penumpang dari dalam kendaraan");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Commands", str, "Close", "");
			}
			case 3:
			{
				new line3[1024];
				strcat(line3, "{ffffff}Taxi\nMechanic\nLumberjack\nTrucker\nMiner\nProduct\nFarmer\nHauling\nPizza Man\nButcher\nReflenish\nWeapon Dealer\nDrug Dealer\nTrash Master(Side Job)");
				ShowPlayerDialog(playerid, DIALOG_JOB, DIALOG_STYLE_LIST, "Job Help", line3, "Pilih", "Batal");
				return 1;
			}
			case 4:
			{
				return callcmd::factionhelp(playerid);
			}
			case 5:
			{
				new str[3500];
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpgun rpcrash rpfall rprob rpfish rpmad rpcj rpdrink\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpwar rpdie rpfixmeka rpcheckmeka rpfight rpcry rpeat\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpfear rpdropgun rpgivegun rptakegun rprun rpnodong\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpshy rpnusuk rplock rpharvest rplockhouse rplockcar\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Konoha AUTO RP", str, "Close", "");
			}
			case 6:
			{
				return callcmd::wshelp(playerid); //WROSKHOP SYSTEM
			}
			case 7:
			{
				new str[3500];
				strcat(str, "Commands\tInformation\n");
				strcat(str, "/buydrink\tUntuk membeli minuman pada mesin vending machine\n");
				strcat(str, "/vmedit\tUntuk membuka menu pada vending machine\n");
				strcat(str, "/myvending\tUntuk lihat list vending machine milik pribadi");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Vending Commands", str, "Close", "");
			}
			case 8:
			{
				new str[3500];
				strcat(str, "Commands\tInformation\n");
				strcat(str, "/buy\tUntuk membeli product pada bisnis point\n");
				strcat(str, "/bm\tUntuk mensetting bisnis milik pribadi\n");
				strcat(str, "/lockbisnis\tUntuk membuka mengunci bisnis\n");
				strcat(str, "/unlockbisnis\tUntuk membuka kunci bisnis\n");
				strcat(str, "/mybis\tUntuk melihat list bisnis milik pribadi\n");
				strcat(str, "/givebisnis\tUntuk memberikan bisnis kepada seseorang");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Bisnis Commands", str, "Close", "");
			}
			case 9:
			{
				new str[3500];
				strcat(str, "Commands\tInformation\n");
				strcat(str, "/buyveh\tUntuk membeli product kendaraan pada dealer point\n");
				strcat(str, "/dem\tUntuk membuka menu setting dealer milik pribadi\n");
				strcat(str, "/mydealer\tUntuk melihat list dealer milik pribadi\n");
				strcat(str, "/givedealer\tUntuk memberikan dealer kepada seseorang\n");
				strcat(str, "/selldealer\tUntuk menjual dealer di balaikota");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Dealer Commands", str, "Close", "");
			}
			case 10:
			{
				new str[3500];
				strcat(str, "Commands\tInformation\n");
				strcat(str, "/buy\tUntuk membeli rumah yang dijual\n");
				strcat(str, "/storage /hm\tUntuk menyimpan/mengambil item dari storage rumah\n");
				strcat(str, "/lockhouse\tUntuk mengunci pintu rumah\n");
				strcat(str, "/unlockhouse\tUntuk membuka kunci pintu rumah\n");
				strcat(str, "/myhouse\tUntuk melihat list rumah milik pribadi\n");
				strcat(str, "/givehouse\tUntuk memberikan rumah kepada seseoarang\n");
				strcat(str, "/givehousekey\tUntuk memberikan kunci rumah kedua\n");
				strcat(str, "/takehousekey\tUntuk mengambil kunci rumah kedua");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "House Commands", str, "Close", "");
			}
			case 11:
			{
				new str[3500];
				strcat(str, "Commands\tInformation\n");
				strcat(str, "/buy\tUntuk membeli private farmer\n");
				strcat(str, "/mypfarm\tUntuk melihat list private farmer milik pribadi\n");
				strcat(str, "/pfmenu\tUntuk membuka menu private farmer\n");
				strcat(str, "/pfarm\tUntuk menanam tanaman pada private farmer point\n");
				strcat(str, "/givepfarm\tUntuk memberikan private farmer kepada seseorang");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "PFarm Commands", str, "Close", "");
			}
			case 12:
			{
				new str[3500];
				strcat(str, "Commands\tInformation\n");
				strcat(str, "/robinvite\tUntuk menginvite seseorang memulai perampokan\n");
				strcat(str, "/robbank\tUntuk memulai perampokan bank dengan kelompokmu\n");
				strcat(str, "/placebomb\tUntuk menempelkan & meledakan Patched Bomb pada brankas bank\n");
				strcat(str, "/robvault\tUntuk mengambil uang dari dalam brankas bank\n");
				strcat(str, "/robatm\tUntuk merampok mesin atm");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Robbing Commands", str, "Close", "");
			}
			case 13:
			{
				return callcmd::donate(playerid);
			}
			case 14:
			{
				return callcmd::credits(playerid);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_JOB)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /taxiduty /fare\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Taxi Job", str, "Close", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /mechduty /service /createrkit\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Mechanic Job", str, "Close", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini khusus untuk Job Center\n\n{7fffd4}CMDS: /(lum)ber\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Lumber Job", str, "Close", "");
			}
			case 3:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /loadbox /unloadbox\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Trucker Job", str, "Close", "");
			}
			case 4:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /mine\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Miner Job", str, "Close", "");
			}
			case 5:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /createproduct /sellproduct\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Production Job", str, "Close", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /plant /price /offer\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Farmer Job", str, "Close", "");
			}
			case 7:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /starthauling /stophauling\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Hauling Job", str, "Close", "");
			}
			case 8:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /getpizza /droppizza\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Pizza Job", str, "Close", "");
			}
			case 9:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /takemeat /cuttingmeat /sellmeat\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Butcher Job", str, "Close", "");
			}
			case 10:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Job Center\n\n{7fffd4}CMDS: /loadmoney /unloadmoney /fillatm /repairatm /findatm\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Reflenish Job", str, "Close", "");
			}
			case 11:
			{
				new str[3500];
				strcat(str, "{ffffff}Lokasi pekerjaan ini tersembunyi kamu harus mencari nya sendiri\n\n{7fffd4}CMDS: /smugglemats /sellgun\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Weapon Dealer Job", str, "Close", "");
			}
			case 13:
			{
				new str[3500];
				strcat(str, "{ffffff}Lokasi pekerjaan ini tersembunyi kamu harus mencari nya sendiri\n\n{7fffd4}CMDS: /buydrugs /smuggledrugs /cookmeth\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Drug Dealer Job", str, "Close", "");
			}
			case 14:
			{
				new str[3500];
				strcat(str, "{ffffff}Lokasi side job ini bisa anda cek di GPS Trash Master\n\n{7fffd4}CMDS: /unloadtrash /loadtrash /throwgarbage\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Trash Master (Side Job)", str, "Close", "");
			}
		}
	}				
	if(dialogid == DIALOG_GPS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pCP] > 1 || pData[playerid][pSideJob] > 1)
						return Error(playerid, "Harap selesaikan Pekerjaan mu terlebih dahulu");

					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);
				}
				case 1:
				{
					new lstr[1500];
				    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\n{BABABA}Kantor Pemerintah\tVerdant Bluffs\t"YELLOW_E"%0.2fm\n{BABABA}Kantor Kepolisian\tPershing Square\t"YELLOW_E"%0.2fm\n{BABABA}Rumah Sakit\tMarket\t"YELLOW_E"%0.2fm\n{BABABA}Kantor Berita\tRodeo\t"YELLOW_E"%0.2fm\n{BABABA}Bank Central\tDowntown LS\t"YELLOW_E"%0.2fm\n{BABABA}Pedagang\tTemple\t"YELLOW_E"%0.2fm\n{BABABA}Kantor Ansuransi\tFlint Country\t"YELLOW_E"%0.2fm\n{BABABA}Mekanik Kota\tEl Corona\t"YELLOW_E"%0.2fm\n{BABABA}IKEA(penjualan)\tWillowfield\t"YELLOW_E"%0.2fm\n{BABABA}Component Store\tHunter Quarry\t"YELLOW_E"%0.2fm\n{BABABA}Material Store\tFlint Country\t"YELLOW_E"%0.2fm\n{BABABA}Fishing Area\tSMB\t"YELLOW_E"%0.2fm\n{BABABA}Rental Boat\tSMB\t"YELLOW_E"%0.2fm\n{BABABA}Casino\tMarket\t"YELLOW_E"%0.2fm\n{BABABA}Bahamas\tEast LS\t"YELLOW_E"%0.2fm\n{BABABA}Apartement\tRodeo\t"YELLOW_E"%0.2fm\n{BABABA}Dealership Konoha\tMarket\t"YELLOW_E"%0.2fm\n{BABABA}Tempat Healing\tSMB\t"YELLOW_E"%0.2fm",
					GetPlayerDistanceFromPoint(playerid, 1130.9117,-2036.8796,69.0078),//Balkot
					GetPlayerDistanceFromPoint(playerid, 1542.34, -1675.75, 13.55),//Polisi
					GetPlayerDistanceFromPoint(playerid, 1184.55, -1323.80, 13.57),//Rumah Sakit
					GetPlayerDistanceFromPoint(playerid, 645.63, -1356.65, 13.56),//Kantor Berita
					GetPlayerDistanceFromPoint(playerid, 1464.98, -1011.79, 26.84),//Bank Central
					GetPlayerDistanceFromPoint(playerid, 1200.2607, -922.9066, 43.0167),//Pedagang
					GetPlayerDistanceFromPoint(playerid, -77.4220,-1136.6021,1.0781),//kantor asuransi
					GetPlayerDistanceFromPoint(playerid, 1799.2003, -2066.1726, 13.5689),//Mekanik Kota
					GetPlayerDistanceFromPoint(playerid, 2357.3823, -1990.5114, 13.5469),//IKEA
					GetPlayerDistanceFromPoint(playerid, 601.71, 867.77, -42.96),//component store
					GetPlayerDistanceFromPoint(playerid, -258.23, -2189.83, 28.97),//material store
					GetPlayerDistanceFromPoint(playerid, 370.15, -2038.16, 7.67),//Fishing area
					GetPlayerDistanceFromPoint(playerid, 148.14, -1928.87, 3.77),//Rental Boat
					GetPlayerDistanceFromPoint(playerid, 1022.49, -1125.98, 23.87),//casino
					GetPlayerDistanceFromPoint(playerid, 2420.26, -1224.75, 25.12),//Bahamas
					GetPlayerDistanceFromPoint(playerid, 332.15, -1516.88, 35.86),//Apartement
					GetPlayerDistanceFromPoint(playerid, 1285.23, -1308.43, 13.54),//Dealership
					GetPlayerDistanceFromPoint(playerid, 339.6764,-1800.3688,4.3778));//Tempat Healing
					ShowPlayerDialog(playerid, DIALOG_GPS_MORE, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Public GPS", lstr, "Pilih", "Batal");
					//ShowPlayerDialog(playerid, DIALOG_GPS_MORE, DIALOG_STYLE_LIST, "GPS PUBLIC", "Police Station\nHospital\nNews Agency\nRehabilitation\nFishing Area\nRental Boat\nMechanic City\nMaterial Store\nComponent Store\nCasino\nBahamas\nVIP Lounge\nIsurance Vehicle\nPedagang(Lounge)\nShoroom Konoha\nMarket Penjualan", "Select", "Close");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_PERSONAL, DIALOG_STYLE_LIST, "Personal GPS", "My House\nMy Vending\nMy Bisnis\nMy Dealer\nMy Private Farm\nMy Vehicle", "Select", "No");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_NEAREST, DIALOG_STYLE_LIST, "Nearest GPS", "Nearest Public Garage\nNearest Bisnis\nNearest Dealer\nNearest Workshop\nNearest Gas Station\nNearest FindAtm\nNearest Bisnis (2)", "Select", "No");
				}
				case 4:
				{
					if(pData[playerid][pJob] == 0)
					{
					    ErrorMsg(playerid, "Anda seorang pengangguran");
					}
					else if(pData[playerid][pJob] == 20)
					{
					    new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPengambilan Batu\tHunter Quarry\t"YELLOW_E"%0.2fm\n{BABABA}Pencucian Batu\t{BABABA}Bone Country\t"YELLOW_E"%0.2fm\nPeleburan Batu\tOcean Docks\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 693.7296,909.6602,-38.5426),
						GetPlayerDistanceFromPoint(playerid, -796.5180,-1927.7703,6.0931),
						GetPlayerDistanceFromPoint(playerid, 2152.539062,-2263.646972,13.300081));
					    ShowPlayerDialog(playerid, DIALOG_GPS_PENAMBANG, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Penambang", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 3)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPenebangan Pohon\tBack O Beyond\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, -535.7894,-2290.9490,30.2955));
					    ShowPlayerDialog(playerid, DIALOG_GPS_LUMBER, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Lumber", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 4)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nParkiran Truck\tFlint Country\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, -53.7950,-1137.8450,1.0781));
					    ShowPlayerDialog(playerid, DIALOG_GPS_TRUCK, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Trucker", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 5)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nMiner Area\tHunter Quarry\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 633.8900,828.2900,-41.6254));
					    ShowPlayerDialog(playerid, DIALOG_GPS_MINER, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Miner", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 6)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPembuatan Product\tFlint Country\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, -267.7101,-2158.9119,28.8078));
					    ShowPlayerDialog(playerid, DIALOG_GPS_PRODUCT, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Production", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 7)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPembelian Bibit\tFlint Range\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, -377.3221,-1419.5966,25.7266));
					    ShowPlayerDialog(playerid, DIALOG_GPS_FARMER, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Farmer", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 8)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nLoad Barang\tOcean Docks\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 2771.6372,-2486.8743,13.6908));
					    ShowPlayerDialog(playerid, DIALOG_GPS_HAULS, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Hauling", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 9)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nParkiran Motor\tIdlewood\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 2104.72, -1803.92, 13.55));
					    ShowPlayerDialog(playerid, DIALOG_GPS_PIZZA, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Pizza Man", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 10)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPemotongan Daging\tWillowfield\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 1996.40, -2059.75, 13.54));
					    ShowPlayerDialog(playerid, DIALOG_GPS_BUTCHER, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Butcher", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 11)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nLoad Money\tDowntown LS\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 1433.16, -968.11, 37.39));
					    ShowPlayerDialog(playerid, DIALOG_GPS_REFLENISH, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Reflenish", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 14)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nKandang Sapi\tBone Country\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 303.56, 1140.85, 8.58));
					    ShowPlayerDialog(playerid, DIALOG_GPS_PEMERAH, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Pemerah", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 21)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nProduction Kayu\tThe Panopticon\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, -505.1494, -61.8270, 61.3429));
					    ShowPlayerDialog(playerid, DIALOG_GPS_TKAYU, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Tukang Kayu", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 23)
					{
						new lstr[1500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nKantor Penjahit\tLittle Mexico\t"YELLOW_E"%0.2fm\nPembelian Bulu\tLeavy Hollow\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 1795.8268, -1770.1813, 13.5465),
						GetPlayerDistanceFromPoint(playerid, -1106.8861,-1637.5360,76.3672));
					    ShowPlayerDialog(playerid, DIALOG_GPS_PENJAHITS, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Tukang Kayu", lstr, "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 24)
					{
						new lstr[500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPengambilan Ayam\tSan Fierro\t"YELLOW_E"%0.2fm\n{BABABA}Pengolahan Ayam\t{BABABA}Leavy Hollow\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, -1422.421142,-967.581909,200.775970),
						GetPlayerDistanceFromPoint(playerid, -1120.229736,-1660.261108,76.378242));
					    ShowPlayerDialog(playerid, DIALOG_GPS_TUKANGAYAM, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Tukang Ayam", lstr, "Pilih", "Kembali"); //Pemotong Ayam
					}
					else if(pData[playerid][pJob] == 25)
					{
						new lstr[500];
					    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPengolahan Minyak\tOctane Springs\t"YELLOW_E"%0.2fm\n{BABABA}Pengambilan Minyak\t{BABABA}Octane Springs\t"YELLOW_E"%0.2fm",
						GetPlayerDistanceFromPoint(playerid, 570.088989,1219.789794,11.711267),
						GetPlayerDistanceFromPoint(playerid, 435.119323,1264.405517,9.370626));
					    ShowPlayerDialog(playerid, DIALOG_GPS_MINYAK, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {ffffff}- Penambang Minyak", lstr, "Pilih", "Kembali"); //Penambang minyak
					}
					else if(pData[playerid][pJob] == 26)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_REYCYCLER, DIALOG_STYLE_LIST, "{15D4ED}Konoha {ffffff}- Daur Ulang", "Lokasi tempat kerja\nLokasi tempat mulai kerja\nLokasi ambil box\nlokasi penyortiran\nlokasi daur ulang", "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 27)
					{
					    SetPlayerRaceCheckpoint(playerid,1, -557.1394,-515.4979,25.1791, 0.0, 0.0, 0.0, 3.5); //Bus
						SuccesMsg(playerid, "Lokasi Kerja Bus Ditandai!");
					}
					//ShowPlayerDialog(playerid, DIALOG_GPS_JOB, DIALOG_STYLE_LIST, "GPS JOBS LOCATION", "Taxi\nPenambang\nLumber Jack\nTrucker\nMiner\nProduction\nFarmer\nHauling\nPizza Man\nButcher (Pemotong Daging)\nReflenish (Pengisi ATM)\nCow Milker(Pemeras Susu)\nFisherman(Side Job)\nSweeper(Side Job)\nBus(Side Job)\nForklift(Side Job)\nLawn Mower(Side Job)\nTrash Master(Side Job)\nTukang Kayu\nPenjahit\nTukang Ayam\nPenambang Minyak", "Select", "Close");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_SIDEJOB, DIALOG_STYLE_LIST, "GPS SIDEJOBS LOCATION", "Fisherman(Side Job)\nSweeper(Side Job)\nBus(Side Job)\nForklift(Side Job)\nLawn Mower(Side Job)\nTrash Master(Side Job)", "Select", "Close");
				}
			}
		}
	}
	if(dialogid == DIALOG_GPS_NEAREST)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetGarkotNearest(playerid) <= 0)
						return Error(playerid, "Tidak ada Public Garage yang berjarak 1km (1000 meter) darimu.");

					new id, count = GetGarkotNearest(playerid), mission[2024], lstr[3024];

					strcat(mission,"NO\tLOCATION\tDISTANCE\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnGarkotNearestID(playerid, itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d.\t%s\t%0.0fm\n", itt, GetLocation(gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]),GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]));
						}
						else format(lstr,sizeof(lstr), "%d.\t%s\t%0.0fm\n", itt, GetLocation(gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]), GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]));
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, GPS_NEAREST_GARKOT, DIALOG_STYLE_TABLIST_HEADERS,"Nearest Public Garage",mission,"Select","Cancel");
				}
				case 1:
				{
					if(GetBisnisNearest(playerid) <= 0)
						return Error(playerid, "Tidak ada bisnis yang berjarak 1km (1000 meter) darimu.");

					new id, count = GetBisnisNearest(playerid), mission[2024], lstr[3024], type[1024];

					strcat(mission,"NO\tTYPE\tDISTANCE\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBisnisNearestID(playerid, itt);
						if(bData[id][bType] == 1)
						{
							type = "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type = "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type = "Clothing Shop";
						}
						else if(bData[id][bType] == 4)
						{
							type = "Equipment";
						}
						else if(bData[id][bType] == 6)
						{
							type = "Gym";
						}
						else
						{
							type = "{FF0000}Unknown{FFFFFF}";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.0fm\n", itt, type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.0fm\n", itt, type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, GPS_NEAREST_BISNIS, DIALOG_STYLE_TABLIST_HEADERS,"Dealer Restock",mission,"Select","Cancel");
				}
				case 2:
				{
					if(GetDealerNearest(playerid) <= 0)
						return Error(playerid, "Tidak ada dealer yang berjarak 1km (1000 meter) darimu.");

					new id, count = GetDealerNearest(playerid), mission[2024], lstr[3024], type[1024];

					strcat(mission,"NO\tTYPE\tDISTANCE\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnDealerNearestID(playerid, itt);
						if(drData[id][dType] == 1)
						{
							type = "Bikes Vehicles";
						}
						else if(drData[id][dType] == 2)
						{
							type = "Cars";
						}
						else if(drData[id][dType] == 3)
						{
							type = "Unique Cars";
						}
						else if(drData[id][dType] == 4)
						{
							type = "Job Cars";
						}
						else if(drData[id][dType] == 5)
						{
							type = "Rental Jobs";
						}
						else
						{
							type = "{FF0000}Unknown{FFFFFF}";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.0fm\n", itt, type, GetPlayerDistanceFromPoint(playerid, drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.0fm\n", itt, type, GetPlayerDistanceFromPoint(playerid, drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]));
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, GPS_NEAREST_DEALER, DIALOG_STYLE_TABLIST_HEADERS,"Nearest Dealer",mission,"Select","Cancel");
				}
				case 3:
				{
					if(GetWorkshopNearest() <= 0)
						return Error(playerid, "Tidak dapat menemukan workshop dikota.");

					new id, count = GetWorkshopNearest(), mission[2024], lstr[3024], wsstatus[128];

					strcat(mission,"NO\tNAME\tSTATUS\tDISTANCE\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnWorkshopNearestID(itt);
						if(wData[id][wStatus] == 1)
						{
							wsstatus = "{FF0000}Closed{FFFFFF}";
						}
						else
						{
							wsstatus = "{00FF00}Opened{FFFFFF}";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.0fm\n", itt, wData[id][wName], wsstatus, GetPlayerDistanceFromPoint(playerid, wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.0fm\n", itt, wData[id][wName], wsstatus, GetPlayerDistanceFromPoint(playerid, wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]));
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, GPS_NEAREST_WORKSHOP, DIALOG_STYLE_TABLIST_HEADERS,"Nearest Workshop",mission,"Select","Cancel");
					return 1;
				}
				case 4:
				{
					if(GetGStationNearest(playerid) <= 0)
						return Error(playerid, "Tidak ada Gas Station yang berjarak 1km (1000 meter) darimu.");

					new id, count = GetGStationNearest(playerid), mission[2024], lstr[3024];

					strcat(mission,"NO\tLOCATION\tDISTANCE\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnGStationNearestID(playerid, itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.0fm\n", itt, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]), GetPlayerDistanceFromPoint(playerid, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.0fm\n", itt, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]), GetPlayerDistanceFromPoint(playerid, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, GPS_NEAREST_GSTATION, DIALOG_STYLE_TABLIST_HEADERS,"Nearest Gas Station",mission,"Select","Cancel");
					return 1;
				}
				case 5:
				{
					if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
					{
						if(GetATMStatus() <= 0)
							return ShowNotifError(playerid, "Tidak ada atm yang kekurangan stock/rusak.", 10000);

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
					else return ShowNotifError(playerid, "Kamu bukan pekerja reflenish", 10000);
					return 1;
				}
				case 6:
				{
					if(GetAnyBusiness() <= 0) return ErrorMsg(playerid, "Tidak ada Business di kota.");
					new id, count = GetAnyBusiness(), location[4096], lstr[596];
					strcat(location,"No\tNama Bisnis\tTipe Bisnis\tJarak\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBusinessID(itt);

						new type[128];
						if(bData2[id][bType2] == 1)
						{
							type= "Fast Food";
						}
						else if(bData2[id][bType2] == 2)
						{
							type= "MiniMarket";
						}
						else if(bData2[id][bType2] == 3)
						{
							type= "Toko Baju";
						}
						else if(bData2[id][bType2] == 4)
						{
							type= "Perlengkapan";
						}
						else if(bData2[id][bType2] == 5)
						{
							type= "Elektronik";
						}
						else
						{
							type= "N/A";
						}

						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData2[id][bName2], type, GetPlayerDistanceFromPoint(playerid, bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData2[id][bName2], type, GetPlayerDistanceFromPoint(playerid, bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKBUSINESS, DIALOG_STYLE_TABLIST_HEADERS,"List Bisnis",location,"Tandai","Batal");
				}
			}
		}
		return 1;
	}
	if(dialogid == GPS_NEAREST_GARKOT)
	{
		if(response)
		{
			new id = ReturnGarkotNearestID(playerid, (listitem+1));
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ], 0.0, 0.0, 0.0, 7.0); //GPS GARKOT
			Info(playerid, "GPS Active! Public Garage (ID: %d) yang berjarak %0.0fm berlokasi di %s telah ditandai", id, GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]), GetLocation(gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]));
		}
	}
	if(dialogid == GPS_NEAREST_BISNIS)
	{
		if(response)
		{
			new id = ReturnBisnisNearestID(playerid, (listitem+1));
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0); //GPS BISNIS
			Info(playerid, "GPS Active! Bisnis yang berjarak %0.0fm berlokasi di %s telah ditandai", GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}
	if(dialogid == GPS_NEAREST_DEALER)
	{
		if(response)
		{
			new id = ReturnDealerNearestID(playerid, (listitem+1));
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, drData[id][dPosX], drData[id][dPosY], drData[id][dPosZ], 0.0, 0.0, 0.0, 7.0); //GPS DEALER
			Info(playerid, "GPS Active! Dealer yang berjarak %0.0fm berlokasi di %s telah ditandai", GetPlayerDistanceFromPoint(playerid, drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]));
		}
	}
	if(dialogid == GPS_NEAREST_WORKSHOP)
	{
		if(response)
		{
			new id = ReturnWorkshopNearestID((listitem+1));
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ], 0.0, 0.0, 0.0, 7.0); //GPS WORKSHOP
			Info(playerid, "GPS Active! Workshop yang berjarak %0.0fm berlokasi di %s telah ditandai", GetPlayerDistanceFromPoint(playerid, wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]), GetLocation(wData[id][wExtposX], wData[id][wExtposY], wData[id][wExtposZ]));
		}
	}
	if(dialogid == GPS_NEAREST_GSTATION)
	{
		if(response)
		{
			new id = ReturnGStationNearestID(playerid, (listitem+1));
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ], 0.0, 0.0, 0.0, 7.0); //GPS GAS STATION
			Info(playerid, "GPS Active! Gas Station yang berjarak %0.0fm berlokasi di %s telah ditandai", GetPlayerDistanceFromPoint(playerid, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]), GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
		}
	}
	if(dialogid == DIALOG_GPS_PERSONAL)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::myhouse(playerid);
				}
				case 1:
				{
					return callcmd::myvending(playerid);
				}
				case 2:
				{
					return callcmd::mybis(playerid);
				}
				case 3:
				{
					return callcmd::mydealer(playerid);
				}
				case 4:
				{
					return callcmd::mypfarm(playerid);
				}
				case 5:
				{
					return callcmd::v(playerid, "my");
				}
			}
		}
	}
	if(dialogid == DIALOG_GPS_JOB)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 694.10, -452.50, 16.33, 0.0,0.0,0.0, 3.5); //Taxi
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 1:
				{
					new lstr[1500];
				    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPengambilan Batu\tBone Country\t"YELLOW_E"%0.2fm\n{BABABA}Pencucian Batu\t{BABABA}Bone Country\t"YELLOW_E"%0.2fm\nPeleburan Batu\tOcean Docks\t"YELLOW_E"%0.2fm",
					GetPlayerDistanceFromPoint(playerid, 693.7296,909.6602,-38.5426),
					GetPlayerDistanceFromPoint(playerid, -795.9457,-1928.1815,5.7338),
					GetPlayerDistanceFromPoint(playerid, 2152.539062,-2263.646972,13.300081));
				    ShowPlayerDialog(playerid, DIALOG_GPS_PENAMBANG, DIALOG_STYLE_TABLIST_HEADERS, "Konoha {ffffff}- Penambang", lstr, "Pilih", "Kembali");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, -266.06, -2213.47, 29.04, 0.0, 0.0, 0.0, 3.5); //Lumber
					Info(playerid, "GPS active! Ikuti Checkpoint.");
					
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, -77.11, -1136.48, 1.07, 0.0, 0.0, 0.0, 3.5); //Trucker
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, 592.28, 864.61, -43.50, 0.0, 0.0, 0.0, 3.5); //Miner
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, -283.20, -2174.58, 28.66, 0.0, 0.0, 0.0, 3.5); //Production
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 6:
				{
					SetPlayerRaceCheckpoint(playerid,1, -382.86, -1438.84, 26.33, 0.0, 0.0, 0.0, 3.5); //Farmer
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 7:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2750.03, -2450.83, 13.64, 0.0, 0.0, 0.0, 3.5); //Hauling
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 8:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2104.72, -1803.92, 13.55, 0.0, 0.0, 0.0, 3.5); //pizza man
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 9:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1996.40, -2059.75, 13.54, 0.0, 0.0, 0.0, 3.5); //butcher
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 10:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1433.16, -968.11, 37.39, 0.0, 0.0, 0.0, 3.5); //reflenish
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 11:
				{
					SetPlayerRaceCheckpoint(playerid,1, 303.56, 1140.85, 8.58, 0.0, 0.0, 0.0, 3.5); //reflenish
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 12:
				{
					SetPlayerRaceCheckpoint(playerid,1, 370.15, -2038.16, 7.67, 0.0, 0.0, 0.0, 3.5); //Fisherman
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 13:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2197.24, -1977.86, 13.55, 0.0, 0.0, 0.0, 3.5); //Swpper
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 14:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1698.79, -1545.35, 13.38, 0.0, 0.0, 0.0, 3.5); //Bus
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 15:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2749.74, -2385.79, 13.64, 0.0, 0.0, 0.0, 3.5); //Forklift
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 16:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2046.20, -1253.30, 23.98, 0.0, 0.0, 0.0, 3.5); //Lawn Mower
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 17:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2423.56, -2089.59, 13.53, 0.0, 0.0, 0.0, 3.5); //Trash Master
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 18:
				{
					SetPlayerRaceCheckpoint(playerid,1, -505.1494, -61.8270, 61.3429, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");// Tukang Kayu
				}
				case 19:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_PENJAHIT, DIALOG_STYLE_LIST, "{FF0000}Konoha{ffffff} - GPS Penjahit", "Lokasi - Kantor Penjahit\nLokasi - Pembelian Bulu", "Select", "Back"); // Penjahit
					//ShowPlayerDialog(playerid, DIALOG_GPS_PETANI, DIALOG_STYLE_LIST, "{FF0000}Konoha{ffffff} - GPS Petani", "Lokasi - Pertanian\nLokasi - Penjualan Hasil Tani", "Select", "Back"); // Petani
				}
				case 20:
				{
					new lstr[500];
				    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPengambilan Ayam\tSan Fierro\t"YELLOW_E"%0.2fm\n{BABABA}Pengolahan Ayam\t{BABABA}Leavy Hollow\t"YELLOW_E"%0.2fm",
					GetPlayerDistanceFromPoint(playerid, -1422.421142,-967.581909,200.775970),
					GetPlayerDistanceFromPoint(playerid, -1120.229736,-1660.261108,76.378242));
				    ShowPlayerDialog(playerid, DIALOG_GPS_TUKANGAYAM, DIALOG_STYLE_TABLIST_HEADERS, "Konoha {ffffff}- Tukang Ayam", lstr, "Pilih", "Kembali"); //Pemotong Ayam
				}
				case 21:
				{
					new lstr[500];
				    format(lstr,sizeof(lstr), "Nama\tLokasi\tJarak\nPengolahan Minyak\tOctane Springs\t"YELLOW_E"%0.2fm\n{BABABA}Pengambilan Minyak\t{BABABA}Octane Springs\t"YELLOW_E"%0.2fm",
					GetPlayerDistanceFromPoint(playerid, 570.088989,1219.789794,11.711267),
					GetPlayerDistanceFromPoint(playerid, 435.119323,1264.405517,9.370626));
				    ShowPlayerDialog(playerid, DIALOG_GPS_MINYAK, DIALOG_STYLE_TABLIST_HEADERS, "Konoha {ffffff}- Penambang Minyak", lstr, "Pilih", "Kembali"); //Penambang minyak
				}
			}
		}
	}
	if(dialogid == DIALOG_GPS_TRUCK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -53.7950,-1137.8450,1.0781, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_MINER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 633.8900,828.2900,-41.6254, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PRODUCT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -267.7101,-2158.9119,28.8078, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_FARMER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -377.3221,-1419.5966,25.7266, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_HAULS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2771.6372,-2486.8743,13.6908, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PIZZA)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2104.72, -1803.92, 13.55, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_BUTCHER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1996.40, -2059.75, 13.54, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_REFLENISH)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1433.16, -968.11, 37.39, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PEMERAH)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 303.56, 1140.85, 8.58, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_TKAYU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -505.1494, -61.8270, 61.3429, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PENJAHITS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1795.8268, -1770.1813, 13.5465, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1106.8861,-1637.5360,76.3672, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_SIDEJOB)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 370.15, -2038.16, 7.67, 0.0, 0.0, 0.0, 3.5); //Fisherman
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2197.24, -1977.86, 13.55, 0.0, 0.0, 0.0, 3.5); //Swpper
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1698.79, -1545.35, 13.38, 0.0, 0.0, 0.0, 3.5); //Bus
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2749.74, -2385.79, 13.64, 0.0, 0.0, 0.0, 3.5); //Forklift
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2046.20, -1253.30, 23.98, 0.0, 0.0, 0.0, 3.5); //Lawn Mower
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2423.56, -2089.59, 13.53, 0.0, 0.0, 0.0, 3.5); //Trash Master
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_MINYAK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 570.088989,1219.789794,11.711267, 0.0, 0.0, 0.0, 3.5); //Pengolahan
					SuccesMsg(playerid, "Tempat penyaringan minyak ditandai");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 435.119323,1264.405517,9.370626, 0.0, 0.0, 0.0, 3.5); //Pengambilan
					SuccesMsg(playerid, "Tempat pengambilan minyak ditandai");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_REYCYCLER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 279.4645,-218.7562,1.5781, 0.0, 0.0, 0.0, 3.5); //Penambangan
					SuccesMsg(playerid, "Lokasi tempat kerja");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -920.0016,-468.0568,826.8417, 0.0, 0.0, 0.0, 3.5); //Penambangan
					SuccesMsg(playerid, "lokasi mulai kerja");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, -898.6295,-500.8337,826.8417, 0.0, 0.0, 0.0, 3.5); //Pencucian
					SuccesMsg(playerid, "Lokasi tempat ambil box");
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, -927.1517,-486.4165,826.8417, 0.0, 0.0, 0.0, 3.5); //Pencucian
					SuccesMsg(playerid, "Lokasi tempat penyortiran box");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, -9.0089,1374.7740,9.3476, 0.0, 0.0, 0.0, 3.5); //Pencucian
					SuccesMsg(playerid, "Tempat Daur Ulang ditandai");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_MULAIBOX)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    pData[playerid][pDutyBox] = 1;
				    SuccesMsg(playerid, "Anda memulai Pekerjaan!");
				}
				case 1:
				{
				     pData[playerid][pDutyBox] = 0;
				     SuccesMsg(playerid, "Anda berhasil Mengakhiri Pekerjaan!");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GPS_TUKANGAYAM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
			    {
			        SetPlayerRaceCheckpoint(playerid,1, -1422.421142,-967.581909,200.775970, 0.0, 0.0, 0.0, 3.5); //Tempat Pemotongan
					SuccesMsg(playerid, "Tempat pengambilan ayam ditandai!");
			    }
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1105.8398,-1650.9512,76.3883, 0.0, 0.0, 0.0, 3.5); //Tempat Pemotongan
					SuccesMsg(playerid, "Tempat pemotongan ayam ditandai!");
				}
			}
		}
        else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PETANI)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -32.5913, 151.2911, 2.7683, 0.0, 0.0, 0.0, 3.5); // Lokasi pertanian
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 1:
				{
					//SetPlayerRaceCheckpoint(playerid,1, 2183.178466,-2668.562744,17.882808, 0.0, 0.0, 0.0, 3.5); // Penjualan hasil tani
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PENJAHIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1795.8268, -1770.1813, 13.5465, 0.0, 0.0, 0.0, 3.5); // Lokasi Kantor Penjahit
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1106.8861,-1637.5360,76.3672, 0.0, 0.0, 0.0, 3.5); // Lokasi Kantor Penjahit
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_TUKANGKAYU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1960.1082, -2476.5842, 30.6250, 0.0, 0.0, 0.0, 3.5); // Lokasi Tukang Kayu
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -2044.6476, -2384.1541, 30.6318, 0.0, 0.0, 0.0, 3.5); // Pengolahan & Pengemasan hasil kayu
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_MORE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1130.9117,-2036.8796,69.0078, 0.0,0.0,0.0, 3.5); //Kantor Pemerintah
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1542.34, -1675.75, 13.55, 0.0, 0.0, 0.0, 3.5); //Kantor Kepolisian
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
  				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1184.55, -1323.80, 13.57, 0.0, 0.0, 0.0, 3.5); //Rumah Sakit
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, 645.63, -1356.65, 13.56, 0.0, 0.0, 0.0, 3.5); //Kantor Berita
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1464.98, -1011.79, 26.84, 0.0, 0.0, 0.0, 3.5); //Bank Central
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1200.2607, -922.9066, 43.0167, 0.0, 0.0, 0.0, 3.5); //Pedagang
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 6:
				{
					SetPlayerRaceCheckpoint(playerid,1, -77.4220,-1136.6021,1.0781, 0.0, 0.0, 0.0, 3.5); //Kantor Asuransi
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 7:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1799.2003, -2066.1726, 13.5689, 0.0, 0.0, 0.0, 3.5); //Mekanik Kota
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 8:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2357.3823, -1990.5114, 13.5469, 0.0, 0.0, 0.0, 3.5); //IKEA
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 9:
				{
					SetPlayerRaceCheckpoint(playerid, 1, 601.71, 867.77, -42.96,  0.0, 0.0, 0.0, 3.5); //Component Store
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 10:
				{
					SetPlayerRaceCheckpoint(playerid,1, -258.23, -2189.83, 28.97, 0.0, 0.0, 0.0, 3.5); //Material Store
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 11:
				{
					SetPlayerRaceCheckpoint(playerid,1, 370.15, -2038.16, 7.67, 0.0, 0.0, 0.0, 3.5); //Fishing Area
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 12:
				{
					SetPlayerRaceCheckpoint(playerid,1, 148.14, -1928.87, 3.77, 0.0, 0.0, 0.0, 3.5); //Rental Boat
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 13:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1022.49, -1125.98, 23.87, 0.0, 0.0, 0.0, 3.5); //Casino
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 14:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2420.26, -1224.75, 25.12, 0.0, 0.0, 0.0, 3.5); //Bahamas
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 15:
				{
					SetPlayerRaceCheckpoint(playerid,1, 332.15, -1516.88, 35.86, 0.0, 0.0, 0.0, 3.5); //Apartement
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 16:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1285.23, -1308.43, 13.54, 0.0, 0.0, 0.0, 3.5); //Dealership Konoha
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
				case 17:
				{
					SetPlayerRaceCheckpoint(playerid,1, 339.6764,-1800.3688,4.3778, 0.0, 0.0, 0.0, 3.5); //Tempat Healing
					Info(playerid, "GPS active! Ikuti Checkpoint.");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_HOLIMARKET)
	{
		if(response)
		{
			switch(listitem)
			{
				//================[ CASE 0 ]=============
				case 0:
				{
				    callcmd::jualemasdentotz(playerid, "");
				}
				//================[ CASE 1 ]=============
				case 1:
				{
				    callcmd::jualbesidentotz(playerid, "");
				}
				//================[ CASE 2 ]=============
				case 2:
				{
				    callcmd::jualtembagadentotz(playerid, "");
				}
				//================[ CASE 3 ]=============
				case 3:
				{
				    callcmd::jualberliandentotz(playerid, "");
				}
				//================[ CASE 4 ]=============
				case 4:
				{
				    callcmd::jualikantuna(playerid, "");
				}
				//================[ CASE 5 ]=============
				case 5:
				{
				    callcmd::jualikantongkol(playerid, "");
				}
				//================[ CASE 6 ]=============
				case 6:
				{
				    callcmd::jualikankakap(playerid, "");
				}
				//================[ CASE 7 ]=============
				case 7:
				{
				    callcmd::jualikankembung(playerid, "");
				}
				//================[ CASE 8 ]=============
				case 8:
				{
				    callcmd::jualikanmakarel(playerid, "");
				}
				//================[ CASE 9 ]=============
				case 9:
				{
				    callcmd::jualikantenggiri(playerid, "");
				}
				//================[ CASE 10 ]=============
				case 10:
				{
				    callcmd::jualikanbmarlin(playerid, "");
				}
				//================[ CASE 11 ]=============
				case 11:
				{
				    callcmd::jualikanbsailfish(playerid, "");
				}
				//================[ CASE 12 ]=============
				case 12:
				{
				    callcmd::jualkayugen(playerid, "");
				}
				//================[ CASE 13 ]=============
				case 13:
				{
				    callcmd::jualpakaiangen(playerid, "");
				}
				//================[ CASE 14 ]=============
				case 14:
				{
				    callcmd::jualbulunya(playerid, "");
				}
				//================[ CASE 15 ]=============
				case 15:
				{
				    callcmd::jualayamgen(playerid, "");
				}
				//================[ CASE 16 ]=============
				case 16:
				{
				    callcmd::jualminyakbank(playerid, "");
				}
				//================[ CASE 17 ]=============
				case 17:
				{
				    callcmd::jualbotol(playerid, "");
				}
				//================[ CASE 18 ]=============
				case 18:
				{
				    callcmd::jualkaret1(playerid, "");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GPS_LUMBER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -535.7894,-2290.9490,30.2955, 0.0, 0.0, 0.0, 3.5);
					SuccesMsg(playerid, "Tempat Penebangan Pohon ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PENAMBANG)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 693.7296,909.6602,-38.5426, 0.0, 0.0, 0.0, 3.5); //Penambangan
					SuccesMsg(playerid, "Tempat penambangan ditandai!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -795.9457,-1928.1815,5.7338, 0.0, 0.0, 0.0, 3.5); //Pencucian
					SuccesMsg(playerid, "Tempat pencucian batu ditandai!");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2152.539062,-2263.646972,13.300081, 0.0, 0.0, 0.0, 3.5); //Peleburan
					SuccesMsg(playerid, "Tempat peleburan batu ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_PAY)
	{
		if(response)
		{
			new mstr[128];
			new otherid = GetPVarInt(playerid, "gcPlayer");
			new money = GetPVarInt(playerid, "gcAmount");

			if(otherid == INVALID_PLAYER_ID)
				return Error(playerid, "Player not connected!");
			GivePlayerMoneyEx(otherid, money);
			GivePlayerMoneyEx(playerid, -money);

			format(mstr, sizeof(mstr), "Server: "YELLOW_E"You have sent %s(%i) "GREEN_E"%s", ReturnName(otherid), otherid, FormatMoney(money));
			SendClientMessage(playerid, COLOR_GREY, mstr);
			format(mstr, sizeof(mstr), "Server: "YELLOW_E"%s(%i) has sent you "GREEN_E"%s", ReturnName(playerid), playerid, FormatMoney(money));
			SendClientMessage(otherid, COLOR_GREY, mstr);
			InfoTD_MSG(playerid, 3500, "~g~~h~Money Sent!");
			InfoTD_MSG(otherid, 3500, "~g~~h~Money received!");
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s memberikan uang kepada %s sebesar %s", ReturnName(playerid), ReturnName(otherid), FormatMoney(money));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s menerima uang dari %s sebesar %s", ReturnName(otherid), ReturnName(playerid), FormatMoney(money));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logpay (player,playerid,toplayer,toplayerid,ammount,time) VALUES('%s','%d','%s','%d','%d',UNIX_TIMESTAMP())", pData[playerid][pName], pData[playerid][pID], pData[otherid][pName], pData[otherid][pID], money);
			mysql_tquery(g_SQL, query);
		}
		return 1;
	}
	//-------------[ Player Weapons Atth ]-----------
	if(dialogid == DIALOG_EDITBONE)
	{
		if(response)
		{
			new weaponid = EditingWeapon[playerid], weaponname[18], string[150];
	 
			GetWeaponName(weaponid, weaponname, sizeof(weaponname));
		   
			WeaponSettings[playerid][weaponid - 22][Bone] = listitem + 1;

			Servers(playerid, "You have successfully changed the bone of your %s.", weaponname);
		   
			mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, Bone) VALUES ('%d', %d, %d) ON DUPLICATE KEY UPDATE Bone = VALUES(Bone)", pData[playerid][pID], weaponid, listitem + 1);
			mysql_tquery(g_SQL, string);
		}
		EditingWeapon[playerid] = 0;
	}
	//------------[ Family Dialog ]------------
	if(dialogid == FAMILY_SAFE)
	{
		if(!response) return 1;
		new fid = pData[playerid][pFamily];
		switch(listitem) 
		{
			case 0: Family_OpenStorage(playerid, fid);
			case 1:
			{
				//Marijuana
				ShowPlayerDialog(playerid, FAMILY_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 2:
			{
				//Component
				ShowPlayerDialog(playerid, FAMILY_COMPONENT, DIALOG_STYLE_LIST, "Component", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 3:
			{
				//Material
				ShowPlayerDialog(playerid, FAMILY_MATERIAL, DIALOG_STYLE_LIST, "Material", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 4:
			{
				//Money
				ShowPlayerDialog(playerid, FAMILY_MONEY, DIALOG_STYLE_LIST, "Money", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_STORAGE)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(listitem == 0) 
			{
				Family_WeaponStorage(playerid, fid);
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_WEAPONS)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(fData[fid][fGun][listitem] != 0)
			{
				if(pData[playerid][pFamilyRank] < 5)
					return Error(playerid, "Only boss can taken the weapon!");
					
				if(PlayerHasWeapon(playerid, fData[fid][fGun][listitem]))
					return Error(playerid, "Kamu sudah memiliki senjata tersebut");

				GivePlayerWeaponEx(playerid, fData[fid][fGun][listitem], fData[fid][fAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(fData[fid][fGun][listitem]));

				fData[fid][fGun][listitem] = 0;
				fData[fid][fAmmo][listitem] = 0;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				fData[fid][fGun][listitem] = weaponid;
				fData[fid][fAmmo][listitem] = ammo;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
		}
		else
		{
			Family_OpenStorage(playerid, fid);
		}
		return 1;
	}
	if(dialogid == FAMILY_MARIJUANA)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw marijuana!");
							
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMarijuana] -= amount;
			pData[playerid][pMarijuana] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d marijuana from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMarijuana] += amount;
			pData[playerid][pMarijuana] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d marijuana into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_COMPONENT)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw component!");
							
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fComponent] -= amount;
			pData[playerid][pComponent] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d component from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fComponent] += amount;
			pData[playerid][pComponent] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d component into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MATERIAL)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw material!");
							
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMaterial] -= amount;
			pData[playerid][pMaterial] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d material from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMaterial] += amount;
			pData[playerid][pMaterial] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d material into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MONEY)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw money!");
							
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from their family safe.", ReturnName(playerid), FormatMoney(amount));
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into their family safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_INFO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT name,leader,marijuana,component,material,money FROM familys WHERE ID = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyInfo", "i", playerid);
				}
				case 1:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");
						
					new lstr[1024];
					format(lstr, sizeof(lstr), "Rank\tName\n");
					foreach(new i: Player)
					{
						if(pData[i][pFamily] == pData[playerid][pFamily])
						{
							format(lstr, sizeof(lstr), "%s%s\t%s(%d)", lstr, GetFamilyRank(i), pData[i][pName], i);
							format(lstr, sizeof(lstr), "%s\n", lstr);
						}
					}
					format(lstr, sizeof(lstr), "%s\n", lstr);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Family Online", lstr, "Close", "");
					
				}
				case 2:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,familyrank FROM players WHERE family = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	//------------[ VIP Locker Dialog ]----------
	if(dialogid == DIALOG_LOCKERVIP)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					SetPlayerHealthEx(playerid, 100);
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 1, 1);
					GivePlayerWeaponEx(playerid, 7, 1);
					GivePlayerWeaponEx(playerid, 15, 1);
				}
				case 2:
				{
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, VIPMaleSkins, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, VIPFemaleSkins, "Choose your skin");
					}
				}
				case 3:
				{
					new string[248];
					if(pToys[playerid][0][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 1\n");
					}
					else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

					if(pToys[playerid][1][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 2\n");
					}
					else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

					if(pToys[playerid][2][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 3\n");
					}
					else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

					if(pToys[playerid][3][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 4\n");
					}
					else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

					/*if(pToys[playerid][4][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 5\n");
					}
					else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

					if(pToys[playerid][5][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 6\n");
					}
					else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");*/

					ShowPlayerDialog(playerid, DIALOG_TOYVIP, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"VIP Toys", string, "Select", "Cancel");
				}
			}
		}
	}
	//-------------[ Faction Commands Dialog ]-----------
	if(dialogid == DIALOG_LOCKERSAPD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
						ResetWeapon(playerid, 25);
						ResetWeapon(playerid, 27);
						ResetWeapon(playerid, 29);
						ResetWeapon(playerid, 31);
						ResetWeapon(playerid, 33);
						ResetWeapon(playerid, 34);
						KillTimer(DutyTimer);
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 300);
							pData[playerid][pFacSkin] = 300;
						}
						else
						{
							SetPlayerSkin(playerid, 306);
							pData[playerid][pFacSkin] = 306;
						}
						DutyTimer = SetTimerEx("DutyHour", 1000, true, "i", playerid);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					//SetPlayerHealthEx(playerid, 100);
					pData[playerid][pMedkit]++;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					pData[playerid][pVest]++;
					//SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil vest pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAPD, DIALOG_STYLE_LIST, "SAPD Weapons/Items", "TEST DRUG\nSPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE\nSHOTGUN\nSHOTGSPA\nMP5\nM4", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAPDMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAPDFemale, "Choose your skin");
					}
				}
				case 5:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
					
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAPDWar, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAPDFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAPD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					pData[playerid][pTdrug] += 1;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s  open the locker and take the drug test kit.", ReturnName(playerid));
				}
				case 1:
				{
					if(PlayerHasWeapon(playerid, 46))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 2:
				{
					if(PlayerHasWeapon(playerid, 46))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 3:
				{
					if(PlayerHasWeapon(playerid, 3))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 3, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 4:
				{
					if(PlayerHasWeapon(playerid, 4))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 5:
				{
					if(PlayerHasWeapon(playerid, 22))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 22, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 2)
						return Error(playerid, "You are not allowed!");
					
					if(PlayerHasWeapon(playerid, 23))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 23, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 7:
				{
					if(pData[playerid][pFactionRank] < 2)
						return Error(playerid, "You are not allowed!");
					
					if(PlayerHasWeapon(playerid, 24))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
				case 8:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					if(PlayerHasWeapon(playerid, 25))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 25, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(25));
				}
				case 9:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					if(PlayerHasWeapon(playerid, 27))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 27, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(27));
				}
				case 10:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					if(PlayerHasWeapon(playerid, 29))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
				case 11:
				{
					if(pData[playerid][pFactionRank] < 4)
						return Error(playerid, "You are not allowed!");

					if(PlayerHasWeapon(playerid, 31))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 31, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(31));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAGS)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 295);
							pData[playerid][pFacSkin] = 295;
						}
						else
						{
							SetPlayerSkin(playerid, 141);
							pData[playerid][pFacSkin] = 141;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					SetPlayerHealthEx(playerid, 100);

					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAGS, DIALOG_STYLE_LIST, "SAGS Weapons", "SPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE\nMP5", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAGSMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAGSFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAGS)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					if(PlayerHasWeapon(playerid, 41))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 1:
				{
					if(PlayerHasWeapon(playerid, 46))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 2:
				{
					if(PlayerHasWeapon(playerid, 3))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 3, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 3:
				{
					if(PlayerHasWeapon(playerid, 4))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 4:
				{
					if(PlayerHasWeapon(playerid, 22))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 22, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 2)
						return Error(playerid, "You are not allowed!");
					
					if(PlayerHasWeapon(playerid, 23))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 23, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
						
					if(PlayerHasWeapon(playerid, 24))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
				case 7:
				{
					if(pData[playerid][pFactionRank] < 4)
						return Error(playerid, "You are not allowed!");

					if(PlayerHasWeapon(playerid, 29))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAMD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 276);
							pData[playerid][pFacSkin] = 276;
						}
						else
						{
							SetPlayerSkin(playerid, 308);
							pData[playerid][pFacSkin] = 308;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					//SetPlayerHealthEx(playerid, 100);
					pData[playerid][pMedkit]++;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					pData[playerid][pVest]++;
					//SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil vest pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAMD, DIALOG_STYLE_LIST, "SAMD Weapons/Items", "TEST DRUG\nFIREEXTINGUISHER\nPARACHUTE\nNITE STICK\nKNIFE", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAMDMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAMDFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAMD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					pData[playerid][pTdrug] += 1;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s  open the locker and take the drug test kit.", ReturnName(playerid));
				}
				case 1:
				{
					if(PlayerHasWeapon(playerid, 42))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 42, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(42));
				}
				case 2:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "Only rank 3-6 for take this");
					
					if(PlayerHasWeapon(playerid, 46))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 3:
				{
					if(PlayerHasWeapon(playerid, 3))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 3, 34);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(34));
				}
				case 4:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "Only rank 3-6 for take this");

					if(PlayerHasWeapon(playerid, 4))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 4, 34);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSANEW)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 189);
							pData[playerid][pFacSkin] = 189;
						}
						else
						{
							SetPlayerSkin(playerid, 150); //194
							pData[playerid][pFacSkin] = 150; //194
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSANEW, DIALOG_STYLE_LIST, "SANEW Weapons", "CAMERA\nPARACHUTE\nNITE STICK\nKNIFE", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SANEWMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SANEWFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSANEW)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					if(PlayerHasWeapon(playerid, 43))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 43, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(43));
				}
				case 1:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "Only rank 3-6 for take this");

					if(PlayerHasWeapon(playerid, 46))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 2:
				{
					if(PlayerHasWeapon(playerid, 3))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 3, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 3:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "Only rank 3-6 for take this");

					if(PlayerHasWeapon(playerid, 4))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");
					
					GivePlayerWeaponEx(playerid, 4, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSACF)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					//static
						//pid;
						
					if(pData[playerid][pOnDuty] == 1)
					{

						pData[playerid][pOnDuty] = 0;
						//RefreshMapSacf(playerid);
						//Pedagang_Refresh(playerid, pid);
						//pData[playerid][pOndutysacf] = false;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{

						pData[playerid][pOnDuty] = 1;
						//RefreshMapSacf(playerid);
						//Pedagang_Refresh(playerid, pid);
						//pData[playerid][pOndutysacf] = true;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 189);
							pData[playerid][pFacSkin] = 189;
						}
						else
						{
							SetPlayerSkin(playerid, 150); //194
							pData[playerid][pFacSkin] = 150; //194
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					//SetPlayerHealthEx(playerid, 100);
					pData[playerid][pMedkit]++;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					pData[playerid][pVest]++;
					//SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil vest pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSANEW, DIALOG_STYLE_LIST, "Pedagang Weapons", "PARACHUTE\nNITE STICK\nKNIFE", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SACFMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SACFFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSACF)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "Only rank 3-6 for take this");

					if(PlayerHasWeapon(playerid, 46))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 1:
				{
					if(PlayerHasWeapon(playerid, 3))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");

					GivePlayerWeaponEx(playerid, 3, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 2:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "Only rank 3-6 for take this");

					if(PlayerHasWeapon(playerid, 4))
						return Error(playerid, "Kamu sudah memiliki senjata tersebut");
					
					GivePlayerWeaponEx(playerid, 4, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
			}
		}
		return 1;
	}
	//--------[ DIALOG SERVICE WORKSHOP]
	if(dialogid == WORKSHOP_SERVICE)
	{
		new wid = pData[playerid][pWorkshop];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new Float:health, comp;
						GetVehicleHealth(pData[playerid][pMechVeh], health);
						if(health > 1000.0) health = 1000.0;
						if(health > 0.0) health *= -1;
						comp = floatround(health, floatround_round) / 10 + 100;
						
						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("EngineFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						//Showbar(playerid, 20, "MEMPERBAIKI MESIN", "EngineFix");
						ShowProgressbar(playerid, "MEMPERBAIKI MESIN", 20);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new panels, doors, light, tires, comp;
						
						GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
						new cpanels = panels / 1000000;
						new lights = light / 2;
						new pintu;
						if(doors != 0) pintu = 5;
						if(doors == 0) pintu = 0;
						comp = cpanels + lights + pintu + 20;
						
						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki body kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("BodyFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						//Showbar(playerid, 20, "MEMPERBAIKI BODY", "BodyFix");
						ShowProgressbar(playerid, "MEMPERBAIKI BODY", 20);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 12) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 3:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 4:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 5:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SPOILER,DIALOG_STYLE_LIST,"Choose below","Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 6:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 7:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 8:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 9:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 10:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_FRONT_BUMPERS, DIALOG_STYLE_LIST, "Front bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 11:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_REAR_BUMPERS, DIALOG_STYLE_LIST, "Rear bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 12:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 13:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SIDE_SKIRTS, DIALOG_STYLE_LIST, "Side skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
					Info(playerid, "Side blm ada.");
				}
				case 14:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 15) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_BULLBARS, DIALOG_STYLE_LIST, "Bull bars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 15:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						pData[playerid][pMechColor1] = 1086;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 45) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 45;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"45 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							//Showbar(playerid, 20, "MODIF KENDARAAN", "ModifCar");
							ShowProgressbar(playerid, "MODIF KENDARAAN", 20);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 16:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						pData[playerid][pMechColor1] = 1087;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 45) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 45;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"45 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							//Showbar(playerid, 20, "MODIF KENDARAAN", "ModifCar");
							ShowProgressbar(playerid, "MODIF KENDARAAN", 20);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 17:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
						pData[playerid][pMechColor1] = 1009;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 75) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 75;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"75 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "MODIF KENDARAAN", 20);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 18:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
					
						pData[playerid][pMechColor1] = 1008;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 112) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 112;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"112 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "MODIF KENDARAAN", 20);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 19:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
						pData[playerid][pMechColor1] = 1010;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "MODIF KENDARAAN", 20);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
				case 20:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wData[wid][wExtposX], wData[wid][wExtposY], wData[wid][wExtposZ]))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_NEON,DIALOG_STYLE_LIST,"Neon","RED\nBLUE\nGREEN\nYELLOW\nPINK\nWHITE\nREMOVE","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "kamu harus berjarak 10 meter dari point workshopmu");
				}
			}
		}
	}
	//--------[ DIALOG JOB ]--------
	if(dialogid == DIALOG_SERVICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new Float:health, comp;
						GetVehicleHealth(pData[playerid][pMechVeh], health);
						if(health > 2500.0) health = 2500.0;
						if(health > 0.0) health *= -1;
						comp = floatround(health, floatround_round) / 10 + 100;
						
						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("EngineFix", 2500, true, "id", playerid, pData[playerid][pMechVeh]);
						//Showbar(playerid, 20, "MEMPERBAIKI MESIN", "EngineFix");
						ShowProgressbar(playerid, "MEMPERBAIKI MESIN", 20);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new panels, doors, light, tires, comp;
						
						GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
						new cpanels = panels / 1000000;
						new lights = light / 2;
						new pintu;
						if(doors != 0) pintu = 5;
						if(doors == 0) pintu = 0;
						comp = cpanels + lights + pintu + 20;
						
						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki body kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("BodyFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						//Showbar(playerid, 20, "MEMPERBAIKI BODY", "BodyFix");
						ShowProgressbar(playerid, "MEMPERBAIKI BODY", 20);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 12) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 3:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 4:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 5:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SPOILER,DIALOG_STYLE_LIST,"Choose below","Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 6:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 7:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 8:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 9:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 10:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_FRONT_BUMPERS, DIALOG_STYLE_LIST, "Front bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 11:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_REAR_BUMPERS, DIALOG_STYLE_LIST, "Rear bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 12:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 13:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SIDE_SKIRTS, DIALOG_STYLE_LIST, "Side skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
					Info(playerid, "Side blm ada.");
				}
				case 14:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 15) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_BULLBARS, DIALOG_STYLE_LIST, "Bull bars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 15:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						pData[playerid][pMechColor1] = 1086;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 45) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 45;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"45 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 16:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						pData[playerid][pMechColor1] = 1087;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 45) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 45;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"45 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 17:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{
						pData[playerid][pMechColor1] = 1009;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 75) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 75;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"75 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 18:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{

						pData[playerid][pMechColor1] = 1008;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 112) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 112;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"112 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 19:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{
						pData[playerid][pMechColor1] = 1010;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 150) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 20:
				{
					if(IsPlayerInRangeOfPoint(playerid, 30.0, 1795.8846,-2023.5182,13.5735))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_NEON,DIALOG_STYLE_LIST,"Neon","RED\nBLUE\nGREEN\nYELLOW\nPINK\nWHITE\nREMOVE","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_COLOR)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
			
			ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Close");
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_COLOR2)
	{
		if(response)
		{
			pData[playerid][pMechColor2] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor2] < 0 || pData[playerid][pMechColor2] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Close");
			
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{	
				if(pData[playerid][pComponent] < 12) return Error(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 12;
				Info(playerid, "Anda mengganti warna kendaraan dengan "RED_E"12 component.");
				pData[playerid][pMechanic] = SetTimerEx("SprayCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Spraying Car...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_PAINTJOB)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 3)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
			
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{	
				if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 30;
				Info(playerid, "Anda mengganti paintjob kendaraan dengan "RED_E"30 component.");
				pData[playerid][pMechanic] = SetTimerEx("PaintjobCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Painting Car...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_WHEELS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = 1025;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = 1074;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = 1076;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = 1078;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = 1081;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = 1082;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 1085;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					pData[playerid][pMechColor1] = 1096;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					pData[playerid][pMechColor1] = 1097;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 9:
				{
					pData[playerid][pMechColor1] = 1098;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 10:
				{
					pData[playerid][pMechColor1] = 1084;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 11:
				{
					pData[playerid][pMechColor1] = 1073;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 12:
				{
					pData[playerid][pMechColor1] = 1075;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 13:
				{
					pData[playerid][pMechColor1] = 1077;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 14:
				{
					pData[playerid][pMechColor1] = 1079;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 15:
				{
					pData[playerid][pMechColor1] = 1080;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 16:
				{
					pData[playerid][pMechColor1] = 1083;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 25) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 25;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"25 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SPOILER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1147;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1049;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1162;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1058;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1164;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1138;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1146;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1050;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1158;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1060;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1163;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1139;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1001;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1023;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 401 ||
						VehicleModel == 517 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 477 ||
						VehicleModel == 547 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1003;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 547 ||
						VehicleModel == 405)
						{
				
							pData[playerid][pMechColor1] = 1000;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 405)
						{
				
							pData[playerid][pMechColor1] = 1014;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542)
						{
				
							pData[playerid][pMechColor1] = 1015;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 546 ||
						VehicleModel == 517)
						{
				
							pData[playerid][pMechColor1] = 1002;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_HOODS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{
				
							pData[playerid][pMechColor1] = 1005;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 402 ||
						VehicleModel == 546 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{
				
							pData[playerid][pMechColor1] = 1004;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401)
						{
				
							pData[playerid][pMechColor1] = 1011;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1012;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_VENTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 547 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1142;
							pData[playerid][pMechColor2] = 1143;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1144;
							pData[playerid][pMechColor2] = 1145;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_LIGHTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 436 ||
						VehicleModel == 439)
						{
				
							pData[playerid][pMechColor1] = 1013;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 603 ||
						VehicleModel == 400)
						{
				
							pData[playerid][pMechColor1] = 1024;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_EXHAUSTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1034;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1046;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1065;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1064;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1028;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1089;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1037;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1045;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1066;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1059;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1029;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1092;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1044;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1126;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1129;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1104;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1113;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1136;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1043;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1127;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1132;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1105;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1135;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1114;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1020;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 400 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1021;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 436)
						{
							
							pData[playerid][pMechColor1] = 1022;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1019;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 24) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 415 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1018;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 24;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"24 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_FRONT_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1171;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1153;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1160;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1155;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1166;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1169;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 30;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"30 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1172;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1152;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1173;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1157;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1165;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1170;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 30;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"30 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1174;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1179;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1189;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1182;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1191;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1115;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 30;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"30 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1175;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1185;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1188;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1181;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1190;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1116;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 30;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"30 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_REAR_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1149;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1150;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1159;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1154;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1168;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1141;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 30;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"30 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1148;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1151;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1161;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1156;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1167;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1140;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 30;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"30 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1176;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1180;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1187;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1184;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1192;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1109;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 30;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"30 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 30) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1177;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1178;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1186;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1183;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1193;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1110;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 30;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"30 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_ROOFS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1054;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1067;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1055;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1088;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1032;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1053;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1068;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1061;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1091;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1033;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1130;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1128;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1131;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1103;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 21) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1006;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 21;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"21 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SIDE_SKIRTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1036;
								pData[playerid][pMechColor2] = 1040;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1047;
								pData[playerid][pMechColor2] = 1051;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1069;
								pData[playerid][pMechColor2] = 1071;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1056;
								pData[playerid][pMechColor2] = 1062;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1090;
								pData[playerid][pMechColor2] = 1094;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1026;
								pData[playerid][pMechColor2] = 1027;
							}
							
							pData[playerid][pComponent] -= 27;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"27 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1039;
								pData[playerid][pMechColor2] = 1041;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1048;
								pData[playerid][pMechColor2] = 1052;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1070;
								pData[playerid][pMechColor2] = 1072;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1057;
								pData[playerid][pMechColor2] = 1063;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1093;
								pData[playerid][pMechColor2] = 1095;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1031;
								pData[playerid][pMechColor2] = 1030;
							}
							
							pData[playerid][pComponent] -= 27;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"27 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 567)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1042;
								pData[playerid][pMechColor2] = 1099;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1108;
								pData[playerid][pMechColor2] = 1107;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1134;
								pData[playerid][pMechColor2] = 1137;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1102;
								pData[playerid][pMechColor2] = 1133;
							}
							
							pData[playerid][pComponent] -= 27;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"27 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1102;
							pData[playerid][pMechColor2] = 1101;
							
							pData[playerid][pComponent] -= 27;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"27 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1106;
							pData[playerid][pMechColor2] = 1124;
							
							pData[playerid][pComponent] -= 27;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"27 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{
				
							pData[playerid][pMechColor1] = 1118;
							pData[playerid][pMechColor2] = 1120;
							
							pData[playerid][pComponent] -= 27;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"27 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{
				
							pData[playerid][pMechColor1] = 1119;
							pData[playerid][pMechColor2] = 1121;
							
							pData[playerid][pComponent] -= 27;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"27 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 27) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 436 ||
						VehicleModel == 439 ||
						VehicleModel == 580 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
				
							pData[playerid][pMechColor1] = 1007;
							pData[playerid][pMechColor2] = 1017;
							
							pData[playerid][pComponent] -= 27;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"27 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_BULLBARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 15) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1100;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 15;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"15 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 15) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1123;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 15;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"15 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 15) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1125;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 15;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"15 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 15) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1117;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 15;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"15 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_NEON)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = RED_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 135;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"135 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = BLUE_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 135;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"135 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = GREEN_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 135;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"135 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = YELLOW_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 135;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"135 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = PINK_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 135;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"135 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = WHITE_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 135;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"135 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 135) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 135;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"135 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PLANT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pSeed] < 5) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");

					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");

					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");

					if(IsPlayerInRangeOfPoint(playerid, 100.0, -263.49, -1508.27, 5.66) || IsPlayerInRangeOfPoint(playerid, 100.0, -424.36, -1330.72, 27.46)
					|| IsPlayerInRangeOfPoint(playerid, 100.0, -243.84, -1366.69, 9.95) || IsPlayerInRangeOfPoint(playerid, 100.0, -563.65, -1344.91, 22.39))
					{

						pData[playerid][pSeed] -= 5;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 1;
						PlantData[id][PlantTime] = 1800;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Potato.");
					}
					else return Error(playerid, "You must in farmer area!");
				}
				case 1:
				{
					if(pData[playerid][pSeed] < 18) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");

					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");

					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");

					if(IsPlayerInRangeOfPoint(playerid, 100.0, -263.49, -1508.27, 5.66) || IsPlayerInRangeOfPoint(playerid, 100.0, -424.36, -1330.72, 27.46)
					|| IsPlayerInRangeOfPoint(playerid, 100.0, -243.84, -1366.69, 9.95) || IsPlayerInRangeOfPoint(playerid, 100.0, -563.65, -1344.91, 22.39))
					{

						pData[playerid][pSeed] -= 18;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 2;
						PlantData[id][PlantTime] = 2500;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Wheat.");
					}
					else return Error(playerid, "You must in farmer area!");
				}
				case 2:
				{
					if(pData[playerid][pSeed] < 11) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");

					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");

					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");

					if(IsPlayerInRangeOfPoint(playerid, 100.0, -263.49, -1508.27, 5.66) || IsPlayerInRangeOfPoint(playerid, 100.0, -424.36, -1330.72, 27.46)
					|| IsPlayerInRangeOfPoint(playerid, 100.0, -243.84, -1366.69, 9.95) || IsPlayerInRangeOfPoint(playerid, 100.0, -563.65, -1344.91, 22.39))
					{

						pData[playerid][pSeed] -= 11;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 3;
						PlantData[id][PlantTime] = 2700;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Orange.");
					}
					else return Error(playerid, "You must in farmer area!");
				}
				case 3:
				{
					if(pData[playerid][pSeed] < 25) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");

					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");

					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");

					if(IsPlayerInRangeOfPoint(playerid, 100.0, -263.49, -1508.27, 5.66) || IsPlayerInRangeOfPoint(playerid, 100.0, -424.36, -1330.72, 27.46)
					|| IsPlayerInRangeOfPoint(playerid, 100.0, -243.84, -1366.69, 9.95) || IsPlayerInRangeOfPoint(playerid, 100.0, -563.65, -1344.91, 22.39))
					{

						pData[playerid][pSeed] -= 25;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 4;
						PlantData[id][PlantTime] = 3500;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Orange.");
					}
					else return Error(playerid, "You must in farmer area!");
				}
			}
		}
	}
	if(dialogid == PFARM_PLANT)
	{
		if(response)
		{
			foreach(new pfid : PFarm)
			{
				switch(listitem)
				{
					case 0:
					{
						if(pData[playerid][pSeed] < 5)
							return Error(playerid, "Not enough seed!");
						
						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");

						new pid = GetNearPlant(playerid);
						if(pid != -1)
							return Error(playerid, "You too closes with other plant!");

						new id = Iter_Free(Plants);
						if(id == -1)
							return Error(playerid, "Cant plant any more plant!");

						pData[playerid][pSeed] -= 5;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 1;
						PlantData[id][PlantTime] = 1800;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Potato.");
					}
					case 1:
					{
						if(pData[playerid][pSeed] < 18)
							return Error(playerid, "Not enough seed!");

						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");

						new pid = GetNearPlant(playerid);
						if(pid != -1)
							return Error(playerid, "You too closes with other plant!");

						new id = Iter_Free(Plants);
						if(id == -1)
							return Error(playerid, "Cant plant any more plant!");

						pData[playerid][pSeed] -= 18;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 2;
						PlantData[id][PlantTime] = 3600;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Wheat.");
					}
					case 2:
					{
						if(pData[playerid][pSeed] < 11)
							return Error(playerid, "Not enough seed!");

						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");

						new pid = GetNearPlant(playerid);
						if(pid != -1)
							return Error(playerid, "You too closes with other plant!");

						new id = Iter_Free(Plants);
						if(id == -1)
							return Error(playerid, "Cant plant any more plant!");

						pData[playerid][pSeed] -= 11;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 3;
						PlantData[id][PlantTime] = 2700;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Orange.");
					}
					case 3:
					{
						if(pData[playerid][pSeed] < 50)
							return Error(playerid, "Not enough seed!");

						if(!Iter_Contains(PFarm, pfid))
							return Error(playerid, "Invalid ID.");

						new pid = GetNearPlant(playerid);
						if(pid != -1)
							return Error(playerid, "You too closes with other plant!");

						new id = Iter_Free(Plants);
						if(id == -1)
							return Error(playerid, "Cant plant any more plant!");

						pData[playerid][pSeed] -= 50;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 4;
						PlantData[id][PlantTime] = 4500;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Marijuana.");
					}
				}
			}
		}
	}
	if(dialogid == HAULING_DELIVERY)
	{
		if(HaulingType[playerid] != 0)
			return Error(playerid, "Kamu memiliki tugas pengantaran yang belum diselesaikan (/stophauling jika ingin membatalkan pengantaran)");

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					VehHauling[playerid] = AddStaticVehicle(584, 2781.00, -2493.73, 13.75+0.2, 89.88, -1, -1);
					HaulingType[playerid] = 1;
					SetPlayerCheckpoint(playerid, 2781.00, -2493.73, 13.75, 15.0); //TAKE PETROL
					Info(playerid, "Ikuti checkpoint untuk mengambil trailer yang akan kamu antar menuju gas station");
				}
				case 1:
				{
					if(GetDealerRestock() <= 0)
						return Error(playerid, "Mission dealer sedang kosong.");

					new id, count = GetDealerRestock(), mission[2024], lstr[3024], type[1024];

					strcat(mission,"NO\tNAMES\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockDealerID(itt);
						if(drData[id][dType] == 1)
						{
							type = "Bikes Vehicles";
						}
						else if(drData[id][dType] == 2)
						{
							type = "Cars";
						}
						else if(drData[id][dType] == 3)
						{
							type = "Unique Cars";
						}
						else if(drData[id][dType] == 4)
						{
							type = "Jobs Vehicles";
						}
						else if(drData[id][dType] == 5)
						{
							type = "Rental Jobs";
						}
						else
						{
							type = "{FF0000}Unknown{FFFFFF}";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", itt, drData[id][dName], type, GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", itt, drData[id][dName], type, GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]));
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_DEALER, DIALOG_STYLE_TABLIST_HEADERS,"Dealer Restock",mission,"Start","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_RESTOCK_DEALER)
	{
		if(HaulingType[playerid] != 0)
			return Error(playerid, "Kamu memiliki tugas pengantaran yang belum diselesaikan (/stophauling jika ingin membatalkan pengantaran)");

		if(response)
		{
			new id = ReturnRestockDealerID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsAHaulingVeh(vehicleid)) 
				return Error(playerid, "Kendaraan ini tidak support untuk melakukan hauling");

			VehHauling[playerid] = AddStaticVehicle(591, 2781.44, -2455.97, 13.73+0.2, 89.67, -1, -1);
			HaulingType[playerid] = 2;
			pData[playerid][pGetDEIDHAULING] = id;
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 2781.44, -2455.97, 13.73, 15.0); //TAKE DEALER
			Info(playerid, "Ikuti checkpoint untuk mengambil trailer yang akan kamu antar menuju dealer");
		}
	}
	if(dialogid == DIALOG_LOADBOX)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetVehicleModel(vehicleid) != 578)
						return Error(playerid, "Untuk merestock bisnis kamu harus mengendarai kendaraan DFT-30 milik trucker");
					
					new str[1024];
					format(str, sizeof(str), "Fast Food\nMarket\nClothes\nEquipment\nGun Shop\nGym");
					ShowPlayerDialog(playerid, DIALOG_RESTOCK1, DIALOG_STYLE_LIST,"Trucker Restock", str, "Start", "Cancel");
				}
				case 1:
				{
					if(GetRestockVending() <= 0)
						return Error(playerid, "Belum ada yang merequest restock vending machine.");

					new id, count = GetRestockVending(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tLOCATION\tOWNER\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockVendingID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\n", itt, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), vmData[id][venOwner]);
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\n", itt, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), vmData[id][venOwner]);	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK2, DIALOG_STYLE_TABLIST_HEADERS,"Vending Restock",mission,"Start","Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK1)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetBisnisFastFood() <= 0)
						return Error(playerid, "Belum ada yang merequest restock untuk bisnis type ini.");

					new id, count = GetBisnisFastFood(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tNAMES\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockFoodID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\tFastfood\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\tFastfood\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_FOOD, DIALOG_STYLE_TABLIST_HEADERS,"Fastfood Restock",mission,"Start","Cancel");
				}
				case 1:
				{
					if(GetBisnisMarket() <= 0)
						return Error(playerid, "Belum ada yang merequest restock untuk bisnis type ini.");

					new id, count = GetBisnisMarket(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tNAMES\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockMarketID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\tMarket\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\tMarket\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_MARKET, DIALOG_STYLE_TABLIST_HEADERS,"Market Restock",mission,"Start","Cancel");
				}
				case 2:
				{
					if(GetBisnisClothes() <= 0)
						return Error(playerid, "Belum ada yang merequest restock untuk bisnis type ini..");

					new id, count = GetBisnisClothes(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tNAMES\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockClothesID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\tClothes\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\tClothes\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_CLOTHES, DIALOG_STYLE_TABLIST_HEADERS,"Clothes Restock",mission,"Start","Cancel");
				}
				case 3:
				{
					if(GetBisnisEquipment() <= 0)
						return Error(playerid, "Belum ada yang merequest restock untuk bisnis type ini.");

					new id, count = GetBisnisEquipment(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tNAMES\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockEquipmentID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\tEquipment\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\tEquipment\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_EQUIPMENT, DIALOG_STYLE_TABLIST_HEADERS,"Equipment Restock",mission,"Start","Cancel");
				}
				case 4:
				{
					if(GetBisnisGunshop() <= 0)
						return Error(playerid, "Belum ada yang merequest restock untuk bisnis type ini.");

					new id, count = GetBisnisGunshop(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tNAMES\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockGunshopID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\tGun Shop\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\tGun Shop\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_GUNSHOP, DIALOG_STYLE_TABLIST_HEADERS,"Gunshop Restock",mission,"Start","Cancel");
				}
				case 5:
				{
					if(GetBisnisGym() <= 0)
						return Error(playerid, "Belum ada yang merequest restock untuk bisnis type ini.");

					new id, count = GetBisnisGym(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tNAMES\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockGymID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\tGym\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\tGym\t%s\n", itt, bData[id][bName], GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_GYM, DIALOG_STYLE_TABLIST_HEADERS,"Gym Restock",mission,"Start","Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK2)
	{
		if(response)
		{
			new id = ReturnRestockVendingID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMissionBiz] > -1 || pData[playerid][pMissionVen] > -1)
				return Error(playerid, "Kamu sedang melakukan mission, selesaikan terlebih dahulu!");
				
			pData[playerid][pMissionVen] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, vmData[id][venX], vmData[id][venY], vmData[id][venZ]);

			VehProduct[vehicleid] += 15;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 15;
			}
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, vmData[id][venX], vmData[id][venY], vmData[id][venZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju vending machine yang berlokasi di %s berjarak %0.0fm", GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), GetPlayerDistanceFromPoint(playerid, vmData[id][venX], vmData[id][venY], vmData[id][venZ]));
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK_FOOD)
	{
		if(response)
		{
			new id = ReturnRestockFoodID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMissionBiz] > -1 || pData[playerid][pMissionVen] > -1)
				return Error(playerid, "Kamu sedang melakukan mission, selesaikan terlebih dahulu!");
			
			pData[playerid][pMissionBiz] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Server_AddMoney(500);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
			
			TruckerVehObject[GetPlayerVehicleID(playerid)] = CreateDynamicObject(2934, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 90.0, 90.0);
			AttachDynamicObjectToVehicle(TruckerVehObject[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.0, -1.98, 1.20, 0.0, 0.0, 0.0);
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK_MARKET)
	{
		if(response)
		{
			new id = ReturnRestockMarketID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMissionBiz] > -1 || pData[playerid][pMissionVen] > -1)
				return Error(playerid, "Kamu sedang melakukan mission, selesaikan terlebih dahulu!");
				
			pData[playerid][pMissionBiz] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Server_AddMoney(500);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
			
			TruckerVehObject[GetPlayerVehicleID(playerid)] = CreateDynamicObject(2934, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 90.0, 90.0);
			AttachDynamicObjectToVehicle(TruckerVehObject[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.0, -1.98, 1.20, 0.0, 0.0, 0.0);
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK_CLOTHES)
	{
		if(response)
		{
			new id = ReturnRestockClothesID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMissionBiz] > -1 || pData[playerid][pMissionVen] > -1)
				return Error(playerid, "Kamu sedang melakukan mission, selesaikan terlebih dahulu!");
				
			pData[playerid][pMissionBiz] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Server_AddMoney(500);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
			
			TruckerVehObject[GetPlayerVehicleID(playerid)] = CreateDynamicObject(2934, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 90.0, 90.0);
			AttachDynamicObjectToVehicle(TruckerVehObject[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.0, -1.98, 1.20, 0.0, 0.0, 0.0);
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK_EQUIPMENT)
	{
		if(response)
		{
			new id = ReturnRestockEquipmentID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMissionBiz] > -1 || pData[playerid][pMissionVen] > -1)
				return Error(playerid, "Kamu sedang melakukan mission, selesaikan terlebih dahulu!");
				
			pData[playerid][pMissionBiz] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Server_AddMoney(500);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
			
			TruckerVehObject[GetPlayerVehicleID(playerid)] = CreateDynamicObject(2934, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 90.0, 90.0);
			AttachDynamicObjectToVehicle(TruckerVehObject[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.0, -1.98, 1.20, 0.0, 0.0, 0.0);
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK_GUNSHOP)
	{
		if(response)
		{
			new id = ReturnRestockGunshopID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMissionBiz] > -1 || pData[playerid][pMissionVen] > -1)
				return Error(playerid, "Kamu sedang melakukan mission, selesaikan terlebih dahulu!");
			
			pData[playerid][pMissionBiz] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Server_AddMoney(500);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
			
			TruckerVehObject[GetPlayerVehicleID(playerid)] = CreateDynamicObject(2934, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 90.0, 90.0);
			AttachDynamicObjectToVehicle(TruckerVehObject[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.0, -1.98, 1.20, 0.0, 0.0, 0.0);
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK_GYM)
	{
		if(response)
		{
			new id = ReturnRestockGymID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMissionBiz] > -1 || pData[playerid][pMissionVen] > -1)
				return Error(playerid, "Kamu sedang melakukan mission, selesaikan terlebih dahulu!");
				
			pData[playerid][pMissionBiz] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Server_AddMoney(500);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
			
			TruckerVehObject[GetPlayerVehicleID(playerid)] = CreateDynamicObject(2934, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 90.0, 90.0);
			AttachDynamicObjectToVehicle(TruckerVehObject[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.0, -1.98, 1.20, 0.0, 0.0, 0.0);
		}
		return 1;
	}
	if(dialogid == DIALOG_MATERIAL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMaterial] + amount;
			new value = amount * MaterialPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Material terlalu penuh di Inventory! Maximal 500.");
			if(pData[playerid][pMoney] < value) return Error(playerid, "Uang anda kurang.");
			if(Material < amount) return Error(playerid, "Material stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMaterial] += amount;
			Material -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"material seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_COMPONENT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pComponent] + amount;
			new value = amount * ComponentPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Component terlalu penuh di Inventory! Maximal 500.");
			if(pData[playerid][pMoney] < value) return Error(playerid, "Uang anda kurang.");
			if(Component < amount) return Error(playerid, "Component stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pComponent] += amount;
			Component -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"component seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_DAGING)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = PlayerHasItem(playerid, "Daging") + amount;
			new value = amount * DagingPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Daging terlalu penuh di Inventory! Maximal 500.");
			if(pData[playerid][pMoney] < value) return Error(playerid, "Uang anda kurang.");
			if(Daging < amount) return Error(playerid, "Daging stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pDaging] += amount;
			new str[500];
			format(str, sizeof(str), "Received_%dx", amount);
			ShowItemBox(playerid, "Daging", str, 2804, 2);
			//Inventory_Add(playerid, "Daging", 2805, amount);
			Daging -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"daging seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_DRUGS)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMarijuana] + amount;
			new value = amount * MarijuanaPrice;
			if(amount < 0 || amount > 100) return Error(playerid, "amount maximal 0 - 100.");
			if(total > 100) return Error(playerid, "Marijuana full in your inventory! max: 100 kg.");
			if(pData[playerid][pMoney] < value) return Error(playerid, "Uang anda kurang.");
			if(Marijuana < amount) return Error(playerid, "Marijuana stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMarijuana] += amount;
			Marijuana -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Marijuana seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_FOOD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//buy food
					if(pData[playerid][pFood] > 500) return Error(playerid, "Anda sudah membawa 500 Food!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Food:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Food Price"GREEN_E"%s /item", Food, FormatMoney(FoodPrice));
					ShowPlayerDialog(playerid, DIALOG_FOOD_BUY, DIALOG_STYLE_INPUT, "Buy Food", mstr, "Buy", "Cancel");
				}
				case 1:
				{
					//buy seed
					if(pData[playerid][pSeed] > 100) return Error(playerid, "Anda sudah membawa 100 Seed!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Seed:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Seed Price"GREEN_E"%s /item", Food, FormatMoney(SeedPrice));
					ShowPlayerDialog(playerid, DIALOG_SEED_BUY, DIALOG_STYLE_INPUT, "Buy Seed", mstr, "Buy", "Cancel");
				}
				case 2:
				{
					//wheat
					if(pData[playerid][pWheat] > 500) return Error(playerid, "Anda sudah membawa 500 Wheat!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Wheat:\nWheat Stock: "GREEN_E"%d\n"WHITE_E"Wheat Price"GREEN_E"%s /item", Gandum, FormatMoney(GandumPrice));
					ShowPlayerDialog(playerid, DIALOG_GANDUM_BUY, DIALOG_STYLE_INPUT, "Buy Wheat", mstr, "Buy", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_FOOD_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pFood] + amount;
			new value = amount * FoodPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Food terlalu penuh di Inventory! Maximal 500.");
			if(pData[playerid][pMoney] < value) return Error(playerid, "Uang anda kurang.");
			if(Food < amount) return Error(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pFood] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Food seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_SEED_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pSeed] + amount;
			new value = amount * SeedPrice;
			if(amount < 0 || amount > 100) return Error(playerid, "amount maximal 0 - 100.");
			if(total > 100) return Error(playerid, "Seed terlalu penuh di Inventory! Maximal 100.");
			if(pData[playerid][pMoney] < value) return Error(playerid, "Uang anda kurang.");
			if(Food < amount) return Error(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pSeed] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Seed seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_GANDUM_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pWheat] + amount;
			new value = amount * GandumPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Wheat terlalu penuh di Inventory! Maximal 500.");
			if(pData[playerid][pMoney] < value) return Error(playerid, "Uang anda kurang.");
			if(Gandum < amount) return Error(playerid, "Gandum di stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pWheat] += amount;
			Gandum -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Wheat seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Sprunk(1 - 500):\nPrice 1(Sprunk): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice1]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE1, DIALOG_STYLE_INPUT, "Price 1", mstr, "Edit", "Cancel");
				}
				case 1:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Snack(1 - 500):\nPrice 2(Snack): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice2]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE2, DIALOG_STYLE_INPUT, "Price 2", mstr, "Edit", "Cancel");
				}
				case 2:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Ice Cream Orange(1 - 500):\nPrice 3(Ice Cream Orange): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice3]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE3, DIALOG_STYLE_INPUT, "Price 3", mstr, "Edit", "Cancel");
				}
				case 3:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Hotdog(1 - 500):\nPrice 4(Hotdog): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice4]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE4, DIALOG_STYLE_INPUT, "Price 4", mstr, "Edit", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE1)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice1] = amount;
			Info(playerid, "Anda berhasil mengedit price 1(Sprunk) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE2)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice2] = amount;
			Info(playerid, "Anda berhasil mengedit price 2(Snack) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE3)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice3] = amount;
			Info(playerid, "Anda berhasil mengedit price 3(Ice Cream Orange) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE4)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice4] = amount;
			Info(playerid, "Anda berhasil mengedit price 4(Hotdog) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_OFFER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");
					
					if(pData[playerid][pMoney] < pData[id][pPrice1])
						return Error(playerid, "Not enough money!");
						
					if(pData[id][pFood] < 5)
						return Error(playerid, "Food stock empty!");
					
					GivePlayerMoneyEx(id, pData[id][pPrice1]);
					pData[id][pFood] -= 5;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice1]);
					pData[playerid][pSprunk] += 1;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli sprunk seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice1]));
				}
				case 1:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");
					
					if(pData[playerid][pMoney] < pData[id][pPrice2])
						return Error(playerid, "Not enough money!");
					
					if(pData[id][pFood] < 5)
						return Error(playerid, "Food stock empty!");
						
					GivePlayerMoneyEx(id, pData[id][pPrice2]);
					pData[id][pFood] -= 5;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice2]);
					pData[playerid][pSnack] += 1;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli snack seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice2]));	
				}
				case 2:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");
					
					if(pData[playerid][pMoney] < pData[id][pPrice3])
						return Error(playerid, "Not enough money!");
					
					if(pData[id][pFood] < 10)
						return Error(playerid, "Food stock empty!");
						
					GivePlayerMoneyEx(id, pData[id][pPrice3]);
					pData[id][pFood] -= 10;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice3]);
					pData[playerid][pEnergy] += 30;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli ice cream orange seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice3]));
				}
				case 3:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");
					
					if(pData[playerid][pMoney] < pData[id][pPrice4])
						return Error(playerid, "Not enough money!");
						
					if(pData[id][pFood] < 10)
						return Error(playerid, "Food stock empty!");
					
					GivePlayerMoneyEx(id, pData[id][pPrice4]);
					pData[id][pFood] -= 10;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice4]);
					pData[playerid][pHunger] += 30;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli hotdog seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice4]));
				}
			}
		}
		pData[playerid][pOffer] = -1;
	}
	if(dialogid == DIALOG_APOTEK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[254];
					format(str, sizeof(str), ""WHITE_E"Medicine stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah medicine yang ingin kamu beli:", Apotek, FormatMoney(MedicinePrice));
					ShowPlayerDialog(playerid, DIALOG_BUY_MEDICINE, DIALOG_STYLE_INPUT, "Apotek Menu (Medicine)", str, "Yes", "No");
				}
				case 1:
				{
					new str[254];
					format(str, sizeof(str), ""WHITE_E"Medkit stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah medkit yang ingin kamu beli:", Apotek, FormatMoney(MedicinePrice));
					ShowPlayerDialog(playerid, DIALOG_BUY_MEDKIT, DIALOG_STYLE_INPUT, "Apotek Menu (Medkit)", str, "Yes", "No");
				}
				case 2:
				{
					new str[254];
					format(str, sizeof(str), ""WHITE_E"Bandage stock: "GREEN_E"%d ($100/item)\n\n"WHITE_E"Masukan jumlah bandage yang ingin kamu beli:", Apotek);
					ShowPlayerDialog(playerid, DIALOG_BUY_BANDAGE, DIALOG_STYLE_INPUT, "Apotek Menu (Bandage)", str, "Yes", "No");
				}
				case 3:
				{
					new str[254];
					format(str, sizeof(str), ""WHITE_E"Obat Stress stock: "GREEN_E"%d ($750/item)\n\n"WHITE_E"Masukan jumlah obat stress yang ingin kamu beli:", Apotek);
					ShowPlayerDialog(playerid, DIALOG_BUY_STRESS, DIALOG_STYLE_INPUT, "Apotek Menu (Obat Stress)", str, "Yes", "No");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUY_MEDICINE)
	{
		if(!response)
			return 1;

		new ammount = strval(inputtext), str[500];

		if(ammount < 1 || isnull(inputtext))
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Jumlah tidak boleh kosong/dibawah angka 1!\n\n"WHITE_E"Medicine stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah medicine yang ingin kamu beli:", Apotek, FormatMoney(MedicinePrice));
			ShowPlayerDialog(playerid, DIALOG_BUY_MEDICINE, DIALOG_STYLE_INPUT, "Apotek Menu (Medicine)", str, "Yes", "No");
			return 1;
		}
		if(Apotek - ammount < 0)
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Jumlah stock medicine tidak mencukupi\n\n"WHITE_E"Medicine stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah medicine yang ingin kamu beli:", Apotek, FormatMoney(MedicinePrice));
			ShowPlayerDialog(playerid, DIALOG_BUY_MEDICINE, DIALOG_STYLE_INPUT, "Apotek Menu (Medicine)", str, "Yes", "No");
			return 1;
		}
		if(pData[playerid][pMoney] < ammount * MedicinePrice)
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Uang kamu tidak mencukupi\n\n"WHITE_E"Medicine stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah medicine yang ingin kamu beli:", Apotek, FormatMoney(MedicinePrice));
			ShowPlayerDialog(playerid, DIALOG_BUY_MEDICINE, DIALOG_STYLE_INPUT, "Apotek Menu (Medicine)", str, "Yes", "No");
			return 1;
		}

		pData[playerid][pMedicine] += ammount;
		format(str, sizeof(str), "Received_%dx", ammount);
		ShowItemBox(playerid, "Medicine", str, 1575, 2);
		//Inventory_Add(playerid, "Medicine", 1575, ammount);
		Apotek -= ammount;
		Server_AddMoney(ammount * MedicinePrice);
		GivePlayerMoneyEx(playerid, -ammount * MedicinePrice);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s membeli %d medicine dengan harga %s", ReturnName(playerid), ammount, FormatMoney(ammount * MedicinePrice));
	}
	if(dialogid == DIALOG_BUY_MEDKIT)
	{
		if(!response)
			return 1;

		new ammount = strval(inputtext), str[500];

		if(ammount < 1 || isnull(inputtext))
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Jumlah tidak boleh kosong/dibawah angka 1!\n\n"WHITE_E"Medkit stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah medkit yang ingin kamu beli:", Apotek, FormatMoney(MedkitPrice));
			ShowPlayerDialog(playerid, DIALOG_BUY_MEDKIT, DIALOG_STYLE_INPUT, "Apotek Menu (Medkit)", str, "Yes", "No");
			return 1;
		}
		if(Apotek - ammount < 0)
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Jumlah stock medkit tidak mencukupi\n\n"WHITE_E"Medkit stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah medkit yang ingin kamu beli:", Apotek, FormatMoney(MedkitPrice));
			ShowPlayerDialog(playerid, DIALOG_BUY_MEDKIT, DIALOG_STYLE_INPUT, "Apotek Menu (Medkit)", str, "Yes", "No");
			return 1;
		}
		if(pData[playerid][pMoney] < ammount * MedkitPrice)
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Uang kamu tidak mencukupi\n\n"WHITE_E"Medkit stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah medkit yang ingin kamu beli:", Apotek, FormatMoney(MedkitPrice));
			ShowPlayerDialog(playerid, DIALOG_BUY_MEDKIT, DIALOG_STYLE_INPUT, "Apotek Menu (Medkit)", str, "Yes", "No");
			return 1;
		}

		pData[playerid][pMedkit] += ammount;
		format(str, sizeof(str), "Received_%dx", ammount);
		ShowItemBox(playerid, "Medkit", str, 1580, 2);
		//Inventory_Add(playerid, "Medkit", 1580, ammount);
		Apotek -= ammount;
		Server_AddMoney(ammount * MedkitPrice);
		GivePlayerMoneyEx(playerid, -ammount * MedkitPrice);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s membeli %d medkit dengan harga %s", ReturnName(playerid), ammount, FormatMoney(ammount * MedkitPrice));
	}
	if(dialogid == DIALOG_BUY_BANDAGE)
	{
		if(!response)
			return 1;

		new ammount = strval(inputtext), str[500];

		if(ammount < 1 || isnull(inputtext))
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Jumlah tidak boleh kosong/dibawah angka 1!\n\n"WHITE_E"Bandage stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah bandage yang ingin kamu beli:", Apotek, FormatMoney(100));
			ShowPlayerDialog(playerid, DIALOG_BUY_BANDAGE, DIALOG_STYLE_INPUT, "Apotek Menu (Bandage)", str, "Yes", "No");
			return 1;
		}
		if(Apotek - ammount < 0)
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Jumlah stock bandage tidak mencukupi\n\n"WHITE_E"Bandage stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah bandage yang ingin kamu beli:", Apotek, FormatMoney(100));
			ShowPlayerDialog(playerid, DIALOG_BUY_BANDAGE, DIALOG_STYLE_INPUT, "Apotek Menu (Bandage)", str, "Yes", "No");
			return 1;
		}
		if(pData[playerid][pMoney] < ammount * 100)
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Uang kamu tidak mencukupi\n\n"WHITE_E"Bandage stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah bandage yang ingin kamu beli:", Apotek, FormatMoney(100));
			ShowPlayerDialog(playerid, DIALOG_BUY_BANDAGE, DIALOG_STYLE_INPUT, "Apotek Menu (Bandage)", str, "Yes", "No");
			return 1;
		}

		pData[playerid][pBandage] += ammount;
		format(str, sizeof(str), "Received_%dx", ammount);
		ShowItemBox(playerid, "Bandage", str, 11747, 2);
		//Inventory_Add(playerid, "Bandage", 11747, ammount);
		Apotek -= ammount;
		Server_AddMoney(ammount * 100);
		GivePlayerMoneyEx(playerid, -ammount * 100);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s membeli %d bandage dengan harga %s", ReturnName(playerid), ammount, FormatMoney(100));
	}
	if(dialogid == DIALOG_BUY_STRESS)
	{
		if(!response)
			return 1;

		new ammount = strval(inputtext), str[500];

		if(ammount < 1 || isnull(inputtext))
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Jumlah tidak boleh kosong/dibawah angka 1!\n\n"WHITE_E"Obat Stress stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah Obat Stress yang ingin kamu beli:", Apotek, FormatMoney(750));
			ShowPlayerDialog(playerid, DIALOG_BUY_STRESS, DIALOG_STYLE_INPUT, "Apotek Menu (Obat Stress)", str, "Yes", "No");
			return 1;
		}
		if(Apotek - ammount < 0)
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Jumlah stock Obat Stress tidak mencukupi\n\n"WHITE_E"Obat Stress stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah Obat Stress yang ingin kamu beli:", Apotek, FormatMoney(750));
			ShowPlayerDialog(playerid, DIALOG_BUY_STRESS, DIALOG_STYLE_INPUT, "Apotek Menu (Obat Stress)", str, "Yes", "No");
			return 1;
		}
		if(pData[playerid][pMoney] < ammount * 750)
		{
			format(str, sizeof(str), ""RED_E"ERROR:"WHITE_E" Uang kamu tidak mencukupi\n\n"WHITE_E"Obat Stress stock: "GREEN_E"%d (%s/item)\n\n"WHITE_E"Masukan jumlah Obat Stress yang ingin kamu beli:", Apotek, FormatMoney(750));
			ShowPlayerDialog(playerid, DIALOG_BUY_STRESS, DIALOG_STYLE_INPUT, "Apotek Menu (Obat Stress)", str, "Yes", "No");
			return 1;
		}

		pData[playerid][pObatStress] += ammount;
		format(str, sizeof(str), "Received_%dx", ammount);
		ShowItemBox(playerid, "Obat_Stress", str, 1212, 4);
		Apotek -= ammount;
		Server_AddMoney(ammount * 750);
		GivePlayerMoneyEx(playerid, -ammount * 750);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s membeli %d Obat Stress dengan harga %s", ReturnName(playerid), ammount, FormatMoney(750));
	}
	if(dialogid == DIALOG_ATM)
	{
		new id = -1;
		id = GetClosestATM(playerid);
		if(!response) 
			return 1;

		switch(listitem)
		{
			case 0: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}Bank Rekening: "LB_E"%d\n{F6F6F6}Money in your bank account: "LB_E"%s", pData[playerid][pBankRek],FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
			}
			case 1: // Withdraw
			{
				new str[512];
				format(str, sizeof(str), ""WHITE_E"Atm Stock: "YELLOW_E"%s\n"WHITE_E"Bank Money: "GREEN_LIGHT"%s\n\n"WHITE_E"Masukan jumlah uang yang ingin kamu withdraw:", FormatMoney(AtmData[id][atmStock]), FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_INPUT, "Atm Withdraw", str, "Withdraw", "Cancel");
			}
			case 2: // Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_ATMREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
			}
			case 3: //Paycheck
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_ATMREKENING)
	{
		if(!response) 
			return true;

		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) 
			return Error(playerid, "Uang dalam rekening anda kurang.");
		
		if(amount < 1) 
			return Error(playerid, "You have entered an invalid amount!");

		else
		{
			pData[playerid][pTransfer] = amount;
			ShowPlayerDialog(playerid, DIALOG_ATMTRANSFER, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan nomor rekening target:", "Transfer", "Cancel");
		}
	}	
	if(dialogid == DIALOG_TRANSFERREK)
	{
		if(!response) return true;
		new rek = floatround(strval(inputtext)), query[128];
		
		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRekAtm", "id", playerid, rek);
	}
	if(dialogid == DIALOG_ATMWITHDRAW)
	{
		new id = -1;
		id = GetClosestATM(playerid);
		if(response)
		{
			new ammount = strval(inputtext);
			if(ammount < 1)
			{
				new str[512];
				format(str, sizeof(str), ""WHITE_E"Atm Stock: "YELLOW_E"%s\n"WHITE_E"Bank Money: "GREEN_LIGHT"%s\n\n"RED_E"ERROR: "WHITE_E"Jumlah tidak boleh dibawah angka 1!\n"WHITE_E"Masukan jumlah uang yang ingin kamu withdraw:", FormatMoney(AtmData[id][atmStock]), FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_INPUT, "Atm Withdraw", str, "Withdraw", "Cancel");
				return 1;
			}
			if(ammount > pData[playerid][pBankMoney])
			{
				new str[512];
				format(str, sizeof(str), ""WHITE_E"Atm Stock: "YELLOW_E"%s\n"WHITE_E"Bank Money: "GREEN_LIGHT"%s\n\n"RED_E"ERROR: "WHITE_E"Uang dalam rekening anda tidak mencukupi!\n"WHITE_E"Masukan jumlah uang yang ingin kamu withdraw:", FormatMoney(AtmData[id][atmStock]), FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_INPUT, "Atm Withdraw", str, "Withdraw", "Cancel");
				return 1;
			}
			if(ammount > AtmData[id][atmStock])
			{
				new str[512];
				format(str, sizeof(str), ""WHITE_E"Atm Stock: "YELLOW_E"%s\n"WHITE_E"Bank Money: "GREEN_LIGHT"%s\n\n"RED_E"ERROR: "WHITE_E"ATM tidak memiliki stok uang sebanyak itu!\n"WHITE_E"Masukan jumlah uang yang ingin kamu withdraw:", FormatMoney(AtmData[id][atmStock]), FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_INPUT, "Atm Withdraw", str, "Withdraw", "Cancel");
				return 1;
			}

			pData[playerid][pBankMoney] -= ammount;
			AtmData[id][atmStock] -= ammount;
			
			GivePlayerMoneyEx(playerid, ammount);
			SendNearbyMessage(playerid, 15.0, COLOR_PURPLE,  "** %s menarik uang sejumlah %s dari mesin atm", ReturnName(playerid), FormatMoney(ammount));
		}
		return 1;
	}
	if(dialogid == DIALOG_ATMREKENING)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return Error(playerid, "Uang dalam rekening anda kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");

		else
		{
			pData[playerid][pTransfer] = amount;
			ShowPlayerDialog(playerid, DIALOG_ATMTRANSFER, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan nomor rekening target:", "Transfer", "Cancel");
		}
	}
	if(dialogid == DIALOG_ATMTRANSFER)
	{
		if(!response) return true;
		new rek = floatround(strval(inputtext)), query[128];
		
		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRekAtm", "id", playerid, rek);
		return 1;
	}
	if(dialogid == DIALOG_ATMCONFIRM)
	{
		if(response)
		{
			new id = -1;
			id = GetClosestATM(playerid);
			AtmData[id][atmStock] -= pData[playerid][pTransfer];
			Atm_Save(id);

			new query[128], mstr[248];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=bmoney+%d WHERE brek=%d", pData[playerid][pTransfer], pData[playerid][pTransferRek]);
			mysql_tquery(g_SQL, query);
			
			foreach(new ii : Player)
			{
				if(pData[ii][pBankRek] == pData[playerid][pTransferRek])
				{
					pData[ii][pBankMoney] += pData[playerid][pTransfer];
				}
			}
			
			pData[playerid][pBankMoney] -= pData[playerid][pTransfer];
			
			format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda telah berhasil mentransfer!", pData[playerid][pTransferRek], pData[playerid][pTransferName], FormatMoney(pData[playerid][pTransfer]));
			ShowPlayerDialog(playerid, DIALOG_ATMSUKSES, DIALOG_STYLE_MSGBOX, ""LB_E"Transfer Sukses", mstr, "Sukses", "");
		}
	}
	if(dialogid == DIALOG_ATMSUKSES)
	{
		if(response)
		{
			pData[playerid][pTransfer] = 0;
			pData[playerid][pTransferRek] = 0;
		}
	}
	if(dialogid == DIALOG_FIND_ATM)
	{
		if(response) 
		{	
			new id = ReturnRestockATMID((listitem + 1));
			
			if(AtmData[id][atmStock] >= 1000000)
				return Error(playerid, "ATM ini tidak membutuhkan stock");

			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju ATM yang berlokasi di %s yang berjarak %0.0fm", GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), GetPlayerDistanceFromPoint(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
		}
		return 1;
	}
	if(dialogid == DIALOG_TRACKBUSINESS)
	{
		if(response)
		{
			new id = ReturnBusinessID((listitem + 1));

			pData[playerid][pTrackBisnis] = 1;
			SetPlayerRaceCheckpoint(playerid, 1, bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Business checkpoint targeted! (%s)", GetLocation(bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2]));
		}
	}
	if(dialogid == DIALOG_BANK)
	{
		if(!response) 
			return true;
		
		switch(listitem)
		{
			case 0: // Deposit
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Cancel");
			}
			case 1: // Withdraw
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.\n\nType in the amount you want to withdraw below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Withdraw", "Cancel");
			}
			case 2: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
			}
			case 3: //Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
			}
			case 4:
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_BANKDEPOSIT)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pMoney]) return Error(playerid, "You do not have the sufficient funds to make this transaction.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");

		else
		{
			new query[512], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] + amount);
			GivePlayerMoneyEx(playerid, -amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "{F6F6F6}You have successfully deposited "LB_E"%s {F6F6F6}into your bank account.\n"LB_E"Current Balance: {F6F6F6}%s", FormatMoney(amount), FormatMoney(pData[playerid][pBankMoney]));
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Konoha:RP"LB_E"Bank", lstr, "Close", "");

			new string[256];
			format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
			TextDrawSetString(TDBANKAJI[37], string);
		}
	}
	if(dialogid == DIALOG_BANKWITHDRAW)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return Error(playerid, "You do not have the sufficient funds to make this transaction.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		else
		{
			new query[128], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - amount);
			GivePlayerMoneyEx(playerid, amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "{F6F6F6}You have successfully withdrawed "LB_E"%s {F6F6F6}from your bank account.\n"LB_E"Current Balance: {F6F6F6}%s", FormatMoney(amount), FormatMoney(pData[playerid][pBankMoney]));
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Konoha:RP"LB_E"Bank", lstr, "Close", "");

			new string[256];
			format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
			TextDrawSetString(TDBANKAJI[37], string);
		}
	}
	if(dialogid == DIALOG_BANKREKENING)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return Error(playerid, "Uang dalam rekening anda kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");

		else
		{
			pData[playerid][pTransfer] = amount;
			ShowPlayerDialog(playerid, DIALOG_BANKTRANSFER, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan nomor rekening target:", "Transfer", "Cancel");
		}
	}
	if(dialogid == DIALOG_BANKTRANSFER)
	{
		if(!response) return true;
		new rek = floatround(strval(inputtext)), query[128];
		
		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRek", "id", playerid, rek);
		return 1;
	}
	if(dialogid == DIALOG_BANKCONFIRM)
	{
		if(response)
		{
			new query[128], mstr[248];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=bmoney+%d WHERE brek=%d", pData[playerid][pTransfer], pData[playerid][pTransferRek]);
			mysql_tquery(g_SQL, query);
			
			foreach(new ii : Player)
			{
				if(pData[ii][pBankRek] == pData[playerid][pTransferRek])
				{
					pData[ii][pBankMoney] += pData[playerid][pTransfer];
				}
			}
			
			pData[playerid][pBankMoney] -= pData[playerid][pTransfer];
			
			format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda telah berhasil mentransfer!", pData[playerid][pTransferRek], pData[playerid][pTransferName], FormatMoney(pData[playerid][pTransfer]));
			ShowPlayerDialog(playerid, DIALOG_BANKSUKSES, DIALOG_STYLE_MSGBOX, ""LB_E"Transfer Sukses", mstr, "Sukses", "");
		}
	}
	if(dialogid == DIALOG_BANKSUKSES)
	{
		if(response)
		{
			pData[playerid][pTransfer] = 0;
			pData[playerid][pTransferRek] = 0;
		}
	}
	if(dialogid == DIALOG_ASKS)
	{
		if(response) 
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, AskData[i][askText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Ask Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Asked: "GREEN_E"%s\n"WHITE_E"Question: "RED_E"%s.", pData[AskData[i][askPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	if(dialogid == DIALOG_REPORTS)
	{
		if(response) 
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, ReportData[i][rText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Report Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Reported: "GREEN_E"%s\n"WHITE_E"Reason: "RED_E"%s.", pData[ReportData[i][rPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	if(dialogid == DIALOG_BUYPVCP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//Bikes
					new str[1024];
					
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(481), FormatMoney(GetVehicleCost(481)), 
					GetVehicleModelName(509), FormatMoney(GetVehicleCost(509)),
					GetVehicleModelName(510), FormatMoney(GetVehicleCost(510)),
					GetVehicleModelName(462), FormatMoney(GetVehicleCost(462)),
					GetVehicleModelName(586), FormatMoney(GetVehicleCost(586)),
					GetVehicleModelName(581), FormatMoney(GetVehicleCost(581)),
					GetVehicleModelName(461), FormatMoney(GetVehicleCost(461)),
					GetVehicleModelName(521), FormatMoney(GetVehicleCost(521)),
					GetVehicleModelName(463), FormatMoney(GetVehicleCost(463)),
					GetVehicleModelName(468), FormatMoney(GetVehicleCost(468))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_BIKES, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Motorcycle", str, "Buy", "Close");
				}
				case 1:
				{
					//Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(400), FormatMoney(GetVehicleCost(400)), 
					GetVehicleModelName(412), FormatMoney(GetVehicleCost(412)),
					GetVehicleModelName(419), FormatMoney(GetVehicleCost(419)),
					GetVehicleModelName(426), FormatMoney(GetVehicleCost(426)),
					GetVehicleModelName(436), FormatMoney(GetVehicleCost(436)),
					GetVehicleModelName(466), FormatMoney(GetVehicleCost(466)),
					GetVehicleModelName(467), FormatMoney(GetVehicleCost(467)),
					GetVehicleModelName(474), FormatMoney(GetVehicleCost(474)),
					GetVehicleModelName(475), FormatMoney(GetVehicleCost(475)),
					GetVehicleModelName(480), FormatMoney(GetVehicleCost(480)),
					GetVehicleModelName(603), FormatMoney(GetVehicleCost(603)),
					GetVehicleModelName(421), FormatMoney(GetVehicleCost(421)),
					GetVehicleModelName(602), FormatMoney(GetVehicleCost(602)),
					GetVehicleModelName(492), FormatMoney(GetVehicleCost(492)),
					GetVehicleModelName(545), FormatMoney(GetVehicleCost(545)),
					GetVehicleModelName(489), FormatMoney(GetVehicleCost(489)),
					GetVehicleModelName(405), FormatMoney(GetVehicleCost(405)),
					GetVehicleModelName(445), FormatMoney(GetVehicleCost(445)),
					GetVehicleModelName(579), FormatMoney(GetVehicleCost(579)),
					GetVehicleModelName(507), FormatMoney(GetVehicleCost(507))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Mobil", str, "Buy", "Close");
				}
				case 2:
				{
					//Unique Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(483), FormatMoney(GetVehicleCost(483)), 
					GetVehicleModelName(534), FormatMoney(GetVehicleCost(534)),
					GetVehicleModelName(535), FormatMoney(GetVehicleCost(535)),
					GetVehicleModelName(536), FormatMoney(GetVehicleCost(536)),
					GetVehicleModelName(558), FormatMoney(GetVehicleCost(558)),
					GetVehicleModelName(559), FormatMoney(GetVehicleCost(559)),
					GetVehicleModelName(560), FormatMoney(GetVehicleCost(560)),
					GetVehicleModelName(561), FormatMoney(GetVehicleCost(561)),
					GetVehicleModelName(562), FormatMoney(GetVehicleCost(562)),
					GetVehicleModelName(565), FormatMoney(GetVehicleCost(565)),
					GetVehicleModelName(567), FormatMoney(GetVehicleCost(567)),
					GetVehicleModelName(575), FormatMoney(GetVehicleCost(575)),
					GetVehicleModelName(576), FormatMoney(GetVehicleCost(576))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_UCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan Unik", str, "Buy", "Close");
				}
				case 3:
				{
					//Job Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s", 
					GetVehicleModelName(420), FormatMoney(GetVehicleCost(420)), 
					GetVehicleModelName(438), FormatMoney(GetVehicleCost(438)), 
					GetVehicleModelName(403), FormatMoney(GetVehicleCost(403)), 
					GetVehicleModelName(413), FormatMoney(GetVehicleCost(413)),
					GetVehicleModelName(414), FormatMoney(GetVehicleCost(414)),
					GetVehicleModelName(422), FormatMoney(GetVehicleCost(422)),
					GetVehicleModelName(440), FormatMoney(GetVehicleCost(440)),
					GetVehicleModelName(455), FormatMoney(GetVehicleCost(455)),
					GetVehicleModelName(456), FormatMoney(GetVehicleCost(456)),
					GetVehicleModelName(478), FormatMoney(GetVehicleCost(478)),
					GetVehicleModelName(482), FormatMoney(GetVehicleCost(482)),
					GetVehicleModelName(498), FormatMoney(GetVehicleCost(498)),
					GetVehicleModelName(499), FormatMoney(GetVehicleCost(499)),
					GetVehicleModelName(423), FormatMoney(GetVehicleCost(423)),
					GetVehicleModelName(588), FormatMoney(GetVehicleCost(588)),
					GetVehicleModelName(524), FormatMoney(GetVehicleCost(524)),
					GetVehicleModelName(525), FormatMoney(GetVehicleCost(525)),
					GetVehicleModelName(543), FormatMoney(GetVehicleCost(543)),
					GetVehicleModelName(552), FormatMoney(GetVehicleCost(552)),
					GetVehicleModelName(554), FormatMoney(GetVehicleCost(554)),
					GetVehicleModelName(578), FormatMoney(GetVehicleCost(578)),
					GetVehicleModelName(609), FormatMoney(GetVehicleCost(609))
					//GetVehicleModelName(530), FormatMoney(GetVehicleCost(530)) //fortklift
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_JOBCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan Job", str, "Buy", "Close");
				}
				case 4:
				{
					// VIP Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n", 
					GetVehicleModelName(522), GetVipVehicleCost(522), 
					GetVehicleModelName(411), GetVipVehicleCost(411), 
					GetVehicleModelName(451), GetVipVehicleCost(451),
					GetVehicleModelName(415), GetVipVehicleCost(415), 
					GetVehicleModelName(402), GetVipVehicleCost(402), 
					GetVehicleModelName(541), GetVipVehicleCost(541), 
					GetVehicleModelName(429), GetVipVehicleCost(429), 
					GetVehicleModelName(506), GetVipVehicleCost(506), 
					GetVehicleModelName(494), GetVipVehicleCost(494), 
					GetVehicleModelName(502), GetVipVehicleCost(502), 
					GetVehicleModelName(503), GetVipVehicleCost(503), 
					GetVehicleModelName(409), GetVipVehicleCost(409), 
					GetVehicleModelName(477), GetVipVehicleCost(477)
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan VIP", str, "Buy", "Close");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_BIKES)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 509;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 510;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 462;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 586;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 581;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 461;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 521;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 463;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 468;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 400;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 412;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 419;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 426;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 436;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 466;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 467;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 474;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 475;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 480;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 603;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 421;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 602;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 492;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 545;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 489;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 405;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 445;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 579;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 507;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_UCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 483;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 534;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 535;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 536;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 558;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 559;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 560;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 561;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 562;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 565;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 567;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 575;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 576;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 420;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 438;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 403;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 413;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 414;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 422;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 440;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 455;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 456;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 478;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 482;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 498;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 499;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 423;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 588;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 524;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 525;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 543;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 552;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 554;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 20:
				{
					new modelid = 578;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 21:
				{
					new modelid = 609;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 414;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 455;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 456;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 3:
				{
					new modelid = 498;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 4:
				{
					new modelid = 499;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 5:
				{
					new modelid = 609;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 6:
				{
					new modelid = 478;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 7:
				{
					new modelid = 422;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 8:
				{
					new modelid = 543;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 9:
				{
					new modelid = 554;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 10:
				{
					new modelid = 525;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 11:
				{
					new modelid = 438;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 12:
				{
					new modelid = 420;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
			}
		}
	}
	//
	/*if(dialogid == DIALOG_BUYPVCP_BIKES)
	{
		new deid = pData[playerid][pGetDEID];
		
		if(drData[deid][dP][listitem] == 0)
			return Error(playerid, "Harga kendaraan ini belum di set oleh pemiliknya");

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][0];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][0]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 509;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][1];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][1]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 510;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][2];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][2]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 462;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][3];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][3]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 586;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][4];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][4]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 581;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][5];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][5]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 461;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][6];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][6]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 521;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][7];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][7]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 463;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][8];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][8]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 468;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][9];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][9]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPVCP_CARS)
	{
		new deid = pData[playerid][pGetDEID];

		if(drData[deid][dP][listitem] == 0)
			return Error(playerid, "Harga kendaraan ini belum di set oleh pemiliknya");

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 400;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][0];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][0]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 412;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][1];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][1]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 419;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][2];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][2]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 426;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][3];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][3]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 436;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][4];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][4]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 466;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][5];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][5]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 467;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][6];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][6]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 474;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][7];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][7]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 475;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][8];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][8]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 480;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][9];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][9]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 603;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][10];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][10]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 421;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][11];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][11]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 602;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][12];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][12]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 492;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][13];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][13]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 545;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][14];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][14]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 489;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][15];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][15]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 405;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][16];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][16]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 445;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][17];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][17]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 579;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][18];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][18]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 507;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][19];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][19]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPVCP_UCARS)
	{
		new deid = pData[playerid][pGetDEID];

		if(drData[deid][dP][listitem] == 0)
			return Error(playerid, "Harga kendaraan ini belum di set oleh pemiliknya");

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 483;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][0];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][0]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 535;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][1];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][1]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 536;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][2];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][2]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 558;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][3];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][3]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 559;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][4];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][4]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 560;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][5];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][5]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 561;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][6];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][6]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 562;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][7];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][7]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 565;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][8];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][8]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 567;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][9];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][9]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 575;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][10];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][10]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 576;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][11];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][11]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPVCP_JOBCARS)
	{
		new deid = pData[playerid][pGetDEID];

		if(drData[deid][dP][listitem] == 0)
			return Error(playerid, "Harga kendaraan ini belum di set oleh pemiliknya");

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 420;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][0];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][0]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 438;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][1];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][1]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 403;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][2];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][2]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 413;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][3];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][3]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 414;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][4];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][4]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 422;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][5];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][5]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 440;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][6];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][6]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 455;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][7];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][7]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 456;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][8];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][8]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 478;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][9];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][9]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 482;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][10];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][10]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 498;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][11];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][11]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 499;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][12];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][12]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 423;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][13];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][13]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 588;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][14];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][14]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 524;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][15];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][15]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 525;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][16];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][16]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 543;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][17];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][17]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 552;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][18];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][18]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 554;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][19];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][19]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 20:
				{
					new modelid = 578;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][20];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][20]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 21:
				{
					new modelid = 609;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][21];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][21]));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
		return 1;
	}*/
	if(dialogid == DIALOG_BUYPVCP_VIPCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 522;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 411;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 451;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 415;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 541;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 429;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 506;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 494;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 503;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 409;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 477;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
		return 1;
	}
	/*if(dialogid == DIALOG_RENT_JOBCARS)
	{
		new deid = pData[playerid][pGetDEID];

		if(drData[deid][dP][listitem] == 0)
			return Error(playerid, "Harga kendaraan ini belum di set oleh pemiliknya");
		
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 414;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][0];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][0]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 455;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][1];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][1]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 456;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][2];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][2]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 3:
				{
					new modelid = 498;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][3];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][3]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 4:
				{
					new modelid = 499;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][4];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][4]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 5:
				{
					new modelid = 609;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][5];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][5]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 6:
				{
					new modelid = 478;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][6];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][6]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 7:
				{
					new modelid = 422;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][7];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][7]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 8:
				{
					new modelid = 543;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][8];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][8]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 9:
				{
					new modelid = 554;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][9];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][9]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 10:
				{
					new modelid = 525;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][10];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][10]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 11:
				{
					new modelid = 438;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][11];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][11]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 12:
				{
					new modelid = 420;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][12];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][12]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
				case 13:
				{
					new modelid = 403;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					pData[playerid][pGetDEIDPRICE] = drData[deid][dP][13];
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(drData[deid][dP][12]));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Jobs", tstr, "Rental", "Batal");
				}
			}
		}
		return 1;
	}*/
	if(dialogid == DIALOG_RENTBIKES)
	{
		new renid = pData[playerid][pGetRENID];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 509;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(rnData[renid][rPrice]));
					ShowPlayerDialog(playerid, DIALOG_RENTAL_CONFIRM, DIALOG_STYLE_MSGBOX, "Rental Bikes", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 481;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(rnData[renid][rPrice]));
					ShowPlayerDialog(playerid, DIALOG_RENTAL_CONFIRM, DIALOG_STYLE_MSGBOX, "Rental Bikes", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 510;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(rnData[renid][rPrice]));
					ShowPlayerDialog(playerid, DIALOG_RENTAL_CONFIRM, DIALOG_STYLE_MSGBOX, "Rental Bikes", tstr, "Rental", "Batal");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_RENTBOAT)
	{
		new renid = pData[playerid][pGetRENID];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 453;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(rnData[renid][rPrice]));
					ShowPlayerDialog(playerid, DIALOG_RENTAL_CONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boat", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 454;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(rnData[renid][rPrice]));
					ShowPlayerDialog(playerid, DIALOG_RENTAL_CONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boat", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 484;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(rnData[renid][rPrice]));
					ShowPlayerDialog(playerid, DIALOG_RENTAL_CONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boat", tstr, "Rental", "Batal");
				}
				case 3:
				{
					new modelid = 595;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s / one days", GetVehicleModelName(modelid), FormatMoney(rnData[renid][rPrice]));
					ShowPlayerDialog(playerid, DIALOG_RENTAL_CONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boat", tstr, "Rental", "Batal");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_RENTAL_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel], renid = pData[playerid][pGetRENID];
		if(response)
		{
			if(modelid <= 0)
				return Error(playerid, "Invalid model id.");

			new cost = rnData[renid][rPrice];
			if(pData[playerid][pMoney] < cost)
				return Error(playerid, "Uang anda tidak mencukupi.!");

			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new pid, model, color1, color2, rental;

			pid = pData[playerid][pID];
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = rnData[renid][rVehposX];
			y = rnData[renid][rVehposY];
			z = rnData[renid][rVehposZ]+0.5;
			a = rnData[renid][rVehposA];
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRenidPV", "ddddddffffd", playerid, pid, model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
		return 1;
	}
	if(dialogid == DIALOG_RENT_JOBCARSCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < 500)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -500);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new pid, model, color1, color2, rental;

			pid = pData[playerid][pID];
			color1 = 0;
			color2 = 0;
			model = modelid;

			x = 1280.17;
			y = -1300.65;
			z = 13.34;
			a = 177.06;

			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentPV", "ddddddffffd", playerid, pid, model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new pid, model, color1, color2;

			pid = pData[playerid][pID];
			color1 = 0;
			color2 = 0;
			model = modelid;
			
			x = 1280.17;
			y = -1300.65;
			z = 13.34;
			a = 177.06;

			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pid, model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVipVehicleCost(modelid);
			if(pData[playerid][pGold] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			pData[playerid][pGold] -= cost;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new pid, model, color1, color2;

			pid = pData[playerid][pID];
			color1 = 0;
			color2 = 0;
			model = modelid;

			x = 1280.17;
			y = -1300.65;
			z = 13.34;
			a = 177.06;

			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pid, model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	/*if(dialogid == DIALOG_RENT_JOBCARSCONFIRM)
	{
		new deid = pData[playerid][pGetDEID];
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = pData[playerid][pGetDEIDPRICE];
			if(pData[playerid][pMoney] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new pid, model, color1, color2, rental;

			pid = pData[playerid][pID];
			color1 = 0;
			color2 = 0;
			model = modelid;

			x = drData[deid][dVehX];
			y = drData[deid][dVehY];
			z = drData[deid][dVehZ]+0.5;
			a = drData[deid][dVehA];
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentPV", "ddddddffffd", playerid, pid, model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPVCP_CONFIRM)
	{
		new deid = pData[playerid][pGetDEID];
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = pData[playerid][pGetDEIDPRICE];
			if(pData[playerid][pMoney] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new pid, model, color1, color2;

			pid = pData[playerid][pID];
			color1 = 0;
			color2 = 0;
			model = modelid;

			x = drData[deid][dVehX];
			y = drData[deid][dVehY];
			z = drData[deid][dVehZ]+0.5;
			a = drData[deid][dVehA];
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pid, model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCONFIRM)
	{
		new deid = pData[playerid][pGetDEID];
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVipVehicleCost(modelid);
			if(pData[playerid][pGold] < cost)
			{
				Error(playerid, "Gold anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			pData[playerid][pGold] -= cost;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new pid, model, color1, color2;

			pid = pData[playerid][pID];
			color1 = 0;
			color2 = 0;
			model = modelid;

			x = drData[deid][dVehX];
			y = drData[deid][dVehY];
			z = drData[deid][dVehZ]+0.5;
			a = drData[deid][dVehA];
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pid, model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
		return 1;
	}
	if(dialogid == DIALOG_SALARY)
	{
		if(!response) 
		{
			ListPage[playerid]--;
			if(ListPage[playerid] < 0)
			{
				ListPage[playerid] = 0;
				return 1;
			}
		}
		else
		{
			ListPage[playerid]++;
		}
		
		DisplaySalary(playerid);
		return 1;
	}*/
	if(dialogid == DIALOG_PAYCHECK)
	{
		if(response)
		{
			if(pData[playerid][pPaycheck] < 3600) return Error(playerid, "Sekarang belum waktunya anda mengambil paycheck.");
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM salary WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
			mysql_query(g_SQL, query);
			new rows = cache_num_rows();
			if(rows) 
			{
				new list[2000], date[30], info[16], money, totalduty, gajiduty, totalsal, total, pajak, hasil;
				
				totalduty = pData[playerid][pOnDutyTime] + pData[playerid][pTaxiTime];
				for(new i; i < rows; ++i)
				{
					cache_get_value_name(i, "info", info);
					cache_get_value_name(i, "date", date);
					cache_get_value_name_int(i, "money", money);
					totalsal += money;
				}
				
				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty + totalsal;
				pajak = total / 100 * 10;
				hasil = total - pajak;
				
				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Close", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				pData[playerid][pTaxiTime] = 0;
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM salary WHERE owner='%d'", pData[playerid][pID]);
				mysql_query(g_SQL, query);
			}
			else
			{
				new list[2000], totalduty, gajiduty, total, pajak, hasil;
				
				totalduty = pData[playerid][pOnDutyTime] + pData[playerid][pTaxiTime];
				
				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty;
				pajak = total / 100 * 10;
				hasil = total - pajak;
				
				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Close", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				pData[playerid][pTaxiTime] = 0;
			}
		}
	}
	if(dialogid == DIALOG_SWEEPER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			
			pData[playerid][pSideJob] = 1;
			SetPlayerCheckpoint(playerid, sweperpoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_BUS)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(pData[playerid][pSideJobTime] > 0)
		{
			Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerCheckpoint(playerid, buspointmarket1, 7.0);
				}
				case 1:
				{
					SetPlayerCheckpoint(playerid, buspointelcor1, 7.0);
				}
			}
			pData[playerid][pBusRoute] = listitem+1;
			pData[playerid][pSideJob] = 2;
			Info(playerid, "Kamu berhasil memilih route bus %d, Ikuti checkpoint yang telah ditandai!", pData[playerid][pBusRoute]);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_FORKLIFT)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			
			pData[playerid][pSideJob] = 3;
			SetPlayerCheckpoint(playerid, forpoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_LAWN_MOWER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			
			pData[playerid][pSideJob] = 4;
			SetPlayerCheckpoint(playerid, rumputpoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_TRASHMASTER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			
			pData[playerid][pSideJob] = 5;
			Info(playerid, "Kamu memulai sidejob trash master, pergi untuk mencari tong sampah yang penuh di sekeliling kota");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_PHONE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[128];
					format(str, sizeof(str), "Business Tax\nHouse Tax\nDealer Tax\nVending Tax");
					ShowPlayerDialog(playerid, MYTAX_MENU, DIALOG_STYLE_LIST, "MyTax Application", str, "Select", "No");
				}
				case 1:
				{
					new header[1400], count = 0;
				    new bool:status = false;
				    format(header, sizeof(header), "Faction\tFrom\tBill Name\tAmount\n");
				    foreach(new i: tagihan)
				    {
				    	new fac[24];
						if(bilData[i][bilType] == 1)
						{
							fac = "Police";
						}
						else if(bilData[i][bilType] == 2)
						{
							fac = "Goverment";
						}
						else if(bilData[i][bilType] == 3)
						{
							fac = "Medic";
						}
						else if(bilData[i][bilType] == 4)
						{
							fac = "News";
						}
						else if(bilData[i][bilType] == 5)
						{
							fac = "Food Vendor";
						}
				        if(i != -1)
				        {
				            if(bilData[i][bilTarget] == pData[playerid][pID])
				            {
				                format(header, sizeof(header), "%s\t%s\t%s\t%s\t{00ff00}%s\n", header, fac, bilData[i][billoName], bilData[i][bilName], FormatMoney(bilData[i][bilammount]));
				                count++;
				                status = true;
				            }
				        }
				    }
				    if(status)
				    {
				        ShowPlayerDialog(playerid, DIALOG_PAYBILL, DIALOG_STYLE_TABLIST_HEADERS, "My invoice", header, "Pay", "back");
				    }
				    else
				    {
				        Error(playerid, "You have no bills");
				    }
				}
				case 2:
				{
					DisplayContact(playerid);
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_MBANK, DIALOG_STYLE_LIST, "{bab8a2}MBanking", "Check Balance\nTransfer Money\nSign Paycheck", "Select", "Back");
				}
				case 4:
				{
					new string[512], twitter[64], gps[64], ads[64];
					if(pData[playerid][pTwtIns] < 1)
					{
						twitter = ""RED_E"Install";
					}
					else
					{
						twitter = ""LG_E"Terinstall";
					}
					if(pData[playerid][pGpsIns] < 1)
					{
						gps = ""RED_E"Install";
					}
					else
					{
						gps = ""LG_E"Terinstall";
					}
					if(pData[playerid][pAonaIns] < 1)
					{
						ads = ""RED_E"Install";
					}
					else
					{
						ads = ""LG_E"Terinstall";
					}
					format(string, sizeof(string),"Aplikasi\tStatus\n{7fffd4}Twitter ( 6Mb )\t%s\n{bab8a2}Gps ( 8Mb )\t%s\n{fcba03}Ads Of News Agency ( 3Mb )\t%s", twitter, gps, ads);
					ShowPlayerDialog(playerid, DIALOG_APPSTORE, DIALOG_STYLE_TABLIST_HEADERS, "App Store",string,"Download","Back");
				}
				case 5:
				{
					if(pData[playerid][pGpsIns] == 1 && pData[playerid][pTwtIns] == 0 && pData[playerid][pAonaIns] == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nPublic GPS\nPersonal GPS\nNearest GPS\nCity Hall\nDriving School\nBank Central\nValet Apartement\nJobs Location", "Select", "Close");
					}
					else if(pData[playerid][pGpsIns] == 0 && pData[playerid][pTwtIns] == 1 && pData[playerid][pAonaIns] == 0)
					{
						new str[128];
						format(str, sizeof(str), "Set Username\nPost Message");
						ShowPlayerDialog(playerid, TWITTER_MENU, DIALOG_STYLE_LIST, "Twitter Application", str, "Select", "No");
					}
					else if(pData[playerid][pGpsIns] == 0 && pData[playerid][pTwtIns] == 0 && pData[playerid][pAonaIns] == 1)
					{
						ShowAdsLog(playerid);
					}
					else if(pData[playerid][pGpsIns] == 1 && pData[playerid][pTwtIns] == 1 && pData[playerid][pAonaIns] == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nPublic GPS\nPersonal GPS\nNearest GPS\nCity Hall\nDriving School\nBank Central\nValet Apartement\nJobs Location", "Select", "Close");
					}
					else if(pData[playerid][pGpsIns] == 0 && pData[playerid][pTwtIns] == 1 && pData[playerid][pAonaIns] == 1)
					{
						ShowAdsLog(playerid);
					}
					else if(pData[playerid][pGpsIns] == 1 && pData[playerid][pTwtIns] == 0 && pData[playerid][pAonaIns] == 1)
					{
						ShowAdsLog(playerid);
					}
					else if(pData[playerid][pGpsIns] == 1 && pData[playerid][pTwtIns] == 1 && pData[playerid][pAonaIns] == 1)
					{
						new str[128];
						format(str, sizeof(str), "Set Username\nPost Message");
						ShowPlayerDialog(playerid, TWITTER_MENU, DIALOG_STYLE_LIST, "Twitter Application", str, "Select", "No");
					}
				}
				case 6:
				{
					if(pData[playerid][pGpsIns] == 1 && pData[playerid][pTwtIns] == 1 && pData[playerid][pAonaIns] == 0)
					{
						new str[128];
						format(str, sizeof(str), "Set Username\nPost Message");
						ShowPlayerDialog(playerid, TWITTER_MENU, DIALOG_STYLE_LIST, "Twitter Application", str, "Select", "No");
					}
					if(pData[playerid][pGpsIns] == 0 && pData[playerid][pTwtIns] == 1 && pData[playerid][pAonaIns] == 1)
					{
						new str[128];
						format(str, sizeof(str), "Set Username\nPost Message");
						ShowPlayerDialog(playerid, TWITTER_MENU, DIALOG_STYLE_LIST, "Twitter Application", str, "Select", "No");
					}
					if(pData[playerid][pGpsIns] == 1 && pData[playerid][pTwtIns] == 0 && pData[playerid][pAonaIns] == 1)
					{
						ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nPublic GPS\nPersonal GPS\nNearest GPS\nCity Hall\nDriving School\nBank Central\nValet Apartement\nJobs Location", "Select", "Close");
					}
					if(pData[playerid][pGpsIns] == 1 && pData[playerid][pTwtIns] == 1 && pData[playerid][pAonaIns] == 1)
					{
						ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nPublic GPS\nPersonal GPS\nNearest GPS\nCity Hall\nDriving School\nBank Central\nValet Apartement\nJobs Location", "Select", "Close");
					}
				}
				case 7:
				{
					ShowAdsLog(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_APPSTORE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pTwtIns] > 0)
						return Error(playerid, "You have twitter installed");

					if(pData[playerid][pPhoneCredit] <= 6) 
						return Error(playerid, "Phone Credit Not Enaugh!");

					SetTimerEx("DownloadTwitter", 10000, false, "i", playerid);
					GameTextForPlayer(playerid, "Downloading...", 10000, 4);
				}
				case 1:
				{
					if(pData[playerid][pGpsIns] > 0)
						return Error(playerid, "You have gps installed");

					if(pData[playerid][pPhoneCredit] <= 8) 
						return Error(playerid, "Phone Credit Not Enaugh!");

					SetTimerEx("DownloadGps", 10000, false, "i", playerid);
					GameTextForPlayer(playerid, "Downloading...", 10000, 4);
				}
				case 2:
				{
					if(pData[playerid][pAonaIns] > 0)
						return Error(playerid, "You have gps installed");

					if(pData[playerid][pPhoneCredit] <= 3) 
						return Error(playerid, "Phone Credit Not Enaugh!");

					SetTimerEx("DownloadAona", 10000, false, "i", playerid);
					GameTextForPlayer(playerid, "Downloading...", 10000, 4);
				}
			}
		}
		else
		{
			return callcmd::nonono(playerid, "");
		}
	}
	if(dialogid == DIALOG_MBANK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[200];
					format(str, sizeof(str), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"MBanking", str, "Close", "");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"MBanking", "Masukan jumlah uang:", "Transfer", "Cancel");
				}
				case 2:
				{
					DisplayPaycheck(playerid);
				}
			}
		}
		else
		{
			return callcmd::nonono(playerid, "");
		}
	}
	if(dialogid == MYTAX_MENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetBisnisPaytax(playerid) <= 0)
						return Error(playerid, "Kamu tidak memiliki bisnis.");

					new id, count = GetBisnisPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBisnisPaytaxID(playerid, itt);
						if(bData[id][bType] == 1)
						{
							type = "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type = "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type = "Clothes";
						}
						else if(bData[id][bType] == 4)
						{
							type = "Equipment";
						}
						else if(bData[id][bType] == 5)
						{
							type = "Gun Shop";
						}
						else if(bData[id][bType] == 6)
						{
							type = "Gym";
						}
						else
						{
							type = "Unknown";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), ReturnTimelapse(gettime(), bData[id][bVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), ReturnTimelapse(gettime(), bData[id][bVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS,"Business Tax",mission,"Close", "");
				}
				case 1:
				{
					if(GetHousesPaytax(playerid) <= 0)
						return Error(playerid, "Kamu tidak memiliki rumah.");

					new id, count = GetHousesPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnHousesPaytaxID(playerid, itt);
						if(hData[id][hType] == 1)
						{
							type = "Low";
						}
						else if(hData[id][hType] == 2)
						{
							type = "Medium";
						}
						else if(hData[id][hType] == 3)
						{
							type = "High";
						}
						else
						{
							type = "Unknown";
						}
	
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(hData[id][hExtposX], hData[id][hExtposY], hData[id][hExtposZ]), ReturnTimelapse(gettime(), hData[id][hVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(hData[id][hExtposX], hData[id][hExtposY], hData[id][hExtposZ]), ReturnTimelapse(gettime(), hData[id][hVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS,"Houses Tax",mission,"Close", "");
				}
				case 2:
				{
					if(GetDealerPaytax(playerid) <= 0)
						return Error(playerid, "Kamu tidak memiliki Dealer.");

					new id, count = GetDealerPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnDealerPaytaxID(playerid, itt);
						if(drData[id][dType] == 1)
						{
							type = "Bikes Vehicles";
						}
						else if(drData[id][dType] == 2)
						{
							type = "Cars";
						}
						else if(drData[id][dType] == 3)
						{
							type = "Unique Cars";
						}
						else if(drData[id][dType] == 4)
						{
							type = "Job Cars";
						}
						else if(drData[id][dType] == 5)
						{
							type = "Rental Jobs";
						}
	
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS,"Dealer Tax",mission,"Close", "");
				}
				case 3:
				{
					if(GetVendingPaytax(playerid) <= 0)
						return Error(playerid, "Kamu tidak memiliki Vending Machine.");

					new id, count = GetVendingPaytax(playerid), mission[2024], lstr[3024];
					
					strcat(mission,"ID\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnVendingPaytaxID(playerid, itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\n", id, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\n", id, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS,"Vending Tax",mission,"Select","Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_ADDCTRESPONSE)
	{
		if(!response)
			return 1;
		{
			ShowPlayerDialog(playerid, DIALOG_ADDCT, DIALOG_STYLE_INPUT, "Add Contact", "Masukkan nomor kontak baru yang ingin kamu tambahkan:", "Add", "No");
		}
	}
	if(dialogid == DIALOG_ADDCT)
	{
		if(Player_ContactCount(playerid) + 1 > 6)
			return Error(playerid, "Kamu tidak dapat menyimpan lebih dari 6 contact");

		if(response)
		{
			new number;
			if(sscanf(inputtext, "d", number))
            {
				new mstr[512];
				format(mstr,sizeof(mstr),"NOTE: Nomor Contact tidak di perbolehkan kosong!");
				ShowPlayerDialog(playerid, DIALOG_ADDCT, DIALOG_STYLE_INPUT,"Add Contact", mstr,"Change","Back");
			}
			else if(number < 1 || number > 999999)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),"NOTE: Nomor Contact harus 1 sampai 4 karakter.");
				ShowPlayerDialog(playerid, DIALOG_ADDCT, DIALOG_STYLE_INPUT,"Add Contact", mstr,"Change","Back");
			}
			else
			{
				AddPlayerContact(playerid, "No Name", number);
				Info(playerid, "Nomor Contact (%d) berhasil ditambahkan", number);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_EDITCTRESPONSE)
	{
		if(!response)
			return 1;
		{
			switch(listitem+1)
			{
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_ADDCT, DIALOG_STYLE_INPUT, "Add Contact", "Masukkan nomor kontak baru yang ingin kamu tambahkan:", "Add", "No");
				}
				case 2..50:
				{
					SetPVarInt(playerid, "ClickedContact", ReturnPlayerContactID(playerid, (listitem)));
					ShowPlayerDialog(playerid, DIALOG_EDITCTMENU, DIALOG_STYLE_LIST, "Contact Menu", "Edit Name\nEdit Number\nSMS Contact\nShare Lock\nDelete Contact", "Select", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_EDITCTMENU)
	{
		new dbid = GetPVarInt(playerid, "ClickedContact");
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE id='%d' ORDER BY id ASC LIMIT 30", dbid);
					mysql_query(g_SQL, query);
					new rows = cache_num_rows();

					if(rows)
					{
						new cname[40], string[1024];
						for(new i; i < rows; ++i)
					    {
							cache_get_value_name(i, "cname", cname);

							format(string, sizeof(string), "Contact Name: %s\ntulis nama baru yang ingin anda ubah untuk contact ini", cname);
						}
						ShowPlayerDialog(playerid, DIALOG_EDITNAMECT, DIALOG_STYLE_INPUT, "Edit Contact Name", string, "Yes", "No");
					}
				}
				case 1:
				{
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE id='%d' ORDER BY id ASC LIMIT 30", dbid);
					mysql_query(g_SQL, query);
					new rows = cache_num_rows();

					if(rows)
					{
						new cnumber, string[1024];
						for(new i; i < rows; ++i)
					    {
							cache_get_value_name_int(i, "cnumber", cnumber);
							
							format(string, sizeof(string), "Contact Number: %d\ntulis nomor baru yang ingin anda ubah untuk contact ini", cnumber);
						}
						ShowPlayerDialog(playerid, DIALOG_EDITNUMBERCT, DIALOG_STYLE_INPUT, "Edit Contact Number", string, "Yes", "No");
					}
				}
				/*case 2:
				{
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE id='%d' ORDER BY id ASC LIMIT 30", dbid);
					mysql_query(g_SQL, query);
					new rows = cache_num_rows();

					if(rows)
					{
						new cnumber;
						for(new i; i < rows; ++i)
					    {
							cache_get_value_name_int(i, "cnumber", cnumber);

							new ph = cnumber;
							if(GetSignalNearest(playerid) == 0)
								return Error(playerid, "Ponsel anda tidak mendapatkan sinyal di wilayah ini.");

							if(ph == pData[playerid][pPhone]) 
								return Error(playerid, "Nomor sedang sibuk!");

							foreach(new ii : Player)
							{
								if(pData[ii][pPhone] == ph)
								{
									if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) 
										return Error(playerid, "This number is not actived!");

									if(pData[ii][pUsePhone] == 0) 
										return Error(playerid, "Tidak dapat menelepon, Ponsel tersebut yang dituju sedang Offline");
									
									if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
										return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

									if(GetSignalNearest(ii) == 0)
										return Error(playerid, "Ponsel tersebut sedang mengalami gangguan sinyal.");

									if(pData[ii][pCall] == INVALID_PLAYER_ID)//telpn
									{
										pData[playerid][pCall] = ii;
										
										SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE to %d] "WHITE_E"phone begins to ring, please wait for answer!", ph);
										SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE form %d] "WHITE_E"Your phonecell is ringing, type '/p' to answer it!", pData[playerid][pPhone]);
										PlayerPlaySound(playerid, 3600, 0,0,0);
										PlayerPlaySound(ii, 6003, 0,0,0);
										SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
										SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
										return 1;
									}
									else
									{
										Error(playerid, "Nomor ini sedang sibuk.");
										return 1;
									}
								}
							}
						}
					}
				}*/
				case 2:
				{
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE id='%d' ORDER BY id ASC LIMIT 30", dbid);
					mysql_query(g_SQL, query);
					new rows = cache_num_rows();

					if(rows)
					{
						new cnumber, string[1024];
						for(new i; i < rows; ++i)
					    {
							cache_get_value_name_int(i, "cnumber", cnumber);
							format(string, sizeof(string), "SMS To: %d\n\nTulis pesan yang ingin kamu kirim ke nomor diatas", cnumber);
						}
						ShowPlayerDialog(playerid, DIALOG_SENDMSGCT, DIALOG_STYLE_INPUT, "SMS Contact", string, "Send", "Cancel");
					}
				}
				case 3:
				{
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE id='%d' ORDER BY id ASC LIMIT 30", dbid);
					mysql_query(g_SQL, query);
					new rows = cache_num_rows();

					if(rows)
					{
						new cnumber;
						for(new i; i < rows; ++i)
					    {
							cache_get_value_name_int(i, "cnumber", cnumber);

							new ph = cnumber;

							if(ph == pData[playerid][pPhone]) 
								return Error(playerid, "Nomor sedang sibuk!");

							foreach(new ii : Player)
							{
								if(pData[ii][pPhone] == ph)
								{
									if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) 
										return Error(playerid, "This number is not actived!");

									if(pData[ii][pUsePhone] == 0) 
										return Error(playerid, "Tidak dapat share loc, Ponsel tersebut yang dituju sedang Offline");
									
									if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
										return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

									if(pData[ii][pCall] == INVALID_PLAYER_ID)
									{
										PlayerPlaySound(playerid, 3600, 0,0,0);
										PlayerPlaySound(ii, 6003, 0,0,0);

										new Float:x, Float:y, Float:z;
										GetPlayerPos(playerid, x, y, z);
										SetPlayerRaceCheckpoint(ii, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);

										Info(ii, "%s telah memberikan keberadaan lokasinya kepadamu", ReturnName(playerid));
										Info(playerid, "Kamu telah memberikan lokasi mu kepada %s.", ReturnName(ii));
										return 1;
									}
									else
									{
										Error(playerid, "Nomor ini sedang sibuk.");
										return 1;
									}
								}
							}
						}
					}
				}
				case 4:
				{
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM phonebook WHERE id='%d'", dbid);
					mysql_query(g_SQL, query);

					Info(playerid, "Succes deleted contact in db: %d", dbid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PANELPHONE)
	{
		if (response)
		{
            switch (listitem)
			{
				case 0:
				{
				    new gstr[256];
				    format(gstr,sizeof(gstr),"{C6E2FF}iPhone 14 PRO milik %s\nNomor telepon: %d\nNama model: iPhone 14 PRO\nNomor serial: AS6R8127V1JKW\nIMEI (slot 1): 2374236342\nIMEI (slot 2): 8734563737", pData[playerid][pName], pData[playerid][pPhone]);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "HandPhone - TentangPonsel", gstr, "Tutup","");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_TOGGLEPHONE, DIALOG_STYLE_LIST, "Settings", "Nyalakan Handphone\nMatikan Handphone", "Select", "Back");
				}
			}
		}
	}
	if(dialogid == DIALOG_TOGGLEPHONE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pUsePhone] = 1;
					Servers(playerid, "Berhasil menyalakan Handphone");
					return 0;
				}
				case 1:
				{
					pData[playerid][pUsePhone] = 0;
					Servers(playerid, "Berhasil mematikan Handphone");
					return 0;
				}
			}
		}
	}
	if(dialogid == DIALOG_PHONE_DIALUMBER)
	{
		if (response)
		{
		    new
		        string[16];

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Kembali");

	        format(string, 16, "%d", strval(inputtext));
			callcmd::gencallvoice(playerid, string);
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_SENDMSGCT)
	{
		new dbid = GetPVarInt(playerid, "ClickedContact");

		if(pData[playerid][pPhone] == 0) 
		return ShowNotifError(playerid, "Kamu tidak memilik phone!", 10000);

		//if(Inventory_Count(playerid, "Phone") < 1)
			//return ShowNotifError(playerid, "Kamu tidak memilik phone!", 10000);

		if(pData[playerid][pPhoneCredit] <= 0) 
			return Error(playerid, "Anda tidak memiliki Ponsel credits!");

		if(pData[playerid][pInjured] != 0) 
			return Error(playerid, "You cant do at this time.");

		if(response)
		{
			if(isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),"NOTE: Pesan sms tidak boleh kosong!");
				ShowPlayerDialog(playerid, DIALOG_SENDMSGCT, DIALOG_STYLE_INPUT,"SMS Contact", mstr, "Send","Cancel");
				return 1;
			}
			if(strlen(inputtext) < 1 || strlen(inputtext) > 50)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),"NOTE: Pesan tidak boleh kurang dari 1 dan lebih dari 50 karakter!.");
				ShowPlayerDialog(playerid, DIALOG_SENDMSGCT, DIALOG_STYLE_INPUT,"SMS Contact", mstr, "Send","Cancel");
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE id='%d' ORDER BY id ASC LIMIT 30", dbid);
			mysql_query(g_SQL, query);
			new rows = cache_num_rows();

			if(rows)
			{
				new cnumber, ph;
				for(new i; i < rows; ++i)
			    {
					cache_get_value_name_int(i, "cnumber", cnumber);

					ph = cnumber;
					foreach(new ii : Player)
					{
						if(pData[ii][pPhone] == ph)
						{
							if(pData[ii][pUsePhone] == 0) 
								return Error(playerid, "Tidak dapat SMS, Ponsel tersebut yang dituju sedang Offline");

							if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
								return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

							if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");
							SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", ph, ColouredText(inputtext));
							SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], ColouredText(inputtext));
							Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
							PlayerPlaySound(ii, 6003, 0,0,0);
							pData[ii][pSMS] = pData[playerid][pPhone];
							
							pData[playerid][pPhoneCredit] -= 1;
							return 1;
						}
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_EDITNAMECT)
	{
		new dbid = GetPVarInt(playerid, "ClickedContact");
		if(response)
		{
			if(isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),"NOTE: Nama Contact tidak di perbolehkan kosong!");
				ShowPlayerDialog(playerid, DIALOG_EDITNAMECT, DIALOG_STYLE_INPUT,"Change Contact Name", mstr,"Change","Back");
				return 1;
			}
			if(strlen(inputtext) > 20 || strlen(inputtext) < 1)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),"NOTE: Nama Contact hanya bisa 1 sampai 20 karakter.");
				ShowPlayerDialog(playerid, DIALOG_EDITNAMECT, DIALOG_STYLE_INPUT,"Change Contact Name", mstr,"Change","Back");
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE phonebook SET cname='%s' WHERE id='%d'", ColouredText(inputtext), dbid);
			mysql_query(g_SQL, query);

			Info(playerid, "Nama contact berhasil diubah menjadi: %s", ColouredText(inputtext));
		}
		return 1;
	}
	if(dialogid == DIALOG_EDITNUMBERCT)
	{
		new dbid = GetPVarInt(playerid, "ClickedContact"), number, mstr[512];
		if(response)
		{
			if(sscanf(inputtext, "d", number))
            {
				format(mstr,sizeof(mstr),"NOTE: Nomor Contact tidak di perbolehkan kosong!");
				ShowPlayerDialog(playerid, DIALOG_EDITNUMBERCT, DIALOG_STYLE_INPUT,"Change Contact Name", mstr,"Change","Back");
			}
			else if(number < 0 || number > 999999)
			{
				format(mstr,sizeof(mstr),"NOTE: Nomor Contact harus 1 sampai 4 karakter.");
				ShowPlayerDialog(playerid, DIALOG_EDITNUMBERCT, DIALOG_STYLE_INPUT,"Change Contact Name", mstr,"Change","Back");
			}
			else
			{
				new query[512];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE phonebook SET cnumber='%d' WHERE id='%d'", strval(inputtext), dbid);
				mysql_query(g_SQL, query);

				Info(playerid, "Nomor contact berhasil diubah menjadi: %d", strval(inputtext));
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PVEHLOCKED)
	{
		if(response)
		{
			switch(listitem+1)
			{
				case 1:
				{
			    	static
			    	carid = -1;

			    	if((carid = Vehicle_Nearest(playerid)) != -1)
			    	{
			    		if(Vehicle_IsOwner(playerid, carid))
			    		{
			    			if(!pvData[carid][cLocked])
			    			{
			    				pvData[carid][cLocked] = 1;

			    				InfoTD_MSG(playerid, 4000, "Kendaraan ini berhasil ~r~Dikunci!");
			    				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengunci kendaraan %s", ReturnName(playerid), GetVehicleModelName(pvData[carid][cModel]));
			    				PlayAudioStreamForPlayer(playerid, "https://cdn.discordapp.com/attachments/955329178885042186/1052091263312216114/car-lock-sound-effect.mp3", 5.0, 5.0, 5.0, 5.0);

			    				SwitchVehicleDoors(pvData[carid][cVeh], true);
			    			}
			    			else
			    			{

			    				pvData[carid][cLocked] = 0;
			    				InfoTD_MSG(playerid, 4000, "Kendaraan ini berhasil ~g~Dibuka!");
			    				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s membuka kunci kendaraan %s", ReturnName(playerid), GetVehicleModelName(pvData[carid][cModel]));
			    				PlayAudioStreamForPlayer(playerid, "https://cdn.discordapp.com/attachments/955329178885042186/1052091263312216114/car-lock-sound-effect.mp3", 5.0, 5.0, 5.0, 5.0);

			    				SwitchVehicleDoors(pvData[carid][cVeh], false);
			    			}
			    		}
			    	}
			    	else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun yang ingin anda kunci.");
			    }
				case 2..50:
				{
					new vehid = ReturnPVehiclesLockID(playerid, (listitem));
					foreach(new ii : PVehicles)
					{
						if(pvData[vehid][cVeh] == pvData[ii][cVeh])
						{
							if(pvData[ii][cOwner] == pData[playerid][pID])
							{
								new Float:x, Float:y, Float:z;
								GetVehiclePos(pvData[ii][cVeh], x, y, z);
								
								if(!IsPlayerInRangeOfPoint(playerid, 6.0, x, y, z))
									return Error(playerid, "Kamu harus berjarak dekat dengan kendaraan tersebut");

								if(!pvData[ii][cLocked])
					    		{
						    		pvData[ii][cLocked] = 1;

					    			Info(playerid, "Kendaraan %s (ID: %d) berhasil "RED_E"Dikunci!", GetVehicleModelName(pvData[ii][cModel]), pvData[ii][cVeh]);
					    			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengunci kendaraan %s", ReturnName(playerid), GetVehicleModelName(pvData[ii][cModel]));
					    			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

					    			SwitchVehicleDoors(pvData[ii][cVeh], true);
				    			}
				    			else
				    			{
					    			pvData[ii][cLocked] = 0;

					    			Info(playerid, "Kendaraan %s (ID: %d) berhasil "GREEN_E"Dibuka!", GetVehicleModelName(pvData[ii][cModel]), pvData[ii][cVeh]);
					    			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s membuka kunci kendaraan %s", ReturnName(playerid), GetVehicleModelName(pvData[ii][cModel]));
					    			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

					    			SwitchVehicleDoors(pvData[ii][cVeh], false);
					    		}
							}							
							else return Error(playerid, "Kamu bukan pemilik kendaraan ini");
						}
					}
				}
			}
		}
	}
	if(dialogid == GARKOT_PICKUP)
	{
		if(response)
		{
			new i = ReturnPVehParkID(playerid, (listitem + 1));
			new gkid = pData[playerid][pGetPARKID];

			pvData[i][cParkid] = -1;
			pvData[i][cPosX] = gkData[gkid][sgkX];
			pvData[i][cPosY] = gkData[gkid][sgkY];
			pvData[i][cPosZ] = gkData[gkid][sgkZ];
			pvData[i][cPosA] = gkData[gkid][sgkA];

			
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			OnPlayerVehicleRespawn(i);
			SetPlayerArmedWeapon(playerid, 0);
			PutPlayerInVehicle(playerid, pvData[i][cVeh], 0);
			
			/*
			SetValidVehicleHealth(pvData[i][cVeh], 2500);
			SetVehiclePos(pvData[i][cVeh], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ] + 3.0);
			SetVehicleZAngle(pvData[i][cVeh], pvData[i][cPosA]);
			SetVehicleFuel(pvData[i][cVeh], 1000);
			*/

			Info(playerid, "Kendaraan %s milikmu telah di keluarkan dari park point id: %d.", GetVehicleModelName(pvData[i][cModel]), gkid);
		}
		return 1;
	}
	if(dialogid == DIALOG_TICKET)
	{
		if(!response)
			return 1;

		new vehid = GetPVarInt(playerid, "GiveTicketVehicle");

		foreach(new ii : PVehicles)
		{
			if(vehid == pvData[ii][cVeh])
			{
				if(pvData[ii][cTicket] >= 1)
					return Error(playerid, "Kendaraan ini sudah memiliki ticket tilang");

				pvData[ii][cTicket] = 1;
				Info(playerid, "Anda telah berhasil memberi tilang kendaraan %s (ID: %d)", GetVehicleModelName(pvData[ii][cModel]), pvData[ii][cVeh]);

				DeletePVar(playerid, "GiveTicketVehicle");
			}
		}
	}
	if(dialogid == DIALOG_CLEARTICKET)
	{
		if(!response)
			return 1;

		new vehid = GetPVarInt(playerid, "ClearVehTicket");

		foreach(new ii : PVehicles)
		{
			if(vehid == pvData[ii][cVeh])
			{
				if(pvData[ii][cTicket] <= 0)
					return Error(playerid, "Kendaraan ini tidak memiliki ticket tilang");

				pvData[ii][cTicket] = 0;
				Info(playerid, "Anda telah berhasil menghapus tilang kendaraan %s (ID: %d)", GetVehicleModelName(pvData[ii][cModel]), pvData[ii][cVeh]);

				DeletePVar(playerid, "ClearVehTicket");
			}
		}
	}
	if(dialogid == VEHICLE_INSURANCE)
	{
		if(!response) return 1;
		new vehid = ReturnPVehiclesInsuID(playerid, (listitem + 1));

		pvData[vehid][cClaim] = 0;
		pvData[vehid][cParkid] = -1;
		
		OnPlayerVehicleRespawn(vehid); //-64.5236,-1110.8503,0.7381,73.7670
		pvData[vehid][cPosX] = -64.5236;
		pvData[vehid][cPosY] = -1110.8503;
		pvData[vehid][cPosZ] = 0.7381;
		pvData[vehid][cPosA] = 73.7670;
		SetValidVehicleHealth(pvData[vehid][cVeh], 2500);
		PutPlayerInVehicle(playerid, pvData[vehid][cVeh], 0);
		SetVehiclePos(pvData[vehid][cVeh], -64.5236,-1110.8503,0.7381);
		SetVehicleZAngle(pvData[vehid][cVeh], 73.7670);
		SetVehicleFuel(pvData[vehid][cVeh], 100);
		//ShowItemBox(playerid, "Uang", "Removed_$500", 1212, 4);
		
		Info(playerid, "Anda telah mengclaim kendaraan %s anda.", GetVehicleModelName(pvData[vehid][cModel]));
		return 1;
	}
	if(dialogid == DIALOG_BOOMBOX)
	{
		new bbid = pData[playerid][pGetBOOMBOXID];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[254], hstr[254];
					format(hstr, sizeof(hstr), "Boombox URL (ID: %d)", bbid);
					format(str, sizeof(str), "Masukkan URL musik yang ingin kamu setel:");
					ShowPlayerDialog(playerid, DIALOG_BOOMBOX_URL, DIALOG_STYLE_INPUT, hstr, str, "Yes", "No");
				}
				case 1:
				{
					foreach(new i : Player)
					{
						if(IsPlayerInRangeOfPoint(i, 30.0, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]))
						{
							StopAudioStreamForPlayer(i);
						}
					}
					bbData[bbid][bbAreaid] = -1;
					Info(playerid, "Kamu telah mematikan boombox milikmu (Boombox ID: %d | Location: %s)", bbid, GetLocation(bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]));
					SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "** %s telah mematikan boombox miliknya", ReturnName(playerid));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BOOMBOX_URL)
	{
		new bbid = pData[playerid][pGetBOOMBOXID], str[254], hstr[254];
		if(response)
		{
			if(isnull(inputtext))
			{
				format(hstr, sizeof(hstr), "Boombox URL (ID: %d)", bbid);
				format(str, sizeof(str), "ERROR: Kotak penginputan URL tidak boleh kosong!");
				ShowPlayerDialog(playerid, DIALOG_BOOMBOX_URL, DIALOG_STYLE_INPUT, hstr, str, "Yes", "No");
			}
			if(strlen(inputtext) > 250)
			{
				format(hstr, sizeof(hstr), "Boombox URL (ID: %d)", bbid);
				format(str, sizeof(str), "ERROR: Panjang URL tidak boleh melebihi dari 128 character!");
				ShowPlayerDialog(playerid, DIALOG_BOOMBOX_URL, DIALOG_STYLE_INPUT, hstr, str, "Yes", "No");
			}

			format(bbData[bbid][bbUrl], 250, inputtext);
			foreach(new i : Player)
			{
				if(IsPlayerInRangeOfPoint(i, 30.0, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ]))
				{
					PlayAudioStreamForPlayer(i, inputtext, bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ], 30.0, 1);
				}
			}
		}
		return 1;
	}
	if(dialogid == TWITTER_MENU)
	{
		new str[524];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str), "Username mu sekarang: @%s\nMasukan nama twitter yang kamu inginkan:", pData[playerid][pTwittername]);
					ShowPlayerDialog(playerid, TWITTER_NAME, DIALOG_STYLE_INPUT, "Twitter Name", str, "Yes", "No");
				}
				case 1:
				{
					format(str, sizeof(str), "Masukan text postingan yang akan dikirim:");
					ShowPlayerDialog(playerid, TWITTER_POST, DIALOG_STYLE_INPUT, "Twitter Post", str, "Yes", "No");
				}
			}
		}
		return 1;
	}
	if(dialogid == TWITTER_NAME)
	{
		if(pData[playerid][pPhoneCredit] <= 0)
			return Error(playerid, "Kamu tidak memiliki phone credit!");
		
		if(response)
		{
			new str[254];
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "ERROR: Kotak penginputan tidak boleh kosong!\n\nUsername mu sekarang: @%s\nMasukan nama twitter yang kamu inginkan:", pData[playerid][pTwittername]);
				ShowPlayerDialog(playerid, TWITTER_NAME, DIALOG_STYLE_INPUT, "Twitter Name", str, "Yes", "No");
				return 1;
			}
			if(strlen(inputtext) > 15)
			{
				format(str, sizeof(str), "ERROR: Panjang text tidak boleh lebih dari 15 character!\n\nUsername mu sekarang: @%s\nMasukan nama twitter yang kamu inginkan:", pData[playerid][pTwittername]);
				ShowPlayerDialog(playerid, TWITTER_NAME, DIALOG_STYLE_INPUT, "Twitter Name", str, "Yes", "No");
				return 1;
			}

			pData[playerid][pPhoneCredit]--;
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM players WHERE twittername = '%s'", inputtext);
			mysql_tquery(g_SQL, query, "ChangeTwitterName", "ds", playerid, inputtext);
		}
		return 1;
	}
	if(dialogid == TWITTER_POST)
	{
		if(pData[playerid][pPhoneCredit] <= 0)
			return Error(playerid, "Kamu tidak memiliki phone credit!");

		if(response)
		{
			new str[128];
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "ERROR: Kotak penginputan tidak boleh kosong!\n\nMasukan text postingan yang akan dikirim:");
				ShowPlayerDialog(playerid, TWITTER_POST, DIALOG_STYLE_INPUT, "Twitter Post", str, "Yes", "No");
				return 1;
			}
			if(!strcmp(pData[playerid][pTwittername], "None"))
			{
				format(str, sizeof(str), "ERROR: Kamu belum mengatur username twitter mu!\n\nMasukan text postingan yang akan dikirim:");
				ShowPlayerDialog(playerid, TWITTER_POST, DIALOG_STYLE_INPUT, "Twitter Post", str, "Yes", "No");
				return 1;
			}
			if(strlen(inputtext) > 50)
			{
				format(str, sizeof(str), "ERROR: Panjang text tidak boleh lebih dari 50 character!\n\nMasukan text postingan yang akan dikirim:");
				ShowPlayerDialog(playerid, TWITTER_POST, DIALOG_STYLE_INPUT, "Twitter Post", str, "Yes", "No");
				return 1;
			}

			pData[playerid][pPhoneCredit]--;

			foreach(new i : Player)
			{
				if(IsPlayerConnected(i))
				{
					if(pData[i][pPhone] != 0 && pData[i][pUsePhone] != 0)
					{
						SendClientMessageEx(i, COLOR_WHITEP, ""LB_E"[TWITTER] @%s: %s", pData[playerid][pTwittername], inputtext);
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PAYTAX)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetBisnisPaytax(playerid) <= 0)
						return ShowNotifError(playerid, "Anda tidak memiliki bisnis!", 5000);

					new id, count = GetBisnisPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBisnisPaytaxID(playerid, itt);
						if(bData[id][bType] == 1)
						{
							type = "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type = "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type = "Clothes";
						}
						else if(bData[id][bType] == 4)
						{
							type = "Equipment";
						}
						else if(bData[id][bType] == 5)
						{
							type = "Gun Shop";
						}
						else if(bData[id][bType] == 6)
						{
							type = "Gym";
						}
						else
						{
							type = "Unknown";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), ReturnTimelapse(gettime(), bData[id][bVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), ReturnTimelapse(gettime(), bData[id][bVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_PAYTAX_BISNIS, DIALOG_STYLE_TABLIST_HEADERS,"Business Tax",mission,"Select","Cancel");
				}
				case 1:
				{
					if(GetHousesPaytax(playerid) <= 0)
						return ShowNotifError(playerid, "Anda tidak memiliki rumah!", 5000);

					new id, count = GetHousesPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnHousesPaytaxID(playerid, itt);
						if(hData[id][hType] == 1)
						{
							type = "Low";
						}
						else if(hData[id][hType] == 2)
						{
							type = "Medium";
						}
						else if(hData[id][hType] == 3)
						{
							type = "High";
						}
						else
						{
							type = "Unknown";
						}
	
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(hData[id][hExtposX], hData[id][hExtposY], hData[id][hExtposZ]), ReturnTimelapse(gettime(), hData[id][hVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(hData[id][hExtposX], hData[id][hExtposY], hData[id][hExtposZ]), ReturnTimelapse(gettime(), hData[id][hVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_PAYTAX_HOUSE, DIALOG_STYLE_TABLIST_HEADERS,"Houses Tax",mission,"Select","Cancel");
				}
				case 2:
				{
					if(GetDealerPaytax(playerid) <= 0)
						return ShowNotifError(playerid, "Anda tidak memiliki dealer!", 5000);

					new id, count = GetDealerPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnDealerPaytaxID(playerid, itt);
						if(drData[id][dType] == 1)
						{
							type = "Bikes Vehicles";
						}
						else if(drData[id][dType] == 2)
						{
							type = "Cars";
						}
						else if(drData[id][dType] == 3)
						{
							type = "Unique Cars";
						}
						else if(drData[id][dType] == 4)
						{
							type = "Job Cars";
						}
						else if(drData[id][dType] == 5)
						{
							type = "Rental Jobs";
						}
	
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_PAYTAX_DEALER, DIALOG_STYLE_TABLIST_HEADERS,"Dealer Tax",mission,"Select","Cancel");
				}
				case 3:
				{
					if(GetVendingPaytax(playerid) <= 0)
						return ShowNotifError(playerid, "Anda tidak memiliki vending machine!", 5000);

					new id, count = GetVendingPaytax(playerid), mission[2024], lstr[3024];
					
					strcat(mission,"ID\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnVendingPaytaxID(playerid, itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\n", id, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\n", id, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_PAYTAX_VENDING, DIALOG_STYLE_TABLIST_HEADERS,"Vending Tax",mission,"Select","Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PAYTAX_BISNIS)
	{
		if(response)
		{
			new id = ReturnBisnisPaytaxID(playerid, (listitem + 1));

			if(bData[id][bLocked] >= 2)
				return Error(playerid, "Kamu tidak dapat membayar pajak bisnis yang di segel pemerintah");
			
			if(bData[id][bVisit] > gettime() + (86400 * 7))
				return Error(playerid, "Kamu hanya bisa membayar pajak bisnis yang masa expired nya dibawah 7 hari");

			if(pData[playerid][pMoney] < 16000)
				return Error(playerid, "Kamu harus memiliki uang sejumlah $16.000"GREEN_E" "WHITE_E"untuk membayar pajak asset bisnismu");

			bData[id][bVisit] = gettime() + (86400 * 31);
			Bisnis_Refresh(id);
			Bisnis_Save(id);

			GivePlayerMoneyEx(playerid, -16000);
			Server_AddMoney(16000);
			Info(playerid, "Kamu telah membayar pajak bisnis %s (ID: %d) dengan harga "GREEN_E"$60.000 "WHITE_E"(/paytax untuk mengeceknya)", bData[id][bName], id);
		}
		return 1;
	}
	if(dialogid == DIALOG_PAYTAX_HOUSE)
	{
		if(response)
		{
			new id = ReturnHousesPaytaxID(playerid, (listitem + 1));

			if(hData[id][hVisit] > gettime() + (86400 * 7))
				return Error(playerid, "Kamu hanya bisa membayar pajak bisnis yang masa expired nya dibawah 7 hari");

			if(pData[playerid][pMoney] < 8000)
				return Error(playerid, "Kamu harus memiliki uang sejumlah $8.000"GREEN_E" "WHITE_E"untuk membayar pajak asset rumahnmu");

			hData[id][hVisit] = gettime() + (86400 * 31);
			House_Refresh(id);
			House_Save(id);

			GivePlayerMoneyEx(playerid, -8000);
			Server_AddMoney(8000);
			Info(playerid, "Kamu telah membayar pajak rumah %s (ID: %d) dengan harga "GREEN_E"$60.000 "WHITE_E"(/paytax untuk mengeceknya)", GetLocation(hData[id][hExtposX], hData[id][hExtposY], hData[id][hExtposZ]), id);
		}
		return 1;
	}
	if(dialogid == DIALOG_PAYTAX_DEALER)
	{
		if(response)
		{
			new id = ReturnDealerPaytaxID(playerid, (listitem + 1));

			if(drData[id][dVisit] > gettime() + (86400 * 7))
				return Error(playerid, "Kamu hanya bisa membayar pajak dealer yang masa expired nya dibawah 7 hari");

			if(pData[playerid][pMoney] < 25000)
				return Error(playerid, "Kamu harus memiliki uang sejumlah $25.000"GREEN_E" "WHITE_E"untuk membayar pajak asset dealer");

			drData[id][dVisit] = gettime() + (86400 * 31);
			Dealer_Refresh(id);
			Dealer_Save(id);

			GivePlayerMoneyEx(playerid, -25000);
			Server_AddMoney(25000);
			Info(playerid, "Kamu telah membayar pajak dealer %s (ID: %d) dengan harga "GREEN_E"$25.000 "WHITE_E"(/paytax untuk mengeceknya)", GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), id);
		}
		return 1;
	}
	if(dialogid == DIALOG_PAYTAX_VENDING)
	{
		if(response)
		{
			new id = ReturnVendingPaytaxID(playerid, (listitem + 1));

			if(vmData[id][venVisit] > gettime() + (86400 * 7))
				return Error(playerid, "Kamu hanya bisa membayar pajak vending yang masa expired nya dibawah 7 hari");

			if(pData[playerid][pMoney] < 20000)
				return Error(playerid, "Kamu harus memiliki uang sejumlah $20.000"GREEN_E" "WHITE_E"untuk membayar pajak asset vending");

			vmData[id][venVisit] = gettime() + (86400 * 31);
			Vending_Refresh(id);
			Vending_Save(id);

			GivePlayerMoneyEx(playerid, -20000);
			Server_AddMoney(20000);
			Info(playerid, "Kamu telah membayar pajak vending %s (ID: %d) dengan harga "GREEN_E"$50.000 "WHITE_E"(/paytax untuk mengeceknya)", GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), id);
		}
		return 1;
	}
	//--------------[ Vehicle Toy Dialog ]-------------
	if(dialogid == DIALOG_VTOY)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][pVtoySelect] = 0;

					new slotid = pData[playerid][pVtoySelect];
					if(vToys[vehicleid][0][vtModelid] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(Android/PC)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\n"dot"Testing(PC Only)",
						vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
						vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][pVtoySelect] = 1;

					new slotid = pData[playerid][pVtoySelect];
					if(vToys[vehicleid][1][vtModelid] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(Android/PC)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\n"dot"Testing(PC Only)",
						vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
						vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"GloryPeace:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][pVtoySelect] = 2;

					new slotid = pData[playerid][pVtoySelect];
					if(vToys[vehicleid][2][vtModelid] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(Android/PC)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\n"dot"Testing(PC Only)",
						vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
						vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"GloryPeace:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][pVtoySelect] = 3;

					new slotid = pData[playerid][pVtoySelect];
					if(vToys[vehicleid][3][vtModelid] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(Android/PC)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\n"dot"Testing(PC Only)",
						vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
						vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"GloryPeace:RP "WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 4:
				{
					foreach(new vehid : PVehicles)
					{
						if(vehicleid == pvData[vehid][cVeh])
						{
							MySQL_ResetVehicleToys(vehid);
						}
					}
					GameTextForPlayer(playerid, "~r~~h~All Toy Reseted!~y~!", 3000, 4);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VTOYEDIT)
	{
		new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];
		if(response)
		{
			switch(listitem)
			{
				case 0: // edit vehicle toys
				{
					for(new i = 0; i <= 18; i++)
					{
						TextDrawHideForPlayer(playerid, ModTD[i]);
						TextDrawShowForPlayer(playerid, ModTD[i]);
					}

					pData[playerid][pGetVTOYID] = vehicleid;

					SelectTextDraw(playerid, 0xFF4040AA);
					TogglePlayerControllable(playerid, 0);
					SwitchVehicleEngine(vehicleid, false);
					InfoTD_MSG(playerid, 4000, "~b~~h~You are now editing vehicle toy.");
				}
				case 1: // remove toy
				{
					if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
						DestroyObject(vToys[vehicleid][slotid][vtObj]);

					vToys[vehicleid][slotid][vtModelid] = 0;

					vToys[vehicleid][slotid][vtX] = 0.0;
					vToys[vehicleid][slotid][vtY] = 0.0;
					vToys[vehicleid][slotid][vtZ] = 0.0;

					vToys[vehicleid][slotid][vtRX] = 0.0;
					vToys[vehicleid][slotid][vtRY] = 0.0;
					vToys[vehicleid][slotid][vtRZ] = 0.0;

					MySQL_SaveVehicleToys(vehicleid);

					GameTextForPlayer(playerid, "~r~~h~Vehicle Toy Removed~y~!", 3000, 4);
					SetPVarInt(vehicleid, "UpdatedVtoy", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 2:	//share toy pos
				{
					SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[VTOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f",
					ReturnName(playerid), vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
					vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
				}
				case 3: //Pos X
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosX: %f\nInput new Toy PosX:(Float)", vToys[vehicleid][slotid][vtX]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSX, DIALOG_STYLE_INPUT, "Vehicle Toy PosX", mstr, "Edit", "Cancel");
				}
				case 4: //Pos Y
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosY: %f\nInput new Toy PosY:(Float)", vToys[vehicleid][slotid][vtY]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSY, DIALOG_STYLE_INPUT, "Vehicle Toy PosY", mstr, "Edit", "Cancel");
				}
				case 5: //Pos Z
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosZ: %f\nInput new Toy PosZ:(Float)", vToys[vehicleid][slotid][vtZ]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSZ, DIALOG_STYLE_INPUT, "Vehicle Toy PosZ", mstr, "Edit", "Cancel");
				}
				case 6: //Pos RX
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRX: %f\nInput new Toy PosRX:(Float)", vToys[vehicleid][slotid][vtRX]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSRX, DIALOG_STYLE_INPUT, "Vehicle Toy PosRX", mstr, "Edit", "Cancel");
				}
				case 7: //Pos RY
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRY: %f\nInput new Toy PosRY:(Float)", vToys[vehicleid][slotid][vtRY]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSRY, DIALOG_STYLE_INPUT, "Vehicle Toy PosRY", mstr, "Edit", "Cancel");
				}
				case 8: //Pos RZ
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", vToys[vehicleid][slotid][vtRZ]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSRZ, DIALOG_STYLE_INPUT, "Vehicle Toy PosRZ", mstr, "Edit", "Cancel");
				}
				case 9:
				{
					//Vehicle_ObjectEdit(playerid, vehicleid, slot);
                    EditDynamicObject(playerid, vToys[vehicleid][slotid][vtObj]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VTOYPOSX)
	{
		new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				posisi, 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtX] = posisi;
			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
			MySQL_SaveVehicleToys(vehicleid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
			vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSY)
	{
		new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				posisi, 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtY] = posisi;
			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
			MySQL_SaveVehicleToys(vehicleid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
			vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSZ)
	{
		new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				posisi, 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtZ] = posisi;
			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
			MySQL_SaveVehicleToys(vehicleid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
			vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSRX)
	{
		new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				posisi, 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtRX] = posisi;
			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
			MySQL_SaveVehicleToys(vehicleid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
			vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSRY)
	{
		new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				posisi, 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtRY] = posisi;
			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
			MySQL_SaveVehicleToys(vehicleid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
			vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSRZ)
	{
		new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				posisi);

			vToys[vehicleid][slotid][vtRZ] = posisi;
			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
			MySQL_SaveVehicleToys(vehicleid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vToys[vehicleid][slotid][vtX], vToys[vehicleid][slotid][vtY], vToys[vehicleid][slotid][vtZ],
			vToys[vehicleid][slotid][vtRX], vToys[vehicleid][slotid][vtRY], vToys[vehicleid][slotid][vtRZ]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Konoha:RP "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYBUY)
	{
		if(response)
		{
			new vehicleid = GetPlayerVehicleID(playerid);

			if(vToys[vehicleid][listitem][vtModelid] != 0)
				return Error(playerid, "Slot tersebut sudah terisi!");

			pData[playerid][pVtoySelect] = listitem;
			ShowModelSelectionMenu(playerid, vtoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
		}
		return 1;
	}
	if(dialogid == NPCFAM_MENU)
	{	
		new str[512], nfid = pData[playerid][pGetNPCFAMID], fid;

		fid = nfData[nfid][nfOwner];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str), "Withdraw Money\nDeposit Money");
					ShowPlayerDialog(playerid, NPCFAM_MONEY, DIALOG_STYLE_LIST, fData[fid][fName], str, "Select", "Cancel");
				}
				case 1:
				{
					if(nfData[nfid][nfType] == 1)
					{
						format(str, sizeof(str), "Withdraw Marijuana\nDeposit Marijuana");
						ShowPlayerDialog(playerid, NPCFAM_MARIJUANA, DIALOG_STYLE_LIST, fData[fid][fName], str, "Select", "Cancel");
					}
					if(nfData[nfid][nfType] == 2)
					{
						format(str, sizeof(str), "Withdraw Material\nDeposit Material");
						ShowPlayerDialog(playerid, NPCFAM_MATERIAL, DIALOG_STYLE_LIST, fData[fid][fName], str, "Select", "Cancel");
					}
				}
				case 2:
				{
					if(nfData[nfid][nfType] == 1)
					{
						format(str, sizeof(str), "Withdraw Cocaine\nDeposit Cocaine");
						ShowPlayerDialog(playerid, NPCFAM_COCAINE, DIALOG_STYLE_LIST, fData[fid][fName], str, "Select", "Cancel");
					}
					if(nfData[nfid][nfType] == 2)
					{
						Npcfam_ProductMenu(playerid, nfid);
					}
				}
				case 3:
				{
					format(str, sizeof(str), "Withdraw Meth\nDeposit Meth");
					ShowPlayerDialog(playerid, NPCFAM_METH, DIALOG_STYLE_LIST, fData[fid][fName], str, "Select", "Cancel");
				}
				case 4:
				{
					Npcfam_ProductMenu(playerid, nfid);
				}
			}
		}
		return 1;
	}
	if(dialogid == NPCFAM_MONEY)
	{
		new str[512], nfid = pData[playerid][pGetNPCFAMID], fid;

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str), "Money Vault: %s\n\nMasukan jumlah uang yang ingin kamu withdraw:", FormatMoney(nfData[nfid][nfMoney]));
					ShowPlayerDialog(playerid, NPCFAM_MONEY_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				}
				case 1:
				{
					format(str, sizeof(str), "Money Vault: %s\n\nMasukan jumlah uang yang ingin kamu depositkan:", FormatMoney(nfData[nfid][nfMoney]));
					ShowPlayerDialog(playerid, NPCFAM_MONEY_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == NPCFAM_MATERIAL)
	{
		new str[512], nfid = pData[playerid][pGetNPCFAMID], fid;

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str), "Material Vault: %d\n\nMasukan jumlah material yang ingin kamu withdraw:", nfData[nfid][nfMaterial]);
					ShowPlayerDialog(playerid, NPCFAM_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				}
				case 1:
				{
					format(str, sizeof(str), "Material Vault: %d\n\nMasukan jumlah material yang ingin kamu depositkan:", nfData[nfid][nfMaterial]);
					ShowPlayerDialog(playerid, NPCFAM_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == NPCFAM_MARIJUANA)
	{
		new str[512], nfid = pData[playerid][pGetNPCFAMID], fid;

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str), "Marijuana Vault: %d gram\n\nMasukan jumlah marijuana yang ingin kamu withdraw:", nfData[nfid][nfMarijuana]);
					ShowPlayerDialog(playerid, NPCFAM_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				}
				case 1:
				{
					format(str, sizeof(str), "Marijuana Vault: %d gram\n\nMasukan jumlah marijuana yang ingin kamu depositkan:", nfData[nfid][nfMarijuana]);
					ShowPlayerDialog(playerid, NPCFAM_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == NPCFAM_COCAINE)
	{
		new str[512], nfid = pData[playerid][pGetNPCFAMID], fid;

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str), "Cocaine Vault: %d gram\n\nMasukan jumlah cocaine yang ingin kamu withdraw:", nfData[nfid][nfCocaine]);
					ShowPlayerDialog(playerid, NPCFAM_COCAINE_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				}
				case 1:
				{
					format(str, sizeof(str), "Cocaine Vault: %d gram\n\nMasukan jumlah cocaine yang ingin kamu depositkan:", nfData[nfid][nfCocaine]);
					ShowPlayerDialog(playerid, NPCFAM_COCAINE_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == NPCFAM_METH)
	{
		new str[512], nfid = pData[playerid][pGetNPCFAMID], fid;

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str), "Meth Vault: %d gram\n\nMasukan jumlah meth yang ingin kamu withdraw:", nfData[nfid][nfMeth]);
					ShowPlayerDialog(playerid, NPCFAM_METH_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				}
				case 1:
				{
					format(str, sizeof(str), "Meth Vault: %d gram\n\nMasukan jumlah meth yang ingin kamu depositkan:", nfData[nfid][nfMeth]);
					ShowPlayerDialog(playerid, NPCFAM_METH_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == NPCFAM_MONEY_WITHDRAW)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Money Vault: %s\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah uang yang ingin kamu withdraw:", FormatMoney(nfData[nfid][nfMoney]));
				ShowPlayerDialog(playerid, NPCFAM_MONEY_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > nfData[nfid][nfMoney])
			{
				format(str, sizeof(str), "Money Vault: %s\n\nERROR: Uang didalam vault tidak mencukupi!\nMasukan jumlah uang yang ingin kamu withdraw:", FormatMoney(nfData[nfid][nfMoney]));
				ShowPlayerDialog(playerid, NPCFAM_MONEY_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}

			GivePlayerMoneyEx(playerid, ammount);
			nfData[nfid][nfMoney] -= ammount;
			Npcfam_Save(nfid);

			Info(playerid, "Kamu berhasil menwithdraw %s dari dalam vault NPCFAMID: %d", FormatMoney(ammount), nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_MONEY_DEPOSIT)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Money Vault: %s\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah uang yang ingin kamu deposit:", FormatMoney(nfData[nfid][nfMoney]));
				ShowPlayerDialog(playerid, NPCFAM_MONEY_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > pData[playerid][pMoney])
			{
				format(str, sizeof(str), "Money Vault: %s\n\nERROR: Uang ditanganmu tidak mencukupi!\nMasukan jumlah uang yang ingin kamu deposit:", FormatMoney(nfData[nfid][nfMoney]));
				ShowPlayerDialog(playerid, NPCFAM_MONEY_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}

			GivePlayerMoneyEx(playerid, -ammount);
			nfData[nfid][nfMoney] += ammount;
			Npcfam_Save(nfid);
			
			Info(playerid, "Kamu berhasil mendepositkan %s kedalam vault NPCFAMID: %d", FormatMoney(ammount), nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_MATERIAL_WITHDRAW)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Material Vault: %d\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah material yang ingin kamu withdraw:", nfData[nfid][nfMaterial]);
				ShowPlayerDialog(playerid, NPCFAM_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > nfData[nfid][nfMaterial])
			{
				format(str, sizeof(str), "Material Vault: %d\n\nERROR: Material didalam vault tidak mencukupi!\nMasukan jumlah material yang ingin kamu withdraw:", nfData[nfid][nfMaterial]);
				ShowPlayerDialog(playerid, NPCFAM_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}

			pData[playerid][pMaterial] += ammount;
			nfData[nfid][nfMaterial] -= ammount;
			Npcfam_Save(nfid);

			Info(playerid, "Kamu berhasil menwithdraw %d material dari dalam vault NPCFAMID: %d", ammount, nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_MATERIAL_DEPOSIT)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Material Vault: %d\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah material yang ingin kamu deposit:", nfData[nfid][nfMaterial]);
				ShowPlayerDialog(playerid, NPCFAM_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > pData[playerid][pMaterial])
			{
				format(str, sizeof(str), "Material Vault: %d\n\nERROR: Material ditanganmu tidak mencukupi!\nMasukan jumlah material yang ingin kamu deposit:", nfData[nfid][nfMaterial]);
				ShowPlayerDialog(playerid, NPCFAM_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}

			pData[playerid][pMaterial] -= ammount;
			nfData[nfid][nfMaterial] += ammount;
			Npcfam_Save(nfid);
			
			Info(playerid, "Kamu berhasil mendepositkan %d material kedalam vault NPCFAMID: %d", ammount, nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_MARIJUANA_WITHDRAW)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Marijuana Vault: %d gram\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah marijuana yang ingin kamu withdraw:", nfData[nfid][nfMarijuana]);
				ShowPlayerDialog(playerid, NPCFAM_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > nfData[nfid][nfMarijuana])
			{
				format(str, sizeof(str), "Marijuana Vault: %d gram\n\nERROR: Marijuana didalam vault tidak mencukupi!\nMasukan jumlah marijuana yang ingin kamu withdraw:", nfData[nfid][nfMarijuana]);
				ShowPlayerDialog(playerid, NPCFAM_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}

			pData[playerid][pMarijuana] += ammount;
			nfData[nfid][nfMarijuana] -= ammount;
			Npcfam_Save(nfid);

			Info(playerid, "Kamu berhasil menwithdraw %d gram marijuana dari dalam vault NPCFAMID: %d", ammount, nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_MARIJUANA_DEPOSIT)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Marijuana Vault: %d gram\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah marijuana yang ingin kamu deposit:", nfData[nfid][nfMarijuana]);
				ShowPlayerDialog(playerid, NPCFAM_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > pData[playerid][pMarijuana])
			{
				format(str, sizeof(str), "Marijuana Vault: %d gram\n\nERROR: Marijuana ditanganmu tidak mencukupi!\nMasukan jumlah marijuana yang ingin kamu deposit:", nfData[nfid][nfMarijuana]);
				ShowPlayerDialog(playerid, NPCFAM_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}

			pData[playerid][pMarijuana] -= ammount;
			nfData[nfid][nfMarijuana] += ammount;
			Npcfam_Save(nfid);
			
			Info(playerid, "Kamu berhasil mendepositkan %d gram kedalam vault NPCFAMID: %d", ammount, nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_COCAINE_WITHDRAW)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Cocaine Vault: %d gram\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah cocaine yang ingin kamu withdraw:", nfData[nfid][nfCocaine]);
				ShowPlayerDialog(playerid, NPCFAM_COCAINE_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > nfData[nfid][nfMarijuana])
			{
				format(str, sizeof(str), "Cocaine Vault: %d gram\n\nERROR: Cocaine didalam vault tidak mencukupi!\nMasukan jumlah cocaine yang ingin kamu withdraw:", nfData[nfid][nfCocaine]);
				ShowPlayerDialog(playerid, NPCFAM_COCAINE_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}

			pData[playerid][pCocaine] += ammount;
			nfData[nfid][nfCocaine] -= ammount;
			Npcfam_Save(nfid);

			Info(playerid, "Kamu berhasil menwithdraw %d gram cocaine dari dalam vault NPCFAMID: %d", ammount, nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_COCAINE_DEPOSIT)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Cocaine Vault: %d gram\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah marijuana yang ingin kamu deposit:", nfData[nfid][nfCocaine]);
				ShowPlayerDialog(playerid, NPCFAM_COCAINE_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > pData[playerid][pCocaine])
			{
				format(str, sizeof(str), "Cocaine Vault: %d gram\n\nERROR: Marijuana ditanganmu tidak mencukupi!\nMasukan jumlah marijuana yang ingin kamu deposit:", nfData[nfid][nfCocaine]);
				ShowPlayerDialog(playerid, NPCFAM_COCAINE_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}

			pData[playerid][pCocaine] -= ammount;
			nfData[nfid][nfCocaine] += ammount;
			Npcfam_Save(nfid);
			
			Info(playerid, "Kamu berhasil mendepositkan %d gram cocaine kedalam vault NPCFAMID: %d", ammount, nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_METH_WITHDRAW)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Meth Vault: %d gram\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah meth yang ingin kamu withdraw:", nfData[nfid][nfMeth]);
				ShowPlayerDialog(playerid, NPCFAM_METH_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > nfData[nfid][nfMeth])
			{
				format(str, sizeof(str), "Meth Vault: %d gram\n\nERROR: Meth didalam vault tidak mencukupi!\nMasukan jumlah meth yang ingin kamu withdraw:", nfData[nfid][nfMeth]);
				ShowPlayerDialog(playerid, NPCFAM_METH_WITHDRAW, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Withdraw", "Cancel");
				return 1;
			}

			pData[playerid][pMeth] += ammount;
			nfData[nfid][nfMeth] -= ammount;
			Npcfam_Save(nfid);

			Info(playerid, "Kamu berhasil menwithdraw %d gram meth dari dalam vault NPCFAMID: %d", ammount, nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_METH_DEPOSIT)
	{
		new str[1024], nfid = pData[playerid][pGetNPCFAMID], fid, ammount = strval(inputtext);

		fid = nfData[nfid][nfOwner];

		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "Meth Vault: %d gram\n\nERROR: Kotak penginputan tidak boleh kosong!\nMasukan jumlah meth yang ingin kamu deposit:", nfData[nfid][nfMeth]);
				ShowPlayerDialog(playerid, NPCFAM_METH_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}
			if(ammount < 1 || ammount > pData[playerid][pMeth])
			{
				format(str, sizeof(str), "Meth Vault: %d gram\n\nERROR: Meth ditanganmu tidak mencukupi!\nMasukan jumlah meth yang ingin kamu deposit:", nfData[nfid][nfMeth]);
				ShowPlayerDialog(playerid, NPCFAM_METH_DEPOSIT, DIALOG_STYLE_INPUT, fData[fid][fName], str, "Deposit", "Cancel");
				return 1;
			}

			pData[playerid][pMeth] -= ammount;
			nfData[nfid][nfMeth] += ammount;
			Npcfam_Save(nfid);
			
			Info(playerid, "Kamu berhasil mendepositkan %d gram meth kedalam vault NPCFAMID: %d", ammount, nfid);
		}
		return 1;
	}
	if(dialogid == NPCFAM_EDITPROD)
	{
		new nfid = pData[playerid][pGetNPCFAMID];

		if(pData[playerid][pFamily] != nfData[nfid][nfOwner])
			return PermissionError(playerid);

		if(pData[playerid][pFamilyRank] < 4)
			return Error(playerid, "Hany rank 5-6 yang bisa mengakses ini");

		if(response)
		{
			static
				item[40],
				str[128];

			strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
			strpack(pData[playerid][pEditingItem], item, 40 char);

			pData[playerid][pProductModify] = listitem;
			format(str,sizeof(str), "Please enter the new product price for %s:", item);
			ShowPlayerDialog(playerid, NPCFAM_PRICESET, DIALOG_STYLE_INPUT, "NPC Family: Set Price", str, "Modify", "Back");
		}
		else return callcmd::npcfam(playerid, "menu");
		return 1;
	}
	if(dialogid == NPCFAM_PRICESET)
    {
        static
        	item[40];

        new nfid = pData[playerid][pGetNPCFAMID];

		if(pData[playerid][pFamily] != nfData[nfid][nfOwner])
			return PermissionError(playerid);

		if(pData[playerid][pFamilyRank] < 4)
			return Error(playerid, "Hany rank 5-6 yang bisa mengakses ini");

        if(response)
        {
            strunpack(item, pData[playerid][pEditingItem]);
            if(isnull(inputtext))
            {
                new str[128];
                format(str,sizeof(str), "Please enter the new product price for %s:", item);
                ShowPlayerDialog(playerid, NPCFAM_PRICESET, DIALOG_STYLE_INPUT, "NPC Familiy: Set Price", str, "Set", "Back");
                return 1;
            }
            if(strval(inputtext) < 0 || strval(inputtext) > 2500000)
            {
                new str[128];
                format(str,sizeof(str), "Please enter the new product price for %s ($0 to $2.500,000):", item);
                ShowPlayerDialog(playerid, NPCFAM_PRICESET, DIALOG_STYLE_INPUT, "NPC Familiy: Set Price", str, "Set", "Back");
                return 1;
            }

            nfData[nfid][nfPrice][pData[playerid][pProductModify]] = strval(inputtext);
            Npcfam_Save(nfid);

            Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
            Npcfam_ProductMenu(playerid, nfid);
        }
        else
        {
            Npcfam_ProductMenu(playerid, nfid);
        }
        return 1;
    }
    if(dialogid == NPCFAM_BUYPROD)
	{
		static
        nfid = -1,
        price;

		if((nfid = pData[playerid][pGetNPCFAMID]) != -1 && response)
		{
			price = nfData[nfid][nfPrice][listitem];

			if(listitem != 0 && price <= 0)
				return Error(playerid, "Harga product ini belum di set oleh pemiliknya");
			
			if(pData[playerid][pMoney] < price)
				return Error(playerid, "Not enough money!");

			if(nfData[nfid][nfType] == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						if(nfData[nfid][nfMarijuana] <= 0)
							return Error(playerid, "Stock marijuana tidak mencukupi!");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMarijuana]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 1gram Marijuana dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfMarijuana]--;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
					case 1:
					{
						if(nfData[nfid][nfCocaine] <= 0)
							return Error(playerid, "Stock marijuana tidak mencukupi!");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pCocaine]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 1gram Cocaine dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfCocaine]--;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
					case 2:
					{
						if(nfData[nfid][nfMeth] <= 0)
							return Error(playerid, "Stock marijuana tidak mencukupi!");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMeth]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 1gram Meth dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfMeth]--;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
				}
			}
			else if(nfData[nfid][nfType] == 2)
			{
				switch(listitem)
				{
					case 0:
					{
						if(nfData[nfid][nfMaterial] < 250)
							return Error(playerid, "Stock material tidak mencukupi");

						if(PlayerHasWeapon(playerid, 22))
							return Error(playerid, "Kamu sudah memiliki senjata tersebut");

						GivePlayerMoneyEx(playerid, -price); //250
						GivePlayerWeaponEx(playerid, 22, 70);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli senjata Colt45 dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfMaterial] -= 250;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
					case 1:
					{
						if(nfData[nfid][nfMaterial] < 500)
							return Error(playerid, "Stock material tidak mencukupi");

						if(PlayerHasWeapon(playerid, 24))
							return Error(playerid, "Kamu sudah memiliki senjata tersebut");

						GivePlayerMoneyEx(playerid, -price); //500
						GivePlayerWeaponEx(playerid, 24, 34);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli senjata Desert Eagle dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfMaterial] -= 500;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
					case 2:
					{
						if(nfData[nfid][nfMaterial] < 400)
							return Error(playerid, "Stock material tidak mencukupi");

						if(PlayerHasWeapon(playerid, 25))
							return Error(playerid, "Kamu sudah memiliki senjata tersebut");

						GivePlayerMoneyEx(playerid, -price); //400
						GivePlayerWeaponEx(playerid, 25, 20);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli senjata Shotgun dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfMaterial] -= 400;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
					case 3:
					{
						if(nfData[nfid][nfMaterial] < 750)
							return Error(playerid, "Stock material tidak mencukupi");

						if(PlayerHasWeapon(playerid, 30))
							return Error(playerid, "Kamu sudah memiliki senjata tersebut");

						GivePlayerMoneyEx(playerid, -price); //750
						GivePlayerWeaponEx(playerid, 30, 200);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli senjata AK-47 dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfMaterial] -= 750;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
					case 4:
					{
						if(nfData[nfid][nfMaterial] < 500)
							return Error(playerid, "Stock material tidak mencukupi");

						if(PlayerHasWeapon(playerid, 28))
							return Error(playerid, "Kamu sudah memiliki senjata tersebut");

						GivePlayerMoneyEx(playerid, -price); //500
						GivePlayerWeaponEx(playerid, 28, 200);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli senjata Micro SMG/Uzi dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfMaterial] -= 500;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
					case 5:
					{
						if(nfData[nfid][nfMaterial] < 500)
							return Error(playerid, "Stock material tidak mencukupi");

						GivePlayerMoneyEx(playerid, -price); //500
						pData[playerid][pBomb]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli senjata Patched Bomb dengan harga %s.", ReturnName(playerid), FormatMoney(price));
						nfData[nfid][nfMaterial] -= 500;
						nfData[nfid][nfMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Npcfam_Save(nfid);
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == PMDC_MENU)
	{
		new str[254];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
					format(str, sizeof(str), "Masukan nomor plat kendaraan yang ingin kamu cari:");
					ShowPlayerDialog(playerid, MDC_VEHICLE, DIALOG_STYLE_INPUT, "MDC Menu (Vehicle)", str, "Yes", "No");
				}
				case 1:
				{
					PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
					format(str, sizeof(str), "Masukan nama pemilik bisnis:");
					ShowPlayerDialog(playerid, MDC_BISNIS, DIALOG_STYLE_INPUT, "MDC Menu (Bisnis)", str, "Yes", "No");
				}
				case 2:
				{
					PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
					format(str, sizeof(str), "Masukan nama pemiliik rumah:");
					ShowPlayerDialog(playerid, MDC_HOUSE, DIALOG_STYLE_INPUT, "MDC Menu (House)", str, "Yes", "No");
				}
				case 3:
				{
					PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
					format(str, sizeof(str), "Masukan Nomor Handphone:");
					ShowPlayerDialog(playerid, MDC_PHONE, DIALOG_STYLE_INPUT, "MDC Menu (Phone Track)", str, "Yes", "No");
				}
				case 4:
				{
					PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
					callcmd::flare(playerid, "");
				}
				case 5:
				{
					PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
        			ShowEmergency(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == EMDC_MENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
        			ShowEmergency(playerid);
				}
			}
		}
	}
	if(dialogid == MDC_VEHICLE)
	{
		new str[254], count = 0;
		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "ERROR: Kotak penginputan tidak boleh kosong!\n\nMasukan nomor plat kendaraan yang ingin kamu cari:");
				ShowPlayerDialog(playerid, MDC_VEHICLE, DIALOG_STYLE_INPUT, "MDC Menu (Vehicle)", str, "Yes", "No");
				return 1;
			}
			if(strlen(inputtext) > 20)
			{
				format(str, sizeof(str), "ERROR: Tidak boleh lebih dari 20 character!\n\nMasukan nomor plat kendaraan yang ingin kamu cari:");
				ShowPlayerDialog(playerid, MDC_VEHICLE, DIALOG_STYLE_INPUT, "MDC Menu (Vehicle)", str, "Yes", "No");
				return 1;
			}
			format(pData[playerid][pTargetMDC], MAX_PLAYER_NAME, inputtext);
			foreach(new i : PVehicles)
			{
				if(IsValidVehicle(pvData[i][cVeh]))
				{
					if(!strcmp(pvData[i][cPlate], pData[playerid][pTargetMDC]))
					{
						count++;
						format(str, sizeof(str), "%s%s (ID: %d)\n", str, GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh]);
					}
					ShowPlayerDialog(playerid, MDC_VEHICLE_MENU, DIALOG_STYLE_LIST, "MDC Menu (Vehicle)", str, "Select", "Cancel");
				}
			}

			if(count <= 0)
			{
				format(str, sizeof(str), "ERROR: Tidak dapat menemukan kendaraan dengan plat nomor (%s)\n\nMasukan nomor plat kendaraan yang ingin kamu cari:", pData[playerid][pTargetMDC]);
				ShowPlayerDialog(playerid, MDC_VEHICLE_MENU, DIALOG_STYLE_INPUT, "MDC Menu (Vehicle)", str, "Yes", "No");
			}
		}
		return 1;
	}
	if(dialogid == MDC_BISNIS)
	{
		new str[254], count = 0;
		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "ERROR: Kotak penginputan tidak boleh kosong!\n\nMasukan nama pemilik bisnis:");
				ShowPlayerDialog(playerid, MDC_BISNIS, DIALOG_STYLE_INPUT, "MDC Menu (Bisnis)", str, "Yes", "No");
				return 1;
			}
			if(strlen(inputtext) > 20)
			{
				format(str, sizeof(str), "ERROR: Tidak boleh lebih dari 20 character!\n\nMasukan nama pemilik bisnis:");
				ShowPlayerDialog(playerid, MDC_BISNIS, DIALOG_STYLE_INPUT, "MDC Menu (Bisnis)", str, "Yes", "No");
				return 1;
			}

			format(pData[playerid][pTargetMDC], MAX_PLAYER_NAME, inputtext);
			for(new i = 0; i < MAX_BISNIS; i++)
			{
				if(Iter_Contains(Bisnis, i))
				{
					if(!strcmp(bData[i][bOwner], pData[playerid][pTargetMDC]))
					{
						count++;
						format(str, sizeof(str), "%s%s (ID: %d)\n", str, bData[i][bName], i);
					}
					ShowPlayerDialog(playerid, MDC_BISNIS_MENU, DIALOG_STYLE_LIST, "MDC Menu (Bisnis)", str, "Select", "Cancel");
				}
			}

			if(count <= 0)
			{
				format(str, sizeof(str), "ERROR: Tidak dapat menemukan bisnis dengan pemilik (%s)\n\nMasukan nama pemilik bisnis:", pData[playerid][pTargetMDC]);
				ShowPlayerDialog(playerid, MDC_VEHICLE_MENU, DIALOG_STYLE_INPUT, "MDC Menu (Bisnis)", str, "Yes", "No");
			}
		}
		return 1;
	}
	if(dialogid == MDC_HOUSE)
	{
		new str[254], count = 0;
		if(response)
		{
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "ERROR: Kotak penginputan tidak boleh kosong!\n\nMasukan nama pemilik rumah:");
				ShowPlayerDialog(playerid, MDC_HOUSE, DIALOG_STYLE_INPUT, "MDC Menu (House)", str, "Yes", "No");
				return 1;
			}
			if(strlen(inputtext) > 25)
			{
				format(str, sizeof(str), "ERROR: Tidak boleh lebih dari 25 character!\n\nMasukan nama pemilik rumah:");
				ShowPlayerDialog(playerid, MDC_HOUSE, DIALOG_STYLE_INPUT, "MDC Menu (House)", str, "Yes", "No");
				return 1;
			}

			format(pData[playerid][pTargetMDC], MAX_PLAYER_NAME, inputtext);
			for(new i = 0; i < MAX_HOUSES; i++)
			{
				if(Iter_Contains(Houses, i))
				{
					if(!strcmp(hData[i][hOwner], pData[playerid][pTargetMDC]))
					{
						count++;
						format(str, sizeof(str), "%sHouse (ID: %d)\n", str, i);
					}
					ShowPlayerDialog(playerid, MDC_HOUSE_MENU, DIALOG_STYLE_LIST, "MDC Menu (House)", str, "Select", "Cancel");
				}
			}

			if(count <= 0)
			{
				format(str, sizeof(str), "ERROR:\nTidak dapat menemukan rumah dengan pemilik (%s)\n\nMasukan nama pemilik rumah:", pData[playerid][pTargetMDC]);
				ShowPlayerDialog(playerid, MDC_HOUSE, DIALOG_STYLE_INPUT, "MDC Menu (House)", str, "Yes", "No");
			}
		}
		if(dialogid == MDC_PHONE)
		{
			new ph = floatround(strval(inputtext));
			if(response)
			{
				if(isnull(inputtext))
				{
					format(str, sizeof(str), "ERROR: Kotak penginputan tidak boleh kosong!\n\nMasukan Nomor Handphone:");
					ShowPlayerDialog(playerid, MDC_HOUSE, DIALOG_STYLE_INPUT, "MDC Menu (Phone Track)", str, "Yes", "No");
					return 1;
				}
				foreach(new ii : Player)
				{
					if(pData[ii][pPhone] == ph)
					{
						if(pData[ii][pUsePhone] == 0) return Error(playerid, "Ponsel tersebut yang dituju sedang Offline");
						if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880)) return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");
						if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");

						Info(playerid, "Kamu mencoba Mencari pemilik Handphone.", 8000);
						pData[playerid][pLoading] = true;
						pData[playerid][pActivityTime] = SetTimerEx("TrackPh", 1000, true, "id", playerid);
						//Showbar(playerid, 20, "SEARCHING", "TrackPh");
						ShowProgressbar(playerid, "SEARCHING", 20);
					}
				}
			}
			return 1;
		}
	}
	if(dialogid == MDC_VEHICLE_MENU)
	{
		if(response)
		{
			new str[128];
			SetPVarInt(playerid, "MdcVehicleID", ReturnMdcVehicleID(playerid, (listitem+1)));
			format(str, sizeof(str), "Show Information\nTrack Vehicle");
			ShowPlayerDialog(playerid, MDC_VEHICLE_TRACK, DIALOG_STYLE_LIST, "MDC Menu (Vehicle)", str, "Select", "Cancel");
		}
		return 1;
	}
	if(dialogid == MDC_BISNIS_MENU)
	{
		if(response)
		{
			new str[254];
			SetPVarInt(playerid, "MdcBisnisID", ReturnMdcBisnisID(playerid, (listitem+1)));
			format(str, sizeof(str), "Show Information\nTrack Bisnis");
			ShowPlayerDialog(playerid, MDC_BISNIS_TRACK, DIALOG_STYLE_LIST, "MDC Menu (Bisnis)", str, "Select", "Cancel");
		}
		return 1;
	}
	if(dialogid == MDC_HOUSE_MENU)
	{
		if(response)
		{
			new str[128];
			SetPVarInt(playerid, "MdcHouseID", ReturnMdcHouseID(playerid, (listitem+1)));
			format(str, sizeof(str), "Show Information\nTrack House");
			ShowPlayerDialog(playerid, MDC_HOUSE_TRACK, DIALOG_STYLE_LIST, "MDC Menu (House)", str, "Select", "Cancel");
		}
		return 1;
	}
	if(dialogid == MDC_VEHICLE_TRACK)
	{
		new vehid = GetPVarInt(playerid, "MdcVehicleID"), str[254];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					format(str, sizeof(str),"Vehicle ID: %d\nVehicle Model: %s\nVehicle Plate: %s", pvData[vehid][cVeh], GetVehicleModelName(pvData[vehid][cModel]), pvData[vehid][cPlate]);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "MDC Menu (Vehicle)", str, "Close", "");
					DeletePVar(playerid, "MdcVehicleID");
				}
				case 1:
				{
					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);

					new Float:x, Float:y, Float:z;
					GetVehiclePos(pvData[vehid][cVeh], x, y, z);
					SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Kendaraan %s (ID: %d) yang berlokasi di %s telah ditandai!", GetVehicleModelName(pvData[vehid][cModel]), pvData[vehid][cVeh], GetLocation(x, y, z));
					DeletePVar(playerid, "MdcVehicleID");
				}
			}
		}
		return 1;
	}
	if(dialogid == MDC_BISNIS_TRACK)
	{
		new bid = GetPVarInt(playerid, "MdcBisnisID"), str[254];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new btype[128];
					if(bData[bid][bType] == 1)
					{
						btype = "Fast Food";
					}
					else if(bData[bid][bType] == 2)
					{
						btype = "Market";
					}
					else if(bData[bid][bType] == 3)
					{
						btype = "Clothes";
					}
					else if(bData[bid][bType] == 4)
					{
						btype = "Equipment";
					}
					else if(bData[bid][bType] == 5)
					{
						btype = "Gun Shop";
					}
					else
					{
						btype = "None";
					}
					format(str, sizeof(str), "Bisnis ID: %d\nBisnis Owner: %s\nBisnis Type: %s\nBisnis Location: %s", bid, bData[bid][bOwner], btype, GetLocation(bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "MDC Menu (Bisnis)", str, "Close", "");
					DeletePVar(playerid, "MdcBisnisID");
				}
				case 1:
				{
					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Bisnis (ID: %d) milik %s yang berlokasi di %s telah ditandai", bid, bData[bid][bOwner], GetLocation(bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]));
					DeletePVar(playerid, "MdcBisnisID");
				}
			}
		}
		return 1;
	}
	if(dialogid == MDC_HOUSE_TRACK)
	{
		new hid = GetPVarInt(playerid, "MdcHouseID"), str[254];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new htype[128];
					if(hData[hid][hType] == 1)
					{
						htype = "Small";
					}
					else if(hData[hid][hType] == 2)
					{
						htype = "Medium";
					}
					else if(hData[hid][hType] == 3)
					{
						htype = "High";
					}
					else
					{
						htype = "None";
					}
					format(str, sizeof(str), "House ID: %d\nHouse Owner: %s\nHouse Owner 2: %s\nHouse Type: %s\nHouse Location: %s", hid, hData[hid][hOwner], hData[hid][hOwner2], htype, GetLocation(hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "MDC Menu (House)", str, "Close", "");
					DeletePVar(playerid, "MdcHouseID");
				}
				case 1:
				{
					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "House (ID: %d) milik %s yang berlokasi di %s telah ditandai", hid, hData[hid][hOwner], GetLocation(hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]));
					DeletePVar(playerid, "MdcHouseID");
				}
			}
		}
		return 1;
	}
    if(dialogid == SVPOINT_SAPD)
    {
        new tstr[512];
        if(!response)
            return 1;

        switch(listitem+1)
        {
            case 1:
            {
                new modelid = 596;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 2:
            {
                new modelid = 407;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 3:
            {
                new modelid = 544;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 4:
            {
                new modelid = 599;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 5:
            {
                new modelid = 601;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 6:
            {
                new modelid = 528;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 7:
            {
                new modelid = 560;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 8:
            {
                new modelid = 523;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 9:
            {
                new modelid = 525;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 10:
            {
                new modelid = 497;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
            case 11:
            {
                new modelid = 411;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAPD)", tstr, "Yes", "No");
            }
        }
    }
    if(dialogid == SVPOINT_SAGS)
    {
        new tstr[512];
        if(!response)
            return 1;

        switch(listitem+1)
        {
            case 1:
            {
                new modelid = 405;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAGS)", tstr, "Yes", "No");
            }
            case 2:
            {
                new modelid = 409;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAGS)", tstr, "Yes", "No");
            }
            case 3:
            {
                new modelid = 411;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAGS)", tstr, "Yes", "No");
            }
            case 4:
            {
                new modelid = 521;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAGS)", tstr, "Yes", "No");
            }
            case 5:
            {
                new modelid = 437;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAGS)", tstr, "Yes", "No");
            }
            case 6:
            {
                new modelid = 487;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAGS)", tstr, "Yes", "No");
            }
        }
    }
    if(dialogid == SVPOINT_SAMD)
    {
        new tstr[512];
        if(!response)
            return 1;

        switch(listitem+1)
        {
            case 1:
            {
                new modelid = 407;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAMD)", tstr, "Yes", "No");
            }
            case 2:
            {
                new modelid = 544;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAMD)", tstr, "Yes", "No");
            }
            case 3:
            {
                new modelid = 416;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAMD)", tstr, "Yes", "No");
            }
            case 4:
            {
                new modelid = 442;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAMD)", tstr, "Yes", "No");
            }
            case 5:
            {
                new modelid = 426;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAMD)", tstr, "Yes", "No");
            }
            case 6:
            {
                new modelid = 586;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAMD)", tstr, "Yes", "No");
            }
            case 7:
            {
                new modelid = 563;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAMD)", tstr, "Yes", "No");
            }
            case 8:
            {
                new modelid = 487;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SAMD)", tstr, "Yes", "No");
            }
        }
    }
    if(dialogid == SVPOINT_SANEWS)
    {
        new tstr[512];
        if(!response)
            return 1;

        switch(listitem+1)
        {
            case 1:
            {
                new modelid = 582;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SANEWS)", tstr, "Yes", "No");
            }
            case 2:
            {
                new modelid = 418;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SANEWS)", tstr, "Yes", "No");
            }
            case 3:
            {
                new modelid = 413;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SANEWS)", tstr, "Yes", "No");
            }
            case 4:
            {
                new modelid = 405;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SANEWS)", tstr, "Yes", "No");
            }
            case 5:
            {
                new modelid = 461;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SANEWS)", tstr, "Yes", "No");
            }
            case 6:
            {
                new modelid = 488;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (SANEWS)", tstr, "Yes", "No");
            }
        }
    }
    if(dialogid == SVPOINT_SACF)
    {
        new tstr[512];
        if(!response)
            return 1;

        switch(listitem+1)
        {
            case 1:
            {
                new modelid = 588;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (Pedagang)", tstr, "Yes", "No");
            }
            case 2:
            {
                new modelid = 488;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (Pedagang)", tstr, "Yes", "No");
            }
            case 3:
            {
                new modelid = 423;
                pData[playerid][pSvModelid] = modelid;
                format(tstr, sizeof(tstr), ""WHITE_E"Anda yakin ingin mengeluarkan kendaraan "GREEN_LIGHT"%s"WHITE_E"?", GetVehicleModelName(modelid));
                ShowPlayerDialog(playerid, SVPOINT_SPAWNVEH, DIALOG_STYLE_MSGBOX, "Vehicle Spawn (Pedagang)", tstr, "Yes", "No");
            }
        }
    }
    if(dialogid == SVPOINT_SPAWNVEH)
    {
        new fvid = Iter_Free(FactionVeh);
        new svid = pData[playerid][pGetSVPOINTID];
        new modelid = pData[playerid][pSvModelid];
        if(response)
        {
            if(svData[svid][svType] == 1) //SAPD
            {
                if(modelid == 497)
                {
                    fvData[fvid][fvPosX] = 1566.16;
                    fvData[fvid][fvPosY] = -1643.75;
                    fvData[fvid][fvPosZ] = 28.40+0.5;
                    fvData[fvid][fvPosA] = 89.69;

                    fvData[fvid][fvColor1] = 0;
                    fvData[fvid][fvColor2] = 1;

                    fvData[fvid][fvFaction] = 1;
                }
                else
                {
                    fvData[fvid][fvPosX] = 1538.62;
                    fvData[fvid][fvPosY] = -1651.09;
                    fvData[fvid][fvPosZ] = 5.89+0.5;
                    fvData[fvid][fvPosA] = 183.14;

                    fvData[fvid][fvColor1] = 0;
                    fvData[fvid][fvColor2] = 1;

                    fvData[fvid][fvFaction] = 1;
                }
                fvData[fvid][fvLabel] = Create3DTextLabel("Police Departement", COLOR_GREY, 0.0, 0.0, 0.0, 15.0, 0, 1);
            }
            else if(svData[svid][svType] == 2) //SAGS
            {
            	//AddStaticVehicle(411,1245.6412,-2026.8379,59.4969,269.2488,9,3); // spawn veh pemerintah
                if(modelid == 487)
                {
                    fvData[fvid][fvPosX] = 1245.6412;
                    fvData[fvid][fvPosY] = -2026.8379;
                    fvData[fvid][fvPosZ] = 59.4969;
                    fvData[fvid][fvPosA] = 269.2488;

                    fvData[fvid][fvColor1] = 0;
                    fvData[fvid][fvColor2] = 0;

                    fvData[fvid][fvFaction] = 2;
                }
                else
                {
                    fvData[fvid][fvPosX] = 1245.6412;
                    fvData[fvid][fvPosY] = -2026.8379;
                    fvData[fvid][fvPosZ] = 59.4969;
                    fvData[fvid][fvPosA] = 269.2488;

                    fvData[fvid][fvColor1] = 0;
                    fvData[fvid][fvColor2] = 0;

                    fvData[fvid][fvFaction] = 2;
                }
                fvData[fvid][fvLabel] = Create3DTextLabel("Goverment Service", COLOR_GREY, 0.0, 0.0, 0.0, 15.0, 0, 1);
            }
            else if(svData[svid][svType] == 3) //SAMD
            {
                if(modelid == 563 || modelid == 487)
                {
                    fvData[fvid][fvPosX] = 1159.78;
                    fvData[fvid][fvPosY] = -1302.98;
                    fvData[fvid][fvPosZ] = 31.49+0.5;
                    fvData[fvid][fvPosA] = 270.99;

                    fvData[fvid][fvColor1] = 3;
                    fvData[fvid][fvColor2] = 1;

                    fvData[fvid][fvFaction] = 3;
                }
                else
                {
                    fvData[fvid][fvPosX] = 1121.55;
                    fvData[fvid][fvPosY] = -1309.98;
                    fvData[fvid][fvPosZ] = 13.63+0.5;
                    fvData[fvid][fvPosA] = 271.55;

                    fvData[fvid][fvColor1] = 3;
                    fvData[fvid][fvColor2] = 1;

                    fvData[fvid][fvFaction] = 3;
                }
                fvData[fvid][fvLabel] = Create3DTextLabel("Medical Departement", COLOR_GREY, 0.0, 0.0, 0.0, 15.0, 0, 1);
            }
            else if(svData[svid][svType] == 4) //SANEWS
            {
                if(modelid == 488)
                {
                    fvData[fvid][fvPosX] = 741.78;
                    fvData[fvid][fvPosY] = -1370.26;
                    fvData[fvid][fvPosZ] = 25.69+0.5;
                    fvData[fvid][fvPosA] = 178.56;

                    fvData[fvid][fvColor1] = -1;
                    fvData[fvid][fvColor2] = -1;

                    fvData[fvid][fvFaction] = 4;
                }
                else
                {
                    fvData[fvid][fvPosX] = 740.23;
                    fvData[fvid][fvPosY] = -1339.85;
                    fvData[fvid][fvPosZ] = 13.84+0.5;
                    fvData[fvid][fvPosA] = 250.85;

                    fvData[fvid][fvColor1] = -1;
                    fvData[fvid][fvColor2] = -1;

                    fvData[fvid][fvFaction] = 4;
                }
                fvData[fvid][fvLabel] = Create3DTextLabel("News Agency", COLOR_GREY, 0.0, 0.0, 0.0, 15.0, 0, 1);
            }
            else if(svData[svid][svType] == 5) //SACF
            {
            	//AddStaticVehicle(411,1220.1825,-891.9686,42.5685,187.4703,9,3); // spawn veh pedagang
				//AddStaticVehicle(411,1245.6412,-2026.8379,59.4969,269.2488,9,3); // spawn veh pemerintah
                if(modelid == 588)
                {
                    fvData[fvid][fvPosX] = 1220.1825;
                    fvData[fvid][fvPosY] = -891.9686;
                    fvData[fvid][fvPosZ] = 42.5685;
                    fvData[fvid][fvPosA] = 187.4703;

                    fvData[fvid][fvColor1] = -1;
                    fvData[fvid][fvColor2] = -1;

                    fvData[fvid][fvFaction] = 5;
                }
                else
                {
                    fvData[fvid][fvPosX] = 1220.1825;
                    fvData[fvid][fvPosY] = -891.9686;
                    fvData[fvid][fvPosZ] = 42.5685;
                    fvData[fvid][fvPosA] = 187.4703;

                    fvData[fvid][fvColor1] = -1;
                    fvData[fvid][fvColor2] = -1;

                    fvData[fvid][fvFaction] = 5;
                }
                fvData[fvid][fvLabel] = Create3DTextLabel("Cafe Food", COLOR_GREY, 0.0, 0.0, 0.0, 15.0, 0, 1);
            }
            fvData[fvid][fvVeh] = AddStaticVehicle(modelid, fvData[fvid][fvPosX], fvData[fvid][fvPosY], fvData[fvid][fvPosZ], fvData[fvid][fvPosA], fvData[fvid][fvColor1], fvData[fvid][fvColor2]);
            Attach3DTextLabelToVehicle(fvData[fvid][fvLabel], fvData[fvid][fvVeh], 0.0, 0.0, 0.2);
            Info(playerid, "Kendaraan %s (id: %d) dari Faction Vehicle (id: %d) telah di spawn", GetVehicleModelName(modelid), fvData[fvid][fvVeh], svid);
            Info(playerid, "Kendaraan yang anda spawn telah ditandai!");

            DisablePlayerCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 1, fvData[fvid][fvPosX], fvData[fvid][fvPosY], fvData[fvid][fvPosZ], 0.0, 0.0, 0.0, 3.5);

            pData[playerid][pGetSVPOINTID] = -1;
            pData[playerid][pSvModelid] = -1;

            Iter_Add(FactionVeh, fvid);
        }
        return 1;
    }
	if(dialogid == DIALOG_EMERGENCY_LIST)
	{
		if(!response)
			return 1;

		new fcid = ReturnFactionCallID(playerid, listitem+1);

		if(pData[playerid][pFaction] == 1)
		{
			SendFactionMessage(pData[playerid][pFaction], COLOR_BLUE, "[EMERGENCY CALL] "WHITE_E"%s telah menangani emergency call #%d (From: "YELLOW_E"%s"WHITE_E")", pData[playerid][pName], fcid, ReturnName(fcData[fcid][fcOwner]));
			Info(fcData[fcid][fcOwner], "%s telah meneriman panggilan emergency call 911 anda!", pData[playerid][pName]);
		}
		else if(pData[playerid][pFaction] == 3)
		{
			SendFactionMessage(pData[playerid][pFaction], COLOR_PINK, "[EMERGENCY CALL] "WHITE_E"%s telah menangani emergency call #%d (From: "YELLOW_E"%s"WHITE_E")", pData[playerid][pName], fcid, ReturnName(fcData[fcid][fcOwner]));
			Info(fcData[fcid][fcOwner], "%s telah meneriman panggilan emergency call 922 anda!", pData[playerid][pName]);
		}

		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 1, fcData[fcid][fcPosX], fcData[fcid][fcPosY], fcData[fcid][fcPosZ], 0.0, 0.0, 0.0, 3.5);
		Info(playerid, "Lokasi emergency call yang kamu pilih telah ditandai!");
		
		FactionCall_Delete(fcid);
	}
	if(dialogid == ADSLOG_LIST)
	{
		if(!response)
			return 1;

		new adsid = ReturnAdsLogID((listitem + 1));

		new str[524];
		format(str, sizeof(str), ""WHITE_E"Advertisement ID: "YELLOW_E"%d\n", str, adsid);
		format(str, sizeof(str), "%s"WHITE_E"Poster Owner: "YELLOW_E"%s\n", str, ReturnName(AdsData[adsid][adsOwner]));
		format(str, sizeof(str), "%s"WHITE_E"Phone Number: "YELLOW_E"%d\n", str, pData[playerid][pPhone]);
		format(str, sizeof(str), "%s"WHITE_E"Bank Rek: "YELLOW_E"%d", str, pData[playerid][pBankRek]);

		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Advertisement Logs", str, "Close", "");
	}
	if(dialogid == DIALOG_JOBCENTER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new JOB[10000], String[10000];
					strcat(JOB, "Job Name\n");
					format(String, sizeof(String), "Job Taxi Driver\n");//1
					strcat(JOB, String);
					format(String, sizeof(String), "Job Penambang\n"); // 2
					strcat(JOB, String);
					format(String, sizeof(String), "Job Lumber Jack\n"); // 3
					strcat(JOB, String);
					format(String, sizeof(String), "Job Trucker\n");// 4
					strcat(JOB, String);
					format(String, sizeof(String), "Job Miner\n"); // 5
					strcat(JOB, String);
					format(String, sizeof(String), "Job Production\n"); // 6
					strcat(JOB, String);
					format(String, sizeof(String), "Job Farmer\n");// 7
					strcat(JOB, String);
					format(String, sizeof(String), "Job Hauling\n"); // 8
					strcat(JOB, String);
					format(String, sizeof(String), "Job Pizza\n"); // 9
					strcat(JOB, String);
					format(String, sizeof(String), "Job Butcher\n"); // 10
					strcat(JOB, String);
					format(String, sizeof(String), "Job Reflenish\n"); // 11
					strcat(JOB, String);
					format(String, sizeof(String), "Job Cow milker\n"); // 12
					strcat(JOB, String);
					format(String, sizeof(String), "Job Tukang Kayu\n"); // 13
					strcat(JOB, String);
					format(String, sizeof(String), "unemployment\n"); // 14
					strcat(JOB, String);
					ShowPlayerDialog(playerid, DIALOG_DAFTAR_JOB1, DIALOG_STYLE_TABLIST_HEADERS,"JOB CENTER", JOB, "Select", "Cancel");
				}
				case 1:
				{
					if(pData[playerid][pVip] <= 0) return Error(playerid, "Tidak tersedia untuk anda");
					{
						new JOB[10000], String[10000];
						strcat(JOB, "Job Name\n");
						format(String, sizeof(String), "Job Taxi Driver\n");//1
						strcat(JOB, String);
						format(String, sizeof(String), "Job Penambang\n"); // 2
						strcat(JOB, String);
						format(String, sizeof(String), "Job Lumber Jack\n"); // 3
						strcat(JOB, String);
						format(String, sizeof(String), "Job Trucker\n");// 4
						strcat(JOB, String);
						format(String, sizeof(String), "Job Miner\n"); // 5
						strcat(JOB, String);
						format(String, sizeof(String), "Job Production\n"); // 6
						strcat(JOB, String);
						format(String, sizeof(String), "Job Farmer\n");// 7
						strcat(JOB, String);
						format(String, sizeof(String), "Job Hauling\n"); // 8
						strcat(JOB, String);
						format(String, sizeof(String), "Job Pizza\n"); // 9
						strcat(JOB, String);
						format(String, sizeof(String), "Job Butcher\n"); // 10
						strcat(JOB, String);
						format(String, sizeof(String), "Job Reflenish\n"); // 11
						strcat(JOB, String);
						format(String, sizeof(String), "Job Cow milker\n"); // 12
						strcat(JOB, String);
						format(String, sizeof(String), "Job Tukang Kayu\n"); // 13
						strcat(JOB, String);
						format(String, sizeof(String), "unemployment\n"); // 14
						strcat(JOB, String);
						ShowPlayerDialog(playerid, DIALOG_DAFTAR_JOB2, DIALOG_STYLE_TABLIST_HEADERS,"JOB CENTER", JOB, "Select", "Cancel");
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_DISNAKER)
	{
		if(response)
		{
			switch(listitem)
			{
				//================[ CASE 0 ]=============
				case 0:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di Job Penambang");
					pData[playerid][pJob] = 20;
					RefreshJobTambang(playerid);
					penambang++;
				}
				//================[ CASE 1 ]=============
				case 1:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di Job Lumber Jack");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 3;
					lumberjack++;
				}
				//================[ CASE 2 ]=============
				case 2:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di Job trucker");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 4;
					trucker++;
				}
				//================[ CASE 3 ]=============
				case 3:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di Job miner");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 5;
					miner++;
				}
				//================[ CASE 4 ]=============
				case 4:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di Job production");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 6;
					production++;
				}
				//================[ CASE 5 ]=============
				case 5:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di Job farmer");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 7;
					farmers++;
				}
				//================[ CASE 6 ]=============
				case 6:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di Job Hauling");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 8;
					hauling++;
				}
				//================[ CASE 7 ]=============
				case 7:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Pizza");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 9;
					pizza++;
				}
				//================[ CASE 8 ]=============
				case 8:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Butcher");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 10;
					butcher++;
				}
				//================[ CASE 9 ]=============
				case 9:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Reflenish");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 11;
					reflenish++;
				}
				//================[ CASE 10 ]=============
				case 10:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Pemerah Susu");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 14;
					RefreshMapJobSapi(playerid);
					pemerassusu++;
				}
				//================[ CASE 11 ]=============
				case 11:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Tukang Kayu");
					Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 21;
					//LoadAreaJob();
					tukangkayu++;
				}
				//================[ CASE 12 ]=============
				case 12:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Penjahit");
					//Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 23;
					penjahitt++;
				}
				//================[ CASE 13 ]=============
				case 13:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Tukang Ayam");
					//Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 24;
					RefreshJobPemotong(playerid);
					tukangayams++;
				}
				//================[ CASE 14 ]=============
				case 14:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Penambang Minyak");
					//Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 25;
					RefreshJobTambangMinyak(playerid);
					penambangminyak++;
				}
				//================[ CASE 15 ]=============
				case 15:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Recycle Rise");
					//Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 26;
					Recycler++;
				}
				//================[ CASE 16 ]=============
				case 16:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					Info(playerid, "Anda telah berhasil Bekerja di job Sopir Bus Kota");
					//Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
					pData[playerid][pJob] = 27;
					Sopirbus++;
					RefreshJobBus(playerid);
				}
				//================[ KELUAR PEKERJAAN ]=============
				case 17:
				{
				    if(pData[playerid][pJob] == 0) return ErrorMsg(playerid, "Anda seorang pengangguran.");
				    if(pData[playerid][pJob] == 20)
					{
					    penambang--;
				    	DeletePenambangCP(playerid);
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 3)
					{
					    lumberjack--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 4)
					{
					    trucker--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 5)
					{
					    miner--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 6)
					{
					    production--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 7)
					{
					    farmers--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 8)
					{
					    hauling--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 9)
					{
					    pizza--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 10)
					{
					    butcher--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 11)
					{
					    reflenish--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 14)
					{
					    pemerassusu--;
				    	pData[playerid][pJob] = 0;
				    	DeleteJobPemerahMap(playerid);
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 21)
					{
					    tukangkayu--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 23)
					{
					    penjahitt--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 24)
					{
					    tukangayams--;
				    	pData[playerid][pJob] = 0;
				    	DeletePemotongCP(playerid);
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 25)
					{
					    penambangminyak--;
				    	pData[playerid][pJob] = 0;
				    	DeleteMinyakCP(playerid);
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 26)
					{
					    Recycler--;
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
					else if(pData[playerid][pJob] == 27)
					{
					    Sopirbus--;
					    DeleteBusCP(playerid);
				    	pData[playerid][pJob] = 0;
						Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DAFTAR_JOB1)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 1;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job Taxi");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 1:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 20;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job Penambang");
	                    	RefreshJobTambang(playerid);
							//Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 3600);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 2:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 3;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job lumber jack");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 3:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 4;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job trucker");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 4:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 5;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job miner");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
					}
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");	               
                    return 1;
                }
                case 5:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 6;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job production");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 6:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 7;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job farmer");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 7:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 8;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job Hauling");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 8:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");
                	
                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 9;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Pizza");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 9:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");
                	
                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 10;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Butcher");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							RefreshMapJobDaging(playerid);
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 10:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");
                	
                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 11;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Reflenish");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 11:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");
                	
                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 14;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Cow milker");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
							RefreshMapJobSapi(playerid);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 12:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");
                	
                	if(pData[playerid][pJob] == 0)
					{
	                    if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob] = 21;
	                    	pData[playerid][pJob] = pData[playerid][pGetJob];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Tukang Kayu");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
							//RefreshMapJobSapi(playerid);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 13:
                {
                    if(pData[playerid][pJob] == 0) return Error(playerid, "Anda tidak memiliki job apapun.");
                    if(pData[playerid][pExitJob] != 0) return Error(playerid, "You must wait 1 days for exit from your current job!");
                    if(pData[playerid][pJob] != 0)
                    {
                    	pData[playerid][pJob] = 0;
                    	DeletePenambangCP(playerid);
                    	Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
                    }
                    return 1;
                }
            }
        }
    }
    if(dialogid == DIALOG_DAFTAR_JOB2)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");

                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 1;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job Taxi");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 1:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");

                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 20;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job Penambang");
							RefreshJobTambang(playerid);
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 2:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");

                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 3;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job lumber jack");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 3:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");

                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 4;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job trucker");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 4:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");

                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 5;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job miner");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
					}
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");	               
                    return 1;
                }
                case 5:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");

                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 6;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job production");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 6:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");

                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 7;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job farmer");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 3600);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 7:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");

                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 8;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di Job Hauling");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 8:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");
                	
                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 9;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Pizza");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 9:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");
                	
                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 10;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Butcher");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							RefreshMapJobDaging(playerid);
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 10:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");

					if(pData[playerid][pVip] < 0) 
						return Error(playerid, "Tidak tersedia untuk anda");
                	
                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 11;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Reflenish");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 11:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");
                	
                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 14;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Cow milker");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
							RefreshMapJobSapi(playerid);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 12:
                {
                	if(pData[playerid][pIDCard] <= 0)
						return Error(playerid, "Anda tidak memiliki ID-Card.");
                	
                	if(pData[playerid][pJob2] == 0)
					{
	                    if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1)
	                    {
	                    	pData[playerid][pGetJob2] = 21;
	                    	pData[playerid][pJob2] = pData[playerid][pGetJob2];
	                    	Info(playerid, "Anda telah berhasil Bekerja di job Tukang Kayu");
							Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
							pData[playerid][pGetJob2] = 0;
							pData[playerid][pExitJob] = gettime() + (1 * 86400);
							//RefreshMapJobSapi(playerid);
	                    }
	                    else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	                }
					else return Error(playerid, "Anda sudah memiliki pekerjaan!");
                    return 1;
                }
                case 13:
                {
                    if(pData[playerid][pJob2] == 0) return Error(playerid, "Anda tidak memiliki job apapun.");
                    if(pData[playerid][pExitJob] != 0) return Error(playerid, "You must wait 1 days for exit from your current job!");
                    if(pData[playerid][pJob2] != 0)
                    {
                    	pData[playerid][pJob2] = 0;
                    	DeletePenambangCP(playerid);
                    	Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
                    }
                    return 1;
                }
            }
        }
    }
    if(dialogid == DIALOG_BALKOT)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                	if(pData[playerid][pIDCard] != 0) return ShowNotifError(playerid, "Anda sudah memiliki ID Card!", 5000);
                	if(pData[playerid][pMoney] < 25) return ShowNotifError(playerid, "Anda butuh $500 untuk membuat ID Card", 5000);
                	new sext[40], mstr[128];
                	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
                	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
                	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "ID-Card", mstr, "Tutup", "");
                	pData[playerid][pIDCard] = 1;
                	pData[playerid][pIDCardTime] = gettime() + (15 * 86400);
                	GivePlayerMoneyEx(playerid, -25);
                	Server_AddMoney(25);
                	ShowItemBox(playerid, "Ktp", "Received_1x", 1581, 4);
                    return 1;
                }
                case 1:
                {
                	if(pData[playerid][pMoney] < 20) return ShowNotifError(playerid, "Anda butuh $20 untuk mengganti tgl lahir anda!", 5000);
                	if(pData[playerid][IsLoggedIn] == false) return ShowNotifError(playerid, "Anda harus login terlebih dahulu!", 5000);
                	ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Change", "Cancel");
                    return 1;
                }
                case 2:
                {
                	if(GetOwnedHouses(playerid) == -1) return ShowNotifError(playerid, "Anda tidak memiliki rumah!", 5000);
                	new hid, _tmpstring[128], count = GetOwnedHouses(playerid), CMDSString[1024];
                	CMDSString = "";
                	new lock[128];
                	Loop(itt, (count + 1), 1)
                	{
                		hid = ReturnPlayerHousesID(playerid, itt);
                		if(hData[hid][hLocked] == 0)
                		{
                			lock = ""GREEN_LIGHT"Unlocked"WHITE_E"";
                		}
                		else if(hData[hid][hLocked] == 1)
                		{
                			lock = ""RED_E"Locked"WHITE_E"";
                		}
                		else
                		{
                			lock = ""RED_E"Sealed"WHITE_E"";
                		}
                		if(itt == count)
                		{
                			format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, hData[hid][hAddress], lock);
                		}
                		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, hData[hid][hAddress], lock);
                		strcat(CMDSString, _tmpstring);
                	}
                	ShowPlayerDialog(playerid, DIALOG_SELL_HOUSES, DIALOG_STYLE_LIST, "Sell Houses", CMDSString, "Sell", "Cancel");
                }
                case 3:
                {
                	if(GetOwnedBisnis(playerid) == 0) return ShowNotifError(playerid, "Anda tidak memiliki bisnis!", 5000);
                	new bid, _tmpstring[128], count = GetOwnedBisnis(playerid), CMDSString[512];
                	CMDSString = "";
                	new lock[128];
                	Loop(itt, (count + 1), 1)
                	{
                		bid = ReturnPlayerBisnisID(playerid, itt);
                		if(bData[bid][bLocked] == 0)
                		{
                			lock = ""GREEN_LIGHT"Dibuka{ffffff}";

                		}
                		else if(bData[bid][bLocked] == 1)
                		{
                			lock = ""RED_E"Dikunci{ffffff} ";
                		}
                		else
                		{
                			lock = ""RED_E"Disegel"WHITE_E"";
                		}
                		if(itt == count)
                		{
                			format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, bData[bid][bName], lock);
                		}
                		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, bData[bid][bName], lock);
                		strcat(CMDSString, _tmpstring);
                	}
                	ShowPlayerDialog(playerid, DIALOG_SELL_BISNISS, DIALOG_STYLE_LIST, "Sell Bisnis", CMDSString, "Sell", "Cancel");
                }
                case 4:
                {
                	if(GetOwnedDealer(playerid) == 0) return ShowNotifError(playerid, "Anda tidak memiliki dealer!", 5000);
                	new deid, _tmpstring[128], count = GetOwnedDealer(playerid), CMDSString[512];
                	CMDSString = "";
                	Loop(itt, (count + 1), 1)
                	{
                		deid = ReturnPlayerDealerID(playerid, itt);
                		if(itt == count)
                		{
                			format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, drData[deid][dName], GetLocation(drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]));
                		}
                		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, drData[deid][dName], GetLocation(drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]));
                		strcat(CMDSString, _tmpstring);
                	}
                	ShowPlayerDialog(playerid, DIALOG_SELL_DEALER, DIALOG_STYLE_LIST, "Sell Dealer", CMDSString, "Sell", "Cancel");
                }
                case 5:
                {
                	new string[1024];
                	format(string, sizeof(string), "Business Tax\nHouse Tax\nDealer Tax\nVending Tax");
                	ShowPlayerDialog(playerid, DIALOG_PAYTAX, DIALOG_STYLE_LIST, "Paytax Assets", string , "Yes","No");
                }
            }
        }
    }
    if(dialogid == DIALOG_MENU_PLAYER)
    {
    	if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                	return callcmd::i(playerid, "");
                }
                case 1:
                {
                	
                }
                case 2:
                {
                	return callcmd::nonono(playerid, "");
                }
                case 3:
                {
                	
                }
                case 4:
                {
                	
                }
                case 5:
                {
                	
                }
            }
        }
    }
    if(dialogid == DIALOG_MYVEH)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVeh", ReturnPlayerVehID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_MYVEH_INFO, DIALOG_STYLE_LIST, "Vehicle Info", "Information Vehicle\nTrack Vehicle\nUnstuck Vehicle", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DIALOG_MYVEH_INFO)
	{
		if(!response) return 1;
		new vid = GetPVarInt(playerid, "ClickedVeh");
		switch(listitem)
		{
			case 0:
			{
				
				if(IsValidVehicle(pvData[vid][cVeh]))
				{
					new line9[900];
				
					format(line9, sizeof(line9), "{ffffff}[{7348EB}INFO VEHICLE{ffffff}]:\nVehicle ID: {ffff00}%d\n{ffffff}Model: {ffff00}%s\n{ffffff}Plate: {ffff00}%s{ffffff}\n\n{ffffff}[{7348EB}DATA VEHICLE{ffffff}]:\nInsurance: {ffff00}%d{ffffff}",
					pvData[vid][cVeh], GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cPlate], pvData[vid][cInsu]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Info", line9, "Close","");
				}
				else
				{
					new line9[900];
				
					format(line9, sizeof(line9), "{ffffff}[{7348EB}INFO VEHICLE{ffffff}]:\nVehicle UID: {ffff00}%d\n{ffffff}Model: {ffff00}%s\n{ffffff}Plate: {ffff00}%s{ffffff}\n\n{ffffff}[{7348EB}DATA VEHICLE{ffffff}]:\nInsurance: {ffff00}%d{ffffff}",
					pvData[vid][cID], GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cPlate], pvData[vid][cInsu]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Info", line9, "Close","");
				}
			}
			case 1:
			{
				if(IsValidVehicle(pvData[vid][cVeh]))
				{
					new palid = pvData[vid][cVeh];
					new
			        	Float:x,
			        	Float:y,
			        	Float:z;

					pData[playerid][pTrackCar] = 1;
					GetVehiclePos(palid, x, y, z);
					SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Ikuti checkpoint untuk menemukan kendaraan anda!");
				}
				else if(pvData[vid][cParkid] > 0)
				{
					SetPlayerRaceCheckpoint(playerid, 1, pvData[vid][cPosX], pvData[vid][cPosY], pvData[vid][cPosZ], 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Ikuti checkpoint untuk menemukan kendaraan yang ada di dalam garkot!");
				}
				else if(pvData[vid][cClaim] != 0)
				{
					Info(playerid, "Kendaraan kamu di kantor insuransi!");
				}
				else
					return Error(playerid, "Kendaraanmu belum di spawn!");
			}
		}
		return 1;
	}
	/*if(dialogid == DIALOG_VMENU)
    {
    	if(response)
    	{
    		switch(listitem)
    		{
    			case 0:
    			{
    				callcmd::engine(playerid, "");
    			}
    			case 1:
    			{
    				callcmd::lock(playerid, "");
    			}
    			case 2:
    			{
    				if(IsPlayerInAnyVehicle(playerid)) 
    					return Error(playerid, "You must exit from the vehicle.");

    				new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

    				static
    				carid = -1;

    				if((carid = Vehicle_Nearest(playerid)) != -1)
    				{
    					if(pvData[carid][cLocked] != 0) return Error(playerid, "Bagasi terkunci");
    					if(IsAVehicleStorage(x))
    					{
    						if(Vehicle_IsOwner(playerid, carid) || pData[playerid][pFaction] == 1)
    						{
    							new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
    							foreach(new i : PVehicles)
    							{
    								if(vehid == pvData[i][cVeh])
    								{
    									if(pvData[i][cOwner] == pData[playerid][pID])
    									{
    										if(GetVehicleModel(vehid) == 509 || GetVehicleModel(vehid) == 510 || GetVehicleModel(vehid) == 481)
    											return Error(playerid, "Kendaraan ini tidak memiliki storage untuk menyimpan barang");
    										{
    											if(!GetTrunkStatus(vehid))
    												return Error(playerid, "Kamu harus membuka trunk kendaraanmu untuk membuka storage");
    											{
    												Info(playerid, "kendaraan id %d (in database %d).", vehid, pvData[i][cID]);
    												Vehicle_TrunknStorage(playerid, vehid);
    											}
    										}
    									}
    									else return Error(playerid, "kendaraan ini bukan milikmu.");
    								}
    							}
    						}
    						else Error(playerid, "Kendaraan ini bukan milik anda!");
    					}	
    					else Error(playerid, "Kendaraan tidak mempunyai penyimpanan/ bagasi!");
    				}
    				else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
    				return 1;
    			}
    			case 3:
    			{
    				static
    				vehicleid;

    				if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Kamu harus keluar dari kendaraan.");

    				vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

    				if(vehicleid == INVALID_VEHICLE_ID)
    					return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

    				new Float:x, Float:y, Float:z;
    				GetPlayerPos(playerid, x, y, z);
    				switch (GetHoodStatus(vehicleid))
    				{
    					case false:
    					{
    						SwitchVehicleBonnet(vehicleid, true);
    						InfoTD_MSG(playerid, 4000, "Vehicle Hood ~g~Dibuka");
    					}
    					case true:
    					{
    						SwitchVehicleBonnet(vehicleid, false);
    						InfoTD_MSG(playerid, 4000, "Vehicle Hood ~r~Ditutup");
    					}
    				}
    				return 1;
    			}
    			case 4:
    			{
    				static
    				vehicleid;
    				
    				if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Kamu harus keluar dari kendaraan.");

    				vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

    				if(vehicleid == INVALID_VEHICLE_ID)
    					return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

    				switch (GetTrunkStatus(vehicleid))
    				{
    					case false:
    					{
    						SwitchVehicleBoot(vehicleid, true);
    						Vehicle(playerid, "trunk "GREEN_E"dibuka.");
    					}
    					case true:
    					{
    						SwitchVehicleBoot(vehicleid, false);
    						Vehicle(playerid, "Vehicle trunk "RED_E"ditutup.");
    					}
    				}
    				return 1;
    			}
    			case 5:
    			{
    				static
    				vehicleid;

    				vehicleid = GetPlayerVehicleID(playerid);
    				if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    				{
    					if(!IsEngineVehicle(vehicleid))
    						return Error(playerid, "Kamu tidak berada didalam kendaraan.");

    					new carid = -1;
    					if((carid = Vehicle_Nearest(playerid)) != -1)
    					{
    						if(Vehicle_IsOwner(playerid, carid))
    						{
    							if(pvData[carid][cTogNeon] == 0)
    							{
    								if(pvData[carid][cNeon] != 0)
    								{
    									SetVehicleNeonLights(pvData[carid][cVeh], true, pvData[carid][cNeon], 0);
    									InfoTD_MSG(playerid, 4000, "Neon ~g~ON");
    									pvData[carid][cTogNeon] = 1;
    								}
    								else
    								{
    									SetVehicleNeonLights(pvData[carid][cVeh], false, pvData[carid][cNeon], 0);
    									pvData[carid][cTogNeon] = 0;
    								}
    							}
    							else
    							{
    								SetVehicleNeonLights(pvData[carid][cVeh], false, pvData[carid][cNeon], 0);
    								InfoTD_MSG(playerid, 4000, "Neon ~r~OFF");
    								pvData[carid][cTogNeon] = 0;
    							}
    						}
    					}
    				}
    				else return Error(playerid, "Anda harus mengendarai kendaraan!");
    			}
    		}
    	}
    }*/
    if(dialogid == DIALOG_VMENU)
    {
    	if(response)
    	{
    		switch(listitem)
    		{
    			case 0:
    			{
    				//callcmd::engine(playerid, "");
    			}
    			case 1:
    			{
    				callcmd::kunci(playerid, "");
    			}
    			case 2:
    			{
    				if(IsPlayerInAnyVehicle(playerid)) 
    					return Error(playerid, "You must exit from the vehicle.");

    				new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

    				static
    				carid = -1;

    				if((carid = Vehicle_Nearest(playerid)) != -1)
    				{
    					if(pvData[carid][cLocked] != 0) return Error(playerid, "Bagasi terkunci");
    					if(IsAVehicleStorage(x))
    					{
    						if(Vehicle_IsOwner(playerid, carid) || pData[playerid][pFaction] == 1)
    						{
    							new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
    							foreach(new i : PVehicles)
    							{
    								if(vehid == pvData[i][cVeh])
    								{
    									if(pvData[i][cOwner] == pData[playerid][pID])
    									{
    										if(GetVehicleModel(vehid) == 509 || GetVehicleModel(vehid) == 510 || GetVehicleModel(vehid) == 481)
    											return Error(playerid, "Kendaraan ini tidak memiliki storage untuk menyimpan barang");
    										{
    											if(!GetTrunkStatus(vehid))
    												return Error(playerid, "Kamu harus membuka trunk kendaraanmu untuk membuka storage");
    											{
    												ShowPlayerDialog(playerid, DIALOG_BAGASI, DIALOG_STYLE_LIST, "BAGASI", "Storage Weapons\nStorage [1]\nstorage [2]", "Select", "<<<");
	    										}
	    									}
	    								}
	    							}
	    						}
	    					}
	    				}
	    			}
	    			return 1;
    			}
    			case 3:
    			{
    				static
    				vehicleid;

    				if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Kamu harus keluar dari kendaraan.");

    				vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

    				if(vehicleid == INVALID_VEHICLE_ID)
    					return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

    				new Float:x, Float:y, Float:z;
    				GetPlayerPos(playerid, x, y, z);
    				switch (GetHoodStatus(vehicleid))
    				{
    					case false:
    					{
    						SwitchVehicleBonnet(vehicleid, true);
    						InfoTD_MSG(playerid, 4000, "Vehicle Hood ~g~Dibuka");
    					}
    					case true:
    					{
    						SwitchVehicleBonnet(vehicleid, false);
    						InfoTD_MSG(playerid, 4000, "Vehicle Hood ~r~Ditutup");
    					}
    				}
    				return 1;
    			}
    			case 4:
    			{
    				static
    				vehicleid;
    				
    				if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Kamu harus keluar dari kendaraan.");

    				vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

    				if(vehicleid == INVALID_VEHICLE_ID)
    					return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

    				switch (GetTrunkStatus(vehicleid))
    				{
    					case false:
    					{
    						SwitchVehicleBoot(vehicleid, true);
    						Vehicle(playerid, "trunk "GREEN_E"dibuka.");
    					}
    					case true:
    					{
    						SwitchVehicleBoot(vehicleid, false);
    						Vehicle(playerid, "Vehicle trunk "RED_E"ditutup.");
    					}
    				}
    				return 1;
    			}
    			case 5:
    			{
    				static
    				vehicleid;

    				vehicleid = GetPlayerVehicleID(playerid);
    				if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    				{
    					if(!IsEngineVehicle(vehicleid))
    						return Error(playerid, "Kamu tidak berada didalam kendaraan.");

    					new carid = -1;
    					if((carid = Vehicle_Nearest(playerid)) != -1)
    					{
    						if(Vehicle_IsOwner(playerid, carid))
    						{
    							if(pvData[carid][cTogNeon] == 0)
    							{
    								if(pvData[carid][cNeon] != 0)
    								{
    									SetVehicleNeonLights(pvData[carid][cVeh], true, pvData[carid][cNeon], 0);
    									InfoTD_MSG(playerid, 4000, "Neon ~g~ON");
    									pvData[carid][cTogNeon] = 1;
    								}
    								else
    								{
    									SetVehicleNeonLights(pvData[carid][cVeh], false, pvData[carid][cNeon], 0);
    									pvData[carid][cTogNeon] = 0;
    								}
    							}
    							else
    							{
    								SetVehicleNeonLights(pvData[carid][cVeh], false, pvData[carid][cNeon], 0);
    								InfoTD_MSG(playerid, 4000, "Neon ~r~OFF");
    								pvData[carid][cTogNeon] = 0;
    							}
    						}
    					}
    				}
    				else return Error(playerid, "Anda harus mengendarai kendaraan!");
    			}
    		}
    	}
    }
    if(dialogid == DIALOG_BAGASI)
    {
    	if(response)
    	{
    		new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
    		switch(listitem)
    		{
    			case 0:
    			{
    				Vehicle_WeaponStorage(playerid, vehid);
    			}
    			case 1:
    			{
    				callcmd::bagasi(playerid, "");
    			}
    			case 2:
    			{
    				foreach(new i : PVehicles)
					{
						new string[10 * 32];

						format(string, sizeof(string), "%sMoney Storage ({00ff00}%s{ffffff}/{00ff00}$100.000)\n", string, FormatMoney(pvData[i][cMoney]));
						format(string, sizeof(string), "%sComponent Storage (%d/2500)\n", string, pvData[i][cComponent]);
						format(string, sizeof(string), "%sMaterial Storage (%d/2500)\n", string, pvData[i][cMaterial]);
						ShowPlayerDialog(playerid, VEHICLE_STORAGE, DIALOG_STYLE_LIST, "Vehicle Storage", string, "Select", "Cancel");
					}
    			}
    		}
    	}
    	return 1;
    }
	//
    if(dialogid == DIALOG_MILK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFaction] != 5)
						return ShowNotifError(playerid, "You must be part of a Pedagang faction.", 10000);

					if(pData[playerid][pSusuolah] == 500) return ErrorMsg(playerid, "Anda sudah membawa susu olahan!");

					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Milk:\nMilk Stock: "GREEN_E"%d\n"WHITE_E"Milk Price"GREEN_E"%s /item", Susu, FormatMoney(SusuPrice));
					ShowPlayerDialog(playerid, DIALOG_MILK_BUY, DIALOG_STYLE_INPUT, "Buy Milk", mstr, "Buy", "Cancel");
				}
				case 1:
				{
					if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pSusuolah] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Susu Olahan");
					new total = pData[playerid][pSusuolah];
					ShowProgressbar(playerid, "Menjual Susu..", total);
					ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					pData[playerid][pSusuolah] -= total;
					new str[500];
					format(str, sizeof(str), "Removed_%dx", total);
					ShowItemBox(playerid, "Susu_Olahan", str, 19569, total);
				    Inventory_Update(playerid);

					RemovePlayerAttachedObject(playerid, 9);
					AddPlayerSalary(playerid, "Job(Pemerah Susu Sapi)", jobpemerahprice);
					ShowNotifInfo(playerid, "Job(Pemerah Susu Sapi) telah masuk ke pending salary anda!", 10000);
					pData[playerid][pMeatProgres] = 0;
					pData[playerid][pJobTime] = 250;
					Susu += total;
					Server_Save();
				}
			}
		}
	}
	if(dialogid == DIALOG_MILK_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = PlayerHasItem(playerid, "Susu Olah") + amount;
			new value = amount * SusuPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Susu terlalu penuh di Inventory! Maximal 500.");
			if(pData[playerid][pMoney] < value) return Error(playerid, "Uang anda kurang.");
			if(Susu < amount) return Error(playerid, "Susu Olahan di stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pSusuolah] += amount;
			Susu -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Milk seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_IKAN_SELL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = amount - PlayerHasItem(playerid, "Ikan");
			new value = amount * FishPrice;
			if(total < 1) return Error(playerid, "Ikan anda kurang.");
			if(pData[playerid][pItuna] < 1) return Error(playerid, "Ikan anda kurang.");
			//if(Inventory_Count(playerid, "Ikan") < 1) return Error(playerid, "Ikan anda kurang.");
			GivePlayerMoneyEx(playerid, value);
			Inventory_Remove(playerid, "Ikan", amount);
			Food += amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil menjual "GREEN_E"%d "WHITE_E"Ikan seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == GUDANG_SACF)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, PDG_GANDUM, DIALOG_STYLE_LIST, "Gandum", "Ambil Gandum\nMasukan Gandum", "Select","Cancel");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, PDG_DAGING, DIALOG_STYLE_LIST, "Daging", "Ambil Daging\nMasukan Daging", "Select","Cancel");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, PDG_SUSU, DIALOG_STYLE_LIST, "Susu", "Ambil Susu\nMasukan Susu", "Select","Cancel");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, PDG_BIGBURGER, DIALOG_STYLE_LIST, "Burger", "Ambil Burger\nMasukan Burger", "Select","Cancel");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, PDG_ROTI, DIALOG_STYLE_LIST, "Roti", "Ambil Roti\nMasukan Roti", "Select","Cancel");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, PDG_STEAK, DIALOG_STYLE_LIST, "Steak", "Ambil Steak\nMasukan Steak", "Select","Cancel");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, PDG_MILK, DIALOG_STYLE_LIST, "Milk", "Ambil Milk\nMasukan Milk", "Select","Cancel");
				}
			}
		}
	}
	if(dialogid == PDG_GANDUM)
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Gandum: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgGandum]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 2;
					format(str, sizeof str,"Gandum: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgGandum]);
				}
			}
			ShowPlayerDialog(playerid, PDG_GANDUM2, DIALOG_STYLE_INPUT, "Gandum Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == PDG_GANDUM2)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgGandum] < amount) return Error(playerid, "Not Enough Gandum");

				if((pdgDATA[playerid][pdgGandum] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Gandum");

				pData[playerid][pWheat] += amount;
				pdgDATA[pid][pdgGandum] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d gandum from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah minimal 1");

				if(pData[playerid][pWheat] < amount) return Error(playerid, "Not Enough Gandum");

				pData[playerid][pWheat] -= amount;
				pdgDATA[pid][pdgGandum] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Gandum", amount);
			}
		}
	}
	if(dialogid == PDG_DAGING)
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Daging: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgDaging]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 2;
					format(str, sizeof str,"Daging: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgDaging]);
				}
			}
			ShowPlayerDialog(playerid, PDG_DAGING2, DIALOG_STYLE_INPUT, "Daging Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == PDG_DAGING2)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgDaging] < amount) return Error(playerid, "Not Enough Daging");

				if((pdgDATA[playerid][pdgDaging] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Daging");

				pData[playerid][pDaging] += amount;
				pdgDATA[pid][pdgDaging] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Daging from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah minimal 1");

				if(pData[playerid][pDaging] < amount) return Error(playerid, "Not Enough Daging");

				pData[playerid][pDaging] -= amount;
				pdgDATA[pid][pdgDaging] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Daging", amount);
			}
		}
	}
	if(dialogid == PDG_SUSU)
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Susu: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgSusuolah]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 2;
					format(str, sizeof str,"Susu: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgSusuolah]);
				}
			}
			ShowPlayerDialog(playerid, PDG_SUSU2, DIALOG_STYLE_INPUT, "Susu Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == PDG_SUSU2)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgSusuolah] < amount) return Error(playerid, "Not Enough Susu");

				if((pdgDATA[playerid][pdgSusuolah] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Daging");

				pData[playerid][pSusuolah] += amount;
				pdgDATA[pid][pdgSusuolah] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Susu from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah minimal 1");

				if(pData[playerid][pSusuolah] < amount) return ErrorMsg(playerid, "Not Enough Susu");

				pData[playerid][pSusuolah] -= amount;
				pdgDATA[pid][pdgSusuolah] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Susu", amount);
			}
		}
	}
	if(dialogid == PDG_BIGBURGER)
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Burger: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgBurger]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 2;
					format(str, sizeof str,"Burger: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgBurger]);
				}
			}
			ShowPlayerDialog(playerid, PDG_BIGBURGER2, DIALOG_STYLE_INPUT, "Burger Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == PDG_BIGBURGER2)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgBurger] < amount) return Error(playerid, "Not Enough Burger");

				if((pdgDATA[playerid][pdgBurger] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Daging");

				pData[playerid][pBurger] += amount;
				pdgDATA[pid][pdgBurger] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Burger from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah minimal 1");

				if(pData[playerid][pBurger] < amount) return ErrorMsg(playerid, "Not Enough Burger");

				pData[playerid][pBurger] -= amount;
				pdgDATA[pid][pdgBurger] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Burger", amount);
			}
		}
	}
	if(dialogid == PDG_ROTI)
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Roti: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgRoti]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 2;
					format(str, sizeof str,"Roti: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgRoti]);
				}
			}
			ShowPlayerDialog(playerid, PDG_ROTI2, DIALOG_STYLE_INPUT, "Roti Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == PDG_ROTI2)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgRoti] < amount) return Error(playerid, "Not Enough Roti");

				if((pdgDATA[playerid][pdgRoti] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Daging");

				pData[playerid][pRoti] += amount;
				pdgDATA[pid][pdgRoti] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Roti from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah minimal 1");

				if(pData[playerid][pRoti] < amount) return ErrorMsg(playerid, "Not Enough Burger");

				pData[playerid][pRoti] -= amount;
				pdgDATA[pid][pdgRoti] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Roti", amount);
			}
		}
	}
	if(dialogid == PDG_STEAK)
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Steak: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgSteak]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 2;
					format(str, sizeof str,"Steak: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgSteak]);
				}
			}
			ShowPlayerDialog(playerid, PDG_STEAK2, DIALOG_STYLE_INPUT, "Steak Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == PDG_STEAK2)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgSteak] < amount) return Error(playerid, "Not Enough Steak");

				if((pdgDATA[playerid][pdgSteak] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Daging");

				pData[playerid][pSteak] += amount;
				pdgDATA[pid][pdgSteak] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You'pSteak successfully withdraw %d Steak from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah minimal 1");

				if(pData[playerid][pSteak] < amount) return ErrorMsg(playerid, "Not Enough Burger");

				pData[playerid][pSteak] -= amount;
				pdgDATA[pid][pdgSteak] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Steak", amount);
			}
		}
	}
	if(dialogid == PDG_MILK)
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Milk: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgMilk]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 2;
					format(str, sizeof str,"Milk: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgMilk]);
				}
			}
			ShowPlayerDialog(playerid, PDG_MILK2, DIALOG_STYLE_INPUT, "Milk Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == PDG_MILK2)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgMilk] < amount) return Error(playerid, "Not Enough Milk");

				if((pdgDATA[playerid][pdgMilk] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Daging");

				//Inventory_Add(playerid, "Milk", 19630, amount);
				pData[playerid][pMilks] += amount;
				pdgDATA[pid][pdgMilk] -= amount;
				new str[500];
				format(str, sizeof(str), "Received_%dx", amount);
				ShowItemBox(playerid, "Milk", str, 19630, 2);
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Milk from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Jumlah minimal 1");

				if(pData[playerid][pMilks] < amount) return ErrorMsg(playerid, "Not Enough Burger");

				pData[playerid][pMilks] -= amount;
				pdgDATA[pid][pdgMilk] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Milk", amount);
			}
		}
	}
	if(dialogid == DIALOG_COOKING_SACF)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFaction] != 5)
						return ErrorMsg(playerid, "You must be part of a Pedagang faction.");

					if(pData[playerid][pRoti] < 20) return ErrorMsg(playerid, "Kamu Tidak ada Roti. MIN : 20 Roti");
					if(pData[playerid][pDaging] < 10) return ErrorMsg(playerid, "Kamu Tidak ada Daging. MIN : 10 Daging");

					pData[playerid][pRoti] -= 20;
					pData[playerid][pDaging] -= 10;
					pData[playerid][pBurgerP] += 10;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda memulai membuat burger!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					pData[playerid][pMasak] = SetTimerEx("cookingsacf", 1000, true, "i", playerid);
					//Showbar(playerid, 20, "MEMBUAT BURGER", "cookingsacf");
					ShowProgressbar(playerid, "MEMBUAT BURGER", 20);
				}
				case 1:
				{
					if(pData[playerid][pFaction] != 5)
						return ErrorMsg(playerid, "Anda Tidak Bisa Mengakses ini.");

					//if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pWheat] < 10) return ErrorMsg(playerid, "Kamu Tidak ada Gandum. MIN : 20 Gandum");
					//if(Inventory_Count(playerid, "Gandum") < 10) return ShowNotifError(playerid, "Kamu Tidak ada Gandum. MIN : 10 Gandum", 10000);

					pData[playerid][pWheat] -= 10;
					pData[playerid][pRoti] += 10;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda memulai membuat roti!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					pData[playerid][pMasak] = SetTimerEx("cookingsacf", 1000, true, "i", playerid);
					//Showbar(playerid, 20, "MEMBUAT ROTI", "cookingsacf");
					ShowProgressbar(playerid, "MEMBUAT ROTI", 20);
				}
				case 2:
				{

					if(pData[playerid][pFaction] != 5)
						return ErrorMsg(playerid, "Anda Tidak Bisa Mengakses ini.");

					if(pData[playerid][pDaging] < 15) return ErrorMsg(playerid, "Kamu Tidak ada Daging. MIN : 15 Daging");

					pData[playerid][pDaging] -= 15;
					pData[playerid][pSteak] += 5;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda memulai membuat steak!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					pData[playerid][pMasak] = SetTimerEx("cookingsacf", 1000, true, "i", playerid);
					//Showbar(playerid, 20, "MEMBUAT STEAK", "cookingsacf");
					ShowProgressbar(playerid, "MEMBUAT STEAK", 20);
				}
				case 3:
				{
					if(pData[playerid][pFaction] != 5)
						return ErrorMsg(playerid, "Anda Tidak Bisa Mengakses ini.");

					if(pData[playerid][pSusuolah] < 10) return ErrorMsg(playerid, "Kamu Tidak ada Susu Olahan. MIN : 10 Susu Olahan");

					pData[playerid][pSusuolah] -= 10;
					pData[playerid][pMilks] += 10;
					//Inventory_Remove(playerid, "Susu Olah", 10);
					//Inventory_Add(playerid, "Milk", 19570, 10);

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda memulai membuat susu!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					pData[playerid][pMasak] = SetTimerEx("cookingsacf", 1000, true, "i", playerid);
					//Showbar(playerid, 20, "MEMBUAT SUSU", "cookingsacf");
					ShowProgressbar(playerid, "MEMBUAT SUSU", 20);
				}
			}
		}
	}
	if(dialogid == DIALOG_CALL_911)
	{
		if(response)
		{
			ServiceType[playerid] = listitem;
			if(ServiceIndex[playerid] == 1) ServiceIndex[playerid] = 2; SendClientMessage(playerid, 0x1394BFFF, "911 Dispatch: OK, Tell us more about what's going on.");
		}
		else
		{
			ServiceIndex[playerid] = 0;
			ServiceRequest[playerid] = 0;
			SendClientMessage(playerid, 0x1394BFFF, "911 Dispatch: Alright we will cancel our units. Thank you.");
		    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		    RemovePlayerAttachedObject(playerid, 3);
		}
	}
	if(dialogid == DIALOG_MDC_911)
	{
		if(response)
		{
			new count;
			PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
			forex(i, MAX_EMERGENCY) if(EmergencyData[i][emgExists])
			{
				if(EmergencyData[i][emgSector] == ReturnSector(playerid) && count++ == listitem)
				{
					pData[playerid][pListitem] = i;
					ShowPlayerDialog(playerid, DIALOG_MDC_911_MENU, DIALOG_STYLE_LIST, "MDC - 911 Menu", "Show Details\nRespond Report\nRemove Report", "Select", "Return");
				}		
			}	
		}
	}
	if(dialogid == DIALOG_MDC_911_MENU)
	{
		if(response)
		{
			new id = pData[playerid][pListitem];
			PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
			if(listitem == 0)
			{
				ShowEmergencyDetails(playerid, id);
			}
			if(listitem == 1)
			{
				SendFactionMessage(1, COLOR_RADIO, "[911] %s %s is now responding 911 report with problem %s", GetFactionRank(playerid), ReturnName(playerid), GetProblemType(EmergencyData[id][emgSector], EmergencyData[id][emgType]));
				SendFactionMessage(3, COLOR_RADIO, "[911] %s %s is now responding 911 report with problem %s", GetFactionRank(playerid), ReturnName(playerid), GetProblemType(EmergencyData[id][emgSector], EmergencyData[id][emgType]));
				SendClientMessageEx(playerid, COLOR_RADIO, "[MDC] {FFFFFF}You have respond to emergency call with problem {FFFF00}%s", GetProblemType(EmergencyData[id][emgSector], EmergencyData[id][emgType]));
				SendClientMessageEx(playerid, COLOR_RADIO, "[MDC] {FFFFFF}Location: %s | Name: %s | Number: %d", EmergencyData[id][emgLocation], EmergencyData[id][emgIssuerName], EmergencyData[id][emgNumber]);
				Emergency_Delete(id);
			}
			if(listitem == 2)
			{
				SendClientMessageEx(playerid, COLOR_RADIO, "[MDC] {FFFFFF}Successfully remove selected emergency call.");
				Emergency_Delete(id);
			}
		}
	}
	if(dialogid == DIALOG_PAYBILL)
	{
		if(response)
		{
			new step = 0, idtag;
			new bt[128];
			foreach(new ib: tagihan)
			{
				if(ib != -1)
				{
					if(bilData[ib][bilTarget] == pData[playerid][pID])
					{
						if(step == listitem)
						{
							idtag = ib;
						}
						step++;
					}
				}
			}
			if(pData[playerid][pBankMoney] < bilData[idtag][bilammount])
			{
				Error(playerid, "your bank money is not enough");
			}
			else
			{
			pData[playerid][pBankMoney] -= bilData[idtag][bilammount];
			Info(playerid, "You paid bill %s for %s", bilData[idtag][bilName], FormatMoney(bilData[idtag][bilammount]));
			SendFactionMessage(bilData[idtag][bilType], COLOR_WHITE, ""LB_E"[Pay Invoice] "WHITE_E"%s Telah membayar invoice "YELLOW_E"%s "WHITE_E"sebesar "GREEN_E"%s", bilData[idtag][billTargetName], bilData[idtag][bilName], FormatMoney(bilData[idtag][bilammount]));
			Iter_Remove(tagihan, idtag);
			mysql_format(g_SQL, bt, sizeof(bt), "DELETE FROM `bill` WHERE `bid`='%d'", idtag);
			mysql_tquery(g_SQL, bt);
			}
		}
		else
		{	
			return callcmd::nonono(playerid, "");
		}
		return 1;
	}
	if(dialogid == DIALOG_FMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					static
						userid = -1;

					if(!IsPlayerNearPlayer(playerid, userid, 3.0))
					{
						ShowNotifInfo(playerid, "ComingSoon", 10000);
					}
					return 1;
				}
				case 1:
				{
					ShowNotifInfo(playerid, "ComingSoon", 10000);

					return 1;
				}
				case 2:
				{
					ShowNotifInfo(playerid, "ComingSoon", 10000);

					return 1;
				}
				case 3:
				{
					ShowNotifInfo(playerid, "ComingSoon", 10000);
					
					return 1;
				}
				case 4:
				{
					static
						userid = -1;

					if(!IsPlayerNearPlayer(playerid, userid, 3.0))
					{
						new rseat = RandomEx(2,4);
						new vehicleid = GetNearestVehicleToPlayer(playerid, 3.0, false);
						new seatid = GetAvailableSeat(vehicleid, rseat);

						if(seatid == -1)
							return ShowNotifError(playerid, "There are no more seats remaining.", 10000);

						new
						string[64];

						format(string, sizeof(string), "You've been ~r~detained~w~ by %s.", ReturnName(playerid));
						TogglePlayerControllable(userid, 0);

						PutPlayerInVehicle(userid, vehicleid, seatid);

						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens the door and places %s into the vehicle.", ReturnName(playerid), ReturnName(userid));
						InfoTD_MSG(userid, 3500, string);
					}

					return 1;
				}
				case 5:
				{
					static
						userid = -1;

					if(!IsPlayerNearPlayer(playerid, userid, 3.0))
					{
						new vehicleid = GetNearestVehicleToPlayer(playerid, 3.0, false);

						if(IsPlayerInVehicle(userid, vehicleid))
						{
							TogglePlayerControllable(userid, 1);

							RemoveFromVehicle(userid);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens the door and pulls %s out the vehicle.", ReturnName(playerid), ReturnName(userid));
						}
					}

					return 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_STREAMER_CONFIG)
	{
		if(response)
		{
			new config[] = {1000, 600, 400, 100};
			new const confignames[][24] = {"High", "Medium", "Low", "Potato"};

			Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, config[listitem], playerid);
			Servers(playerid, "You have adjusted maximum streamed object configuration to {FFFF00}%s", confignames[listitem]);
			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		}
	}
	if(dialogid == DIALOG_INVOICE)
	{
		if(response)
		{
			new count;
			PlayerPlaySound(playerid, MDC_SELECT, 0, 0, 0);
			forex(i, MAX_BILLS)
			{
				if(bilData[i][bilType] == ReturnFa(playerid) && count++ == listitem)
				{
					pData[playerid][pListitem] = i;
					ShowInvoiceDetails(playerid, i);
				}		
			}
		}
	}
	if(dialogid == DIALOG_ASETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::togreport(playerid);
				}
				case 1:
				{
					return callcmd::togask(playerid);
				}
				case 2:
				{
					return callcmd::togadminchat(playerid);
				}
				case 3:
				{
					return callcmd::togwt(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUY_VEHICLE)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                	ShowPlayerDialog(playerid, DIALOG_BUYPVCP, DIALOG_STYLE_LIST, "{7fffd4}SHOWROOM Konoha", "Motorcycle\nMobil\nKendaraan Unik\nKendaraan Job", "Select", "Cancel");
                }
                case 1:
                {
                   new str[1024];
                   format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days",
                   	GetVehicleModelName(414), 
                   	GetVehicleModelName(455), 
                   	GetVehicleModelName(456),
                   	GetVehicleModelName(498),
                   	GetVehicleModelName(499),
                   	GetVehicleModelName(609),
                   	GetVehicleModelName(478),
                   	GetVehicleModelName(422),
                   	GetVehicleModelName(543),
                   	GetVehicleModelName(554),
                   	GetVehicleModelName(525),
                   	GetVehicleModelName(438),
                   	GetVehicleModelName(420)
                   	);

                   ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARS, DIALOG_STYLE_TABLIST_HEADERS, "Rent Job Cars", str, "Rent", "Close");
                }
            }
        }
    }
    if(dialogid == DIALOG_AMOUNT)
	{
		if (response)
		{
			new str[125], jumlah;
			if(sscanf(inputtext, "p</>d", jumlah)) {
				ShowPlayerDialog(playerid, DIALOG_AMOUNT, DIALOG_STYLE_INPUT, "Konoha - {ffffff}Jumlah inv", "Kesalahan! Tidak sah\nMasukan jumlah item minimal 1 sampai 1jt", "Oke", "Batal");
			}
			else if(jumlah < 1 || jumlah > 100000) {
				ShowPlayerDialog(playerid, DIALOG_AMOUNT, DIALOG_STYLE_INPUT, "Konoha - {ffffff}Jumalah inv", "Kesalahan! Tidak sah\nMasukan jumlah item minimal 1 sampai 1jt", "Oke", "Batal");
			}
			pData[playerid][pGiveAmount] = strval(inputtext);
			format(str, sizeof(str), "%s", inputtext);
			PlayerTextDrawSetString(playerid, INVINFO[playerid][6], str);
		}
	}
 	if(dialogid == DIALOG_GIVE)
	{
		if (response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			new itemid = pData[playerid][pSelectItem];
			new value = pData[playerid][pGiveAmount];

			CallLocalFunction("OnPlayerGiveInvItem", "ddds[128]d", playerid, p2, itemid, InventoryData[playerid][itemid][invItem], value);
		}
	}
	if(dialogid == DIALOG_TAKE)
	{
		if(response)
		{
  			new id = GetPlayerListitemValue(playerid, listitem);

			CallLocalFunction("TakePlayerItem", "dds[128]", playerid, id, DroppedItems[id][droppedItem]);
		}
	}
	if(dialogid == DIALOG_GOTOPUP)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "Anda tidak memiliki uang di bank.");
		if(amount < 50) return ErrorMsg(playerid, "Minimal topup $50!");

		else
		{
			new query[512], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - amount);
			pData[playerid][pGopay] += amount;
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);

			new AtmInfo[560];
	   		format(AtmInfo,1000,"%s", FormatMoney(pData[playerid][pGopay]));
			TextDrawSetString(APKGOJEK[28], AtmInfo);
			TextDrawShowForPlayer(playerid, APKGOJEK[28]);

			format(lstr, sizeof(lstr), "Anda berhasil topup gopay sebanyak %s", FormatMoney(amount));
			SuccesMsg(playerid, lstr);
		}
	}
	if(dialogid == DIALOG_GOJEK)
    {
		if(response)
		{
		    new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
            SendFactionMessage(6, COLOR_GREEN, "[GoJek] "WHITE_E"Orderan masuk atas nama %s", ReturnName(playerid));
	    	SendFactionMessage(6, COLOR_WHITE, "[Details] No.HP: %d // Lokasi: %s - Tujuan: %s", pData[playerid][pPhone], GetLocation(x, y, z), inputtext);
		}
	}
	if(dialogid == DIALOG_GOCAR)
    {
		if(response)
		{
		    new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
            SendFactionMessage(6, COLOR_GREEN, "[GoCar] "WHITE_E"Orderan masuk atas nama %s", ReturnName(playerid));
	    	SendFactionMessage(6, COLOR_WHITE, "[Details] No.HP: %d // Lokasi: %s - Tujuan: %s", pData[playerid][pPhone], GetLocation(x, y, z), inputtext);
		}
	}
	if(dialogid == DIALOG_GOFOOD)
    {
		if(response)
		{
		    new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
            SendFactionMessage(6, COLOR_GREEN, "[GoFood] "WHITE_E"Orderan masuk atas nama %s", ReturnName(playerid));
	    	SendFactionMessage(6, COLOR_WHITE, "[Pesanan] %s", inputtext);
	    	SendFactionMessage(6, COLOR_WHITE, "[Details] No.HP: %d // Tujuan: %s", pData[playerid][pPhone], GetLocation(x, y, z));
		}
	}
	if(dialogid == DIALOG_WASSAP)
	{
		if(response)
		{
			switch(listitem)
			{
				//================[ CASE 0 ]=============
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_SHARELOC, DIALOG_STYLE_INPUT, "HandPhone - Shareloc", "Masukan id player yang akan anda kirimkan lokasi:", "Kirim", "Kembali");
				}
				//================[ CASE 1 ]=============
				case 1:
				{
				    ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "HandPhone - Message", "Masukan nomor yang akan anda kirimkan:", "Kirim", "Kembali");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SHARELOC)
	{
		if(response)
		{
			callcmd::shareloc(playerid, inputtext);
		}
	}
	if(dialogid == DIALOG_PHONE_SENDSMS)
	{
		if (response)
		{
		    new ph = strval(inputtext);

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Kembali");

		    foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == ph)
				{
		        	if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
		            	return ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Error: That number is not online right now.\n\nPlease enter the number that you wish to send a text message to:", "Dial", "Kembali");

		            ShowPlayerDialog(playerid, DIALOG_PHONE_TEXTSMS, DIALOG_STYLE_INPUT, "Text Message", "Please enter the message to send", "Send", "Kembali");
		        	pData[playerid][pContact] = ph;
		        }
		    }
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_TEXTSMS)
	{
		if (response)
		{
			if (isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_PHONE_TEXTSMS, DIALOG_STYLE_INPUT, "Text Message", "Error: Please enter a message to send.", "Send", "Kembali");

			new targetid = pData[playerid][pContact];
			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == targetid)
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", targetid, inputtext);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], inputtext);
					Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];

					pData[playerid][pPhoneCredit] -= 1;
				}
			}
		}
		else {
	        ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Submit", "Kembali");
		}
		return 1;
	}
	if(dialogid == DIALOG_SPAWNGEN)
	{
		if(response)
		{
			switch(listitem)
			{
				//Bandara
				case 0:
				{
					if(pData[playerid][pJail] == 1) return Error(playerid, "Anda Sedang Dipenjara");
					if(pData[playerid][pArrest] == 1) return Error(playerid, "Anda Sedang Dipenjara");
					
					//1685.7356,-2238.5923,13.5469,176.7719
					SetPlayerPos(playerid, 1685.7356,-2238.5923,13.5469);
					SetPlayerFacingAngle(playerid, 176.7719);
					SetCameraBehindPlayer(playerid);
					SetPlayerVirtualWorld(playerid, 0);
		   			SetPlayerInterior(playerid, 0);
					SuccesMsg(playerid, "Anda Spawn Di Bandara");
					TogglePlayerControllable(playerid, 1);
		            PlayerData[playerid][pPos][0] =  1685.7356,
					PlayerData[playerid][pPos][1] = -2238.5923,
					PlayerData[playerid][pPos][2] = 13.5469;
					PlayerData[playerid][pPos][3] = 176.7719;
					InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
					InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					SetTimerEx("SetPlayerCameraBehind", 2500, false, "i", playerid);
					return 1;
				}
				case 1:
				{
					if(pData[playerid][pJail] == 1) return Error(playerid, "Anda Sedang Dipenjara");
					if(pData[playerid][pArrest] == 1) return Error(playerid, "Anda Sedang Dipenjara");
					
					SetPlayerPos(playerid, 2780.0942,-2392.3618,37.2239);
		    		SetPlayerFacingAngle(playerid, 137.2742);
				    SuccesMsg(playerid, "Anda Spawn Di Pelabuhan Kumai");
					SetCameraBehindPlayer(playerid);
					TogglePlayerControllable(playerid, 1);
					SetPlayerVirtualWorld(playerid, 0);
		   			SetPlayerInterior(playerid, 0);
		   			PlayerData[playerid][pPos][0] = 2780.0942,
					PlayerData[playerid][pPos][1] = -2392.3618,
					PlayerData[playerid][pPos][2] = 37.2239;
					PlayerData[playerid][pPos][3] = 137.2742;
					InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
					InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					SetTimerEx("SetPlayerCameraBehind", 2500, false, "i", playerid);
					return 1;
				}
				case 2:
				{
					if(pData[playerid][pJail] == 1) return Error(playerid, "Anda Sedang Dipenjara");
					if(pData[playerid][pArrest] == 1) return Error(playerid, "Anda Sedang Dipenjara");
					
					if(pData[playerid][pFaction] == 1)
			        {
				        //pData[playerid][PilihSpawn] = 0;
				        //1550.6509,-1675.5555,15.5015,89.9024
					    SetPlayerPos(playerid, 1550.6509,-1675.5555,15.5015);
					    SetPlayerFacingAngle(playerid, 89.9024);
					    SuccesMsg(playerid, "Anda Spawn Di Kepolisian Konoha");
						SetCameraBehindPlayer(playerid);
						TogglePlayerControllable(playerid, 1);
						SetPlayerVirtualWorld(playerid, 0);
			   			SetPlayerInterior(playerid, 0);
			   			PlayerData[playerid][pPos][0] = 1550.6509,
						PlayerData[playerid][pPos][1] = -1675.5555,
						PlayerData[playerid][pPos][2] = 15.5015;
						PlayerData[playerid][pPos][3] = 89.9024;
						InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
						InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					}
					if(pData[playerid][pFaction] == 2)
			        {
				        //pData[playerid][PilihSpawn] = 0;
				        //1139.6361,-2037.1384,69.0078,90.1180
					    SetPlayerPos(playerid, 1130.9117,-2036.8796,69.0078);
					    SetPlayerFacingAngle(playerid, 90.1180);
					    SuccesMsg(playerid, "Anda Spawn Di kantor pemerintahan Konoha");
						SetCameraBehindPlayer(playerid);
						TogglePlayerControllable(playerid, 1);
						SetPlayerVirtualWorld(playerid, 0);
			   			SetPlayerInterior(playerid, 0);
			   			PlayerData[playerid][pPos][0] = 1130.9117,
						PlayerData[playerid][pPos][1] = -2036.8796,
						PlayerData[playerid][pPos][2] = 69.0078;
						PlayerData[playerid][pPos][3] = 90.1180;
						InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
						InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					}
					if(pData[playerid][pFaction] == 3)
			        {
				        //pData[playerid][PilihSpawn] = 0;
				        //1177.9443,-1323.3846,14.0957,267.7228
					    SetPlayerPos(playerid, 1177.9443,-1323.3846,14.0957);
					    SetPlayerFacingAngle(playerid, 267.7228);
					    SuccesMsg(playerid, "Anda Spawn Di Rumah Sakit Konoha");
						SetCameraBehindPlayer(playerid);
						TogglePlayerControllable(playerid, 1);
						SetPlayerVirtualWorld(playerid, 0);
			   			SetPlayerInterior(playerid, 0);
			   			PlayerData[playerid][pPos][0] = 1177.9443,
						PlayerData[playerid][pPos][1] = -1323.3846,
						PlayerData[playerid][pPos][2] = 14.0957;
						PlayerData[playerid][pPos][3] = 267.7228;
						InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
						InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					}
					if(pData[playerid][pFaction] == 4)
			        {
				        //pData[playerid][PilihSpawn] = 0;
				        //643.0523,-1360.7532,13.5887,93.6608
					    SetPlayerPos(playerid, 643.0523,-1360.7532,13.5887);
					    SetPlayerFacingAngle(playerid, 93.6608);
					    SuccesMsg(playerid, "Anda Spawn Di kantor berita Konoha");
						SetCameraBehindPlayer(playerid);
						TogglePlayerControllable(playerid, 1);
						SetPlayerVirtualWorld(playerid, 0);
			   			SetPlayerInterior(playerid, 0);
			   			PlayerData[playerid][pPos][0] = 643.0523,
						PlayerData[playerid][pPos][1] = -1360.7532,
						PlayerData[playerid][pPos][2] = 13.5887;
						PlayerData[playerid][pPos][3] = 93.6608;
						InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
						InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					}
					if(pData[playerid][pFaction] == 5)
			        {
				        //pData[playerid][PilihSpawn] = 0;
				        //1202.5819,-952.3196,42.9258,8.5301
					    SetPlayerPos(playerid, 1202.5819,-952.3196,42.9258);
					    SetPlayerFacingAngle(playerid, 8.5301);
					    SuccesMsg(playerid, "Anda Spawn Di Pedagang Konoha");
						SetCameraBehindPlayer(playerid);
						TogglePlayerControllable(playerid, 1);
						SetPlayerVirtualWorld(playerid, 0);
			   			SetPlayerInterior(playerid, 0);
			   			PlayerData[playerid][pPos][0] =  1202.5819,
						PlayerData[playerid][pPos][1] = -952.3196,
						PlayerData[playerid][pPos][2] = 42.9258;
						PlayerData[playerid][pPos][3] = 8.5301;
						InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
						InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					}
					if(pData[playerid][pFaction] == 6)
			        {
				        //pData[playerid][PilihSpawn] = 0;
				        //1224.3972,-1816.0796,16.5938,175.1182
					    SetPlayerPos(playerid, 1224.3972,-1816.0796,16.5938);
					    SetPlayerFacingAngle(playerid, 175.1182);
					    SuccesMsg(playerid, "Anda Spawn Di Gojek Konoha");
						SetCameraBehindPlayer(playerid);
						TogglePlayerControllable(playerid, 1);
						SetPlayerVirtualWorld(playerid, 0);
			   			SetPlayerInterior(playerid, 0);
			   			PlayerData[playerid][pPos][0] = 1224.3972,
						PlayerData[playerid][pPos][1] = -1816.0796,
						PlayerData[playerid][pPos][2] = 16.5938;
						PlayerData[playerid][pPos][3] = 175.1182;
						InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
						InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					}
					if(pData[playerid][pFaction] == 7)
			        {
				        //pData[playerid][PilihSpawn] = 0;
				        //-75.7975,-1573.5862,2.6430,41.9648
					    SetPlayerPos(playerid, 1799.2003,-2066.1726,13.5689);
					    SetPlayerFacingAngle(playerid, 3.9499);
					    SuccesMsg(playerid, "Anda Spawn Di Mekanik");
						SetCameraBehindPlayer(playerid);
						TogglePlayerControllable(playerid, 1);
						SetPlayerVirtualWorld(playerid, 0);
			   			SetPlayerInterior(playerid, 0);
			   			PlayerData[playerid][pPos][0] = 1799.2003,
						PlayerData[playerid][pPos][1] = -2066.1726,
						PlayerData[playerid][pPos][2] = 13.5689;
						PlayerData[playerid][pPos][3] = 3.9499;
						InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
						InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					}
					SetTimerEx("SetPlayerCameraBehind", 2500, false, "i", playerid);
					return 1;
				}
				case 3:
				{
					if(pData[playerid][pJail] == 1) return Error(playerid, "Anda Sedang Dipenjara");
					if(pData[playerid][pArrest] == 1) return Error(playerid, "Anda Sedang Dipenjara");
					
					SetPlayerInterior(playerid, pData[playerid][pInt]);
					SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
					SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
					SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
					SetCameraBehindPlayer(playerid);
					TogglePlayerControllable(playerid, 0);
					SetPlayerSpawn(playerid);
					LoadAnims(playerid);
					PlayerData[playerid][pPos][0] = pData[playerid][pPosX],
					PlayerData[playerid][pPos][1] = pData[playerid][pPosY],
					PlayerData[playerid][pPos][2] = pData[playerid][pPosZ];
					PlayerData[playerid][pPos][3] = pData[playerid][pPosA];
					InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
					InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
					SetTimerEx("SetPlayerCameraBehind", 2500, false, "i", playerid);
					return 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_VRM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					callcmd::lock(playerid, "");
				}
				case 1:
				{
				    callcmd::light(playerid, "");
				}
				case 2:
				{
				    callcmd::vstorage(playerid, "");
				}
				case 3:
				{
				    callcmd::hood(playerid, "");
				}
				case 4:
				{
				    callcmd::trunk(playerid, "");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SHOWKTP)
	{
		if (response)
		{
            new p2 = GetPlayerListitemValue(playerid, listitem);

   			new sext[40], AtmInfo[560];
			if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
		   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
		   	PlayerTextDrawSetString(p2, KTPValrise[playerid][10], AtmInfo);
			format(AtmInfo,1000,"%s", pData[playerid][pAge]);
			PlayerTextDrawSetString(p2, KTPValrise[playerid][15], AtmInfo);
			format(AtmInfo,1000,"%s", sext);
			PlayerTextDrawSetString(p2, KTPValrise[playerid][17], AtmInfo);
			format(AtmInfo,1000,"%s", pData[playerid][pTinggi]);
			PlayerTextDrawSetString(p2, KTPValrise[playerid][19], AtmInfo);

			for(new i = 0; i < 28; i++)
			{
				PlayerTextDrawShow(p2, KTPValrise[playerid][i]);
			}
			SetTimerEx("ktp",9000, false, "d", p2);
		    return 1;
		}
	}
	if(dialogid == DIALOG_SHOWSIM)
	{
		if (response)
		{
            new p2 = GetPlayerListitemValue(playerid, listitem);

   			new sext[40], AtmInfo[560];
			if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
		   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
		   	PlayerTextDrawSetString(p2, SIMVALRISE[playerid][18], AtmInfo);
			format(AtmInfo,1000,"%s", pData[playerid][pAge]);
			PlayerTextDrawSetString(p2, SIMVALRISE[playerid][29], AtmInfo);
			format(AtmInfo,1000,"%s", sext);
			PlayerTextDrawSetString(p2, SIMVALRISE[playerid][22], AtmInfo);

			for(new i = 0; i < 30; i++)
			{
				PlayerTextDrawShow(p2, SIMVALRISE[playerid][i]);
			}
			SetTimerEx("simisimi",9000, false, "d", p2);
		    return 1;
		}
	}
	if(dialogid == DIALOG_SHOWBPJS)
	{
		if (response)
		{
            new p2 = GetPlayerListitemValue(playerid, listitem);

   			new AtmInfo[560];
		   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
		   	PlayerTextDrawSetString(p2, BPJSTD[playerid][12], AtmInfo);
			format(AtmInfo,1000,"%s", pData[playerid][pAge]);
			PlayerTextDrawSetString(p2, BPJSTD[playerid][15], AtmInfo);

			for(new i = 0; i < 19; i++)
			{
				PlayerTextDrawShow(p2, BPJSTD[playerid][i]);
			}
			SetTimerEx("bpjs",9000, false, "d", p2);
		    return 1;
		}
	}
	if(dialogid == DIALOG_SHOWSKS)
	{
		if (response)
		{
            new p2 = GetPlayerListitemValue(playerid, listitem);

   			new sext[40], AtmInfo[560];
			if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
		   	format(AtmInfo,1000,"%s", pData[playerid][pName]);
		   	PlayerTextDrawSetString(p2, SKSTD[playerid][23], AtmInfo);
		   	format(AtmInfo,1000,"%d", pData[playerid][pPhone]);
			PlayerTextDrawSetString(p2, SKSTD[playerid][24], AtmInfo);
		   	format(AtmInfo,1000,"%s", sext);
			PlayerTextDrawSetString(p2, SKSTD[playerid][26], AtmInfo);
			format(AtmInfo,1000,"%s", pData[playerid][pAge]);
			PlayerTextDrawSetString(p2, SKSTD[playerid][25], AtmInfo);
			format(AtmInfo,1000,"%s", GetJobName(pData[playerid][pJob]));
			PlayerTextDrawSetString(playerid, SKSTD[playerid][27], AtmInfo);
			format(AtmInfo,1000,"%s Cm", pData[playerid][pTinggi]);
			PlayerTextDrawSetString(p2, SKSTD[playerid][28], AtmInfo);

			for(new i = 0; i < 34; i++)
			{
				PlayerTextDrawShow(p2, SKSTD[playerid][i]);
			}
			SetTimerEx("sks",9000, false, "d", p2);
		    return 1;
		}
	}
	if(dialogid == DIALOG_SHOWSKCK)
	{
		if (response)
		{
            new p2 = GetPlayerListitemValue(playerid, listitem);

   			new sext[40], AtmInfo[560];
			if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
		   	format(AtmInfo,1000,"Nama : %s", pData[playerid][pName]);
		   	PlayerTextDrawSetString(p2, SKCKTD[playerid][7], AtmInfo);
		   	format(AtmInfo,1000,"Jenis Kelamin : %s", sext);
			PlayerTextDrawSetString(p2, SKCKTD[playerid][8], AtmInfo);
			format(AtmInfo,1000,"Tempat tanggal lahir : LS, %s", pData[playerid][pAge]);
			PlayerTextDrawSetString(p2, SKCKTD[playerid][9], AtmInfo);
			format(AtmInfo,1000,"Pekerjaan : %s", GetJobName(pData[playerid][pJob]));
			PlayerTextDrawSetString(p2, SKCKTD[playerid][11], AtmInfo);

			for(new i = 0; i < 27; i++)
			{
				PlayerTextDrawShow(p2, SKCKTD[playerid][i]);
			}
			SetTimerEx("skck",9000, false, "d", p2);
		    return 1;
		}
	}
	//BISNIS GENZO
	if(dialogid == BISNIS_BUYPROD2)
	{
		static
        bizid = -1,
        price;

		if((bizid = pData[playerid][pInBiz]) != -1 && response)
		{
			price = bData2[bizid][bP2][listitem];

			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Not enough money!");

			if(bData2[bizid][bProd2] < 1)
				return ErrorMsg(playerid, "This business is out of stock product.");
				
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(bData2[bizid][bType2] == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+30);
						pData[playerid][pHunger] += 35;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+45);
						pData[playerid][pHunger] += 50;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);

						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+70);
						pData[playerid][pHunger] += 75;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);

						pData[playerid][pEnergy] += 60;
						//SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli minuman seharga %s.", ReturnName(playerid), FormatMoney(price));
						//SetPVarInt(playerid, "UsingSprunk", 1);
					}
				}
			}
			else if(bData2[bizid][bType2] == 2)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSnack]++;
						ShowItemBox(playerid, "Nasi_Padang", "Received_1x", 2663, 3);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli nasi padang seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSprunk]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Sprunk seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGas]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Gas Fuel seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBandage]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Perban seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 4:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMineral]++;
						ShowItemBox(playerid, "Air_Mineral", "Received_1x", 1484, 3);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Air Mineral seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);

						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 5:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pCig]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Cigarette seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);

						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData2[bizid][bType2] == 3)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						switch(pData[playerid][pGender])
						{
							case 1: ShowModelSelectionMenu(playerid, MaleSkins, "Choose your skin");
							case 2: ShowModelSelectionMenu(playerid, FemaleSkins, "Choose your skin");
						}
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						new string[248];
						if(pToys[playerid][0][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 1\n");
						}
						else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

						if(pToys[playerid][1][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 2\n");
						}
						else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

						if(pToys[playerid][2][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 3\n");
						}
						else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

						if(pToys[playerid][3][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 4\n");
						}
						else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");
						ShowPlayerDialog(playerid, DIALOG_TOYBUY, DIALOG_STYLE_LIST, "Konoha - Aksesoris", string, "Pilih", "Batal");
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMask] = 1;
						pData[playerid][pMaskID] = random(90000) + 10000;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli mask seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHelmet] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Helmet seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData2[bizid][bType2] == 4)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 1, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Brass Knuckles seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
			
						if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7 || pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 4, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Knife seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData2[bizid][bProd2]--;
							bData2[bizid][bMoney2] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return ErrorMsg(playerid, "Job farmer & Ayam only!");
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 5, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Baseball Bat seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 6, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Shovel seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData2[bizid][bProd2]--;
							bData2[bizid][bMoney2] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return ErrorMsg(playerid, "Job miner only!");
					}
					case 4:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pJob] == 3 || pData[playerid][pJob2] == 3)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 9, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Chainsaw seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData2[bizid][bProd2]--;
							bData2[bizid][bMoney2] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return ErrorMsg(playerid, "Job lumber jack only!");
					}
					case 5:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 15, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Cane seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 6:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pFishTool] > 2) return ErrorMsg(playerid, "You only can get 3 fish tool!");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pFishTool]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli pancingan seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 7:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWorm] += 2;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 2 umpan cacing seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData2[bizid][bType2] == 5)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGPS] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli GPS seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

						GivePlayerMoneyEx(playerid, -price);
						new query[128], rand = RandomEx(1111, 9888);
						new phone = rand+pData[playerid][pID];
						mysql_format(g_SQL, query, sizeof(query), "SELECT phone FROM players WHERE phone='%d'", phone);
						mysql_tquery(g_SQL, query, "PhoneNumber", "id", playerid, phone);
						pData[playerid][pPhone] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli phone seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						//Bisnis_Save2(bizid);
						
						new queryy[128];
						mysql_format(g_SQL, queryy, sizeof(queryy), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, queryy);
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneCredit] += 20;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 20 phone credit seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneBook] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah phone book seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 4:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWT] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah walkie talkie seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 5:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pKuota] += 10000000;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah kuota 10gb seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 6:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBoombox] += 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah boombox seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData2[bizid][bProd2]--;
						bData2[bizid][bMoney2] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}	
		}
		return 1;
	}
	if(dialogid == BISNIS_EDITPROD2)
	{
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, BISNIS_PRICESET2, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Kembali");
			}
			else
				return callcmd::bm2(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_PRICESET2)
	{
		static
        item[40];
		new bizid = pData[playerid][pInBiz];
		if(Player_OwnsBisnis2(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET2, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Kembali");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 5000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5,000):", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET2, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Kembali");
					return 1;
				}
				bData[bizid][bP][pData[playerid][pProductModify]] = strval(inputtext);
				Bisnis_Save2(bizid);

				Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				Bisnis_ProductMenu2(playerid, bizid);
			}
			else
			{
				Bisnis_ProductMenu2(playerid, bizid);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SELL_BISNISS2)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell bisnis id: %d", GetPVarInt(playerid, "SellingBisnis"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_BISNIS2, DIALOG_STYLE_MSGBOX, "Sell Bisnis", str, "Sell", "Batal");
	}
	if(dialogid == DIALOG_SELL_BISNIS2)
	{
		if(response)
		{
			new bid = GetPVarInt(playerid, "SellingBisnis"), price;
			price = bData2[bid][bPrice2] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual bisnis id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", bid, FormatMoney(price));
			new str[150];
			format(str,sizeof(str),"[BIZ]: %s menjual business id %d seharga %s!", GetRPName(playerid), bid, FormatMoney(price));
			LogServer("Property", str);
			Bisnis_Reset2(bid);
			Bisnis_Save2(bid);
			Bisnis_Refresh2(bid);
		}
		DeletePVar(playerid, "SellingBisnis");
		return 1;
	}
	if(dialogid == DIALOG_MY_BISNIS2)
	{
		if(!response) return true;
		SetPVarInt(playerid, "ClickedBisnis", ReturnPlayerBisnisID2(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, BISNIS_INFO2, DIALOG_STYLE_LIST, "{0000FF}My Business", "Show Information\nTrack Bisnis", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == BISNIS_INFO2)
	{
		if(!response) return true;
		new bid = GetPVarInt(playerid, "ClickedBisnis");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(bData2[bid][bLocked2] == 1)
				{
					lock = "{FF0000}Locked";
				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(bData2[bid][bType2] == 1)
				{
					type = "Fast Food";
			
				}
				else if(bData2[bid][bType2] == 2)
				{
					type = "Market";
				}
				else if(bData2[bid][bType2] == 3)
				{
					type = "Clothes";
				}
				else if(bData2[bid][bType2] == 4)
				{
					type = "Equipment";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "Bisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Price: %s\nBisnis Type: %s\nBisnis Status: %s\nBisnis Product: %d",
				bid, bData2[bid][bOwner2], bData2[bid][bName2], FormatMoney(bData2[bid][bPrice2]), type, lock, bData2[bid][bProd2]);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Bisnis Info", line9, "Tutup","");
			}
			case 1:
			{
				pData[playerid][pTrackBisnis] = 1;
				SetPlayerRaceCheckpoint(playerid,1, bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan bisnis anda!");
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_MENU2)
	{
		new bid = pData[playerid][pInBiz];
		new lock[128];
		if(bData2[bid][bLocked2] == 1)
		{
			lock = "Locked";
		}
		else
		{
			lock = "Unlocked";
		}
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new mstr[248], lstr[512];
					format(mstr,sizeof(mstr),"Bisnis ID %d", bid);
					format(lstr,sizeof(lstr),"Bisnis Name:\t%s\nBisnis Locked:\t%s\nBisnis Product:\t%d\nBisnis Vault:\t%s", bData2[bid][bName2], lock, bData2[bid][bProd2], FormatMoney(bData2[bid][bMoney2]));
					ShowPlayerDialog(playerid, BISNIS_INFO2, DIALOG_STYLE_TABLIST, mstr, lstr,"Kembali","Tutup");
				}
				case 1:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Nama sebelumnya: %s\n\nMasukkan nama bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama bisnis", bData2[bid][bName2]);
					ShowPlayerDialog(playerid, BISNIS_NAME2, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Kembali");
				}
				case 2: ShowPlayerDialog(playerid, BISNIS_VAULT2, DIALOG_STYLE_LIST,"Bisnis Vault","Deposit\nWithdraw","Next","Kembali");
				case 3:
				{
					Bisnis_ProductMenu2(playerid, bid);
				}
				case 4:
				{
					if(bData2[bid][bProd2] > 100)
						return ErrorMsg(playerid, "Bisnis ini masih memiliki cukup produck.");
					if(bData2[bid][bMoney2] < 1000)
						return ErrorMsg(playerid, "Setidaknya anda mempunyai uang dalam bisnis anda senilai $1.000 untuk merestock product.");
					bData2[bid][bRestock2] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock product kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_INFO2)
	{
		if(response)
		{
			return callcmd::bm2(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_NAME2)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];

			if(!Player_OwnsBisnis2(playerid, pData[playerid][pInBiz])) return ErrorMsg(playerid, "You don't own this bisnis.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis tidak di perbolehkan kosong!\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData2[bid][bName2]);
				ShowPlayerDialog(playerid, BISNIS_NAME2, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Kembali");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData2[bid][bName2]);
				ShowPlayerDialog(playerid, BISNIS_NAME2, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Kembali");
				return 1;
			}
			format(bData2[bid][bName2], 32, ColouredText(inputtext));

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET name='%s' WHERE ID='%d'", bData2[bid][bName2], bid);
			mysql_tquery(g_SQL, query);

			Bisnis_Refresh2(bid);

			Servers(playerid, "Bisnis name set to: \"%s\".", bData[bid][bName]);
		}
		else return callcmd::bm2(playerid, "\0");
		return 1;
	}
	if(dialogid == BISNIS_VAULT2)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam bisnis ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, BISNIS_DEPOSIT2, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Kembali");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Business Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam bisnis ini", FormatMoney(bData2[pData[playerid][pInBiz]][bMoney2]));
					ShowPlayerDialog(playerid, BISNIS_WITHDRAW2, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Kembali");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_WITHDRAW2)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > bData2[bid][bMoney2])
				return ErrorMsg(playerid, "Invalid amount specified!");

			bData2[bid][bMoney2] -= amount;
			
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET money='%d' WHERE ID='%d'", bData2[bid][bMoney2], bid);
			mysql_tquery(g_SQL, query);

			GivePlayerMoneyEx(playerid, amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have withdrawn "GREEN_E"%s "WHITE_E"from the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT2, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Kembali");
		return 1;
	}
	if(dialogid == BISNIS_DEPOSIT2)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return ErrorMsg(playerid, "Invalid amount specified!");

			bData2[bid][bMoney2] += amount;

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET money='%d' WHERE ID='%d'", bData2[bid][bMoney2], bid);
			mysql_tquery(g_SQL, query);

			GivePlayerMoneyEx(playerid, -amount);
			
			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have deposit "GREEN_E"%s "WHITE_E"into the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT2, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Kembali");
		return 1;
	}
	if (dialogid == DIALOG_JOB_PETANI_MENGOLAHBAHAN) 
	{
        if (response) 
        {
            switch (listitem) 
            {
                case 0 :  
                {
                	if(pData[playerid][pPadi] < 4) return Error(playerid, "Kamu kekurangan bahan untuk membuat Beras");
                	if(pData[playerid][pKarungGoni] < 1) return Error(playerid, "Kamu kekurangan bahan untuk membuat Beras");
                	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");

                    ShowProgressbar(playerid, "Mengolah Padi", 4);
                	SetTimerEx("Beras", 4000, false, "d", playerid);
                    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 1, 1, 1, 0, 1);
                }
                case 1 :  
                {
                	if(pData[playerid][pCabai] < 4) return Error(playerid, "Kamu kekurangan bahan untuk membuat Sambal");
                	if(pData[playerid][pBotolBekas] < 1) return Error(playerid, "Kamu kekurangan bahan untuk membuat Sambal");
                	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");

                    ShowProgressbar(playerid, "Mengolah Cabai", 4);
                	SetTimerEx("Sambal", 4000, false, "d", playerid);
                    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 1, 1, 1, 0, 1);

                }
                case 2 :  
                {
                	if(pData[playerid][pTebu] < 4) return Error(playerid, "Kamu kekurangan bahan untuk membuat Gula");
                	if(pData[playerid][pKarungGoni] < 1) return Error(playerid, "Kamu kekurangan bahan untuk membuat Gula");
                	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");

                	ShowProgressbar(playerid, "Mengolah Tebu", 4);
                	SetTimerEx("Gula", 4000, false, "d", playerid);
                    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 1, 1, 1, 0, 1);
                }
                case 3 :  
                {
                	if(pData[playerid][pGaram] < 4) return Error(playerid, "Kamu kekurangan bahan untuk membuat Gula");
                	if(pData[playerid][pBotolBekas] < 1) return Error(playerid, "Kamu kekurangan bahan untuk membuat Gula");
                	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");

                    ShowProgressbar(playerid, "Mengolah Garam", 4);
                	SetTimerEx("Garam", 4000, false, "d", playerid);
                    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 1, 1, 1, 0, 1);
                }
            }
        }
    }
    if(dialogid == DIALOG_AYAMFILL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][AyamFillet] + amount;
			new value = amount * AyamFillPrice;
			if(amount < 0 || amount > 100) return ErrorMsg(playerid, "amount maximal 0 - 100.");
			if(total > 100) return ErrorMsg(playerid, "Ayam full in your inventory! max: 100kg.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(AyamFill < amount) return ErrorMsg(playerid, "ayam stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][AyamFillet] += amount;
			AyamFill -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"ayam seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_BULUAYAM)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pBulu] + amount;
			new value = amount * BuluAyamPrice;
			if(amount < 0 || amount > 100) return ErrorMsg(playerid, "amount maximal 0 - 100.");
			if(total > 100) return ErrorMsg(playerid, "Bulu full di inventory! max: 100kg.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(BuluAyam < amount) return ErrorMsg(playerid, "Bulu stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pBulu] += amount;
			BuluAyam -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Bulu seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	/*if (dialogid == DIALOG_SPRAYTAG_MODE) 
	{
        if (!response)
            return ShowTagSetup(playerid);

        new id = Tag_Create(playerid);

        if (id == INVALID_ITERATOR_SLOT)
            return Error(playerid, "This server cannot create more tags!");


        PlayerData[playerid][pEditing] = id;
        PlayerData[playerid][pEditType] = EDIT_TAG;
        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

        if (listitem == 0) 
        {
            ShowEditTextDraw(playerid);
            //EditDynamicObject(playerid, TagData[id][tagObject]);
        }
        if (listitem == 1) 
        {
            EditDynamicObject(playerid, TagData[id][tagObject]);
        }
    }
    if (dialogid == DIALOG_SPRAYTAG_TEXT) 
    {
        if (response) 
        {
            if (isnull(inputtext))
                return callcmd::tag(playerid, "create");

            if (strlen(inputtext) > 64)
                return Error(playerid, "Text length cannot more than 64 chars!"), callcmd::tag(playerid, "create"); //cmd_tag(playerid, "create");

            format(TagText[playerid], 64, inputtext);
            ShowTagSetup(playerid);

        }
    }
    if (dialogid == DIALOG_SPRAYTAG_FONT) 
    {
        if (!response)
            return ShowTagSetup(playerid);

        if (isnull(inputtext))
            return ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_FONT, DIALOG_STYLE_INPUT, "Tag - Font", "Please input the fontface name:", "Set", "Return");

        if (strlen(inputtext) > 24)
            return ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_FONT, DIALOG_STYLE_INPUT, "Tag - Font", "Please input the fontface name:", "Set", "Return");

        format(TagFont[playerid], 24, inputtext);
        ShowTagSetup(playerid);
    }
    if (dialogid == DIALOG_SPRAYTAG_SIZE) 
    {
        if (!response)
            return ShowTagSetup(playerid);

        if (isnull(inputtext))
            return ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_SIZE, DIALOG_STYLE_INPUT, "Tag - Font Size", "Please input the fontsize:\nNote: min 24 max 255!", "Set", "Return");

        if (!IsNumeric(inputtext))
            return ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_SIZE, DIALOG_STYLE_INPUT, "Tag - Font Size", "Please input the fontsize:\nNote: min 24 max 255!", "Set", "Return");

        if (strval(inputtext) < 24 || strval(inputtext) > 255)
            return ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_SIZE, DIALOG_STYLE_INPUT, "Tag - Font Size", "Please input the fontsize:\nNote: min 24 max 255!", "Set", "Return");

        TagSize[playerid] = strval(inputtext);
        ShowTagSetup(playerid);
    }
    if (dialogid == DIALOG_SPRAYTAG_COLOR) 
    {
        if (!response)
            return 1;

        if (isnull(inputtext))
            return ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_COLOR, DIALOG_STYLE_INPUT, "Tag - Color", "Please input the color for the tag:\nExample: 0xFFFFFFFF (white)", "Set", "Return");

        TagColor[playerid] = HexToInt(inputtext);
        ShowTagSetup(playerid);
    }
    if (dialogid == DIALOG_SPRAYTAG) 
    {
        if (!response)
            return 1;

        if (listitem == 0) 
        {
            ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_FONT, DIALOG_STYLE_INPUT, "Tag - Font", "Please input the fontface name:", "Set", "Return");
        }
        if (listitem == 1) 
        {
            ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_SIZE, DIALOG_STYLE_INPUT, "Tag - Font Size", "Please input the fontsize:\nNote: min 24 max 255!", "Set", "Return");
        }
        if (listitem == 2) 
        {
            if (TagBold[playerid] == 0) 
            {
                TagBold[playerid] = 1;
            } 
            else 
            {
                TagBold[playerid] = 0;
            }
            ShowTagSetup(playerid);
        }
        if (listitem == 3) 
        {
            ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_COLOR, DIALOG_STYLE_INPUT, "Tag - Color", "Please input the color for the tag:\nExample: 0xFFFFFFFF (white)", "Set", "Return");
        }
        if (listitem == 4) 
        {
            ShowPlayerDialog(playerid, DIALOG_SPRAYTAG_MODE, DIALOG_STYLE_LIST, "Tag - Edit Mode", "TextDraw Click\nClick n Drag", "Select", "Close");
        }
    }*/
	if(dialogid == DIALOG_BAHAMAS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Vodka
				{
					callcmd::belivodka1(playerid, "");
				}
				case 1: //ciu
				{
					callcmd::beliciu1(playerid, "");
				}
				case 2: //amer
				{
					callcmd::beliamer1(playerid, "");
				}
			}
		}
	}
	if(dialogid == DIALOG_PLAYERMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    new str[500], count = 0,String[500];
        			String="";
					foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) &&i!= playerid)
		   			{
						format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
		    			strcat(String, str);
		       			SetPlayerListitemValue(playerid, count++, i);
		          	}
		            if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		            else ShowPlayerDialog(playerid, DIALOG_IKAT, DIALOG_STYLE_LIST, "Ikat Pemain", String, "Pilih", "Tutup");
				}
				case 1:
				{
					new str[500], count = 0,String[500];
        			String="";
					foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) &&i!= playerid)
		   			{
						format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
		    			strcat(String, str);
		       			SetPlayerListitemValue(playerid, count++, i);
		          	}
		            if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		            else ShowPlayerDialog(playerid, DIALOG_LEPASIKAT, DIALOG_STYLE_LIST, "Lepas Ikatan", String, "Pilih", "Tutup");
				}
				case 2:
				{
					new str[500], count = 0,String[500];
        			String="";
					foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) &&i!= playerid)
		   			{
						format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
		    			strcat(String, str);
		       			SetPlayerListitemValue(playerid, count++, i);
		          	}
		            if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		            else ShowPlayerDialog(playerid, DIALOG_GELEDAH, DIALOG_STYLE_LIST, "Geledah Pemain", String, "Pilih", "Tutup");
				}
				case 3:
				{
				    new str[500], count = 0,String[500];
        			String="";
					foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) &&i!= playerid)
		   			{
						format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
		    			strcat(String, str);
		       			SetPlayerListitemValue(playerid, count++, i);
		          	}
		            if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		            else ShowPlayerDialog(playerid, DIALOG_AIRDROP, DIALOG_STYLE_LIST, "AirDrop", String, "Pilih", "Tutup");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_IKAT)
	{
		if (response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			CallLocalFunction("OnPlayerBorgol", "dd", playerid, p2);
		}
	}
	if(dialogid == DIALOG_LEPASIKAT)
	{
		if (response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			CallLocalFunction("OnPlayerUnBorgol", "dd", playerid, p2);
		}
	}
	if(dialogid == DIALOG_GELEDAH)
	{
		if (response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			CallLocalFunction("OnPlayerGeledah", "dd", playerid, p2);
		}
	}
	if(dialogid == DIALOG_AIRDROP)
	{
		if (response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			CallLocalFunction("OnPlayerGiveKontak", "dd", playerid, p2);
		}
	}
	if(dialogid == DIALOG_BUG)
	{
	    if(!response) return 1;
		if(response)
		{
			new String[212];
		    if(listitem == 0)
		    {
				foreach(new i : Player)
				{
					if(pData[i][pAdmin] > 0)
					{
						format(String,sizeof(String), "[STUCK]: {00FFFF}%s[id:%d] "YELLOW_E"Freeze bug while Spawn or Death.", ReturnName(playerid), playerid);
						SendClientMessage(playerid, COLOR_ARWIN, String);
					}
				}
				SendClientMessage(playerid, COLOR_ARWIN, "REPORTINFO: "WHITE_E"Report anda telah dikirim ke Administrator yang online");
				return 1;
			}
			if(listitem == 1)
			{
				foreach(new i : Player)
				{
					if(pData[i][pAdmin] > 0)
					{
						format(String,sizeof(String), "[STUCK]: {00FFFF}%s[id:%d] "YELLOW_E"Wrong World ID (WWID) (vw: %d, int: %d)",ReturnName(playerid), playerid, pData[playerid][pWorld], pData[playerid][pInt]);
						SendClientMessage(playerid, COLOR_ARWIN, String);
					}
				}
				SendClientMessage(playerid, COLOR_ARWIN, "REPORTINFO: "WHITE_E"Report anda telah dikirim ke Administrator yang online");
				return 1;
			}
			if(listitem == 2)
			{
				foreach(new i : Player)
				{
					if(pData[i][pAdmin] > 0)
					{
						format(String,sizeof(String), "[STUCK]: {00FFFF}%s[id:%d] "YELLOW_E"Stuck at someone property or entraance (vw: %d, int: %d)",ReturnName(playerid), playerid, pData[playerid][pWorld], pData[playerid][pInt]);
						SendClientMessage(playerid, COLOR_ARWIN, String);
					}
				}
				SendClientMessage(playerid, COLOR_ARWIN, "REPORTINFO: "WHITE_E"Report anda telah dikirim ke Administrator yang online");
				return 1;
			}
			if(listitem == 3)
			{
				foreach(new i : Player)
				{
					if(pData[i][pAdmin] > 0)
					{
						format(String,sizeof(String), "[STUCK]: {00FFFF}%s[id:%d] "YELLOW_E"Spawn at Blueberry (vw: %d, int: %d)",ReturnName(playerid), playerid, pData[playerid][pWorld], pData[playerid][pInt]);
						SendClientMessage(playerid, COLOR_ARWIN, String);
					}
				}
				SendClientMessage(playerid, COLOR_ARWIN, "REPORTINFO: "WHITE_E"Report anda telah dikirim ke Administrator yang online");
				return 1;
			}
			if(listitem == 4)
			{
				foreach(new i : Player)
				{
					if(pData[i][pAdmin] > 0)
					{
						format(String,sizeof(String), "[STUCK]: {00FFFF}%s[id:%d] "YELLOW_E"Bug Death (vw: %d, int: %d)",ReturnName(playerid), playerid, pData[playerid][pWorld], pData[playerid][pInt]);
						SendClientMessage(playerid, COLOR_ARWIN, String);
					}
				}
				SendClientMessage(playerid, COLOR_ARWIN, "REPORTINFO: "WHITE_E"Report anda telah dikirim ke Administrator yang online");
				return 1;
			}
		}
	}
	//VEHICLE STORAGE
	if(dialogid == VEHICLE_OTHER)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
            	new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            ShowPlayerDialog(playerid, VEHICLE_SEED1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Ayam Hidup\nSimpan Ayam Hidup", "Pilih", "Kembali");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Kanabis\nSimpan Kanabis", "Pilih", "Kembali");
                        }
                        case 2:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Marijuana\nSimpan Marijuana", "Pilih", "Kembali");
                        }
                        case 3:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Component\nSimpan Component", "Pilih", "Kembali");
                        }
                        case 4:
                        {
                        	Vehicle_ItemStorage(playerid, vehicleid);
                        }
                    }
                }
                else return 1;
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_SEED1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Ayam hidup yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak ayam hidup yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                            ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Ayam hidup yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak ayam hidup yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][AyamHidup]);
                            ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                	new
						items[1],
						string[10 * 32];

					for (new nano = 0; nano < 3; nano ++) if(vsData[vehicleid][vsWeapon][nano]) 
					{
						items[0]++;
					}
					format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\nSenjata\t({3BBD44}%d{ffffff}/3)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA), vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), items[0]);
		   			ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");
                    //new string[200];
                    //format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA), vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT));
   					//ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");

                    //new string[200];
                    //format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
   					//ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_SEED_WITHDRAW1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Ayam hidup yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak ayam hidup yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsSeed])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Ayam hidup tidak mencukupi!{ffffff}.\n\nAyam hidup yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak ayam hidup yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsSeed] -= amount;
                    pData[playerid][AyamHidup] += amount;
                    new lstr[500];
					format(lstr, sizeof(lstr), "Received_%dx", amount);
                    ShowItemBox(playerid, "Ayam", lstr, 16776, 5);
                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d ayam hidup dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_SEED1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Ayam Hidup\nSimpan Ayam Hidup", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_SEED_DEPOSIT1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak ayam hidup yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][AyamHidup]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][AyamHidup])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Ayam Hidup anda tidak mencukupi!{ffffff}.\n\nAyam hidup yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak ayam hidup yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][AyamHidup]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_SEED) < vsData[vehicleid][vsSeed] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Ayam Hidup!.\n\nAyam Hidup yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Ayam hidup yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_SEED), pData[playerid][AyamHidup]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsSeed] += amount;
                    pData[playerid][AyamHidup] -= amount;
                    new lstr[500];
					format(lstr, sizeof(lstr), "Removed_%dx", amount);
                    ShowItemBox(playerid, "Ayam", lstr, 16776, 5);
                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s telah menyimpan %d ayam hidup ke bagasi kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_SEED1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Ayam Hidup\nSimpan Ayam Hidup", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	if(dialogid == VEHICLE_MATERIAL1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Kanabis yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak kanabis yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Kanabis yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak kanabis yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pKanabis]);
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA), vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT));
   					ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");

                    //new string[200];
                    //format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
   					//ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MATERIAL_WITHDRAW1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Kanabis yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak kanabis yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMaterial])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Kanabis tidak mencukupi!{ffffff}.\n\nKanabis yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak kanabis yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMaterial] -= amount;
                    pData[playerid][pKanabis] += amount;
                    new lstr[500];
					format(lstr, sizeof(lstr), "Received_%dx", amount);
                    ShowItemBox(playerid, "Kanabis", lstr, 800, 5);
                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s telah mengambil %d kanabis dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MATERIAL1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Kanabis\nSimpan Kanabis", "Pilih", "Kembali");
            }
        }
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MATERIAL_DEPOSIT1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Kanabis yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak kanabis yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pKanabis]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pKanabis])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}kanabis anda tidak mencukupi!{ffffff}.\n\nKanabis yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak kanabis yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pKanabis]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MATERIAL) < vsData[vehicleid][vsMaterial] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Kanabis!.\n\nKanabis yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak kanabis yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MATERIAL), pData[playerid][pKanabis]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMaterial] += amount;
                    pData[playerid][pKanabis] -= amount;
                    new lstr[500];
					format(lstr, sizeof(lstr), "Removed_%dx", amount);
                    ShowItemBox(playerid, "Kanabis", lstr, 800, 5);
                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s telah menyimpan %d kanabis ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MATERIAL1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
            }
        }
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	if(dialogid == VEHICLE_MARIJUANA1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMarijuana]);
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                	new string[200];
                    format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA), vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT));
   					ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");

                    //new string[200];
                    //format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
   					//ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");
                } 
			}
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MARIJUANA_WITHDRAW1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMarijuana])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Marijuana tidak mencukupi!{ffffff}.\n\nMarijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMarijuana] -= amount;
                    pData[playerid][pMarijuana] += amount;
                    new lstr[500];
					format(lstr, sizeof(lstr), "Received_%dx", amount);
                    ShowItemBox(playerid, "Marijuana", lstr, 1578, 5);
                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d marijuana dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MARIJUANA1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MARIJUANA_DEPOSIT1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                	new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMarijuana])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Marijuana anda tidak mencukupi!{ffffff}.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MARIJUANA) < vsData[vehicleid][vsMarijuana] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Marijuana!.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MARIJUANA), pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMarijuana] += amount;
                    pData[playerid][pMarijuana] -= amount;
                    new lstr[500];
					format(lstr, sizeof(lstr), "Removed_%dx", amount);
                    ShowItemBox(playerid, "Marijuana", lstr, 1578, 5);
                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d marijuana ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MARIJUANA1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	if(dialogid == VEHICLE_COMPONENT1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pComponent]);
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                	new string[200];
                    format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA), vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT));
   					ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");
                    //new string[200];
                    //format(string, sizeof(string), "Ayam Hidup\t({3BBD44}%d{ffffff}/%d)\nKanabis\t({3BBD44}%d{ffffff}/%d)\nMarijuana\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Batu\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
   					//ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Bagasi Kendaraan", string, "Pilih", "Kembali");
                }
            }
        }
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_COMPONENT_WITHDRAW1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsComponent])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Component tidak mencukupi!{ffffff}.\n\nComponent yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsComponent] -= amount;
                    pData[playerid][pComponent] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d component dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_COMPONENT1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_COMPONENT_DEPOSIT1)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pComponent])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Component anda tidak mencukupi!{ffffff}.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_COMPONENT) < vsData[vehicleid][vsComponent] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Component!.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_COMPONENT), pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT1, DIALOG_STYLE_INPUT, "Bagasi Kendaraan", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsComponent] += amount;
                    pData[playerid][pComponent] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d component ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_COMPONENT1, DIALOG_STYLE_LIST, "Bagasi Kendaraan", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	if(dialogid == VEHICLE_WEAPON)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    if(vsData[vehicleid][vsWeapon][listitem] != 0)
                    {
                        GivePlayerWeaponEx(playerid, vsData[vehicleid][vsWeapon][listitem], vsData[vehicleid][vsAmmo][listitem]);

                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(vsData[vehicleid][vsWeapon][listitem]));

                        vsData[vehicleid][vsWeapon][listitem] = 0;
                        vsData[vehicleid][vsAmmo][listitem] = 0;

                        Vehicle_StorageSave(i);
                        Vehicle_ItemStorage(playerid, vehicleid);
                    }
                    else
                    {
                        new
                        	weaponid = GetPlayerWeaponEx(playerid),
                            //weaponid = pData[playerid][pSelectItem],
                            ammo = GetPlayerAmmoEx(playerid);

                        if(weaponid == -1)
                            return ErrorMsg(playerid, "Anda belum memilih item yang akan disimpan!");

                        ResetWeapon(playerid, weaponid);
                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "ACTION: %s telah menyimpan %s kedalam bagasi.", ReturnName(playerid), ReturnWeaponName(weaponid));

                        vsData[vehicleid][vsWeapon][listitem] = weaponid;
                        vsData[vehicleid][vsAmmo][listitem] = ammo;

                        Vehicle_StorageSave(i);
                        Vehicle_ItemStorage(playerid, vehicleid);
                    }
                }
                else
                {
                     Vehicle_OpenStorage(playerid, vehicleid);
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	return 1;
}