
//----------[ Function Login Register]----------
function OnPlayerDataLoaded(playerid, race_check)
{
    SetPlayerCameraPos(playerid,698.826049, -1404.027099, 41);
	SetPlayerCameraLookAt(playerid,703.825317, -1404.041990, 39.802570);
	InterpolateCameraPos(playerid, 698.826049, -1404.027099, 16.206615, 2045.292480, -1425.237182, 128.337753, 60000);
	InterpolateCameraLookAt(playerid, 703.825317, -1404.041990, 500000681, 2050.291992, -1425.306762, 128.361190, 50000);
	if (race_check != g_MysqlRaceCheck[playerid]) return Kick(playerid);

	cache_get_value_name(0, "password", pData[playerid][pPassword], 65);
	cache_get_value_name(0, "salt", pData[playerid][pSalt], 17);
	cache_get_value_name_int(0, "verifycode", pData[playerid][pVerifyCode]);

	new query[248], PlayerIP[16];
	//new string[1000];
	if(cache_num_rows() > 0)
	{
		if(pData[playerid][pPassword] < 1)
		{
			new str[400];
			format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh KonohaBot", pData[playerid][pUCP]);
			ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "{15D4ED}Konoha - {ffffff}Verify Account", str, "Input", "Batal");
		}
		if(pData[playerid][pPassword] > 10)
		{
			new lstring[512];
			format(lstring, sizeof lstring, "{FFFFFF}Selamat datang kembali di {15D4ED}Konoha\n{FFFFFF}UCP ini terdaftar!\n\nNama UCP: "LG_E"%s\n{FFFF00}(Silahkan Masukkan Kata Sandi Anda Di Bawah Ini:)", pData[playerid][pUCP]);
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login to {15D4ED}Konoha", lstring, "Masuk", "Keluar");

			//format(string, sizeof string, "{FFFFFF}This account is {00FF00}registered!\n\n{FFFFFF}UCP: {FFFF00}%s\n{FFFFFF}Enter your password below :", pData[playerid][pUCP]);
			//ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login to {15D4ED}Konoha{FFFF00}", string, "Login", "Abort");
		}
		pData[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "i", playerid);
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,"Kota Konoha - Tiket","Dari: Penjaga Pintu Konoha\nKepada: Calon Aktor (Pemain Peran) di Kota Konoha\n\nSilahkan Terlebih Dahulu mengambil tiket Konoha di discord sebelum dapat memasuki Kota Konoha\nLink Discord: https://discord.gg/5dmGMXYyaC","Keluar","");
        SetTimerEx("KickTimer", 3000, 0, "i", playerid);

	}
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `banneds` WHERE `name` = '%s' OR `ip` = '%s' OR (`longip` != 0 AND (`longip` & %i) = %i) LIMIT 1", pData[playerid][pUCP], pData[playerid][pIP], BAN_MASK, (Ban_GetLongIP(PlayerIP) & BAN_MASK));
	mysql_tquery(g_SQL, query, "CheckBanUCP", "i", playerid);
	return 1;
}

function KickTimer(playerid)
{
	KickEx(playerid);
	return 1;
}

function CheckBanUCP(playerid)
{
	if(cache_num_rows() > 0)
	{
		new Reason[40], PlayerName[24], BannedName[24];
	    new banTime_Int, banDate, banIP[16];
		cache_get_value_name(0, "name", BannedName);
		cache_get_value_name(0, "admin", PlayerName);
		cache_get_value_name(0, "reason", Reason);
		cache_get_value_name(0, "ip", banIP);
		cache_get_value_name_int(0, "ban_expire", banTime_Int);
		cache_get_value_name_int(0, "ban_date", banDate);

		new currentTime = gettime();
        if(banTime_Int != 0 && banTime_Int <= currentTime) // Unban the player.
		{
			new query[248];
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE name = '%s'", pData[playerid][pUCP]);
			mysql_tquery(g_SQL, query);
				
			Servers(playerid, "Welcome back to server, its been %s since your ban was lifted.", ReturnTimelapse(banTime_Int, gettime()));
		}
		else
		{
			foreach(new pid : Player)
			{
				if(pData[pid][pTogLog] == 0)
				{
					SendClientMessageEx(pid, COLOR_RED, "[SERVER]: "GREY2_E"%s(%i) has been auto-kicked for ban evading.", pData[playerid][pUCP], playerid);
				}
			}
			new query[248];
  			mysql_format(g_SQL, query, sizeof query, "UPDATE `banneds` SET `last_activity_timestamp` = '%d' WHERE `name` = '%s'", gettime(), pData[playerid][pUCP]);
			mysql_tquery(g_SQL, query);
			
				
			/*pData[playerid][IsLoggedIn] = false;
			printf("[BANNED INFO]: Ban Getting Called on %s", pData[playerid][pUCP]);
			GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
			
			InfoTD_MSG(playerid, 5000, "~r~~h~You are banned from this server!");
			//for(new l; l < 20; l++) SendClientMessage(playerid, COLOR_DARK, "\n");
			SendClientMessage(playerid, COLOR_RED, "You are banned from this server!");*/
			if(banTime_Int == 0)
			{
				new lstr[512];
				format(lstr, sizeof(lstr), "{FFFFFF}Your UCP has been Banned from this server\n{FF0000}Reason: {FFFFFF}%s\n{FF0000}Banned By: {FFFFFF}%s\n{FF0000}Ends On: {FFFFFF}Permanent\n{FFFFFF}For Unbanned please visit our discord at {FF0000}https://discord.gg/5dmGMXYyaC", Reason, pData[playerid][pName], ReturnDate(banDate));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FFFFFF}Banned Alert - UCP Ban", lstr, "Close", "");
			}
			else
			{
				new lstr[512];
				format(lstr, sizeof(lstr), "{FFFFFF}Your UCP has been Banned from this server\n{FF0000}Reason: {FFFFFF}%s\n{FF0000}Banned By: {FFFFFF}%s\n{FF0000}Ends On: {FFFFFF}%s\n{FFFFFF}For Unbanned please visit our discord at {FF0000}https://discord.gg/5dmGMXYyaC", Reason, pData[playerid][pName], ReturnDate(banDate));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FFFFFF}Banned Alert - UCP Ban", lstr, "Close", "");
			}
			KickEx(playerid);
			return 1;
  		}
	}
	return 1;
}

function CheckBan(playerid)
{
	if(cache_num_rows() > 0)
	{
		new Reason[40], PlayerName[24], BannedName[24];
	    new banTime_Int, banDate, banIP[16];
		cache_get_value_name(0, "name", BannedName);
		cache_get_value_name(0, "admin", PlayerName);
		cache_get_value_name(0, "reason", Reason);
		cache_get_value_name(0, "ip", banIP);
		cache_get_value_name_int(0, "ban_expire", banTime_Int);
		cache_get_value_name_int(0, "ban_date", banDate);

		new currentTime = gettime();
        if(banTime_Int != 0 && banTime_Int <= currentTime) // Unban the player.
		{
			new query[248];
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE name = '%s'", pData[playerid][pName]);
			mysql_tquery(g_SQL, query);
				
			Servers(playerid, "Welcome back to server, its been %s since your ban was lifted.", ReturnTimelapse(banTime_Int, gettime()));
		}
		else
		{
			foreach(new pid : Player)
			{
				if(pData[pid][pTogLog] == 0)
				{
					SendClientMessageEx(pid, COLOR_RED, "Server: "GREY2_E"%s(%i) has been auto-kicked for ban evading.", pData[playerid][pName], playerid);
				}
			}
			new query[248], PlayerIP[16];
  			mysql_format(g_SQL, query, sizeof query, "UPDATE `banneds` SET `last_activity_timestamp` = %i WHERE `name` = '%s'", gettime(), pData[playerid][pName]);
			mysql_tquery(g_SQL, query);
				
			pData[playerid][IsLoggedIn] = false;
			printf("[BANNED INFO]: Ban Getting Called on %s", pData[playerid][pName]);
			GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
			
			InfoTD_MSG(playerid, 5000, "~r~~h~You are banned from this server!");
			//for(new l; l < 20; l++) SendClientMessage(playerid, COLOR_DARK, "\n");
			SendClientMessage(playerid, COLOR_RED, "You are banned from this server!");
			if(banTime_Int == 0)
			{
				new lstr[512];
				format(lstr, sizeof(lstr), "{FF0000}You are banned from this server!\n\n"LB2_E"Ban Info:\n{FF0000}UCP Name/Character Name: {778899}%s\n{FF0000}IP: {778899}%s\n{FF0000}Admin: {778899}%s\n{FF0000}Ban Date: {778899}%s\n{FF0000}Ban Reason: {778899}%s\n{FF0000}Ban Time: {778899}Permanent\n\n{FFFFFF}Merasa tidak bersalah terkena banned? Appeal di Discord Konoha Roleplay", BannedName, PlayerIP, PlayerName, ReturnDate(banDate), Reason);
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"BANNED", lstr, "Exit", "");
			}
			else
			{
				new lstr[512];
				format(lstr, sizeof(lstr), "{FF0000}You are banned from this server!\n\n"LB2_E"Ban Info:\n{FF0000}UCP Name/Character Name: {778899}%s\n{FF0000}IP: {778899}%s\n{FF0000}Admin: {778899}%s\n{FF0000}Ban Date: {778899}%s\n{FF0000}Ban Reason: {778899}%s\n{FF0000}Ban Time: {778899}%s\n\n{FFFFFF}Merasa tidak bersalah terkena banned? Appeal di Discord Konoha Roleplay ", BannedName, PlayerIP, PlayerName, ReturnDate(banDate), Reason, ReturnTimelapse(gettime(), banTime_Int));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"BANNED", lstr, "Exit", "");
			}
			KickEx(playerid);
			return 1;
  		}
	}
	return 1;
}

