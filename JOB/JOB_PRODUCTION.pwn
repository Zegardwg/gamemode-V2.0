// -279.67, -2148.42, 28.54 buy product
//-249.79, -2148.05, 29.30 point1
//-244.14, -2146.05, 29.30 point2
//-250.88, -2143.23, 29.32 point 3
//-245.74, -2141.65, 29.32 point4

/*AddPlayerClass(300,-2148.6230,-241.8216,36.5156,271.1692,0,0,0,0,0,0); // JoinJOB Produc new ++
AddPlayerClass(300,-2157.0347,-247.0754,36.5156,174.8829,0,0,0,0,0,0); // c1 ++
AddPlayerClass(300,-2160.5552,-248.9859,36.5156,8.1364,0,0,0,0,0,0); // c2 ++
AddPlayerClass(300,-2164.1355,-247.0717,36.5156,189.2029,0,0,0,0,0,0); // c3 ++
AddPlayerClass(300,-2167.7087,-248.9825,36.5156,0.5535,0,0,0,0,0,0); // c4 ++
AddPlayerClass(300,-2146.9463,-189.0441,35.3203,178.2556,0,0,0,0,0,0); // jual product
AddPlayerClass(300,242.1874,118.5328,1003.2188,359.5511,0,0,0,0,0,0); // NewlumberLic
AddPlayerClass(300,250.3115,118.5369,1003.2188,8.5129,0,0,0,0,0,0); // Newtruck lic*/

CreateJoinProductionPoint()
{
	//JOBS
	new strings[128];
	format(strings, sizeof(strings), "Production Job\n{FFFFFF}/createproduct");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -249.88, -2148.07, 29.30, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job

	format(strings, sizeof(strings), "Production Job\n{FFFFFF}/createproduct");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -244.28, -2146.10, 29.30, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job

	format(strings, sizeof(strings), "Production Job\n{FFFFFF}/createproduct");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -250.99, -2143.27, 29.32, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job

	format(strings, sizeof(strings), "Production Job\n{FFFFFF}/createproduct");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -245.71, -2141.63, 29.32, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job

	CreateDynamicPickup(1239, 23, 359.63, -2032.09, 7.83, -1);
	format(strings, sizeof(strings), "Tekan "LG_E"Y {ffffff}Untuk Menjuak ikan");
	//format(strings, sizeof(strings), "Production Job\n{FFFFFF}/sellfish - for sell a fish");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 359.63, -2032.09, 7.83, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // FishFactory job
}


CMD:createproduct(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
	if(pData[playerid][pJob] == 6 || pData[playerid][pJob2] == 6)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.88, -2148.07, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -250.99, -2143.27, 29.32)
		|| IsPlayerInRangeOfPoint(playerid, 2.0, -244.28, -2146.10, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.71, -2141.63, 29.32))
		{
			new type;
			if(sscanf(params, "d", type)) return Usage(playerid, "/createproduct [type, 1.Food 2.Clothes 3.Equipment");

			if(type < 1 || type > 3) return ShowNotifError(playerid, "Invalid type id.", 10000);

			if(type == 1)
			{
				if(pData[playerid][pLoading] == true) return ShowNotifError(playerid, "Anda Masih Membuat Food", 10000);
				if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
				if(pData[playerid][pFood] < 40) return ShowNotifError(playerid, "Food tidak cukup!(Minimal: 40).", 10000);
				if(pData[playerid][CarryProduct] != 0) return ShowNotifError(playerid, "Anda sedang membawa sebuah product", 10000);
				pData[playerid][pFood] -= 40;

				TogglePlayerControllable(playerid, 0);
				pData[playerid][pLoading] = true;
				Info(playerid, "Anda sedang memproduksi bahan makanan dengan 40 food!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 1);
				//Showbar(playerid, 20, "MEMBUAT FOOD", "CreateProduct");
				ShowProgressbar(playerid, "MEMBUAT FOOD", 20);
			}
			else if(type == 2)
			{
				if(pData[playerid][pLoading] == true) return ShowNotifError(playerid, "Anda Masih Membuat Baju", 10000);
				if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
				if(pData[playerid][pMaterial] < 40) return ShowNotifError(playerid, "Material tidak cukup!(Butuh: 40).", 10000);
				if(pData[playerid][CarryProduct] != 0) return ShowNotifError(playerid, "Anda sedang membawa sebuah product", 10000);
				pData[playerid][pMaterial] -= 40;

				TogglePlayerControllable(playerid, 0);
				pData[playerid][pLoading] = true;
				Info(playerid, "Anda sedang memproduksi baju dengan 40 material!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 2);
				//Showbar(playerid, 20, "MEMBUAT BAJU", "CreateProduct");
				ShowProgressbar(playerid, "MEMBUAT BAJU", 20);

			}
			else if(type == 3)
			{
				if(pData[playerid][pLoading] == true) return ShowNotifError(playerid, "Anda Masih Membuat Peralatan", 10000);
				if(pData[playerid][pActivityTime] > 5) return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);
				if(pData[playerid][pMaterial] < 40) return ShowNotifError(playerid, "Material tidak cukup!(Butuh: 40).", 10000);
				if(pData[playerid][pComponent] < 20) return ShowNotifError(playerid, "Component tidak cukup!(Butuh: 20).", 10000);
				if(pData[playerid][CarryProduct] != 0) return ShowNotifError(playerid, "Anda sedang membawa sebuah product", 10000);
				pData[playerid][pMaterial] -= 40;
				pData[playerid][pComponent] -= 20;

				TogglePlayerControllable(playerid, 0);
				pData[playerid][pLoading] = true;
				Info(playerid, "Anda sedang memproduksi equipment dengan 40 material dan 20 component!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 3);
				//Showbar(playerid, 20, "MEMBUAT PERALATAN", "CreateProduct");
				ShowProgressbar(playerid, "MEMBUAT PERALATAN", 20);
			}
		}
		else return Error(playerid, "You're not near in production warehouse.");
	}
	else Error(playerid, "Anda bukan pekerja sebagai operator produksi.");
	return 1;
}

