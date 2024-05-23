CreateJoinDrugDealer()
{
	new strings[254];

	//JOIN JOB
	CreateDynamicPickup(1239, 23, 2165.21, -1673.13, 15.07, -1);
	format(strings, sizeof(strings), "Drug Dealer\n{FFFFFF}/joinjob - to get drug dealer job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 2165.21, -1673.13, 15.07, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

	//DRUG SMUGGLING
	CreateDynamicPickup(1575, 23, 51.96, -292.28, 1.70, -1);
	format(strings, sizeof(strings), "Drug Smuggling\n"WHITE_E"Cost: $500\n/smuggledrugs [ephedrine/cocaine]");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 51.96, -292.28, 1.70+0.2, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

	//COOK METH
	CreateDynamicPickup(1577, 23, 1.21, 2.80, 999.42, -1);
	format(strings, sizeof(strings), "Cooking Meth"WHITE_E"\nRequires ephedrine\n/cookmeth - to begin cooking.");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1.21, 2.80, 999.42+0.2, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
}

CMD:buydrugs(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) 
		return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
	
	if(pData[playerid][pJob] == 12 || pData[playerid][pJob2] == 12)
	{
		new type[128], ammount;
		if(sscanf(params, "s[128]d", type, ammount))
			return Usage(playerid, "/buydrugs [ephedrine/cocaine] [ammount]");

		if(!strcmp(type, "ephedrine", true))
		{
			if(!IsPlayerInRangeOfPoint(playerid, 3.5, 323.81, 1117.20, 1083.88))
				return Error(playerid, "Kamu tidak berada di dekat point pembelian ephedrine");

			if(ammount * EphedrinePrice > pData[playerid][pMoney])
			 	return Error(playerid, "Uang kamu tidak mencukupi");

			if(ammount <= 0)
			 	return Error(playerid, "jumlah harus diatas 0!");

			if(ammount > Ephedrine)
				return Error(playerid, "Jumlah stok ephedrine tidak mencukupi");

			//Inventory_Add(playerid, "Ephedrine", 1580, ammount);
			pData[playerid][pEphedrine] += ammount;
			new str[500];
			format(str, sizeof(str), "Received_%dx", ammount);
			ShowItemBox(playerid, "Ephedrine", str, 1580, 2);
			Ephedrine -= ammount;
			GivePlayerMoneyEx(playerid, -ammount * EphedrinePrice);
			Server_AddMoney(ammount * EphedrinePrice);
			Info(playerid, "Kamu berhasil membeli %d ephedrine dengan harga %s", ammount, FormatMoney(EphedrinePrice * ammount));
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s membeli %d raw ephedrine dengan harga %s", ReturnName(playerid), ammount, FormatMoney(EphedrinePrice * ammount));
		}
		else if(!strcmp(type, "cocaine", true))
		{
			if(!IsPlayerInRangeOfPoint(playerid, 3.5, 330.9419,1129.3291,1083.8828))
				return Error(playerid, "Kamu tidak berada di dekat point pembelian cocaine");

			if(ammount * CocainePrice > pData[playerid][pMoney])
			 	return Error(playerid, "Uang kamu tidak mencukupi");

			if(ammount <= 0)
			 	return Error(playerid, "jumlah harus diatas 0!");

			if(ammount > Cocaine)
				return Error(playerid, "Jumlah stok cocaine tidak mencukupi");

			//new dapetbatu = RandomEx(2,6);
		    pData[playerid][pCocaine] += ammount;
		    new str[500];
			format(str, sizeof(str), "Received_%dx", ammount);
			ShowItemBox(playerid, "Cocaine", str, 1580, 2);
			Cocaine -= ammount;
			GivePlayerMoneyEx(playerid, -ammount * CocainePrice);
			Server_AddMoney(ammount * CocainePrice);
			Info(playerid, "Kamu berhasil membeli %d cocaine dengan harga %s", ammount, FormatMoney(CocainePrice * ammount));
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s membeli %d cocaine dengan harga %s", ReturnName(playerid), ammount,  FormatMoney(CocainePrice * ammount));
		}
	}
	else return Error(playerid, "Kamu bukan pekerja drug dealer");
	return 1;
}

CMD:smuggledrugs(playerid, params[])
{
	if(pData[playerid][pJob] == 12 || pData[playerid][pJob2] == 12)
	{
		if(pData[playerid][pDrugDealer] != 0)
			return Error(playerid, "Kamu masih memiliki paket yang belum diantar");

		if(!IsPlayerInRangeOfPoint(playerid, 3.5, 51.96, -292.28, 1.70))
			return Error(playerid, "Kamu tidak berada didekat point drug smuggling");
		
		new type[128];
		if(sscanf(params, "s[128]", type))
			return Usage(playerid, "/smuggledrugs [ephedrine/cocaine]");

		if(500 > pData[playerid][pMoney])
			return Error(playerid, "Kamu harus memegang $500 ditanganmu");

		if(!strcmp(type, "ephedrine", true))
		{
			if(Ephedrine > 500)
				return Error(playerid, "Stok Raw Ephedrine digudang sudah penuh");

			pData[playerid][pDrugDealer] = 2;
			GivePlayerMoneyEx(playerid, -500);
			SetPlayerCheckpoint(playerid, 2167.21, -1672.69, 15.07, 3.5);
			Info(playerid, "Kamu telah mengambil paket smuggling Raw Ephedrine dengan harga $500");
			Info(playerid, "Antar menuju checkpoint yang telah ditandai");
		}
		else if(!strcmp(type, "cocaine", true))
		{
			if(Cocaine > 500)
				return Error(playerid, "Stok cocaine digudang sudah penuh");

			pData[playerid][pDrugDealer] = 3;
			GivePlayerMoneyEx(playerid, -500);
			SetPlayerCheckpoint(playerid, 2351.82, -1168.90, 27.98, 3.5);
			Info(playerid, "Kamu telah mengambil paket smuggling cocaine dengan harga $500");
			Info(playerid, "Antar menuju checkpoint yang telah ditandai");
		}
	}
	else return Error(playerid, "Kamu bukan pekerja drug dealer");
	return 1;
}

