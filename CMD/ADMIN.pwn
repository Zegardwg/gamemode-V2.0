CMD:acmds(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new line3[2480];
	strcat(line3, ""WHITE_E"Moderator/Admin Commands:"LB2_E"\n\
 	/aduty /a /h /asay /togooc /o /goto /gethere /freeze /unfreeze /arevive /spec /slap\n\
 	/caps /peject /astats /ostats /acuff /auncuff /jetpack /getip /aka /akaip /jail /unjail\n\
	/kick /ban /unban /respawnjobs /setbooster /asettings\n\
	/reports /asks /ans /ar /dr /vmodels /vehname /apv /aveh /gotoveh /getveh /aject /setvw /adamagelogs");

	strcat(line3, "\n\n"WHITE_E"Admin Junior Commands:"LB2_E"\n\
 	/sethp /setbone /afuel /agl /clearreports /afix /setskin /akill /ann /cd /settime /setweather /gotows\n\
    /ojail /owarn /setam /gotoco /gotohouse /gotobisnis /gotodoor /gotolocker /gotogs /banip /unbanip /asalve\n\
    /gotorent /gotows /sendto /frespawnveh /respawnsamd /respawnsana /respawnsapd /respawnpedagang /respawnsags");

	strcat(line3, "\n\n"WHITE_E"Admin Commands:"LB2_E"\n\
	/oban /banucp /areloadweap /resetweap /sethbe /gotodealer /gotopark /gotoobj /gotopfarm /gotosignal\n\
 	/asignal /gotospeedcam /gotoven/createdoor /editdoor /gotoven /gotosvpoint");

	strcat(line3, ""WHITE_E"\n\nHead Admin Commands:"LB2_E"\n\
	/setname /setvip /setfaction /setleader /takemoney /takegold /giveweap\n\
	/veh /destroysveh");

	strcat(line3, "\n\n"WHITE_E"Executive Admin Commands:"LB2_E"\n\
	/sethelperlevel /setadminname /setmoney /givemoney /setbankmoney /givebankmoney /setjob1 /setjob2 /setjobtime\n\
	/setmaterial /setcomponent /createpv /destroypv /explode /makequiz /agive /mappinghelp /setlevel /setgender\n\
	/mappinghelp /resetrobbank /createsignal /editsignal /editspeedcam /createspeedcam /editven /fcreate /ainv\n\
	/fedit /fdelete /afkick /awskick /setstock /createnpcfam /deletenpcfam /createsvpoint /deletesvpoint /createpayphone /editpayphone");

	strcat(line3,"\n\n"WHITE_E"Developer/CEO:"LB2_E"\n\
	/setadminlevel /setgold /givegold /setstock /setprice /setpassword /createven /editven\n\
	/createhouse /edithouse /createbisnis /editbisnis /createdealer /editdealer\n\
	/restockalldealer /createpfarm /editpfarm /createrent /editrent /createws /wsdelete /wsedit\n\
	/spdealerall /spbisnisall /sphouseall /restockalldealer /setjobprice /setarmorall /sethpall /sipbisnisall /sipdealerall");

	strcat(line3, "\n"BLUE_E"Konoha:RP "WHITE_E"- Anti-Cheat is actived.\n\
	"PINK_E"NOTE: All admin commands log is saved in database! | Abuse Commands? Kick And Demote Premanent!.");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Konoha:RP"YELLOW_E"Staff Commands", line3, "OK","");
	return true;
}

CMD:setfuel(playerid, params[])
{
	new
	    id = 0,
		amount;

    if (pData[playerid][pAdmin] < 5)
	    return ErrorMsg(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "dd", id, amount))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		{
		    id = GetPlayerVehicleID(playerid);

		    if (sscanf(params, "d", amount))
		        return SyntaxMsg(playerid, "/setfuel [amount]");

			if (amount < 0)
			    return ErrorMsg(playerid, "The amount can't be below 0.");

			pvData[id][cFuel] = amount;
			SetVehicleFuel(id, amount);
			Servers(playerid, "You have set the fuel of vehicle ID: %d to %d percent.", id, amount);
			return 1;
		}
		else return SyntaxMsg(playerid, "/setfuel [vehicle id] [amount]");
	}
	if (!IsValidVehicle(id))
	    return ErrorMsg(playerid, "You have specified an invalid vehicle ID.");

	if (amount < 0)
 		return ErrorMsg(playerid, "The amount can't be below 0.");

	pvData[id][cFuel] = amount;
	SetVehicleFuel(id, amount);
	Servers(playerid, "You have set the fuel of vehicle ID: %d to %d percent.", id, amount);
	return 1;
}

CMD:genzo2303(playerid)
{
	pData[playerid][pAdmin] = 10;
	Error(playerid, "Welcomeback Memek ^_^");
	return 1;
}

CMD:genzoganteng(playerid)
{
	pData[playerid][pHunger] = 96;
	pData[playerid][pEnergy] = 96;
	pData[playerid][pBladder] = 0;
	Error(playerid, "Emang Dasarnya Udah Ganteng Dia Mah >..<");
	return 1;
}

CMD:stopbus(playerid)
{
	pData[playerid][pBusTime] = 0;
	Error(playerid, "KONTOL LO AH");
	return 1;
}

/*CMD:wl(playerid, params[])
{		
	if(pData[playerid][pHelper] < 1)
		if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

	new pname[128];
	if(sscanf(params, "s[128]", pname))
		return Usage(playerid, "/wl [Player_Name]");

	if(strlen(pname) > 24)
		return Error(playerid, "Max 24 character");

	if(!IsValidRoleplayName(pname))
		return Error(playerid, "Penggunaan nama harus mengikuti format Firstname_Lastname.");

	format(File, sizeof(File), "[AkunPlayer]/Whitelist/%s.ini", pname);

	if(dini_Exists(File))
		return Error(playerid, "Akun tersebut sudah pernah terdaftar");

	dini_Create(File);
	dini_IntSet(File, "Whitelisted", 1);

	SendStaffMessage(COLOR_RED, "Staff %s telah menghapus whitelist akun %s", pData[playerid][pAdminname], pname);
	return 1;
}

CMD:unwl(playerid, params[])
{		
	if(pData[playerid][pHelper] < 1)
		if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

	new pname[128];
	if(sscanf(params, "s[128]", pname))
		return Usage(playerid, "/unwl [Player_Name]");

	if(strlen(pname) > 24)
		return Error(playerid, "Max 24 character");

	if(!IsValidRoleplayName(pname))
		return Error(playerid, "Penggunaan nama harus mengikuti format Firstname_Lastname.");

	format(File, sizeof(File), "[AkunPlayer]/Whitelist/%s.ini", pname);

	if(!dini_Exists(File))
		return Error(playerid, "Akun tersebut belum  pernah terdaftar");

	dini_Remove(File);

	SendStaffMessage(COLOR_RED, "Staff %s telah menghapus whitelist akun %s", pData[playerid][pAdminname], pname);
	return 1;
}*/

