/*

	CMD DISCORD

*/

DCMD:help(user, channel, params[])
{	
	new bool:status;
	DCC_HasGuildMemberRole(guildid, user, rolerrpteam, status);
	if(status == false)
		return 1;

	new str[1024];
	strcat(str,  "**:robot: GLORYPEACE BOT COMMAND:\n_```");
	strcat(str, "\n!binducp - for bind character to ucp account (Admin Command)");
	strcat(str, "\n!addcs - for add character story account player (Admin Command)");
	strcat(str, "\n!delcs - for delete character story account player (Admin Command)");
	strcat(str, "\n!help - for check list command in this bot (Admin Command)\n```_\n**");
	strcat(str, "\n!code - melihat kode anda\n```_\n**");
	DCC_SendChannelMessage(channel, str);
	return 1;
}

DCMD:binducp(user, channel, params[])
{
	new bool:status;
	DCC_HasGuildMemberRole(guildid, user, rolerrpteam, status);
	if(status == false)
		return 1;

	new ucpname[MAX_PLAYER_NAME], pname[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]s[24]", ucpname, pname))
		return DCC_SendChannelMessage(channel, "**```\n!binducp [ucpname] [Player_Name]\n```**");

	new query[254], channelid[21];
	DCC_GetChannelId(DCC_Channel:channel, channelid, sizeof(channelid));
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM ucp WHERE ucp_name = '%s' LIMIT 1", ucpname);
	mysql_tquery(g_SQL, query, "BindUcpCheck", "sss", pname, ucpname, channelid);
	return 1;
}

DCMD:addcs(user, channel, params[])
{

	if(channel != g_Discord_Cs)
		return 1;

	new name[128], str[254];
	if(sscanf(params, "s[128]", name))
		return DCC_SendChannelMessage(channel, "**```\nUSAGE: !addcs [Player_Name]\n```**");

	format(File, sizeof(File), "[AkunPlayer]/Stats/%s.ini", name);

	if(dini_Exists(File))
	{
		if(dini_Int(File, "CharacterStory") != 0)
			return DCC_SendChannelMessage(channel, "**```\nERROR: Akun tersebut sudah memiliki character story\n```**");

		foreach(new i : Player)
		{
			if(IsPlayerConnected(i))
			{
				if(!strcmp(name, pData[i][pName]))
				{
					pData[i][pCharStory] = 1;
					Servers(i, "GloryPeace BOT telah mengset character story pada akunmu");
				}
			}
		}
		dini_IntSet(File, "CharacterStory", 1);
		format(str, sizeof(str), "**```\nINFO: Berhasil memberikan character story pada akun %s\n```**", name);
		DCC_SendChannelMessage(channel, str);
	}
	else
	{
		format(str, sizeof(str), "**```\nERROR: Akun %s belum terdaftar di database\n```**", name);
		DCC_SendChannelMessage(channel, str);
	}
	return 1;
}

DCMD:delcs(user, channel, params[])
{

	if(channel != g_Discord_Cs)
		return 1;

	new name[128], str[254];
	if(sscanf(params, "s[128]", name))
		return DCC_SendChannelMessage(channel, "**```\nUSAGE: !delcs [Player_Name]\n```**");

	format(File, sizeof(File), "[AkunPlayer]/Stats/%s.ini", name);

	if(dini_Exists(File))
	{
		if(dini_Int(File, "CharacterStory") != 1)
			return DCC_SendChannelMessage(channel, "**```\nERROR: Akun tersebut tidak memiliki character story\n```**");

		foreach(new i : Player)
		{
			if(IsPlayerConnected(i))
			{
				if(!strcmp(name, pData[i][pName]))
				{
					pData[i][pCharStory] = 0;
					Servers(i, "GloryPeace BOT telah menghapus character story pada akunmu");
				}
			}
		}
		dini_IntSet(File, "CharacterStory", 0);
		format(str, sizeof(str), "**```\nINFO: Berhasil menghapus character story pada akun %s\n```**", name);
		DCC_SendChannelMessage(channel, str);
	}
	else
	{
		format(str, sizeof(str), "**```\nERROR: Akun %s belum terdaftar di database\n```**", name);
		DCC_SendChannelMessage(channel, str);
	}
	return 1;
}

DCMD:ucp(user, channel, params[])
{
	new ucpname[MAX_PLAYER_NAME];
	if(channel != chucp)
		return 1;

	if(sscanf(params, "s[24]", ucpname)) return DCC_SendChannelMessage(channel, "**```\nUSAGE: !ucp [ucpname]\n```**");
	if(strlen(ucpname) < 5 || strlen(ucpname) > 20) return DCC_SendChannelMessage(channel, "**```\nERROR: Minimal 5-20 character\n```**");
	if(!IsValidUcpName(ucpname)) return DCC_SendChannelMessage(channel, "**```\nERROR: Invalid UCP name! Dont use symbol\n```**");
	if(strfind(params, "_", false) != -1) return DCC_SendChannelMessage(channel, "`[GLORYPEACEBOT:RP]: JANGAN MENGGUNAKAN SIMBOL INI '_'`");
	if(strfind(params, " ", false) != -1) return DCC_SendChannelMessage(channel, "`[GLORYPEACEBOT:RP]: JANGAN MENGGUNAKAN KARAKTER SPASI`");

	new userid[21];
	DCC_GetUserId(DCC_User:user, userid, sizeof(userid));
	MySQL_CheckDiscordId(ucpname, userid);
	return 1;
}