function AssignPlayerData(playerid)
{
	new aname[MAX_PLAYER_NAME], ucp[22], twname[MAX_PLAYER_NAME], email[40], age[128], tng[128], brt[128], ip[128], regdate[50], lastlogin[50];
	new name[MAX_PLAYER_NAME];
	
	cache_get_value_name_int(0, "reg_id", pData[playerid][pID]);
	if(pData[playerid][pID] < 1)
	{
		Error(playerid, "Database player not found!");
		KickEx(playerid);
		return 1;
	}
	cache_get_value_name(0, "ucp", ucp);
	format(pData[playerid][pUCP], 22, "%s", ucp);
	cache_get_value_name(0, "username", name);
	format(pData[playerid][pName], MAX_PLAYER_NAME, "%s", name);
	cache_get_value_name(0, "adminname", aname);
	format(pData[playerid][pAdminname], MAX_PLAYER_NAME, "%s", aname);
	cache_get_value_name(0, "twittername", twname);
	format(pData[playerid][pTwittername], MAX_PLAYER_NAME, "%s", twname);
	cache_get_value_name(0, "ip", ip);
	format(pData[playerid][pIP], 128, "%s", ip);
	cache_get_value_name(0, "email", email);
	format(pData[playerid][pEmail], 40, "%s", email);
	cache_get_value_name_int(0, "admin", pData[playerid][pAdmin]);
	cache_get_value_name_int(0, "helper", pData[playerid][pHelper]);
	cache_get_value_name_int(0, "level", pData[playerid][pLevel]);
	cache_get_value_name_int(0, "levelup", pData[playerid][pLevelUp]);
	cache_get_value_name_int(0, "vip", pData[playerid][pVip]);
	cache_get_value_name_int(0, "vip_time", pData[playerid][pVipTime]);
	cache_get_value_name_int(0, "gold", pData[playerid][pGold]);
	cache_get_value_name(0, "reg_date", regdate);
	format(pData[playerid][pRegDate], 128, "%s", regdate);
	cache_get_value_name(0, "last_login", lastlogin);
	format(pData[playerid][pLastLogin], 128, "%s", lastlogin);
	cache_get_value_name_int(0, "money", pData[playerid][pMoney]);
	cache_get_value_name_int(0, "bmoney", pData[playerid][pBankMoney]);
	cache_get_value_name_int(0, "brek", pData[playerid][pBankRek]);
	cache_get_value_name_int(0, "phone", pData[playerid][pPhone]);
	cache_get_value_name_int(0, "phonecredit", pData[playerid][pPhoneCredit]);
	cache_get_value_name_int(0, "phonebook", pData[playerid][pPhoneBook]);
	cache_get_value_name_int(0, "gpsins", pData[playerid][pGpsIns]);
	cache_get_value_name_int(0, "twtins", pData[playerid][pTwtIns]);
	cache_get_value_name_int(0, "aonains", pData[playerid][pAonaIns]);
	cache_get_value_name_int(0, "wt", pData[playerid][pWT]);
	cache_get_value_name_int(0, "hours", pData[playerid][pHours]);
	cache_get_value_name_int(0, "minutes", pData[playerid][pMinutes]);
	cache_get_value_name_int(0, "seconds", pData[playerid][pSeconds]);
	cache_get_value_name_int(0, "paycheck", pData[playerid][pPaycheck]);
	cache_get_value_name_int(0, "skin", pData[playerid][pSkin]);
	cache_get_value_name_int(0, "facskin", pData[playerid][pFacSkin]);
	cache_get_value_name_int(0, "gender", pData[playerid][pGender]);
	cache_get_value_name(0, "age", age);
	format(pData[playerid][pAge], 128, "%s", age);
	cache_get_value_name(0, "tinggi", tng);
	format(pData[playerid][pTinggi], 128, "%s", tng);
	cache_get_value_name(0, "berat", brt);
	format(pData[playerid][pBerat], 128, "%s", brt);
	cache_get_value_name_int(0, "indoor", pData[playerid][pInDoor]);
	cache_get_value_name_int(0, "inhouse", pData[playerid][pInHouse]);
	cache_get_value_name_int(0, "inbiz", pData[playerid][pInBiz]);
	cache_get_value_name_float(0, "posx", pData[playerid][pPosX]);
	cache_get_value_name_float(0, "posy", pData[playerid][pPosY]);
	cache_get_value_name_float(0, "posz", pData[playerid][pPosZ]);
	cache_get_value_name_float(0, "posa", pData[playerid][pPosA]);
	cache_get_value_name_int(0, "interior", pData[playerid][pInt]);
	cache_get_value_name_int(0, "world", pData[playerid][pWorld]);
	cache_get_value_name_float(0, "health", pData[playerid][pHealth]);
	cache_get_value_name_float(0, "armour", pData[playerid][pArmour]);
	cache_get_value_name_int(0, "hunger", pData[playerid][pHunger]);
	cache_get_value_name_int(0, "energy", pData[playerid][pEnergy]);
	cache_get_value_name_int(0, "bladder", pData[playerid][pBladder]);
	cache_get_value_name_int(0, "sick", pData[playerid][pSick]);
	cache_get_value_name_int(0, "hospital", pData[playerid][pHospital]);
	cache_get_value_name_int(0, "injured", pData[playerid][pInjured]);
	cache_get_value_name_int(0, "duty", pData[playerid][pOnDuty]);
	cache_get_value_name_int(0, "dutytime", pData[playerid][pOnDutyTime]);
	cache_get_value_name_int(0, "faction", pData[playerid][pFaction]);
	cache_get_value_name_int(0, "factionrank", pData[playerid][pFactionRank]);
	cache_get_value_name_int(0, "factionlead", pData[playerid][pFactionLead]);
	cache_get_value_name_int(0, "family", pData[playerid][pFamily]);
	cache_get_value_name_int(0, "familyrank", pData[playerid][pFamilyRank]);
	cache_get_value_name_int(0, "workshop", pData[playerid][pWorkshop]);
	cache_get_value_name_int(0, "workshoprank", pData[playerid][pWorkshopRank]);
	cache_get_value_name_int(0, "jail", pData[playerid][pJail]);
	cache_get_value_name_int(0, "jail_time", pData[playerid][pJailTime]);
	cache_get_value_name_int(0, "rehab", pData[playerid][pRehab]);
	cache_get_value_name_int(0, "rehab_time", pData[playerid][pRehabTime]);
	cache_get_value_name_int(0, "robbing", pData[playerid][pRobbing]);
	cache_get_value_name_int(0, "robbing_time", pData[playerid][pRobbingTime]);
	cache_get_value_name_int(0, "arrest", pData[playerid][pArrest]);
	cache_get_value_name_int(0, "arrest_time", pData[playerid][pArrestTime]);
	cache_get_value_name_int(0, "warn", pData[playerid][pWarn]);
	cache_get_value_name_int(0, "job", pData[playerid][pJob]);
	cache_get_value_name_int(0, "job2", pData[playerid][pJob2]);
	cache_get_value_name_int(0, "jobtime", pData[playerid][pJobTime]);
	cache_get_value_name_int(0, "sidejobtime", pData[playerid][pSideJobTime]);
	cache_get_value_name_int(0, "exitjob", pData[playerid][pExitJob]);
	cache_get_value_name_int(0, "taxitime", pData[playerid][pTaxiTime]);
	cache_get_value_name_int(0, "medicine", pData[playerid][pMedicine]);
	cache_get_value_name_int(0, "medkit", pData[playerid][pMedkit]);
	cache_get_value_name_int(0, "mask", pData[playerid][pMask]);
	cache_get_value_name_int(0, "helmet", pData[playerid][pHelmet]);
	cache_get_value_name_int(0, "fightingstyle", pData[playerid][pFightingStyle]);
	cache_get_value_name_int(0, "snack", pData[playerid][pSnack]);
	cache_get_value_name_int(0, "sprunk", pData[playerid][pSprunk]);
	cache_get_value_name_int(0, "ciken", pData[playerid][pChicken]);
	cache_get_value_name_int(0, "pizza", pData[playerid][pPizzaP]);
	cache_get_value_name_int(0, "burger", pData[playerid][pBurgerP]);
	cache_get_value_name_int(0, "gas", pData[playerid][pGas]);
	cache_get_value_name_int(0, "bandage", pData[playerid][pBandage]);
	cache_get_value_name_int(0, "gps", pData[playerid][pGPS]);
	cache_get_value_name_int(0, "material", pData[playerid][pMaterial]);
	cache_get_value_name_int(0, "component", pData[playerid][pComponent]);
	cache_get_value_name_int(0, "food", pData[playerid][pFood]);
	cache_get_value_name_int(0, "seed", pData[playerid][pSeed]);
	cache_get_value_name_int(0, "potato", pData[playerid][pPotato]);
	cache_get_value_name_int(0, "wheat", pData[playerid][pWheat]);
	cache_get_value_name_int(0, "orange", pData[playerid][pOrange]);
	cache_get_value_name_int(0, "price1", pData[playerid][pPrice1]);
	cache_get_value_name_int(0, "price2", pData[playerid][pPrice2]);
	cache_get_value_name_int(0, "price3", pData[playerid][pPrice3]);
	cache_get_value_name_int(0, "price4", pData[playerid][pPrice4]);
	cache_get_value_name_int(0, "marijuana", pData[playerid][pMarijuana]);
	cache_get_value_name_int(0, "kanabis", pData[playerid][pKanabis]);
	cache_get_value_name_int(0, "ephedrine", pData[playerid][pEphedrine]);
	cache_get_value_name_int(0, "cocaine", pData[playerid][pCocaine]);
	cache_get_value_name_int(0, "meth", pData[playerid][pMeth]);
	cache_get_value_name_int(0, "muriatic", pData[playerid][pMuriatic]);
	cache_get_value_name_int(0, "plant", pData[playerid][pPlant]);
	cache_get_value_name_int(0, "plant_time", pData[playerid][pPlantTime]);
	cache_get_value_name_int(0, "fishtool", pData[playerid][pFishTool]);
	cache_get_value_name_int(0, "fish", pData[playerid][pFish]);
	cache_get_value_name_int(0, "worm", pData[playerid][pWorm]);
	cache_get_value_name_int(0, "idcard", pData[playerid][pIDCard]);
	cache_get_value_name_int(0, "idcard_time", pData[playerid][pIDCardTime]);
	cache_get_value_name_int(0, "bpjs", pData[playerid][pBPJS]);
	cache_get_value_name_int(0, "bpjs_time", pData[playerid][pBPJSTime]);
	cache_get_value_name_int(0, "skcknya", pData[playerid][pSKCK]);
	cache_get_value_name_int(0, "sksnya", pData[playerid][pSKS]);
	cache_get_value_name_int(0, "drivelic", pData[playerid][pDriveLic]);
	cache_get_value_name_int(0, "drivelic_time", pData[playerid][pDriveLicTime]);
	cache_get_value_name_int(0, "lumberlic", pData[playerid][pLumberLic]);
	cache_get_value_name_int(0, "lumberlic_time", pData[playerid][pLumberLicTime]);
	cache_get_value_name_int(0, "trucklic", pData[playerid][pTruckLic]);
	cache_get_value_name_int(0, "trucklic_time", pData[playerid][pTruckLicTime]);
	cache_get_value_name_int(0, "weaponlic", pData[playerid][pWeapLic]);
	cache_get_value_name_int(0, "weaponlic_time", pData[playerid][pWeapLicTime]);
	cache_get_value_name_int(0, "hbemode", pData[playerid][pHBEMode]);
	cache_get_value_name_int(0, "togpm", pData[playerid][pTogPM]);
	cache_get_value_name_int(0, "toglog", pData[playerid][pTogLog]);
	cache_get_value_name_int(0, "togads", pData[playerid][pTogAds]);
	cache_get_value_name_int(0, "togwt", pData[playerid][pTogWT]);
	cache_get_value_name_int(0, "togreport", pData[playerid][pTogReport]);
	cache_get_value_name_int(0, "togask", pData[playerid][pTogAsk]);
	cache_get_value_name_int(0, "togadminchat", pData[playerid][pTogAdminchat]);
	cache_get_value_name_int(0, "togspeedcam", pData[playerid][pTogSpeedcam]);
	cache_get_value_name_int(0, "daging", pData[playerid][pDaging]);
	cache_get_value_name_int(0, "gandum", pData[playerid][pGandum]);
	cache_get_value_name_int(0, "susu", pData[playerid][pSusu]);
	cache_get_value_name_int(0, "susuolah", pData[playerid][pSusuolah]);
	cache_get_value_name_int(0, "staterpack", pData[playerid][pStarterPack]);

	cache_get_value_name_int(0, "clippistol", pData[playerid][pAmmoPistol]);
	cache_get_value_name_int(0, "clipsg", pData[playerid][pAmmoSG]);
	cache_get_value_name_int(0, "clipsmg", pData[playerid][pAmmoSMG]);
	cache_get_value_name_int(0, "cliprifle", pData[playerid][pAmmoRifle]);

	cache_get_value_name_int(0, "gopay", pData[playerid][pGopay]);
	cache_get_value_name_int(0, "kepala", pData[playerid][pHead]);
	cache_get_value_name_int(0, "perut", pData[playerid][pPerut]);
	cache_get_value_name_int(0, "lengankiri", pData[playerid][pLHand]);
	cache_get_value_name_int(0, "lengankanan", pData[playerid][pRHand]);
	cache_get_value_name_int(0, "kakikiri", pData[playerid][pLFoot]);
	cache_get_value_name_int(0, "kakikanan", pData[playerid][pRFoot]);
	cache_get_value_name_int(0, "boombox", pData[playerid][pBoombox]);
	cache_get_value_name_int(0, "ask_time", pData[playerid][pAskTime]);
	cache_get_value_name_int(0, "suspect", pData[playerid][pSuspect]);
	cache_get_value_name_int(0, "suspect_time", pData[playerid][pSuspectTimer]);
	cache_get_value_name_int(0, "phonestats", pData[playerid][pUsePhone]);
	cache_get_value_name_int(0, "bomb", pData[playerid][pBomb]);
	cache_get_value_name_int(0, "repairkit", pData[playerid][pRepairkit]);
	cache_get_value_name_int(0, "delayrob", pData[playerid][pRobTime]);
	cache_get_value_name_int(0, "booster", pData[playerid][pBooster]);
	cache_get_value_name_int(0, "booster_time", pData[playerid][pBoostTime]);
	cache_get_value_name_int(0, "accent", pData[playerid][pAccent1]);
	cache_get_value_name_int(0, "tdrug", pData[playerid][pTdrug]);
	cache_get_value_name_int(0, "use_drugs", pData[playerid][pUseDrug]);
	//cache_get_value_name_int(0, "starterpack", pData[playerid][pStarterPack]);
	cache_get_value_name_int(0, "characterstory", pData[playerid][pCharStory]);
	cache_get_value_name_int(0, "weapon_skill", pData[playerid][pWeaponSkill]);
	cache_get_value_name_int(0, "batu", pData[playerid][pBatu]);
    cache_get_value_name_int(0, "batucucian", pData[playerid][pBatuCucian]);
    cache_get_value_name_int(0, "emas", pData[playerid][pEmas]);
    cache_get_value_name_int(0, "besi", pData[playerid][pBesi]);
    cache_get_value_name_int(0, "aluminium", pData[playerid][pAluminium]);
    cache_get_value_name_int(0, "berlian", pData[playerid][pBerlian]);
    cache_get_value_name_int(0, "sampahsaya", pData[playerid][sampahsaya]);
    cache_get_value_name_int(0, "Cappucino", pData[playerid][pCappucino]);
    cache_get_value_name_int(0, "MilxMax", pData[playerid][pMilxMax]);
    cache_get_value_name_int(0, "Starling", pData[playerid][pStarling]);
    cache_get_value_name_int(0, "obatstres", pData[playerid][pObatStress]);
    cache_get_value_name_int(0, "Kayu", pData[playerid][pKayu]);
    cache_get_value_name_int(0, "KayuPotong", pData[playerid][pKayuPotong]);
    cache_get_value_name_int(0, "KayuKemas", pData[playerid][pKayuKemas]);
    cache_get_value_name_int(0, "bulu", pData[playerid][pBulu]);
    cache_get_value_name_int(0, "benang", pData[playerid][pBenang]);
    cache_get_value_name_int(0, "kain", pData[playerid][pKain]);
    cache_get_value_name_int(0, "pakaian", pData[playerid][pPakaian]);
    cache_get_value_name_int(0, "ayamhidup", pData[playerid][AyamHidup]);
    cache_get_value_name_int(0, "ayampotong", pData[playerid][AyamPotong]);
    cache_get_value_name_int(0, "ayamkemas", pData[playerid][AyamFillet]);
    cache_get_value_name_int(0, "vest", pData[playerid][pVest]);
    cache_get_value_name_int(0, "kevlar", pData[playerid][pKevlar]);
    cache_get_value_name_int(0, "minyak", pData[playerid][pMinyak]);
    cache_get_value_name_int(0, "essence", pData[playerid][pEssence]);
    cache_get_value_name_int(0, "sidejob_bustime", pData[playerid][pBusTime]);
    cache_get_value_name_int(0, "akempattujuh", pData[playerid][pAK47]);
    cache_get_value_name_int(0, "deseteagle", pData[playerid][pDesertEagle]);
    cache_get_value_name_int(0, "weapuzi", pData[playerid][pMicroSMG]);
    cache_get_value_name_int(0, "weapmplima", pData[playerid][pMP5]);
    cache_get_value_name_int(0, "weapcoltpatlima", pData[playerid][pColt45]);
    cache_get_value_name_int(0, "tecbilan", pData[playerid][pTec9]);
    cache_get_value_name_int(0, "weapshotgun", pData[playerid][pShotgun]);
    cache_get_value_name_int(0, "weaprifle", pData[playerid][pRifle]);
    cache_get_value_name_int(0, "weapsniper", pData[playerid][pSniper]);
    cache_get_value_name_int(0, "clipweap", pData[playerid][pClip]);
    cache_get_value_name_int(0, "pisau", pData[playerid][pKnife]);
    cache_get_value_name_int(0, "samurai", pData[playerid][pKatana]);
    cache_get_value_name_int(0, "karet", pData[playerid][pKaret]);
	cache_get_value_name_int(0, "box", pData[playerid][pBox]);
	cache_get_value_name_int(0, "botol", pData[playerid][pBotol]);

    //JOB BUTCHER
    cache_get_value_name_int(0, "dagingmentah", pData[playerid][pDagingMentah]);
    cache_get_value_name_int(0, "dagingpotong", pData[playerid][pDagingPotong]);
    cache_get_value_name_int(0, "dagingkemas", pData[playerid][pDagingKemas]);

    //JOB_FISH
    cache_get_value_name_int(0, "tuna", pData[playerid][pItuna]);
    cache_get_value_name_int(0, "tongkol", pData[playerid][pItongkol]);
    cache_get_value_name_int(0, "kakap", pData[playerid][pIkakap]);
    cache_get_value_name_int(0, "kembung", pData[playerid][pIkembung]);
    cache_get_value_name_int(0, "makarel", pData[playerid][pImkarel]);
    cache_get_value_name_int(0, "tenggiri", pData[playerid][pItenggiri]);
    cache_get_value_name_int(0, "bluemarlin", pData[playerid][pIBmarlin]);
    cache_get_value_name_int(0, "sailfish", pData[playerid][pIsailF]);

	//PDG
	cache_get_value_name_int(0, "burgerped", pData[playerid][pBurger]);
	cache_get_value_name_int(0, "rotiped", pData[playerid][pRoti]);
	cache_get_value_name_int(0, "steakped", pData[playerid][pSteak]);
	cache_get_value_name_int(0, "milk", pData[playerid][pMilks]);
	
	cache_get_value_name_int(0, "Gun1", pData[playerid][pGuns][0]);
	cache_get_value_name_int(0, "Gun2", pData[playerid][pGuns][1]);
	cache_get_value_name_int(0, "Gun3", pData[playerid][pGuns][2]);
	cache_get_value_name_int(0, "Gun4", pData[playerid][pGuns][3]);
	cache_get_value_name_int(0, "Gun5", pData[playerid][pGuns][4]);
	cache_get_value_name_int(0, "Gun6", pData[playerid][pGuns][5]);
	cache_get_value_name_int(0, "Gun7", pData[playerid][pGuns][6]);
	cache_get_value_name_int(0, "Gun8", pData[playerid][pGuns][7]);
	cache_get_value_name_int(0, "Gun9", pData[playerid][pGuns][8]);
	cache_get_value_name_int(0, "Gun10", pData[playerid][pGuns][9]);
	cache_get_value_name_int(0, "Gun11", pData[playerid][pGuns][10]);
	cache_get_value_name_int(0, "Gun12", pData[playerid][pGuns][11]);
	cache_get_value_name_int(0, "Gun13", pData[playerid][pGuns][12]);
	
	cache_get_value_name_int(0, "Ammo1", pData[playerid][pAmmo][0]);
	cache_get_value_name_int(0, "Ammo2", pData[playerid][pAmmo][1]);
	cache_get_value_name_int(0, "Ammo3", pData[playerid][pAmmo][2]);
	cache_get_value_name_int(0, "Ammo4", pData[playerid][pAmmo][3]);
	cache_get_value_name_int(0, "Ammo5", pData[playerid][pAmmo][4]);
	cache_get_value_name_int(0, "Ammo6", pData[playerid][pAmmo][5]);
	cache_get_value_name_int(0, "Ammo7", pData[playerid][pAmmo][6]);
	cache_get_value_name_int(0, "Ammo8", pData[playerid][pAmmo][7]);
	cache_get_value_name_int(0, "Ammo9", pData[playerid][pAmmo][8]);
	cache_get_value_name_int(0, "Ammo10", pData[playerid][pAmmo][9]);
	cache_get_value_name_int(0, "Ammo11", pData[playerid][pAmmo][10]);
	cache_get_value_name_int(0, "Ammo12", pData[playerid][pAmmo][11]);
	cache_get_value_name_int(0, "Ammo13", pData[playerid][pAmmo][12]);
	
	for (new i; i < 17; i++)
	{
		WeaponSettings[playerid][i][Position][0] = -0.116;
		WeaponSettings[playerid][i][Position][1] = 0.189;
		WeaponSettings[playerid][i][Position][2] = 0.088;
		WeaponSettings[playerid][i][Position][3] = 0.0;
		WeaponSettings[playerid][i][Position][4] = 44.5;
		WeaponSettings[playerid][i][Position][5] = 0.0;
		WeaponSettings[playerid][i][Bone] = 1;
		WeaponSettings[playerid][i][Hidden] = false;
	}
	WeaponTick[playerid] = 0;
	EditingWeapon[playerid] = 0;
	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "SELECT * FROM weaponsettings WHERE Owner = '%d'", pData[playerid][pID]);
	mysql_tquery(g_SQL, string, "OnWeaponsLoaded", "d", playerid);

	new invQuery[256];
	mysql_format(g_SQL, invQuery, sizeof(invQuery), "SELECT * FROM `inventory` WHERE `ID` = '%d'", pData[playerid][pID]);
	mysql_tquery(g_SQL, invQuery, "LoadPlayerItems", "d", playerid);
	
	KillTimer(pData[playerid][LoginTimer]);
	pData[playerid][LoginTimer] = 0;
	pData[playerid][IsLoggedIn] = true;

	if(pData[playerid][pJob] == 20)
	{
	    pData[playerid][DutyPenambang] = false;
	    RefreshJobTambang(playerid);
		penambang++;
	}
	else if(pData[playerid][pJob] == 3)
	{
		lumberjack++;
	}
	else if(pData[playerid][pJob] == 4)
	{
		trucker++;
	}
	else if(pData[playerid][pJob] == 5)
	{
		miner++;
	}
	else if(pData[playerid][pJob] == 6)
	{
		production++;
	}
	else if(pData[playerid][pJob] == 7)
	{
		farmers++;
	}
	else if(pData[playerid][pJob] == 8)
	{
		hauling++;
	}
	else if(pData[playerid][pJob] == 9)
	{
		pizza++;
	}
	else if(pData[playerid][pJob] == 10)
	{
		butcher++;
	}
	else if(pData[playerid][pJob] == 11)
	{
		reflenish++;
	}
	else if(pData[playerid][pJob] == 14)
	{
		pemerassusu++;
		RefreshMapJobSapi(playerid);
	}
	else if(pData[playerid][pJob] == 21)
	{
		tukangkayu++;
	}
	else if(pData[playerid][pJob] == 23)
	{
		penjahitt++;
	}
	else if(pData[playerid][pJob] == 24)
	{
		tukangayams++;
		pData[playerid][DutyPemotong] = false;
		RefreshJobPemotong(playerid);
	}
	else if(pData[playerid][pJob] == 25)
	{
		RefreshJobTambangMinyak(playerid);
		pData[playerid][DutyMinyak] = false;
		penambangminyak++;
	}
	else if(pData[playerid][pJob] == 26)
	{
		Recycler++;
	}
	else if(pData[playerid][pJob] == 27)
	{
		Sopirbus++;
		RefreshJobBus(playerid);
	}

	//FACTION ONLINE
	if(pData[playerid][pFaction] == 1)
	{
		polisidikota++;
	}
	if(pData[playerid][pFaction] == 2)
	{
		pemerintahdikota++;
	}
	if(pData[playerid][pFaction] == 3)
	{
		medisdikota++;
	}
	if(pData[playerid][pFaction] == 4)
	{
		newsdikota++;
	}
	if(pData[playerid][pFaction] == 5)
	{
		pedagangdikota++;
	}
	if(pData[playerid][pFaction] == 6)
	{
		gojekdikota++;
	}
	if(pData[playerid][pFaction] == 7)	
	{
		mekanikdikota++;
	}

	if(pData[playerid][pJail] == 1)
	{
	    for(new i = 0; i < 13; i++)
		{
			TextDrawHideForPlayer(playerid, TDSpawnBYDAYSAMP[i]);
			TextDrawHideForPlayer(playerid, SpawnBandara);
			TextDrawHideForPlayer(playerid, SpawnKapal);
			TextDrawHideForPlayer(playerid, SpawnHouse);
			TextDrawHideForPlayer(playerid, SpawnFaction);
			TextDrawHideForPlayer(playerid, SpawnLastExit);
			TextDrawHideForPlayer(playerid, TombolSpawn);
			CancelSelectTextDraw(playerid);
		}
	}
	if(pData[playerid][pArrest] == 1)
	{
	    for(new i = 0; i < 13; i++)
		{
			TextDrawHideForPlayer(playerid, TDSpawnBYDAYSAMP[i]);
			TextDrawHideForPlayer(playerid, SpawnBandara);
			TextDrawHideForPlayer(playerid, SpawnKapal);
			TextDrawHideForPlayer(playerid, SpawnHouse);
			TextDrawHideForPlayer(playerid, SpawnFaction);
			TextDrawHideForPlayer(playerid, SpawnLastExit);
			TextDrawHideForPlayer(playerid, TombolSpawn);			
			CancelSelectTextDraw(playerid);
		}
	}

	// for(new i = 0; i < 8; i++)
	// {
	// 	TextDrawHideForPlayer(playerid, BarMenu_Login[i]);
	// }
	// TextDrawHideForPlayer(playerid, Login);
	// TextDrawHideForPlayer(playerid, Berita);
	// TextDrawHideForPlayer(playerid, Informasi);
	// TextDrawHideForPlayer(playerid, Credit);
	// TextDrawHideForPlayer(playerid, Keluar);
	// CancelSelectTextDraw(playerid);

	if(pData[playerid][pJail] == 0)
	{
	   	pilihanspawn(playerid);
	}      


	Servers(playerid, "Hallo "LB_E"%s"WHITE_E"! Welcome back to Konoha Roleplay", ReturnName(playerid));
	Servers(playerid, "Last login: "YELLOW_E"%s", pData[playerid][pLastLogin]);
	Servers(playerid, "Successfully loaded your characters database in "RED_E"%dms", GetPlayerPing(playerid));
	Servers(playerid, "Don't Forget to Follow Server Rules!");
	SendClientMessage(playerid, -1, "[i] Selalu ingat bahwa server ini menggunakan sistem voice only, dilarang keras RP Bisu/Tuli.");
    SendClientMessage(playerid, -1, "[i] Selama didalam server ingatlah aturan pokok Konoha Roleplay -> {ffff00}Respect & Good Attitude.");
    SendClientMessage(playerid, -1, "[i] {ff0000}Dilarang keras meniup-niup mic!");
    SendClientMessageEx(playerid, COLOR_ARWIN, "[!]: "YELLOW_E"Jika Anda mengalami bug silahkan gunakan command "RED_E"'/stuck'");
	
	SetSpawnInfo(playerid, NO_TEAM, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	
	//LoadLunarSystem(playerid);
	MySQL_LoadPlayerToys(playerid);
	LoadPlayerVehicle(playerid);
	RefreshMapJobDaging(playerid);
	LoadArea(playerid);
	RefreshMapJobSapi(playerid);

	/*new mstr[64];
	format(mstr, sizeof(mstr), "{004BFF}ID : {FFFFFF}%i", playerid);
	pData[playerid][pLabel] = Create3DTextLabel(mstr, 0x008080FF, 30.0, 40.0, 50.0, 40.0, 0);
	Attach3DTextLabelToPlayer(pData[playerid][pLabel], playerid, 0.0, 0.0, 0.6);*/

	return 1;
}

