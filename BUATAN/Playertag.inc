/*
	Tags system by Agus Syahputra
*/

// menghindari nama file yang sama
#if defined _inc_tags
	#undef _inc_tags
#endif
// pengaman jika terjadi duplikat
#if defined _tags_included
	#endinput
#endif
#define _tags_included


#include <YSI\y_hooks>

#define 	MAX_TAGS				(431)
#define 	MAX_TAGS_TEXT			(40)
#define 	TAG_DEFAULT_SIZE		(30)
#define 	TAG_DEFAULT_MAX_SIZE	(50)
#define 	TAG_DEFAULT_BOLD		(true)


static 
	EditingTag[MAX_PLAYERS] = {-1, ...},
	bool:EditingTagPosition[MAX_PLAYERS] = {false, ...},
	ListedTags[MAX_PLAYERS][MAX_TAGS];

new const fontNames[][] = {
	"Arial", "Calibri", "Comic Sans MS", "Georgia", "Times New Roman", "Consolas", "Constantia", "Corbel", 
	"Courier New","Impact","Lucida Console","Palatino Linotype","Tahoma","Trebuchet MS","Verdana","Custom Font"
};

enum E_TAGS_ENUM {
	tagText[65],
	tagFont[32],
	Float:tagPos[3],
	Float:tagRot[3],
	tagId,
	tagOwner,
	tagCreated[MAX_PLAYER_NAME],
	tagBold,
	tagFontsize,
	tagColor,
	tagAlignment,
	tagObject
};


new TagData[MAX_TAGS][E_TAGS_ENUM],
	Iterator:Tags<MAX_TAGS>;

stock Tags_Create(playerid, text[]) 
{
	static 	
		Float:x, 
		Float:y, 
		Float:z, 
		Float:a;
 
	for (new id; id < MAX_TAGS; id ++) if (!Iter_Contains(Tags, id)) {

		Iter_Add(Tags, id);

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		x += 0.5 * floatsin(-a, degrees);
		y += 0.5 * floatcos(-a, degrees);

		format(TagData[id][tagFont], 32, "Arial");
		format(TagData[id][tagText], 65, ReplaceString(text));
		format(TagData[id][tagCreated], MAX_PLAYER_NAME, pData[playerid][pName]);

		TagData[id][tagPos][0] 			= x;
		TagData[id][tagPos][1] 			= y;
		TagData[id][tagPos][2] 			= z;

		TagData[id][tagRot][2] 			= (a-90);

		TagData[id][tagOwner] 			= pData[playerid][pID];
		TagData[id][tagBold] 			= TAG_DEFAULT_BOLD;
		TagData[id][tagFontsize] 		= TAG_DEFAULT_SIZE;
		TagData[id][tagAlignment] 		= OBJECT_MATERIAL_TEXT_ALIGN_CENTER;
		TagData[id][tagColor] 			= 1;
		Tags_Refresh(id);

		EditingTag[playerid] 			= id;
		EditingTagPosition[playerid] 	= false;

		EditDynamicObject(playerid, TagData[id][tagObject]);

		SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS", "Tag berhasil di buat, gerakkan cursor mu untuk memposisikan tag.");
		SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS", "Tekan "YELLOW_E"ESC "WHITE_E"untuk menggagalkan pembuatan tag ini.");
		return 1;
	}
	SendClientMessage(playerid, -1, "Tag tidak bisa dibuat, kepenuhan!");
	print("[DEBUG] TagCreate terpanggil");
	return 0;
}

stock Tags_Remove(id, database = 0) {
	if (Iter_Contains(Tags, id)) {
		if (IsValidDynamicObject(TagData[id][tagObject])) {
			DestroyDynamicObject(TagData[id][tagObject]);
		}

		if(!database) mysql_tquery(g_SQL, "DELETE FROM `tags` WHERE `tagId`='%d'", TagData[id][tagId]);

		TagData[id][tagOwner] 	= 0;
		TagData[id][tagId] 		= 0;
		Iter_Remove(Tags, id);
	}
	return 1;
}