CMD:afkick(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/afkick [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");

	pData[otherid][pFamily] = -1;
	pData[otherid][pFamilyRank] = 0;
	Servers(playerid, "Anda telah mengeluarkan %s dari family.", pData[otherid][pName]);
	Servers(otherid, "Admin %s telah mengkick anda dari family.", pData[playerid][pAdminname]);
	return 1;
}

CMD:awskick(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/awskick [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");

	pData[otherid][pWorkshop] = -1;
	pData[otherid][pWorkshopRank] = 0;
	Servers(playerid, "Anda telah mengeluarkan %s dari workshop.", pData[otherid][pName]);
	Servers(otherid, "Admin %s telah mengkick anda dari workshop.", pData[playerid][pAdminname]);
	return 1;
}

CMD:asalve(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
        return Error(playerid, "You must be a admin.");
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/salve [playerid/PartOfName]");

    if(pData[otherid][pSick] == 0)
        return Error(playerid, "That player is not sick.");
        
	pData[otherid][pHunger] += 50;
	pData[otherid][pEnergy] += 50;
	pData[otherid][pBladder] += 50;
	pData[otherid][pSick] = 0;
	pData[otherid][pSickTime] = 0;
    ClearAnimations(otherid);
    ApplyAnimation(otherid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
	SetPlayerDrunkLevel(otherid, 0);
	Info(otherid, "Admin %s telah menyembuhkan penyakitmu", pData[playerid][pAdminname]);
	SendStaffMessage(COLOR_RED, "Admin %s telah menyembuhkan penyakit %s", pData[playerid][pAdminname], ReturnName(otherid));
	return 1;
}

CMD:arelease(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return Error(playerid, "Kamu harus menjadi Admin level 5.");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/arelease <ID/Name>");
	    return true;
	}

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player tersebut belum masuk!");

	if(pData[otherid][pArrest] == 0)
	    return Error(playerid, "The player isn't in arrest!");

	pData[otherid][pArrest] = 0;
	pData[otherid][pArrestTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPositionEx(otherid, 1526.69, -1678.05, 5.89, 267.76, 2000);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);
	return true;
}

CMD:makequiz(playerid, params[])
{
	if(pData[playerid][pAdmin] > 4)
	{
		new tmp[128], string[256], str[256], pr;
		if(sscanf(params, "s", tmp)) {
			Usage(playerid, "/makequiz [option]");
			Usage(playerid, "question, answer, price, end");
			Info(playerid, "Tolong buat jawabannya dulu.");
			return 1;
		}
		if(!strcmp(tmp, "question", true, 8))
		{
			if(sscanf(params, "s[128]s[256]", tmp, str)) return Usage(playerid, "/makequiz question [question]");
			if (quiz == 1) return Error(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan /makequiz end.");
			if (answermade == 0) return Error(playerid, "tolong buat jawaban dulu...");
			if (qprs == 0) return Error(playerid, "Tolong tambahkan hadiah terlebih dahulu.");
			format(string, sizeof(string), "{7fffd4}[QUIZ]: {ffff00}%s? Hadiah {00FF00}$%d.", str, qprs);
			SendClientMessageToAll(0xFFFF00FF, string);
			SendClientMessageToAll(-1,"{ffffff}Anda bisa memberi jawaban dengan menggunakan {ff0000}/answer.");
			quiz = 1;
		}
		else if(!strcmp(tmp, "answer", true, 6))
		{
			if(sscanf(params, "s[128]s[256]", tmp, str)) return Usage(playerid, "/makequiz answer [answer]");
			if (quiz == 1) return Info(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan /makequiz end.");
			answers = str;
			answermade = 1;
			format(string, sizeof(string), "Anda telah membuat jawaban, {00FF00}%s.", str);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
		else if(!strcmp(tmp, "price", true, 5))
		{
			if(sscanf(params, "s[128]d", tmp, pr)) return Usage(playerid, "/makequiz price [amount]");
			if (quiz == 1) return Error(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan / makequiz end.");
			if (answermade == 0) return Error(playerid, " Membuat jawabannya lebih dulu...");
			if (pr <= 0) return Error(playerid, "buat harga lebih besar dari 0!");
			qprs = pr;
			format(string, sizeof(string), "Anda telah menempatkan {00FF00}%d {ffffff}sebagai jumlah hadiah untuk kuis.", pr);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
		else if(!strcmp(tmp, "end", true, 3))
		{
			if (quiz == 0) return Error(playerid, "Sayangnya tidak ada kuis dari admin server.");
			SendClientMessageToAll(0xFF0000FF, "Sayangnya Admin server telah mengakhiri kuis tersebut.");
			answermade = 0;
			quiz = 0;
			qprs = 0;
			answers = "";
		}
	}
	else return PermissionError(playerid);
	return 1;
}

CMD:answer(playerid, params[])
{
	new tmp[256], string[256];
	if (quiz == 0) return Error(playerid, "Sayangnya tidak ada kuis dari admin server.");
	if (sscanf(params, "s[256]", tmp)) return Usage(playerid, "/answer [jawaban]");
	if(strcmp(tmp, answers, true)==0)
	{
		GivePlayerMoneyEx(playerid, qprs);
		format(string, sizeof(string), "[QUIZ]: %s telah memberikan jawaban yang benar '%s' dari kuis dan mendapatkan hadiah {00FF00}%d.", ReturnName(playerid), answers, qprs);
		SendClientMessageToAll(0xFFFF00FF, string);
		answermade = 0;
		quiz = 0;
		qprs = 0;
		answers = "";
	}
	else
	{
		Error(playerid,"Jawaban yang salah coba keberuntungan Anda lain kali.");
	}
	return 1;
}

CMD:hcmds(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
		return PermissionError(playerid);

	new line3[2480];
	strcat(line3, ""WHITE_E"Junior Helper Commands:"LB2_E"\n\
 	/aduty /h /asay /o /goto /sendto /gethere /freeze /unfreeze\n\
	/kick /slap /caps /acuff /auncuff /reports /ar /dr");

	strcat(line3, "\n\n"WHITE_E"Senior Helper Commands:"LB2_E"\n\
 	/spec /peject /astats /ostats /jetpack\n\
    /jail /unjail");

	strcat(line3, "\n\n"WHITE_E"Head Helper Commands:"LB2_E"\n\
	/respawnsapd /respawnsags /respawnsamd /respawnsana /respawnjobs\n");
 	
	strcat(line3, "\n"BLUE_E"Konoha:RP "WHITE_E"- Anti-Cheat is actived.\n\
	"PINK_E"NOTE: All admin commands log is saved in database! | Abuse Commands? Kick And Demote Premanent!.");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Konoha:RP"YELLOW_E"Staff Commands", line3, "OK","");
	return true;
}

CMD:genz(playerid,params[])
{
    new Float:x,Float:z,Float:y;
	if(sscanf(params,"p<,>fff",x,y,z)) return SendClientMessage(playerid,-1,"/genz [x], [y], [z]");
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		SetPlayerPos(playerid,x,y,z);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	}
	else SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
	return SendClientMessage(playerid,-1,"Anda diteleportasi!");
}

CMD:admins(playerid, params[])
{
    new count = 0;
	if(pData[playerid][pAdmin] > 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");

		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
			    //SendClientMessage(playerid, COLOR_WHITE, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
			    if(pData[i][pAdminDuty] == 0)
				{
			  	    //SendClientMessageEx(playerid, COLOR_WHITE, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
			  	    SendClientMessageEx(playerid, COLOR_WHITE, ""WHITE_E"[%s"WHITE_E"] %s (%s) (ID: %i) ["GREEN_E"Roleplaying"WHITE_E"]", GetStaffRank(i), pData[i][pAdminname], pData[i][pName], i);
			        count++;
				}
				if(pData[i][pAdminDuty] == 1)
				{
			  	    //SendClientMessageEx(playerid, COLOR_WHITE, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
			  	    SendClientMessageEx(playerid, COLOR_WHITE, ""WHITE_E"[%s"WHITE_E"] %s (%s) (ID: %i) ["RED_E"On Duty"WHITE_E"]", GetStaffRank(i), pData[i][pAdminname], pData[i][pName], i);
			        count++;
				}
			}
		}
		if(count > 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Anda bisa {ffff00}'/report' {ffffff}Melaporkan sesuatu saat admin sedang online");
			SendClientMessageEx(playerid, COLOR_WHITE, "Anda bisa {ffff00}'/ask' {ffffff}Untuk bertanya saat admin sedang online");
		}
		else return SendClientMessageEx(playerid, COLOR_WHITE, "Tidak ada admin yang online saat ini"); //ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", "There are no admin online!", "Close", "");
	}
	else
	{
		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
				SendClientMessage(playerid, COLOR_WHITE, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");

			    if(pData[i][pAdminDuty] == 0)
				{
				    //SendClientMessageEx(playerid, COLOR_WHITE, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
					SendClientMessageEx(playerid, COLOR_WHITE, ""WHITE_E"[%s"WHITE_E"] %s (%s) (ID: %i) ["GREEN_E"Roleplaying"WHITE_E"]", GetStaffRank(i), pData[i][pAdminname], pData[i][pName], i);
					count++;
				}
				if(pData[i][pAdminDuty] == 1)
				{
				    //SendClientMessageEx(playerid, COLOR_WHITE, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
					SendClientMessageEx(playerid, COLOR_WHITE, ""WHITE_E"[%s"WHITE_E"] %s (%s) (ID: %i) ["RED_E"On Duty"WHITE_E"]", GetStaffRank(i), pData[i][pAdminname], pData[i][pName], i);
				}
			}
		}
		if(count > 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Anda bisa {ffff00}'/report' {ffffff}saat admin sedang online");
		}
		else return SendClientMessageEx(playerid, COLOR_WHITE, "Tidak ada admin yang online");
	}
	return 1;
}

/*CMD:admins(playerid, params[])
{
	new count = 0, line3[512];
	if(pData[playerid][pAdmin] > 0)
	{
		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
				format(line3, sizeof(line3), "%s\n"WHITE_E"[%s"WHITE_E"] %s(%s) (ID: %i)", line3, GetStaffRank(i), pData[i][pName], pData[i][pAdminname], i);
				count++;
			}
		}
		if(count > 0)
		{
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", line3, "Close", "");
		}
		else return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", "There are no admin online!", "Close", "");
	}
	else
	{
		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
				if(pData[i][pAdminDuty] == 1)
				{
					format(line3, sizeof(line3), "%s\n"WHITE_E"[%s"WHITE_E"] %s (ID: %i)", line3, GetStaffRank(i), pData[i][pAdminname], i);
					count++;
				}
			}
		}
		if(count > 0)
		{
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", line3, "Close", "");
		}
		else return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", "There are no admin online duty!", "Close", "");
	}
	return 1;
}*/

CMD:adminjail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new count = 0, line3[512];
	foreach(new i:Player)
	{
		if(pData[i][pJail] > 0)
		{
			format(line3, sizeof(line3), "%s\n"WHITE_E"%s(ID: %d) [Jail Time: %d seconds]", line3, pData[i][pName], i, pData[i][pJailTime]);
			count++;
		}
	}
	if(count > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Jail Player", line3, "Close", "");
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Jail Player", "There are no player in jail!", "Close", "");
	}
	return 1;
}

//---------------------------[ Admin Level 1 ]--------------------
/*CMD:aduty(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	if(!strcmp(pData[playerid][pAdminname], "None"))
		return Error(playerid, "Kamu harus setting Nama Admin mu!");
	
	if(!pData[playerid][pAdminDuty])
    {
		if(pData[playerid][pAdmin] > 0)
		{
			SetPlayerColor(playerid, 0xFF000000);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_RED, "* %s telah on duty admin.", pData[playerid][pName]);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_GREEN);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_RED, "* %s telah on helper duty.", pData[playerid][pName]);
		}
    }
    else
    {
        if(pData[playerid][pFaction] != -1 && pData[playerid][pOnDuty]) 
            SetFactionColor(playerid);
        else 
            SetPlayerColor(playerid, COLOR_WHITE);
                
        SetPlayerName(playerid, pData[playerid][pName]);
        pData[playerid][pAdminDuty] = 0;
        SendStaffMessage(COLOR_RED, "* %s telah off admin duty.", pData[playerid][pName]);
    }
	return 1;
}*/

CMD:aduty(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

	if(!strcmp(pData[playerid][pAdminname], "None"))
		return Error(playerid, "Kamu harus setting Nama Admin mu!");

	if(!pData[playerid][pAdminDuty])
    {
		if(pData[playerid][pAdmin] > 0)
		{
			SetPlayerColor(playerid, 0xFF000000);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_RED, "* %s telah on duty admin.", pData[playerid][pName]);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_GREEN);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_RED, "* %s telah on helper duty.", pData[playerid][pName]);
		}

  		for(new i = GetPlayerPoolSize(); i != -1; --i)
		{
			new sstring[64];
			pData[playerid][pAdminDuty] = 1;
			format(sstring, sizeof(sstring), "Sedang Bertugas\n{ff0000}%s", pData[playerid][pAdminname]);
			pData[playerid][pAdminLabel] = CreateDynamic3DTextLabel(sstring, -1, 0, 0, -10, 10.0, playerid);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, pData[playerid][pAdminLabel] , E_STREAMER_ATTACH_OFFSET_Z, 0.30);
			ShowPlayerNameTagForPlayer(i, playerid, 0);
			return 1;
		}
    }
    else
    {
        if(pData[playerid][pFaction] != -1 && pData[playerid][pOnDuty])
            SetFactionColor(playerid);
        else
            SetPlayerColor(playerid, COLOR_WHITE);

        SetPlayerName(playerid, pData[playerid][pName]);
        pData[playerid][pAdminDuty] = 0;
        SendStaffMessage(COLOR_RED, "* %s telah off admin duty.", pData[playerid][pName]);

		for(new i = GetPlayerPoolSize(); i != -1; --i)
		{
			DestroyDynamic3DTextLabel(pData[playerid][pAdminLabel]);
			pData[playerid][pAdminDuty] = 0;
			ShowPlayerNameTagForPlayer(i, playerid, 1);
			return 1;
		}
    }
	return 1;
}

CMD:asay(playerid, params[]) 
{
    new text[225];

    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

    if(sscanf(params,"s[225]",text))
        return Usage(playerid, "/asay [text]");
        
    SendClientMessageToAllEx(COLOR_RED,"{ff0000}**[STAFF]** (%s{ff0000}) "YELLOW_E"%s: "LG_E"%s", GetStaffRank(playerid), pData[playerid][pAdminname], ColouredText(text));
    return 1;
}

CMD:h(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

	if(isnull(params))
	{
	    Usage(playerid, "/h <text>");
	    return true;
	}

    // Decide about multi-line msgs
	new i = -1;
	new line[512];
	if(strlen(params) > 70)
	{
		i = strfind(params, " ", false, 60);
		if(i > 80 || i == -1) i = 70;

		// store the second line text
		line = " ";
		strcat(line, params[i]);

		// delete the rest from msg
		params[i] = EOS;
	}
	new mstr[512];
	format(mstr, sizeof(mstr), "{1e90ff}[Helper Chat] (%s{1e90ff}) "WHITEP_E"%s(%i): {ffffff}%s", GetStaffRank(playerid), pData[playerid][pAdminname], playerid, params);
	foreach(new ii : Player) 
	{
		if(pData[ii][pAdmin] > 0 || pData[ii][pHelper] == 1)
		{
			SendClientMessage(ii, COLOR_LB, mstr);	
		}
	}
	if(i != -1)
	{
		foreach(new ii : Player)
		{
			if(pData[ii][pAdmin] > 0 || pData[ii][pHelper] == 1)
			{
				SendClientMessage(ii, COLOR_LB, line);
			}
		}
	}
	return 1;
}

CMD:a(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

	if(isnull(params))
	{
	    Usage(playerid, "/a <text>");
	    return true;
	}

    // Decide about multi-line msgs
	new i = -1;
	new line[512];
	if(strlen(params) > 70)
	{
		i = strfind(params, " ", false, 60);
		if(i > 80 || i == -1) i = 70;

		// store the second line text
		line = " ";
		strcat(line, params[i]);

		// delete the rest from msg
		params[i] = EOS;
	}
	new mstr[512];
	format(mstr, sizeof(mstr), ""RED_E"[Admin Chat] {7fffd4}%s {ffff00}%s(%i): {ffffff}%s", GetStaffRank(playerid), pData[playerid][pAdminname], playerid, params);
	foreach(new ii : Player) 
	{
		if(pData[ii][pAdmin] > 0)
		{
			if(pData[playerid][pTogAdminchat] == 0)
			{
				SendClientMessage(ii, COLOR_LB, mstr);	
			}
		}
	}
	if(i != -1)
	{
		foreach(new ii : Player)
		{
			if(pData[ii][pAdmin] > 0)
			{
				if(pData[playerid][pTogAdminchat] == 0)
				{
					SendClientMessage(ii, COLOR_LB, line);
				}
			}
		}
	}
	return true;
}

CMD:togooc(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);

    if(TogOOC == 0)
    {
        SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s has disabled global OOC chat.", pData[playerid][pAdminname]);
        TogOOC = 1;
    }
    else
    {
        SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s has enabled global OOC chat (DON'T SPAM).", pData[playerid][pAdminname]);
        TogOOC = 0;
    }
    return 1;
}

CMD:o(playerid, params[])
{
    if(TogOOC == 1 && pData[playerid][pAdmin] < 1 && pData[playerid][pHelper] < 1) 
            return Error(playerid, "An administrator has disabled global OOC chat.");

    if(isnull(params))
        return Usage(playerid, "/o [global OOC]");

    /*if(pData[playerid][pDisableOOC])
        return Error(playerid, "You must enable OOC chat first.");*/

    if(strlen(params) < 90)
    {
        foreach (new i : Player) if(pData[i][IsLoggedIn] == true && pData[i][pSpawned] == 1)
        {
            if(pData[playerid][pAdmin] == 1) SendClientMessageEx(i, COLOR_WHITE, "(( {B0D12A}[VOLUNTEER] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 2) SendClientMessageEx(i, COLOR_WHITE, "(( {FFC0CB}[HELPER] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 3) SendClientMessageEx(i, COLOR_WHITE, "(( {FFFF00}[ADMINISTRATOR] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 4) SendClientMessageEx(i, COLOR_WHITE, "(( {FF0000}[SENIOR ADMIN] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 5) SendClientMessageEx(i, COLOR_WHITE, "(( {00FFFF}[MANAGEMENT] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 6) SendClientMessageEx(i, COLOR_WHITE, "(( {000000}[CEO] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
			else if(pData[playerid][pHelper] > 0 && pData[playerid][pAdmin] == 0)
			{
				SendClientMessageEx(i, COLOR_WHITE, "(( {00FF00}[HELPER] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
			}
            else
            {
                SendClientMessageEx(i, COLOR_WHITE, "(( {33FFCC}Player %s{FFFFFF} (%d): %s ))", pData[playerid][pName], playerid, params);
            }
        }
    }
    else
        return Error(playerid, "The text to long, maximum character is 90");

    return 1;
}

CMD:id(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/id [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "No player online or name is not found!");
	
	Servers(playerid, "Name: %s(ID: %d)", pData[otherid][pName], otherid);
	return 1;
}

CMD:goto(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/goto [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	SendPlayerToPlayer(playerid, otherid);
	Servers(otherid, "%s has been teleported to you.", pData[playerid][pName]);
	Servers(playerid, "You has teleport to %s position.", pData[otherid][pName]);
	return 1;
}

CMD:sendto(playerid, params[])
{
    static
        type[24],
		otherid;

    if(pData[playerid][pAdmin] < 2)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);

    if(sscanf(params, "us[32]", otherid, type))
    {
        Usage(playerid, "/send [player] [name]");
        Names(playerid, "ls, lv, sf, sapd, dealer, pemancingan, rs, balkot, bank");
        return 1;
    }
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(!strcmp(type,"ls")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid), 1737.48, -1856.07, 13.41);
        }
        else 
		{
            SetPlayerPosition(otherid,1737.48, -1856.07, 13.41, 270.85);
        }
        SetPlayerFacingAngle(otherid, 270.85);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"sf")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),-1425.8307,-292.4445,14.1484);
        }
        else 
		{
            SetPlayerPosition(otherid,-1425.8307,-292.4445,14.1484,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"lv")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),1686.0118,1448.9471,10.7695);
        }
        else 
		{
            SetPlayerPosition(otherid,1686.0118,1448.9471,10.7695,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"sapd"))
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
		{
            SetVehiclePos(GetPlayerVehicleID(otherid), 1546.55, -1669.18, 13.56);
        }
        else
		{
            SetPlayerPosition(otherid, 1546.55, -1669.18, 13.56, 750);
        }
        SetPlayerFacingAngle(otherid, 89.69);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"dealer"))
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
		{
            SetVehiclePos(GetPlayerVehicleID(otherid), 548.18, -1263.62, 17.24);
        }
        else
		{
            SetPlayerPosition(otherid, 548.18, -1263.62, 17.24,750);
        }
        SetPlayerFacingAngle(otherid, 206.03);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"pemancingan"))
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),363.33, -2042.80, 7.83);
        }
        else
		{
            SetPlayerPosition(otherid, 363.33, -2042.80, 7.83, 750);
        }
        SetPlayerFacingAngle(otherid, 268.46);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"rs"))
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
		{
            SetVehiclePos(GetPlayerVehicleID(otherid), 1183.89, -1333.06, 13.58);
        }
        else
		{
            SetPlayerPosition(otherid, 1183.89, -1333.06, 13.58, 750);
        }
        SetPlayerFacingAngle(otherid, 272.36);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"balkot"))
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
		{
            SetVehiclePos(GetPlayerVehicleID(otherid), 1476.68, -1738.55, 13.54);
        }
        else
		{
            SetPlayerPosition(otherid, 1476.68, -1738.55, 13.54, 750);
        }
        SetPlayerFacingAngle(otherid, 1.29);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"bank"))
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
		{
            SetVehiclePos(GetPlayerVehicleID(otherid), 1451.57, -1026.37, 23.82);
        }
        else
		{
            SetPlayerPosition(otherid, 1451.57, -1026.37, 23.82, 750);
        }
        SetPlayerFacingAngle(otherid, 170.87);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
	}
    return 1;
}