stock PlayReloadAnimation(playerid, weaponid)
{
	switch (weaponid)
	{
	    case 22: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.0, 0, 0, 0, 0, 0);
		case 23: ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0, 0, 0, 0, 0, 0);
		case 24: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0);
		case 25, 27: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0);
		case 26: ApplyAnimation(playerid, "COLT45", "sawnoff_reload", 4.0, 0, 0, 0, 0, 0);
		case 29..31, 33, 34: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.0, 0, 0, 0, 0, 0);
		case 28, 32: ApplyAnimation(playerid, "TEC", "tec_reload", 4.0, 0, 0, 0, 0, 0);
	}
	return 1;
}

stock PlayerPlaySoundEx(playerid, sound)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 20.0, x, y, z)) {
	    PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

function CekNamaDobelJing(playerid, name[])
{
	new rows = cache_num_rows();
	if(rows > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "Create Character", "ERROR: This name is already used by the other player!\nInsert your new Character Name\n\nExample: Finn_Xanderz, Javier_Cooper etc.", "Create", "Back");
	}
	else 
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "INSERT INTO players ( username, ucp, reg_date ) VALUES ('%s', '%s', CURRENT_TIMESTAMP())", name, GetName(playerid));
		mysql_tquery(g_SQL, characterQuery, "OnPlayerRegister", "d", playerid);

		SetPlayerName(playerid, name);
		format(pData[playerid][pName], MAX_PLAYER_NAME, name);
	}
}

