//Paytax
GetBisnisPaytax(playerid)
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
		if(!strcmp(pData[playerid][pName], bData[id][bOwner], true))
		{
	     	tmpcount++;
		}
	}
	return tmpcount;
}

ReturnBisnisPaytaxID(playerid, slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
		if(!strcmp(pData[playerid][pName], bData[id][bOwner], true))
		{
		    tmpcount++;
		    if(tmpcount == slot)
		    {
		    	return id;
		  	}
		}
	}
	return -1;
}

GetVendingPaytax(playerid)
{
	new tmpcount;
	foreach(new id : Vending)
	{
	    if(!strcmp(vmData[id][venOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnVendingPaytaxID(playerid, slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_VENDING) return -1;
	foreach(new id : Vending)
	{
		if(!strcmp(vmData[id][venOwner], pData[playerid][pName], true))
		{
		    tmpcount++;
		    if(tmpcount == slot)
		    {
		    	return id;
		  	}
		}
	}
	return -1;
}

GetHousesPaytax(playerid)
{
	new tmpcount;
	foreach(new hid : Houses)
	{
	    if(!strcmp(hData[hid][hOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnHousesPaytaxID(playerid, slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_HOUSES) return -1;
	foreach(new hid : Houses)
	{
		if(!strcmp(pData[playerid][pName], hData[hid][hOwner], true))
		{
		    tmpcount++;
		    if(tmpcount == slot)
		    {
		    	return hid;
		  	}
		}
	}
	return -1;
}

GetDealerPaytax(playerid)
{
	new tmpcount;
	foreach(new drid : Dealer)
	{
	    if(!strcmp(drData[drid][dOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnDealerPaytaxID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_DEALER) return -1;
	foreach(new drid : Houses)
	{
	    if(!strcmp(pData[playerid][pName], drData[drid][dOwner], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return drid;
  			}
	    }
	}
	return -1;
}

CMD:paytax(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, 910.95, 256.18, 1289.98))
		return Error(playerid, "Kamu harus berada di city hall");

	new string[1024];
	format(string, sizeof(string), "Business Tax\nHouse Tax\nDealer Tax\nVending Tax");
	ShowPlayerDialog(playerid, DIALOG_PAYTAX, DIALOG_STYLE_LIST, "Paytax Assets", string , "Yes","No");
	return 1;
}


/*

---------[ENUM DIALOG]--------------
	DIALOG_PAYTAX,
	DIALOG_PAYTAX_BISNIS,
	DIALOG_PAYTAX_HOUSE,
	DIALOG_PAYTAX_DEALER

------------[FUNCTION TIMER]-------------

	foreach(new bid : Bisnis)
	{
		if(strcmp(bData[bid][bOwner], "-"))
		{
			if(bData[bid][bVisit] != 0 && bData[bid][bVisit] <= gettime())
			{
				Bisnis_Reset(bid);
				Bisnis_Save(bid);
			}
		}
	}
	foreach(new hid : Houses)
	{
		if(strcmp(hData[hid][hOwner], "-"))
		{
			if(hData[hid][hVisit] != 0 && hData[hid][hVisit] <= gettime())
			{
				HouseReset(hid);
				House_Save(hid);
			}
		}
	}
	foreach(new drid : Dealer)
	{
		if(strcmp(drData[drid][dOwner], "-"))
		{
			if(drData[drid][dVisit] != 0 && drData[drid][dVisit] <= gettime())
			{
				Dealer_Reset(drid);
				Dealer_Save(drid);
			}
		}
	}

-----------[DIALOG.PWN]-----------

	if(dialogid == DIALOG_PAYTAX)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetBisnisPaytax(playerid) <= 0)
						return Error(playerid, "Kamu tidak memiliki bisnis.");

					new id, count = GetBisnisPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBisnisPaytaxID(playerid, itt);
						if(bData[id][bType] == 1)
						{
							type = "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type = "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type = "Clothes";
						}
						else if(bData[id][bType] == 4)
						{
							type = "Equipment";
						}
						else
						{
							type = "Unknown";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), ReturnTimelapse(gettime(), bData[id][bVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), ReturnTimelapse(gettime(), bData[id][bVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_PAYTAX_BISNIS, DIALOG_STYLE_TABLIST_HEADERS,"Business Tax",mission,"Start","Cancel");
				}
				case 1:
				{
					if(GetHousesPaytax(playerid) <= 0)
						return Error(playerid, "Kamu tidak memiliki rumah.");

					new id, count = GetHousesPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnHousesPaytaxID(playerid, itt);
						if(hData[id][hType] == 1)
						{
							type = "Small";
						}
						else if(hData[id][hType] == 2)
						{
							type = "Medium";
						}
						else if(hData[id][hType] == 3)
						{
							type = "Large";
						}
						else
						{
							type = "Unknown";
						}
	
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(hData[id][hExtposX], hData[id][hExtposY], hData[id][hExtposZ]), ReturnTimelapse(gettime(), hData[id][hVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(hData[id][hExtposX], hData[id][hExtposY], hData[id][hExtposZ]), ReturnTimelapse(gettime(), hData[id][hVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_PAYTAX_HOUSE, DIALOG_STYLE_TABLIST_HEADERS,"Houses Tax",mission,"Start","Cancel");
				}
				case 2:
				{
					if(GetDealerPaytax(playerid) <= 0)
						return Error(playerid, "Kamu tidak memiliki Dealer.");

					new id, count = GetDealerPaytax(playerid), mission[2024], lstr[3024], type[128];
					
					strcat(mission,"ID\tTYPE\tLOCATION\tEXPIRED\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnDealerPaytaxID(playerid, itt);
						if(drData[id][dType] == 1)
						{
							type = "Bikes Vehicles";
						}
						else if(drData[id][dType] == 2)
						{
							type = "Cars";
						}
						else if(drData[id][dType] == 3)
						{
							type = "Unique Cars";
						}
						else if(drData[id][dType] == 4)
						{
							type = "Job Cars";
						}
						else if(drData[id][dType] == 5)
						{
							type = "Rental Vehicles";
						}
	
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", id, type, GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), ReturnTimelapse(gettime(), drData[id][dVisit]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_PAYTAX_DEALER, DIALOG_STYLE_TABLIST_HEADERS,"Dealer Tax",mission,"Start","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_PAYTAX_BISNIS)
	{
		if(response)
		{
			new id = ReturnBisnisPaytaxID(playerid, (listitem + 1));

			if(bData[id][bVisit] > gettime() + (86400 * 7))
				return Error(playerid, "Kamu hanya bisa membayar pajak asset bisnis yang dibawah 7 hari");

			if(pData[playerid][pMoney] < 15000)
				return Error(playerid, "Kamu harus memiliki uang sejumlah $150.00"GREEN_E" "WHITE_E"untuk membayar pajak asset bisnismu");

			bData[id][bVisit] = gettime() + (86400 * 15);
			Bisnis_Refresh(id);
			Bisnis_Save(id);

			GivePlayerMoneyEx(playerid, -15000);
			Info(playerid, "Kamu telah membayar pajak bisnis (%s (ID: %d)) dengan harga "GREEN_E"$150.00 "WHITE_E"(/paytax untuk mengeceknya)", bData[id][bName], id);
		}
	}
	if(dialogid == DIALOG_PAYTAX_HOUSE)
	{
		if(response)
		{
			new id = ReturnHousesPaytaxID(playerid, (listitem + 1));

			if(hData[id][hVisit] > gettime() + (86400 * 7))
				return Error(playerid, "Kamu hanya bisa membayar pajak asset bisnis yang dibawah 7 hari");

			if(pData[playerid][pMoney] < 15000)
				return Error(playerid, "Kamu harus memiliki uang sejumlah $150.00"GREEN_E" "WHITE_E"untuk membayar pajak asset rumahnmu");

			hData[id][hVisit] = gettime() + (86400 * 15);
			House_Refresh(id);
			House_Save(id);

			GivePlayerMoneyEx(playerid, -15000);
			Info(playerid, "Kamu telah membayar pajak rumah (%s (ID: %d)) dengan harga "GREEN_E"$150.00 "WHITE_E"(/paytax untuk mengeceknya)", GetLocation(hData[id][hExtposX], hData[id][hExtposY], hData[id][hExtposZ]), id);
		}
	}
	if(dialogid == DIALOG_PAYTAX_DEALER)
	{
		if(response)
		{
			new id = ReturnDealerPaytaxID(playerid, (listitem + 1));

			if(drData[id][dVisit] > gettime() + (86400 * 7))
				return Error(playerid, "Kamu hanya bisa membayar pajak asset dealer yang dibawah 7 hari");

			if(pData[playerid][pMoney] < 50000)
				return Error(playerid, "Kamu harus memiliki uang sejumlah $500.00"GREEN_E" "WHITE_E"untuk membayar pajak asset dealer");

			drData[id][dVisit] = gettime() + (86400 * 15);
			Dealer_Refresh(id);
			Dealer_Save(id);

			GivePlayerMoneyEx(playerid, -15000);
			Info(playerid, "Kamu telah membayar pajak rumah (%s (ID: %d)) dengan harga "GREEN_E"$500.00 "WHITE_E"(/paytax untuk mengeceknya)", GetLocation(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]), id);
		}
	}
*/