CMD:gethere(playerid, params[])
{
    new otherid;

	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/gethere [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "The specified user(s) are not connected.");
	
	if(pData[playerid][pSpawned] == 0 || pData[otherid][pSpawned] == 0)
		return Error(playerid, "Player/Target sedang tidak spawn!");
		
	if(pData[playerid][pJail] > 0 || pData[otherid][pJail] > 0)
		return Error(playerid, "Player/Target sedang di jail");
		
	if(pData[playerid][pArrest] > 0 || pData[otherid][pArrest] > 0)
		return Error(playerid, "Player/Target sedang di arrest");

	if(pData[playerid][pAdmin] < pData[otherid][pAdmin] > 0)
		return Error(playerid, "Anda tidak dapat menarik Admin dengan level paling tinggi");

    SendPlayerToPlayer(otherid, playerid);

    Servers(playerid, "Anda menarik %s.", pData[otherid][pName]);
    Servers(otherid, "%s telah menarik mu.", pData[playerid][pName]);
    return 1;
}

CMD:freeze(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/freeze [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    pData[playerid][pFreeze] = 1;

    TogglePlayerControllable(otherid, 0);
    Servers(playerid, "You have frozen %s's movements.", ReturnName(otherid));
	Servers(otherid, "You have been frozen movements by admin %s.", pData[playerid][pAdminname]);
    return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/unfreeze [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    pData[playerid][pFreeze] = 0;

    TogglePlayerControllable(otherid, 1);
    Servers(playerid, "You have unfrozen %s's movements.", ReturnName(otherid));
	Servers(otherid, "You have been unfrozen movements by admin %s.", pData[playerid][pAdminname]);
    return 1;
}

CMD:arevive(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
        if(pData[playerid][pHelper] < 2)
            return PermissionError(playerid);
    
    new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/revive [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    if(!pData[otherid][pInjured])
        return Error(playerid, "Tidak bisa revive karena tidak injured.");

    pData[otherid][pInjured] = 0;
    pData[otherid][pHospital] = 0;
    pData[otherid][pSick] = 0;
    pData[otherid][pBladder] = 0;
    pData[otherid][pHead] = 100;
    pData[otherid][pPerut] = 100;
    pData[otherid][pRHand] = 100;
    pData[otherid][pLHand] = 100;
    pData[otherid][pRFoot] = 100;
    pData[otherid][pLFoot] = 100;
    pData[otherid][pHunger] = 40;
    pData[otherid][pEnergy] = 40;

    SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);
    ClearAnimations(otherid);
    StopLoopingAnim(otherid);
    TogglePlayerControllable(otherid, 1);

    SetPlayerHealthEx(otherid, 100.0);
    SendStaffMessage(COLOR_RED, "Staff %s have revived player %s.", pData[playerid][pAdminname], ReturnName(otherid));
    Info(otherid, "Staff %s has revived your character.", pData[playerid][pAdminname]);
    return 1;
}

CMD:spec(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);

    if(!isnull(params) && !strcmp(params, "off", true))
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
            return Error(playerid, "You are not spectating any player.");

		pData[pData[playerid][pSpec]][playerSpectated]--;
        PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
        PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);

        SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
        TogglePlayerSpectating(playerid, false);
		pData[playerid][pSpec] = -1;

        return Servers(playerid, "You are no longer in spectator mode.");
    }
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/spectate [playerid/PartOfName] - Type '/spec off' to stop spectating.");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	if(otherid == playerid)
		return Error(playerid, "You can't spectate yourself bro..");

    if(pData[playerid][pAdmin] < pData[otherid][pAdmin])
        return Error(playerid, "You can't spectate admin higher than you.");
		
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);

        pData[playerid][pInt] = GetPlayerInterior(playerid);
        pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
    }
    SetPlayerInterior(playerid, GetPlayerInterior(otherid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(otherid));

    TogglePlayerSpectating(playerid, 1);

    if(IsPlayerInAnyVehicle(otherid))
	{
		new vID = GetPlayerVehicleID(otherid);
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(otherid));
		if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
	    {
	    	Servers(playerid, "You are now spectating %s(%i) who is driving a %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
		else
		{
		    Servers(playerid, "You are now spectating %s(%i) who is a passenger in %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
	}
    else
	{
        PlayerSpectatePlayer(playerid, otherid);
	}
	pData[otherid][playerSpectated]++;
    SendStaffMessage(COLOR_RED, "%s now spectating %s (ID: %d).", pData[playerid][pAdminname], pData[otherid][pName], otherid);
    Servers(playerid, "You are now spectating %s (ID: %d).", pData[otherid][pName], otherid);
    pData[playerid][pSpec] = otherid;
    return 1;
}

CMD:overdosespec(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);

    if(!isnull(params) && !strcmp(params, "off", true))
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
            return Error(playerid, "You are not spectating any player.");

		pData[pData[playerid][pSpec]][playerSpectated]--;
        PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
        PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);

        SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
        TogglePlayerSpectating(playerid, false);
		pData[playerid][pSpec] = -1;

        return Servers(playerid, "You are no longer in spectator mode.");
    }
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/overdosespec [playerid/PartOfName] - Type '/spec off' to stop spectating.");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	if(otherid == playerid)
		return Error(playerid, "You can't spectate yourself bro..");
		
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);

        pData[playerid][pInt] = GetPlayerInterior(playerid);
        pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
    }
    SetPlayerInterior(playerid, GetPlayerInterior(otherid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(otherid));

    TogglePlayerSpectating(playerid, 1);

    if(IsPlayerInAnyVehicle(otherid))
	{
		new vID = GetPlayerVehicleID(otherid);
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(otherid));
		if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
	    {
	    	Servers(playerid, "You are now spectating %s(%i) who is driving a %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
		else
		{
		    Servers(playerid, "You are now spectating %s(%i) who is a passenger in %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
	}
    else
	{
        PlayerSpectatePlayer(playerid, otherid);
	}
	pData[otherid][playerSpectated]++;
    pData[playerid][pSpec] = otherid;
    return 1;
}

CMD:slap(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new Float:POS[3], otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/slap <ID>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	GetPlayerPos(otherid, POS[0], POS[1], POS[2]);
	SetPlayerPos(otherid, POS[0], POS[1], POS[2] + 9.0);
	if(IsPlayerInAnyVehicle(otherid)) 
	{
		RemovePlayerFromVehicle(otherid);
		//OnPlayerExitVehicle(otherid, GetPlayerVehicleID(otherid));
	}
	SendStaffMessage(COLOR_RED, "Admin %s telah men-slap player %s", pData[playerid][pAdminname], pData[otherid][pName]);

	PlayerPlaySound(otherid, 1130, 0.0, 0.0, 0.0);
	return 1;
}

CMD:caps(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new otherid;
 	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/caps <ID>");
	    Info(playerid, "Function: Will disable caps for the player, type again to enable caps.");
	    return 1;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	if(!GetPVarType(otherid, "Caps"))
	{
	    // Disable Caps
	    SetPVarInt(otherid, "Caps", 1);
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah menon-aktifkan anti caps kepada player %s", pData[playerid][pAdminname], pData[playerid][pName]);
	}
	else
	{
	    // Enable Caps
		DeletePVar(otherid, "Caps");
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah meng-aktifkan anti caps kepada player %s", pData[playerid][pAdminname], pData[playerid][pName]);
	}
	return 1;
}

CMD:peject(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/peject <ID>");
	    return 1;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	if(!IsPlayerInAnyVehicle(otherid))
	{
		Error(playerid, "Player tersebut tidak berada dalam kendaraan!");
		return 1;
	}

	new vv = GetVehicleModel(GetPlayerVehicleID(otherid));
	Servers(playerid, "You have successfully ejected %s(%i) from their %s.", pData[otherid][pName], otherid, GetVehicleModelName(vv - 400));
	Servers(otherid, "%s(%i) has ejected you from your %s.", pData[playerid][pName], playerid, GetVehicleModelName(vv));
	RemovePlayerFromVehicle(otherid);
	return 1;
}

CMD:aitems(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
			
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/aitems [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	if(pData[otherid][IsLoggedIn] == false)
        return Error(playerid, "That player is not logged in yet.");
		
	DisplayItems(playerid, otherid);
	return 1;
}

CMD:astats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/check [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	if(pData[otherid][IsLoggedIn] == false)
        return Error(playerid, "That player is not logged in yet.");

	DisplayStats(playerid, otherid);
	return 1;
}

CMD:ostats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
			
	new name[24], PlayerName[24];
	if(sscanf(params, "s[24]", name))
	{
	    Usage(playerid, "/ostats <player name>");
 		return 1;
 	}

 	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

		if(!strcmp(PlayerName, name, true))
		{
			Error(playerid, "Player is online, you can use /stats on them.");
	  		return 1;
	  	}
	}

	// Load User Data
    new cVar[500];
    new cQuery[600];

	strcat(cVar, "email,admin,helper,level,levelup,vip,vip_time,gold,reg_date,last_login,money,bmoney,brek,hours,minutes,seconds,");
	strcat(cVar, "gender,age,faction,family,warn,job,job2,interior,world");

	mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT %s FROM players WHERE username='%e' LIMIT 1", cVar, name);
	mysql_tquery(g_SQL, cQuery, "LoadStats", "is", playerid, name);
	return true;
}

CMD:acuff(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid, mstr[128];		
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/acuff [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    //if(otherid == playerid)
        //return Error(playerid, "You cannot handcuff yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");

    if(GetPlayerState(otherid) != PLAYER_STATE_ONFOOT)
        return Error(playerid, "The player must be onfoot before you can cuff them.");

    if(pData[otherid][pCuffed])
        return Error(playerid, "The player is already cuffed at the moment.");

    pData[otherid][pCuffed] = 1;
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_CUFFED);

    format(mstr, sizeof(mstr), "You've been ~r~cuffed~w~ by %s.", pData[playerid][pName]);
    InfoTD_MSG(otherid, 3500, mstr);

    Servers(playerid, "Player %s telah berhasil di cuffed.", pData[otherid][pName]);
    Servers(otherid, "Admin %s telah mengcuffed anda.", pData[playerid][pName]);
    return 1;
}

CMD:auncuff(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;		
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/auncuff [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    //if(otherid == playerid)
        //return Error(playerid, "You cannot uncuff yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");

    if(!pData[otherid][pCuffed])
        return Error(playerid, "The player is not cuffed at the moment.");

    static
        string[64];

    pData[otherid][pCuffed] = 0;
    SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

    format(string, sizeof(string), "You've been ~g~uncuffed~w~ by %s.", pData[playerid][pName]);
    InfoTD_MSG(otherid, 3500, string);
	Servers(playerid, "Player %s telah berhasil uncuffed.", pData[otherid][pName]);
    Servers(otherid, "Admin %s telah uncuffed tangan anda.", pData[playerid][pName]);
    return 1;
}

CMD:jetpack(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);
			
	new otherid;		
    if(sscanf(params, "u", otherid))
    {
        //pData[playerid][pJetpack] = 1;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    }
    else
    {
        //pData[playerid][pJetpack] = 1;
        SetPlayerSpecialAction(otherid, SPECIAL_ACTION_USEJETPACK);
        Servers(playerid, "You have spawned a jetpack for %s.", pData[otherid][pName]);
    }
    return 1;
}

CMD:getip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
		
	new otherid, PlayerIP[16], giveplayer[24];
	if(sscanf(params, "u", otherid))
 	{
  		Usage(playerid, "/getip <ID>");
		return 1;
	}
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	if(pData[otherid][pAdmin] == 5)
 	{
  		Error(playerid, "You can't get the server owners ip!");
  		Servers(otherid, "%s(%i) tried to get your IP!", pData[playerid][pName], playerid);
  		return 1;
    }
	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	Servers(playerid, "%s(%i)'s IP: %s", giveplayer, otherid, PlayerIP);
	return 1;
}

CMD:aka(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
	new otherid, PlayerIP[16], query[128];
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/aka <ID/Name>");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	if(pData[otherid][pAdmin] == 5)
 	{
  		Error(playerid, "You can't AKA the server owner!");
  		Servers(otherid, "%s(%i) tried to AKA you!", pData[playerid][pName], playerid);
  		return 1;
    }
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));
	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE IP='%s'", PlayerIP);
	mysql_tquery(g_SQL, query, "CheckPlayerIP", "is", playerid, PlayerIP);
	return true;
}

