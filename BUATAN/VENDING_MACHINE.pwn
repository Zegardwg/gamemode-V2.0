//Vending System
#define MAX_VENDING 100

enum E_VENDING
{
	venOwner[MAX_PLAYER_NAME],
	venPrice,
	Float:venX,
	Float:venY,
	Float:venZ,
	Float:venRX,
	Float:venRY,
	Float:venRZ,
	venWorld,
	venInt,
	venMoney,
	venDrinkPrice,
	venProduct,
	venVisit,
	//Not Save
	venObject,
	Text3D:venLabel,
};

new vmData[MAX_VENDING][E_VENDING],
	Iterator:Vending<MAX_VENDING>;

Vending_Save(id)
{
	new dquery[2048];
	format(dquery, sizeof(dquery), "UPDATE vendingmachine SET owner='%s', price='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d', money='%d', drinkprice='%d', product='%d', visit='%d' WHERE ID='%d'",
	vmData[id][venOwner],
	vmData[id][venPrice],
	vmData[id][venX],
	vmData[id][venY],
	vmData[id][venZ],
	vmData[id][venRX],
	vmData[id][venRY],
	vmData[id][venRZ],
	vmData[id][venInt],
	vmData[id][venWorld],
	vmData[id][venMoney],
	vmData[id][venDrinkPrice],
	vmData[id][venProduct],
	vmData[id][venVisit],
	id);

	return mysql_tquery(g_SQL, dquery);
}


Vending_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamicObject(vmData[id][venObject]))
			DestroyDynamicObject(vmData[id][venObject]);

		if(IsValidDynamic3DTextLabel(vmData[id][venLabel]))
			DestroyDynamic3DTextLabel(vmData[id][venLabel]);

		new status[128], string[128];
		if(vmData[id][venProduct] == 0)
		{
			status = "{FF0000}OUT OF STOCK{FFFFFF}";
		}
		else
		{	
			format(string, sizeof(string), "{00FF00}%d{FFFFFF}", vmData[id][venProduct]);
			status = string;
		}
		new tstr[1024];
        if(strcmp(vmData[id][venOwner], "-"))
        {
			format(tstr, sizeof(tstr), "[VENDING ID: %d]\n{ffffff}Vending Stock: %s\n{ffffff}Location: "GREEN_LIGHT"%s\n{ffffff}Drink Price: {00ff00}%s\n{ffffff}Owned by %s\n"LG_E"'ALT' {ffffff}- for buy a drink", id, status, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), FormatMoney(vmData[id][venDrinkPrice]), vmData[id][venOwner]);
            vmData[id][venObject] = CreateDynamicObject(1209, vmData[id][venX], vmData[id][venY], vmData[id][venZ], vmData[id][venRX], vmData[id][venRY], vmData[id][venRZ], vmData[id][venWorld], vmData[id][venInt], -1, 90.0, 300.0);
            vmData[id][venLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, vmData[id][venX], vmData[id][venY], vmData[id][venZ]+1.5, 5.0);
        }
		else
		{
			format(tstr, sizeof(tstr), "[VENDING ID: %d]\n{00FF00}This Vending for sell\n{FFFFFF}Location: {00FF00}%s\n{FFFFFF}Price: {00FF00}%s\n"WHITE_E"Type /buy to purchase", id, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), FormatMoney(vmData[id][venPrice]));
        	vmData[id][venObject] = CreateDynamicObject(1209, vmData[id][venX], vmData[id][venY], vmData[id][venZ], vmData[id][venRX], vmData[id][venRY], vmData[id][venRZ], vmData[id][venWorld], vmData[id][venInt], -1, 90.0, 300.0);
            vmData[id][venLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, vmData[id][venX], vmData[id][venY], vmData[id][venZ]+1.5, 5.0);
		}
	}		
	return 1;
}


