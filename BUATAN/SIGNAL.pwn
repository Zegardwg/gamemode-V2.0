#define MAX_SIGNAL 500

enum E_SIGNAL
{	
	sgStatus,
	Float:sgX,
	Float:sgY,
	Float:sgZ,
	Float:sgRX,
	Float:sgRY,
	Float:sgRZ,
	sgInt,
	sgVW,
	//Temp
	sgObj,
	Text3D:sgLabel,
	sgSeconds,
	sgTimer
};

new sgData[MAX_SIGNAL][E_SIGNAL],
	Iterator: Signal<MAX_SIGNAL>;

Signal_Save(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE sigenal SET status='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d' WHERE id='%d'",
	sgData[id][sgStatus],
	sgData[id][sgX],
	sgData[id][sgY],
	sgData[id][sgZ],
	sgData[id][sgRX],
	sgData[id][sgRY],
	sgData[id][sgRZ],
	sgData[id][sgInt],
	sgData[id][sgVW],
	id);

	return mysql_tquery(g_SQL, cQuery);
}

Signal_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamicObject(sgData[id][sgObj]))
			DestroyDynamicObject(sgData[id][sgObj]);

		if(IsValidDynamic3DTextLabel(sgData[id][sgLabel]))
			DestroyDynamic3DTextLabel(sgData[id][sgLabel]);

		static
		 string[1024], 
		  status[128];

		if(sgData[id][sgStatus] == 0)
		{
			status = "{00ff00}Good";
		}
		else if(sgData[id][sgStatus] == 1)
		{
			status = "{ff0000}Troubled";
		}
		else
		{
			status = "{ff0000}Unknown";
		}
		if(sgData[id][sgStatus] == 0)
		{
			sgData[id][sgObj] = CreateDynamicObject(3876, sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ], sgData[id][sgRX], sgData[id][sgRY], sgData[id][sgRZ], sgData[id][sgVW], sgData[id][sgInt], -1, 90.0, 90.0);
			format(string, sizeof(string), "[SIGNAL ID: %d]\n"WHITE_E"Signal Status: %s\n"WHITE_E"Signal Location: "GREEN_LIGHT"%s", id, status, GetLocation(sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ]));
			sgData[id][sgLabel] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ]+3.5, 15.0);
		}
		else
		{
			sgData[id][sgTimer] = SetTimerEx("RespawnSignal", 1000, true, "i", id);

			sgData[id][sgObj] = CreateDynamicObject(3876, sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ], sgData[id][sgRX], sgData[id][sgRY], sgData[id][sgRZ], sgData[id][sgVW], sgData[id][sgInt], -1, 90.0, 90.0);

		    format(string, sizeof(string), "[SIGNAL ID: %d]\n"WHITE_E"Signal Status: %s\n"WHITE_E"Fixxing In: "GREEN_LIGHT"%s", id, status, ConvertToMinutes(sgData[id][sgSeconds]));
			sgData[id][sgLabel] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ]+3.5, 15.0);
			UpdateDynamic3DTextLabelText(sgData[id][sgLabel], COLOR_YELLOW, string);
		}
	}
	return 1;
}

function RespawnSignal(id)
{
	new string[96];
	if(sgData[id][sgSeconds] > 1) 
	{
	    sgData[id][sgSeconds]--;
	    
		format(string, sizeof(string), "[SIGNAL ID: %d]\n"WHITE_E"Signal Status: {ff0000}Troubled\n"WHITE_E"Fixxing In: "GREEN_LIGHT"%s", id, ConvertToMinutes(sgData[id][sgSeconds]));
		UpdateDynamic3DTextLabelText(sgData[id][sgLabel], COLOR_YELLOW, string);
	}
	else if(sgData[id][sgSeconds] == 1) 
	{
	    KillTimer(sgData[id][sgTimer]);

	    sgData[id][sgSeconds] = 0;
	    sgData[id][sgTimer] = -1;
	    sgData[id][sgStatus] = 0;

	    Signal_Refresh(id);
	    Signal_Save(id);
	}
	return 1;
}

function LoadSignal()
{
    static sgid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", sgid);
			cache_get_value_name_int(i, "status", sgData[sgid][sgStatus]);
			cache_get_value_name_float(i, "posx", sgData[sgid][sgX]);
			cache_get_value_name_float(i, "posy", sgData[sgid][sgY]);
			cache_get_value_name_float(i, "posz", sgData[sgid][sgZ]);

			cache_get_value_name_float(i, "posrx", sgData[sgid][sgRX]);
			cache_get_value_name_float(i, "posry", sgData[sgid][sgRY]);
			cache_get_value_name_float(i, "posrz", sgData[sgid][sgRZ]);

			cache_get_value_name_int(i, "interior", sgData[sgid][sgInt]);
			cache_get_value_name_int(i, "world", sgData[sgid][sgVW]);
			if(sgData[sgid][sgStatus] == 1)
			{
				sgData[sgid][sgSeconds] = 60 * 20;
			}
			Signal_Refresh(sgid);
			Iter_Add(Signal, sgid);
		}
		printf("[Signal Tower] Number of Loaded: %d.", rows);
	}
}