function OnPlayerRegister(playerid)
{
	if(pData[playerid][IsLoggedIn] == true)
		return Error(playerid, "You already logged in!");
		
	pData[playerid][pID] = cache_insert_id();
	pData[playerid][IsLoggedIn] = true;

	//1682.5914,-2241.6711,13.6469,182.4905
	pData[playerid][pPosX] = 1682.5914;
	pData[playerid][pPosY] = -2241.6711;
	pData[playerid][pPosZ] = 13.6469;
	pData[playerid][pPosA] = 182.4905;
	pData[playerid][pInt] = 0;
	pData[playerid][pWorld] = 0;
	pData[playerid][pGender] = 0;
	
	format(pData[playerid][pAdminname], MAX_PLAYER_NAME, "None");
	format(pData[playerid][pEmail], 40, "None");
	format(pData[playerid][pTwittername], 40, "None");
	pData[playerid][pHealth] = 100.0;
	pData[playerid][pArmour] = 0.0;
	pData[playerid][pLevel] = 1;
	pData[playerid][pHunger] = 100;
	pData[playerid][pBladder] = 0;
	pData[playerid][pEnergy] = 100;
	pData[playerid][pMoney] = 10;
	//pData[playerid][pStarterPack] = 1;
	pData[playerid][pBankMoney] = 500;
	pData[playerid][pWorkshop] = -1;
	
	pData[playerid][pFightingStyle] = 4;
	pData[playerid][pHead] = 100;
    pData[playerid][pPerut] = 100;
    pData[playerid][pRHand] = 100;
    pData[playerid][pLHand] = 100;
    pData[playerid][pRFoot] = 100;
    pData[playerid][pLFoot] = 100;
	
	new query[128], rand = RandomEx(111111, 999999);
	new rek = rand+pData[playerid][pID];
	mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
	mysql_tquery(g_SQL, query, "BankRek", "id", playerid, rek);
	
	SetSpawnInfo(playerid, NO_TEAM, 0, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);

	//LoadLunarSystem(playerid);

	return 1;
}

function KeluarKendaraanKerja(playerid)
{
    if(TimerKeluar[playerid] == 15)
	{
        TimerKeluar[playerid] = 0;
        DestroyVehicle(pData[playerid][pKendaraanKerja]);
		//DestroyVehicle(pData[playerid][pTrailer]);
        KillTimer(KeluarKerja[playerid]);
        DisablePlayerCheckpoint(playerid);
        DisablePlayerRaceCheckpoint(playerid);
    }
	else
	{
        TimerKeluar[playerid]++;
    }
    return 1;
}

function BankRek(playerid, brek)
{
	if(cache_num_rows() > 0)
	{
		//Rekening Exist
		new query[128], rand = RandomEx(11111, 99999);
		new rek = rand+pData[playerid][pID];
		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "BankRek", "is", playerid, rek);
		Info(playerid, "Your Bank rekening number is same with someone. We will research new.");
	}
	else
	{
		new query[128];
	    mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET brek='%d' WHERE reg_id=%d", brek, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		pData[playerid][pBankRek] = brek;
	}
    return true;
}

function PhoneNumber(playerid, phone)
{
	if(cache_num_rows() > 0)
	{
		//Rekening Exist
		new query[128], rand = RandomEx(1111, 9888);
		new phones = rand+pData[playerid][pID];
		mysql_format(g_SQL, query, sizeof(query), "SELECT phone FROM players WHERE phone='%d'", phones);
		mysql_tquery(g_SQL, query, "PhoneNumber", "is", playerid, phones);
		Info(playerid, "Your Phone number is same with someone. We will research new.");
	}
	else
	{
		new query[128];
	    mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET phone='%d' WHERE reg_id=%d", phone, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		pData[playerid][pPhone] = phone;
	}
    return true;
}

function OnLoginTimeout(playerid)
{
	pData[playerid][LoginTimer] = 0;

	//ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Login", "You have been kicked for taking too long to login successfully to your account.", "Okay", "");
	//KickEx(playerid);
	return 1;
}


function _KickPlayerDelayed(playerid)
{
	Kick(playerid);
	return 1;
}

function SafeLogin(playerid)
{
	// Main Menu Features.
	SetPlayerVirtualWorld(playerid, 0);
	
	//Filtering Invalid UCP Format Name
	if(!IsValidUcpName(pData[playerid][pName]))
    {
        Error(playerid, "Nama tidak sesuai dengan format UCP.");
        Error(playerid, "Penggunaan nama harus mengikuti format UCP.");
        Error(playerid, "Sebagai contoh: Rulay, Kaizo dll.");
        KickEx(playerid);
    }
}

