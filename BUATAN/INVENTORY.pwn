#define MAX_INVENTORY 20

new PlayerText: BARQUANTITY[MAX_PLAYERS];
new PlayerText: INVINFO[MAX_PLAYERS][11];
new PlayerText: INVNAME[MAX_PLAYERS][6];
new PlayerText:INDEXTD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:GARISBAWAH[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:MODELTD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:NAMETD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:AMMOUNTTD[MAX_PLAYERS][MAX_INVENTORY];

new BukaInven[MAX_PLAYERS];

enum inventoryData
{
	invID,
	invExists,
	invItem[32 char],
	invModel,
	invAmount,
	invTotalQuantity,
	invQuantity
};

new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];

	
enum e_InventoryItems
{
	e_InventoryItem[32], //Nama item
	e_InventoryModel, //Object item
	e_InventoryTotal
};


new const g_aInventoryItems[][e_InventoryItems] =
{
	{"Tas", 3026, 2},
	{"GPS", 18875, 2},
	{"Phone", 18867, 2},
	{"Medkit", 11738, 2},
	{"Portable Radio", 19942, 2},
	{"Mask", 19036, 2},
	{"Snack", 2768, 2},
	{"Water", 2958, 2},
	{"Sprunk", 2958, 2},
	{"Rolling Paper", 19873, 2},
	{"Rolled Weed", 3027, 2},
	{"Weed", 1578, 2},
	{"Component", 19627, 2},
	{"Weed Seed", 1279, 2},
	{"9mm Luger", 19995, 2},
	{"12 Gauge", 19995, 2},
	{"9mm Silenced Schematic", 3111, 2},
	{"Shotgun Schematic", 3111, 2},
	{"9mm Silenced Material", 3052, 2},
	{"Shotgun Material", 3052, 2},
	{"Fuel Can", 1650, 2},
	{"Fish Rod", 18632, 2},
	{"Bait", 19566, 2},
	{"Fried Chicken", 19847, 2},
	{"Pizza Stack", 19580, 2},
	{"Patty Burger", 2703, 2},
	{"Boombox", 2226, 2},
	{"Medicine", 2709, 2},
	{"Cocaine", 1580, 2},
	{"Muriatic", 1580, 2},
	{"Ephedrine", 1580, 2},
	{"Meth", 1580, 2},
	{"Daging", 2805, 2},
	{"Susu", 19570, 2},
	{"Susu Olah", 19570, 2},
	{"Ikan", 19630, 2},
	//Ikan Genzo
	{"Ikan_Tuna", 19630, 2},
	{"Ikan_Tongkol", 19630, 2},
	{"Ikan_Kakap", 19630, 2},
	{"Ikan_Kembung", 19630, 2},
	{"Ikan_Makarel", 19630, 2},
	{"Ikan_Tenggiri", 19630, 2},
	{"Ikan_BlueMarlin", 19630, 2},
	{"Ikan_Sail", 19630, 2},
	{"Daging Sapi Mentah", 2805, 2},
	{"Potongan Daging Sapi", 2805, 2},
	{"Kemasan Daging Sapi", 2805, 2},
	{"Big Burger", 2703, 2},
	{"Steak", 19882, 2},
	{"Milk", 19570, 2},
	{"Roti", 19579, 2},
	{"Bandage", 11736, 2},
	{"Clip Pistol", 19995},
	{"Clip Rifle", 19995},
	{"Bomb", 363, 2},

	{"Uang", 1212, 1},
	{"Hand_Phone", 18867, 3},
	{"Radio", 19942, 3},
	{"Painkiller", 1241, 3},
	{"Joran", 18632, 2},
	{"Jerigen", 1650, 2},
	{"botol", 1486, 2},

	{"Kamera", 367, 1},
	{"Tazer", 346, 1},
	{"Desert_Eagle", 348, 1},
	{"Parang", 339, 1},
	{"Molotov", 344, 1},
	{"Slc_9mm", 346, 1},

	{"Shotgun", 349, 3},
	{"Combat_Shotgun", 351, 3},
	{"MP5", 353, 3},
	{"M4", 356, 3},
	{"Clip", 19995, 3},

	//Penjahit
	{"Bulu", 19274, 3},
	{"Benang", 1901, 3},
	{"Kain", 19873, 3},
	{"Pakaian", 2705, 3},

	//mancing
	{"Penyu", 1609, 3},
	{"Blue_Fish", 1604, 3},
	{"Nemo", 1599, 3},
	{"Ikan_Makarel", 19630, 3},

	//makan dan minum
	{"Water", 2958, 1},
	{"Starling", 1455, 3},
	{"Chiken", 19847, 3},
	{"Roti", 19883, 3},
	{"Kebab", 2769, 3},
	{"Cappucino", 19835, 3},
	{"Snack", 2821, 3},
	{"Milx_Max", 19570, 2},
	{"Potato", 11740, 1},
	{"Mineral", 1484, 1},
	{"Jeruk", 19574, 4},
	{"Burger", 2880, 2}, //19847
	{"Pizza", 2814, 1},
	{"KFC", 19847, 2},
	{"Vodka", 19823, 2},
	{"Ciu", 1486, 2},
	{"Amer", 1517, 2},

	{"Ktp", 1581, 1},

	{"Kanabis", 800, 3},
	{"Marijuana", 1578, 3},
	{"Steak", 19811, 2},
	{"Kopi", 19835, 3},

	//bahan jahit pakaian
	{"Ciki", 19565, 2},
	{"Wool", 2751, 2},
	{"Pakaian", 2399, 2},
	{"Kain", 11747, 2},

	//pertanian
    {"Padi", 806, 3},
    {"Cabai", 870, 3},
    {"Tebu", 651, 3},
    {"Garam Kristal", 19177, 3},
    {"Beras", 19573, 3},
    {"Sambal", 11722, 3},
    {"Gula", 2663, 3},
    {"Garam", 19568, 3},

    {"Karung Goni", 2060, 2},
	{"Botol Bekas", 2683, 2},

	{"Padi_Olahan", 19638, 3},
	{"Tepung", 19570, 3},
	{"Bibit_Padi", 862, 2},
	{"Bibit_Cabai", 862, 2},
	{"Bibit_Jagung", 862, 2},
	{"Bibit_Tebu", 862, 2},
	{"Biji_Kopi", 18225, 1},
	{"Ikan", 19630, 2},
	{"Daging", 2804, 2},
	{"Umpan", 1485, 2},
	{"Pancingan", 18632, 2},
	{"Phone", 18867, 3},
	{"Phone_Book", 18867, 3},
	{"FirstAid", 11738, 2},

	{"Jus", 1546, 1},
	{"Susu", 19570, 2},
	{"Susu_Olahan", 19569, 2},
	{"Minyak", 2969, 3},
	{"Essence", 3015, 1},
	{"Nasgor", 2663, 1},
	{"Jus", 1546, 1},
	{"Sampah", 1265, 1},
	("Batu", 905, 3),
	("Jerigen", 1650, 3),
	("Batu_Cucian", 2936, 2),
	("Emas", 19941, 4),
	("Besi", 1519, 4),
	("Aluminium", 19809, 4),
	("Berlian", 19941, 4),
	("Component", 3096, 4),
	{"material", 1158, 4},

	//AyamGen
	{"Ayam Hidup", 16776, 2},
	{"Ayam Potong", 2804, 2},
	{"Ayam Kemas", 2804, 2},

	{"Ayam", 16776, 2},
	{"Paket_Ayam", 19566, 2},
	{"Ayam_Potong", 2806, 2},
	{"Susu_Mentah", 19570, 1},
	("Perban", 11736, 4),
	("Obat_Stress", 1241, 4),
	("kayu", 1463, 4),
	("papan", 19366, 4),

	("Kayu", 19793, 4),
	("Kayu Potongan", 831, 4),
	("Kayu Kemas", 1463, 4),

	{"box", 1271, 3},
	{"karet", 1316, 3},

	//SENJATA GEN
	{"Golf Club", 333, 24},
	{"Knife", 335, 15},
	{"Shovel", 337, 21},
	{"Katana", 339, 15},

	{"AK-47", 355, 30},
	{"Desert Eagle", 348, 31},
	{"Micro SMG", 352, 33},
	{"MP5", 353, 33},
	{"Colt 45", 346, 31},
	{"Tec-9", 372, 32},
	{"Shotgun", 349, 27},
	{"Rifle", 357, 31},
	{"Sniper", 358, 29},
 
	{"Clip", 19995, 8},

	("BackPack", 2919, 2),
	{"Baking_Soda", 2821, 3},
	{"Asam_Muriatic", 19573, 3},
	{"Uang_Kotor", 1575, 3},
	{"Seed", 859, 2},
	{"Pot", 860, 3},
	{"Ephedrine", 19473, 1},
	{"Meth", 1579, 2},
	{"Vest", 1242, 2},
	{"Kevlar Vest", 19515, 2}
};

stock Inventory_Clear(playerid)
{
	static
	    string[64];

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (InventoryData[playerid][i][invExists])
	    {
	        InventoryData[playerid][i][invExists] = 0;
	        InventoryData[playerid][i][invModel] = 0;
			InventoryData[playerid][i][invAmount] = 0;
		}
	}
	return 1;
}

stock Inventory_GetItemID(playerid, item[])
{
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        continue;

		if (!strcmp(InventoryData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

stock Inventory_GetFreeID(playerid)
{
	if (Inventory_Items(playerid) >= 20)
		return -1;

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        return i;
	}
	return -1;
}

stock Inventory_Items(playerid)
{
    new count;

    for(new i = 0; i < MAX_INVENTORY; i++) if (InventoryData[playerid][i][invExists]) {
        count++;
	}
	return count;
}

stock Inventory_Count(playerid, item[])
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	    return InventoryData[playerid][itemid][invAmount];

	return 0;
}

stock PlayerHasItem(playerid, item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

stock Inventory_Set(playerid, item[], model, amount, totalquantity)
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1 && amount > 0)
		Inventory_Addset(playerid, item, model, amount, totalquantity);

	else if (amount > 0 && itemid != -1)
	    Inventory_SetQuantity(playerid, item, amount, totalquantity);

	else if (amount < 1 && itemid != -1)
	    Inventory_Remove(playerid, item, -1);

	return 1;
}

stock Inventory_SetQuantity(playerid, item[], quantity, totalquantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	{
	    InventoryData[playerid][itemid][invAmount] = quantity;
	    InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
	}
	return 1;
}

stock Inventory_Remove(playerid, item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	{
	    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
		    new totalquantity = g_aInventoryItems[i][e_InventoryTotal];
		    if (InventoryData[playerid][itemid][invAmount] > 0 && InventoryData[playerid][itemid][invTotalQuantity] > 0)
		    {
		        InventoryData[playerid][itemid][invAmount] -= quantity;
		        InventoryData[playerid][itemid][invTotalQuantity] -= totalquantity;
			}
			if (quantity == -1 || InventoryData[playerid][itemid][invTotalQuantity] < 1 || totalquantity == -1 || InventoryData[playerid][itemid][invAmount] < 1)
			{
			    InventoryData[playerid][itemid][invExists] = false;
			    InventoryData[playerid][itemid][invModel] = 0;
			    InventoryData[playerid][itemid][invAmount] = 0;
			    InventoryData[playerid][itemid][invTotalQuantity] = 0;
			}
			else if (quantity != -1 && InventoryData[playerid][itemid][invAmount] > 0 && totalquantity != -1 && InventoryData[playerid][itemid][invTotalQuantity] > 0)
			{
			    InventoryData[playerid][itemid][invAmount] = quantity;
			    InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
			}
		}
		return 1;
	}
	return 0;
}

