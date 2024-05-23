AddPlayerContact(playerid, cname[], cnumber)
{
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO phonebook (owner, cname, cnumber) VALUES ('%d', '%s', '%d')", pData[playerid][pID], cname, cnumber);
	mysql_tquery(g_SQL, query);
	return 1;
}

DisplayContact(playerid)
{
	//if(pData[playerid][pPhoneBook] == 0)
		//return Error(playerid, "You dont have a phone book.");

	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
	mysql_query(g_SQL, query);
	new rows = cache_num_rows();
	if(rows)
	{
		new string[2000], cname[40], cnumber;
		format(string, sizeof(string), "Name\tNumber\n"GREEN_LIGHT"Add Contact"WHITE_E"\n");
		for(new i; i < rows; ++i)
	    {
			cache_get_value_name(i, "cname", cname);
			cache_get_value_name_int(i, "cnumber", cnumber);
			
			format(string, sizeof(string), "%s"WHITE_E"%s\t%d\n", string, cname, cnumber);
		}
		ShowPlayerDialog(playerid, DIALOG_EDITCTRESPONSE, DIALOG_STYLE_TABLIST_HEADERS, "Phonebook List", string, "Select", "Close");
	}
	else
	{
		new string[2000];
		format(string, sizeof(string), "Name\tNumber\n");
		format(string, sizeof(string), "%s"GREEN_LIGHT"Add Contact"WHITE_E"\n", string);
		ShowPlayerDialog(playerid, DIALOG_ADDCTRESPONSE, DIALOG_STYLE_TABLIST_HEADERS, "Phonebook List", string, "Select", "Close");
	}
	return 1;
}

ReturnPlayerContactID(playerid, hslot)
{
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;

	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
	mysql_query(g_SQL, query);
	new rows = cache_num_rows();

	if(rows)
	{
		new owner, tmpcount, dbid;
		for(new i; i < rows; ++i)
	    {
	    	cache_get_value_name_int(i, "id", dbid);
	    	cache_get_value_name_int(i, "owner", owner);
			if(pData[playerid][pID] == owner)
			{
	     		tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return dbid;
	  			}
		    }
		}
	}
	return -1;
}

Player_OwnsContact(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;

	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
	mysql_query(g_SQL, query);

	new rows = cache_num_rows();
	if(rows)
	{
		new owner;
		for(new i; i < rows; ++i)
	    {
	    	cache_get_value_name_int(i, "owner", owner);
			if(pData[playerid][pID] == owner) return 1;
		}
	}
	return 0;
}

Player_ContactCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
	new query[512], count;
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM phonebook WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
	mysql_query(g_SQL, query);
	
	new rows = cache_num_rows();
	if(rows)
	{
		for(new i; i < rows; ++i)
	    {
			if(Player_OwnsContact(playerid, i)) count++;
		}
	}
	return count;
	#else
	return 0;
	#endif
}
CMD:phonebook(playerid, params[])
{
	if(pData[playerid][pPhone] == 0) 
		return Error(playerid, "Anda tidak memiliki Ponsel!");

	if(Inventory_Count(playerid, "Phone") < 1)
		return ShowNotifError(playerid, "Kamu tidak memilik phone!", 10000);
	
	if(pData[playerid][pUsePhone] == 0) 
		return Error(playerid, "Handphone anda sedang dimatikan");

	if(pData[playerid][pPhoneBook] == 0)
		return Error(playerid, "You dont have a phone book.");

	DisplayContact(playerid);
	return 1;
}
/*

//ENUM DIALOG

	//CONTACT
	DIALOG_PHONECT,
	DIALOG_ADDCTRESPONSE,
	DIALOG_ADDCT,
	DIALOG_EDITCTRESPONSE,
	DIALOG_EDITCTMENU,
	DIALOG_EDITNAMECT,
	DIALOG_EDITNUMBERCT,
	DIALOG_SENDMSGCT

//DIALOGID

	if(dialogid == DIALOG_PHONECT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					DisplayContact(playerid);
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_ADDCT, DIALOG_STYLE_INPUT, "Add Contact", "Tulis nomor kontak baru yang ingin kamu tambahkan:", "Add", "No");
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
			ShowPlayerDialog(playerid, DIALOG_ADDCT, DIALOG_STYLE_INPUT, "Add Contact", "Tulis nomor kontak baru yang ingin kamu tambahkan:", "Add", "No");
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
			else if(number < 1 || number > 9999)
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
			SetPVarInt(playerid, "ClickedContact", ReturnPlayerContactID(playerid, (listitem + 1)));
			ShowPlayerDialog(playerid, DIALOG_EDITCTMENU, DIALOG_STYLE_LIST, "Contact Menu", "Edit Name\nEdit Number\nCall Contact\nSMS Contact\nDelete Contact", "Select", "Cancel");
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
				case 2:
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
							if(ph == pData[playerid][pPhone]) return Error(playerid, "Nomor sedang sibuk!");
							foreach(new ii : Player)
							{
								if(pData[ii][pPhone] == ph)
								{
									if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");
									if(pData[ii][pUsePhone] == 0) return Error(playerid, "Tidak dapat menelepon, Ponsel tersebut yang dituju sedang Offline");
									if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
										return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

									if(pData[ii][pCall] == INVALID_PLAYER_ID)
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
				}
				case 3:
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
	if(dialogid == DIALOG_SENDMSGCT)
	{
		new dbid = GetPVarInt(playerid, "ClickedContact");

		if(pData[playerid][pPhone] == 0) 
			return Error(playerid, "Anda tidak memiliki Ponsel!");

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
			else if(number < 0 || number > 9999)
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
	}
    return 1;
}

*/