VendingLabel_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamic3DTextLabel(vmData[id][venLabel]))
			DestroyDynamic3DTextLabel(vmData[id][venLabel]);

		new status[128], string[128];
		if(vmData[id][venProduct] == 0)
		{
			status = "{FF0000}OUT OF STOCK{FFFFFF}";
		}
		else
		{	
			format(string, sizeof(string), "{00FF00}%d{FFFFFF}", vmData[id][venProduct]);
			status = string;
		}
		new tstr[254];
        if(strcmp(vmData[id][venOwner], "-"))
        {
			format(tstr, sizeof(tstr), "[VENDING ID: %d]\n{ffffff}Vending Stock: %s\n{ffffff}Location: "GREEN_LIGHT"%s\n{ffffff}Drink Price: {00ff00}%s\n{ffffff}Owned by %s\n"LG_E"'ALT' {ffffff}- for buy a drink", id, status, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), FormatMoney(vmData[id][venDrinkPrice]), vmData[id][venOwner]);
            vmData[id][venLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, vmData[id][venX], vmData[id][venY], vmData[id][venZ]+1.5, 5.0);
        }
		else
		{
			format(tstr, sizeof(tstr), "[VENDING ID: %d]\n{00FF00}This Vending for sell\n{FFFFFF}Location: {00FF00}%s\n{FFFFFF}Price: {00FF00}%s\n"WHITE_E"Type /buy to purchase", id, GetLocation(vmData[id][venX], vmData[id][venY], vmData[id][venZ]), FormatMoney(vmData[id][venPrice]));
            vmData[id][venLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, vmData[id][venX], vmData[id][venY], vmData[id][venZ]+1.5, 5.0);
		}
	}		
	return 1;
}