DCMD:unverif(user, channel, params[])
{
	if(channel != chunverif)
		return 1;

	new userid[21];
	DCC_GetUserId(DCC_User:user, userid, sizeof(userid));
	MySQL_UnverifUCP(userid);
	return 1;
}

DCMD:code(user, channel, params[])
{
	if(channel != g_discord_code)
		return 1;

	new userid[21];
	DCC_GetUserId(DCC_User:user, userid, sizeof(userid));
	MySQL_Checkcode(userid);
	return 1;
}

DCMD:restart(user, channel, playerid, params[])
{
	new bool:status;
	DCC_HasGuildMemberRole(guildid, user, roledeveloper, status);
	if(status == false)
		return 1;

	if(channel != servermt) return DCC_SendChannelMessage(channel, "`[GLORYPEACEBOT]: Error you are not part of the admin team`");
	SendRconCommand("hostname GLORYPEACE ROLEPLAY");
	SendRconCommand("password 0");
	GameTextForAll("Server will restart in 20 seconds", 200, 3);
	SetTimer("ResPlayerKickALL", 200, true);
	DCC_SendChannelMessage(channel, "Successfully kicked all the players in Server");

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
		SaveLunarSystem(playerid);
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
	logss = DCC_CreateEmbed("GLORYPEACE ROLEPLAY");
	DCC_SetEmbedTitle(logss, "GLORYPEACE ROLEPLAY");
	DCC_SetEmbedTimestamp(logss, timestamp);
	DCC_SetEmbedColor(logss, 0xff0000);
	DCC_SetEmbedImage(logss, "");
	DCC_SetEmbedThumbnail(logss, "");
	DCC_SetEmbedFooter(logss, "GLORYPEACE ROLEPLAY", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "RESTART SERVER\n@everyone");
	DCC_AddEmbedField(logss, "SERVER STATUS:", stroi, true);
	DCC_SendChannelEmbedMessage(mt, logss);
	return 1;
}

DCMD:mt(user, channel, playerid, params[])
{
	new bool:status;
	DCC_HasGuildMemberRole(guildid, user, roledeveloper, status);
	if(status == false)
		return 1;

	if(channel != servermt) return DCC_SendChannelMessage(channel, "`[GLORYPEACEBOT]: Error you are not part of the admin team`");
	SendRconCommand("hostname GLORYPEACE ROLEPLAY | [MAINTANANCE]");
	SendRconCommand("password glorypeacerp2023");
	SetTimer("PlayerKickALL", 100000, true);
	DCC_SendChannelMessage(channel, "Successfully kicked all the players in Server");

	foreach(new i : Player)
	{
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
		SaveLunarSystem(playerid);
		UpdateWeapons(playerid);
		UpdatePlayerData(playerid);
	    GameTextForPlayer(i, "~r~M~g~aintenance", 9000, 0);
        SetPlayerInterior(i,0);
		TogglePlayerControllable(i, 0);
		InterpolateCameraPos(i, 1294.263549, -1337.225830, 278.767089, 1337.283325, -1430.924926, 68.419837, 10000);
		InterpolateCameraLookAt(i, 1291.685546, -1333.435791, 276.769744, 1339.189086, -1435.458740, 67.518539, 10000);
		SendClientMessageToAll(-1, "Ini MAINTENANCE server. Database aman tidak bakal roleback...");
		KickEx(i);
	}

	new DCC_Channel:mt, DCC_Embed:logss;
	new y, m, d, timestamp[200];
	getdate(y, m , d);
	mt = DCC_FindChannelById("1101630354625921084");
	format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
	logss = DCC_CreateEmbed("GLORYPEACE ROLEPLAY");
	DCC_SetEmbedTitle(logss, "GLORYPEACE ROLEPLAY");
	DCC_SetEmbedTimestamp(logss, timestamp);
	DCC_SetEmbedColor(logss, 0xff0000);
	DCC_SetEmbedImage(logss, "");
	DCC_SetEmbedThumbnail(logss, "");
	DCC_SetEmbedFooter(logss, "GLORYPEACE ROLEPLAY", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "SERVER MAINTENANCE\n@everyone");
	DCC_AddEmbedField(logss, "SERVER STATUS:", stroi, true);
	DCC_SendChannelEmbedMessage(mt, logss);
	DCC_SetBotNickname(guildid, "GLORYPEACE ROLEPLAY [MAINTENANCE]");
	return 1;
}

DCMD:jail(user, channel, params[])
{
	if(channel != g_Discord_JailLogs) return DCC_SendChannelMessage(channel, "`[GLORYPEACEBOT]: Error you are not part of the admin team`");
	new player[24], datez, tmp[50];
	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))
		return DCC_SendChannelMessage(channel, "`USAGE: !jail <name> <time in minutes> <reason>`");

	if(strlen(tmp) > 50) return DCC_SendChannelMessage(channel, "`[GLORYPEACEBOT]: Reason must be shorter than 50 characters.`");
	if(datez < 1 || datez > 60) return DCC_SendChannelMessage(channel, "`[GLORYPEACEBOT]: Jail time must remain between 1 and 60 minutes`");
	
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "JailPlayerDiscord", "ssi", player, tmp, datez);
	return 1;
}

DCMD:unjail(user, channel, params[])
{
	if(channel != g_Discord_JailLogs) return DCC_SendChannelMessage(channel, "`[GLORYPEACEBOT]: Error you are not part of the admin team`");
	new player[24];
	if(sscanf(params, "s[24]ds[50]", player))
		return DCC_SendChannelMessage(channel, "`USAGE: !unjail <name>`");

	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "UnJailPlayerDiscord", "s", player);
	return 1;
}