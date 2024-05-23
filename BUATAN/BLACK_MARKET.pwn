/*

	BLACKMARKET

*/

#include <YSI_Coding\y_hooks>

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, -2056.4873,1787.1152,860.6690))
        {
        	return callcmd::crafting(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.5, -2056.4863,1791.8389,860.6690))
        {
        	return callcmd::craftingam(playerid, "");
        }
	}
	return 1;
}

CMD:crafting(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, -2056.4873,1787.1152,860.6690)) return ErrorMsg(playerid, "Kamu harus diblackmarket!");
	if(pData[playerid][pLevel] < 5) return ErrorMsg(playerid, "Kamu tidak memiliki skill creategun.");
	if(pData[playerid][pFamily] == -1) return ErrorMsg(playerid, "Kamu Bukan Family");
	if(pData[playerid][pLoading] == true) return WarningMsg(playerid, "Anda masih crafting");
	
	new Dstring[512];
	format(Dstring, sizeof(Dstring), "Senjatat\tBahan #1\tBahan #2\tBahan #3\n\
	{ffffff}%sAK-47\t350x Mat\t85x Comp\t25x Besi\n");
	format(Dstring, sizeof(Dstring), "{ffffff}%sDesert Eagle\t300x Mat\t65x Comp\t20x Besi\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sMicro SMG/Uzi\t250x Mat\t55x Comp\t15x Besi\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sMP5\t200x Mat\t70x Comp\t30x Besi\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sColt 45\t100x Mat\t45x Comp\t30x Besi\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sTec-9\t130x Mat\t55x Comp\t39x Besi\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sShotgun\t500x Mat\t300x Comp\t60x Besi\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sRifle\t350x Mat\t250x Comp\t45x Besi\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sSniper\t500x Mat\t350x Comp\t70x Besi\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sPatched Bomb\t355x Mat\t90x Alum\t60x Besi\n", Dstring);
	ShowPlayerDialog(playerid, DIALOG_BLACKMARKET, DIALOG_STYLE_TABLIST_HEADERS, "Craffting", Dstring, "Create", "Cancel");
	return 1;
}

CMD:craftingam(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, -2056.4863,1791.8389,860.6690)) return ErrorMsg(playerid, "Kamu harus diblackmarket!");
	if(pData[playerid][pLevel] < 5) return ErrorMsg(playerid, "Kamu tidak memiliki skill creategun.");
	if(pData[playerid][pFamily] == -1) return ErrorMsg(playerid, "Kamu Bukan Family");
	if(pData[playerid][pLoading] == true) return WarningMsg(playerid, "Anda masih crafting");

	new Dstring[512];
	format(Dstring, sizeof(Dstring), "Barang\tBahan #1\tBahan #2\tBahan #3\n\
	{ffffff}%sClip (ammo)\t55x Mat\t20x Alum\t40x Besi\n");
	format(Dstring, sizeof(Dstring), "{ffffff}%sKevlar Vest\t20x Pakaian\t25x Besi\t15x Kain\n", Dstring);
	ShowPlayerDialog(playerid, DIALOG_BLACKMARKET1, DIALOG_STYLE_TABLIST_HEADERS, "Craffting", Dstring, "Create", "Cancel");
	return 1;
}

function crafting(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
	}
	return 1;
}