Player_OwnsVending(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(vmData[id][venOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_VendingCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Vending)
	{
		if(Player_OwnsVending(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

Vending_Reset(id)
{
	format(vmData[id][venOwner], MAX_PLAYER_NAME, "-");
	vmData[id][venProduct] = 0;
    vmData[id][venMoney] = 0;
	vmData[id][venDrinkPrice] = 0;
	Vending_Refresh(id);
}

function LoadVending()
{
    new rows = cache_num_rows();
 	if(rows)
  	{
   		new venid, owner[MAX_PLAYER_NAME];
		for(new i; i < rows; i++)
		{
  			cache_get_value_name_int(i, "ID", venid);
		    cache_get_value_name(i, "owner", owner);
			format(vmData[venid][venOwner], MAX_PLAYER_NAME, owner);
			cache_get_value_name_int(i, "price", vmData[venid][venPrice]);
		    cache_get_value_name_float(i, "posx", vmData[venid][venX]);
		    cache_get_value_name_float(i, "posy", vmData[venid][venY]);
		    cache_get_value_name_float(i, "posz", vmData[venid][venZ]);
		   	cache_get_value_name_float(i, "posrx", vmData[venid][venRX]);
		    cache_get_value_name_float(i, "posry", vmData[venid][venRY]);
		    cache_get_value_name_float(i, "posrz", vmData[venid][venRZ]);
		    cache_get_value_name_int(i, "interior", vmData[venid][venInt]);
			cache_get_value_name_int(i, "world", vmData[venid][venWorld]);
			cache_get_value_name_int(i, "money", vmData[venid][venMoney]);
			cache_get_value_name_int(i, "drinkprice", vmData[venid][venDrinkPrice]);
			cache_get_value_name_int(i, "product", vmData[venid][venProduct]);
			cache_get_value_name_int(i, "visit", vmData[venid][venVisit]);

			Vending_Refresh(venid);
			Iter_Add(Vending, venid);
	    }
	    printf("[Vending Machine] Number of loaded: %d.", rows);
	}
}

GetRestockVending()
{
	new tmpcount;
	foreach(new id : Vending)
	{
		if(strcmp(vmData[id][venOwner], "-"))
		{
	    	if(vmData[id][venProduct] < 100)
	    	{
     			tmpcount++;
	    	}
		}
	}
	return tmpcount;
}

ReturnRestockVendingID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_VENDING) return -1;
	foreach(new id : Vending)
	{
		if(strcmp(vmData[id][venOwner], "-"))
		{
		    if(vmData[id][venProduct] < 100)
		    {
	     		tmpcount++;
	       		if(tmpcount == slot)
	       		{
	        		return id;
	  			}
	  		}
		}
	}
	return -1;
}

//----------[ Vending Commands ]-----------
CMD:createven(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new query[512];
	new venid = Iter_Free(Vending);

	if(venid == -1) return Error(playerid, "You cant create more vending!");

	new price;
	if(sscanf(params, "d", price))
		return Usage(playerid, "/createven [price]");


	format(vmData[venid][venOwner], 128, "-");
	vmData[venid][venPrice] = price;

	new Float: x, Float: y, Float: z, Float: a;
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;

	vmData[venid][venX] = x;
	vmData[venid][venY] = y;
	vmData[venid][venZ] = z;
	vmData[venid][venRX] = vmData[venid][venRY] = vmData[venid][venRZ] = 0.0;
	vmData[venid][venInt] = GetPlayerInterior(playerid);
	vmData[venid][venWorld] = GetPlayerVirtualWorld(playerid);
	vmData[venid][venProduct] = 0;
	vmData[venid][venDrinkPrice] = 0;
	vmData[venid][venMoney] = 0;

	SendStaffMessage(COLOR_RED, "%s telah membuat vending machine ID: %d.", pData[playerid][pAdminname], venid);

  	Vending_Refresh(venid);
	Iter_Add(Vending, venid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO vendingmachine SET ID='%d', owner='%s', price='%d'", venid, vmData[venid][venOwner], vmData[venid][venOwner], vmData[venid][venPrice]);
	mysql_tquery(g_SQL, query, "OnVendingCreated", "i", venid);
	return 1;
}

function OnVendingCreated(venid)
{
	Vending_Save(venid);
	return 1;
}

Vending_BeingEdited(venid)
{
	if(!Iter_Contains(Vending, venid)) return 0;
	foreach(new i : Player) if(pData[i][EditingVENID] == venid) return 1;
	return 0;
}

CMD:editven(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
    	return PermissionError(playerid);

    static
     venid,
    	 type[24],
        	 string[128];

    if(sscanf(params, "ds[24]S()[128]", venid, type, string))
    {
        Usage(playerid, "/editven [id] [name]");
        Names(playerid, "position, location, price, owner, stock, money, reset, delete");
        return 1;
    }

    if(!Iter_Contains(Vending, venid)) 
		return Error(playerid, "Invalid ID.");

	if(Vending_BeingEdited(venid)) 
		return Error(playerid, "Can't edited specified vending because its being edited.");

	if(!strcmp(type, "position", true))
    {
    	if(pData[playerid][EditingVENID] != -1) 
			return Error(playerid, "You're already editing.");

    	if(!IsPlayerInRangeOfPoint(playerid, 30.0, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ])) 
			return Error(playerid, "You're not near the vending you want to edit.");

		pData[playerid][EditingVENID] = venid;
		EditDynamicObject(playerid, vmData[venid][venObject]);
    }
	if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]);

        Vending_Save(venid);
		Vending_Refresh(venid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of vending ID: %d.", pData[playerid][pAdminname], venid);
    }
    if(!strcmp(type, "price", true))
    {
    	new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editven [id] [price] [Ammount]");

        if(price < 1)
        	return Error(playerid, "price tidak bisa kurang dari angka 1");

		vmData[venid][venPrice] = price;

        Vending_Save(venid);
		Vending_Refresh(venid);

		SendAdminMessage(COLOR_RED, "%s has adjusted the price of vending ID: %d to %s.", pData[playerid][pAdminname], venid, FormatMoney(price));
    }
    else if(!strcmp(type, "owner", true))
    {
        new owners[MAX_PLAYER_NAME];

        if(sscanf(string, "s[32]", owners))
            return Usage(playerid, "/editven [id] [owner] [player name] (use '-' to no owner)");

        format(vmData[venid][venOwner], MAX_PLAYER_NAME, owners);
        vmData[venid][venVisit] = gettime() + (86400 * 30);
        
        Vending_Save(venid);
		Vending_Refresh(venid);

       	SendAdminMessage(COLOR_RED, "%s has adjusted the owner of vending ID: %d to %s", pData[playerid][pAdminname], venid, owners);
    }
    if(!strcmp(type, "stock", true))
    {
    	new prod;

        if(sscanf(string, "d", prod))
            return Usage(playerid, "/editven [id] [product] [Ammount]");

        if(prod < 1 || prod > 100)
        	return Error(playerid, "stock tidak bisa kurang dari 1 dan lebih dari 100");

		vmData[venid][venProduct] = prod;

        Vending_Save(venid);
		Vending_Refresh(venid);

		SendAdminMessage(COLOR_RED, "%s has adjusted the stock of vending ID: %d to %d.", pData[playerid][pAdminname], venid, prod);
    }
    else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return Usage(playerid, "/editven [id] [money] [Ammount]");

        if(money < 1 || money > 10000)
        	return Error(playerid, "money tidak bisa kurang dari $1 dan lebih dari $10.000");

        vmData[venid][venMoney] = money;

        Vending_Save(venid);
		Vending_Refresh(venid);

       	SendAdminMessage(COLOR_RED, "%s has adjusted the money of vending ID: %d to %s.", pData[playerid][pAdminname], venid, FormatMoney(money));
    }
	else if(!strcmp(type, "reset", true))
    {
		Vending_Reset(venid);
		Vending_Save(venid);

        SendAdminMessage(COLOR_RED, "%s has reset vending ID: %d.", pData[playerid][pAdminname], venid);
	}
    else if(!strcmp(type, "delete", true))
    {
		Vending_Reset(venid);

		new query[512];
		if(IsValidDynamicObject(vmData[venid][venObject]))
			DestroyDynamicObject(vmData[venid][venObject]);

		if(IsValidDynamic3DTextLabel(vmData[venid][venLabel]))
			DestroyDynamic3DTextLabel(vmData[venid][venLabel]);

		vmData[venid][venX] = vmData[venid][venY] = vmData[venid][venZ] = vmData[venid][venRX] = vmData[venid][venRY] = vmData[venid][venRZ] = 0.0;
		vmData[venid][venInt] = vmData[venid][venWorld] = 0;
		vmData[venid][venObject] = -1;
		vmData[venid][venLabel] = Text3D: -1;

		Iter_Remove(Vending, venid);
		
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vendingmachine WHERE id=%d", venid);
		mysql_tquery(g_SQL, query);
		SendStaffMessage(COLOR_RED, "Staff %s menghapus Vending Machine ID %d.", pData[playerid][pAdminname], venid);
	}
    return 1;
}