stock Tags_Refresh(id) {
	if (!Iter_Contains(Tags,id)) {
		return 0;
	}

	if (IsValidDynamicObject(TagData[id][tagObject])) {
		DestroyDynamicObject(TagData[id][tagObject]);
	}

	foreach(new i : Player) if(IsPlayerInRangeOfPoint(i, 5, TagData[id][tagPos][0], TagData[id][tagPos][1], TagData[id][tagPos][2])) {
		Streamer_Update(i);
	}

	TagData[id][tagObject] = CreateDynamicObject(19482, TagData[id][tagPos][0], TagData[id][tagPos][1], TagData[id][tagPos][2], TagData[id][tagRot][0], TagData[id][tagRot][1], TagData[id][tagRot][2], _, _, _, 150, 150);
	SetDynamicObjectMaterialText(TagData[id][tagObject], 0, TagData[id][tagText], OBJECT_MATERIAL_SIZE_512x256, TagData[id][tagFont], TagData[id][tagFontsize], TagData[id][tagBold], RGBAToARGB(ColorList[TagData[id][tagColor]]), 0x00000000, TagData[id][tagAlignment]);
	return 1;
}

stock Tags_GetCount(playerid) {
	new count = 0;

	foreach(new id : Tags) if (Iter_Contains(Tags,id) && TagData[id][tagOwner] == pData[playerid][pID]) {
		count++;
	} 
	return count;
}

stock Tags_Nearest(playerid) {
	foreach(new id : Tags) if (Iter_Contains(Tags,id) && IsPlayerInRangeOfPoint(playerid, 3.0, TagData[id][tagPos][0], TagData[id][tagPos][1], TagData[id][tagPos][2])) {
		return id;
	} 
	return -1;
}

stock Tags_Save(id) {
	new
		query[900];

	format(query, sizeof(query), "UPDATE `tags` SET `tagText`='%s', `tagFont`='%s', `tagCreated`='%s', `tagPosx`='%.02f', `tagPosy`='%.02f', `tagPosz`='%.02f', `tagRotx`='%.02f', `tagRoty`='%.02f', `tagRotz`='%.02f'",
		SQL_ReturnEscaped(TagData[id][tagText]), SQL_ReturnEscaped(TagData[id][tagFont]), TagData[id][tagCreated], TagData[id][tagPos][0], 
		TagData[id][tagPos][1], TagData[id][tagPos][2], TagData[id][tagRot][0], TagData[id][tagRot][1], TagData[id][tagRot][2]
	);

	format(query, sizeof(query), "%s, `tagOwner`='%d', `tagBold`='%d', `tagFontsize`='%d', `tagColor`='%d', `tagAlignment`='%d' WHERE `tagId`='%d'",
		query, TagData[id][tagOwner], TagData[id][tagBold], TagData[id][tagFontsize], 
		TagData[id][tagColor], TagData[id][tagAlignment], TagData[id][tagId]
	);
	return mysql_tquery(g_SQL, query);
}

stock ResetTagsVariable(playerid) {
	EditingTag[playerid] = -1;
	EditingTagPosition[playerid] = false;
	
	foreach(new id : Tags) {
		ListedTags[playerid][id] = -1;
	}
}

stock ShowTagsDialogMenu(playerid) {
	if(!IsPlayerConnected(playerid)) {
		return 0;
	}

	Dialog_Show(playerid, TagsMenu, DIALOG_STYLE_LIST, "Tags Editor", "Set Position\nText\nSet Font\nFont Size\nToggle Bold\nText Color\nText Alignment\nSave", "Pilih", "Keluar");
	return 1;
}

//--
// 	Tags function
//--

Function:Tags_Created(playerid, id) {

	if (!Iter_Contains(Tags,id))
		return Error(playerid, "Invalid tags id.");
	
	TagData[id][tagId] = cache_insert_id();

	ClearAnimations(playerid);
	ResetTagsVariable(playerid);

	//RefreshWeaponSlot(playerid, 41);

	SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS", "Kamu telah membuat tag baru, "YELLOW"/tag clean "WHITE"untuk membersihkannya.");

	Tags_Save(id);
	Tags_Refresh(id);
	return 1;
}