function CreateGun(playerid, gunid, ammo)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	if(gunid == 0 || ammo == 0) return 0;
	{		
		GivePlayerWeaponEx(playerid, gunid, ammo);
		
		Info(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CreateBomb(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;	
	{
		Info(playerid, "Anda telah berhasil membuat bomb.");
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Bomb Created!");
		ClearAnimations(playerid);
		pData[playerid][pBomb]++;
		//Inventory_Add(playerid, "Bomb", 363, 1);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CreateClipPistol(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{
		Info(playerid, "Anda telah berhasil membuat clip pistol.");
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Clip Pistol Created!");
		ClearAnimations(playerid);
		pData[playerid][pAmmoPistol]++;
		//Inventory_Add(playerid, "Clip Pistol", 19995, 1);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CreateClipRifle(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{
		Info(playerid, "Anda telah berhasil membuat clip Rifle.");
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Clip Rifle Created!");
		ClearAnimations(playerid);
		pData[playerid][pAmmoRifle]++;
		//Inventory_Add(playerid, "Clip Rifle", 19995, 1);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CraftAK47(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pAK47]++;
		ShowItemBox(playerid, "AK-47", "Added_1x", 355, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CraftDE(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pDesertEagle]++;
		ShowItemBox(playerid, "Desert Eagle", "Added_1x", 348, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CraftUzi(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pMicroSMG]++;
		ShowItemBox(playerid, "Micro SMG", "Added_1x", 352, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CraftMP5(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pMP5]++;
		ShowItemBox(playerid, "MP5", "Added_1x", 353, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function Colt45(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pColt45]++;
		ShowItemBox(playerid, "Colt 45", "Added_1x", 346, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function Tec9mm(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pTec9]++;
		ShowItemBox(playerid, "Tec-9", "Added_1x", 372, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function Shotguns(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pShotgun]++;
		ShowItemBox(playerid, "Shotgun", "Added_1x", 349, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function Criffle(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pRifle]++;
		ShowItemBox(playerid, "Rifle", "Added_1x", 357, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CSniper(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat senjata ilegal.");
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		pData[playerid][pSniper]++;
		ShowItemBox(playerid, "Sniper", "Added_1x", 358, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CraftClip(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat clip senjata.");
		InfoTD_MSG(playerid, 8000, "Clip Created!");
		pData[playerid][pClip]++;
		ShowItemBox(playerid, "Clip", "Added_1x", 19995, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

function CraftKevar(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pCraftingtime])) return 0;
	{	
		SuccesMsg(playerid, "Anda telah berhasil membuat Kevlar Vest.");
		InfoTD_MSG(playerid, 8000, "Kevlar Vest Created!");
		pData[playerid][pKevlar]++;
		ShowItemBox(playerid, "Kevlar Vest", "Added_1x", 19515, 2);
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		pData[playerid][pLoading] = false;
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_BLACKMARKET1)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 55) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 55).");
					if(pData[playerid][pAluminium] < 20) return ErrorMsg(playerid, "Alumunium tidak cukup!(Butuh: 20).");
					if(pData[playerid][pBesi] < 40) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 40).");
					
					pData[playerid][pMaterial] -= 55;
					pData[playerid][pAluminium] -= 20;
					pData[playerid][pBesi] -= 40;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);

					ShowProgressbar(playerid, "Crafting Clip", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("CraftClip", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Gun", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_AK47, 200);

					return 1;
				}
				case 1:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pPakaian] < 20) return ErrorMsg(playerid, "Pakaian tidak cukup!(Butuh: 20).");
					if(pData[playerid][pBesi] < 25) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 25).");
					if(pData[playerid][pKain] < 15) return ErrorMsg(playerid, "Kain tidak cukup!(Butuh: 15).");
					
					pData[playerid][pPakaian] -= 20;
					pData[playerid][pBesi] -= 25;
					pData[playerid][pKain] -= 15;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);

					ShowProgressbar(playerid, "Crafting Kevlar", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("CraftKevar", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Gun", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_AK47, 200);

					return 1;
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BLACKMARKET)
	{
		if(response)
		{
			switch(listitem)
			{
				//AK 47
				case 0:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 350) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 350).");
					if(pData[playerid][pComponent] < 85) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 85).");
					if(pData[playerid][pBesi] < 25) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 25).");
					
					pData[playerid][pMaterial] -= 350;
					pData[playerid][pComponent] -= 85;
					pData[playerid][pBesi] -= 25;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 350 material dan 85 component!");

					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("CraftAK47", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Gun", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_AK47, 200);

					return 1;
				}
				case 1:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 300) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 300).");
					if(pData[playerid][pComponent] < 65) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 65).");
					if(pData[playerid][pBesi] < 20) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 20).");
					
					pData[playerid][pMaterial] -= 300;
					pData[playerid][pComponent] -= 65;
					pData[playerid][pBesi] -= 20;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 300 material dan 65 component!");
					
					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("CraftDE", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Gun", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_DEAGLE, 34);

					return 1;
				}
				case 2:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 250) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 250).");
					if(pData[playerid][pComponent] < 55) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 55).");
					if(pData[playerid][pBesi] < 15) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 15).");
					
					pData[playerid][pMaterial] -= 250;
					pData[playerid][pComponent] -= 55;
					pData[playerid][pBesi] -= 15;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 250 material dan 55 component!");
					
					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("CraftUzi", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Gun", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_UZI, 200);

					return 1;
				}
				case 3:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 200) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 200).");
					if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 70).");
					if(pData[playerid][pBesi] < 30) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 30).");
					
					pData[playerid][pMaterial] -= 200;
					pData[playerid][pComponent] -= 70;
					pData[playerid][pBesi] -= 30;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 200 material dan 70 component!");
					
					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("CraftMP5", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Gun", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_MP5, 200);

					return 1;
				}
				case 4:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 100) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 100).");
					if(pData[playerid][pComponent] < 45) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 45).");
					if(pData[playerid][pBesi] < 30) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 30).");
					
					pData[playerid][pMaterial] -= 100;
					pData[playerid][pComponent] -= 45;
					pData[playerid][pBesi] -= 30;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 100 material dan 45 component!");
					
					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("Colt45", 10000, false, "d", playerid);

					//pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_SILENCED, 200);

					return 1;
				}
				case 5:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 130) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 130).");
					if(pData[playerid][pComponent] < 55) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 55).");
					if(pData[playerid][pBesi] < 39) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 39).");
					
					pData[playerid][pMaterial] -= 130;
					pData[playerid][pComponent] -= 55;
					pData[playerid][pBesi] -= 39;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					//Info(playerid, "Anda membuat senjata ilegal dengan 355 material dan 90 component");
					
					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("Tec9mm", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Bomb", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateBomb", 10000, false, "i", playerid);

					return 1;
				}
				case 6:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 300) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 300).");
					if(pData[playerid][pBesi] < 60) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 60).");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 300;
					pData[playerid][pBesi] -= 60;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					
					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("Shotguns", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Clip Pistol", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateClipPistol", 10000, false, "i", playerid);

					return 1;
				}
				case 7:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 350) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 350).");
					if(pData[playerid][pComponent] < 250) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 250).");
					if(pData[playerid][pBesi] < 45) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 45).");
					
					pData[playerid][pMaterial] -= 350;
					pData[playerid][pComponent] -= 250;
					pData[playerid][pBesi] -= 45;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					
					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("Criffle", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Clip Rifle", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateClipRifle", 10000, false, "i", playerid);

					return 1;
				}
				case 8:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 350) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 350).");
					if(pData[playerid][pBesi] < 70) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 70).");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 350;
					pData[playerid][pBesi] -= 70;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					
					ShowProgressbar(playerid, "Crafting Gun", 10);
            		pData[playerid][pCraftingtime] = SetTimerEx("CSniper", 10000, false, "d", playerid);

					//ShowProgressbar(playerid, "Crafting Clip Rifle", 10);
					//pData[playerid][pCraftingtime] = SetTimerEx("CreateClipRifle", 10000, false, "i", playerid);

					return 1;
				}
				case 9:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 355) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 355).");
					if(pData[playerid][pAluminium] < 90) return ErrorMsg(playerid, "Aluminium tidak cukup!(Butuh: 90).");
					if(pData[playerid][pBesi] < 60) return ErrorMsg(playerid, "Besi tidak cukup!(Butuh: 60).");
					
					pData[playerid][pMaterial] -= 355;
					pData[playerid][pAluminium] -= 90;
					pData[playerid][pBesi] -= 60;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					
					ShowProgressbar(playerid, "Crafting Bomb", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateBomb", 10000, false, "i", playerid);

					return 1;
				}
			}
		}
	}
	return 1;
}