CMD:vmedit(playerid, params[])
{
	foreach(new venid : Vending)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]))
		{
			if(!Player_OwnsVending(playerid, venid))
				return Error(playerid, "Kamu bukan pemilik vending machine ini.");

			if(Vending_BeingEdited(venid))
				return Error(playerid, "Vending ini sedang dalam perbaikan admin!");

			pData[playerid][pGetVENID] = venid;
			new mstr[248], lstr[512];
			format(mstr,sizeof(mstr),""WHITE_E"VENDING ID %d", venid);
			format(lstr,sizeof(lstr),""WHITE_E"Drink Price \t({00FF00}%s/1 Drink)\n{FFFFFF}Money Storage \t({00ff00}%s{ffffff})\t(%d)", FormatMoney(vmData[venid][venDrinkPrice]), FormatMoney(vmData[venid][venMoney]), vmData[venid][venProduct]);
			ShowPlayerDialog(playerid, VENDING_MENU, DIALOG_STYLE_TABLIST, mstr, lstr,"Select","Close");
			pData[playerid][pGetVENID] = venid;
		}
	}
	return 1;
}

CMD:gotoven(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotoven [id]");
	if(!Iter_Contains(Vending, id)) return Error(playerid, "VENDING ID tidak ada.");
	
	SetPlayerPosition(playerid, vmData[id][venX], vmData[id][venY], vmData[id][venZ], 2.0);
    SetPlayerInterior(playerid, vmData[id][venInt]);
    SetPlayerVirtualWorld(playerid, vmData[id][venWorld]);
	Servers(playerid, "Teleport ke ID VENDING %d", id);
	return 1;
}

CMD:buydrink(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");
	{
		foreach(new venid : Vending)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]))
			{
				if(strcmp(vmData[venid][venOwner], "-")) 
				{
					if(vmData[venid][venDrinkPrice] > pData[playerid][pMoney]) 
						return Error(playerid, "Kamu tidak memiliki uang.");

					if(vmData[venid][venProduct] == 0)
						return Error(playerid, "vending machine ini telah kehabisan stock");

					if(vmData[venid][venDrinkPrice] == 0)
						return Error(playerid, "Harga minuman belum di set");

					if(Vending_BeingEdited(venid))
						return Error(playerid, "Vending ini sedang dalam perbaikan admin!");

					vmData[venid][venProduct] -= 1;
					vmData[venid][venMoney] += vmData[venid][venDrinkPrice];
					GivePlayerMoneyEx(playerid, -vmData[venid][venDrinkPrice]);
					//Inventory_Add(playerid, "Sprunk", 2958, 1);
					Info(playerid, "Kamu telah berhasil membeli 1 botol minuman di vending machine seharga "GREEN_LIGHT"%s"WHITE_E"", FormatMoney(vmData[venid][venDrinkPrice]));
					SendNearbyMessage(playerid, 3.0, COLOR_PURPLE, "** %s membeli minuman di vending machine dan langsung meminumnya", ReturnName(playerid));
					Vending_Save(venid);
					VendingLabel_Refresh(venid);
				}
				else return Error(playerid, "Vending Machine ini belum memiliki pemilik");
			}
		}
	}
	return 1;
}