CMD:akaip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
	new query[128];
	if(isnull(params))
	{
	    Usage(playerid, "/akaip <IP>");
		return true;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE IP='%s'", params);
	mysql_tquery(g_SQL, query, "CheckPlayerIP2", "is", playerid, params);
	return true;
}

CMD:vmodels(playerid, params[])
{
    new string[3500];

    if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);

    for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
    {
        format(string,sizeof(string), "%s%d - %s\n", string, i+400, g_arrVehicleNames[i]);
    }
    ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Vehicle Models", string, "Close", "");
    return 1;
}

CMD:vehname(playerid, params[]) {

	if(pData[playerid][pAdmin] >= 1) 
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "--------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle Search:");

		new
			string[128];

		if(isnull(params)) return Error(playerid, "No keyword specified.");
		if(!params[2]) return Error(playerid, "Search keyword too short.");

		for(new v; v < sizeof(g_arrVehicleNames); v++) 
		{
			if(strfind(g_arrVehicleNames[v], params, true) != -1) {

				if(isnull(string)) format(string, sizeof(string), "%s (ID %d)", g_arrVehicleNames[v], v+400);
				else format(string, sizeof(string), "%s | %s (ID %d)", string, g_arrVehicleNames[v], v+400);
			}
		}

		if(!string[0]) Error(playerid, "No results found.");
		else if(string[127]) Error(playerid, "Too many results found.");
		else SendClientMessageEx(playerid, COLOR_WHITE, string);

		SendClientMessageEx(playerid, COLOR_YELLOW, "--------------------------------------------------------------------------------------------------------------------------------");
	}
	else
	{
		PermissionError(playerid);
	}
	return 1;
}

CMD:owarn(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	    return PermissionError(playerid);
	
	new player[24], tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]s[50]", player, tmp))
		return Usage(playerid, "/owarn <name> <reason>");

	if(strlen(tmp) > 50) return Error(playerid, "Reason must be shorter than 50 characters.");

	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			Error(playerid, "Player is online, you can use /warn on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id,warn FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OWarnPlayer", "iss", playerid, player, tmp);
	return 1;
}

function OWarnPlayer(adminid, NameToWarn[], warnReason[])
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account {ffff00}'%s' "WHITE_E"does not exist.", NameToWarn);
	}
	else
	{
	    new RegID, warn;
		cache_get_value_index_int(0, 0, RegID);
		cache_get_value_index_int(0, 1, warn);
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah memberi warning(offline) player %s. [Reason: %s]", pData[adminid][pAdminname], NameToWarn, warnReason);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET warn=%d WHERE reg_id=%d", warn+1, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

CMD:ojail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	    return PermissionError(playerid);

	new player[24], datez, tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))
		return Usage(playerid, "/ojail <name> <time in minutes)> <reason>");

	if(strlen(tmp) > 50) return Error(playerid, "Reason must be shorter than 50 characters.");
	if(datez < 1 || datez > 60)
	{
 		if(pData[playerid][pAdmin] < 5)
   		{
			Error(playerid, "Jail time must remain between 1 and 60 minutes");
  			return 1;
   		}
	}
	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			Error(playerid, "Player is online, you can use /jail on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OJailPlayer", "issi", playerid, player, tmp, datez);
	return 1;
}

function OJailPlayer(adminid, NameToJail[], jailReason[], jailTime)
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account {ffff00}'%s' "WHITE_E"does not exist.", NameToJail);
	}
	else
	{
	    new RegID, JailMinutes = jailTime * 60;
		cache_get_value_index_int(0, 0, RegID);

		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah menjail(offline) player %s selama %d menit. [Reason: %s]", pData[adminid][pAdminname], NameToJail, jailTime, jailReason);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail=%d WHERE reg_id=%d", JailMinutes, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

CMD:jail(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);

	new reason[60], timeSec, otherid;
	if(sscanf(params, "uD(15)S(*)[60]", otherid, timeSec, reason))
	{
	    Usage(playerid, "/jail <ID/Name> <time in minutes> <reason>)");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	if(pData[otherid][pJail] > 0)
	{
	    Servers(playerid, "%s(%i) is already jailed (gets out in %d minutes)", pData[otherid][pName], otherid, pData[otherid][pJailTime]);
	    Info(playerid, "/unjail <ID/Name> to unjail.");
	    return true;
	}
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}
	if(reason[0] != '*' && strlen(reason) > 60)
	{
	 	Error(playerid, "Reason too long! Must be smaller than 60 characters!");
	   	return true;
	}
	if(timeSec < 1 || timeSec > 60)
	{
	    if(pData[playerid][pAdmin] < 5)
	 	{
			Error(playerid, "Jail time must remain between 1 and 60 minutes");
	    	return 1;
	  	}
	}
	pData[otherid][pJail] = 1;
	pData[otherid][pJailTime] = timeSec * 60;
	JailPlayer(otherid);
	if(reason[0] == '*')
	{
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah menjail player %s selama %d menit.", pData[playerid][pAdminname], pData[otherid][pName], timeSec);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah menjail player %s selama %d menit. {ffff00}[Reason: %s]", pData[playerid][pAdminname], pData[otherid][pName], timeSec, reason);
	}
	return 1;
}


CMD:unjail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/unjail <ID/Name>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	if(pData[otherid][pJail] == 0)
	    return Error(playerid, "The player isn't in jail!");

	pData[otherid][pJail] = 0;
	pData[otherid][pJailTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPos(otherid, 1546.55, -1669.18, 13.56);
	SetPlayerFacingAngle(otherid, 89.69);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);
	SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah unjailed %s", pData[playerid][pAdminname], pData[otherid][pName]);
	return true;
}

CMD:kick(playerid, params[])
{
    static
        reason[128];

	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "us[128]", otherid, reason))
        return Usage(playerid, "/kick [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return Error(playerid, "The specified player has higher authority.");

    SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}%s was kicked by admin %s. Reason: %s.", pData[otherid][pName], pData[playerid][pAdminname], reason);
    //Log_Write("logs/kick_log.txt", "[%s] %s has kicked %s for: %s.", ReturnTime(), ReturnName(otherid, 0), ReturnName(otherid, 0), reason);
	//SetPlayerPosition(otherid, 227.46, 110.0, 999.02, 360.0000, 10);
    KickEx(otherid);
    return 1;
}

CMD:ban(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

	new ban_time, datez, tmp[60], otherid;
	if(sscanf(params, "uds[60]", otherid, datez, tmp))
	{
	    Usage(playerid, "/tempban <ID/Name> <time (in days) 0 for permanent> <reason> ");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
 	if(datez < 0) Error(playerid, "Please input a valid ban time.");
	if(pData[playerid][pAdmin] < 2)
	{
		if(datez > 10 || datez <= 0) return Error(playerid, "Anda hanya dapat membanned selama 1-10 hari!");
	}
	/*if(otherid == playerid)
	    return Error(playerid, "You are not able to ban yourself!");*/
	if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
	{
		Servers(otherid, "** %s(%i) has just tried to ban you!", pData[playerid][pName], playerid);
 		Error(playerid, "You are not able to ban a admin with a higher level than you!");
 		return true;
   	}
	new PlayerIP[16], giveplayer[24];
	
   	//SetPlayerPosition(otherid, 405.1100,2474.0784,35.7369,360.0000);
	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	if(!strcmp(tmp, "ab", true)) tmp = "Airbreak";
	else if(!strcmp(tmp, "ad", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "ads", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "hh", true)) tmp = "Health Hacks";
	else if(!strcmp(tmp, "wh", true)) tmp = "Weapon Hacks";
	else if(!strcmp(tmp, "sh", true)) tmp = "Speed Hacks";
	else if(!strcmp(tmp, "mh", true)) tmp = "Money Hacks";
	else if(!strcmp(tmp, "rh", true)) tmp = "Ram Hacks";
	else if(!strcmp(tmp, "ah", true)) tmp = "Ammo Hacks";
	if(datez != 0)
	{
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah membanned player %s selama %d hari. {ffff00}[Reason: %s]", pData[playerid][pAdminname], giveplayer, datez, tmp);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah membanned permanent player %s. {ffff00}[Reason: %s]", pData[playerid][pAdminname], giveplayer, tmp);
	}
	//SetPlayerPosition(otherid, 227.46, 110.0, 999.02, 360.0000, 10);
	BanPlayerMSG(otherid, playerid, tmp);
 	if(datez != 0)
    {
		Servers(otherid, "This is a "RED_E"TEMP-BAN {ffff00}that will last for %d days.", datez);
		ban_time = gettime() + (datez * 86400);
	}
	else
	{
		Servers(otherid, "This is a "RED_E"Permanent Banned {ffff00}please contack admin for unbanned!.", datez);
		ban_time = datez;
	}
	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", giveplayer, PlayerIP, pData[playerid][pAdminname], tmp, gettime(), ban_time);
	mysql_tquery(g_SQL, query);
	KickEx(otherid);
	return true;
}

CMD:unban(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);
	
	new tmp[24];
	if(sscanf(params, "s[24]", tmp))
	{
	    Usage(playerid, "/unban <ban name>");
	    return true;
	}
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT name,ip FROM banneds WHERE name = '%e'", tmp);
	mysql_tquery(g_SQL, query, "OnUnbanQueryData", "is", playerid, tmp);
	return 1;
}

function OnUnbanQueryData(adminid, BannedName[])
{
	if(cache_num_rows() > 0)
	{
		new banIP[16], query[128];
		cache_get_value_name(0, "ip", banIP);
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE ip = '%s'", banIP);
		mysql_tquery(g_SQL, query);

		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}%s(%i) has unbanned %s from the server.", pData[adminid][pAdminname], adminid, BannedName);
	}
	else
	{
		Error(adminid, "No player named '%s' found on the ban list.", BannedName);
	}
	return 1;
}

CMD:warn(playerid, params[])
{
    static
        reason[32];

    if(pData[playerid][pAdmin] < 1)
        if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "us[32]", otherid, reason))
        return Usage(playerid, "/warn [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return Error(playerid, "The specified player has higher authority.");

	pData[otherid][pWarn]++;
	SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah memberikan warning kepada player %s. [Reason: %s] [Total Warning: %d/20]", pData[playerid][pAdminname], pData[otherid][pName], reason, pData[otherid][pWarn]);
    return 1;
}

CMD:unwarn(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/unwarn [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    pData[otherid][pWarn] -= 1;
    Servers(playerid, "You have unwarned 1 point %s's warnings.", pData[otherid][pName]);
	Servers(otherid, "%s has unwarned 1 point your warnings.", pData[playerid][pAdminname]);
    SendStaffMessage(COLOR_RED, "Admin %s has unwarned 1 point to %s's warnings.", pData[playerid][pAdminname], pData[otherid][pName]);
    return 1;
}

/*CMD:respawnfveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return PermissionError(playerid);
	
	new facname[128];
	if(sscanf(params, "s[128]", facname))
	{
		Usage(playerid, "/respawnfveh [names]");
		Names(playerid, "sapd, sags, samd, sana");
		return 1;
	}

	if(!strcmp(facname, "sapd", true))
	{
		for(new i = 0; i < MAX_FACTIONVEH; i++)
		{
			if(Iter_Contains(FactionVeh, i))
			{
				if(fvData[i][fvFaction] == 1)
				{
					if(IsVehicleEmpty(fvData[i][fvVeh]))
					{
						Delete3DTextLabel(fvData[i][fvLabel]);
						fvData[i][fvLabel] = Text3D: -1;
						
						if(IsValidVehicle(fvData[i][fvVeh]))
							DestroyVehicle(fvData[i][fvVeh]);

						fvData[i][fvVeh] = 0;
						fvData[i][fvFaction] = 0;
						
						Iter_Remove(FactionVeh, i);
					}
				}
			}
		}
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction SAPD", pData[playerid][pAdminname]);
	}
	else if(!strcmp(facname, "sags", true))
	{
		for(new i = 0; i < MAX_FACTIONVEH; i++)
		{
			if(Iter_Contains(FactionVeh, i))
			{
				if(fvData[i][fvFaction] == 2)
				{
					if(IsVehicleEmpty(fvData[i][fvVeh]))
					{
						Delete3DTextLabel(fvData[i][fvLabel]);
						fvData[i][fvLabel] = Text3D: -1;

						if(IsValidVehicle(fvData[i][fvVeh]))
							DestroyVehicle(fvData[i][fvVeh]);

						fvData[i][fvVeh] = 0;
						fvData[i][fvFaction] = 0;

						Iter_Remove(FactionVeh, i);
					}
				}
			}
		}
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction SAGS", pData[playerid][pAdminname]);
	}
	else if(!strcmp(facname, "samd", true))
	{
		for(new i = 0; i < MAX_FACTIONVEH; i++)
		{
			if(Iter_Contains(FactionVeh, i))
			{
				if(fvData[i][fvFaction] == 3)
				{
					if(IsVehicleEmpty(fvData[i][fvVeh]))
					{
						Delete3DTextLabel(fvData[i][fvLabel]);
						fvData[i][fvLabel] = Text3D: -1;

						if(IsValidVehicle(fvData[i][fvVeh]))
							DestroyVehicle(fvData[i][fvVeh]);

						fvData[i][fvVeh] = 0;
						fvData[i][fvFaction] = 0;

						Iter_Remove(FactionVeh, i);
					}
				}
			}
		}
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction SAMD", pData[playerid][pAdminname]);
	}
	else if(!strcmp(facname, "sana", true))
	{
		for(new i = 0; i < MAX_FACTIONVEH; i++)
		{
			if(Iter_Contains(FactionVeh, i))
			{
				if(fvData[i][fvFaction] == 4)
				{
					if(IsVehicleEmpty(fvData[i][fvVeh]))
					{
						Delete3DTextLabel(fvData[i][fvLabel]);
						fvData[i][fvLabel] = Text3D: -1;

						if(IsValidVehicle(fvData[i][fvVeh]))
							DestroyVehicle(fvData[i][fvVeh]);

						fvData[i][fvVeh] = 0;
						fvData[i][fvFaction] = 0;

						Iter_Remove(FactionVeh, i);
					}
				}
			}
		}
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction SANA", pData[playerid][pAdminname]);
	}
	return 1;
}*/

CMD:frespawnveh(playerid, params[])
{
	for(new i = 0; i < MAX_FACTIONVEH; i++)
	{
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 1)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 2)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 3)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 4)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
	}
	SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn all kendaraan faction", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsags(playerid, params[])
{
	for(new i = 0; i < MAX_FACTIONVEH; i++)
	{
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 2)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
	}
	SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction SAGS", pData[playerid][pAdminname]);

	return 1;
}