Function:Tags_Load() {
	for(new id; id != cache_num_rows(); id++) {
		TagData[id][tagId] 			= cache_get_field_int(id, "tagId");
		TagData[id][tagOwner] 		= cache_get_field_int(id, "tagOwner");
		TagData[id][tagBold] 		= cache_get_field_int(id, "tagBold");
		TagData[id][tagFontsize] 	= cache_get_field_int(id, "tagFontsize");
		TagData[id][tagColor] 		= cache_get_field_int(id, "tagColor");
		TagData[id][tagAlignment] 	= cache_get_field_int(id, "tagAlignment");

		cache_get_field_content(id, "tagText", TagData[id][tagText]);
		cache_get_field_content(id, "tagFont", TagData[id][tagFont]);
		cache_get_field_content(id, "tagCreated", TagData[id][tagCreated]);

		TagData[id][tagPos][0] = cache_get_field_float(id, "tagPosx");
		TagData[id][tagPos][1] = cache_get_field_float(id, "tagPosy");
		TagData[id][tagPos][2] = cache_get_field_float(id, "tagPosz");

		TagData[id][tagRot][0] = cache_get_field_float(id, "tagRotx");
		TagData[id][tagRot][1] = cache_get_field_float(id, "tagRoty");
		TagData[id][tagRot][2] = cache_get_field_float(id, "tagRotz");

		Iter_Add(Tags, id);
		Tags_Refresh(id);
	}
	printf("*** [Database: Loaded] tags data (%d count).", cache_num_rows());
	return 1;	
}

//--
//	Hooking
//--

hook OnPlayerConnect(playerid)
{
	ResetTagsVariable(playerid);
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(EditingTag[playerid] != -1)
	{
		//ResetWeaponID(playerid, 41);
		Tags_Remove(EditingTag[playerid], 1);
	}
	ResetTagsVariable(playerid);
	return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new id = EditingTag[playerid];

	if (response == EDIT_RESPONSE_FINAL)
	{
		if (Iter_Contains(Tags, id))
		{
			if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 3.5)
			{
				Tags_Refresh(id);
				
				EditDynamicObject(playerid, TagData[id][tagObject]);
				return Error(playerid, "Posisi tags terlalu jauh denganmu.");
			}

			TagData[id][tagPos][0] = x;
			TagData[id][tagPos][1] = y;
			TagData[id][tagPos][2] = z;

			TagData[id][tagRot][0] = rx;
			TagData[id][tagRot][1] = ry;
			TagData[id][tagRot][2] = rz;

			EditingTagPosition[playerid] = false;

			SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS", "Posisi tag telah tersimpan!.");
			ShowTagsDialogMenu(playerid);
			Tags_Refresh(id);
		}
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
		if (Iter_Contains(Tags, id))
		{
			if (EditingTagPosition[playerid])
			{
				SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS", "You've cancleed editing for this tag.");
				ShowTagsDialogMenu(playerid);
				Tags_Refresh(id);
			}
			else
			{
				Error(playerid, "Kamu menggagalkan pembuatan tag ini.");
				Tags_Remove(id);
				EditingTag[playerid] = -1;
			}
		}
		EditingTagPosition[playerid] = false;
	}
	return 1;
}

//--
// 	Tags commands
//--