GetOwnedVending(playerid)
{
	new tmpcount;
	foreach(new venid : Vending)
	{
	    if(!strcmp(vmData[venid][venOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
ReturnPlayerVendingID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new venid : Vending)
	{
	    if(!strcmp(pData[playerid][pName], vmData[venid][venOwner], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return venid;
  			}
	    }
	}
	return -1;
}

CMD:myvending(playerid)
{
	if(GetOwnedVending(playerid) == 0) return Error(playerid, "Anda tidak memiliki vending machine.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new venid, _tmpstring[128], count = GetOwnedVending(playerid), CMDSString[512];
	CMDSString = "";
	Loop(itt, (count + 1), 1)
	{
	    venid = ReturnPlayerVendingID(playerid, itt);
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s (ID: %d)\n", itt, GetLocation(vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]), venid);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s (ID: %d)\n", itt, GetLocation(vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]), venid);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_VENDING, DIALOG_STYLE_LIST, "{FF0000}ValriseReality{0000FF}Vending", CMDSString, "Select", "Cancel");
	return 1;
}


/*


----------------------[ENUM PLAYER & DIALOG]-----------------


	//VENDING MACHINE
 	pGetVENID,
 	EditingVENID



	//VENDING SYSTEM
	VENDING_MENU,
	VENDING_DRINK_PRICE,
	VENDING_MONEY,
	VENDING_DEPOSITMONEY,
	VENDING_WITHDRAWMONEY,
	VENDING_DEPOSITSPRUNK

	
	//TARO DI NATIVE.pwn

	pData[playerid][EditingVENID] = -1; //untuk reset value edit position di system vending machine ic
	pData[playerid][pGetVENID] = -1; //UNTUK RESET MENDAPATKAN ID VENDING UNTUK EDIT MENU






---------------------[ONPLAYEREDITDYNAMICOBJECT]----------------------------




	if(pData[playerid][EditingVENID] != -1 && Iter_Contains(Vending, pData[playerid][EditingVENID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new venid = pData[playerid][EditingVENID];
	        vmData[venid][venX] = x;
	        vmData[venid][venY] = y;
	        vmData[venid][venZ] = z;
	        vmData[venid][venRX] = rx;
	        vmData[venid][venRY] = ry;
	        vmData[venid][venRZ] = rz;

	        SetDynamicObjectPos(objectid, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]);
	        SetDynamicObjectRot(objectid, vmData[venid][venRX], vmData[venid][venRY], vmData[venid][venRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_X, vmData[venid][venX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_Y, vmData[venid][venY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_Z, vmData[venid][venZ] + 1.5);

		    Vending_Save(venid);
	        pData[playerid][EditingVENID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new venid = pData[playerid][EditingVENID];
	        SetDynamicObjectPos(objectid, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]);
	        SetDynamicObjectRot(objectid, vmData[venid][venRX], vmData[venid][venRY], vmData[venid][venRZ]);
	        pData[playerid][EditingVENID] = -1;
	    }
	}
	return 1;
}












------------------------[CMD BUY MACHINE]-------------------------


	//Buy Vending
	foreach(new venid : Vending)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]))
		{

			if(vmData[venid][venPrice] > pData[playerid][pMoney]) 
				return Error(playerid, "Not enough money, you can't afford this vending.");

			if(strcmp(vmData[venid][venOwner], "-")) 
				return Error(playerid, "Someone already owns this vending.");

			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more vending machine.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more vending machine.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more vending machine.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more vending machine.");
				#endif
			}

			GivePlayerMoneyEx(playerid, -vmData[venid][venPrice]);
			Server_AddMoney(vmData[venid][venPrice]);
			GetPlayerName(playerid, vmData[venid][venOwner], MAX_PLAYER_NAME);
			vmData[venid][venStatus] = 1;
			
			Vending_Save(venid);
			Vending_Refresh(venid);
		}
	}






//----------------------------[ Vending Menu Edit ] --------------------------

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
				case 2:
				{
					if(!Player_OwnsVending(playerid, venid))
						return Error(playerid, "Kamu bukan pemilik vending machine ini.");

					if(pData[playerid][pGetVENID] == -1)
						return Error(playerid, "Kamu harus relog");


					//Vending Deposit Sprunk
					new str[128];
					format(str, sizeof(str), ""WHITE_E"Product Stock: "GREEN_E"%d\n\n"WHITE_E"Silakan masukkan berapa banyak sprunk yang ingin Anda setorkan ke dalam vending:", vmData[venid][venProduct]);
					ShowPlayerDialog(playerid, VENDING_DEPOSITSPRUNK, DIALOG_STYLE_INPUT, "Deposit Sprunk", str, "Deposit", "Back");
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
				if(strval(inputtext) < 1 || strval(inputtext) > 25)
				{
					new str[128];
					format(str,sizeof(str), "Drink Price: %d (batas harga hanya $1 sampai $25)", vmData[venid][venDrinkPrice]);
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
			else callcmd::wsstorage(playerid, "\0");
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
			callcmd::wsstorage(playerid, "\0");
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
		else callcmd::wsstorage(playerid, "\0");
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


*/