function CreateProduct(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pProducting])) return 0;
	if(pData[playerid][pJob] == 6 || pData[playerid][pJob2] == 6)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.88, -2148.07, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -250.99, -2143.27, 29.32)
			|| IsPlayerInRangeOfPoint(playerid, 2.0, -244.28, -2146.10, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.71, -2141.63, 29.32))
			{
				if(type == 1)
				{
					SetPlayerAttachedObject(playerid, 9, 2453, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					pData[playerid][CarryProduct] = 1;
					ShowNotifSukses(playerid, "Anda telah berhasil membuat bahan makanan, /sellproduct untuk menjualnya.", 10000);
					TogglePlayerControllable(playerid, 1);
					ShowNotifInfo(playerid, "Food Created!", 10000);
					KillTimer(pData[playerid][pProducting]);
					pData[playerid][pLoading] = false;
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else if(type == 2)
				{
					SetPlayerAttachedObject(playerid, 9, 2391, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					pData[playerid][CarryProduct] = 2;
					ShowNotifSukses(playerid, "Anda telah berhasil membuat product baju, /sellproduct untuk menjualnya.", 10000);
					TogglePlayerControllable(playerid, 1);
					ShowNotifInfo(playerid, "Clothes Created!", 10000);
					KillTimer(pData[playerid][pProducting]);
					pData[playerid][pLoading] = false;
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else if(type == 3)
				{
					SetPlayerAttachedObject(playerid, 9, 2912, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					pData[playerid][CarryProduct] = 3;
					ShowNotifSukses(playerid, "Anda telah berhasil membuat product equipment, /sellproduct untuk menjualnya.", 10000);
					TogglePlayerControllable(playerid, 1);
					ShowNotifInfo(playerid, "Equipment Created!", 10000);
					KillTimer(pData[playerid][pProducting]);
					pData[playerid][pLoading] = false;
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else
				{
					KillTimer(pData[playerid][pProducting]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					return 1;
				}
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.88, -2148.07, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -250.99, -2143.27, 29.32)
			|| IsPlayerInRangeOfPoint(playerid, 2.0, -244.28, -2146.10, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.71, -2141.63, 29.32))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}

CMD:sellproduct(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -280.74, -2149.14, 28.54)) return ShowNotifError(playerid, "You're not near in production warehouse.", 10000);
	if(pData[playerid][CarryProduct] == 0) return ShowNotifError(playerid, "You are not holding any products.", 10000);

	if(pData[playerid][CarryProduct] == 1)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		pData[playerid][CarryProduct] = 0;

		pData[playerid][pJobTime] = 20;
		pData[playerid][pHunger] -= 3;
		pData[playerid][pEnergy] -= 6;

		GivePlayerMoneyEx(playerid, productprice1);

		Product += 10;
		Server_MinMoney(productprice1);
		Info(playerid, "Anda menjual 10 bahan makanan dengan harga "GREEN_E"%s", FormatMoney(productprice1));
	}
	else if(pData[playerid][CarryProduct] == 2)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		pData[playerid][CarryProduct] = 0;

		pData[playerid][pJobTime] = 40;
		pData[playerid][pHunger] -= 3;
		pData[playerid][pEnergy] -= 6;

		GivePlayerMoneyEx(playerid, productprice2);

		Product += 10;
		Server_MinMoney(productprice2);
		Info(playerid, "Anda menjual 10 product baju dengan harga "GREEN_E"%s", FormatMoney(productprice2));
	}
	else if(pData[playerid][CarryProduct] == 3)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		pData[playerid][CarryProduct] = 0;

		pData[playerid][pJobTime] = 60;
		pData[playerid][pHunger] -= 3;
		pData[playerid][pEnergy] -= 6;
		
		GivePlayerMoneyEx(playerid, productprice3);

		Product += 10;
		Server_MinMoney(productprice3);
		Info(playerid, "Anda menjual 10 product equipment dengan harga "GREEN_E"%s", FormatMoney(productprice3));
	}
	return 1;
}