//---------[ Textdraw ]----------

// Info textdraw timer for hiding the textdraw
function InfoTD_MSG(playerid, ms_time, text[])
{
	if(GetPVarInt(playerid, "InfoTDshown") != -1)
	{
	    PlayerTextDrawHide(playerid, InfoTD[playerid]);
	    KillTimer(GetPVarInt(playerid, "InfoTDshown"));
	}

    PlayerTextDrawSetString(playerid, InfoTD[playerid], text);
    PlayerTextDrawShow(playerid, InfoTD[playerid]);
	SetPVarInt(playerid, "InfoTDshown", SetTimerEx("InfoTD_Hide", ms_time, false, "i", playerid));
}

function InfoTD_Hide(playerid)
{
	SetPVarInt(playerid, "InfoTDshown", -1);
	PlayerTextDrawHide(playerid, InfoTD[playerid]);
}

//---------[Admin Function ]----------

function a_ChangeAdminName(otherplayer, playerid, nname[])
{
	if(cache_num_rows() > 0)
	{
		// Name Exists
		Error(playerid, "Akun "DARK_E"'%s' "GREY_E"Telah ada! Harap gunakan yang lain", nname);
	}
	else
	{
		new query[512];
	    format(query, sizeof(query), "UPDATE players SET adminname='%e' WHERE reg_id=%d", nname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		format(pData[otherplayer][pAdminname], MAX_PLAYER_NAME, "%s", nname);
		Servers(playerid, "You has set admin name player %s to %s", pData[otherplayer][pName], nname);
	}
    return true;
}

function LoadStats(playerid, PlayersName[])
{
	if(!cache_num_rows())
	{
		Error(playerid, "Account '%s' does not exist.", PlayersName);
	}
	else
	{
		new email[40], admin, helper, level, levelup, vip, viptime, coin, regdate[40], lastlogin[40], money, bmoney, brek,
			jam, menit, detik, gender, age[40], faction, family, warn, job, job2, int, world;
		cache_get_value_index(0, 0, email);
		cache_get_value_index_int(0, 1, admin);
		cache_get_value_index_int(0, 2, helper);
		cache_get_value_index_int(0, 3, level);
		cache_get_value_index_int(0, 4, levelup);
		cache_get_value_index_int(0, 5, vip);
		cache_get_value_index_int(0, 6, viptime);
		cache_get_value_index_int(0, 7, coin);
		cache_get_value_index(0, 8, regdate);
		cache_get_value_index(0, 9, lastlogin);
		cache_get_value_index_int(0, 10, money);
		cache_get_value_index_int(0, 11, bmoney);
		cache_get_value_index_int(0, 12, brek);
		cache_get_value_index_int(0, 13, jam);
		cache_get_value_index_int(0, 14, menit);
		cache_get_value_index_int(0, 15, detik);
		cache_get_value_index_int(0, 16, gender);
		cache_get_value_index(0, 17, age);
		cache_get_value_index_int(0, 18, faction);
		cache_get_value_index_int(0, 19, family);
		cache_get_value_index_int(0, 20, warn);
		cache_get_value_index_int(0, 21, job);
		cache_get_value_index_int(0, 22, job2);
		cache_get_value_index_int(0, 23, int);
		cache_get_value_index_int(0, 24, world);
		
		new header[248], scoremath = ((level)*5), fac[24], Cache:checkfamily, gstr[2468], query[128];
	
		if(faction == 1)
		{
			fac = "San Andreas Police";
		}
		else if(faction == 2)
		{
			fac = "San Andreas Goverment";
		}
		else if(faction == 3)
		{
			fac = "San Andreas Medic";
		}
		else if(faction == 4)
		{
			fac = "San Andreas News";
		}
		else if(faction == 5)
		{
			fac = "San Andreas Pedagang";
		}
		else if(faction == 6)
		{
			fac = "San Andreas Gojek";
		}
		else if(faction == 6)
		{
			fac = "Mekanik Kota";
		}
		else
		{
			fac = "None";
		}
		
		new name[40];
		if(admin == 1)
		{
			name = ""RED_E"Administrator(1)";
		}
		else if(admin == 2)
		{
			name = ""RED_E"Senior Admin(2)";
		}
		else if(admin == 3)
		{
			name = ""RED_E"Lead Admin(3)";
		}
		else if(admin == 4)
		{
			name = ""RED_E"Head Admin(4)";
		}
		else if(admin== 5)
		{
			name = ""RED_E"Server Owner(5)";
		}
		else if(helper >= 1 && admin == 0)
		{
			name = ""GREEN_E"Helper";
		}
		else
		{
			name = "None";
		}
		
		new name1[30];
		if(vip == 1)
		{
			name1 = ""LG_E"Regular(1)";
		}
		else if(vip == 2)
		{
			name1 = ""YELLOW_E"Premium(2)";
		}
		else if(vip == 3)
		{
			name1 = ""PURPLE_E"VIP Player(3)";
		}
		else
		{
			name1 = "None";
		}
		
		format(query, sizeof(query), "SELECT * FROM `familys` WHERE `ID`='%d'", family);
		checkfamily = mysql_query(g_SQL, query);

		new atext[512];

		new boost = pData[playerid][pBooster];
		new boosttime = pData[playerid][pBoostTime];
		if(boost == 1)
		{
			atext = "{7fff00}Yes";
		}
		else 
		{
			atext = "{ff0000}No";
		}
		
		new rows = cache_num_rows(), fname[128];
		
		if(rows)
		{
			new fam[128];
			cache_get_value_name(0, "name", fam);
			format(fname, 128, fam);
		}
		else
		{
			format(fname, 128, "None");
		}
		
		format(header,sizeof(header),"Stats:"YELLOW_E"%s"WHITE_E" ("BLUE_E"%s"WHITE_E")", PlayersName, ReturnTime());
		format(gstr,sizeof(gstr),""RED_E"In Character"WHITE_E"\n");
		format(gstr,sizeof(gstr),"%sGender: [%s] | Money: ["GREEN_E"%s"WHITE_E"] | Bank: ["GREEN_E"%s"WHITE_E"] | Rekening Bank: [%d] | Phone Number: [None]\n", gstr,(gender == 2) ? ("Female") : ("Male") , FormatMoney(money), FormatMoney(bmoney), brek);
		format(gstr,sizeof(gstr),"%sBirdthdate: [%s] | Job: [None] | Job2: [None] | Faction: [%s] | Family: [%s]\n\n", gstr, age, fac, fname);
		format(gstr,sizeof(gstr),"%s"RED_E"Out of Character"WHITE_E"\n",gstr);
		format(gstr,sizeof(gstr),"%sLevel score: [%d/%d] | Email: [%s] | Warning:[%d/10] | Last Login: [%s]\n", gstr, levelup, scoremath, email, warn, lastlogin);
		format(gstr,sizeof(gstr),"%sStaff: [%s"WHITE_E"] | Time Played: [%d hour(s) %d minute(s) %02d second(s)] | Gold Coin: [%d]\n", gstr, name, jam, menit, detik, coin);
		if(vip != 0)
		{
			format(gstr,sizeof(gstr),"%sInterior: [%d] | Virtual World: [%d] | Register Date: [%s] | VIP Level: [%s"WHITE_E"] | VIP Time: [%s] | Roleplay Booster: [%s"WHITE_E"] | Boost Time: [%s]", gstr, int, world, regdate, name1, ReturnTimelapse(gettime(), viptime), boost, ReturnTimelapse(gettime(), boosttime));
		}
		else
		{
			format(gstr,sizeof(gstr),"%sInterior: [%d] | Virtual World: [%d] | Register Date: [%s] | VIP Level: [%s"WHITE_E"] | VIP Time: [None] | Roleplay Booster: [%s"WHITE_E"] | Boost Time: [%s]", gstr, int, world, regdate, name1, boost, ReturnTimelapse(gettime(), boosttime));
		}
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, header, gstr, "Close", "");
		
		cache_delete(checkfamily);
	}
	return true;
}

function CheckPlayerIP(playerid, zplayerIP[])
{
	new count = cache_num_rows(), datez, line[248], tstr[64], lstr[128];
	if(count)
	{
		datez = 0;
 		line = "";
 		format(line, sizeof(line), "Names matching IP: %s:\n\n", zplayerIP);
 		for(new i = 0; i != count; i++)
		{
			// Get the name  ache and append it to the dialog content
			cache_get_value_index(i, 0, lstr);
			strcat(line, lstr);
			datez ++;

			if(datez == 5)
				strcat(line, "\n"), datez = 0;
			else
				strcat(line, "\t\t");
		}

		tstr = "{ACB5BA}Aliases for {70CAFA}", strcat(tstr, zplayerIP);
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, tstr, line, "Close", "");
	}
	else
 	{
		Error(playerid, "No other accounts from this IP!");
	}
	return 1;
}

function CheckPlayerIP2(playerid, zplayerIP[])
{
	new rows = cache_num_rows(), datez, line[248], tstr[64], lstr[128];
	if(!rows)
	{
		Error(playerid, "No other accounts from this IP!");
	}
	else
 	{
 		datez = 0;
 		line = "";
 		format(line, sizeof(line), "Names matching IP: %s:\n\n", zplayerIP);
 		for(new i = 0; i != rows; i++)
		{
			// Get the name from the cache and append it to the dialog content
			cache_get_value_index(i, 0, lstr);
			strcat(line, lstr);
			datez ++;

			if(datez == 5)
				strcat(line, "\n"), datez = 0;
			else
				strcat(line, "\t\t");
		}

		tstr = "{ACB5BA}Aliases for {70CAFA}", strcat(tstr, zplayerIP);
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, tstr, line, "Close", "");
	}
	return 1;
}

