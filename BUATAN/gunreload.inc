//#include <YSI_Coding\y_hooks>

/*hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys & KEY_YES)
	{
	    if (PlayerData[playerid][pUsedMagazine])
	    {
	        new weaponid = PlayerData[playerid][pHoldWeapon];

	        switch (weaponid)
	        {
			    case 22:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Colt 45");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 64);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 24:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Desert Eagle");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 64);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 25:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Shotgun");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 64);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 28:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Micro SMG");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 29:
       			{
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "MP5");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 32:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Tec-9");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 30:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "AK-47");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 33:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Rifle");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
		        case 34:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Sniper");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 50);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
			}
			return 1;
	    }
	}
    if (newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if (PlayerData[playerid][pHoldWeapon] > 0)
		{
		    if (PlayerData[playerid][pUsedMagazine])
      			Inventory_Add(playerid, "Clip", 19995);

		    HoldWeapon(playerid, 0);
			SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Menyimpan senjata kedalam inventory dengan bantuan kedua tangan.");
            SetPlayerChatBubble(playerid, "> Menyimpan senjata yang ia miliki kedalam inventory <", COLOR_PURPLE, 30.0, 5000);
		    }
		return 1;
	}
    return 1;
}*/

stock EquipWeapon(playerid, weapon[])
{

	if (IsPlayerInAnyVehicle(playerid))
	    return ErrorMsg(playerid, "Kamu harus turun dari kendaraan!");

	if (!strcmp(weapon, "Colt 45", true))
	{
	    if(pData[playerid][pColt45] < 1) 
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 22))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 22);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}MengeluarkanColt 45 dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Colt 45 yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Desert Eagle", true))
	{
		if(pData[playerid][pDesertEagle] < 1)
	    //if (!PlayerHasItem(playerid, "Desert Eagle"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 24))
	        return ErrorMsg(playerid, "You already have this weapon.");

	    if (PlayerHasWeapon(playerid, 24))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 24);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Desert Eagle dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Desert Eagle yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Shotgun", true))
	{
		if(pData[playerid][pShotgun] < 1)
	    //if (!PlayerHasItem(playerid, "Shotgun"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 25))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 25);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Shotgun dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Shotgun yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Micro SMG", true))
	{
		if(pData[playerid][pMicroSMG] < 1)
	    //if (!PlayerHasItem(playerid, "Micro SMG"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 28))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 28);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Micro SMG dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Micro SMG yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Tec-9", true))
	{
		if(pData[playerid][pTec9] < 1)
	    //if (!PlayerHasItem(playerid, "Tec-9"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 32))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 32);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Tec-9 dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Tec-9 yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "MP5", true))
	{
		if(pData[playerid][pMP5] < 1)
	    //if (!PlayerHasItem(playerid, "MP5"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 29))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 29);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan MP5 dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan MP5 yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "AK-47", true))
	{
		if(pData[playerid][pAK47] < 1)
	    //if (!PlayerHasItem(playerid, "AK-47"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 30))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 30);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan AK-47 dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan AK-47 yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Rifle", true))
	{
		if(pData[playerid][pRifle] < 1)
	    //if (!PlayerHasItem(playerid, "Rifle"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 33))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 33);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Rifle dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Rifle yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Sniper", true))
	{
		if(pData[playerid][pSniper] < 1)
	    //if (!PlayerHasItem(playerid, "Sniper"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 34))
	        return ErrorMsg(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return ErrorMsg(playerid, "You're already holding a weapon (press 'Y' to put it away).");

		HoldWeapon(playerid, 34);

		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Sniper dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Sniper yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Golf Club", true))
	{
		if(pData[playerid][pGolfClub] < 1)
	    //if (!PlayerHasItem(playerid, "Golf Club"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 2))
	        return ErrorMsg(playerid, "You already have this weapon.");

	    GiveWeaponToPlayer(playerid, 2, 1);

	    Inventory_Remove(playerid, "Golf Club");
		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Stik Golf dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Stik Golf yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Knife", true))
	{
		if(pData[playerid][pKnife] < 1)
	    //if (!PlayerHasItem(playerid, "Knife"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 4))
	        return ErrorMsg(playerid, "You already have this weapon.");

	    GiveWeaponToPlayer(playerid, 4, 1);

	    Inventory_Remove(playerid, "Knife");
		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Pisau dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Pisau yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	else if (!strcmp(weapon, "Shovel", true))
	{
		if(pData[playerid][pShovel] < 1)
	    //if (!PlayerHasItem(playerid, "Shovel"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 6))
	        return ErrorMsg(playerid, "You already have this weapon.");

	    GiveWeaponToPlayer(playerid, 6, 1);

	    Inventory_Remove(playerid, "Shovel");
		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Sekop dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Sekop yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
    else if (!strcmp(weapon, "Katana", true))
	{
		if(pData[playerid][pKatana] < 1)
	    //if (!PlayerHasItem(playerid, "Katana"))
	        return ErrorMsg(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 8))
	        return ErrorMsg(playerid, "You already have this weapon.");

	    GiveWeaponToPlayer(playerid, 8, 1);

	    Inventory_Remove(playerid, "Katana");
		SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Mengeluarkan Katana dan memegangnya.");
        SetPlayerChatBubble(playerid, "> Mengeluarkan Katana yang ia miliki dan memegangnya <", COLOR_PURPLE, 30.0, 5000);
	}
	return 1;
}

stock HoldWeapon(playerid, weaponid)
{
	RemovePlayerAttachedObject(playerid, 9);

	PlayerData[playerid][pHoldWeapon] = weaponid;
    PlayerData[playerid][pUsedMagazine] = 0;

	if (weaponid != 0)
	{
		SetPlayerAttachedObject(playerid, 9, GetWeaponModelAttch(weaponid), 6);
  		SetPlayerArmedWeapon(playerid, 0);
	}
	return 1;
}

stock GetWeaponModelAttch(weaponid) {
    new const g_aWeaponModels[] = {
		0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324,
		325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352,
		353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366,
		367, 368, 368, 371
    };
    if (1 <= weaponid <= 46)
        return g_aWeaponModels[weaponid];

	return 0;
}

CMD:usemag(playerid, params[])
{
	new weaponid = PlayerData[playerid][pHoldWeapon];

	if (!weaponid)
	    return ErrorMsg(playerid, "You are not holding any empty weapon.");

	if(pData[playerid][pClip] < 1)
	//if (!PlayerHasItem(playerid, "Clip"))
	    return ErrorMsg(playerid, "You don't have any weapon clip.");

	if (PlayerData[playerid][pUsedMagazine])
	    return ErrorMsg(playerid, "You have already used a clip on this weapon.");

	switch (weaponid)
	{
	    case 22:
	    {
		    PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

			pData[playerid][pClip]--;

		}
		case 24:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
		case 25:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
		case 27:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
		case 28:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
		case 29:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
		case 32:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
		case 30:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
		case 33:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
        case 34:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        pData[playerid][pClip]--;

		}
		default:
		    return ErrorMsg(playerid, "You can't attach a clip to this weapon.");
	}
	return 1;
}
