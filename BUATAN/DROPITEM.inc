#define MAX_DROPPED_ITEMS 1000
enum droppedItems
{
	droppedID,
	droppedItem[32],
	droppedPlayer[24],
	droppedModel,
	droppedQuantity,
	Float:droppedPos[3],
	droppedWeapon,
	droppedAmmo,
	droppedInt,
	droppedWorld,
	droppedObject,
	Text3D:droppedText3D
};

new DroppedItems[MAX_DROPPED_ITEMS][droppedItems],
	Iterator:DROPPED<MAX_DROPPED_ITEMS>;

function Dropped_Load()
{
	new rows;
	cache_get_row_count(rows);
 	if(rows)
  	{
  		new id, i = 0;
    	while(i < rows)
		{
		    cache_get_value_name_int(i, "ID", id);
			cache_get_value_name(i, "itemName", DroppedItems[id][droppedItem]);
			cache_get_value_name_int(i, "itemModel", DroppedItems[id][droppedModel]);
			cache_get_value_name_int(i, "itemQuantity", DroppedItems[id][droppedQuantity]);
			cache_get_value_name_float(i, "itemX", DroppedItems[id][droppedPos][0]);
			cache_get_value_name_float(i, "itemY", DroppedItems[id][droppedPos][1]);
			cache_get_value_name_float(i, "itemZ", DroppedItems[id][droppedPos][2]);
			cache_get_value_name_int(i, "itemInt", DroppedItems[id][droppedInt]);
			cache_get_value_name_int(i, "itemWorld", DroppedItems[id][droppedWorld]);
			DroppedItems[id][droppedObject] = CreateDynamicObject(DroppedItems[id][droppedModel], DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2], 0.0, 0.0, 0.0, DroppedItems[id][droppedWorld], DroppedItems[id][droppedInt]);
			DroppedItems[id][droppedText3D] = CreateDynamic3DTextLabel(DroppedItems[id][droppedItem], COLOR_RCONBLUE, DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DroppedItems[id][droppedWorld], DroppedItems[id][droppedInt]);
			Iter_Add(DROPPED, id);
			i++;
		}
		printf("[DROPITEM] Loaded: %d Dropped Items", i);
	}
}

Dropped_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE dropped SET itemName='%s', itemModel='%d', itemQuantity='%d', itemX='%f', itemY='%f', itemZ='%f', itemInt='%d', itemWorld='%d' WHERE ID='%d'",
	DroppedItems[id][droppedItem],
	DroppedItems[id][droppedModel],
	DroppedItems[id][droppedQuantity],
	DroppedItems[id][droppedPos][0],
	DroppedItems[id][droppedPos][1],
	DroppedItems[id][droppedPos][2],
	DroppedItems[id][droppedInt],
	DroppedItems[id][droppedWorld],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

function DropItem(name[], itemid, value, Float:x, Float:y, Float:z, interior, world)
{
	new
	    query[512];

	new id = Iter_Free(DROPPED);
	
    format(DroppedItems[id][droppedItem], 32, name);

	DroppedItems[id][droppedModel] = itemid;
	DroppedItems[id][droppedPos][0] = x;
	DroppedItems[id][droppedPos][1] = y;
	DroppedItems[id][droppedPos][2] = z;
	DroppedItems[id][droppedQuantity] = value;
	DroppedItems[id][droppedInt] = interior;
	DroppedItems[id][droppedWorld] = world;
	printf("DropItem: %d", value);

	DroppedItems[id][droppedObject] = CreateDynamicObject(itemid, x, y, z, 0.0, 0.0, 0.0, world, interior);

	DroppedItems[id][droppedText3D] = CreateDynamic3DTextLabel(name, COLOR_RCONBLUE, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, world, interior);

	Iter_Add(DROPPED, id);
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO dropped SET ID='%d', itemName='%s', itemModel='%d', itemQuantity='%d', itemX='%.4f', itemY='%.4f', itemZ='%.4f', itemInt='%d', itemWorld='%d'", id, name, itemid, value, x, y, z, interior, world);
	mysql_tquery(g_SQL, query, "OnDroppedItem", "d", id);
	return 1;
}

function OnDroppedItem(id)
{
	Dropped_Save(id);
	return 1;
}