//--------------[SIGNAL COMMAND]--------------
CMD:createsignal(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new sgid = Iter_Free(Signal), query[512];

	if(sgid == -1)
		return Error(playerid, "Can't add any more signal tower.");

	new Float: x, Float: y, Float: z, Float: a;
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;

	sgData[sgid][sgStatus] = 0;
	sgData[sgid][sgX] = x;
	sgData[sgid][sgY] = y;
	sgData[sgid][sgZ] = z;
	sgData[sgid][sgRX] = sgData[sgid][sgRY] = sgData[sgid][sgRZ] = 0.0;
	sgData[sgid][sgInt] = GetPlayerInterior(playerid);
	sgData[sgid][sgVW] = GetPlayerVirtualWorld(playerid);

	SendStaffMessage(COLOR_RED, "%s telah membuat signal tower ID: %d.", pData[playerid][pAdminname], sgid);
	Signal_Refresh(sgid);
	Iter_Add(Signal, sgid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO sigenal SET id='%d', status='%d'", sgid, sgData[sgid][sgStatus]);
	mysql_tquery(g_SQL, query, "OnSignalCreated", "i", sgid);
	return 1;
}

function OnSignalCreated(sgid)
{
	Signal_Save(sgid);
	return 1;
}

Signal_BeingEdited(sgid)
{
	if(!Iter_Contains(Signal, sgid)) return 0;
	foreach(new i : Player) if(pData[i][EditingSIGNAL] == sgid) return 1;
	return 0;
}

CMD:editsignal(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
    	return PermissionError(playerid);

    static
     sgid,
   	  type[24],
       string[128];

    if(sscanf(params, "ds[24]S()[128]", sgid, type, string))
    {
        Usage(playerid, "/editsignal [id] [name]");
        Names(playerid, "position, status, delete");
        return 1;
    }

    if(!Iter_Contains(Signal, sgid)) 
		return Error(playerid, "Invalid ID.");

	if(Signal_BeingEdited(sgid)) 
		return Error(playerid, "Can't edited specified signal tower because its being edited.");

	if(!strcmp(type, "position", true))
    {
    	if(pData[playerid][EditingSIGNAL] != -1) 
			return Error(playerid, "You're already editing.");

    	if(!IsPlayerInRangeOfPoint(playerid, 30.0, sgData[sgid][sgX], sgData[sgid][sgY], sgData[sgid][sgZ])) 
			return Error(playerid, "You're not near the signal tower you want to edit.");

		pData[playerid][EditingSIGNAL] = sgid;
		EditDynamicObject(playerid, sgData[sgid][sgObj]);
    }
    if(!strcmp(type, "status", true))
    {
    	new status;

        if(sscanf(string, "d", status))
            return Usage(playerid, "/editsignal [id] [status] [statusid 1.Safe 2.Troubled]");

        if(status < 0 || status > 1)
        	return Error(playerid, "status tidak bisa kurang dari angka 0 dan lebih dari 1");

        if(status == 0)
        {
        	KillTimer(sgData[sgid][sgTimer]);
		    sgData[sgid][sgSeconds] = 0;
	    	sgData[sgid][sgTimer] = -1;
			sgData[sgid][sgStatus] = 0;

	        Signal_Save(sgid);
			Signal_Refresh(sgid);
		}
		if(status == 1)
		{
			sgData[sgid][sgSeconds] = 60 * 20;
			sgData[sgid][sgStatus] = 1;
	        Signal_Save(sgid);
			Signal_Refresh(sgid);
		}
		SendAdminMessage(COLOR_RED, "%s has adjusted the status of Signal Tower ID: %d to %d.", pData[playerid][pAdminname], sgid, status);
    }
    else if(!strcmp(type, "delete", true))
    {
		new query[512];
		if(IsValidDynamicObject(sgData[sgid][sgObj]))
			DestroyDynamicObject(sgData[sgid][sgObj]);

		if(IsValidDynamic3DTextLabel(sgData[sgid][sgLabel]))
			DestroyDynamic3DTextLabel(sgData[sgid][sgLabel]);

		sgData[sgid][sgX] = sgData[sgid][sgY] = sgData[sgid][sgZ] = 0;
		sgData[sgid][sgRX] = sgData[sgid][sgRY] = sgData[sgid][sgRZ] = 0.0;
		sgData[sgid][sgInt] = sgData[sgid][sgVW] = 0;
		sgData[sgid][sgObj] = -1;
		sgData[sgid][sgLabel] = Text3D: -1;

		KillTimer(sgData[sgid][sgTimer]);
	    sgData[sgid][sgSeconds] = 0;
    	sgData[sgid][sgTimer] = -1;

		Iter_Remove(Signal, sgid);
		
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM sigenal WHERE id=%d", sgid);
		mysql_tquery(g_SQL, query);
		SendStaffMessage(COLOR_RED, "Staff %s menghapus Signal Tower ID %d.", pData[playerid][pAdminname], sgid);
	}
    return 1;
}

CMD:gotosignal(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		PermissionError(playerid);

	new sgid;
	if(sscanf(params, "d", sgid))
		return Usage(playerid, "/gotosignal [id]");

	if(!Iter_Contains(Signal, sgid))
		return Error(playerid, "Invalid ID!");

	SetPlayerPos(playerid, sgData[sgid][sgX]+2.5, sgData[sgid][sgY]+2.5, sgData[sgid][sgZ]);
	SetPlayerInterior(playerid, sgData[sgid][sgInt]);
	SetPlayerVirtualWorld(playerid, sgData[sgid][sgVW]);

	Info(playerid, "Anda telah diteleportkan menuju Signal Tower ID: %d", sgid);
	return 1;
}

GetSignalNearest(playerid)
{
    new tmpcount;
    foreach(new id : Signal)
    {
        if(sgData[id][sgStatus] == 0)
        {
            if(GetPlayerDistanceFromPoint(playerid, sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ]) < 1000)
            {
                 tmpcount++;
             }
             else if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
            {
                tmpcount++;
            }
        }
    }
    return tmpcount;
}

