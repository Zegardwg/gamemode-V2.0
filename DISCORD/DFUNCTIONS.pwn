/*

	FUCTION CMD DISCORD

*/

//DISCORD

//CHANNEL DISCORD
new DCC_Channel:chucp, DCC_Channel:chunverif;
new DCC_Channel:infomypos, DCC_Channel:servermt, DCC_Channel:g_Discord_Cs;
new DCC_Channel:g_Discord_Information, DCC_Channel:g_Discord_JailLogs;
new DCC_Channel:g_discord_code, DCC_Channel:g_Discord_Chat;
//GUILD DISCORD
new DCC_Guild:guildid;

//ROLE DISCORD
new DCC_Role:rolewarga;
new DCC_Role:rolerrpteam;
new DCC_Role:roledeveloper;

LoadDiscordDCC()
{
	//CHANNEL
	chucp = DCC_FindChannelById("1148268387399630971");
	chunverif = DCC_FindChannelById("1148268387399630971");
	infomypos = DCC_FindChannelById("1148268386330099808");
	servermt = DCC_FindChannelById("1148268383368908860");
	g_Discord_Information = DCC_FindChannelById("1148268382878187543");
	g_discord_code = DCC_FindChannelById("1148268387399630971");
	g_Discord_Chat = DCC_FindChannelById("1148268386330099807");
	g_Discord_JailLogs = DCC_FindChannelById("1148268386330099810");
	g_Discord_Cs = DCC_FindChannelById("1148268386330099808");

	//GUILD
	guildid = DCC_FindGuildById("1148268379409481728");

	//ROLE
	rolewarga = DCC_FindRoleById("1148268379560476777");
	rolerrpteam = DCC_FindRoleById("1148268379438858310");
	roledeveloper = DCC_FindRoleById("1148268379409481729");
}

function BindUcpCheck(const pname[], const ucpname[], const channelid[])
{
	new DCC_Channel:channel = DCC_FindChannelById(channelid);
	if(cache_num_rows())
	{
		new query[524];
		mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM players WHERE username = '%s' LIMIT 1", pname);
		mysql_tquery(g_SQL, query, "BindUcpCharacter", "sss", pname, ucpname, channelid);
	}
	else
	{
		new str[254];
		format(str, sizeof(str), "**```\nERROR: Akun UCP %s belum terdaftar di database\n```**", ucpname);
		DCC_SendChannelMessage(channel, str);
	}
	return 1;
}

function BindUcpCharacter(const pname[], const ucpname[], const channelid[])
{
	new DCC_Channel:channel = DCC_FindChannelById(channelid);
	if(cache_num_rows())
	{
		new query[524];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET ucp_name = '%s' WHERE username = '%s' LIMIT 1", ucpname, pname);
		mysql_tquery(g_SQL, query);

		new str[524];
		format(str, sizeof(str), "**```\nINFO: Character %s telah dibind pada UCP %s \n```**", pname, ucpname);
		DCC_SendChannelMessage(channel, str);
	}
	else
	{
		new str[254];
		format(str, sizeof(str), "**```\nERROR: Character dengan nama %s belum terdaftar di database\n```**", pname);
		DCC_SendChannelMessage(channel, str);
	}
	return 1;
}

MySQL_CheckDiscordId(const ucpname[], const userid[])
{
	new query[524];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM ucp WHERE discordid = '%s'", userid);
	mysql_tquery(g_SQL, query, "CheckDiscordId", "ss", ucpname, userid);
	return 1;
}

function CheckDiscordId(const ucpname[], const userid[])
{
	new username[MAX_PLAYER_NAME], str[254];
	if(cache_num_rows())
	{
		cache_get_value_name(0, "ucp_name", username);

		format(str, sizeof(str), "**```\nINFO: Akun discordmu sudah pernah mendaftar UCP dengan nama (%s)\n```**", username);
		DCC_SendChannelMessage(chucp, str);

		DCC_SetGuildMemberNickname(guildid, DCC_FindUserById(userid), username);
		DCC_AddGuildMemberRole(guildid, DCC_FindUserById(userid), rolewarga);
	}
	else
	{
		MySQL_CheckUcpCreate(ucpname, userid);
	}
	return 1;
}

MySQL_CheckUcpCreate(const ucpname[], const userid[])
{
	new query[524];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM ucp WHERE ucp_name = '%s' LIMIT 1", ucpname);
	mysql_tquery(g_SQL, query, "CheckUcpCreate", "ss", ucpname, userid);
	return 1;
}