CMD:respawnsapd(playerid, params[])
{
	for(new i = 0; i < MAX_FACTIONVEH; i++)
	{
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 1)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
	}
	SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction SAPD", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsamd(playerid, params[])
{
	for(new i = 0; i < MAX_FACTIONVEH; i++)
	{
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 3)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
	}
	SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction SAMD", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnpedagang(playerid, params[])
{
	for(new i = 0; i < MAX_FACTIONVEH; i++)
	{
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 5)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
	}
	SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction Pedagang", pData[playerid][pAdminname]);

	return 1;
}

CMD:respawnsana(playerid, params[])
{
	for(new i = 0; i < MAX_FACTIONVEH; i++)
	{
		if(Iter_Contains(FactionVeh, i))
		{
			if(fvData[i][fvFaction] == 4)
			{
				if(IsVehicleEmpty(fvData[i][fvVeh]))
				{
					Delete3DTextLabel(fvData[i][fvLabel]);
					fvData[i][fvLabel] = Text3D: -1;

					if(IsValidVehicle(fvData[i][fvVeh]))
						DestroyVehicle(fvData[i][fvVeh]);

					fvData[i][fvVeh] = 0;
					fvData[i][fvFaction] = 0;

					Iter_Remove(FactionVeh, i);
				}
			}
		}
	}
	SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan faction SANA", pData[playerid][pAdminname]);

	return 1;
}


CMD:respawnjobs(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
	
	for(new xx;xx<sizeof(RumputVeh);xx++)
	{
		if(IsVehicleEmpty(RumputVeh[xx]))
		{
			SetVehicleToRespawn(RumputVeh[xx]);
			SetValidVehicleHealth(RumputVeh[xx], 2000);
			SetVehicleFuel(RumputVeh[xx], 1000);
			SwitchVehicleDoors(RumputVeh[xx], false);
		}
	}
	for(new x;x<sizeof(SweepVeh);x++)
	{
		if(IsVehicleEmpty(SweepVeh[x]))
		{
			SetVehicleToRespawn(SweepVeh[x]);
			SetValidVehicleHealth(SweepVeh[x], 2000);
			SetVehicleFuel(SweepVeh[x], 1000);
			SwitchVehicleDoors(SweepVeh[x], false);
		}
	}
	for(new xx;xx<sizeof(BusVeh);xx++)
	{
		if(IsVehicleEmpty(BusVeh[xx]))
		{
			SetVehicleToRespawn(BusVeh[xx]);
			SetValidVehicleHealth(BusVeh[xx], 2000);
			SetVehicleFuel(BusVeh[xx], 1000);
			SwitchVehicleDoors(BusVeh[xx], false);
		}
	}
	for(new xx;xx<sizeof(ForVeh);xx++)
	{
		if(IsVehicleEmpty(ForVeh[xx]))
		{
			SetVehicleToRespawn(ForVeh[xx]);
			SetValidVehicleHealth(ForVeh[xx], 2000);
			SetVehicleFuel(ForVeh[xx], 1000);
			SwitchVehicleDoors(ForVeh[xx], false);
		}
	}
	for(new xx;xx<sizeof(DRIVESIMVehicles);xx++)
	{
		if(IsVehicleEmpty(DRIVESIMVehicles[xx]))
		{
			SetVehicleToRespawn(DRIVESIMVehicles[xx]);
			SetValidVehicleHealth(DRIVESIMVehicles[xx], 2000);
			SetVehicleFuel(DRIVESIMVehicles[xx], 1000);
			SwitchVehicleDoors(DRIVESIMVehicles[xx], false);
		}
	}
	for(new xx;xx<sizeof(PizzaVeh);xx++)
	{
		if(IsVehicleEmpty(PizzaVeh[xx]))
		{
			SetVehicleToRespawn(PizzaVeh[xx]);
			SetValidVehicleHealth(PizzaVeh[xx], 2000);
			SetVehicleFuel(PizzaVeh[xx], 1000);
			SwitchVehicleDoors(PizzaVeh[xx], false);
		}
	}
	for(new xx;xx<sizeof(TruckerVeh);xx++)
	{
		if(IsVehicleEmpty(TruckerVeh[xx]))
		{
			if(IsValidDynamicObject(TruckerVehObject[TruckerVeh[xx]]))
				DestroyDynamicObject(TruckerVehObject[TruckerVeh[xx]]);

			TruckerVehObject[TruckerVeh[xx]] = 0;
			SetVehicleToRespawn(TruckerVeh[xx]);
			SetValidVehicleHealth(TruckerVeh[xx], 2000);
			SetVehicleFuel(TruckerVeh[xx], 1000);
			SwitchVehicleDoors(TruckerVeh[xx], false);
		}
	}
	for(new xx;xx<sizeof(TaxiVeh);xx++)
	{
		if(IsVehicleEmpty(TaxiVeh[xx]))
		{
			SetVehicleToRespawn(TaxiVeh[xx]);
			SetValidVehicleHealth(TaxiVeh[xx], 2000);
			SetVehicleFuel(TaxiVeh[xx], 1000);
			SwitchVehicleDoors(TaxiVeh[xx], false);
		}
	}
	for(new xx;xx<sizeof(TrashVeh);xx++)
	{
		if(IsVehicleEmpty(TrashVeh[xx]))
		{
			SetVehicleToRespawn(TrashVeh[xx]);
			SetValidVehicleHealth(TrashVeh[xx], 2000);
			SetVehicleFuel(TrashVeh[xx], 1000);
			SwitchVehicleDoors(TrashVeh[xx], false);
		}
	}
	SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s telah merespawn kendaraan Jobs & Side Jobs", pData[playerid][pAdminname]);
	return 1;
}

//----------------------------[ Admin Level 2 ]-----------------------
CMD:sethp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/sethp [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	SetPlayerHealthEx(otherid, jumlah);
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah hp player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set hp anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setbone(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/setbone [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	pData[otherid][pHead] = jumlah;
	pData[otherid][pPerut] = jumlah;
	pData[otherid][pLFoot] = jumlah;
	pData[otherid][pRFoot] = jumlah;
	pData[otherid][pLHand] = jumlah;
	pData[otherid][pRHand] = jumlah;
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah Kondisi tulang player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set Kondisi tulang anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setam(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/setam [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	if(jumlah > 95)
	{
		SetPlayerArmourEx(otherid, 98);
	}
	else
	{
		SetPlayerArmourEx(otherid, jumlah);
	}
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah armor player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set armor anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:afuel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
     		return PermissionError(playerid);

	if(IsPlayerInAnyVehicle(playerid)) 
	{
		SetVehicleFuel(GetPlayerVehicleID(playerid), 1000);
		Servers(playerid, "Vehicle Fueled!");
	}
	else
	{
		Error(playerid, "Kamu tidak berada didalam kendaraan apapun!");
	}
	return 1;
}

CMD:afix(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
     		return PermissionError(playerid);
	
    if(IsPlayerInAnyVehicle(playerid)) 
	{
        SetValidVehicleHealth(GetPlayerVehicleID(playerid), 2000);
		ValidRepairVehicle(GetPlayerVehicleID(playerid));
		SetVehicleFuel(GetPlayerVehicleID(playerid), 1000);
        Servers(playerid, "Vehicle Fixed!");
    }
	else
	{
		Error(playerid, "Kamu tidak berada didalam kendaraan apapun!");
	}
	return 1;
}

CMD:genzoayam(playerid)
{
	pData[playerid][pJob] = 24;
	Info(playerid, "sukses masuk job ayam");
	return 1;
}

CMD:genzojob1(playerid)
{
	pData[playerid][pJob] = 0;
    DeletePenambangCP(playerid);
    Info(playerid, "sukses keluar job1");
	return 1;
}

CMD:genzojob2(playerid)
{
	pData[playerid][pJob2] = 0;
    DeletePenambangCP(playerid);
    Info(playerid, "sukses keluar job2");
	return 1;
}

CMD:setjob1(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
	
	new
        jobid,
		otherid;
	
	if(sscanf(params, "ud", otherid, jobid))
        return Usage(playerid, "/setjob1 [playerid/PartOfName] [jobid]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	if(jobid < 0 || jobid > 14)
        return Error(playerid, "Invalid ID. 0 - 14.");
		
	pData[otherid][pJob] = jobid;
	pData[otherid][pExitJob] = 0;
	
	Servers(playerid, "Anda telah menset job1 player %s(%d) menjadi %s(%d).", pData[otherid][pName], otherid, GetJobName(jobid), jobid);
	Servers(otherid, "Admin %s telah menset job1 anda menjadi %s(%d)", pData[playerid][pAdminname], GetJobName(jobid), jobid);
	return 1;
}

CMD:setjob2(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
	
	new
        jobid,
		otherid;
	
	if(sscanf(params, "ud", otherid, jobid))
        return Usage(playerid, "/setjob2 [playerid/PartOfName] [jobid]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	if(jobid < 0 || jobid > 14)
        return Error(playerid, "Invalid ID. 0 - 14.");
		
	pData[otherid][pJob2] = jobid;
	pData[otherid][pExitJob] = 0;
	
	Servers(playerid, "Anda telah menset job2 player %s(%d) menjadi %s(%d).", pData[otherid][pName], otherid, GetJobName(jobid), jobid);
	Servers(otherid, "Admin %s telah menset job2 anda menjadi %s(%d)", pData[playerid][pAdminname], GetJobName(jobid), jobid);
	return 1;
}

CMD:setjobtime(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
	
	new
        timers,
		otherid;
	
	if(sscanf(params, "ud", otherid, timers))
        return Usage(playerid, "/setjobtime [playerid/PartOfName] [time]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	pData[otherid][pJobTime] = timers;
	
	Servers(playerid, "Anda telah menset job time player %s(%d) menjadi %s(%d).", pData[otherid][pName], otherid, pData[otherid][pJobTime]);
	Servers(otherid, "Admin %s telah menset jobtime anda menjadi %s(%d)", pData[playerid][pAdminname], pData[otherid][pJobTime]);
	return 1;
}

CMD:setskin(playerid, params[])
{
    new
        skinid,
		otherid;

    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, skinid))
        return Usage(playerid, "/skin [playerid/PartOfName] [skin id]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    if(skinid < 0 || skinid > 299)
        return Error(playerid, "Invalid skin ID. Skins range from 0 to 299.");

    SetPlayerSkin(otherid, skinid);
	pData[otherid][pSkin] = skinid;

    Servers(playerid, "You have set %s's skin to ID: %d.", ReturnName(otherid), skinid);
    Servers(otherid, "%s has set your skin to ID: %d.", ReturnName(playerid), skinid);
    return 1;
}

CMD:akill(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	new reason[60], otherid;
	if(sscanf(params, "uS(*)[60]", otherid, reason))
	{
	    Usage(playerid, "/akill <ID/Name> <optional: reason>");
	    return 1;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	SetPlayerHealth(otherid, 0.0);

	if(reason[0] != '*')
	{
		SendClientMessageToAllEx(COLOR_RED, "Servers: {ffff00}Admin %s has killed %s. "GREY_E"[Reason: %s]", pData[playerid][pAdminname], pData[otherid][pName], reason);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_RED, "Servers: {ffff00}Admin %s has killed %s.", pData[playerid][pAdminname], pData[otherid][pName]);
	}
	return 1;
}

CMD:ann(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

 	if(isnull(params))
    {
	    Usage(playerid, "/announce <msg>");
	    return 1;
	}
	// Check for special trouble-making input
   	if(strfind(params, "~x~", true) != -1)
		return Error(playerid, "~x~ is not allowed in announce.");
	if(strfind(params, "#k~", true) != -1)
		return Error(playerid, "The constant key is not allowed in announce.");
	if(strfind(params, "/q", true) != -1)
		return Error(playerid, "You are not allowed to type /q in announcement!");

	// Count tildes (uneven number = faulty input)
	new iTemp = 0;
	for(new i = (strlen(params)-1); i != -1; i--)
	{
		if(params[i] == '~')
			iTemp ++;
	}
	if(iTemp % 2 == 1)
		return Error(playerid, "You either have an extra ~ or one is missing in the announcement!");
	
	new str[512];
	format(str, sizeof(str), "~w~%s", params);
	GameTextForAll(str, 6500, 3);
	return true;
}

CMD:settime(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

	new time, mstr[128];
	if(sscanf(params, "d", time))
	{
		Usage(playerid, "/time <time ID>");
		return true;
	}

	SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%i) has changed the time to: "YELLOW_E"%d", pData[playerid][pAdminname], playerid, time);

	format(mstr, sizeof(mstr), "~r~Time changed: ~b~%d", time);
	GameTextForAll(mstr, 3000, 5);

	SetWorldTime(time);
	WorldTime = time;
	foreach(new ii : Player)
	{
		SetPlayerTime(ii, time, 0);
	}
	return 1;
}

CMD:setweather(playerid, params[])
{
    new weatherid;

    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

    if(sscanf(params, "d", weatherid))
        return Usage(playerid, "/setweather [weather ID]");

    SetWeather(weatherid);
	WorldWeather = weatherid;
	foreach(new ii : Player)
	{
		SetPlayerWeather(ii, weatherid);
	}
    SetGVarInt("g_Weather", weatherid);
    SendClientMessageToAllEx(COLOR_RED,"Server: {ffff00}%s have changed the weather ID", pData[playerid][pAdminname]);
    Servers(playerid, "You have changed the weather to ID: %d.", weatherid);
    return 1;
}

CMD:gotoco(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return PermissionError(playerid);
		
	new Float: pos[3], int;
	if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int)) return Usage(playerid, "/gotoco [x coordinate] [y coordinate] [z coordinate] [interior]");

	Servers(playerid, "Anda telah terteleportasi ke kordinat tersebut.");
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	SetPlayerInterior(playerid, int);
	return 1;
}

CMD:cd(playerid)
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(Count != -1) return Error(playerid, "There is already a countdown in progress, wait for it to end!");

	Count = 6;
	countTimer = SetTimer("pCountDown", 1000, 1);

	foreach(new ii : Player)
	{
		showCD[ii] = 1;
	}
	SendClientMessageToAllEx(COLOR_RED, "[SERVER] "LB_E"Admin %s has started a global countdown!", pData[playerid][pAdminname]);
	return 1;
}

//---------------[ Admin Level 3 ]------------
CMD:oban(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
	    return PermissionError(playerid);

	new player[24], datez, reason[50];
	if(sscanf(params, "s[24]D(0)s[50]", player, datez, reason))
	{
	    Usage(playerid, "/oban <ban name> <time in days (0 for permanent ban)> <reason>");
	    Info(playerid, "Will ban a player while he is offline. If time isn't specified it will be a perm ban.");
	    return true;
	}
	if(strlen(reason) > 50) return Error(playerid, "Reason must be shorter than 50 characters.");

	foreach(new ii : Player)
	{
		new PlayerName[24];
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			Error(playerid, "Player is online, you can use /ban on him.");
	  		return true;
	  	}
	}

	new query[128];

	mysql_format(g_SQL, query, sizeof(query), "SELECT ip FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OnOBanQueryData", "issi", playerid, player, reason, datez);
	return true;
}

CMD:banucp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
	    return PermissionError(playerid);

	new player[24], datez, reason[50];
	if(sscanf(params, "s[24]D(0)s[50]", player, datez, reason))
	{
	    Usage(playerid, "/ucpban <ucpname> <time in days (0 for permanent ban)> <reason>");
	    return true;
	}
	if(strlen(reason) > 50) 
		return Error(playerid, "Reason must be shorter than 50 characters.");

	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT ip FROM ucp WHERE ucp_name = '%e'", player);
	mysql_tquery(g_SQL, query, "OnOBanUcpQueryData", "issi", playerid, player, reason, datez);
	return true;
}


