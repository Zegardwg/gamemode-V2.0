forward DCC_DM(str[]);
public DCC_DM(str[])
{
    new DCC_Channel:PM;
	//new DCC_Channel:g_Discord_JailLogs;
	PM = DCC_GetCreatedPrivateChannel();
	DCC_SendChannelMessage(PM, str);
	return 1;
}

/*DCMD:addcs(user, channel, params[])
{

	if(channel != g_Discord_Cs)
		return 1;

	new name[128], str[254];
	if(sscanf(params, "s[128]", name))
		return DCC_SendChannelMessage(channel, "**```\nUSAGE: !addcs [Player_Name]\n```**");

	if(pData[playerid][pCharStory] != 0)
		return DCC_SendChannelMessage(channel, "**```\nERROR: Akun tersebut sudah memiliki character story\n```**")

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
					Servers(i, "ValriseReality BOT telah mengset character story pada akunmu");
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
					Servers(i, "ValriseReality BOT telah menghapus character story pada akunmu");
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
}*/

//command discord jail
DCMD:ojail(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1165268091199037511"))
		return 1;
	new player[24], datez, tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))
		return DCC_SendChannelMessage(channel, "`USAGE: !ojail <name> <time in minutes)> <reason>`");

	if(strlen(tmp) > 50) return DCC_SendChannelMessage(channel, "`[ValriseBOT]: Reason must be shorter than 50 characters.`");
	if(datez < 1 || datez > 60) return DCC_SendChannelMessage(channel, "`[ValriseBOT]: Jail time must remain between 1 and 60 minutes`");

	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			DCC_SendChannelMessage(channel, "`[ValriseBOT]: Player tersebut online, gunakan !jail`");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OJailPlayerDiscord", "ssi", player, tmp, datez);
	return 1;
}

//function ojail discord
function OJailPlayerDiscord(adminid, NameToJail[], jailReason[], jailTime, channel)
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
		new str[150];
		format(str,sizeof(str),"Admin: %s memberi %s jail(offline) selama %d menit. Alasan: %s!", GetRPName(adminid), NameToJail, jailTime, jailReason);
		LogServer("Admin", str);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail=%d WHERE reg_id=%d", JailMinutes, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

//function jail discord dari discord
function JailPlayerDiscord(adminid, NameToJail[], jailReason[], jailTime)
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account {ffff00}'%s' "WHITE_E"does not exist.", NameToJail);
	}
	else
	{
	    new RegID, JailMinutes = jailTime * 60, str[256];
		cache_get_value_index_int(0, 0, RegID);
		format(str,sizeof(str),"Admin: %s memberi %s jail selama %d menit. Alasan: %s!", GetRPName(adminid), NameToJail, jailTime, jailReason);
		LogServer("Admin", str);
		SendStaffMessage(COLOR_RED, "[%s] Succeeded Offline Jail with time %d From Discord with reason %s", NameToJail, JailMinutes, jailReason);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail = '1', jail_time = '%d' WHERE reg_id = '%d'", JailMinutes, RegID);
		mysql_query(g_SQL, query);
	}
	return 1;
}

//ommand jail player dari discord
DCMD:jail(user, channel, params[])
{
	if(channel != DCC_FindChannelById("1165268091199037511"))
	return 1;
	if(channel != DCC_FindChannelById("1165268091199037511")) return DCC_SendChannelMessage(channel, "`Error you are not part of the admin team`");
	new player[24], datez, tmp[50];
	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))
		return DCC_SendChannelMessage(channel, "`USAGE: !jail <name> <time in minutes> <reason>`");

	if(strlen(tmp) > 50) return DCC_SendChannelMessage(channel, "`Reason must be shorter than 50 characters.`");
	if(datez < 1 || datez > 60) return DCC_SendChannelMessage(channel, "`Jail time must remain between 1 and 60 minutes`");
	
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "JailPlayerDiscord", "ssi", player, tmp, datez);
	return 1;
}

//ngecek player yang online di dalam kota
DCMD:online(user, channel, params[])
{
	new DCC_Embed:msgEmbed, msgField[256];
	format(msgField, sizeof(msgField), " Player Online Di Kota Valrise Reality: %s", number_format(Iter_Count(Player)));
	msgEmbed = DCC_CreateEmbed("", msgField, "", "", 0x00ff00, "Kota Valrise Reality | #ANOTHERCOMUNITY", "", "", "");
	DCC_SendChannelEmbedMessage(channel, msgEmbed);
	return 1;
}