function CheckUcpCreate(const ucpname[], const userid[])
{
	if(cache_num_rows())
	{
		new str[128];
		format(str, sizeof(str), "**```\nERROR: Akun ucp dengan nama %s sudah pernah mendaftar\n```**", ucpname);
		DCC_SendChannelMessage(chucp, str);
	}
	else
	{
		new DCC_User:user = DCC_FindUserById(userid), str[524];
		format(str, sizeof(str), "**```\nINFO: Akun %s telah berhasil terdaftar\n```**", ucpname);
		DCC_SendChannelMessage(chucp, str);


		DCC_SetGuildMemberNickname(guildid, DCC_FindUserById(userid), ucpname);
		DCC_AddGuildMemberRole(guildid, DCC_FindUserById(userid), rolewarga);

		DCC_CreatePrivateChannel(DCC_User:user, "UcpEmbedMessage", "ss", ucpname, userid);
	}
	return 1;
}

function UcpEmbedMessage(const ucpname[], const userid[])
{
	new DCC_Channel:pm = DCC_GetCreatedPrivateChannel(), query[524], pin = RandomEx(11111, 99999);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO ucp SET ucp_name = '%s', pin_code = '%d', discordid = '%s', reg_date = CURRENT_TIMESTAMP()", ucpname, pin, userid);
	mysql_tquery(g_SQL, query);

	new DCC_Embed:embedmsg, str[524];
	embedmsg = DCC_CreateEmbed(.title="GloryPeace Roleplay (UCP)", .image_url="");

	format(str, sizeof(str), "```\nHalo %s!\nUCP kamu berhasil terverifikasi,\nGunakan PIN dibawah ini untuk login ke dalam game\n```", ucpname);
	DCC_SetEmbedDescription(embedmsg, str);

	format(str, sizeof(str), "```\n %s \n```", ucpname);
	DCC_AddEmbedField(embedmsg, "UCP", str, bool:1);

	format(str, sizeof(str), "```\n %d \n```", pin);
	DCC_AddEmbedField(embedmsg, "PIN", str, bool:1);

	DCC_SetEmbedColor(embedmsg, 0x13ffff);
	DCC_SetEmbedFooter(embedmsg, "PIN Verification", "");

	DCC_SendChannelEmbedMessage(pm, embedmsg);
	return 1;
}

MySQL_UnverifUCP(const discordid[])
{
	new query[254];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM ucp WHERE discordid = '%s' LIMIT 1", discordid);
	mysql_tquery(g_SQL, query, "UnverifUCP", "s", discordid);
	return 1;
}

function UnverifUCP(const discordid[])
{
	if(cache_num_rows())
	{
		new query[254], str[524], ucpname[MAX_PLAYER_NAME];

		cache_get_value_name(0, "ucp_name", ucpname);

		mysql_format(g_SQL, query, sizeof(query), "UPDATE ucp SET register = '0' WHERE discordid = '%s' LIMIT 1", discordid);
		mysql_tquery(g_SQL, query);

		format(str, sizeof(str), "**```\nINFO: Akun UCP %s telah berhasil di unverif! gunakan pin terakhir yang telah diberikan oleh BOT untuk login kedalam game\n```**", ucpname);
		DCC_SendChannelMessage(chunverif, str);
	}
	else
	{
		DCC_SendChannelMessage(chunverif, "**```\nERROR: Akun discordmu belum memiliki UCP\n```**");
	}
	return 1;
}
//

MySQL_Checkcode(const discordid[])
{
	new query[524];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM ucp WHERE discordid = '%s' LIMIT 1", discordid);
	mysql_tquery(g_SQL, query, "CodeUCP", "s", discordid);
	return 1;
}

function CodeUCP(const discordid[])
{
	if(cache_num_rows())
	{
		new DCC_User:user = DCC_FindUserById(discordid), str[524], ucpname[MAX_PLAYER_NAME];

		cache_get_value_name(0, "ucp_name", ucpname);

		format(str, sizeof(str), "**```\nINFO: Akun %s telah berhasil meriset code\n```**", ucpname);
		DCC_SendChannelMessage(g_discord_code, str);

		DCC_CreatePrivateChannel(DCC_User:user, "Ucpcode", "s", discordid);
	}
	else
	{
		DCC_SendChannelMessage(g_discord_code, "**```\nERROR: Akun discordmu belum memiliki UCP\n```**");
	}
	return 1;
}