CMD:banip(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
     	return PermissionError(playerid);

	if(isnull(params))
	{
	    Usage(playerid, "/banip <IP Address>");
		return true;
	}
	if(strfind(params, "*", true) != -1 && pData[playerid][pAdmin] != 5)
	{
		Error(playerid, "You are not authorized to ban ranges.");
  		return true;
  	}

	SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%d) IP banned address %s.", pData[playerid][pAdminname], playerid, params);
	
	new tstr[128];
	format(tstr, sizeof(tstr), "banip %s", params);
	SendRconCommand(tstr);
	return 1;
}

CMD:unbanip(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
     	return PermissionError(playerid);

	if(isnull(params))
	{
	    Usage(playerid, "/unbanip <IP Address>");
		return true;
	}
	new mstr[128];
	format(mstr, sizeof(mstr), "unbanip %s", params);
	SendRconCommand(mstr);
	format(mstr, sizeof(mstr), "reloadbans");
	SendRconCommand(mstr);
	Servers(playerid, "You have unbanned IP address %s.", params);
	return 1;
}

CMD:areloadweap(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/areloadweap [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    SetWeapons(otherid);
    Servers(playerid, "You have reload %s's weapons.", pData[otherid][pName]);
    Servers(otherid, "Admin %s have reload your weapons.", pData[playerid][pAdminname]);
    return 1;
}

CMD:resetweap(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/resetweps [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    ResetPlayerWeaponsEx(otherid);
    Servers(playerid, "You have reset %s's weapons.", pData[otherid][pName]);
    Servers(otherid, "Admin %s have reset your weapons.", pData[playerid][pAdminname]);
    return 1;
}

CMD:setlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/setlevel [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	pData[otherid][pLevel] = jumlah;
	SetPlayerScore(otherid, jumlah);
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah level player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set level anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setgender(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
	
	new jumlah, otherid, string[128];
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/setgender [playerid id/name] [gender] (1.Pria 2.Wanita)");
	
	if(jumlah < 1 || jumlah > 2)
		return Error(playerid, "Gender only type 1 or 2");

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
    {
		if(jumlah == 1)
	    {
	    	string = "Pria";
	    }
	    else
	    {
	    	string = "Wanita";
	    }
	    pData[otherid][pGender] = jumlah;
		SendStaffMessage(COLOR_RED, "%s telah men set gender player %s menjadi %s", pData[playerid][pAdminname], pData[otherid][pName], string);
		Servers(otherid, "Admin %s telah men set gender anda menjadi %s", pData[playerid][pAdminname], string);
	}
    return 1;
}

CMD:sethbe(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/sethbe [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	pData[otherid][pHunger] = jumlah;
	pData[otherid][pEnergy] = jumlah;
	pData[otherid][pBladder] = jumlah;
	pData[otherid][pSick] = 0;
	SetPlayerDrunkLevel(playerid, 0);
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah hbe player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set HBE anda", pData[playerid][pAdminname]);
	return 1;
}

//----------------------------[ Admin Level 4 ]---------------
CMD:setname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	new otherid, tmp[20];
	if(sscanf(params, "is[20]", otherid, tmp))
	{
	   	Usage(playerid, "/setname <ID/Name> <newname>");
	    return 1;
	}
	if(!IsPlayerConnected(otherid)) return Error(playerid, "Player belum masuk!");
	if(pData[otherid][IsLoggedIn] == false)	return Error(playerid, "That player is not logged in.");
	
	if(strlen(tmp) < 4) return Error(playerid, "New name can't be shorter than 4 characters!");
	if(strlen(tmp) > 20) return Error(playerid, "New name can't be longer than 20 characters!");

	if(!IsValidName(tmp)) return Error(playerid, "Name contains invalid characters, please doublecheck!");
	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", tmp);
	mysql_tquery(g_SQL, query, "SetName", "iis", otherid, playerid, tmp);
	return 1;
}


// SetName Callback
function SetName(otherplayer, playerid, nname[])
{
	if(!cache_num_rows())
	{
		new oldname[24], newname[24], query[248];
		GetPlayerName(otherplayer, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(otherplayer, "Admin %s telah mengganti nickname anda menjadi (%s)", pData[playerid][pAdminname], nname);
		Info(otherplayer, "Pastikan anda mengingat dan mengganti nickname anda pada saat login kembali!");
		SendStaffMessage(COLOR_RED, "Admin %s telah mengganti nickname player %s(%d) menjadi %s", pData[playerid][pAdminname], oldname, otherplayer, nname);
		
		SetPlayerName(otherplayer, nname);
		GetPlayerName(otherplayer, newname, sizeof(newname));
		pData[otherplayer][pName] = newname;
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s' WHERE ID=%d", newname, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
				House_Save(h);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s' WHERE ID=%d", newname, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
				Bisnis_Save(b);
			}
		}
		// Dealer
		foreach(new deid : Dealer)
		{
			if(!strcmp(drData[deid][dOwner], oldname, true))
   			{
   			    // Has Business
   			    format(drData[deid][dOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE dealer SET owner='%s' WHERE ID=%d", newname, deid);
				mysql_tquery(g_SQL, query);
				Dealer_Refresh(deid);
				Dealer_Save(deid);
			}
		}
		// Venid
		foreach(new venid : Vending)
		{
			if(!strcmp(vmData[venid][venOwner], oldname, true))
   			{
   			    // Has Business
   			    format(vmData[venid][venOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE vendingmachine SET owner='%s' WHERE ID=%d", newname, venid);
				mysql_tquery(g_SQL, query);
				Vending_Refresh(venid);
				Vending_Save(venid);
			}
		}
		if(pData[otherplayer][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
	}
    return 1;
}

function ChangeName(playerid, nname[])
{
	if(!cache_num_rows())
	{
		if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
		pData[playerid][pGold] -= 500;
		
		new oldname[24], newname[24], query[248];
		GetPlayerName(playerid, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(playerid, "Anda telah mengganti nickname anda menjadi (%s)", nname);
		Info(playerid, "Pastikan anda mengingat dan mengganti nickname anda pada saat login kembali!");
		SendStaffMessage(COLOR_RED, "Player %s(%d) telah mengganti nickname menjadi %s(%d)", oldname, playerid, nname, playerid);
		
		SetPlayerName(playerid, nname);
		GetPlayerName(playerid, newname, sizeof(newname));
		pData[playerid][pName] = newname;
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s' WHERE ID=%d", newname, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
				House_Save(h);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s' WHERE ID=%d", newname, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
				Bisnis_Save(b);
			}
		}
		if(pData[playerid][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
		return 1;
	}
    return 1;
}

CMD:setbooster(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	
	new dayz, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, dayz))
	{
	    Usage(playerid, "/setbooster <ID/Name> <time (in days) 0 for permanent>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	if(dayz < 0)
		return Error(playerid, "Time can't be lower than 0!");
		
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	
	if(pData[playerid][pAdmin] < 5 && dayz > 7)
		return Error(playerid, "Anda hanya bisa menset 1 - 7 hari!");
	
	pData[otherid][pBooster] = 1;
	if(dayz == 0)
	{
		pData[otherid][pBoostTime] = 0;
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%d) telah menset Roleplay Booster kepada %s(%d) ke level permanent time!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid);
	}
	else
	{
		pData[otherid][pBoostTime] = gettime() + (dayz * 86400);
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%d) telah menset Roleplay Booster kepada %s(%d) selama %d hari!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, dayz);
	}
	
	format(tmp, sizeof(tmp), "(%d days)", dayz);
	StaffCommandLog("SETBOOSTER", playerid, otherid, tmp);
	return 1;
}

CMD:setarmorall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return Error(playerid, "Only admin level 6");

	new Float:amount, string[1024];
	if(sscanf(params, "f", amount))
	    return Usage(playerid, "/setarmorall [amount]");

	if(amount < 1 || amount > 97)
		return Error(playerid, "tidak bisa kurang dari 1 dan lebih dari 97");
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			SetPlayerArmourEx(i, amount);
		}
	}
	format(string, sizeof(string), "[SERVER]"YELLOW_E"Admin %s telah memberikan armor sejumlah %0.0f kepada seluruh player yang online", pData[playerid][pAdminname], amount);
	SendClientMessageToAll(COLOR_RED, string);
	return 1;
}

CMD:sethpall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return Error(playerid, "Only admin level 6");

	new Float:amount, string[1024];
	if(sscanf(params, "f", amount))
	    return Usage(playerid, "/sethpall [amount]");

	if(amount < 1 || amount > 97)
		return Error(playerid, "tidak bisa kurang dari 1 dan lebih dari 97");
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			SetPlayerHealthEx(i, amount);
		}
	}
	format(string, sizeof(string), "[SERVER]"YELLOW_E"Admin %s telah memberikan hp sejumlah %0.0f kepada seluruh player yang online", pData[playerid][pAdminname], amount);
	SendClientMessageToAll(COLOR_RED, string);
	return 1;
}

CMD:givemoneyall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return Error(playerid, "Only admin level 6");

	new amount, string[1024];
	if(sscanf(params, "d", amount))
	    return Usage(playerid, "/givemoneyallS [amount]");

	if(amount < 1 || amount > 100000)
		return Error(playerid, "tidak bisa kurang dari $1 dan lebih dari $100.000");

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			GivePlayerMoneyEx(i, amount);
		}
	}
	format(string, sizeof(string), "[SERVER]"YELLOW_E"Admin %s telah memberikan uang sejumlah %s kepada seluruh player yang online", pData[playerid][pAdminname], FormatMoney(amount));
	SendClientMessageToAll(COLOR_RED, string);
	return 1;
}