//pengumuman ke discord announcement
DCMD:pengumuman(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1165268091199037511"))
		return 1;

	new DCC_Channel:Info;
   	Info = DCC_FindChannelById("1165268020210446336");
	if(isnull(params)) return DCC_SendChannelMessage(channel, "```PAKAI : !pengumuman [Text]```");

    new str[50000];
	format(str, sizeof(str), "%s", params);
	DCC_SendChannelMessage(Info, str);
	DCC_SendChannelMessage(channel, "```Pengumuman anda berhasil dikirimkan oleh Valrise Reality Bot!```");
	return 1;
}


DCMD:admins(user, channel, params[])
{
	new count = 0, line3[1200];
	foreach(new i:Player)
	{
		if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
		{
			format(line3, sizeof(line3), "%s\n%s(%s)\n", line3, pData[i][pName], pData[i][pAdminname], GetStaffRank(i));
			count++;
		}
	}
	if(count > 0)
	{
		new DCC_Embed:msgEmbed, msgField[256];
		format(msgField, sizeof(msgField), "```%s```", line3);
		msgEmbed = DCC_CreateEmbed("", "", "", "", 0x00ff00, "Admin online list", "", "", "");
		DCC_AddEmbedField(msgEmbed, "Admin Online In Valrise Reality", msgField);
		DCC_SendChannelEmbedMessage(channel, msgEmbed);
	}
	else return DCC_SendChannelMessage(channel, "Tidak ada administrator di kota!");
	return 1;
}

//command discord kirim pesan ke dalam kota indoland
DCMD:pesan(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1165268091199037511"))
		return 1;
	new string[256];

	if(isnull(params)) return DCC_SendChannelMessage(channel, "/pesan [text]");
	format(string, sizeof(string), "{ffffff}[Discord] : %s ", params);
	SendClientMessageToAll(COLOR_YELLOW, string);
	DCC_SendChannelMessage(channel, "```Pesan anda berhasil dikirim ke dalam kota oleh Valrise Reality Bot!```");
	return 1;
}


forward DCC_DM_EMBED(str[], pin, id[]);
public DCC_DM_EMBED(str[], pin, id[])
{
    new DCC_Channel:PM, query[200];
	PM = DCC_GetCreatedPrivateChannel();

	new DCC_Embed:embed = DCC_CreateEmbed(.title="Valrise Reality Roleplay", .image_url="https://media.discordapp.net/attachments/1165268082554581033/1165655296102899794/360_F_366360587_4KeY8GHvFbdCZSVVLbE52IVaztoqhb6c.jpg?ex=6547a417&is=65352f17&hm=c30cb540eeeee26e32e99b389d5133a6f5d93759a4196065c927ac0dafb68617&=");
	new str1[100], str2[100];

	format(str1, sizeof str1, "```\nHalo!\nUCP kamu berhasil terverifikasi,\nGunakan PIN dibawah ini untuk login ke Game```");
	DCC_SetEmbedDescription(embed, str1);
	format(str1, sizeof str1, "UCP");
	format(str2, sizeof str2, "\n```%s```", str);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	format(str1, sizeof str1, "PIN");
	format(str2, sizeof str2, "\n```%d```", pin);
	DCC_AddEmbedField(embed, str1, str2, bool:1);

	DCC_SendChannelEmbedMessage(PM, embed);

	mysql_format(g_SQL, query, sizeof query, "INSERT INTO `playerucp` (`ucp`, `verifycode`, `DiscordID`) VALUES ('%e', '%d', '%e')", str, pin, id);
	mysql_tquery(g_SQL, query);
	return 1;
}

