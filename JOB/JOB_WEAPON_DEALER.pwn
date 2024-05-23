CreateJoinWeaponDealer()
{
	new strings[128];
	CreateDynamicPickup(1239, 23, 1366.16, -1274.58, 13.54, -1);
	format(strings, sizeof(strings), "Weapon Dealer\n{FFFFFF}/joinjob - to get weapon dealer job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1366.16, -1274.58, 13.54, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Weapon Dealer Job

	//Smuggle Mats 1
	CreateDynamicPickup(1239, 23, 2393.48, -2008.57, 13.34, -1);
	format(strings, sizeof(strings), "Smuggle Mats\n"WHITE_E"Cost: $250\n"WHITE_E"/smugglemats - to take smuggle mats");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 2393.48, -2008.57, 13.34+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	//Smuggle Mats 2
	CreateDynamicPickup(1239, 23, 1421.69, -1318.47, 13.55, -1);
	format(strings, sizeof(strings), "Smuggle Mats\n"WHITE_E"Cost: $250\n"WHITE_E"/smugglemats - to take smuggle mats");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1421.69, -1318.47, 13.55+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
}

CMD:smugglemats(playerid, params[])
{
	if(pData[playerid][pJob] == 13 || pData[playerid][pJob2] == 13)
	{
		if(pData[playerid][pSmuggleMats] == 0)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, 2393.48, -2008.57, 13.34))
			{
				if(pData[playerid][pMoney] < 250)
					return Error(playerid, "Kamu harus memiliki uang sejumlah $250");

				pData[playerid][pSmuggleMats] = 1;

				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 2288.09, -1105.65, 37.97, 3.5);

				GivePlayerMoneyEx(playerid, -250);
				Info(playerid, "Anda membayar "RED_E"$250"WHITE_E" untuk sejumlah bahan mats, antar mereka ke gudang untuk diambil");
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1421.69, -1318.47, 13.55))
			{
				if(pData[playerid][pMoney] < 250)
					return Error(playerid, "Kamu harus memiliki uang sejumlah $250");

				pData[playerid][pSmuggleMats] = 2;

				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 2173.21, -2264.15, 13.34, 3.5);

				GivePlayerMoneyEx(playerid, -250);
				Info(playerid, "Anda membayar "RED_E"$250"WHITE_E" untuk sejumlah bahan mats, antar mereka ke gudang untuk diambil");
			}
			else return Error(playerid, "Kamu harus berada ditempat smuggle mats");
		}
		else return Error(playerid, "Kamu masih memiliki smuggle mats yang belum di selesaikan");
	}
	else return Error(playerid, "Kamu bukan pekerja Weapon Dealer");
	return 1;
}