CMD:cookmeth(playerid, params[])
{
	if(pData[playerid][pJob] == 12 || pData[playerid][pJob2] == 12)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.5, 1.21, 2.80, 999.42))
			return ShowNotifError(playerid, "Kamu harus berada di dekat point cookmeth!", 10000);

		if(pData[playerid][pMuriatic] < 1) return ErrorMsg(playerid, "Kamu membutuhkan 1 muriatic acid");
		if(pData[playerid][pEphedrine] < 2) return ErrorMsg(playerid, "Kamu membutuhkan 2 ephedrine");

		if(pData[playerid][pActivityTime] > 5)
			return ShowNotifError(playerid, "Anda masih memiliki activity progress!", 10000);

		TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
		pData[playerid][pMethBar] = SetTimerEx("CookMeth", 1000, true, "d", playerid);
		//Showbar(playerid, 20, "MEMASAK METH", "CookMeth");
		ShowProgressbar(playerid, "MEMASAK METH", 20);
	}
	else return Error(playerid, "Kamu bukan pekerja drug dealer!");
	return 1;
}

function CookMeth(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMethBar])) return 0;
	if(pData[playerid][pJob] == 12 || pData[playerid][pJob2] == 12)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMethBar]);
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
			InfoTD_MSG(playerid, 3000, "Meth +1");

			ShowNotifSukses(playerid, "Berhasil membuat 1kg meth!", 10000);

			pData[playerid][pMuriatic] -= 1;
			pData[playerid][pEphedrine] -= 1;
			pData[playerid][pMeth] += 1;
			ShowItemBox(playerid, "Muriatic", "Removed_1x", 1580, 2);
			ShowItemBox(playerid, "Ephedrine", "Removed_1x", 1580, 2);
			ShowItemBox(playerid, "Meth", "Received_1x", 1580, 2);
			//Inventory_Remove(playerid, "Muriatic", 1);
			//Inventory_Remove(playerid, "Ephedrine", 2);
			//Inventory_Add(playerid, "Meth", 1580, 1);
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
		}
	}
	return 1;
}

/*function CookMeth(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMethBar])) return 0;
	if(pData[playerid][pJob] == 12 || pData[playerid][pJob2] == 12)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0, 1.21, 2.80, 999.42))
			{
				if(Inventory_Count(playerid, "Muriatic") > 0 || Inventory_Count(playerid, "Ephedrine") >= 2)
				{
					KillTimer(pData[playerid][pMethBar]);
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					InfoTD_MSG(playerid, 3000, "Meth +1");

					ShowNotifSukses(playerid, "Berhasil membuat 1kg meth!", 10000);
					
					Inventory_Remove(playerid, "Muriatic", 1);
					Inventory_Remove(playerid, "Ephedrine", 2);
					Inventory_Add(playerid, "Meth", 1580, 1);

					pData[playerid][pActivityTime] = 0;
				}
				else
				{
					ClearAnimations(playerid, 1);
					TogglePlayerControllable(playerid, 1);

					pData[playerid][pActivityTime] = 0;

					KillTimer(pData[playerid][pMethBar]);
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					ShowNotifError(playerid, "Kamu membutuhkan 1 muriatic acid & 2 ephedrine untuk membuat meth", 10000);
					return 1;
				}
			}
			else
			{
				ClearAnimations(playerid, 1);
				TogglePlayerControllable(playerid, 1);

				pData[playerid][pActivityTime] = 0;

				KillTimer(pData[playerid][pMethBar]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				ShowNotifError(playerid, "Kamu telah keluar dari point cook meth, proses pembuatan meth mu terhenti", 10000);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0, 1.21, 2.80, 999.42))
			{
				if(Inventory_Count(playerid, "Muriatic") > 0 || Inventory_Count(playerid, "Ephedrine") >= 2)
				{
					pData[playerid][pActivityTime] += 5;
					SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				}
				else
				{
					ClearAnimations(playerid, 1);
					TogglePlayerControllable(playerid, 1);

					pData[playerid][pActivityTime] = 0;

					KillTimer(pData[playerid][pMethBar]);
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					ShowNotifError(playerid, "Kamu membutuhkan 1 muriatic acid & 2 ephedrine untuk membuat met", 10000);
					return 1;
				}
			}
			else
			{
				ClearAnimations(playerid, 1);
				TogglePlayerControllable(playerid, 1);

				pData[playerid][pActivityTime] = 0;

				KillTimer(pData[playerid][pMethBar]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				Error(playerid, "Kamu telah keluar dari point cook meth, proses pembuatan meth mu terhenti");
				return 1;
			}
		}
	}
	return 1;
}*/