forward CheckDiscordUCP(DiscordID[], Nama_UCP[]);
public CheckDiscordUCP(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows();
	new DCC_Role: WARGA, DCC_Guild: guild, DCC_User: user, dc[100];
	new verifycode = RandomEx(111111, 988888);
	if(rows > 0)
	{
		return SendDiscordMessage(7, "```\n[INFO]: Nama UCP tersebut sudah terdaftar```");
	}
	else 
	{
		new ns[32];
		guild = DCC_FindGuildById("1165266223378993272");
		WARGA = DCC_FindRoleById("1165267936043352146");
		user = DCC_FindUserById(DiscordID);
		format(ns, sizeof(ns), "Penduduk | %s ", Nama_UCP);
		DCC_SetGuildMemberNickname(guild, user, ns);
		DCC_AddGuildMemberRole(guild, user, WARGA);

		format(dc, sizeof(dc),  "```\n[UCP]: %s is now Verified.```", Nama_UCP);
		SendDiscordMessage(7, dc);
		DCC_CreatePrivateChannel(user, "DCC_DM_EMBED", "sds", Nama_UCP, verifycode, DiscordID);
	}
	return 1;
}

forward CheckDiscordID(DiscordID[], Nama_UCP[]);
public CheckDiscordID(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[20], dc[100];
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);

		format(dc, sizeof(dc),  "```\n[INFO]: Kamu sudah mendaftar UCP sebelumnya dengan nama %s```", ucp);
		return SendDiscordMessage(7, dc);
	}
	else 
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", Nama_UCP);
		mysql_tquery(g_SQL, characterQuery, "CheckDiscordUCP", "ss", DiscordID, Nama_UCP);
	}
	return 1;
}

DCMD:reffucp(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1165268109763031040"))
		return 1;
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "```\n[USAGE]: !reffucp ucp name```");
	if(!IsValidNameUCP(params))
		return DCC_SendChannelMessage(channel, "```\nGunakan nama UCP bukan nama IC!```");
//	DCC_SendChannelMessage(channel, "**Accept Silahkan Cek PM Bot Discord HamZyy!**);

	DCC_GetUserId(user, id, sizeof id);
	new uname[33];
	DCC_GetUserName(user, uname);

	DCC_SendChannelMessage(channel, "Perintah berhasil disubmit, mohon tunggu hasil pemeriksaan dari kami!");
	new zQuery[256];
	mysql_format(g_SQL, zQuery, sizeof(zQuery), "SELECT * FROM `playerucp` WHERE `discordID` = '%e' LIMIT 1", id);
	new Cache:ex = mysql_query(g_SQL, zQuery, true);
	new count = cache_num_rows();
	if(count > 0)
	{
		new str[256];
		format(str, sizeof(str), "```:x: Hai %s, anda sudah pernah mendaftar dan tidak bisa lagi mengambil Karcis.Silahkan ke channel <#1095732559897444394> untuk refund role dan di cek oleh staff!```", uname);
		DCC_SendChannelMessage(channel, str);
	}
	else
	{
    	new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
		mysql_tquery(g_SQL, characterQuery, "CheckDiscordID", "ss", id, params);
		DCC_SendChannelMessage(channel, "```Ucp anda berhasil diverifikasi,silahkan cek pm dari Indoland Bot!```");
	}
    cache_delete(ex);
	return 1;
}

DCMD:ucp(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1179457408695799909"))
		return 1;
    if(isnull(params)) 
		return DCC_SendChannelMessage(channel, "```\n[USAGE]: !ucp [Nama Ucp]```");
	if(!IsValidNameUCP(params))
		return DCC_SendChannelMessage(channel, "```\nGunakan nama UCP bukan nama IC!```");
//	DCC_SendChannelMessage(channel, "**Accept Silahkan Cek PM Bot Discord HamZyy!**);
	
	DCC_GetUserId(user, id, sizeof id);
	new uname[33];
	DCC_GetUserName(user, uname);

	new zQuery[256];
	mysql_format(g_SQL, zQuery, sizeof(zQuery), "SELECT * FROM `playerucp` WHERE `discordID` = '%e' LIMIT 1", id);
	new Cache:ex = mysql_query(g_SQL, zQuery, true);
	new count = cache_num_rows();
	if(count > 0)
	{
		new str[256];
		format(str, sizeof(str), "> Hai %s, Anda sudah pernah mendaftar dan tidak bisa lagi mengambil UCP", uname);
		DCC_SendChannelMessage(channel, str);
	}
	else
	{
    	new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
		mysql_tquery(g_SQL, characterQuery, "CheckDiscordID", "ss", id, params);
		DCC_SendChannelMessage(channel, "> Ucp anda berhasil diverifikasi, silahkan cek message dari Bot.");
	}
    cache_delete(ex);
	return 1;
}