CMD:sellgun(playerid, params[])
{
	if(pData[playerid][pJob] == 13 || pData[playerid][pJob2] == 13)
	{
		new otherid, weaponname[128], price;
		if(sscanf(params, "ds[128]d", otherid, weaponname, price))
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "|______ Weapons Crafting (%d/40) ______|", pData[playerid][pWeaponSkill]);

			if(pData[playerid][pWeaponSkill] >= 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 1: Bat [50 Mat], Shovel [50 Mat], Golfclub [50 Mat], Poolcue [50 Mat]");
				SendClientMessage(playerid, COLOR_GREY, "Level 1: Katana [50 Mat], Dildo [50 Mat], Flowers [50 Mat], Cane [50 Mat]");
				SendClientMessage(playerid, COLOR_GREY, "Level 1: Colt45 [100 Mat], Sdpistol [150 Mat], Shotgun [200 Mat]");
			}
			if(pData[playerid][pWeaponSkill] >= 10)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 2: MP5 [450 Mat], Deagle [350 Mat]");
			} 
			if(pData[playerid][pWeaponSkill] >= 20)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 3: Uzi [500 Mat], Tec9 [500 Mat]");
			}
			if(pData[playerid][pWeaponSkill] >= 30)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 4: Ak47 [850 Mat]");
			} 
			if(pData[playerid][pWeaponSkill] >= 40)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 5: M4 [850 Mat]");
			}
			Usage(playerid, "/sellgun [playerid/otherid] [weaponname] [price]");
			return 1;
		}

		if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
	        return Error(playerid, "Player tidak berada didekat mu.");

	    if(otherid == playerid)
	        return Error(playerid, "Kamu tidak bisa memeriksa dirimu sendiri.");

	    if(pData[otherid][pLevel] < 3)
			return Error(playerid, "Player tersebut masih dibawah level 3");

		if(!strcmp(weaponname, "bat", true))
		{
			if(pData[playerid][pMaterial] < 50)
				return Error(playerid, "Kamu membutuhkan 50 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");

			if(PlayerHasWeapon(otherid, 5))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 5;
			pData[otherid][pWeaponAmmoOffer] = 1;
			pData[otherid][pWeaponMatsOffer] = 50;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "shovel", true))
		{
			if(pData[playerid][pMaterial] < 50)
				return Error(playerid, "Kamu membutuhkan 50 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 6))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 6;
			pData[otherid][pWeaponAmmoOffer] = 1;
			pData[otherid][pWeaponMatsOffer] = 50;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "golfclub", true))
		{
			if(pData[playerid][pMaterial] < 50)
				return Error(playerid, "Kamu membutuhkan 50 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 2))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");
			
			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 2;
			pData[otherid][pWeaponAmmoOffer] = 1;
			pData[otherid][pWeaponMatsOffer] = 50;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "poolcue", true))
		{
			if(pData[playerid][pMaterial] < 50)
				return Error(playerid, "Kamu membutuhkan 50 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 7))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 7;
			pData[otherid][pWeaponAmmoOffer] = 1;
			pData[otherid][pWeaponMatsOffer] = 50;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "katana", true))
		{
			if(pData[playerid][pMaterial] < 50)
				return Error(playerid, "Kamu membutuhkan 50 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 8))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 8;
			pData[otherid][pWeaponAmmoOffer] = 1;
			pData[otherid][pWeaponMatsOffer] = 50;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "dildo", true))
		{
			if(pData[playerid][pMaterial] < 50)
				return Error(playerid, "Kamu membutuhkan 50 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 10))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 10;
			pData[otherid][pWeaponAmmoOffer] = 1;
			pData[otherid][pWeaponMatsOffer] = 50;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "flowers", true))
		{
			if(pData[playerid][pMaterial] < 50)
				return Error(playerid, "Kamu membutuhkan 50 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 14))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 14;
			pData[otherid][pWeaponAmmoOffer] = 1;
			pData[otherid][pWeaponMatsOffer] = 50;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "cane", true))
		{
			if(pData[playerid][pMaterial] < 50)
				return Error(playerid, "Kamu membutuhkan 50 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 15))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 15;
			pData[otherid][pWeaponAmmoOffer] = 1;
			pData[otherid][pWeaponMatsOffer] = 50;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "colt45", true))
		{
			if(pData[playerid][pMaterial] < 100)
				return Error(playerid, "Kamu membutuhkan 100 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 22))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 22;
			pData[otherid][pWeaponAmmoOffer] = 50;
			pData[otherid][pWeaponMatsOffer] = 100;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "sdpistol", true))
		{
			if(pData[playerid][pMaterial] < 150)
				return Error(playerid, "Kamu membutuhkan 150 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 23))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 23;
			pData[otherid][pWeaponAmmoOffer] = 70;
			pData[otherid][pWeaponMatsOffer] = 150;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "shotgun", true))
		{
			if(pData[playerid][pMaterial] < 200)
				return Error(playerid, "Kamu membutuhkan 200 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 25))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 25;
			pData[otherid][pWeaponAmmoOffer] = 25;
			pData[otherid][pWeaponMatsOffer] = 200;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "mp5", true))
		{
			if(pData[playerid][pWeaponSkill] < 10)
				return Error(playerid, "Kamu membutuhkan weapon skill level 2 untuk membuat senjata MP-5");

			if(pData[playerid][pMaterial] < 450)
				return Error(playerid, "Kamu membutuhkan 450 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 29))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 29;
			pData[otherid][pWeaponAmmoOffer] = 300;
			pData[otherid][pWeaponMatsOffer] = 450;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "deagle", true))
		{
			if(pData[playerid][pWeaponSkill] < 10)
				return Error(playerid, "Kamu membutuhkan weapon skill level 2 untuk membuat senjata Dessert Eagle");

			if(pData[playerid][pMaterial] < 350)
				return Error(playerid, "Kamu membutuhkan 350 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 24))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 24;
			pData[otherid][pWeaponAmmoOffer] = 34;
			pData[otherid][pWeaponMatsOffer] = 350;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "uzi", true))
		{
			if(pData[playerid][pWeaponSkill] < 20)
				return Error(playerid, "Kamu membutuhkan weapon skill level 3 untuk membuat senjata UZI");

			if(pData[playerid][pMaterial] < 550)
				return Error(playerid, "Kamu membutuhkan 550 material untuk membuat senjata tersebut");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 28))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 28;
			pData[otherid][pWeaponAmmoOffer] = 300;
			pData[otherid][pWeaponMatsOffer] = 550;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "tec9", true))
		{
			if(pData[playerid][pWeaponSkill] < 20)
				return Error(playerid, "Kamu membutuhkan weapon skill level 3 untuk membuat senjata TEC-9");

			if(pData[playerid][pMaterial] < 550)
				return Error(playerid, "Kamu membutuhkan 550 material untuk membuat senjata TEC-9");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 32))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 32;
			pData[otherid][pWeaponAmmoOffer] = 300;
			pData[otherid][pWeaponMatsOffer] = 550;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "ak47", true))
		{
			if(pData[playerid][pWeaponSkill] < 30)
				return Error(playerid, "Kamu membutuhkan weapon skill level 4 untuk membuat senjata AK-47");

			if(pData[playerid][pMaterial] < 850)
				return Error(playerid, "Kamu membutuhkan 850 material untuk membuat senjata AK-47");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 30))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 30;
			pData[otherid][pWeaponAmmoOffer] = 200;
			pData[otherid][pWeaponMatsOffer] = 850;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
		else if(!strcmp(weaponname, "m4", true))
		{
			if(pData[playerid][pWeaponSkill] < 40)
				return Error(playerid, "Kamu membutuhkan weapon skill level 5 untuk membuat senjata M4");

			if(pData[playerid][pMaterial] < 850)
				return Error(playerid, "Kamu membutuhkan 850 material untuk membuat senjata M4");

			if(price <= 0)
				return Error(playerid, "Harga tidak boleh dibawah 1!");
			
			if(PlayerHasWeapon(otherid, 31))
				return Error(playerid, "Player yang dituju sudah memiliki senjata tersebut");

			pData[otherid][pWeaponOffer] = playerid;
			pData[otherid][pWeaponidOffer] = 31;
			pData[otherid][pWeaponAmmoOffer] = 200;
			pData[otherid][pWeaponMatsOffer] = 850;
			pData[otherid][pWeaponPriceOffer] = price;
			Info(playerid, "Kamu telah menawarkan senjata %s kepada %s dengan harga "GREEN_LIGHT"%s"WHITE_E"", ReturnWeaponName(pData[otherid][pWeaponidOffer]), ReturnName(otherid), FormatMoney(pData[otherid][pWeaponPriceOffer]));
			Info(otherid, "%s telah menawarkan senjata %s seharga "GREEN_LIGHT"%s"WHITE_E" (/accept weapon) untuk menerimanya", ReturnName(playerid), ReturnWeaponName(pData[otherid][pWeaponidOffer]), FormatMoney(pData[otherid][pWeaponPriceOffer]));
		}
	}
	else return Error(playerid, "Kamu bukan pekerja Weapon Dealer");
	return 1;
}