GetAdminSignal()
{
	new tmpcount;
	foreach(new id : Signal)
	{
    	tmpcount++;
    }
	return tmpcount;
} 

ReturnAdminSignalID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_SIGNAL) return -1;
	foreach(new id : Signal)
	{
    	tmpcount++;
       	if(tmpcount == slot)
       	{
        	return id;
  		}
	}
	return -1;
}

CMD:asignal(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return PermissionError(playerid);

	if(GetAdminSignal() <= 0)
		return Error(playerid, "Mission dealer sedang kosong.");

	new id, count = GetAdminSignal(), mission[2024], lstr[3024], status[1024];

	strcat(mission,"ID\tSTATUS\tLOCATION\tDISTANCE\n",sizeof(mission));
	Loop(itt, (count + 1), 1)
	{
		id = ReturnAdminSignalID(itt);
		if(sgData[id][sgStatus] == 0)
		{
			status = "{00ff00}Good";
		}
		else if(sgData[id][sgStatus] == 1)
		{
			status = "{ff0000}Troubled";
		}
		else
		{
			status = "{ff0000}Unknown";
		}
		if(itt == count)
		{
			format(lstr,sizeof(lstr), "%d.\t%s\t%s"WHITE_E"\t%0.0fm\n", id, status, GetLocation(sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ]), GetPlayerDistanceFromPoint(playerid, sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ]));
		}
		else format(lstr,sizeof(lstr), "%d.\t%s\t%s"WHITE_E"\t%0.0fm\n", id, status, GetLocation(sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ]), GetPlayerDistanceFromPoint(playerid, sgData[id][sgX], sgData[id][sgY], sgData[id][sgZ]));
		strcat(mission, lstr, sizeof(mission));
	}
	ShowPlayerDialog(playerid, DIALOG_ADMIN_SIGNAL, DIALOG_STYLE_TABLIST_HEADERS,"Signal In City",mission,"Select","Cancel");
	return 1;
}

/*
DIALOG_ADMIN_SIGNAL






pData[playerid][EditingSIGNAL] = -1;







	mysql_tquery(g_SQL, "SELECT * FROM `sigenal`", "LoadSignal");







	if(dialogid == DIALOG_ADMIN_SIGNAL)
	{
		if(!response)
			return 1;

		new sgid = ReturnAdminSignalID(listitem+1);

		if(sgData[sgid][sgStatus] == 0)
		{
			sgData[sgid][sgSeconds] = 1800;
			sgData[sgid][sgStatus] = 1;
	        Signal_Save(sgid);
			Signal_Refresh(sgid);

			Info(playerid, "Sinyal ID: %d berhasil dimatikan", sgid);
		}
		else
        {
        	KillTimer(sgData[sgid][sgTimer]);
		    sgData[sgid][sgSeconds] = 0;
	    	sgData[sgid][sgTimer] = -1;
			sgData[sgid][sgStatus] = 0;

	        Signal_Save(sgid);
			Signal_Refresh(sgid);

			Info(playerid, "Sinyal ID: %d berhasil diperbaiki", sgid);
		}
	}
	return 1;
}
	
*/