CMD:tags(playerid, params[])
{
	new options[7];

	if (sscanf(params, "s[7]", options))
		return Usage(playerid, "/tag [create/clean/detail]");

	if(!strcmp(options, "create", true))
	{
		if (pData[playerid][pLevel] < 7) 
			return Error(playerid, "~r~ERROR: ~w~Level kamu tidak cukup untuk membuat tag, minimal level 7.");

		if (GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) 
			return Error(playerid, "~r~ERROR: ~w~Sistem saat ini tidak mendukung pembuatan tag dalam interior.");
		
		if (pData[playerid][pJailTime] > 0) 
			return Error(playerid, "~r~ERROR: ~w~Tidak bisa melakukan ini di dalam penjara.");
		
		if (EditingTag[playerid] != -1) 
			return Error(playerid, "~r~ERROR: ~w~Kamu sedang merubah posisi tag!.");

		if(Tags_GetCount(playerid) > 2) return Error(playerid, "~r~ERROR: ~w~Kamu tidak bisa membuat tag lagi, hapus tag sebelumnya untuk membuat lagi (maksimal 2 tags).");
		
		Dialog_Show(playerid, TagName, DIALOG_STYLE_INPUT, "Masukkan teks ..", ""BLUE_E"HINT:\n"WHITE_E"- Teks mendukung bbcode, gunakan (n):untuk membuat baris baru.\n\
			(r):warna merah, (w):putih, (b):biru, (bl):hitam, (g):hijau, (y):kuning\n\
			Contoh: Ganti (r)saya (w)menjadi merah dan seterusnya putih\n\
			- Tidak memasukkan teks kepanjangan\n\n\
			Maksimal teks tidak lebih dari 40 huruf:", "Lanjut", "Keluar"
		);
	}
	else if (!strcmp(options, "clean", true))
	{
		new 
			id = Tags_Nearest(playerid),
			count = 0,
			list[255];

		if (id != -1)
		{
			list = "";

			if((pData[playerid][pFaction] != 1) && (TagData[id][tagOwner] != pData[playerid][pID]) && (!pData[playerid][pAdmin]))
				return Error(playerid, "~r~ERROR: ~w~Kamu tidak dapat menghapus tag ini.");

//			if(pData[playerid][pFactionRank] < 3) return Error(playerid, "You must be at least rank 3.");

			foreach(new i : Tags) if (count < MAX_TAGS && Iter_Contains(Tags,i) && IsPlayerInRangeOfPoint(playerid, 3.0, TagData[i][tagPos][0], TagData[i][tagPos][1], TagData[i][tagPos][2])) {
				ListedTags[playerid][count++] = i;

				strreplace(TagData[i][tagText], "\n", "");
				format(list, sizeof(list), "%s%s\n", list, TagData[i][tagText]);
			}

			if (count > 1) {
				Dialog_Show(playerid, RemoveTag, DIALOG_STYLE_LIST, "Clean Tag", list, "Bersihkan", "Keluar");
			}
			else {
				Tags_Remove(id);
				SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS", "Kamu telah menghapus tag didepanmu.");
			}
		}
		else Error(playerid, "~r~ERROR~n~~w~Kamu tidak berada di sekitar tag apapun.");
	}
	else if (!strcmp(options, "detail", true))
	{
		if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

		static 
			id;

		if((id = Tags_Nearest(playerid)) != -1) {
			Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_TABLIST_HEADERS, "Tags Information", "Name\tValue\nTag id\t%d\nTag Name\t%s\nTag Chat Length\t%d\nTag Created by\t%s\nTag Size\t%d\nTag Font\t%s\nTag Color id\t%d\nTag Bold\t%s", "Keluar", "", 
				id, TagData[id][tagText], strlen(TagData[id][tagText]), TagData[id][tagCreated],
				TagData[id][tagFontsize], TagData[id][tagFont], TagData[id][tagColor], TagData[id][tagBold] ? ("Yes") : ("No")
			);
		}
		else Error(playerid, "~r~ERROR~n~~w~Kamu tidak berada di sekitar tag apapun.");
	}
	return 1;
}

CMD:gototags(playerid, params[])
{
	static 
		id;

	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	if (sscanf(params, "d", id))
		return Usage(playerid, "/gototags [tag id]");

	if (!Iter_Contains(Tags,id))
		return Error(playerid, "Invalid tags id.");

	SetPlayerPos(playerid, TagData[id][tagPos][0], TagData[id][tagPos][1], TagData[id][tagPos][2]);
	SetPlayerFacingAngle(playerid, TagData[id][tagRot][2]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

	SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS","You have been teleport to tags id %d.", id);
	return 1;
}

//--
// 	Tags dialogs
//--

Dialog:RemoveTag(playerid, response, listitem, inputtext[]) {
	if(response) {
		new id = ListedTags[playerid][listitem];

		if((pData[playerid][pFaction] != 1) && (TagData[id][tagOwner] != pData[playerid][pID]) && (!pData[playerid][pAdmin]))
		{
        	Error(playerid, "~r~ERROR~n~~w~Kamu tidak dapat menghapus tag ini.");
            
            callcmd::tag(playerid, "clear");
		}
		else {
			Tags_Remove(id);

			ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);
			SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS", "Kamu telah menghapus tag di sekitarmu.");
		}
	}
	return 1;
}