/*hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_BLACKMARKET)
	{
		if(response)
		{
			switch(listitem)
			{
				//AK 47
				case 0:
				{
					if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 350) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 350).");
					if(pData[playerid][pComponent] < 85) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 85).");
					
					pData[playerid][pMaterial] -= 350;
					pData[playerid][pComponent] -= 85;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 350 material dan 85 component!");
					//Showbar(playerid, 10, "Crafting Gun", "crafting");
					ShowProgressbar(playerid, "Crafting Gun", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_AK47, 200);

					return 1;
				}
				case 1:
				{
					if(pData[playerid][pLoading] == true) return Error(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 300) return Error(playerid, "Material tidak cukup!(Butuh: 300).");
					if(pData[playerid][pComponent] < 65) return Error(playerid, "Component tidak cukup!(Butuh: 65).");
					
					pData[playerid][pMaterial] -= 300;
					pData[playerid][pComponent] -= 65;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 300 material dan 65 component!");
					//Showbar(playerid, 10, "Crafting Gun", "crafting");
					ShowProgressbar(playerid, "Crafting Gun", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_DEAGLE, 34);

					return 1;
				}
				case 2:
				{
					if(pData[playerid][pLoading] == true) return Error(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 250) return Error(playerid, "Material tidak cukup!(Butuh: 250).");
					if(pData[playerid][pComponent] < 55) return Error(playerid, "Component tidak cukup!(Butuh: 55).");
					
					pData[playerid][pMaterial] -= 250;
					pData[playerid][pComponent] -= 55;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 250 material dan 55 component!");
					//Showbar(playerid, 10, "Crafting Gun", "crafting");
					ShowProgressbar(playerid, "Crafting Gun", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_UZI, 200);

					return 1;
				}
				case 3:
				{
					if(pData[playerid][pLoading] == true) return Error(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 200) return Error(playerid, "Material tidak cukup!(Butuh: 200).");
					if(pData[playerid][pComponent] < 70) return Error(playerid, "Component tidak cukup!(Butuh: 70).");
					
					pData[playerid][pMaterial] -= 200;
					pData[playerid][pComponent] -= 70;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 200 material dan 70 component!");
					//Showbar(playerid, 10, "Crafting Gun", "crafting");
					ShowProgressbar(playerid, "Crafting Gun", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_MP5, 200);

					return 1;
				}
				case 4:
				{
					if(pData[playerid][pLoading] == true) return Error(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 100) return Error(playerid, "Material tidak cukup!(Butuh: 100).");
					if(pData[playerid][pComponent] < 45) return Error(playerid, "Component tidak cukup!(Butuh: 45).");
					
					pData[playerid][pMaterial] -= 100;
					pData[playerid][pComponent] -= 45;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 100 material dan 45 component!");
					//Showbar(playerid, 10, "Crafting Gun", "crafting");
					ShowProgressbar(playerid, "Crafting Gun", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateGun", 10000, false, "idd", playerid, WEAPON_SILENCED, 200);

					return 1;
				}
				case 5:
				{
					if(pData[playerid][pLoading] == true) return Error(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 355) return Error(playerid, "Material tidak cukup!(Butuh: 355).");
					if(pData[playerid][pComponent] < 90) return Error(playerid, "Component tidak cukup!(Butuh: 90).");
					
					pData[playerid][pMaterial] -= 355;
					pData[playerid][pComponent] -= 90;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat senjata ilegal dengan 355 material dan 90 component");
					//Showbar(playerid, 10, "Crafting Bomb", "crafting");
					ShowProgressbar(playerid, "Crafting Bomb", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateBomb", 10000, false, "i", playerid);

					return 1;
				}
				case 6:
				{
					if(pData[playerid][pLoading] == true) return Error(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 55) return Error(playerid, "Material tidak cukup!(Butuh: 55).");
					if(pData[playerid][pComponent] < 20) return Error(playerid, "Component tidak cukup!(Butuh: 20).");
					
					pData[playerid][pMaterial] -= 55;
					pData[playerid][pComponent] -= 20;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat clip pintol dengan 55 material dan 20 component");
					//Showbar(playerid, 10, "Crafting Clip Pistol", "crafting");
					ShowProgressbar(playerid, "Crafting Clip Pistol", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateClipPistol", 10000, false, "i", playerid);

					return 1;
				}
				case 7:
				{
					if(pData[playerid][pLoading] == true) return Error(playerid, "Anda masih crafting");
					if(pData[playerid][pMaterial] < 60) return Error(playerid, "Material tidak cukup!(Butuh: 60).");
					if(pData[playerid][pComponent] < 25) return Error(playerid, "Component tidak cukup!(Butuh: 25).");
					
					pData[playerid][pMaterial] -= 60;
					pData[playerid][pComponent] -= 25;
					pData[playerid][pLoading] = true;
					
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
					Info(playerid, "Anda membuat clip rifle dengan 60 material dan 25 component");
					//Showbar(playerid, 10, "Crafting Clip Rifle", "crafting");
					ShowProgressbar(playerid, "Crafting Clip Rifle", 10);
					pData[playerid][pCraftingtime] = SetTimerEx("CreateClipRifle", 10000, false, "i", playerid);

					return 1;
				}
			}
		}
	}
	return 1;
}*/