function JailPlayer(playerid)
{
	ShowPlayerDialog(playerid, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
	SetPlayerPositionEx(playerid, -310.64, 1894.41, 34.05, 178.17, 2000);
	SetPlayerInterior(playerid, 10);
	SetPlayerVirtualWorld(playerid, 100);
	SetPlayerWantedLevel(playerid, 0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	//ResetPlayerWeaponsEx(playerid);
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInDoor] = -1;
	pData[playerid][pCuffed] = 0;
	PlayerPlaySound(playerid, 1186, 0, 0, 0);
	return true;
}

function RehabPlayer(playerid)
{
	ShowPlayerDialog(playerid, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
	SetPlayerPositionEx(playerid, 1153.74, -1330.82, -44.28+0.2, 359.26, 2000);
	SetPlayerInterior(playerid, 10);
	SetPlayerVirtualWorld(playerid, 100);
	SetPlayerWantedLevel(playerid, 0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	//ResetPlayerWeaponsEx(playerid);
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInDoor] = -1;
	pData[playerid][pCuffed] = 0;
	PlayerPlaySound(playerid, 1186, 0, 0, 0);
	return true;
}

//-----------[ Banneds Function ]----------

function OnOBanQueryData(adminid, NameToBan[], banReason[], banTime)
{
	new mstr[512];
	mstr = "";
	if(!cache_num_rows())
	{
		Error(adminid, "Account '%s' does not exist.", NameToBan);
	}
	else
	{
		new datez, PlayerIP[16];
		cache_get_value_index(0, 0, PlayerIP);
		if(banTime != 0)
	    {
			datez = gettime() + (banTime * 86400);
            Servers(adminid, "You have temp-banned %s (IP: %s) from the server.", NameToBan, PlayerIP);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Admin %s telah membanned offline player %s selama %d hari. [Reason: %s]", pData[adminid][pAdminname], NameToBan, banTime, banReason);
		}
		else
		{
			Servers(adminid, "You have permanent-banned %s (IP: %s) from the server.", NameToBan, PlayerIP);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Admin %s telah membanned offline player %s secara permanent. [Reason: %s]", pData[adminid][pAdminname], NameToBan, banReason);
		}
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', UNIX_TIMESTAMP(), %d)", NameToBan, PlayerIP, pData[adminid][pAdminname], banReason, datez);
		mysql_tquery(g_SQL, query);
	}
	return true;
}

function OnOBanUcpQueryData(adminid, NameToBan[], banReason[], banTime)
{
	new mstr[512];
	mstr = "";
	if(!cache_num_rows())
	{
		Error(adminid, "Account UCP '%s' does not exist.", NameToBan);
	}
	else
	{
		new datez, PlayerIP[16];
		cache_get_value_index(0, 0, PlayerIP);
		if(banTime != 0)
	    {
			datez = gettime() + (banTime * 86400);
            Servers(adminid, "You have temp-banned %s (IP: %s) from the server.", NameToBan, PlayerIP);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Admin %s telah membanned offline UCP %s selama %d hari. [Reason: %s]", pData[adminid][pAdminname], NameToBan, banTime, banReason);
		}
		else
		{
			Servers(adminid, "You have permanent-banned %s (IP: %s) from the server.", NameToBan, PlayerIP);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Admin %s telah membanned offline UCP %s secara permanent. [Reason: %s]", pData[adminid][pAdminname], NameToBan, banReason);
		}
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', UNIX_TIMESTAMP(), %d)", NameToBan, PlayerIP, pData[adminid][pAdminname], banReason, datez);
		mysql_tquery(g_SQL, query);
	}
	return true;
}


//-------------[ Player Update Function ]----------

function DragUpdate(playerid, targetid)
{
    if(pData[targetid][pDragged] && pData[targetid][pDraggedBy] == playerid)
    {
        static
        Float:fX,
        Float:fY,
        Float:fZ,
        Float:fAngle;

        GetPlayerPos(playerid, fX, fY, fZ);
        GetPlayerFacingAngle(playerid, fAngle);

        fX -= 3.0 * floatsin(-fAngle, degrees);
        fY -= 3.0 * floatcos(-fAngle, degrees);

        SetPlayerPos(targetid, fX, fY, fZ);
        SetPlayerInterior(targetid, GetPlayerInterior(playerid));
        SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
		//ApplyAnimation(targetid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
		ApplyAnimation(targetid,"PED","WALK_civi",4.1,1,1,1,1,1);
    }
    return 1;
}

function UnfreezePee(playerid)
{
    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid);
	StopLoopingAnim(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}

function UnfreezeSleep(playerid)
{
    TogglePlayerControllable(playerid, 1);
    pData[playerid][pEnergy] = 100;
	pData[playerid][pHunger] -= 3;
    ClearAnimations(playerid);
	StopLoopingAnim(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	InfoTD_MSG(playerid, 3000, "Sleeping Done!");
	return 1;
}

function RefullCar(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	//if(!IsValidVehicle(vehicleid)) return 0;
	if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
    {
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{
			new fuels = GetVehicleFuel(vehicleid);
		
			SetVehicleFuel(vehicleid, fuels+300);
			InfoTD_MSG(playerid, 8000, "Refulling done!");
			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has successfully refulling the vehicle.", ReturnName(playerid));
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Refulling fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		}
	}
	else
	{
		Error(playerid, "Refulling fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pActivity]);
		pData[playerid][pActivityTime] = 0;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		return 1;
	}
	return 1;
}

//Bank
function SearchRek(playerid, rek)
{
	if(!cache_num_rows())
	{
		// Rekening tidak ada
		Error(playerid, "Rekening bank "YELLOW_E"'%d' "WHITE_E"tidak terdaftar!", rek);
		pData[playerid][pTransfer] = 0;
	    
	}
	else
	{
	    // Proceed
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "SELECT username,brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRek2", "id", playerid, rek);
	}
}

function SearchRek2(playerid, rek)
{
	if(cache_num_rows())
	{
		new name[128], brek, mstr[128];
		cache_get_value_index(0, 0, name);
		cache_get_value_index_int(0, 1, brek);
		
		//format(pData[playerid][pTransferName], 128, "%s" name);
		pData[playerid][pTransferName] = name;
		pData[playerid][pTransferRek] = brek;
		format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda yakin akan melanjutkan mentransfer?", brek, name, FormatMoney(pData[playerid][pTransfer]));
		ShowPlayerDialog(playerid, DIALOG_BANKCONFIRM, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Transfer", "Cancel");
	}
	return true;
}

//Atm
function SearchRekAtm(playerid, rek)
{
	if(!cache_num_rows())
	{
		// Rekening tidak ada
		Error(playerid, "Rekening bank "YELLOW_E"'%d' "WHITE_E"tidak terdaftar!", rek);
		pData[playerid][pTransfer] = 0;
	    
	}
	else
	{
	    // Proceed
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "SELECT username,brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRekAtm2", "id", playerid, rek);
	}
}

function SearchRekAtm2(playerid, rek)
{
	new id = -1;
	id = GetClosestATM(playerid);
	if(pData[playerid][pTransfer] > AtmData[id][atmStock])
		return Error(playerid, "Mesin atm tidak memiliki stock uang sebanyak itu");

	if(cache_num_rows())
	{
		new name[128], brek, mstr[128];
		cache_get_value_index(0, 0, name);
		cache_get_value_index_int(0, 1, brek);
		
		//format(pData[playerid][pTransferName], 128, "%s" name);
		pData[playerid][pTransferName] = name;
		pData[playerid][pTransferRek] = brek;
		format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda yakin akan melanjutkan mentransfer?", brek, name, FormatMoney(pData[playerid][pTransfer]));
		ShowPlayerDialog(playerid, DIALOG_ATMCONFIRM, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Transfer", "Cancel");
	}
	return true;
}

//----------[ JOB FUNCTION ]-------------

//Server Timer
function pCountDown()
{
	Count--;
	if(0 >= Count)
	{
		Count = -1;
		KillTimer(countTimer);
		foreach(new ii : Player)
		{
 			if(showCD[ii] == 1)
   			{
   				GameTextForPlayer(ii, "~w~GO~r~!~g~!~b~!", 2500, 6);
   				PlayerPlaySound(ii, 1057, 0, 0, 0);
   				showCD[ii] = 0;
			}
		}
	}
	else
	{
		foreach(new ii : Player)
		{
 			if(showCD[ii] == 1)
   			{
				GameTextForPlayer(ii, CountText[Count-1], 2500, 6);
				PlayerPlaySound(ii, 1056, 0, 0, 0);
   			}
		}
	}
	return 1;
}

//Player Update Time
function onlineTimer()
{	
	//Date and Time Textdraw
	new datestring[64];
	new hours,
	minutes,
	days,
	months,
	years;
	new MonthName[12][] =
	{
		"January", "February", "March", "April", "May", "June",
		"July",	"August", "September", "October", "November", "December"
	};
	getdate(years, months, days);
 	gettime(hours, minutes);
	format(datestring, sizeof datestring, "%s%d %s %s%d", ((days < 10) ? ("0") : ("")), days, MonthName[months-1], (years < 10) ? ("0") : (""), years);
	TextDrawSetString(TextDate, datestring);
	format(datestring, sizeof datestring, "[ %s%d:%s%d ]", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
	TextDrawSetString(TextTime, datestring);
	format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
	TextDrawSetString(FVTimeStr, datestring);
	
	foreach(new ii : Player)
	{
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		TextDrawSetString(GenzoVeh[7], datestring);
		format(datestring, sizeof datestring, "%s%d %s %s%d", ((days < 10) ? ("0") : ("")), days, MonthName[months-1], (years < 10) ? ("0") : (""), years);
		TextDrawSetString(HPLOCKSCREEN[26], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		TextDrawSetString(HPLOCKSCREEN[21], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		TextDrawSetString(HPMENUSCREEN[21], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		TextDrawSetString(APKBRIMO[21], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		TextDrawSetString(APKGOJEK[21], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		TextDrawSetString(TelponNotif[21], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		TextDrawSetString(PlayerTelpon[15], datestring);
	}
    /*foreach (new i : Player) 
	{
		SetPlayerTime(i, hours, minutes);
		if(pData[i][pInDoor] <= -1 || pData[i][pInHouse] <= -1 || pData[i][pInBiz] <= -1)
        {
			SetPlayerWeather(i, GetGVarInt("g_Weather"));
		}
	}*/
	// Increase server uptime
	up_seconds ++;
	if(up_seconds == 60)
	{
	    up_seconds = 0, up_minutes ++;
	    if(up_minutes == 60)
	    {
	        up_minutes = 0, up_hours ++;
	        if(up_hours == 24) up_hours = 0, up_days ++;
			new tstr[128], rand = RandomEx(0, 20);
			format(tstr, sizeof(tstr), ""BLUE_E"UPTIME: "WHITE_E"The server has been online for %s.", Uptime());
			SendClientMessageToAll(COLOR_WHITE, tstr);
			if(hours > 18)
			{
				SetWorldTime(0);
				WorldTime = 0;
			}
			else
			{
				SetWorldTime(hours);
				WorldTime = hours;
			}
			SetWeather(rand);
			WorldWeather = rand;

			// Sync Server
			mysql_tquery(g_SQL, "OPTIMIZE TABLE `bisnis`,`houses`,`toys`,`vehicle`");
			
			// Refresh Topten
			RefreshTopTen();
			
			//SetTimer("changeWeather", 10000, false);
		}
	}
	foreach(new bid : Bisnis)
	{
		if(strcmp(bData[bid][bOwner], "-"))
		{
			if(bData[bid][bVisit] != 0 && bData[bid][bVisit] <= gettime())
			{
				Bisnis_Reset(bid);
				Bisnis_Save(bid);
			}
		}
	}
	foreach(new hid : Houses)
	{
		if(strcmp(hData[hid][hOwner], "-"))
		{
			if(hData[hid][hVisit] != 0 && hData[hid][hVisit] <= gettime())
			{
				HouseReset(hid);
				House_Save(hid);
			}
		}
	}
	foreach(new venid : Vending)
	{
		if(strcmp(vmData[venid][venOwner], "-"))
		{
			if(vmData[venid][venVisit] != 0 && vmData[venid][venVisit] <= gettime())
			{
				Vending_Reset(venid);
				Vending_Save(venid);
			}
		}
	}
	foreach(new drid : Dealer)
	{
		if(strcmp(drData[drid][dOwner], "-"))
		{
			if(drData[drid][dVisit] != 0 && drData[drid][dVisit] <= gettime())
			{
				Dealer_Reset(drid);
				Dealer_Save(drid);
			}
		}
	}
	foreach(new ii : Player)
	{
		// Online Timer
		if(pData[ii][IsLoggedIn] == true /*&& cAFK[ii] == 0*/)
		{
			pData[ii][pPaycheck] ++;
			/*if(pData[ii][pPaycheck] >= 3600)
			{
				Info(ii, "Waktunya mengambil paycheck!");
				Servers(ii, "silahkan pergi ke bank atau ATM terdekat untuk mengambil paycheck.");
			}*/
			
			pData[ii][pSeconds] ++, pData[ii][pCurrSeconds] ++;
			if(pData[ii][pOnDuty] >= 1)
			{
				//pData[ii][pOnDutyTime]++;
			}
			if(pData[ii][pTaxiDuty] >= 1)
			{
				pData[ii][pTaxiTime]++;
			}
			if(pData[ii][pSeconds] == 60)
			{
				new scoremath = ((pData[ii][pLevel])*5);

		    	pData[ii][pMinutes]++, pData[ii][pCurrMinutes] ++;
		    	pData[ii][pSeconds] = 0, pData[ii][pCurrSeconds] = 0;
				
				switch(pData[ii][pMinutes])
				{
					case 20:
					{
						if(pData[ii][pBooster] == 1)
						{
							AddPlayerSalary(ii, "Bonus Boost ( RP Booster )", 2500);
						}
						Servers(ii, "Gunakan "YELLOW_E"'/help'"WHITE_E" untuk melihat command");
						Servers(ii, "Gunakan "YELLOW_E"'/ask'"WHITE_E" untuk bertanya & "YELLOW_E"'/report'"WHITE_E" untuk melaporkan seseorang");
					}
				    case 40:
		            {
					    /*if(pData[ii][pHours] != 0)
					   	{
						   	format(lstr, sizeof(lstr), "~y~You have been online for ~r~~h~%d~y~ hours and ~r~~h~%d~y~ minutes.", pData[ii][pHours], pData[ii][pMinutes]);
							format(mstr, sizeof(mstr), ""RED_E"*** {FFE4C4}You have been online for %d hours and %d minutes.", pData[ii][pHours], pData[ii][pMinutes]);
						}
						else
						{
				            format(lstr, sizeof(lstr), "~y~You have been online for ~r~~h~%d~y~ minutes.", pData[ii][pMinutes]);
							format(mstr, sizeof(mstr), ""RED_E"*** {FFE4C4}You have been online for %d minutes.", pData[ii][pMinutes]);
						}
						InfoTD_MSG(ii, 10000, lstr);
						SendClientMessage(ii, 0xFFE4C4FF, mstr);
 						PlayerPlaySound(ii, 1138, 0.0, 0.0, 0.0);*/
						//SetPlayerTime(ii, hours, minutes);
						if(pData[ii][pBooster] == 1)
						{
							pData[ii][pPaycheck] = 3601;
						}
						if(pData[ii][pPaycheck] >= 3600)
						{
							Info(ii, "Waktunya mengambil paycheck!");
							Servers(ii, "silahkan pergi ke bank atau ATM terdekat untuk mengambil paycheck.");
							PlayerPlaySound(ii, 1139, 0.0, 0.0, 0.0);
						}
						//Servers(ii, "Gunakan "YELLOW_E"'/claimsp'"WHITE_E" untuk mendapatkan starter pack");
					}
					case 60:
					{
						if(pData[ii][pPaycheck] >= 3600)
						{
							Info(ii, "Waktunya mengambil paycheck!");
							Servers(ii, "silahkan pergi ke bank atau ATM terdekat untuk mengambil paycheck.");
							PlayerPlaySound(ii, 1139, 0.0, 0.0, 0.0);
						}
						
						pData[ii][pHours] ++;
						pData[ii][pLevelUp] += 1;
						pData[ii][pMinutes] = 0;
						UpdatePlayerData(ii);
			            
						/*PlayerPlaySound(ii, 1139, 0.0, 0.0, 0.0);

						if(pData[ii][pHours] != 1)
						{
							format(lstr, sizeof(lstr), "~y~You have been online for ~r~~h~%d~y~ hours.", pData[ii][pHours]);
							format(mstr, sizeof(mstr), ""RED_E"*** {FFE4C4}You have been online for %d hours.", pData[ii][pHours]);
						}
						else
						{
						    format(lstr, sizeof(lstr), "~y~You have been online for ~r~~h~one~y~ hour.");
						    format(mstr, sizeof(mstr), ""RED_E"*** {FFE4C4}You have been online for an hour.");
						}
						InfoTD_MSG(ii, 10000, lstr);
						SendClientMessage(ii, 0xFFE4C4FF, mstr);*/
						if(pData[ii][pLevelUp] >= scoremath)
						{
							new mstr[128];
							pData[ii][pLevel] += 1;
							pData[ii][pHours] ++;
							SetPlayerScore(ii, pData[ii][pLevel]);
							format(mstr,sizeof(mstr),"~g~Level Up!~n~~w~Sekarang anda level ~r~%d", pData[ii][pLevel]);
							GameTextForPlayer(ii, mstr, 6000, 1);
						}
					}
				}
				if(pData[ii][pCurrMinutes] == 60)
				{
				    pData[ii][pCurrMinutes] = 0;
				    pData[ii][pCurrHours] ++;
				}
			}
   		}
		
		// Booster Expired Checking
		if(pData[ii][pBooster] > 0)
		{
			if(pData[ii][pBoostTime] != 0 && pData[ii][pBoostTime] <= gettime())
			{
				Info(ii, "Maaf, Booster player anda sudah habis! sekarang anda adalah player biasa!");
				pData[ii][pBooster] = 0;
				pData[ii][pBoostTime] = 0;
			}
		}
		//VIP Expired Checking
		if(pData[ii][pVip] > 0)
		{
			if(pData[ii][pVipTime] != 0 && pData[ii][pVipTime] <= gettime())
			{
				Info(ii, "Maaf, Level VIP player anda sudah habis! sekarang anda adalah player biasa!");
				pData[ii][pVip] = 0;
				pData[ii][pVipTime] = 0;
			}
		}
		//ID Card Expired Checking
		if(pData[ii][pIDCard] > 0)
		{
			if(pData[ii][pIDCardTime] != 0 && pData[ii][pIDCardTime] <= gettime())
			{
				Info(ii, "Masa berlaku ID Card anda telah habis, silahkan perpanjang kembali!");
				pData[ii][pIDCard] = 0;
				pData[ii][pIDCardTime] = 0;
			}
		}
		//BPJS
		if(pData[ii][pBPJS] > 0)
		{
			if(pData[ii][pBPJSTime] != 0 && pData[ii][pBPJSTime] <= gettime())
			{
				Info(ii, "Masa berlaku BPJS anda telah habis, silahkan perpanjang kembali!");
				pData[ii][pBPJS] = 0;
				pData[ii][pBPJSTime] = 0;
			}
		}
		//Weapon License Expired
		if(pData[ii][pWeapLic] > 0)
		{
			if(pData[ii][pWeapLicTime] != 0 && pData[ii][pWeapLicTime] <= gettime())
			{
				Info(ii, "Masa berlaku Weapon License anda telah habis, silahkan perpanjang kembali!");
				pData[ii][pWeapLic] = 0;
				pData[ii][pWeapLicTime] = 0;
			}
		}
		//Robbing Expired
		if(pData[ii][pRobbing] > 0)
		{
			if(pData[ii][pRobbingTime] != 0 && pData[ii][pRobbingTime] <= gettime())
			{
				Info(ii, "Robbing time anda telah selesai, kamu bisa melakukan perampokan kembali!");
				pData[ii][pRobbing] = 0;
				pData[ii][pRobbingTime] = 0;
			}
		}
		//Lumber License
		if(pData[ii][pLumberLic] > 0)
		{
			if(pData[ii][pLumberLicTime] != 0 && pData[ii][pLumberLicTime] <= gettime())
			{
				Info(ii, "Masa berlaku Lumber License anda telah habis, silahkan perpanjang kembali!");
				pData[ii][pLumberLic] = 0;
				pData[ii][pLumberLicTime] = 0;
			}
		}
		//Trucker License
		if(pData[ii][pTruckLic] > 0)
		{
			if(pData[ii][pTruckLicTime] != 0 && pData[ii][pTruckLicTime] <= gettime())
			{
				Info(ii, "Masa berlaku Truck License anda telah habis, silahkan perpanjang kembali!");
				pData[ii][pTruckLic] = 0;
				pData[ii][pTruckLicTime] = 0;
			}
		}

		if(pData[ii][pExitJob] != 0 && pData[ii][pExitJob] <= gettime())
		{
			Info(ii, "Now you can exit from your current job!");
			pData[ii][pExitJob] = 0;
		}
		if(pData[ii][pDriveLic] > 0)
		{
			if(pData[ii][pDriveLicTime] != 0 && pData[ii][pDriveLicTime] <= gettime())
			{
				Info(ii, "Masa berlaku Driving anda telah habis, silahkan perpanjang kembali!");
				pData[ii][pDriveLic] = 0;
				pData[ii][pDriveLicTime] = 0;
			}
		}
		//Player JobTime Delay
		if(pData[ii][pJobTime] > 0)
		{
			pData[ii][pJobTime]--;
		}
		if(pData[ii][pSideJobTime] > 0)
		{
			pData[ii][pSideJobTime]--;
		}
		// Duty Delay
		if(pData[ii][pDutyHour] > 0)
		{
			pData[ii][pDutyHour]--;
		}
		// Rob Delay
		if(pData[ii][pRobTime] > 0)
		{
			pData[ii][pRobTime]--;
		}
		// Get Loc timer
		if(pData[ii][pSuspectTimer] > 0)
		{
			pData[ii][pSuspectTimer]--;
		}
		// Speedcam Timer
		if(pData[ii][TimerSpeedcam] > 0)
		{
			pData[ii][TimerSpeedcam]--;
		}
		//Warn Player Check
		if(pData[ii][pWarn] >= 20)
		{
			new ban_time = gettime() + (5 * 86400), query[512], PlayerIP[16], giveplayer[24];
			GetPlayerIp(ii, PlayerIP, sizeof(PlayerIP));
			GetPlayerName(ii, giveplayer, sizeof(giveplayer));
			pData[ii][pWarn] = 0;
			//SetPlayerPosition(ii, 227.46, 110.0, 999.02, 360.0000, 10);
			BanPlayerMSG(ii, ii, "20 Total Warning", true);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Player %s(%d) telah otomatis dibanned permanent dari server. [Reason: 20 Total Warning]", giveplayer, ii);
			
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', 'Server Ban', '20 Total Warning', %i, %d)", giveplayer, PlayerIP, gettime(), ban_time);
			mysql_tquery(g_SQL, query);
			KickEx(ii);
		}
		//Farmer
		if(pData[ii][pPlant] >= 20)
		{
			pData[ii][pPlant] = 0;
			pData[ii][pPlantTime] = 600;
		}
		if(pData[ii][pPlantTime] > 0)
		{
			pData[ii][pPlantTime]--;
			if(pData[ii][pPlantTime] < 1)
			{
				pData[ii][pPlantTime] = 0;
				pData[ii][pPlant] = 0;
			}
		}
		new pid = GetClosestPlant(ii);
		if(pid != -1)
		{
			if(IsPlayerInDynamicCP(ii, PlantData[pid][PlantCP]) && pid != -1)
			{
				new type[24], mstr[128];
				if(PlantData[pid][PlantType] == 1)
				{
					type = "Potato";
				}
				else if(PlantData[pid][PlantType] == 2)
				{
					type = "Wheat";
				}
				else if(PlantData[pid][PlantType] == 3)
				{
					type = "Orange";
				}
				else if(PlantData[pid][PlantType] == 4)
				{
					type = "Marijuana";
				}
				if(PlantData[pid][PlantTime] > 1)
				{
					format(mstr, sizeof(mstr), "~w~Plant Type: ~g~%s ~n~~w~Plant Time: ~r~%s", type, ConvertToMinutes(PlantData[pid][PlantTime]));
					InfoTD_MSG(ii, 1000, mstr);
				}
				else
				{
					format(mstr, sizeof(mstr), "~w~Plant Type: ~g~%s ~n~~w~Plant Time: ~g~Now", type);
					InfoTD_MSG(ii, 1000, mstr);
				}
			}
		}
	}
	return 1;
}

//----------[ Other Function ]-----------

function SetPlayerToUnfreeze(playerid, Float:x, Float:y, Float:z, Float:a)
{
    if(!IsPlayerInRangeOfPoint(playerid, 15.0, x, y, z))
        return 0;

    pData[playerid][pFreeze] = 0;
    SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, a);
    TogglePlayerControllable(playerid, 1);
    return 1;
}

function SetVehicleToUnfreeze(playerid, vehicleid, Float:x, Float:y, Float:z, Float:a)
{
    if(!IsPlayerInRangeOfPoint(playerid, 15.0, x, y, z))
        return 0;

    pData[playerid][pFreeze] = 0;
    SetVehiclePos(vehicleid, x, y, z);
	SetVehicleZAngle(vehicleid, a);
    TogglePlayerControllable(playerid, 1);
    return 1;
}

//NERF DARAH KETIKA VALUE LAPAR ATAU HAUS DIBAWAH 5
function NerfHpEnegyHunger(playerid)
{
	if(pData[playerid][pSpawned] == 1 && pData[playerid][IsLoggedIn] == true)
	{
		if(pData[playerid][pInjured] == 0 || pData[playerid][pHospital] == 0 || pData[playerid][pJail] == 0)
		{
			if(pData[playerid][pHunger] <= 5 || pData[playerid][pEnergy] <= 5)
			{
				if(pData[playerid][pNerfHP] != 0)
				{
					new Float:health;
					pData[playerid][pNerfHP] = 0;
					GetPlayerHealth(playerid, Float:health);
					SetPlayerHealthEx(playerid, health - 3);
					Info(playerid, "Kamu harus makan dan minum agar darahmu tidak berkurang!");
				}
			}
		}
	}
	return 1;
}

function ShowRedScreen(playerid)
{
	if(pData[playerid][pRedScreen] <= 8)
	{
		TextDrawHideForPlayer(playerid, Text:RedScreen);
		SetTimerEx("DirectRedScreen", 2000, 0, "d", playerid);
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		{
			ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
		}
	}
	else
	{
		pData[playerid][pRedScreen] = 0;
		TextDrawHideForPlayer(playerid, Text:RedScreen);
		SetPlayerDrunkLevel(playerid, 0);
		ClearAnimations(playerid, 1);
		StopLoopingAnim(playerid);
	}
	return 1;
}

function DirectRedScreen(playerid)
{
	pData[playerid][pRedScreen] += 1;
	TextDrawShowForPlayer(playerid, Text:RedScreen);
	SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
	return 1;
}

function ChangeTwitterName(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new str[254];
		format(str, sizeof(str), "ERROR: Sudah ada akun twitter yang memiliki username tersebut!\n\nUsername mu sekarang: @%s\nMasukan nama twitter yang kamu inginkan:", pData[playerid][pTwittername]);
		ShowPlayerDialog(playerid, TWITTER_NAME, DIALOG_STYLE_INPUT, "Twitter Name", str, "Yes", "No");
	}
	else
	{
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET twittername = '%s' WHERE reg_id = '%d'", name, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);

		format(pData[playerid][pTwittername], 40, name);
		Info(playerid, "Kamu telah merubah username twitter mu menjadi @%s", pData[playerid][pTwittername]);
	}
	return 1;
}

function TimerUntogglePlayer(playerid)
{
	TogglePlayerControllable(playerid, 1);
	return 1;
}

RefreshTopTen()
{
	mysql_tquery(g_SQL, "SELECT username, hours FROM players WHERE hours > 0 ORDER BY hours DESC LIMIT 10", "SetStringTopTen");
	return 1;
}

function SetStringTopTen()
{
	new username[MAX_PLAYER_NAME], ontime, string[1024];

	string = "~y~Top ten players:~w~";
    new rows = cache_num_rows();
    if(!rows)
	{
    	strcat(string, "~n~- n/a");
    }
    else
    {
	    for(new i = 0; i < rows; i ++)
	    {
	        cache_get_value_name(i, "username", username);
	        cache_get_value_name_int(i, "hours", ontime);
	        format(string, sizeof(string), "%s~n~%s (%i hrs)", string, username, ontime);
		}
	}
	TextDrawSetString(TopTenList, string);
    return 1;
}

function ShowPlayerTopTen(playerid)
{
	TextDrawShowForPlayer(playerid, TopTenList);
	return 1;
}

function VipSetNumber(playerid, phnumber)
{
	new rows = cache_num_rows();
	if(rows > 0)
	{
		Error(playerid, "Nomor tersebut sudah yang memiliki!");
	}
	else
	{
		pData[playerid][pPhone] = phnumber;
		pData[playerid][pVipNumber] = gettime() + 30;
		Info(playerid, "Kamu telah merubah nomor hanphone mu menjadi "YELLOW_E"%d"WHITE_E"", pData[playerid][pPhone]);

		new cQuery[254];
		mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET phone = '%d' WHERE reg_id = '%d'", phnumber, pData[playerid][pID]);
		mysql_tquery(g_SQL, cQuery);
	}
}

function AdminSetNumber(playerid, phnumber)
{
	new rows = cache_num_rows();
	if(rows > 0)
	{
		Error(playerid, "Nomor tersebut sudah yang memiliki!");
	}
	else
	{
		pData[playerid][pPhone] = phnumber;
		Info(playerid, "Kamu telah merubah nomor hanphone mu menjadi "YELLOW_E"%d"WHITE_E"", pData[playerid][pPhone]);

		new cQuery[254];
		mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET phone = '%d' WHERE reg_id = '%d'", phnumber, pData[playerid][pID]);
		mysql_tquery(g_SQL, cQuery);
	}
}

function cookingsacf(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMasak])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.5, 332.35, -1829.42, 4.49))
			{
				ShowNotifInfo(playerid, "Anda telah berhasil membuatn makan/minuman", 10000);
				ShowNotifSukses(playerid, "Cooking Succes!", 10000);
				TogglePlayerControllable(playerid, 1);
				KillTimer(pData[playerid][pMasak]);

				pData[playerid][pLoading] = false;

				pData[playerid][pActivityTime] = 0;
				pData[playerid][pEnergy] -= 3;
				ClearAnimations(playerid);
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.5, 332.35, -1829.42, 4.49))
			{
				pData[playerid][pActivityTime] += 5;
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}

function restartserver(playerid)
{
	SendRconCommand("hostname Konoha ROLEPLAY");
	SendRconCommand("password 0");
	GameTextForAll("Server will restart in 10 seconds", 200, 3);
	foreach(new i : Player)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			RemovePlayerFromVehicle(playerid);
		}
		RemovePlayerVehicle(playerid);
		Report_Clear(playerid);
		Ask_Clear(playerid);
		FactionCall_Clear(playerid);
		Player_ResetCutting(playerid);
		Player_RemoveLumber(playerid);
		Player_ResetHarvest(playerid);
		Player_ResetBoombox(playerid);
		Player_ResetPayphone(playerid);
		Player_ResetDamageLog(playerid);
		Player_ResetAdsLog(playerid);
		KillTazerTimer(playerid);
		//SaveLunarSystem(playerid);
		UpdateWeapons(playerid);
		UpdatePlayerData(playerid);
		GameTextForPlayer(i, "~r~R~g~estart", 9000, 0);
		SetPlayerInterior(i,0);
		TogglePlayerControllable(i, 0);
		InterpolateCameraPos(i, 1294.263549, -1337.225830, 278.767089, 1337.283325, -1430.924926, 68.419837, 10000);
		InterpolateCameraLookAt(i, 1291.685546, -1333.435791, 276.769744, 1339.189086, -1435.458740, 67.518539, 10000);
		SendClientMessageToAll(-1, "Ini me-restart server. Database aman tidak bakal roleback...");
		KickEx(i);
	}

	new DCC_Channel:mt, DCC_Embed:logss;
	new y, m, d, timestamp[200];
	getdate(y, m , d);
	mt = DCC_FindChannelById("1101630354625921084");
	format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
	logss = DCC_CreateEmbed("Konoha ROLEPLAY");
	DCC_SetEmbedTitle(logss, "Konoha");
	DCC_SetEmbedTimestamp(logss, timestamp);
	DCC_SetEmbedColor(logss, 0xff0000);
	DCC_SetEmbedImage(logss, "");
	DCC_SetEmbedThumbnail(logss, "");
	DCC_SetEmbedFooter(logss, "Konoha", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "RESTART SERVER");
	format(stroi, sizeof(stroi), "@everyone");
	DCC_AddEmbedField(logss, "SERVER STATUS:", stroi, true);
	DCC_SendChannelEmbedMessage(mt, logss);


	print("====================================");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("Server Restarting...					");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("										");
	print("====================================");
	return GameModeExit();	
}

function DelayUnfreeze(playerid)
{
    TogglePlayerControllable(playerid, 1);
}

stock LoadingObject(playerid)
{
    TogglePlayerControllable(playerid, 0);
    SetTimerEx("DelayUnfreeze", 10000, 0, "i", playerid);
}

function pakebandage(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pTimebandage])) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		GameTextForPlayer(playerid, "~w~SELESAI!", 5000, 3);
		TogglePlayerControllable(playerid, 1);
		KillTimer(pData[playerid][pTimebandage]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pLoading] = false;
		ClearAnimations(playerid);

		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

		new Float:darahhh;
		GetPlayerHealth(playerid, darahhh);
		SetPlayerHealthEx(playerid, darahhh+15);
		InfoTD_MSG(playerid, 3000, "Restore +15 Health");
		Inventory_Remove(playerid, "Bandage", 1);
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 20;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	}
	return 1;
}

stock GetName(playerid)
{
	new name[MAX_PLAYER_NAME];
 	GetPlayerName(playerid,name,sizeof(name));
	return name;
}

GetRPName(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));

	for(new i = 0, l = strlen(name); i < l; i ++)
	{
	    if(name[i] == '_')
	    {
	        name[i] = ' ';
		}
	}

	return name;
}

stock SetPlayerChainsaw(playerid, bool:use) 
{
    if (use) 
    {
        for (new i = MAX_PLAYER_ATTACHED_OBJECTS - 1; i != 0; i--) 
        {
            if (!IsPlayerAttachedObjectSlotUsed(playerid, i)) 
            {
                SetPlayerAttachedObject(playerid, i, 341, 6);
                SetPVarInt(playerid, "Chainsaw_Index", i);
                PlayerData[playerid][pChainsaw] = true;
                return 1;
            }
        }
        return -1;
    } else 
    {
        RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "Chainsaw_Index"));
        DeletePVar(playerid, "Chainsaw_Index");
        PlayerData[playerid][pChainsaw] = false;
    }
    return 1;
}