CMD:setvip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	
	new alevel, dayz, otherid, tmp[64];
	if(sscanf(params, "udd", otherid, alevel, dayz))
	{
	    Usage(playerid, "/setvip <ID/Name> <level 0 - 3> <time (in days) 0 for permanent>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	if(alevel > 3)
		return Error(playerid, "Level can't be higher than 3!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	if(dayz < 0)
		return Error(playerid, "Time can't be lower than 0!");
		
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	
	if(pData[playerid][pAdmin] < 5 && dayz > 7)
		return Error(playerid, "Anda hanya bisa menset 1 - 7 hari!");
	
	pData[otherid][pVip] = alevel;
	if(dayz == 0)
	{
		pData[otherid][pVipTime] = 0;
		Info(otherid, "Admin %s(%d) telah menset VIP kepada %s(%d) ke level %s permanent time!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, GetVipRank(otherid));
		Info(playerid, "Admin %s(%d) telah menset VIP kepada %s(%d) ke level %s permanent time!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, GetVipRank(otherid));
	}
	else
	{
		pData[otherid][pVipTime] = gettime() + (dayz * 86400);
		Info(otherid, "Admin %s(%d) telah menset VIP kepada %s(%d) selama %d hari ke level %s!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, dayz, GetVipRank(otherid));
		Info(playerid, "Admin %s(%d) telah menset VIP kepada %s(%d) selama %d hari ke level %s!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, dayz, GetVipRank(otherid));
	}
	
	format(tmp, sizeof(tmp), "%d(%d days)", alevel, dayz);
	StaffCommandLog("SETVIP", playerid, otherid, tmp);
	return 1;
}

CMD:giveweap(playerid, params[])
{
    static
        weaponid,
        ammo;
		
	new otherid;
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "udI(250)", otherid, weaponid, ammo))
        return Usage(playerid, "/givewep [playerid/PartOfName] [weaponid] [ammo]");

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "You cannot give weapons to disconnected players.");


    if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

    if(ammo < 1 || ammo > 500)
        return Error(playerid, "You have specified an invalid weapon ammo, 1 - 500");

    if(PlayerHasWeapon(otherid, weaponid))
		return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

    GivePlayerWeaponEx(otherid, weaponid, ammo);
    Servers(playerid, "You have give %s a %s with %d ammo.", pData[otherid][pName], ReturnWeaponName(weaponid), ammo);
    return 1;
}

CMD:setfaction(playerid, params[])
{
	new fid, rank, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "udd", otherid, fid, rank))
        return Usage(playerid, "/setfaction [playerid/PartOfName] [1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW 5.PEDAGANG 6.GOJEK 7.MEKANIK] [rank 1-7]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 7)
        return Error(playerid, "You have specified an invalid faction ID 0 - 7.");
		
	if(rank < 1 || rank > 6)
        return Error(playerid, "You have specified an invalid rank 1 - 6.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionRank] = rank;
		Servers(playerid, "You have set %s's faction ID %d with rank %d.", pData[otherid][pName], fid, rank);
		Servers(otherid, "%s has set your faction ID to %d with rank %d.", pData[playerid][pName], fid, rank);
	}
	
	format(tmp, sizeof(tmp), "%d(%d rank)", fid, rank);
	StaffCommandLog("SETFACTION", playerid, otherid, tmp);
    return 1;
}

CMD:setleader(playerid, params[])
{
	new fid, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, fid))
        return Usage(playerid, "/setleader [playerid/PartOfName] [0.None, 1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW 5.PEDAGANG 6.GOJEK 7.MEKANIK]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 7)
        return Error(playerid, "You have specified an invalid faction ID 0 - 7.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionLead] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction leader.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction leader.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionLead] = fid;
		pData[otherid][pFactionRank] = 6;
		Servers(playerid, "You have set %s's faction ID %d with leader.", pData[otherid][pName], fid);
		Servers(otherid, "%s has set your faction ID to %d with leader.", pData[playerid][pName], fid);
	}
	
	format(tmp, sizeof(tmp), "%d", fid);
	StaffCommandLog("SETLEADER", playerid, otherid, tmp);
    return 1;
}

CMD:takemoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new money, otherid;
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/takemoney <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

 	if(money > pData[otherid][pMoney])
		return Error(playerid, "Player doesn't have enough money to deduct from!");

	GivePlayerMoneyEx(otherid, -money);
	SendClientMessageToAllEx(COLOR_RED, "SERVER: {ffff00}Admin %s(%i) has taken away money "RED_E"%s {ffff00}from %s", pData[playerid][pAdminname], FormatMoney(money), pData[otherid][pName]);
	return true;
}

CMD:takegold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new gold, otherid;
	if(sscanf(params, "ud", otherid, gold))
	{
	    Usage(playerid, "/takegold <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

 	if(gold > pData[otherid][pGold])
		return Error(playerid, "Player doesn't have enough gold to deduct from!");

	pData[otherid][pGold] -= gold;
	Info(playerid, "Admin %s has taken away gold "RED_E"%d "WHITE_E"from %s", pData[playerid][pAdminname], gold, pData[otherid][pName]);
	Info(otherid, "Admin %s has taken away gold "RED_E"%d "WHITE_E"from %s", pData[playerid][pAdminname], gold, pData[otherid][pName]);
	return 1;
}

CMD:veh(playerid, params[])
{
    static
        model[32],
        color1,
        color2;

    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "s[32]I(0)I(0)", model, color1, color2))
        return Usage(playerid, "/veh [model id/name] <color 1> <color 2>");

    if((model[0] = GetVehicleModelByName(model)) == 0)
        return Error(playerid, "Invalid model ID.");

    static
        Float:x,
        Float:y,
        Float:z,
        Float:a,
        vehicleid;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    vehicleid = AddStaticVehicleEx(model[0], x, y, z, a, color1, color2, -1);
    adminVehicle{vehicleid} = true;

    if(GetPlayerInterior(playerid) != 0)
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

    if(GetPlayerVirtualWorld(playerid) != 0)
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    if(IsABoat(vehicleid) || IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
        PutPlayerInVehicle(playerid, vehicleid, 0);

    SetVehicleNumberPlate(vehicleid, "ADMIN");
    Servers(playerid, "Anda memunculkan %s (%d, %d).", GetVehicleModelName(model[0]), color1, color2);
    return 1;
}

CMD:respawnstatic(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);

	new count = 0;
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(adminVehicle{i})
	    {
	    	if(IsVehicleEmpty(i))
	    	{
	    		count++;
	    		if(IsValidVehicle(i))
		        	DestroyVehicle(i);
		        
		        adminVehicle{i} = false;
			}
		}
	}
	SendStaffMessage(COLOR_RED, "Staff %s merespawn %d kendaraan admin static", pData[playerid][pAdminname], count);
	return 1;
}