stock Inventory_Addset(playerid, item[], model, amount = 1, totalquantity)
{
	new itemid = Inventory_GetItemID(playerid, item);
	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);
	    if (itemid != -1)
	    {
	   		InventoryData[playerid][itemid][invExists] = true;
		    InventoryData[playerid][itemid][invModel] = model;
			InventoryData[playerid][itemid][invAmount] = amount;
			InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;

		    strpack(InventoryData[playerid][itemid][invItem], item, 32 char);
		    return itemid;
		}
		return -1;
	}
	else
	{
		InventoryData[playerid][itemid][invAmount] += amount;
		InventoryData[playerid][itemid][invTotalQuantity] += totalquantity;
	}
	return itemid;
}

stock Inventory_Add(playerid, item[], model, quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);

	    if (itemid != -1)
	    {
         	for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
			{
			    new totalquantity = g_aInventoryItems[i][e_InventoryTotal];
     	 	  	InventoryData[playerid][itemid][invExists] = true;
		        InventoryData[playerid][itemid][invModel] = model;
				InventoryData[playerid][itemid][invAmount] = model;
				InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
		        return itemid;
			}
		}
		return -1;
	}
	return itemid;
}

stock Inventory_Close(playerid)
{
	if(BukaInven[playerid] == 0)
		return ErrorMsg(playerid, "Kamu Belum Membuka Inventory.");
	//ErrorMsg(playerid, "Kamu Belum Membuka Inventory.");

	CancelSelectTextDraw(playerid);
	pData[playerid][pSelectItem] = -1;
	pData[playerid][pGiveAmount] = 0;
	BukaInven[playerid] = 0;
	for(new a = 0; a < 6; a++)
	{
		PlayerTextDrawHide(playerid, INVNAME[playerid][a]);
	}
	PlayerTextDrawHide(playerid, BARQUANTITY[playerid]);
	for(new a = 0; a < 11; a++)
	{
		PlayerTextDrawHide(playerid, INVINFO[playerid][a]);
	}
	PlayerTextDrawSetString(playerid, INVINFO[playerid][6], "Jumlah");
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
		PlayerTextDrawHide(playerid, NAMETD[playerid][i]);
		PlayerTextDrawHide(playerid, INDEXTD[playerid][i]);
		PlayerTextDrawColor(playerid, INDEXTD[playerid][i], 80);
		PlayerTextDrawHide(playerid, MODELTD[playerid][i]);
		PlayerTextDrawHide(playerid, AMMOUNTTD[playerid][i]);
		PlayerTextDrawHide(playerid, GARISBAWAH[playerid][i]);
	}
	return 1;
}

stock Inventory_Show(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	new str[256], string[256], totalall, quantitybar;
	format(str,1000,"%s", GetName(playerid));
	PlayerTextDrawSetString(playerid, INVNAME[playerid][2], str);
	BarangMasuk(playerid);
	BukaInven[playerid] = 1;
	PlayerPlaySound(playerid, 1039, 0,0,0);
	SelectTextDraw(playerid, COLOR_LBLUE);
	for(new b = 0; b < 6; b++)
	{
		PlayerTextDrawShow(playerid, INVNAME[playerid][b]);
	}
	PlayerTextDrawShow(playerid, BARQUANTITY[playerid]);
	for(new a = 0; a < 11; a++)
	{
		PlayerTextDrawShow(playerid, INVINFO[playerid][a]);
	}
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    PlayerTextDrawShow(playerid, INDEXTD[playerid][i]);
		PlayerTextDrawShow(playerid, AMMOUNTTD[playerid][i]);
		totalall += InventoryData[playerid][i][invTotalQuantity];
		format(str, sizeof(str), "%.1f/850.0", float(totalall));
		PlayerTextDrawSetString(playerid, INVNAME[playerid][3], str);
		quantitybar = totalall * 199/850;
	  	PlayerTextDrawTextSize(playerid, BARQUANTITY[playerid], quantitybar, 3.0);
	  	PlayerTextDrawShow(playerid, BARQUANTITY[playerid]);
		if(InventoryData[playerid][i][invExists])
		{
			PlayerTextDrawShow(playerid, NAMETD[playerid][i]);
			PlayerTextDrawShow(playerid, GARISBAWAH[playerid][i]);
			PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][i], InventoryData[playerid][i][invModel]);
			//sesuakian dengan object item kalian
			if(InventoryData[playerid][i][invModel] == 18867)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], -254.000000, 0.000000, 0.000000, 2.779998);
			}
			else if(InventoryData[playerid][i][invModel] == 16776)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], 0.000000, 0.000000, -85.000000, 1.000000);
			}
			else if(InventoryData[playerid][i][invModel] == 1581)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], 0.000000, 0.000000, -180.000000, 1.000000);
			}
			PlayerTextDrawShow(playerid, MODELTD[playerid][i]);
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			PlayerTextDrawSetString(playerid, NAMETD[playerid][i], str);
			format(str, sizeof(str), "%dx", InventoryData[playerid][i][invAmount]);
			PlayerTextDrawSetString(playerid, AMMOUNTTD[playerid][i], str);
		}
		else
		{
			PlayerTextDrawHide(playerid, AMMOUNTTD[playerid][i]);
		}
	}
	return 1;
}