Dialog:TagsMenu(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = EditingTag[playerid];
	
		switch(listitem)
		{
			case 0: { //edit posisi
				EditDynamicObject(playerid, TagData[id][tagObject]);
				EditingTagPosition[playerid] = true;
			}
			case 1: {
				Dialog_Show(playerid, TagsText, DIALOG_STYLE_INPUT, "Masukkan teks ..", ""BLUE_E"HINT:\n"WHITE_E"- Teks mendukung bbcode, gunakan (n):untuk membuat baris baru, \
					(r):warna merah, (w):putih, \n\
					\t(b):biru, (bl):hitam, (g):hijau, (bl):kuning\n\
					\tContoh: Ganti (r)saya (w)menjadi merah dan seterusnya putih\n\
					- Tidak memasukkan teks kepanjangan\n\n\
					Maksimal teks tidak lebih dari 40 huruf:", "Ubah", "Keluar"
				);
			}
			case 2: 
			{
				new str[255];

				for(new i; i != sizeof(fontNames); i++) {
					format(str, sizeof(str), "%s%s\n", str, fontNames[i]);
				}
				Dialog_Show(playerid, TagsFont, DIALOG_STYLE_LIST, "Tags Editor > Font", str, "Pilih", "Kembali");
			}
			case 3: {
				Dialog_Show(playerid, TagsFontSize, DIALOG_STYLE_INPUT, "Tags Editor > Font Size", "Ukuran saat ini: %02d\nMasukkan angka tidak lebih dari 50.", "Ubah", "Kembali", TagData[id][tagFontsize]);
			}
			case 4: 
			{
				switch(TagData[id][tagBold])
				{
					case 1: TagData[id][tagBold] = false;
					case 0: TagData[id][tagBold] = true;
				}

				Info(playerid, "~g~TAGS BOLD~n~~w~Teks bold di %s.", (TagData[id][tagBold]) ? ("~g~aktifkan") : ("~r~nonaktifkan"));
				ShowTagsDialogMenu(playerid);
				Tags_Refresh(id);
			}
			case 5: {
				Dialog_Show(playerid, TagsColor, DIALOG_STYLE_INPUT, "Tags Editor > Color",color_string, "Pilih","Kembali");
			}
			case 6: {
				Dialog_Show(playerid, TagsAlignment, DIALOG_STYLE_LIST, "Tags Editor > Alignment", "Right\nCenter\nLeft", "Pilih", "Kembali");
			}
			case 7: {
				Dialog_Show(playerid, TagsSave, DIALOG_STYLE_MSGBOX, "Tags Editor > Save", "Apakah kamu ingin menyelesaikan pengeditan tag ini?\nNOTE: Tag tidak akan dapat di ubah setelah kamu menyelesaikan pengeditan ini.", "Simpan (>>)", "Tidak (<<)");
			}
		}
	}
	else Dialog_Show(playerid, TagsSave, DIALOG_STYLE_MSGBOX, "Tags Editor > Save", "Apakah kamu ingin menyelesaikan pengeditan tag ini?\nNOTE: Tag tidak akan dapat di ubah setelah kamu menyelesaikan pengeditan ini.", "Simpan (>>)", "Tidak (<<)");
	return 1;
}

Dialog:TagsAlignment(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = EditingTag[playerid];

		TagData[id][tagAlignment] = listitem;
		Error(playerid, "~g~TAGS ALIGNMENT~n~~w~Posisi alignment di ubah menjadi ~r~%s.", inputtext);
		ShowTagsDialogMenu(playerid);
		Tags_Refresh(id);
	}
	else Dialog_Show(playerid, TagsSave, DIALOG_STYLE_MSGBOX, "Tags Editor > Save", "Apakah kamu ingin menyelesaikan pengeditan tag ini?\nNOTE: Tag tidak akan dapat di ubah setelah kamu menyelesaikan pengeditan ini.", "Simpan (>>)", "Tidak (<<)");

	return 1;
}

Dialog:TagName(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if (strlen(inputtext) < 1 || strlen(inputtext) >= MAX_TAGS_TEXT) {
			Dialog_Show(playerid, TagName, DIALOG_STYLE_INPUT, "Masukkan teks ..", ""BLUE_E"HINT:\n"WHITE_E"- Teks mendukung bbcode, gunakan (n):untuk membuat baris baru, \
				(r):warna merah, (w):putih, \n\
				\t(b):biru, (bl):hitam, (g):hijau, (bl):kuning\n\
				\tContoh: Ganti (r)saya (w)menjadi merah dan seterusnya putih\n\
				- Tidak memasukkan teks kepanjangan\n\n\
				Maksimal teks tidak lebih dari 40 huruf:", "Ubah", "Keluar"
			);
			return 1;
		}

		Tags_Create(playerid, inputtext);
	}
	return 1;
}