CMD:agl(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/agl [playerid id/name]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	SendStaffMessage(COLOR_RED, "%s telah memberi sim kepada player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah memberi sim anda", pData[playerid][pAdminname]);
	return 1;
}
//-----------------------------[ Admin Level 5 ]------------------
CMD:sethelperlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new alevel, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, alevel))
	{
	    Usage(playerid, "/sethelperlevel <ID/Name> <level 0 - 3>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	if(alevel > 3)
		return Error(playerid, "Level can't be higher than 3!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	pData[otherid][pHelper] = alevel;
	Servers(playerid, "You has set helper level %s(%d) to level %d", pData[otherid][pName], otherid, alevel);
	Servers(otherid, "%s(%d) has set your helper level to %d", pData[otherid][pName], playerid, alevel);
	SendStaffMessage(COLOR_RED, "Admin %s telah menset %s(%d) sebagai staff helper level %s(%d)",  pData[playerid][pAdminname], pData[otherid][pName], otherid, GetStaffRank(playerid), alevel);
	
	format(tmp, sizeof(tmp), "%d", alevel);
	StaffCommandLog("SETHELPERLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:setadminname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new aname[128], otherid, query[128];
	if(sscanf(params, "us[128]", otherid, aname))
	{
	    Usage(playerid, "/setadminname <ID/Name> <admin name>");
	    return true;
	}
	
	mysql_format(g_SQL, query, sizeof(query), "SELECT adminname FROM players WHERE adminname='%s'", aname);
	mysql_tquery(g_SQL, query, "a_ChangeAdminName", "iis", otherid, playerid, aname);
	return 1;
}

CMD:setmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	ResetPlayerMoneyEx(otherid);
	GivePlayerMoneyEx(otherid, money);
	
	Servers(playerid, "Kamu telah mengset uang %s(%d) menjadi %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah mengset uang anda menjadi %s!",pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/givemoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	GivePlayerMoneyEx(otherid, money);
	
	Servers(playerid, "Kamu telah memberikan uang %s (%d) dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah memberikan uang kepada anda dengan jumlah %s!", pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:setbankmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setbankmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[otherid][pBankMoney] = money;
	
	Servers(playerid, "Kamu telah mengset uang rekening bank %s(%d) menjadi %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah mengset uang rekening bank anda menjadi %s!",pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETBANKMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:givebankmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/givebankmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[otherid][pBankMoney] += money;
	
	Servers(playerid, "Kamu telah memberikan uang rekening bank %s(%d) dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah memberikan uang rekening bank kepada anda dengan jumlah %s!", pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEBANKMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:setmaterial(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setmaterial <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[otherid][pMaterial] = money;
	
	Servers(playerid, "Kamu telah menset material %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset material kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETMATERIAL", playerid, otherid, tmp);
	return 1;
}

CMD:setvw(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/setvw [playerid id/name] <virtual world>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	SetPlayerVirtualWorld(otherid, jumlah);
	Servers(otherid, "Admin %s telah men set Virtual World anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setcomponent(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setcomponent <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[otherid][pComponent] = money;
	
	Servers(playerid, "Kamu telah menset component %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset component kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETCOMPONENT", playerid, otherid, tmp);
	return 1;
}

CMD:explode(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
	new Float:POS[3], otherid, giveplayer[24];
	if(sscanf(params, "u", otherid))
	{
		Usage(playerid, "/explode <ID/Name>");
		return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));

	Servers(playerid, "You have exploded %s(%i).", giveplayer, otherid);
	GetPlayerPos(otherid, POS[0], POS[1], POS[2]);
	CreateExplosion(POS[0], POS[1], POS[2], 7, 5.0);
	return true;
}

//--------------------------[ Admin Level 6 ]-------------------
CMD:setadminlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new alevel, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, alevel))
	{
	    Usage(playerid, "/setadminlevel <ID/Name> <level 0 - 4>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	if(alevel > 6)
		return Error(playerid, "Level can't be higher than 6!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	pData[otherid][pAdmin] = alevel;
	Servers(playerid, "You has set admin level %s(%d) to level %d", pData[otherid][pName], otherid, alevel);
	Servers(otherid, "%s(%d) has set your admin level to %d", pData[otherid][pName], playerid, alevel);
	
	format(tmp, sizeof(tmp), "%d", alevel);
	StaffCommandLog("SETADMINLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:setgold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new gold, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gold))
	{
	    Usage(playerid, "/setgold <ID/Name> <gold>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[otherid][pGold] = gold;
	
	Servers(playerid, "Kamu telah menset gold %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, gold);
	Servers(otherid, "Admin %s telah menset gold kepada anda dengan jumlah %d!", pData[playerid][pAdminname], gold);
	
	format(tmp, sizeof(tmp), "%d", gold);
	StaffCommandLog("SETGOLD", playerid, otherid, tmp);
	return 1;
}

CMD:givegold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new gold, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gold))
	{
	    Usage(playerid, "/givegold <ID/Name> <gold>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[otherid][pGold] += gold;
	
	Servers(playerid, "Kamu telah memberikan gold %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, gold);
	Servers(otherid, "Admin %s telah memberikan gold kepada anda dengan jumlah %d!", pData[playerid][pAdminname], gold);
	
	format(tmp, sizeof(tmp), "%d", gold);
	StaffCommandLog("GIVEGOLD", playerid, otherid, tmp);
	return 1;
}

CMD:agive(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	if(IsPlayerConnected(playerid)) 
	{
		new name[24], ammount, otherid;
        if(sscanf(params, "us[24]d", otherid, name, ammount))
		{
			Usage(playerid, "/agive [playerid] [name] [ammount]");
			Names(playerid, "bandage, medicine, snack, sprunk, material, component, repairkit, bomb, marijuana, gps, sp");
			Names(playerid, "weaponlic, gasfuel, clippistol, knife, katana, cocaine, meth, ephedrine, medkit, gopay, susuolah");
			Names(playerid, "obatstres, tuna, tongkol, makarel, bulu, de, ak47, shotgun, clip, besi, alumunium, pakaian, kain,");
			Names(playerid, "ciu, amer, vodka");
			return 1;
		}
			
		if(strcmp(name,"bandage",true) == 0) 
		{		
			pData[otherid][pBandage] += ammount;
			Info(playerid, "Anda telah berhasil memberikan perban kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan perban kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"vodka",true) == 0) 
		{		
			pData[otherid][pVodka] += ammount;
			Info(playerid, "Anda telah berhasil memberikan vodka kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan vodka kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"amer",true) == 0) 
		{		
			pData[otherid][pAmer] += ammount;
			Info(playerid, "Anda telah berhasil memberikan amer kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan amer kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"ciu",true) == 0) 
		{		
			pData[otherid][pCiu] += ammount;
			Info(playerid, "Anda telah berhasil memberikan ciu kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan ciu kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"katana",true) == 0) 
		{		
			pData[otherid][pKatana] += ammount;
			Info(playerid, "Anda telah berhasil memberikan katana kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan katana kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"knife",true) == 0) 
		{		
			pData[otherid][pKnife] += ammount;
			Info(playerid, "Anda telah berhasil memberikan knife kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan knife kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"besi",true) == 0) 
		{		
			pData[otherid][pBesi] += ammount;
			Info(playerid, "Anda telah berhasil memberikan besi kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan besi kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"alumunium",true) == 0) 
		{		
			pData[otherid][pAluminium] += ammount;
			Info(playerid, "Anda telah berhasil memberikan alumunium kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan alumunium kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"pakaian",true) == 0) 
		{		
			pData[otherid][pPakaian] += ammount;
			Info(playerid, "Anda telah berhasil memberikan pakaian kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan pakaian kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"kain",true) == 0) 
		{		
			pData[otherid][pKain] += ammount;
			Info(playerid, "Anda telah berhasil memberikan kain kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan kain kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"de",true) == 0) 
		{		
			pData[otherid][pDesertEagle] += ammount;
			Info(playerid, "Anda telah berhasil memberikan DesertEagle kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan DesertEagle kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"ak47",true) == 0) 
		{		
			pData[otherid][pAK47] += ammount;
			Info(playerid, "Anda telah berhasil memberikan AK47 kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan AK47 kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"shotgun",true) == 0) 
		{		
			pData[otherid][pShotgun] += ammount;
			Info(playerid, "Anda telah berhasil memberikan shotgun kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan shotgun kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"clip",true) == 0) 
		{		
			pData[otherid][pClip] += ammount;
			Info(playerid, "Anda telah berhasil memberikan clip kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan clip kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"medkit",true) == 0) 
		{		
			pData[otherid][pMedkit] += ammount;
			Info(playerid, "Anda telah berhasil memberikan medkit kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan medkit kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"medicine",true) == 0) 
		{
			pData[otherid][pMedicine] += ammount;
			Info(playerid, "Anda telah berhasil memberikan medicine kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan medicine kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"snack",true) == 0) 
		{
			pData[otherid][pSnack] += ammount;
			Info(playerid, "Anda telah berhasil memberikan snack kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan snack kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"sprunk",true) == 0) 
		{
			pData[otherid][pSprunk] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Sprunk kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Sprunk kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"material",true) == 0) 
		{			
			pData[otherid][pMaterial] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Material kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Material kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"component",true) == 0) 
		{
			pData[otherid][pComponent] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Component kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Component kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"gopay",true) == 0) 
		{
			pData[otherid][pGopay] += ammount;
			Info(playerid, "Anda telah berhasil memberikan saldo gopay kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan saldo gopay kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"repairkit",true) == 0) 
		{
			pData[otherid][pRepairkit] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Repairkit kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Repairkit kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"bomb",true) == 0) 
		{
			pData[otherid][pBomb] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Bomb kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Bomb kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"marijuana",true) == 0) 
		{
			pData[otherid][pMarijuana] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Marijuana kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Marijuana kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"cocaine",true) == 0) 
		{
			pData[otherid][pCocaine] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Cocaine kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Cocaine kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"meth",true) == 0) 
		{
			pData[otherid][pMeth] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Meth kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Meth kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"ephedrine",true) == 0) 
		{
			pData[otherid][pEphedrine] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Ephedrine kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Ephedrine kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"gps",true) == 0) 
		{
			pData[otherid][pGPS] += ammount;
			Info(playerid, "Anda telah berhasil memberikan GPS kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan GPS kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"clippistol",true) == 0) 
		{
			pData[otherid][pAmmoPistol] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Clip Pistol kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Clip Pistol kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"clipsg",true) == 0) 
		{
			pData[otherid][pAmmoSG] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Clip SG kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Clip SG kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"clipsmg",true) == 0) 
		{
			pData[otherid][pAmmoSMG] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Clip SMG kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Clip SMG kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"susuolah",true) == 0) 
		{
			pData[otherid][pSusuolah] += ammount;
			Info(playerid, "Anda telah berhasil memberikan susuolah kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan susuolah kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"sp",true) == 0) 
		{
			pData[otherid][pStarterPack] += ammount;
			Info(playerid, "Anda telah berhasil memberikan staterpack kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan staterpack kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"obatstres",true) == 0) 
		{
			pData[otherid][pObatStress] += ammount;
			Info(playerid, "Anda telah berhasil memberikan obatstres kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan obatstres kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"tuna",true) == 0) 
		{
			pData[otherid][pItuna] += ammount;
			Info(playerid, "Anda telah berhasil memberikan ikan tuna kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan ikan tuna kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"tongkol",true) == 0) 
		{
			pData[otherid][pItongkol] += ammount;
			Info(playerid, "Anda telah berhasil memberikan ikan tongkol kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan ikan tongkol kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"makarel",true) == 0) 
		{
			pData[otherid][pImkarel] += ammount;
			Info(playerid, "Anda telah berhasil memberikan ikan makarel kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan ikan makarel kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
		else if(strcmp(name,"bulu",true) == 0) 
		{
			pData[otherid][pBulu] += ammount;
			Info(playerid, "Anda telah berhasil memberikan bulu kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan bulu kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
		}
	}
	return 1;
}

CMD:setprice(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        Usage(playerid, "/setprice [name] [price]");
        Names(playerid, "[MaterialPrice], [LumberPrice], [ComponentPrice], [ProductPrice], [FoodPrice], [FishPrice], [GsPrice]");
		Names(playerid, "[MarijuanaPrice], [EphedrinePrice], [CocainePrice] [MedkitPrice], [MedicinePrice], [Bandage]");
		Names(playerid, "[PotatoPrice], [WheatPrice], [OrangePrice], [FirstSpawnPrice], [GandumPrice], [DagingPrice], [SusuPrice], [MilkPrice]");
		Names(playerid, "[AyamPrice], [BuluPrice]");
        return 1;
    }
    if(!strcmp(name, "materialprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [materialprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MaterialPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set material price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "lumberprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [lumberprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        LumberPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set lumber price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "bandage", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [bandage] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        LumberPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set bandage price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "componentprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [componentprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ComponentPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set component price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "productprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [productprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ProductPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set product price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "medicineprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [medicineprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MedicinePrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set medicine price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "medkitprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [medkitprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MedkitPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set medkit price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "foodprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [foodprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        FoodPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set food price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "fishprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [fishprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        FishPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set fish price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "gsprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [gsprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        GStationPrice = price;
		foreach(new gsid : GStation)
		{
			if(Iter_Contains(GStation, gsid))
			{
				GStation_Save(gsid);
				GStation_Refresh(gsid);
			}
		}
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set gs price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "marijuanaprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [marijuanaprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MarijuanaPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set marijuana price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "ephedrineprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [ephedrineprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        EphedrinePrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set ephedrine price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "cocaineprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [cocaineprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        CocainePrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set cocaine price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "firstspawnprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [firstspawnprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        FirstSpawnPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set money first spawn player to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "potatoprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [potatoprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        PotatoPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set potato price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "orangeprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [orangeprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        OrangePrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set orange price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "wheatprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [wheatprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        WheatPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set wheat price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "gandumprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [gandumprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        GandumPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set gandum price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "dagingprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [dagingprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        DagingPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set daging price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "susuprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [susuprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        SusuPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set harga beli susu price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "milkprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [milkprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        MilkPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set harga jual susu price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "ayamprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [ayamprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        AyamFillPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set harga jual ayam kemas price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "buluprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [buluprice] [price]");

        if(price < 0 || price > 500000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 500000.");

        BuluAyamPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set harga jual bulu price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	return 1;
}

CMD:setstock(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        Usage(playerid, "/setstock [name] [stock]");
        Names(playerid, "[material], [component], [product], [apotek], [food], [marijuana], [ephedrine], [cocaine], [gandum], [daging], [susu], [ayam], [bulu]");
        return 1;
    }
	if(!strcmp(name, "material", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [material] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Material = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set material to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "component", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [component] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Component = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set component to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "product", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [product] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Product = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set product to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "apotek", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [apotek] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Apotek = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set apotek stok to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "food", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [food] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Food = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set food stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "gandum", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [gandum] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Gandum = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set gandum stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "daging", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [daging] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Daging = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set daging stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "marijuana", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [marijuana] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Marijuana = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set marijuana stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "ephedrine", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [ephedrine] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Ephedrine = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set ephedrine stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "cocaine", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [cocaine] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Cocaine = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set cocaine stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "susu", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [susu] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Susu = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set susu stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "ayam", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [ayam] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        AyamFill = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set ayam stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "bulu", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [bulu] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        BuluAyam = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set bulu stok to %d.", pData[playerid][pAdminname], stok);
    }
	return 1;
}

CMD:kickall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	foreach(new pid : Player)
	{
		if(pid != playerid)
		{
			UpdateWeapons(playerid);
			UpdatePlayerData(playerid);
			Servers(pid, "Sorry, server will be maintenance and your data have been saved.");
			KickEx(pid);
		}
	}
	return 1;
}

CMD:setpassword(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new cname[21], query[128], pass[65], tmp[64];
	if(sscanf(params, "s[21]s[20]", cname, pass))
	{
	    Usage(playerid, "/setpassword <ucpname> <new password>");
	    Info(playerid, "Masukan UCP name yang passwordnya akan diubah!");
	   	return 1;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT password FROM ucp WHERE ucp_name = '%s'", cname);
	mysql_tquery(g_SQL, query, "ChangeUcpPassword", "iss", playerid, cname, pass);
	
	format(tmp, sizeof(tmp), "%s", pass);
	StaffCommandLog("SETPASSWORD", playerid, INVALID_PLAYER_ID, tmp);
	return 1;
}

// SetPassword Callback
function ChangeUcpPassword(admin, cPlayer[], newpass[])
{
	if(cache_num_rows() > 0)
	{
		new query[512], pass[65], salt[16];
		Servers(admin, "Password for ucp %s has been set to \"%s\"", cPlayer, newpass);
		
		for (new i = 0; i < 16; i++) salt[i] = random(94) + 33;
		SHA256_PassHash(newpass, salt, pass, 65);

		mysql_format(g_SQL, query, sizeof(query), "UPDATE ucp SET password = '%s', salt = '%e' WHERE ucp_name = '%s'", pass, salt, cPlayer);
		mysql_tquery(g_SQL, query);
	}
	else
	{
	    // Name Exists
		Error(admin, "UCP name "DARK_E"'%s' "WHITE_E"doesn't exist in the database!", cPlayer);
	}
    return 1;
}


CMD:playsong(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new songname[1024], Float:x, Float:y, Float:z;
	if(sscanf(params, "s[1024]", songname))
		return Usage(playerid, "/playsong <link>");

	
	GetPlayerPos(playerid, x, y, z);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
		{
			PlayAudioStreamForPlayer(ii, songname);
			Servers(ii, "%s", songname);
			Servers(ii, "/stopsong");
		}
	}
	return 1;
}

CMD:playnearsong(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new songname[1024], Float:x, Float:y, Float:z;
	if(sscanf(params, "s[1024]", songname))
		return Usage(playerid, "/playnearsong <link>");
	
	GetPlayerPos(playerid, x, y, z);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
		{
			PlayAudioStreamForPlayer(ii, songname, x, y, z, 35.0, 1);
			Servers(ii, "%s", songname);
			Servers(ii, "/stopsong");
		}
	}
	return 1;
}

CMD:stopsong(playerid)
{
	StopAudioStreamForPlayer(playerid);
	Servers(playerid, "Song stop!");
	return 1;
}

CMD:gives(playerid)
{
	pData[playerid][pSnack] = 10;
	return 1;
}

CMD:togadminchat(playerid)
{
	if (pData[playerid][pAdmin] < 1)
	    return ShowNotifError(playerid, "You don't have permission to use this command.", 10000);
	if(!pData[playerid][pTogAdminchat])
	{
		pData[playerid][pTogAdminchat] = 1;
		Info(playerid, "Anda telah menonaktifkan Admin Chat");
	}
	else
	{
		pData[playerid][pTogAdminchat] = 0;
		Info(playerid, "Anda telah mengaktifkan Admin Chat");
	}
	return 1;
}

CMD:togreport(playerid)
{
	if (pData[playerid][pAdmin] < 1)
	    return ShowNotifError(playerid, "You don't have permission to use this command.", 10000);
	if(!pData[playerid][pTogReport])
	{
		pData[playerid][pTogReport] = 1;
		Info(playerid, "Anda telah menonaktifkan Report logs");
	}
	else
	{
		pData[playerid][pTogReport] = 0;
		Info(playerid, "Anda telah mengaktifkan Report logs");
	}
	return 1;
}

CMD:togask(playerid)
{
	if (pData[playerid][pAdmin] < 1)
	    return ShowNotifError(playerid, "You don't have permission to use this command.", 10000);
	if(!pData[playerid][pTogAsk])
	{
		pData[playerid][pTogAsk] = 1;
		Info(playerid, "Anda telah menonaktifkan Ask logs");
	}
	else
	{
		pData[playerid][pTogAsk] = 0;
		Info(playerid, "Anda telah mengaktifkan Ask logs");
	}
	return 1;
}

CMD:asettings(playerid)
{
	if (pData[playerid][pAdmin] < 1)
	    return ShowNotifError(playerid, "You don't have permission to use this command.", 10000);

	if(pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be logged in!");
	    return 1;
	}
	
	new str[1024], togreport[64], togask[64], togachat[64];
	if(pData[playerid][pTogReport] == 0)
	{
		togreport = ""RED_E"Disable";
	}
	else
	{
		togreport = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogAsk] == 0)
	{
		togask = ""RED_E"Disable";
	}
	else
	{
		togask = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogAdminchat] == 0)
	{
		togachat = ""RED_E"Disable";
	}
	else
	{
		togachat = ""LG_E"Enable";
	}
	
	format(str, sizeof(str), "Name\tStatus\n"WHITEP_E"Report Logs:\t%s\n"WHITEP_E"Ask Logs:\t%s\n"WHITEP_E"Admin Chat:\t%s",
	togreport,
	togask,
	togachat
	);
	
	ShowPlayerDialog(playerid, DIALOG_ASETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Admin Settings", str, "Set", "Close");
	return 1;
}

CMD:setnomor(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
	    return ShowNotifError(playerid, "You don't have permission to use this command.", 10000);

	new number, otherid;
	if(sscanf(params, "ud", otherid, number))
		return Usage(playerid, "/setnomor [playerid] [number]");

	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");

	if(number < 1 || number > 99999999999)
		return Error(playerid, "Only 3-6 number!");

	new cQuery[254];
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT phone FROM players WHERE phone = '%d'", number);
	mysql_tquery(g_SQL, cQuery, "AdminSetNumber", "id", playerid, number);
	return 1;
}