forward OnPlayerUseItem(playerid, itemid, name[]);
public OnPlayerUseItem(playerid, itemid, name[])
{
	if(!strcmp(name, "Snack"))
	{
		pData[playerid][pSnack]--;
		pData[playerid][sampahsaya]++;
	    pData[playerid][pHunger] += 40;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Snack", "Removed_1x", 2821, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil snack di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "BackPack"))
	{
	    ShowProgressbar(playerid, "Membuka Tas..", 5);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0, 1);

		pData[playerid][pStarterPack] -= 1;

		pData[playerid][pSnack] += 10;
		pData[playerid][pSprunk] += 10;
		GivePlayerMoneyEx(playerid, 1000);
		ShowItemBox(playerid, "Snack", "Received_10x", 2821, 4);
		ShowItemBox(playerid, "Water", "Received_10x", 2958, 4);
		ShowItemBox(playerid, "Uang", "Received_$1000", 1212, 4);
		ShowNotifSukses(playerid, "Anda Diberi Kompensasi 10 Snack, 10 Water, $1000", 5000);

		ShowItemBox(playerid, "BackPack", "Used_1x", InventoryData[playerid][itemid][invModel], 2);
		new string[128];
		format(string, sizeof(string), "> %s Membuka BackPack.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Ktp"))
	{
	    callcmd::ktpshow(playerid, "");
	}
	else if(!strcmp(name, "Water"))
	{
		pData[playerid][pSprunk]--;
		pData[playerid][pEnergy] += 40;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
		ApplyAnimation(playerid, "VENDING", "VEND_DRINK2_P", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Water", "Removed_1x", 2958, 2);
		pData[playerid][sampahsaya]++;
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil Sprunk di tas dan meminumnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Fried Chicken"))
	{
		pData[playerid][pChicken]--;
	    pData[playerid][pHunger] += 12;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Fried Chicken", "Removed_1x", 19847, 2);
		pData[playerid][sampahsaya]++;
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil makanan di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Pizza Stack"))
	{
		pData[playerid][pPizzaP]--;
	    pData[playerid][pHunger] += 12;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Pizza Stack", "Removed_1x", 19580, 2);
		pData[playerid][sampahsaya]++;
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil makanan di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Patty Burger"))
	{
		pData[playerid][pBurgerP]--;
	    pData[playerid][pHunger] += 12;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Patty Burger", "Removed_1x", 2703, 2);
		pData[playerid][sampahsaya]++;
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil makanan di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Milk"))
	{
		pData[playerid][pMilks]--;
		pData[playerid][pEnergy] += 12;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
		ApplyAnimation(playerid, "VENDING", "VEND_DRINK2_P", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Milk", "Removed_1x", 19570, 2);
		pData[playerid][sampahsaya]++;
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil minuman di tas dan meminumnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Steak"))
	{
		pData[playerid][pSteak]--;
	    pData[playerid][pHunger] += 12;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Steak", "Removed_1x", 19882, 2);
		pData[playerid][sampahsaya]++;
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil makanan di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Roti"))
	{
		pData[playerid][pRoti]--;
	    pData[playerid][pHunger] += 12;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Roti", "Removed_1x", 19883, 2);
		pData[playerid][sampahsaya]++;
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil makanan di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Ciu"))
	{
		pData[playerid][pCiu]--;
		Inventory_Update(playerid);
        Inventory_Close(playerid);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
		//ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Ciu", "Removed_1x", 1486, 2);
		//pData[playerid][sampahsaya]++;
		//ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
        //SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil makanan di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Cappucino"))
	{
	    callcmd::drinkcappucino(playerid, "");
	}
	else if(!strcmp(name, "Starling"))
	{
	    callcmd::drinkstarling(playerid, "");
	}
	else if(!strcmp(name, "Milx_Max"))
	{
	    callcmd::drinkmilk(playerid, "");
	}
	else if(!strcmp(name, "Uang"))
	{
	    ShowNotifError(playerid, "Item Ini Tidak Dapat Digunakan", 5000);
	}
	else if(!strcmp(name, "Fuel Can"))
	{
		if(IsPlayerInAnyVehicle(playerid))
			return Error(playerid, "Anda harus berada diluar kendaraan!");

		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
		if(IsValidVehicle(vehicleid))
		{
			new fuel = GetVehicleFuel(vehicleid);
			
			if(GetEngineStatus(vehicleid))
				return Error(playerid, "Turn off vehicle engine.");
			
			if(fuel >= 100)
				return Error(playerid, "This vehicle gas is full.");
			
			if(!IsEngineVehicle(vehicleid))
				return Error(playerid, "This vehicle can't be refull.");

			if(!GetHoodStatus(vehicleid))
				return Error(playerid, "The hood must be opened before refull the vehicle.");

			pData[playerid][pGas]--;
			Inventory_Update(playerid);
        	Inventory_Close(playerid);
			Info(playerid, "Don't move from your position or you will failed to refulling this vehicle.");
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			pData[playerid][pActivity] = SetTimerEx("RefullCar", 1000, true, "id", playerid, vehicleid);
			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Refulling...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s menggisi bensin kendaraan dengan menggunakan kedua tangan.", ReturnName(playerid));
		}
	}
	else if(!strcmp(name, "Clip Pistol"))
	{
		if(GetPlayerWeapon(playerid) == 0)
		return Error(playerid, "Kamu harus memegang senjata api");

		new weaponid = GetPlayerWeapon(playerid), ammo = GetPlayerAmmo(playerid);

		if(weaponid < 22 || weaponid > 32)
			return Error(playerid, "this weapon does not support to use clip");

		if(weaponid >= 22 && weaponid <= 24) //PISTOL
		{
			if(weaponid == 22 || weaponid == 23)
			{
				GivePlayerWeaponEx(playerid, weaponid, ammo+50);
			}
			else
			{
				GivePlayerWeaponEx(playerid, weaponid, ammo+34);
			}
			pData[playerid][pAmmoPistol] -= 1;
			PlayerPlaySound(playerid, 36401, 0,0,0);
			ShowItemBox(playerid, "Clip Pistol", "Removed_1x", 19995, 2);
			Inventory_Update(playerid);
       	 	Inventory_Close(playerid);
			Info(playerid, "Succes reloaded ammo weapon %s with Pistol Clip", ReturnWeaponName(weaponid));
			ApplyAnimation(playerid, "PYTHON", "python_reload", 4.1, 0, 0, 0, 0, 0);
		}
	}
	else if(!strcmp(name, "Clip Rifle"))
	{
		if(GetPlayerWeapon(playerid) == 0)
		return Error(playerid, "Kamu harus memegang senjata api");

		new weaponid = GetPlayerWeapon(playerid), ammo = GetPlayerAmmo(playerid);

		if(weaponid < 28 || weaponid > 32)
			return Error(playerid, "this weapon does not support to use clip");

		if(weaponid >= 28 && weaponid <= 32) //Rifle
		{
			pData[playerid][pAmmoRifle] -= 1;
			PlayerPlaySound(playerid, 36401, 0,0,0);
			GivePlayerWeaponEx(playerid, weaponid, ammo+200);
			ShowItemBox(playerid, "Clip Rifle", "Removed_1x", 19995, 2);
			Inventory_Update(playerid);
       	 	Inventory_Close(playerid);
			Info(playerid, "Succes reloaded ammo weapon %s with Rifle Clip", ReturnWeaponName(weaponid));
			ApplyAnimation(playerid, "RIFLE", "RIFLE_load", 4.1, 0, 0, 0, 0, 0);
		}
	}
	else if(!strcmp(name, "Knife"))
	{
		new ammo = GetPlayerAmmo(playerid);

		pData[playerid][pKnife] -= 1;
		//GiveWeaponToPlayer(playerid, 4, 1);
		GivePlayerWeaponEx(playerid, 4, ammo+1);
		ShowItemBox(playerid, "Knife", "Removed_1x", 335, 2);
		Inventory_Update(playerid);
   	 	Inventory_Close(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Pisau dan memegangnya.");
	}
	else if(!strcmp(name, "Katana"))
	{
		new ammo = GetPlayerAmmo(playerid);

		pData[playerid][pKatana] -= 1;
		//GiveWeaponToPlayer(playerid, 4, 1);
		GivePlayerWeaponEx(playerid, 8, ammo+1);
		ShowItemBox(playerid, "Katana", "Removed_1x", 339, 2);
		Inventory_Update(playerid);
   	 	Inventory_Close(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Katana dan memegangnya.");
	}
	else if(!strcmp(name, "Marijuana"))
	{
		new Float:health;
		GetPlayerHealth(playerid, health);
		if(health+25 > 95)
		{
			Error(playerid, "Over dosis!");
			TextDrawShowForPlayer(playerid, Text:RedScreen);
			SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			}
			SetPlayerHealthEx(playerid, 95);
			Inventory_Update(playerid);
	       	Inventory_Close(playerid);
	       	pData[playerid][pMarijuana]--;
	       	pData[playerid][pUseDrug]++;
	       	ShowItemBox(playerid, "Marijuana", "Removed_1x", 1578, 2);
			return 1;
		}

		pData[playerid][pUseDrug] = 1;
		pData[playerid][pUseDrug]++;
		SetPlayerHealthEx(playerid, health+25);
		SetPlayerDrunkLevel(playerid, 4000);
		Inventory_Update(playerid);
	    Inventory_Close(playerid);
	    pData[playerid][pMarijuana]--;
		ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g marijuana dan langsung menghisapnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Cocaine"))
	{
		new Float:armor;
		GetPlayerArmour(playerid, armor);
		if(armor+25 > 95)
		{
			Error(playerid, "Over dosis!");
			TextDrawShowForPlayer(playerid, Text:RedScreen);
			SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			}
			SetPlayerArmourEx(playerid, 95);
			pData[playerid][pCocaine]--;
			pData[playerid][pUseDrug]++;
			Inventory_Update(playerid);
	    	Inventory_Close(playerid);
			return 1;
		}

		pData[playerid][pCocaine]--;
		Inventory_Update(playerid);
	    Inventory_Close(playerid);
	    pData[playerid][pUseDrug] = 1;
		pData[playerid][pUseDrug]++;
		SetPlayerArmourEx(playerid, armor+20);
		SetPlayerDrunkLevel(playerid, 4000);
		ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g cocaine dan langsung menghisapnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Meth"))
	{
		new Float:armor, Float:health;
		GetPlayerArmour(playerid, armor);
		GetPlayerHealth(playerid, health);
		if(armor+25 > 95)
		{
			Error(playerid, "Over dosis!");
			TextDrawShowForPlayer(playerid, Text:RedScreen);
			SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			}
			SetPlayerArmourEx(playerid, 95);
		}
		else if(health+25 > 95)
		{
			Error(playerid, "Over dosis!");
			TextDrawShowForPlayer(playerid, Text:RedScreen);
			SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			}
			SetPlayerHealthEx(playerid, 95);
			pData[playerid][pUseDrug]++;
			pData[playerid][pMeth]--;
			Inventory_Update(playerid);
	    	Inventory_Close(playerid);
			return 1;
		}

		pData[playerid][pMeth]--;
		Inventory_Update(playerid);
	    Inventory_Close(playerid);
	    pData[playerid][pUseDrug] = 1;
		pData[playerid][pUseDrug]++;
		SetPlayerArmourEx(playerid, armor+20);
		SetPlayerHealthEx(playerid, health+20);
		SetPlayerDrunkLevel(playerid, 4000);
		ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g meth dan langsung menghisapnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Medicine"))
	{
		pData[playerid][pSick] = 0;
		pData[playerid][pSickTime] = 0;
		pData[playerid][pBladder] = 5;
		pData[playerid][pMedicine]--;
		ShowItemBox(playerid, "Medicine", "Removed_1x", 2709, 2);
		SetPlayerDrunkLevel(playerid, 0);
		Inventory_Update(playerid);
	    Inventory_Close(playerid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil medicine dan langsung menggunakannya", ReturnName(playerid));

		ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
	}
	else if(!strcmp(name, "Medkit"))
	{
		new Float:darahh;

		if (ReturnHealth(playerid) > 99)
		    return ErrorMsg(playerid, "Anda tidak perlu menggunakan medkit sekarang.");

	    GetPlayerHealth(playerid, darahh);
	    SetPlayerHealthEx(playerid, darahh+90);
	    ShowItemBox(playerid, "Medkit", "Removed_1x", 11738, 2);
	    pData[playerid][pMedkit]--;
	    Inventory_Update(playerid);
	    Inventory_Close(playerid);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil medkit dan menggunakannya.", ReturnName(playerid));
	}
	else if(!strcmp(name, "Bandage"))
	{
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s membalut luka menggunakan perban", ReturnName(playerid));
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerAttachedObject(playerid, 9, 11738, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
		pData[playerid][pBandage]--;
		ShowItemBox(playerid, "Bandage", "Removed_1x", 11736, 2);
	    Inventory_Update(playerid);
	    Inventory_Close(playerid);

		pData[playerid][pTimebandage] = SetTimerEx("pakebandage", 1000, true, "i", playerid);
		//Showbar(playerid, 5, "USE BANDAGE", "pakebandage");
		ShowProgressbar(playerid, "USE BANDAGE", 5);
	}
	else if(!strcmp(name, "Obat_Stress"))
	{
	    if(pData[playerid][pBladder] < 50) return ErrorMsg(playerid, "Anda sedang tidak stress");
		pData[playerid][pObatStress] -= 1;
		ShowProgressbar(playerid, "Menggunakan obat stress..", 5);
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
		pData[playerid][pBladder] -= 15;

		new string[128];
		format(string, sizeof(string), "> %s Menggunakan obat stress.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);

 		ShowItemBox(playerid, "Obat_Stress", "Used_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Vest"))
	{
	    ShowProgressbar(playerid, "Menggunakan vest..", 5);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0, 1);

		pData[playerid][pVest] -= 1;
		pData[playerid][pArmour] = 100.0;

		SetPlayerArmourEx(playerid, pData[playerid][pArmour]);

		new string[128];
		format(string, sizeof(string), "> %s Menggunakan vestnya.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
		
 		ShowItemBox(playerid, "Vest", "Used_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Kevlar Vest"))
	{
	    ShowProgressbar(playerid, "Menggunakan Kevlar Vest..", 5);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0, 1);

		pData[playerid][pKevlar] -= 1;
		pData[playerid][pArmour] = 100.0;

		SetPlayerArmourEx(playerid, pData[playerid][pArmour]);

		new string[128];
		format(string, sizeof(string), "%s Menggunakan Kevlar Vestnya.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
		
 		ShowItemBox(playerid, "Kevlar Vest", "Used_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if (!strcmp(name, "Clip", true)) 
    {
        callcmd::usemag(playerid, "\1");
        SendClientMessageEx(playerid, COLOR_WHITE, "[i] Gunakan otot {FFFF00}Y"WHITE_E" untuk memasangkan clip kedalam senjata.");
	}
    else if (!strcmp(name, "Colt 45", true)) 
    {
        EquipWeapon(playerid, "Colt 45");
    }
    else if (!strcmp(name, "Desert Eagle", true)) 
    {
        EquipWeapon(playerid, "Desert Eagle");
    }
    else if (!strcmp(name, "Shotgun", true)) 
    {
        EquipWeapon(playerid, "Shotgun");
    }
    else if (!strcmp(name, "Micro SMG", true)) 
    {
        EquipWeapon(playerid, "Micro SMG");
    }
    else if (!strcmp(name, "Tec-9", true)) 
    {
        EquipWeapon(playerid, "Tec-9");
    }
    else if (!strcmp(name, "MP5", true)) 
    {
        EquipWeapon(playerid, "MP5");
    }
    else if (!strcmp(name, "AK-47", true)) 
    {
        EquipWeapon(playerid, "AK-47");
    }
    else if (!strcmp(name, "Rifle", true)) 
    {
        EquipWeapon(playerid, "Rifle");
    }
    else if (!strcmp(name, "Sniper", true)) 
    {
        EquipWeapon(playerid, "Sniper");
    }
    else if (!strcmp(name, "Golf Club", true)) 
    {
        EquipWeapon(playerid, "Golf Club");
    }
    //else if (!strcmp(name, "Knife", true)) 
    //{
        //EquipWeapon(playerid, "Knife");
    //}
    else if (!strcmp(name, "Shovel", true)) 
    {
        EquipWeapon(playerid, "Shovel");
    }
    //else if (!strcmp(name, "Katana", true)) 
    //{
        //EquipWeapon(playerid, "Katana");
    //}
	else if(!strcmp(name, "Minyak"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Essence"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Pakaian"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Kain"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Benang"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Bulu"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "botol"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "box"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "karet"))
	{
	    ErrorMsg(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	return 1;
}

function OnPlayerGiveInvItem(playerid, userid, itemid, name[], value)
{
	new str[500], string[500];
	if(Inventory_Count(playerid, string) < pData[playerid][pGiveAmount])
		return ErrorMsg(playerid, "KESALAHAN: Barang Kamu Tidak Mencukupi !");

	if(!strcmp(name, "Uang", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Uang", str, 1212, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Uang", str, 1212, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		
        GivePlayerMoneyEx(playerid, -value);
        GivePlayerMoneyEx(userid, value);
	}
	else if(!strcmp(name, "Obat_Stress", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Obat_Stress", str, 1241, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Obat_Stress", str, 1241, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pObatStress] -= value;
		pData[userid][pObatStress] += value;
	}
	else if(!strcmp(name, "Ktp", true))
	{
		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
	    new strings[256];
		// Set name player
		format(strings, sizeof(strings), "%s", pData[playerid][pName]);
		PlayerTextDrawSetString(userid, KTPValrise[playerid][10], strings);
		// Set birtdate
		format(strings, sizeof(strings), "%s", pData[playerid][pTinggi]);
		PlayerTextDrawSetString(userid, KTPValrise[playerid][19], strings);

		format(strings, sizeof(strings), "%s", pData[playerid][pAge]);
		PlayerTextDrawSetString(userid, KTPValrise[playerid][15], strings);

		format(strings, sizeof(strings), "%s", pData[playerid][pGender]);
		PlayerTextDrawSetString(userid, KTPValrise[playerid][17], strings);

		for(new txd; txd < 28; txd++)
		{
			PlayerTextDrawShow(userid, KTPValrise[playerid][txd]);
		}
		SetTimerEx("ktp",9000, false, "d", userid);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Marijuana", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Marijuana", str, 1578, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Marijuana", str, 1578, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pMarijuana] -= value;
		pData[userid][pMarijuana] += value;
	}
	else if(!strcmp(name, "Water", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Water", str, 2958, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Water", str, 2958, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pSprunk] -= value;
		pData[userid][pSprunk] += value;
	}
	else if(!strcmp(name, "Snack", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Snack", str, 2821, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Snack", str, 2821, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pSnack] -= value;
		pData[userid][pSnack] += value;
	}
	else if(!strcmp(name, "Roti", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Roti", str, 19883, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Roti", str, 19883, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pRoti] -= value;
		pData[userid][pRoti] += value;
	}
	else if(!strcmp(name, "Vest", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Vest", str, 1242, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Vest", str, 1242, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pVest] -= value;
		pData[userid][pVest] += value;
	}
	else if(!strcmp(name, "Kevlar Vest", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kevlar Vest", str, 19515, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Kevlar Vest", str, 19515, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pKevlar] -= value;
		pData[userid][pKevlar] += value;
	}
	else if(!strcmp(name, "Essence", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Essence", str, 3015, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Essence", str, 3015, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pEssence] -= value;
		pData[userid][pEssence] += value;
	}
	else if(!strcmp(name, "Minyak", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Minyak", str, 2969, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Minyak", str, 2969, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pMinyak] -= value;
		pData[userid][pMinyak] += value;
	}
	else if(!strcmp(name, "Vodka", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Vodka", str, 19823, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Vodka", str, 19823, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pVodka] -= value;
		pData[userid][pVodka] += value;
	}
	else if(!strcmp(name, "Ciu", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Ciu", str, 1486, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Ciu", str, 1486, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pCiu] -= value;
		pData[userid][pCiu] += value;
	}
	else if(!strcmp(name, "Amer", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Amer", str, 1517, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Amer", str, 1517, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pAmer] -= value;
		pData[userid][pAmer] += value;
	}
	else if(!strcmp(name, "Besi", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Besi", str, 1510, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Besi", str, 1510, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pBesi] -= value;
		pData[userid][pBesi] += value;
	}
	else if(!strcmp(name, "Material", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Material", str, 11708, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Material", str, 11708, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pMaterial] -= value;
		pData[userid][pMaterial] += value;
	}
	else if(!strcmp(name, "Component", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Component", str, 3096, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Component", str, 3096, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pComponent] -= value;
		pData[userid][pComponent] += value;
	}
	else if(!strcmp(name, "Aluminium", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Aluminium", str, 19809, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Aluminium", str, 19809, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pAluminium] -= value;
		pData[userid][pAluminium] += value;
	}
	else if(!strcmp(name, "Berlian", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Berlian", str, 19941, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Berlian", str, 19941, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pBerlian] -= value;
		pData[userid][pBerlian] += value;
	}
	else if(!strcmp(name, "Emas", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Emas", str, 19941, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Emas", str, 19941, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pEmas] -= value;
		pData[userid][pEmas] += value;
	}
	else if(!strcmp(name, "Pakaian", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Pakaian", str, 11741, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Pakaian", str, 11741, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pPakaian] -= value;
		pData[userid][pPakaian] += value;
	}
	else if(!strcmp(name, "Kain", true))
	{
		//Inventory_Set(playerid, "Kain", 19873,
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kain", str, 19873, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Kain", str, 19873, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pKain] -= value;
		pData[userid][pKain] += value;
	}
	else if(!strcmp(name, "Kanabis", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kanabis", str, 800, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Kanabis", str, 800, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pKanabis] -= value;
		pData[userid][pKanabis] += value;
	}	
	return Inventory_Close(playerid);
}

forward OnPlayerDropItem(playerid, itemid, name[]);
public OnPlayerDropItem(playerid, itemid, name[])
{
	if(!strcmp(name, "Marijuana"))
	{
	    pData[playerid][pMarijuana] -= 1;
		//ShowProgressbar(playerid, "Membuang marijuana..");
		ShowProgressbar(playerid, "Membuang marijuana..", 3);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		new string[128];
		format(string, sizeof(string), "> %s Telah membuang marijuana.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
 		ShowItemBox(playerid, "Marijuana", "Removed_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Uang"))
	{
		ErrorMsg(playerid, "Item Ini Tidak Dapat Dibuang");
	}
	else if(!strcmp(name, "Obat_Stress"))
	{
		pData[playerid][pObatStress] -= 1;
		ShowProgressbar(playerid, "Membuang obat stress..", 3);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		new string[128];
		format(string, sizeof(string), "> %s Telah membuang obat stress.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
 		ShowItemBox(playerid, "Obat_Stress", "Removed_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Vest"))
	{
	    pData[playerid][pVest] -= 1;
		ShowProgressbar(playerid, "Membuang vest..", 3);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		new string[128];
		format(string, sizeof(string), "> %s Telah membuang vest.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
 		ShowItemBox(playerid, "Vest", "Removed_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Kevlar Vest"))
	{
	    pData[playerid][pKevlar] -= 1;
		ShowProgressbar(playerid, "Membuang Kevlar vest..", 3);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		new string[128];
		format(string, sizeof(string), "> %s Telah membuang Kevlar vest.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
 		ShowItemBox(playerid, "Kevlar Vest", "Removed_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	return 1;
}

stock BarangMasuk(playerid)
{
	Inventory_Set(playerid, "Uang", 1212, pData[playerid][pMoney], 2);
	Inventory_Set(playerid, "BackPack", 2919, pData[playerid][pStarterPack], pData[playerid][pStarterPack]);
	Inventory_Set(playerid, "Ktp", 1581, pData[playerid][pIDCard], pData[playerid][pIDCard]);

	//Makan dan Minum
	Inventory_Set(playerid, "Water", 2958, pData[playerid][pSprunk], pData[playerid][pSprunk]);
	Inventory_Set(playerid, "Snack", 2821, pData[playerid][pSnack], pData[playerid][pSnack]);
	Inventory_Set(playerid, "Fried Chicken", 19847, pData[playerid][pChicken], pData[playerid][pChicken]);
	Inventory_Set(playerid, "Pizza Stack", 19580, pData[playerid][pPizzaP], pData[playerid][pPizzaP]);
	Inventory_Set(playerid, "Patty Burger", 2703, pData[playerid][pBurgerP], pData[playerid][pBurgerP]);
	Inventory_Set(playerid, "Starling", 1455, pData[playerid][pStarling], pData[playerid][pStarling]);
	Inventory_Set(playerid, "Cappucino", 19835, pData[playerid][pCappucino], pData[playerid][pCappucino]);
	Inventory_Set(playerid, "Milx_Max", 19570, pData[playerid][pMilxMax], pData[playerid][pMilxMax]);
	Inventory_Set(playerid, "Vodka", 19823, pData[playerid][pVodka], pData[playerid][pVodka]);
	Inventory_Set(playerid, "Ciu", 1486, pData[playerid][pCiu], pData[playerid][pCiu]);
	Inventory_Set(playerid, "Amer", 1517, pData[playerid][pAmer], pData[playerid][pAmer]);

	//Pedagang
	Inventory_Set(playerid, "Gandum", 855, pData[playerid][pWheat], pData[playerid][pWheat]);
	Inventory_Set(playerid, "Daging", 2804, pData[playerid][pDaging], pData[playerid][pDaging]);
	Inventory_Set(playerid, "Susu", 19570, pData[playerid][pSusu], pData[playerid][pSusu]);
	Inventory_Set(playerid, "Susu_Olahan", 19569, pData[playerid][pSusuolah], pData[playerid][pSusuolah]);//
	Inventory_Set(playerid, "Burger", 2880, pData[playerid][pBurger], pData[playerid][pBurger]);
	Inventory_Set(playerid, "Roti", 19883, pData[playerid][pRoti], pData[playerid][pRoti]);
	Inventory_Set(playerid, "Steak", 19882, pData[playerid][pSteak], pData[playerid][pSteak]);
	Inventory_Set(playerid, "Milk", 19570, pData[playerid][pMilks], pData[playerid][pMilks]);

	//JOB TUKANG AYAM
	Inventory_Set(playerid, "Ayam Hidup", 16776, pData[playerid][AyamHidup], pData[playerid][AyamHidup]);
	Inventory_Set(playerid, "Ayam Potong", 2804, pData[playerid][AyamPotong], pData[playerid][AyamPotong]);
	Inventory_Set(playerid, "Ayam Kemas", 2768, pData[playerid][AyamFillet], pData[playerid][AyamFillet]);

	//JOB DAUR ULANG
	Inventory_Set(playerid, "box", 1271, pData[playerid][pBox], pData[playerid][pBox]);
	Inventory_Set(playerid, "karet", 1316, pData[playerid][pKaret], pData[playerid][pKaret]);
	Inventory_Set(playerid, "botol", 1486, pData[playerid][pBotol], pData[playerid][pBotol]);
	
	//JOB TUKANG KAYU
	Inventory_Set(playerid, "Kayu", 19793, pData[playerid][pKayu], pData[playerid][pKayu]);
	Inventory_Set(playerid, "Kayu Potongan", 831, pData[playerid][pKayuPotong], pData[playerid][pKayuPotong]);
	Inventory_Set(playerid, "Kayu Kemas", 1463, pData[playerid][pKayuKemas], pData[playerid][pKayuKemas]);

	//JOB PETANI GEN
	Inventory_Set(playerid, "Padi", 806, pData[playerid][pPadi], pData[playerid][pPadi]);
	Inventory_Set(playerid, "Cabai", 870, pData[playerid][pCabai], pData[playerid][pCabai]);
	Inventory_Set(playerid, "Tebu", 651, pData[playerid][pTebu], pData[playerid][pTebu]);
	Inventory_Set(playerid, "Garam Kristal", 19177, pData[playerid][pGaramKristal], pData[playerid][pGaramKristal]);//
	Inventory_Set(playerid, "Beras", 19573, pData[playerid][pBeras], pData[playerid][pBeras]);
	Inventory_Set(playerid, "Sambal", 11722, pData[playerid][pSambal], pData[playerid][pSambal]);
	Inventory_Set(playerid, "Gula", 2663, pData[playerid][pGula], pData[playerid][pGula]);
	Inventory_Set(playerid, "Garam", 19568, pData[playerid][pGaram], pData[playerid][pGaram]);
	Inventory_Set(playerid, "Botol Bekas", 2683, pData[playerid][pBotolBekas], pData[playerid][pBotolBekas]);
	Inventory_Set(playerid, "Karung Goni", 2060, pData[playerid][pKarungGoni], pData[playerid][pKarungGoni]);

	//JOB PENJAHIT
	Inventory_Set(playerid, "Bulu", 19274, pData[playerid][pBulu], pData[playerid][pBulu]);
	Inventory_Set(playerid, "Benang", 1901, pData[playerid][pBenang], pData[playerid][pBenang]);
	Inventory_Set(playerid, "Kain", 19873, pData[playerid][pKain], pData[playerid][pKain]);
	Inventory_Set(playerid, "Pakaian", 2705, pData[playerid][pPakaian], pData[playerid][pPakaian]);

	//FISH
	Inventory_Set(playerid, "Ikan_Tuna", 19630, pData[playerid][pItuna], pData[playerid][pItuna]);
	Inventory_Set(playerid, "Ikan_Tongkol", 19630, pData[playerid][pItongkol], pData[playerid][pItongkol]);
	Inventory_Set(playerid, "Ikan_Kakap", 19630, pData[playerid][pIkakap], pData[playerid][pIkakap]);
	Inventory_Set(playerid, "Ikan_Kembung", 19630, pData[playerid][pIkembung], pData[playerid][pIkembung]);
	Inventory_Set(playerid, "Ikan_Makarel", 19630, pData[playerid][pImkarel], pData[playerid][pImkarel]);
	Inventory_Set(playerid, "Ikan_Tenggiri", 19630, pData[playerid][pItenggiri], pData[playerid][pItenggiri]);
	Inventory_Set(playerid, "Ikan_BlueMarlin", 19630, pData[playerid][pIBmarlin], pData[playerid][pIBmarlin]);
	Inventory_Set(playerid, "Ikan_Sail", 19630, pData[playerid][pIsailF], pData[playerid][pIsailF]);

	//JOB BUTCHER
	Inventory_Set(playerid, "Daging_Sapi_Mentah", 2805, pData[playerid][pDagingMentah], pData[playerid][pDagingMentah]);
	Inventory_Set(playerid, "Potongan_Daging_Sapi", 2805, pData[playerid][pDagingPotong], pData[playerid][pDagingPotong]);
	Inventory_Set(playerid, "Kemasan_Daging_Sapi", 2805, pData[playerid][pDagingKemas], pData[playerid][pDagingKemas]);

	//JOB PENAMBANG
	Inventory_Set(playerid, "Batu", 905, pData[playerid][pBatu], pData[playerid][pBatu]);
	Inventory_Set(playerid, "Batu_Cucian", 2936, pData[playerid][pBatuCucian], pData[playerid][pBatuCucian]);
	Inventory_Set(playerid, "Besi", 1510, pData[playerid][pBesi], pData[playerid][pBesi]);
	Inventory_Set(playerid, "Emas", 19941, pData[playerid][pEmas], pData[playerid][pEmas]);
	Inventory_Set(playerid, "Aluminium", 19809, pData[playerid][pAluminium], pData[playerid][pAluminium]);
	Inventory_Set(playerid, "Berlian", 19941, pData[playerid][pBerlian], pData[playerid][pBerlian]);

	//JOB PENAMBANG MINYAK
	Inventory_Set(playerid, "Minyak", 2969, pData[playerid][pMinyak], pData[playerid][pMinyak]);
	Inventory_Set(playerid, "Essence", 3015, pData[playerid][pEssence], pData[playerid][pEssence]);

	//Medis
	Inventory_Set(playerid, "Medicine", 2709, pData[playerid][pMedicine], pData[playerid][pMedicine]);
	Inventory_Set(playerid, "Medkit", 11738, pData[playerid][pMedkit], pData[playerid][pMedkit]);
	Inventory_Set(playerid, "Bandage", 11736, pData[playerid][pBandage], pData[playerid][pBandage]);
	Inventory_Set(playerid, "Obat_Stress", 1241, pData[playerid][pObatStress], pData[playerid][pObatStress]);

	//GUN RELOAD
	Inventory_Set(playerid, "Golf Club", 333, pData[playerid][pGolfClub], pData[playerid][pGolfClub]);
	Inventory_Set(playerid, "Knife", 335, pData[playerid][pKnife], pData[playerid][pKnife]);
	Inventory_Set(playerid, "Shovel", 337, pData[playerid][pShovel], pData[playerid][pShovel]);
	Inventory_Set(playerid, "Katana", 339, pData[playerid][pKatana], pData[playerid][pKatana]);
	Inventory_Set(playerid, "Colt 45", 346, pData[playerid][pColt45], pData[playerid][pColt45]);
	Inventory_Set(playerid, "Desert Eagle", 348, pData[playerid][pDesertEagle], pData[playerid][pDesertEagle]);
	Inventory_Set(playerid, "Micro SMG", 352, pData[playerid][pMicroSMG], pData[playerid][pMicroSMG]);
	Inventory_Set(playerid, "Tec-9", 372, pData[playerid][pTec9], pData[playerid][pTec9]);
	Inventory_Set(playerid, "MP5", 353, pData[playerid][pMP5], pData[playerid][pMP5]);
	Inventory_Set(playerid, "Shotgun", 349, pData[playerid][pShotgun], pData[playerid][pShotgun]);
	Inventory_Set(playerid, "AK-47", 355, pData[playerid][pAK47], pData[playerid][pAK47]);
	Inventory_Set(playerid, "Rifle", 357, pData[playerid][pRifle], pData[playerid][pRifle]);
	Inventory_Set(playerid, "Sniper", 358, pData[playerid][pSniper], pData[playerid][pSniper]);
	Inventory_Set(playerid, "Clip", 19995, pData[playerid][pClip], pData[playerid][pClip]);

	//Barang barang
	Inventory_Set(playerid, "Meth", 1580, pData[playerid][pMeth], pData[playerid][pMeth]);
	Inventory_Set(playerid, "Cocaine", 1580, pData[playerid][pCocaine], pData[playerid][pCocaine]);
	Inventory_Set(playerid, "Ephedrine", 1580, pData[playerid][pEphedrine], pData[playerid][pEphedrine]);
	Inventory_Set(playerid, "Marijuana", 1578, pData[playerid][pMarijuana], pData[playerid][pMarijuana]);
	Inventory_Set(playerid, "Kanabis", 800, pData[playerid][pKanabis], pData[playerid][pKanabis]);
	Inventory_Set(playerid, "Muriatic", 1580, pData[playerid][pMuriatic], pData[playerid][pMuriatic]);
	Inventory_Set(playerid, "Boombox", 2226, pData[playerid][pBoombox], pData[playerid][pBoombox]);
	Inventory_Set(playerid, "Fuel Can", 1650, pData[playerid][pGas], pData[playerid][pGas]);
	Inventory_Set(playerid, "Clip Pistol", 19995, pData[playerid][pAmmoPistol], pData[playerid][pAmmoPistol]);
	Inventory_Set(playerid, "Clip Rifle", 19995, pData[playerid][pAmmoRifle], pData[playerid][pAmmoRifle]);//Clip Rifle
	Inventory_Set(playerid, "material", 1158, pData[playerid][pMaterial], pData[playerid][pMaterial]);
	Inventory_Set(playerid, "component", 1104, pData[playerid][pComponent], pData[playerid][pComponent]);
	Inventory_Set(playerid, "Sampah", 1265, pData[playerid][sampahsaya], pData[playerid][sampahsaya]);
	Inventory_Set(playerid, "Vest", 1242, pData[playerid][pVest], pData[playerid][pVest]);
	Inventory_Set(playerid, "Kevlar Vest", 19515, pData[playerid][pKevlar], pData[playerid][pKevlar]);
	return 1;
}

stock Inventory_Update(playerid)
{
	new str[256], string[256], totalall, quantitybar;
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    totalall += InventoryData[playerid][i][invTotalQuantity];
		format(str, sizeof(str), "%.1f/850.0", float(totalall));
		PlayerTextDrawSetString(playerid, INVNAME[playerid][3], str);
		quantitybar = totalall * 199/850;
	    PlayerTextDrawTextSize(playerid, BARQUANTITY[playerid], quantitybar, 13.0);
		if(InventoryData[playerid][i][invExists])
		{
			//sesuakian dengan object item kalian
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			PlayerTextDrawSetString(playerid, NAMETD[playerid][i], str);
			format(str, sizeof(str), "%d", InventoryData[playerid][i][invAmount]);
			PlayerTextDrawSetString(playerid, AMMOUNTTD[playerid][i], str);
		}
		else
		{
			PlayerTextDrawHide(playerid, AMMOUNTTD[playerid][i]);
			PlayerTextDrawHide(playerid, MODELTD[playerid][i]);
			PlayerTextDrawHide(playerid, NAMETD[playerid][i]);
		}
	}
}

stock MenuStore_SelectRow(playerid, row)
{
	pData[playerid][pSelectItem] = row;
    PlayerTextDrawHide(playerid,INDEXTD[playerid][row]);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][row], -7232257);
	PlayerTextDrawShow(playerid,INDEXTD[playerid][row]);
}

stock MenuStore_UnselectRow(playerid)
{
	if(pData[playerid][pSelectItem] != -1)
	{
		new row = pData[playerid][pSelectItem];
		PlayerTextDrawHide(playerid,INDEXTD[playerid][row]);
		PlayerTextDrawColor(playerid, INDEXTD[playerid][row], 80);
		PlayerTextDrawShow(playerid,INDEXTD[playerid][row]);
	}

	pData[playerid][pSelectItem] = -1;
}

CMD:i(playerid, params[])
{
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	Inventory_Show(playerid);
	return 1;
}

function OnInventoryAdd(playerid, itemid)
{
	InventoryData[playerid][itemid][invID] = cache_insert_id();
	return 1;
}

CreateinvenTD(playerid)
{
	BARQUANTITY[playerid] = CreatePlayerTextDraw(playerid, 126.000, 115.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, BARQUANTITY[playerid], 194.000, 3.000);
	PlayerTextDrawAlignment(playerid, BARQUANTITY[playerid], 1);
	PlayerTextDrawColor(playerid, BARQUANTITY[playerid], 512819199);
	PlayerTextDrawSetShadow(playerid, BARQUANTITY[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BARQUANTITY[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, BARQUANTITY[playerid], 255);
	PlayerTextDrawFont(playerid, BARQUANTITY[playerid], 4);
	PlayerTextDrawSetProportional(playerid, BARQUANTITY[playerid], 1);

	INVINFO[playerid][0] = CreatePlayerTextDraw(playerid, 347.000, 168.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVINFO[playerid][0], 55.000, 117.000);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][0], 1);
	PlayerTextDrawColor(playerid, INVINFO[playerid][0], 1887473774);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][0], 255);
	PlayerTextDrawFont(playerid, INVINFO[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][0], 1);

	INVINFO[playerid][1] = CreatePlayerTextDraw(playerid, 352.000, 174.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVINFO[playerid][1], 45.000, 18.000);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][1], 1);
	PlayerTextDrawColor(playerid, INVINFO[playerid][1], 120);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][1], 255);
	PlayerTextDrawFont(playerid, INVINFO[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, INVINFO[playerid][1], 1);

	INVINFO[playerid][2] = CreatePlayerTextDraw(playerid, 352.000, 195.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVINFO[playerid][2], 45.000, 18.000);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][2], 1);
	PlayerTextDrawColor(playerid, INVINFO[playerid][2], 120);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][2], 255);
	PlayerTextDrawFont(playerid, INVINFO[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, INVINFO[playerid][2], 1);

	INVINFO[playerid][3] = CreatePlayerTextDraw(playerid, 352.000, 216.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVINFO[playerid][3], 45.000, 18.000);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][3], 1);
	PlayerTextDrawColor(playerid, INVINFO[playerid][3], 120);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][3], 255);
	PlayerTextDrawFont(playerid, INVINFO[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, INVINFO[playerid][3], 1);

	INVINFO[playerid][4] = CreatePlayerTextDraw(playerid, 352.000, 237.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVINFO[playerid][4], 45.000, 18.000);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][4], 1);
	PlayerTextDrawColor(playerid, INVINFO[playerid][4], 120);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][4], 255);
	PlayerTextDrawFont(playerid, INVINFO[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, INVINFO[playerid][4], 1);

	INVINFO[playerid][5] = CreatePlayerTextDraw(playerid, 352.000, 258.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVINFO[playerid][5], 45.000, 18.000);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][5], 1);
	PlayerTextDrawColor(playerid, INVINFO[playerid][5], 120);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][5], 255);
	PlayerTextDrawFont(playerid, INVINFO[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, INVINFO[playerid][5], 1);

	INVINFO[playerid][6] = CreatePlayerTextDraw(playerid, 375.000, 179.000, "Jumlah");
	PlayerTextDrawLetterSize(playerid, INVINFO[playerid][6], 0.150, 0.898);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][6], 2);
	PlayerTextDrawColor(playerid, INVINFO[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][6], 150);
	PlayerTextDrawFont(playerid, INVINFO[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][6], 1);

	INVINFO[playerid][7] = CreatePlayerTextDraw(playerid, 375.000, 199.000, "Gunakan");
	PlayerTextDrawLetterSize(playerid, INVINFO[playerid][7], 0.150, 0.898);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][7], 2);
	PlayerTextDrawColor(playerid, INVINFO[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][7], 150);
	PlayerTextDrawFont(playerid, INVINFO[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][7], 1);

	INVINFO[playerid][8] = CreatePlayerTextDraw(playerid, 375.000, 220.000, "Berikan");
	PlayerTextDrawLetterSize(playerid, INVINFO[playerid][8], 0.150, 0.898);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][8], 2);
	PlayerTextDrawColor(playerid, INVINFO[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][8], 150);
	PlayerTextDrawFont(playerid, INVINFO[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][8], 1);

	INVINFO[playerid][9] = CreatePlayerTextDraw(playerid, 375.000, 242.000, "Buang");
	PlayerTextDrawLetterSize(playerid, INVINFO[playerid][9], 0.150, 0.898);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][9], 2);
	PlayerTextDrawColor(playerid, INVINFO[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][9], 150);
	PlayerTextDrawFont(playerid, INVINFO[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][9], 1);

	INVINFO[playerid][10] = CreatePlayerTextDraw(playerid, 375.000, 263.000, "Tutup");
	PlayerTextDrawLetterSize(playerid, INVINFO[playerid][10], 0.150, 0.898);
	PlayerTextDrawAlignment(playerid, INVINFO[playerid][10], 2);
	PlayerTextDrawColor(playerid, INVINFO[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, INVINFO[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, INVINFO[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, INVINFO[playerid][10], 150);
	PlayerTextDrawFont(playerid, INVINFO[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, INVINFO[playerid][10], 1);

	INVNAME[playerid][0] = CreatePlayerTextDraw(playerid, 118.000, 96.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVNAME[playerid][0], 211.000, 253.000);
	PlayerTextDrawAlignment(playerid, INVNAME[playerid][0], 1);
	PlayerTextDrawColor(playerid, INVNAME[playerid][0], 1887473774);
	PlayerTextDrawSetShadow(playerid, INVNAME[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, INVNAME[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, INVNAME[playerid][0], 255);
	PlayerTextDrawFont(playerid, INVNAME[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, INVNAME[playerid][0], 1);

	INVNAME[playerid][1] = CreatePlayerTextDraw(playerid, 126.000, 115.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVNAME[playerid][1], 194.000, 3.000);
	PlayerTextDrawAlignment(playerid, INVNAME[playerid][1], 1);
	PlayerTextDrawColor(playerid, INVNAME[playerid][1], 140);
	PlayerTextDrawSetShadow(playerid, INVNAME[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, INVNAME[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, INVNAME[playerid][1], 255);
	PlayerTextDrawFont(playerid, INVNAME[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, INVNAME[playerid][1], 1);

	INVNAME[playerid][2] = CreatePlayerTextDraw(playerid, 126.000, 105.000, "Genzo Ganteng");
	PlayerTextDrawLetterSize(playerid, INVNAME[playerid][2], 0.140, 0.898);
	PlayerTextDrawAlignment(playerid, INVNAME[playerid][2], 1);
	PlayerTextDrawColor(playerid, INVNAME[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, INVNAME[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, INVNAME[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, INVNAME[playerid][2], 150);
	PlayerTextDrawFont(playerid, INVNAME[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, INVNAME[playerid][2], 1);

	INVNAME[playerid][3] = CreatePlayerTextDraw(playerid, 320.000, 105.000, "100/300");
	PlayerTextDrawLetterSize(playerid, INVNAME[playerid][3], 0.140, 0.699);
	PlayerTextDrawAlignment(playerid, INVNAME[playerid][3], 3);
	PlayerTextDrawColor(playerid, INVNAME[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, INVNAME[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, INVNAME[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, INVNAME[playerid][3], 150);
	PlayerTextDrawFont(playerid, INVNAME[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, INVNAME[playerid][3], 1);

	INVNAME[playerid][4] = CreatePlayerTextDraw(playerid, 287.000, 106.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INVNAME[playerid][4], 9.000, 7.000);
	PlayerTextDrawAlignment(playerid, INVNAME[playerid][4], 1);
	PlayerTextDrawColor(playerid, INVNAME[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, INVNAME[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, INVNAME[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, INVNAME[playerid][4], 255);
	PlayerTextDrawFont(playerid, INVNAME[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, INVNAME[playerid][4], 1);

	INVNAME[playerid][5] = CreatePlayerTextDraw(playerid, 288.000, 109.000, "U");
	PlayerTextDrawLetterSize(playerid, INVNAME[playerid][5], 0.300, -1.100);
	PlayerTextDrawAlignment(playerid, INVNAME[playerid][5], 1);
	PlayerTextDrawColor(playerid, INVNAME[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, INVNAME[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, INVNAME[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, INVNAME[playerid][5], 150);
	PlayerTextDrawFont(playerid, INVNAME[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, INVNAME[playerid][5], 1);

	//INDEX
	INDEXTD[playerid][0] = CreatePlayerTextDraw(playerid, 126.000, 119.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][0], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][0], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][0], 1);

	INDEXTD[playerid][1] = CreatePlayerTextDraw(playerid, 165.000, 119.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][1], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][1], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][1], 1);

	INDEXTD[playerid][2] = CreatePlayerTextDraw(playerid, 204.000, 119.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][2], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][2], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][2], 1);

	INDEXTD[playerid][3] = CreatePlayerTextDraw(playerid, 243.000, 119.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][3], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][3], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][3], 1);

	INDEXTD[playerid][4] = CreatePlayerTextDraw(playerid, 282.000, 119.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][4], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][4], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][4], 1);

	INDEXTD[playerid][5] = CreatePlayerTextDraw(playerid, 126.000, 176.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][5], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][5], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][5], 1);

	INDEXTD[playerid][6] = CreatePlayerTextDraw(playerid, 165.000, 176.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][6], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][6], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][6], 1);

	INDEXTD[playerid][7] = CreatePlayerTextDraw(playerid, 204.000, 176.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][7], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][7], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][7], 1);

	INDEXTD[playerid][8] = CreatePlayerTextDraw(playerid, 243.000, 176.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][8], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][8], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][8], 1);

	INDEXTD[playerid][9] = CreatePlayerTextDraw(playerid, 282.000, 176.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][9], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][9], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][9], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][9], 1);

	INDEXTD[playerid][10] = CreatePlayerTextDraw(playerid, 126.000, 233.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][10], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][10], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][10], 1);

	INDEXTD[playerid][11] = CreatePlayerTextDraw(playerid, 165.000, 233.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][11], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][11], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][11], 1);

	INDEXTD[playerid][12] = CreatePlayerTextDraw(playerid, 204.000, 233.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][12], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][12], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][12], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][12], 1);

	INDEXTD[playerid][13] = CreatePlayerTextDraw(playerid, 243.000, 233.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][13], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][13], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][13], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][13], 1);

	INDEXTD[playerid][14] = CreatePlayerTextDraw(playerid, 282.000, 233.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][14], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][14], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][14], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][14], 1);

	INDEXTD[playerid][15] = CreatePlayerTextDraw(playerid, 126.000, 290.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][15], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][15], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][15], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][15], 1);

	INDEXTD[playerid][16] = CreatePlayerTextDraw(playerid, 165.000, 290.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][16], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][16], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][16], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][16], 1);

	INDEXTD[playerid][17] = CreatePlayerTextDraw(playerid, 204.000, 290.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][17], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][17], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][17], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][17], 1);

	INDEXTD[playerid][18] = CreatePlayerTextDraw(playerid, 243.000, 290.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][18], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][18], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][18], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][18], 1);

	INDEXTD[playerid][19] = CreatePlayerTextDraw(playerid, 282.000, 290.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][19], 38.000, 49.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][19], 80);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][19], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][19], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][19], 1);

	//GARIS BAWAH
	GARISBAWAH[playerid][0] = CreatePlayerTextDraw(playerid, 126.000, 168.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][0], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][0], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][0], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][0], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][0], 1);

	GARISBAWAH[playerid][1] = CreatePlayerTextDraw(playerid, 165.000, 168.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][1], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][1], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][1], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][1], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][1], 1);

	GARISBAWAH[playerid][2] = CreatePlayerTextDraw(playerid, 204.000, 168.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][2], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][2], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][2], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][2], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][2], 1);

	GARISBAWAH[playerid][3] = CreatePlayerTextDraw(playerid, 243.000, 168.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][3], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][3], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][3], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][3], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][3], 1);

	GARISBAWAH[playerid][4] = CreatePlayerTextDraw(playerid, 282.000, 168.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][4], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][4], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][4], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][4], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][4], 1);

	GARISBAWAH[playerid][5] = CreatePlayerTextDraw(playerid, 126.000, 225.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][5], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][5], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][5], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][5], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][5], 1);

	GARISBAWAH[playerid][6] = CreatePlayerTextDraw(playerid, 165.000, 225.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][6], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][6], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][6], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][6], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][6], 1);

	GARISBAWAH[playerid][7] = CreatePlayerTextDraw(playerid, 204.000, 225.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][7], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][7], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][7], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][7], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][7], 1);

	GARISBAWAH[playerid][8] = CreatePlayerTextDraw(playerid, 243.000, 225.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][8], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][8], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][8], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][8], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][8], 1);

	GARISBAWAH[playerid][9] = CreatePlayerTextDraw(playerid, 282.000, 225.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][9], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][9], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][9], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][9], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][9], 1);

	GARISBAWAH[playerid][10] = CreatePlayerTextDraw(playerid, 126.000, 282.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][10], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][10], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][10], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][10], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][10], 1);

	GARISBAWAH[playerid][11] = CreatePlayerTextDraw(playerid, 165.000, 282.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][11], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][11], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][11], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][11], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][11], 1);

	GARISBAWAH[playerid][12] = CreatePlayerTextDraw(playerid, 204.000, 282.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][12], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][12], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][12], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][12], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][12], 1);

	GARISBAWAH[playerid][13] = CreatePlayerTextDraw(playerid, 243.000, 282.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][13], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][13], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][13], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][13], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][13], 1);

	GARISBAWAH[playerid][14] = CreatePlayerTextDraw(playerid, 282.000, 282.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][14], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][14], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][14], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][14], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][14], 1);

	GARISBAWAH[playerid][15] = CreatePlayerTextDraw(playerid, 126.000, 339.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][15], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][15], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][15], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][15], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][15], 1);

	GARISBAWAH[playerid][16] = CreatePlayerTextDraw(playerid, 165.000, 339.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][16], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][16], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][16], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][16], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][16], 1);

	GARISBAWAH[playerid][17] = CreatePlayerTextDraw(playerid, 204.000, 339.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][17], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][17], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][17], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][17], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][17], 1);

	GARISBAWAH[playerid][18] = CreatePlayerTextDraw(playerid, 243.000, 339.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][18], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][18], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][18], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][18], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][18], 1);

	GARISBAWAH[playerid][19] = CreatePlayerTextDraw(playerid, 282.000, 339.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][19], 38.000, 4.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][19], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][19], 512819199);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][19], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][19], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][19], 1);

	MODELTD[playerid][0] = CreatePlayerTextDraw(playerid, 130.000, 129.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][0], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][0], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][0], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][0], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][0], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][0], 1);

	MODELTD[playerid][1] = CreatePlayerTextDraw(playerid, 169.000, 129.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][1], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][1], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][1], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][1], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][1], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][1], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][1], 1);

	MODELTD[playerid][2] = CreatePlayerTextDraw(playerid, 208.000, 129.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][2], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][2], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][2], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][2], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][2], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][2], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][2], 1);

	MODELTD[playerid][3] = CreatePlayerTextDraw(playerid, 248.000, 129.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][3], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][3], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][3], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][3], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][3], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][3], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][3], 1);

	MODELTD[playerid][4] = CreatePlayerTextDraw(playerid, 286.000, 129.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][4], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][4], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][4], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][4], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][4], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][4], 1);

	MODELTD[playerid][5] = CreatePlayerTextDraw(playerid, 130.000, 185.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][5], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][5], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][5], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][5], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][5], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][5], 1);

	MODELTD[playerid][6] = CreatePlayerTextDraw(playerid, 169.000, 185.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][6], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][6], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][6], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][6], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][6], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][6], 1);

	MODELTD[playerid][7] = CreatePlayerTextDraw(playerid, 208.000, 185.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][7], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][7], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][7], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][7], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][7], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][7], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][7], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][7], 1);

	MODELTD[playerid][8] = CreatePlayerTextDraw(playerid, 248.000, 185.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][8], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][8], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][8], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][8], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][8], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][8], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][8], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][8], 1);

	MODELTD[playerid][9] = CreatePlayerTextDraw(playerid, 286.000, 185.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][9], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][9], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][9], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][9], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][9], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][9], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][9], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][9], 1);

	MODELTD[playerid][10] = CreatePlayerTextDraw(playerid, 130.000, 242.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][10], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][10], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][10], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][10], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][10], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][10], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][10], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][10], 1);

	MODELTD[playerid][11] = CreatePlayerTextDraw(playerid, 169.000, 242.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][11], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][11], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][11], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][11], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][11], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][11], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][11], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][11], 1);

	MODELTD[playerid][12] = CreatePlayerTextDraw(playerid, 208.000, 242.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][12], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][12], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][12], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][12], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][12], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][12], 1);

	MODELTD[playerid][13] = CreatePlayerTextDraw(playerid, 248.000, 242.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][13], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][13], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][13], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][13], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][13], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][13], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][13], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][13], 1);

	MODELTD[playerid][14] = CreatePlayerTextDraw(playerid, 286.000, 242.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][14], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][14], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][14], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][14], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][14], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][14], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][14], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][14], 1);

	MODELTD[playerid][15] = CreatePlayerTextDraw(playerid, 130.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][15], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][15], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][15], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][15], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][15], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][15], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][15], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][15], 1);

	MODELTD[playerid][16] = CreatePlayerTextDraw(playerid, 169.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][16], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][16], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][16], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][16], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][16], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][16], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][16], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][16], 1);

	MODELTD[playerid][17] = CreatePlayerTextDraw(playerid, 208.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][17], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][17], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][17], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][17], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][17], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][17], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][17], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][17], 1);

	MODELTD[playerid][18] = CreatePlayerTextDraw(playerid, 248.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][18], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][18], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][18], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][18], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][18], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][18], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][18], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][18], 1);

	MODELTD[playerid][19] = CreatePlayerTextDraw(playerid, 286.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][19], 29.000, 30.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][19], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][19], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][19], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][19], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][19], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][19], 0, 0);
	PlayerTextDrawSetSelectable(playerid, MODELTD[playerid][19], 1);

	NAMETD[playerid][0] = CreatePlayerTextDraw(playerid, 129.000, 122.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][0], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][0], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][0], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][0], 1);

	NAMETD[playerid][1] = CreatePlayerTextDraw(playerid, 168.000, 122.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][1], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][1], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][1], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][1], 1);

	NAMETD[playerid][2] = CreatePlayerTextDraw(playerid, 207.000, 122.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][2], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][2], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][2], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][2], 1);

	NAMETD[playerid][3] = CreatePlayerTextDraw(playerid, 246.000, 122.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][3], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][3], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][3], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][3], 1);

	NAMETD[playerid][4] = CreatePlayerTextDraw(playerid, 285.000, 122.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][4], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][4], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][4], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][4], 1);

	NAMETD[playerid][5] = CreatePlayerTextDraw(playerid, 129.000, 179.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][5], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][5], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][5], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][5], 1);

	NAMETD[playerid][6] = CreatePlayerTextDraw(playerid, 168.000, 179.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][6], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][6], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][6], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][6], 1);

	NAMETD[playerid][7] = CreatePlayerTextDraw(playerid, 207.000, 179.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][7], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][7], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][7], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][7], 1);

	NAMETD[playerid][8] = CreatePlayerTextDraw(playerid, 246.000, 179.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][8], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][8], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][8], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][8], 1);

	NAMETD[playerid][9] = CreatePlayerTextDraw(playerid, 285.000, 179.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][9], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][9], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][9], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][9], 1);

	NAMETD[playerid][10] = CreatePlayerTextDraw(playerid, 129.000, 235.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][10], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][10], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][10], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][10], 1);

	NAMETD[playerid][11] = CreatePlayerTextDraw(playerid, 168.000, 235.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][11], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][11], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][11], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][11], 1);

	NAMETD[playerid][12] = CreatePlayerTextDraw(playerid, 207.000, 235.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][12], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][12], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][12], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][12], 1);

	NAMETD[playerid][13] = CreatePlayerTextDraw(playerid, 246.000, 235.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][13], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][13], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][13], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][13], 1);

	NAMETD[playerid][14] = CreatePlayerTextDraw(playerid, 285.000, 235.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][14], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][14], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][14], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][14], 1);

	NAMETD[playerid][15] = CreatePlayerTextDraw(playerid, 129.000, 293.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][15], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][15], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][15], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][15], 1);

	NAMETD[playerid][16] = CreatePlayerTextDraw(playerid, 168.000, 293.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][16], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][16], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][16], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][16], 1);

	NAMETD[playerid][17] = CreatePlayerTextDraw(playerid, 207.000, 293.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][17], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][17], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][17], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][17], 1);

	NAMETD[playerid][18] = CreatePlayerTextDraw(playerid, 246.000, 293.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][18], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][18], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][18], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][18], 1);

	NAMETD[playerid][19] = CreatePlayerTextDraw(playerid, 285.000, 293.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][19], 0.160, 0.699);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][19], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][19], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][19], 1);

	AMMOUNTTD[playerid][0] = CreatePlayerTextDraw(playerid, 128.000, 159.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][0], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][0], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][0], 1);

	AMMOUNTTD[playerid][1] = CreatePlayerTextDraw(playerid, 167.000, 159.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][1], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][1], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][1], 1);

	AMMOUNTTD[playerid][2] = CreatePlayerTextDraw(playerid, 206.000, 159.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][2], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][2], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][2], 1);

	AMMOUNTTD[playerid][3] = CreatePlayerTextDraw(playerid, 245.000, 159.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][3], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][3], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][3], 1);

	AMMOUNTTD[playerid][4] = CreatePlayerTextDraw(playerid, 284.000, 159.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][4], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][4], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][4], 1);

	AMMOUNTTD[playerid][5] = CreatePlayerTextDraw(playerid, 128.000, 217.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][5], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][5], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][5], 1);

	AMMOUNTTD[playerid][6] = CreatePlayerTextDraw(playerid, 167.000, 217.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][6], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][6], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][6], 1);

	AMMOUNTTD[playerid][7] = CreatePlayerTextDraw(playerid, 206.000, 217.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][7], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][7], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][7], 1);

	AMMOUNTTD[playerid][8] = CreatePlayerTextDraw(playerid, 245.000, 217.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][8], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][8], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][8], 1);

	AMMOUNTTD[playerid][9] = CreatePlayerTextDraw(playerid, 284.000, 217.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][9], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][9], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][9], 1);

	AMMOUNTTD[playerid][10] = CreatePlayerTextDraw(playerid, 128.000, 274.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][10], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][10], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][10], 1);

	AMMOUNTTD[playerid][11] = CreatePlayerTextDraw(playerid, 167.000, 274.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][11], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][11], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][11], 1);

	AMMOUNTTD[playerid][12] = CreatePlayerTextDraw(playerid, 206.000, 274.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][12], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][12], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][12], 1);

	AMMOUNTTD[playerid][13] = CreatePlayerTextDraw(playerid, 245.000, 274.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][13], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][13], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][13], 1);

	AMMOUNTTD[playerid][14] = CreatePlayerTextDraw(playerid, 284.000, 274.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][14], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][14], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][14], 1);

	AMMOUNTTD[playerid][15] = CreatePlayerTextDraw(playerid, 128.000, 331.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][15], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][15], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][15], 1);

	AMMOUNTTD[playerid][16] = CreatePlayerTextDraw(playerid, 167.000, 331.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][16], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][16], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][16], 1);

	AMMOUNTTD[playerid][17] = CreatePlayerTextDraw(playerid, 206.000, 331.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][17], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][17], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][17], 1);

	AMMOUNTTD[playerid][18] = CreatePlayerTextDraw(playerid, 245.000, 331.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][18], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][18], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][18], 1);

	AMMOUNTTD[playerid][19] = CreatePlayerTextDraw(playerid, 284.000, 331.000, "10000x");
	PlayerTextDrawLetterSize(playerid, AMMOUNTTD[playerid][19], 0.140, 0.599);
	PlayerTextDrawAlignment(playerid, AMMOUNTTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, AMMOUNTTD[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, AMMOUNTTD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, AMMOUNTTD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, AMMOUNTTD[playerid][19], 150);
	PlayerTextDrawFont(playerid, AMMOUNTTD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, AMMOUNTTD[playerid][19], 1);
}