Dialog:TagsText(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = EditingTag[playerid];

		if (strlen(inputtext) < 1 || strlen(inputtext) >= MAX_TAGS_TEXT) {
			Dialog_Show(playerid, TagsText, DIALOG_STYLE_INPUT, "Masukkan teks ..", ""BLUE_E"HINT:\n"WHITE_E"- Teks mendukung bbcode, gunakan (n):untuk membuat baris baru, \
				(r):warna merah, (w):putih, \n\
				\t(b):biru, (bl):hitam, (g):hijau, (bl):kuning\n\
				\tContoh: Ganti (r)saya (w)menjadi merah dan seterusnya putih\n\
				- Tidak memasukkan teks kepanjangan\n\n\
				Maksimal teks tidak lebih dari 40 huruf:", "Ubah", "Keluar"
			);
			return 1;
		}

		format(TagData[id][tagText], 65, ReplaceString(inputtext));
		ShowTagsDialogMenu(playerid);
		Tags_Refresh(id);
	}
	else ShowTagsDialogMenu(playerid);
	return 1;
}

Dialog:CustomFont(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = EditingTag[playerid];

		format(TagData[id][tagFont], 24, inputtext);
		ShowTagsDialogMenu(playerid);
		Tags_Refresh(id);
	}
	else
	{
		new str[255];

		for(new i; i != sizeof(fontNames); i++) {
			format(str, sizeof(str), "%s%s\n", str, fontNames[i]);
		}
		Dialog_Show(playerid, TagsFont, DIALOG_STYLE_LIST, "Tags Editor > Font", str, "Pilih", "Kembali");
	}
	return 1;
}

Dialog:TagsFont(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = EditingTag[playerid];

		if (listitem == sizeof(fontNames)-1)
			return Dialog_Show(playerid, CustomFont, DIALOG_STYLE_INPUT, "Custom Font", "Masukkan nama font yang kamu inginkan.\nPastikan font yang kamu masukkan, tersedia di PC/Laptop kamu", "Gunakan", "Kembali");

		format(TagData[id][tagFont], 24, inputtext);
		ShowTagsDialogMenu(playerid);
		Tags_Refresh(id);
	}
	else ShowTagsDialogMenu(playerid);
	return 1;
}

Dialog:TagsFontSize(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = EditingTag[playerid];

		if (strval(inputtext) < 1 || strval(inputtext) > TAG_DEFAULT_MAX_SIZE)
			return Dialog_Show(playerid, TagsFontSize, DIALOG_STYLE_INPUT, "Tags Editor > Font Size", "Ukuran saat ini: %02d\nMasukkan angka tidak lebih dari 50.", "Ubah", "Kembali", TagData[id][tagFontsize]);

		TagData[id][tagFontsize] = strval(inputtext);
		Tags_Refresh(id);

		ShowTagsDialogMenu(playerid);
	}
	else ShowTagsDialogMenu(playerid);
	return 1;
}


Dialog:TagsColor(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = EditingTag[playerid],
			color = strval(inputtext);
        
        if(!(0 <= color <= sizeof(ColorList)-1))
        { 
	        Dialog_Show(playerid, TagsColor, DIALOG_STYLE_INPUT, "Tags Editor > Color",color_string, "Pilih","Kembali");	
		    return Error(playerid, "~r~ERROR~n~~w~ID warna yang kamu pilih salah.");
	   	}

	   	TagData[id][tagColor] = color;
		ShowTagsDialogMenu(playerid);
		Tags_Refresh(id);
	}
	else ShowTagsDialogMenu(playerid);

	return 1;
}

Dialog:TagsSave(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = EditingTag[playerid];

		if(IsValidDynamicObject(TagData[id][tagObject])) {
			DestroyDynamicObject(TagData[id][tagObject]);
		}


		SetCameraBehindPlayer(playerid);
		SetPlayerLookAt(playerid, TagData[id][tagPos][0], TagData[id][tagPos][1]);
		
		ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);

		SendClientMessageEx(playerid, COLOR_ARWIN, "TAGS","Tunggu beberapa saat untuk memunculkan tag yang di buat.");
		Error(playerid, "~b~Spraying tag with spray can ...", 5000);
		GivePlayerWeapon(playerid, 41, 99999);
		
		defer Spraying(playerid);
	}
	else ShowTagsDialogMenu(playerid);
	return 1;
}

timer Spraying[5000](playerid) {
	mysql_tquery(g_SQL, "INSERT INTO `tags` SET `tagBold`='1'", "Tags_Created", "dd", playerid, EditingTag[playerid]);
	return 1;
}