function Ucpcode(const discordid[])
{
	new DCC_Channel:code = DCC_GetCreatedPrivateChannel(), query[524], pin = RandomEx(11111, 99999), ucpname[MAX_PLAYER_NAME];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE ucp SET pin_code = '%d' WHERE discordid = '%s' LIMIT 1", pin, discordid);
	mysql_tquery(g_SQL, query);

	new DCC_Embed:embedmsg, str[524];
	embedmsg = DCC_CreateEmbed(.title="GloryPeace Roleplay (UCP)", .image_url="");

	format(str, sizeof(str), "```\nHalo %s!\nUCP kamu berhasil meriset kode,\nGunakan PIN dibawah ini untuk login ke dalam game\n```", ucpname);
	DCC_SetEmbedDescription(embedmsg, str);

	format(str, sizeof(str), "```\n %s \n```", ucpname);
	DCC_AddEmbedField(embedmsg, "UCP", str, bool:1);

	format(str, sizeof(str), "```\n %d \n```", pin);
	DCC_AddEmbedField(embedmsg, "PIN", str, bool:1);

	DCC_SetEmbedColor(embedmsg, 0x13ffff);
	DCC_SetEmbedFooter(embedmsg, "PIN Verification", "");

	DCC_SendChannelEmbedMessage(code, embedmsg);
	return 1;
}


function PlayerKickALL(playerid)
{
	print("Server maintenance...");
	return GameModeExit();
}

function ResPlayerKickALL(playerid)
{
	print("Server Restarting...");
	return GameModeExit();	
}

function DCC_OnMessageCreate(DCC_Message:message)
{
	new realMsg[100];
    DCC_GetMessageContent(message, realMsg, 100);
    new bool:IsBot;
    new DCC_Channel:channel;
 	DCC_GetMessageChannel(message, channel);
    new DCC_User:author;
	DCC_GetMessageAuthor(message, author);
    DCC_IsUserBot(author, IsBot);
    if(channel == g_Discord_Chat && !IsBot) //!IsBot will block BOT's message in game
    {
        new str[152];
        format(str,sizeof(str), "{8a6cd1}[BMKG] {ffffff}%s", realMsg);
        SendClientMessageToAll(-1, str);
    }

    return 1;
}

function JailPlayerDiscord(NameToJail[], jailReason[], jailTime)
{
	if(cache_num_rows() < 1)
	{
		new msgError[256];
		format(msgError, sizeof(msgError), "[GLORYPEACE BOT]: Account '%s' does not exist.", NameToJail);
		return DCC_SendChannelMessage(g_Discord_JailLogs, msgError);
	}
	else
	{
	    new RegID, JailMinutes = jailTime * 60, str[256];
		cache_get_value_index_int(0, 0, RegID);

		format(str, sizeof str, "```\nINFO: Berhasil menjail orang dengan nama %s, dengan alasan %s sampai waktu %d\n```", NameToJail, jailReason, jailTime);
		DCC_SendChannelMessage(g_Discord_JailLogs, str);
		SendStaffMessage(COLOR_RED, "[%s] Succeeded Offline Jail with time %d From Discord with reason %s", NameToJail, JailMinutes, jailReason);

		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail = '1', jail_time = '%d' WHERE reg_id = '%d'", JailMinutes, RegID);
		mysql_query(g_SQL, query);
	}
	return 1;
}

function UnJailPlayerDiscord(NameToJail[], jailReason[], jailTime)
{
	if(cache_num_rows() < 1)
	{
		new msgError[256];
		format(msgError, sizeof(msgError), "[GLORYPEACE BOT]: Account '%s' does not exist.", NameToJail);
		return DCC_SendChannelMessage(g_Discord_JailLogs, msgError);
	}
	else
	{
	    new RegID, str[256];
		cache_get_value_index_int(0, 0, RegID);

		format(str, sizeof str, "```\nINFO: Berhasil unjail orang dengan nama %s\n```", NameToJail);
		DCC_SendChannelMessage(g_Discord_JailLogs, str);
		SendStaffMessage(COLOR_RED, "[%s] telah unjailed", NameToJail);

		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail = '0', jail_time = '0' WHERE reg_id = '%d'", RegID);
		mysql_query(g_SQL, query);
	}
	return 1;
}