function DropPlayerItem(playerid, itemid, name[], value)
{
	new
		Float:x,
  		Float:y,
    	Float:z,
		Float:angle,
		string[32],
		str[20];

	if(Inventory_Count(playerid, string) < pData[playerid][pGiveAmount])
		return ErrorMsg(playerid, "Barang Kamu Tidak Mencukupi!");

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if(!strcmp(name, "Uang", true))
	{
		itemid = 1212;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Uang", str, 1212, 2);
		//pData[playerid][pMoney] -= value;
		GivePlayerMoneyEx(playerid, -value);
	}
	else if(!strcmp(name, "Snack", true))
	{
		itemid = 2821;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Snack", str, 2821, 2);
		pData[playerid][pSnack] -= value;
	}
	else if(!strcmp(name, "Water", true))
	{
		itemid = 2958;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Water", str, 2958, 2);
		pData[playerid][pSprunk] -= value;
	}
	else if(!strcmp(name, "Fried Chicken", true))
	{
		itemid = 19847;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Fried Chicken", str, 19847, 2);
		pData[playerid][pChicken] -= value;
	}
	else if(!strcmp(name, "Pizza Stack", true))
	{
		itemid = 19580;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Pizza Stack", str, 19580, 2);
		pData[playerid][pPizzaP] -= value;
	}
	else if(!strcmp(name, "Patty Burger", true))
	{
		itemid = 2703;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Patty Burger", str, 2703, 2);
		pData[playerid][pBurgerP] -= value;
	}
	else if(!strcmp(name, "Milk", true))
	{
		itemid = 19570;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Milk", str, 19570, 2);
		pData[playerid][pMilks] -= value;
	}
	else if(!strcmp(name, "Steak", true))
	{
		itemid = 19882;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Steak", str, 19882, 2);
		pData[playerid][pSteak] -= value;
	}
	else if(!strcmp(name, "Roti", true))
	{
		itemid = 19883;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Roti", str, 19883, 2);
		pData[playerid][pRoti] -= value;
	}
	else if(!strcmp(name, "Cappucino", true))
	{
		itemid = 19835;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Cappucino", str, 19835, 2);
		pData[playerid][pCappucino] -= value;
	}
	else if(!strcmp(name, "Starling", true))
	{
		itemid = 1455;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Starling", str, 1455, 2);
		pData[playerid][pStarling] -= value;
	}
	else if(!strcmp(name, "Milx_Max", true))
	{
		itemid = 19570;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Milx_Max", str, 19570, 2);
		pData[playerid][pMilxMax] -= value;
	}
	else if(!strcmp(name, "Fuel Can", true))
	{
		itemid = 1650;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Fuel Can", str, 1650, 2);
		pData[playerid][pGas] -= value;
	}
	else if(!strcmp(name, "component", true))
	{
		itemid = 1104;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "component", str, 1104, 2);
		pData[playerid][pComponent] -= value;
	}
	else if(!strcmp(name, "material", true))
	{
		itemid = 1158;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "material", str, 1158, 2);
		pData[playerid][pMaterial] -= value;
	}
	else if(!strcmp(name, "Marijuana", true))
	{
		itemid = 1578;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Marijuana", str, 1578, 2);
		pData[playerid][pMarijuana] -= value;
	}
	else if(!strcmp(name, "Cocaine", true))
	{
		itemid = 1580;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Cocaine", str, 1580, 2);
		pData[playerid][pCocaine] -= value;
	}
	else if(!strcmp(name, "Meth", true))
	{
		itemid = 1580;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Meth", str, 1580, 2);
		pData[playerid][pMeth] -= value;
	}
	else if(!strcmp(name, "Medkit", true))
	{
		itemid = 11738;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Medkit", str, 11738, 2);
		pData[playerid][pMedkit] -= value;
	}
	else if(!strcmp(name, "Bandage", true))
	{
		itemid = 11736;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Bandage", str, 11736, 2);
		pData[playerid][pBandage] -= value;
	}
	else if(!strcmp(name, "Obat_Stress", true))
	{
		itemid = 1241;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Obat_Stress", str, 1241, 2);
		pData[playerid][pObatStress] -= value;
	}
	else if(!strcmp(name, "Batu", true))
	{
		itemid = 905;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Batu", str, 905, 2);
		pData[playerid][pBatu] -= value;
	}
	else if(!strcmp(name, "Batu_Cucian", true))
	{
		itemid = 2936;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Batu_Cucian", str, 2936, 2);
		pData[playerid][pBatuCucian] -= value;
	}
	else if(!strcmp(name, "Besi", true))
	{
		itemid = 1510;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Besi", str, 1510, 2);
		pData[playerid][pBesi] -= value;
	}
	else if(!strcmp(name, "Emas", true))
	{
		itemid = 19941;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Emas", str, 19941, 2);
		pData[playerid][pEmas] -= value;
	}
	else if(!strcmp(name, "Aluminium", true))
	{
		itemid = 19809;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Aluminium", str, 19809, 2);
		pData[playerid][pAluminium] -= value;
	}
	else if(!strcmp(name, "Minyak", true))
	{
		itemid = 2969;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Minyak", str, 2969, 2);
		pData[playerid][pMinyak] -= value;
	}
	else if(!strcmp(name, "Essence", true))
	{
		itemid = 3015;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Essence", str, 3015, 2);
		pData[playerid][pEssence] -= value;
	}
	else if(!strcmp(name, "Vest", true))
	{
		itemid = 1242;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Vest", str, 1242, 2);
		pData[playerid][pVest] -= value;
	}
	else if(!strcmp(name, "Kevlar Vest", true))
	{
		itemid = 19515;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kevlar Vest", str, 19515, 2);
		pData[playerid][pKevlar] -= value;
	}
	else if(!strcmp(name, "Clip", true))
	{
		itemid = 19995;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Clip", str, 19995, 2);
		pData[playerid][pClip] -= value;
	}
	else if(!strcmp(name, "AK-47", true))
	{
		itemid = 355;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "AK-47", str, 355, 2);
		pData[playerid][pAK47] -= value;
	}
	else if(!strcmp(name, "Colt 45", true))
	{
		itemid = 346;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Colt 45", str, 346, 2);
		pData[playerid][pColt45] -= value;
	}
	else if(!strcmp(name, "Desert Eagle", true))
	{
		itemid = 348;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Desert Eagle", str, 348, 2);
		pData[playerid][pDesertEagle] -= value;
	}
	else if(!strcmp(name, "Micro SMG", true))
	{
		itemid = 352;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Micro SMG", str, 352, 2);
		pData[playerid][pMicroSMG] -= value;
	}
	else if(!strcmp(name, "Tec-9", true))
	{
		itemid = 372;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Tec-9", str, 372, 2);
		pData[playerid][pTec9] -= value;
	}
	else if(!strcmp(name, "MP5", true))
	{
		itemid = 353;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "MP5", str, 353, 2);
		pData[playerid][pMP5] -= value;
	}
	else if(!strcmp(name, "Shotgun", true))
	{
		itemid = 349;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Shotgun", str, 349, 2);
		pData[playerid][pShotgun] -= value;
	}
	else if(!strcmp(name, "Rifle", true))
	{
		itemid = 357;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Rifle", str, 357, 2);
		pData[playerid][pRifle] -= value;
	}
	else if(!strcmp(name, "Sniper", true))
	{
		itemid = 358;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Sniper", str, 358, 2);
		pData[playerid][pSniper] -= value;
	}
	else if(!strcmp(name, "Knife", true))
	{
		itemid = 335;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Knife", str, 335, 2);
		pData[playerid][pKnife] -= value;
	}
	else if(!strcmp(name, "Katana", true))
	{
		itemid = 339;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Katana", str, 339, 2);
		pData[playerid][pKatana] -= value;
	}
	else if(!strcmp(name, "Berlian", true))
	{
		itemid = 19941;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Berlian", str, 19941, 2);
		pData[playerid][pKatana] -= value;
	}

	printf("Itemid: %d, Name: %s, value: %d", itemid, name, value);

	DropItem(name, itemid, value, x, y, z - 0.9, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

	ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
 	SendNearbyMessageEx(playerid, 20.0, COLOR_PURPLE, "* %s telah menjatuhkan %s.", GetName(playerid), name);
	return Inventory_Close(playerid);
}

