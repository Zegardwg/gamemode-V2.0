GetAccentName(playerid)
{
	new rank[24];
	if(pData[playerid][pAccent] != 0)
	{
		if(pData[playerid][pAccent] == 1) 
		{
			rank = "English";
		}
		else if(pData[playerid][pAccent] == 2) 
		{
			rank = "American";
		}
		else if(pData[playerid][pAccent] == 3) 
		{
			rank = "British";
		}
		else if(pData[playerid][pAccent] == 4) 
		{
			rank = "Chinese";
		}
		else if(pData[playerid][pAccent] == 5) 
		{
			rank = "Korean";
		}
		else if(pData[playerid][pAccent] == 6) 
		{
			rank = "Japanese";
		}
		else if(pData[playerid][pAccent] == 7) 
		{
			rank = "Asian";
		}
		else if(pData[playerid][pAccent] == 8) 
		{
			rank = "Canadian";
		}
		else if(pData[playerid][pAccent] == 9) 
		{
			rank = "Australian";
		}
		else if(pData[playerid][pAccent] == 10) 
		{
			rank = "Southern";
		}
		else if(pData[playerid][pAccent] == 11) 
		{
			rank = "Russian";
		}
		else if(pData[playerid][pAccent] == 12) 
		{
			rank = "Ukrainian";
		}
		else if(pData[playerid][pAccent] == 13) 
		{
			rank = "German";
		}
		else if(pData[playerid][pAccent] == 14) 
		{
			rank = "French";
		}
		else if(pData[playerid][pAccent] == 15) 
		{
			rank = "Portguese";
		}
		else if(pData[playerid][pAccent] == 16) 
		{
			rank = "Polish";
		}
		else if(pData[playerid][pAccent] == 17) 
		{
			rank = "Estonian";
		}
		else if(pData[playerid][pAccent] == 18) 
		{
			rank = "Latvian";
		}
		else if(pData[playerid][pAccent] == 19) 
		{
			rank = "Dutch";
		}
		else if(pData[playerid][pAccent] == 20) 
		{
			rank = "Jamaican";
		}
		else if(pData[playerid][pAccent] == 21) 
		{
			rank = "Turkish";
		}
		else if(pData[playerid][pAccent] == 22) 
		{
			rank = "Mexican";
		}
		else if(pData[playerid][pAccent] == 23) 
		{
			rank = "Spanish";
		}
		else if(pData[playerid][pAccent] == 24) 
		{
			rank = "Arabic";
		}
		else if(pData[playerid][pAccent] == 25) 
		{
			rank = "Israeli";
		}
		else if(pData[playerid][pAccent] == 26) 
		{
			rank = "Romanian";
		}
		else if(pData[playerid][pAccent] == 27) 
		{
			rank = "Italian";
		}
		else if(pData[playerid][pAccent] == 28) 
		{
			rank = "Gangsta";
		}
		else if(pData[playerid][pAccent] == 29) 
		{
			rank = "Greek";
		}
		else if(pData[playerid][pAccent] == 30) 
		{
			rank = "Serbian";
		}
		else if(pData[playerid][pAccent] == 31) 
		{
			rank = "Balkin";
		}
		else if(pData[playerid][pAccent] == 32) 
		{
			rank = "Danish";
		}
		else if(pData[playerid][pAccent] == 33) 
		{
			rank = "Scottish";
		}
		else if(pData[playerid][pAccent] == 34) 
		{
			rank = "Irish";
		}
		else if(pData[playerid][pAccent] == 35) 
		{
			rank = "Indian";
		}
		else if(pData[playerid][pAccent] == 36) 
		{
			rank = "Norwegian";
		}
		else if(pData[playerid][pAccent] == 37) 
		{
			rank = "Swedish";
		}
		else if(pData[playerid][pAccent] == 38) 
		{
			rank = "Finnish";
		}
		else if(pData[playerid][pAccent] == 39) 
		{
			rank = "Hungarian";
		}
		else if(pData[playerid][pAccent] == 40) 
		{
			rank = "Bulgarian";
		}
		else if(pData[playerid][pAccent] == 41) 
		{
			rank = "Pakistani";
		}
		else if(pData[playerid][pAccent] == 42) 
		{
			rank = "Cuban";
		}
		else if(pData[playerid][pAccent] == 43) 
		{
			rank = "Slavic";
		}
		else if(pData[playerid][pAccent] == 44) 
		{
			rank = "Indonesian";
		}
		else if(pData[playerid][pAccent] == 45) 
		{
			rank = "Filipino";
		}
		else if(pData[playerid][pAccent] == 46) 
		{
			rank = "Hawaiian";
		}
		else if(pData[playerid][pAccent] == 47) 
		{
			rank = "Somalian";
		}
		else if(pData[playerid][pAccent] == 48) 
		{
			rank = "Armenian";
		}
		else if(pData[playerid][pAccent] == 49) 
		{
			rank = "Persian";
		}
		else if(pData[playerid][pAccent] == 50) 
		{
			rank = "Vietnamese";
		}
		else if(pData[playerid][pAccent] == 51) 
		{
			rank = "Slovenian";
		}
		else if(pData[playerid][pAccent] == 52) 
		{
			rank = "Kiwi";
		}
		else if(pData[playerid][pAccent] == 53) 
		{
			rank = "Brazilian";
		}
		else if(pData[playerid][pAccent] == 54) 
		{
			rank = "Georgian";
		}
		else
		{
			rank = "Normal";
		}
	}
	else
	{
		rank = "Normal";
	}
	return rank;
}