/*function ShowInventory(playerid, targetid)
{
    if (!IsPlayerConnected(playerid))
	    return 0;

	new
	    items[MAX_INVENTORY],
		amounts[MAX_INVENTORY],
		str[512],
		string[352],
		count = 0;

	format(str, sizeof(str), "Name\tAmount\n");
	format(str, sizeof(str), "%s\nMoney\t$%s", str, pData[targetid][pMoney]);
    forex(i, MAX_INVENTORY)
	{
 		if (InventoryData[targetid][i][invExists])
        {
            count++;
   			items[i] = InventoryData[targetid][i][invModel];
   			amounts[i] = InventoryData[targetid][i][invQuantity];
   			strunpack(string, InventoryData[targetid][i][invItem]);
   			format(str, sizeof(str), "%s\n%s\t%d", str, string, amounts[i]);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, sprintf("%s Inventory", ReturnName(targetid)), str,  "Close", "");
	return 1;
}

stock OpenInventory(playerid)
{
    if (!IsPlayerConnected(playerid))
	    return 0;

	new
		amounts[MAX_INVENTORY],
		str[512],
		string[256];

	format(str, sizeof(str), "Name\tAmount\t%0.4d KG/50.00KG\n", pData[playerid][pMaxitem]);
    forex(i, MAX_INVENTORY)
	{
	    if (!InventoryData[playerid][i][invExists])
	        format(str, sizeof(str), "%s{AFAFAF}Empty Slot\n", str);

		else
		{
			amounts[i] = InventoryData[playerid][i][invQuantity];
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s{FFFFFF}%s\t%d\n", str, string, amounts[i]);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS, "Inventory", str, "Select", "Close");
	return 1;
}

function LoadPlayerItems(playerid)
{
	new name[128];
	new count = cache_num_rows();
	if(count > 0)
	{
	    forex(i, count)
	    {
	        InventoryData[playerid][i][invExists] = true;

	        cache_get_value_name_int(i, "invID", InventoryData[playerid][i][invID]);
	        cache_get_value_name_int(i, "invModel", InventoryData[playerid][i][invModel]);
	        cache_get_value_name_int(i, "invQuantity", InventoryData[playerid][i][invQuantity]);

	        cache_get_value_name(i, "invItem", name);

			strpack(InventoryData[playerid][i][invItem], name, 32 char);
		}
	}
	return 1;
}

function OnPlayerUseItems(playerid, itemid, name[])
{
	if(!strcmp(name, "Snack"))
	{
        pData[playerid][pHunger] += 9;
		Inventory_Remove(playerid, "Snack", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil snack di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Fried Chicken"))
	{
        pData[playerid][pHunger] += 11;
		Inventory_Remove(playerid, "Fried Chicken", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil Fried Chicken di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Pizza Stack"))
	{
        pData[playerid][pHunger] += 13;
		Inventory_Remove(playerid, "Pizza Stack", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil Pizza Stack di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Patty Burger"))
	{
        pData[playerid][pHunger] += 15;
		Inventory_Remove(playerid, "Patty Burger", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil Patty Burger di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Water"))
	{
        pData[playerid][pEnergy] += 10;
		Inventory_Remove(playerid, "Water", 1);
		ApplyAnimation(playerid, "VENDING", "VEND_DRINK2_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil mineral di tas dan meminumnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Sprunk"))
	{
        pData[playerid][pEnergy] += 8;
		Inventory_Remove(playerid, "Sprunk", 1);
		ApplyAnimation(playerid, "VENDING", "VEND_DRINK2_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil Sprunk di tas dan meminumnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Milk"))
	{
        pData[playerid][pEnergy] += 26;
		Inventory_Remove(playerid, "Milk", 1);
		ApplyAnimation(playerid, "VENDING", "VEND_DRINK2_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil milk di tas dan meminumnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Big Burger"))
	{
        pData[playerid][pHunger] += 27;
		Inventory_Remove(playerid, "Big Burger", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil Big Burger di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Steak"))
	{
        pData[playerid][pHunger] += 31;
		Inventory_Remove(playerid, "Steak", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil Stack di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Roti"))
	{
        pData[playerid][pHunger] += 24;
		Inventory_Remove(playerid, "Roti", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil Roti di tas dan memakannya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Phone"))
	{
		callcmd::phone(playerid, "");
	}
	else if(!strcmp(name, "GPS"))
	{
		return ShowNotifError(playerid, "Tidak bisa digunakan", 10000);
	}
	else if(!strcmp(name, "Medkit"))
	{

		if (ReturnHealth(playerid) > 99)
		    return Error(playerid, "Anda tidak perlu menggunakan medkit sekarang.");

	    GetPlayerHealth(playerid, darahh);
	    SetPlayerHealthEx(playerid, darahh+50);
	    Inventory_Remove(playerid, "Medkit", 1);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s membuka kotak P3K dan menggunakannya.", ReturnName(playerid));
	}
	else if(!strcmp(name, "Fuel Can"))
	{
		if(IsPlayerInAnyVehicle(playerid))
			return Error(playerid, "Anda harus berada diluar kendaraan!");

		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
		if(IsValidVehicle(vehicleid))
		{
			new fuel = GetVehicleFuel(vehicleid);
			
			if(GetEngineStatus(vehicleid))
				return Error(playerid, "Turn off vehicle engine.");
			
			if(fuel >= 100)
				return Error(playerid, "This vehicle gas is full.");
			
			if(!IsEngineVehicle(vehicleid))
				return Error(playerid, "This vehicle can't be refull.");

			if(!GetHoodStatus(vehicleid))
				return Error(playerid, "The hood must be opened before refull the vehicle.");

			Inventory_Remove(playerid, "Fuel Can", 1);
			Info(playerid, "Don't move from your position or you will failed to refulling this vehicle.");
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			pData[playerid][pActivity] = SetTimerEx("RefullCar", 1000, true, "id", playerid, vehicleid);
			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Refulling...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s menggisi bensin kendaraan dengan menggunakan kedua tangan.", ReturnName(playerid));
		}

	}
	else if(!strcmp(name, "Component"))
	{
		return Error(playerid, "Tidak bisa digunakan");
	}
	else if(!strcmp(name, "Medicine"))
	{
		pData[playerid][pSick] = 0;
		pData[playerid][pSickTime] = 0;
		SetPlayerDrunkLevel(playerid, 0);
		Inventory_Remove(playerid, "Medicine", 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil medicine dan langsung menggunakannya", ReturnName(playerid));

		ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
	}
	else if(!strcmp(name, "Bandage"))
	{
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s membalut luka menggunakan perban", ReturnName(playerid));
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerAttachedObject(playerid, 9, 11738, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);

		pData[playerid][pTimebandage] = SetTimerEx("pakebandage", 1000, true, "i", playerid);
		Showbar(playerid, 5, "USE BANDAGE", "pakebandage");
	}
	else if(!strcmp(name, "Marijuana"))
	{
		new Float:health;
		GetPlayerHealth(playerid, health);
		if(health+25 > 95)
		{
			Error(playerid, "Over dosis!");
			TextDrawShowForPlayer(playerid, Text:RedScreen);
			SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			}
			SetPlayerHealthEx(playerid, 95);
			return 1;
		}

		Inventory_Remove(playerid, "Marijuana", 1);
		pData[playerid][pUseDrug]++;
		SetPlayerHealthEx(playerid, health+25);
		SetPlayerDrunkLevel(playerid, 4000);
		ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g marijuana dan langsung menghisapnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Cocaine"))
	{
		new Float:armor;
		GetPlayerArmour(playerid, armor);
		if(armor+25 > 95)
		{
			Error(playerid, "Over dosis!");
			TextDrawShowForPlayer(playerid, Text:RedScreen);
			SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			}
			SetPlayerArmourEx(playerid, 95);
			return 1;
		}

		Inventory_Remove(playerid, "Cocaine", 1);
		pData[playerid][pUseDrug]++;
		SetPlayerArmourEx(playerid, armor+20);
		SetPlayerDrunkLevel(playerid, 4000);
		ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g cocaine dan langsung menghisapnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Meth"))
	{
		new Float:armor, Float:health;
		GetPlayerArmour(playerid, armor);
		GetPlayerHealth(playerid, health);
		if(armor+25 > 95)
		{
			Error(playerid, "Over dosis!");
			TextDrawShowForPlayer(playerid, Text:RedScreen);
			SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			}
			SetPlayerArmourEx(playerid, 95);
		}
		else if(health+25 > 95)
		{
			Error(playerid, "Over dosis!");
			TextDrawShowForPlayer(playerid, Text:RedScreen);
			SetTimerEx("ShowRedScreen", 1000, 0, "d", playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			}
			SetPlayerHealthEx(playerid, 95);
			return 1;
		}

		Inventory_Remove(playerid, "Meth", 1);
		pData[playerid][pUseDrug]++;
		SetPlayerArmourEx(playerid, armor+20);
		SetPlayerHealthEx(playerid, health+20);
		SetPlayerDrunkLevel(playerid, 4000);
		ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 1g meth dan langsung menghisapnya", ReturnName(playerid));
	}
	else if(!strcmp(name, "Clip Pistol"))
	{
		if(GetPlayerWeapon(playerid) == 0)
		return Error(playerid, "Kamu harus memegang senjata api");

		new weaponid = GetPlayerWeapon(playerid), ammo = GetPlayerAmmo(playerid);

		if(weaponid < 22 || weaponid > 32)
			return Error(playerid, "this weapon does not support to use clip");

		if(weaponid >= 22 && weaponid <= 24) //PISTOL
		{
			if(weaponid == 22 || weaponid == 23)
			{
				GivePlayerWeaponEx(playerid, weaponid, ammo+50);
			}
			else
			{
				GivePlayerWeaponEx(playerid, weaponid, ammo+34);
			}
			pData[playerid][pAmmoPistol] -= 1;
			Inventory_Remove(playerid, "Clip Pistol", 1);
			Info(playerid, "Succes reloaded ammo weapon %s with Pistol Clip", ReturnWeaponName(weaponid));
			ApplyAnimation(playerid, "PYTHON", "python_reload", 4.1, 0, 0, 0, 0, 0);
		}
	}
	else if(!strcmp(name, "Clip Rifle"))
	{
		if(GetPlayerWeapon(playerid) == 0)
		return Error(playerid, "Kamu harus memegang senjata api");

		new weaponid = GetPlayerWeapon(playerid), ammo = GetPlayerAmmo(playerid);

		if(weaponid < 28 || weaponid > 32)
			return Error(playerid, "this weapon does not support to use clip");

		if(weaponid >= 28 && weaponid <= 32) //Rifle
		{
			Inventory_Remove(playerid, "Clip Rifle", 1);
			GivePlayerWeaponEx(playerid, weaponid, ammo+200);
			Info(playerid, "Succes reloaded ammo weapon %s with Rifle Clip", ReturnWeaponName(weaponid));
			ApplyAnimation(playerid, "RIFLE", "RIFLE_load", 4.1, 0, 0, 0, 0, 0);
		}
	}
	return 1;
}

CMD:inventory(playerid, params[])
{
	pData[playerid][pStorageSelect] = 0;
	OpenInventory(playerid);
	return 1;
}

CMD:setitem(playerid, params[])
{
	new
	    userid,
		item[32],
		amount;

	if (pData[playerid][pAdmin] < 6)
	    return Error(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "uds[32]", userid, amount, item))
	    return SendSyntaxMessage(playerid, "/setitem [playerid/PartOfName] [amount] [item name]");

	for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
	{
        Inventory_Set(userid, g_aInventoryItems[i][e_InventoryItem], g_aInventoryItems[i][e_InventoryModel], amount);

		return Servers(playerid, "You have set %s's \"%s\" to %d.", ReturnName(userid), item, amount);
	}
	Error(playerid, "Invalid item name (use /itemlist for a list).");
	return 1;
}

CMD:itemlist(playerid, params[])
{
	new
	    string[1024];

	if (!strlen(string)) {
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) {
			format(string, sizeof(string), "%s%s\n", string, g_aInventoryItems[i][e_InventoryItem]);
		}
	}
	return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "List of Items", string, "Select", "Cancel");
}*/