NearItemDropped(playerid, targetid, Float:radius)
{
    return (IsPlayerInRangeOfPoint(playerid, radius, DroppedItems[targetid][droppedPos][0], DroppedItems[targetid][droppedPos][1], DroppedItems[targetid][droppedPos][2]));
}

CMD:takedrop(playerid)
{
	new count = 0, str[500], strr[500];
	foreach(new i : DROPPED) if(NearItemDropped(playerid, i, 2))
	{
		format(str, sizeof(str), "- %d\t (%s[%d])\n", i, DroppedItems[i][droppedItem], DroppedItems[i][droppedQuantity]);
		strcat(strr, str);
		SetPlayerListitemValue(playerid, count++, i);
	}
	if(!count) Error(playerid, "Tidak ada item yang terdrop didekat mu!");
	else ShowPlayerDialog(playerid, DIALOG_TAKE, DIALOG_STYLE_LIST, "{15D4ED}Konoha{ffffff} - Item Drop", strr, "Ambil", "Tutup");
}

function TakePlayerItem(playerid, id, name[])
{
	new str[50], query[512];
	DestroyDynamicObject(DroppedItems[id][droppedObject]);
	DestroyDynamic3DTextLabel(DroppedItems[id][droppedText3D]);
	DroppedItems[id][droppedObject] = -1;
	DroppedItems[id][droppedText3D] = Text3D: -1;
	Iter_Remove(DROPPED, id);

	if(!strcmp(name, "Uang", true))
	{
		GivePlayerMoneyEx(playerid, DroppedItems[id][droppedQuantity]);
	}
	else if(!strcmp(name, "Snack", true))
	{
		pData[playerid][pSnack] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Water", true))
	{
		pData[playerid][pSprunk] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Fried Chicken", true))
	{
		pData[playerid][pChicken] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Pizza Stack", true))
	{
		pData[playerid][pPizzaP] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Patty Burger", true))
	{
		pData[playerid][pBurgerP] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Milk", true))
	{
		pData[playerid][pMilks] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Steak", true))
	{
		pData[playerid][pSteak] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Roti", true))
	{
		pData[playerid][pRoti] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Cappucino", true))
	{
		pData[playerid][pCappucino] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Starling", true))
	{
		pData[playerid][pStarling] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Milx_Max", true))
	{
		pData[playerid][pMilxMax] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Fuel Can", true))
	{
		pData[playerid][pGas] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "component", true))
	{
		pData[playerid][pComponent] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "material", true))
	{
		pData[playerid][pMaterial] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Marijuana", true))
	{
		pData[playerid][pMarijuana] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Cocaine", true))
	{
		pData[playerid][pCocaine] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Meth", true))
	{
		pData[playerid][pMeth] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Medkit", true))
	{
		pData[playerid][pMedkit] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Bandage", true))
	{
		pData[playerid][pBandage] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Obat_Stress", true))
	{
		pData[playerid][pObatStress] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Batu", true))
	{
		pData[playerid][pBatu] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Batu_Cucian", true))
	{
		pData[playerid][pBatuCucian] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Besi", true))
	{
		pData[playerid][pBesi] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Emas", true))
	{
		pData[playerid][pEmas] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Aluminium", true))
	{
		pData[playerid][pAluminium] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Minyak", true))
	{
		pData[playerid][pMinyak] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Essence", true))
	{
		pData[playerid][pEssence] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Vest", true))
	{
		pData[playerid][pVest] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Kevlar Vest", true))
	{
		pData[playerid][pKevlar] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Clip", true))
	{
		pData[playerid][pClip] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "AK-47", true))
	{
		pData[playerid][pAK47] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Colt 45", true))
	{
		pData[playerid][pColt45] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Desert Eagle", true))
	{
		pData[playerid][pDesertEagle] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Micro SMG", true))
	{
		pData[playerid][pMicroSMG] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Tec-9", true))
	{
		pData[playerid][pTec9] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "MP5", true))
	{
		pData[playerid][pMP5] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Shotgun", true))
	{
		pData[playerid][pShotgun] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Rifle", true))
	{
		pData[playerid][pRifle] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Sniper", true))
	{
		pData[playerid][pSniper] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Knife", true))
	{
		pData[playerid][pKnife] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Katana", true))
	{
		pData[playerid][pKatana] += DroppedItems[id][droppedQuantity];
	}
	else if(!strcmp(name, "Berlian", true))
	{
		pData[playerid][pBerlian] += DroppedItems[id][droppedQuantity];
	}

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM dropped WHERE id= %d", id);
	mysql_tquery(g_SQL, query);

	format(str, sizeof(str), "Received_%dx", DroppedItems[id][droppedQuantity]);
	ShowItemBox(playerid, DroppedItems[id][droppedItem], str, DroppedItems[id][droppedModel], 2);
	return 1;
}

CMD:gotoitem(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "CMD ini untuk admin!");
		
	if(sscanf(params, "d", id))
		return SyntaxMsg(playerid, "/gotoitem [id]");
	if(!Iter_Contains(DROPPED, id)) return ErrorMsg(playerid, "The item drop you specified ID of doesn't exist!");
	SetPlayerPosition(playerid, DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2] + 0.9, 0);
    SetPlayerInterior(playerid, DroppedItems[id][droppedInt]);
    SetPlayerVirtualWorld(playerid, DroppedItems[id][droppedWorld]);
	InfoMsg(playerid, "You has teleport to item drop");
	return 1;
}