CMD:accentss(playerid, params[])
{
	new accent;
	if(sscanf(params, "d", accent))
	{
	    Usage(playerid, "USAGE: /accent [type]");
	    Names(playerid, "(0) None - (1) English - (2) American - (3) British - (4) Chinese - (5) Korean - (6) Japanese - (7) Asian");
		Names(playerid, "(8) Canadian - (9) Australian - (10) Southern - (11) Russian - (12) Ukrainian - (13) German - (14) French");
		Names(playerid, "(15) Portguese - (16) Polish - (17) Estonian - (18) Latvian - (19) Dutch - (20) Jamaican - (21) Turkish");
		Names(playerid, "(22) Mexican - (23) Spanish - (24) Arabic - (25) Israeli - (26) Romanian - (27) Italian - (28) Gangsta");
		Names(playerid, "(29) Greek - (30) Serbian - (31) Balkin - (32) Danish - (33) Scottish - (34) Irish - (35) Indian");
		Names(playerid, "(36) Norwegian - (37) Swedish - (38) Finnish - (39) Hungarian - (40) Bulgarian - (41) Pakistani");
		Names(playerid, "(42) Cuban - (43) Slavic - (44) Indonesian - (45) Filipino - (46) Hawaiian - (47) Somalian");
		Names(playerid, "(48) Armenian - (49) Persian - (50) Vietnamese - (51) Slovenian - (52) Kiwi - (53) Brazilian - (54) Georgian");
		return 1;
	}

	switch(accent)
	{
	case 0:
		{
			pData[playerid][pAccent] = 0;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 1:
		{
			pData[playerid][pAccent] = 1;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 2:
		{
			pData[playerid][pAccent] = 2;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 3:
		{
			pData[playerid][pAccent] = 3;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 4:
		{
			pData[playerid][pAccent] = 4;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 5:
		{
			pData[playerid][pAccent] = 5;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 6:
		{
			pData[playerid][pAccent] = 6;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 7:
		{
			pData[playerid][pAccent] = 7;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 8:
		{
			pData[playerid][pAccent] = 8;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 9:
		{
			pData[playerid][pAccent] = 9;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 10:
		{
			pData[playerid][pAccent] = 10;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 11:
		{
			pData[playerid][pAccent] = 11;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 12:
		{
			pData[playerid][pAccent] = 12;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 13:
		{
			pData[playerid][pAccent] = 13;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 14:
		{
			pData[playerid][pAccent] = 14;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 15:
		{
			pData[playerid][pAccent] = 15;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 16:
		{
			pData[playerid][pAccent] = 16;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 17:
		{
			pData[playerid][pAccent] = 17;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	case 18:
		{
			pData[playerid][pAccent] = 18;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 19:
		{
			pData[playerid][pAccent] = 19;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 20:
		{
			pData[playerid][pAccent] = 20;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 21:
		{
			pData[playerid][pAccent] = 21;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 22:
		{
			pData[playerid][pAccent] = 22;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 23:
		{
			pData[playerid][pAccent] = 23;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 24:
		{
			pData[playerid][pAccent] = 24;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 25:
		{
			pData[playerid][pAccent] = 25;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 26:
		{
			pData[playerid][pAccent] = 26;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 27:
		{
			pData[playerid][pAccent] = 27;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 28:
		{
			pData[playerid][pAccent] = 28;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 29:
		{
			pData[playerid][pAccent] = 29;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 30:
		{
			pData[playerid][pAccent] = 30;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 31:
		{
			pData[playerid][pAccent] = 31;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 32:
		{
			pData[playerid][pAccent] = 32;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 33:
		{
			pData[playerid][pAccent] = 33;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 34:
		{
			pData[playerid][pAccent] = 34;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 35:
		{
			pData[playerid][pAccent] = 35;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 36:
		{
			pData[playerid][pAccent] = 36;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 37:
		{
			pData[playerid][pAccent] = 37;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 38:
		{
			pData[playerid][pAccent] = 38;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 39:
		{
			pData[playerid][pAccent] = 39;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 40:
		{
			pData[playerid][pAccent] = 40;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 41:
		{
			pData[playerid][pAccent] = 41;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 42:
		{
			pData[playerid][pAccent] = 42;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 43:
		{
			pData[playerid][pAccent] = 43;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 44:
		{
			pData[playerid][pAccent] = 44;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 45:
		{
			pData[playerid][pAccent] = 45;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 46:
		{
			pData[playerid][pAccent] = 46;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 47:
		{
			pData[playerid][pAccent] = 47;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 48:
		{
			pData[playerid][pAccent] = 48;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 49:
		{
			pData[playerid][pAccent] = 49;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 50:
		{
			pData[playerid][pAccent] = 50;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 51:
		{
			pData[playerid][pAccent] = 51;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 52:
		{
			pData[playerid][pAccent] = 52;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 53:
		{
			pData[playerid][pAccent] = 53;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
 	case 54:
		{
			pData[playerid][pAccent] = 54;
			Info(playerid, "Anda sekarang akan berbicara dalam %s accent, gunakan /accent untuk merubahnya.", GetAccentName(playerid));
		}
	}
	return 1;
}

/*

		if(pData[playerid][pAdminDuty] == 0 && pData[playerid][pAccent] == 0)
		{
			format(lstr, sizeof(lstr), "%s says: %s", ReturnName(playerid), text);
			ProxDetector(25, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		}
		if(pData[playerid][pAccent] > 0)
		{
			format(lstr, sizeof(lstr), "(%s accent) %s says: %s", GetAccentName(playerid), ReturnName(playerid), text);
			ProxDetector(25, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		}
		else if(pData[playerid][pAdminDuty] == 1)
		{
			format(lstr, sizeof(lstr), ""RED_E"%s "WHITE_E": (( %s ))", pData[playerid][pAdminname], text);
			ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		{
			if(pData[playerid][pAdmin] < 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: (( %s ))", ReturnName(playerid), text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
			else if(pData[playerid][pAdmin] > 1 || pData[playerid][pHelper] > 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: %s", pData[playerid][pAdminname], text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
		}
		return 0;
	}
}


*/