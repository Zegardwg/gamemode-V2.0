

new TruckerVeh[5];

AddTruckerVehicle()
{
	TruckerVeh[0] = AddStaticVehicleEx(498, -64.79+1.5, -1144.38, 1.14, 336.21+0.5, 11, 11, VEHICLE_RESPAWN);
	TruckerVeh[1] = AddStaticVehicleEx(498, -59.40+1.5, -1146.86, 1.14, 336.18+0.5, 11, 11, VEHICLE_RESPAWN);
	TruckerVeh[2] = AddStaticVehicleEx(578, -53.73+3.0, -1149.24, 1.14, 335.42+0.5, 0, 0, VEHICLE_RESPAWN);
	TruckerVeh[3] = AddStaticVehicleEx(578, -48.06+3.0, -1151.74, 1.17, 334.40+0.5, 0, 0, VEHICLE_RESPAWN);
	TruckerVeh[4] = AddStaticVehicleEx(578, -42.80+3.0, -1154.23, 1.17, 333.62+0.5, 0, 0, VEHICLE_RESPAWN);
}

IsATruckerVeh(carid)
{
	for(new v = 0; v < sizeof(TruckerVeh); v++) {
	    if(carid == TruckerVeh[v]) return 1;
	}
	return 0;
}

//Mission
GetBisnisFastFood()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
	    if(bData[id][bType] == 1)
	    {
	    	if(bData[id][bProd] < 500)
	    	{
     			tmpcount++;
	    	}
	    }
	}
	return tmpcount;
}

//Mission
GetBisnisMarket()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
    	if(bData[id][bType] == 2)
	    {
	    	if(bData[id][bProd] < 500)
	    	{
     			tmpcount++;
	    	}
	    }
	}
	return tmpcount;
}

//Mission
GetBisnisClothes()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
    	if(bData[id][bType] == 3)
    	{
	    	if(bData[id][bProd] < 500)
	    	{
     			tmpcount++;
	    	}
	    }
	}
	return tmpcount;
}

//Mission
GetBisnisEquipment()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
    	if(bData[id][bType] == 4)
    	{
	    	if(bData[id][bProd] < 500)
	    	{
     			tmpcount++;
	    	}
	    }
	}
	return tmpcount;
}

//Mission
GetBisnisGunshop()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
    	if(bData[id][bType] == 5)
    	{
	    	if(bData[id][bProd] < 500)
	    	{
     			tmpcount++;
	    	}
	    }
	}
	return tmpcount;
}

//Mission
GetBisnisGym()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
    	if(bData[id][bType] == 6)
    	{
	    	if(bData[id][bProd] < 500)
	    	{
     			tmpcount++;
	    	}
	    }
	}
	return tmpcount;
}

ReturnRestockFoodID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
		if(bData[id][bType] == 1)
		{
		    if(bData[id][bProd] < 500)
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

ReturnRestockMarketID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
		if(bData[id][bType] == 2)
		{
		    if(bData[id][bProd] < 500)
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

ReturnRestockClothesID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
		if(bData[id][bType] == 3)
		{
		    if(bData[id][bProd] < 500)
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

ReturnRestockEquipmentID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
		if(bData[id][bType] == 4)
		{
		    if(bData[id][bProd] < 500)
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

ReturnRestockGunshopID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
		if(bData[id][bType] == 5)
		{
		    if(bData[id][bProd] < 500)
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

ReturnRestockGymID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
		if(bData[id][bType] == 6)
		{
		    if(bData[id][bProd] < 500)
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

//Mission Commands
CMD:loadbox(playerid, params[])
{
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		if(pData[playerid][pJobTime] > 0) 
			return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

		if(!IsPlayerInRangeOfPoint(playerid, 8.0, -62.03, -1121.26, 1.29))
			return ShowNotifError(playerid, "Kamu harus berada di tempat pengambilan box", 10000);

		new vehicleid = GetPlayerVehicleID(playerid);

		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return ShowNotifError(playerid, "Kamu harus mengendarai kendaraan DFT-30/Boxvillie", 10000);

		if(GetVehicleModel(vehicleid) == 609 || GetVehicleModel(vehicleid) == 498 || GetVehicleModel(vehicleid) == 578)
		{
			new str[1024];
			format(str, sizeof(str), "Bisnis Restock\nVending Restock");
			ShowPlayerDialog(playerid, DIALOG_LOADBOX, DIALOG_STYLE_LIST,"Trucker Restock", str, "Select", "Cancel");
		}
		else return ShowNotifError(playerid, "Kamu harus mengendarai kendaraan DFT-30/Boxvillie", 10000);
	}
	else return ShowNotifError(playerid, "You are not trucker job.", 10000);
	return 1;
}

CMD:unloadbox(playerid, params[])
{
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		new bid = pData[playerid][pMissionBiz], venid = pData[playerid][pMissionVen], vehicleid = GetPlayerVehicleID(playerid);

		if(bid != -1 || venid != -1)
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				return ShowNotifError(playerid, "Kamu harus mengendarai kendaraan DFT-30/Boxvillie", 10000);

			if(GetVehicleModel(vehicleid) == 609 || GetVehicleModel(vehicleid) == 498 || GetVehicleModel(vehicleid) == 578)
			{
				if(VehProduct[vehicleid] < 1)
					return ShowNotifError(playerid, "Product is empty in this vehicle.", 10000);

				new convert, pay;
				if(pData[playerid][pMissionBiz] > -1)
				{
					if(IsPlayerInRangeOfPoint(playerid, 5.5, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
					{
						if(IsValidDynamicObject(TruckerVehObject[GetPlayerVehicleID(playerid)]))
							DestroyDynamicObject(TruckerVehObject[GetPlayerVehicleID(playerid)]);

						TruckerVehObject[GetPlayerVehicleID(playerid)] = -1;
						
						bData[bid][bProd] += 50;
						Bisnis_Save(bid);
						Bisnis_Refresh(bid);

						VehProduct[vehicleid] = 0;
						pData[playerid][pMissionBiz] = -1;

						pData[playerid][pJobTime] = 200;
						pData[playerid][pHunger] -= 5;
						pData[playerid][pEnergy] -= 10;

						convert = floatround(pData[playerid][pDistanceMission], floatround_floor);
						pay = convert * 2 + jobtruckerprice;
						GivePlayerMoneyEx(playerid, pay);
						Info(playerid, "Anda kamu berhasil mengstore "RED_E"50 "WHITE_E"product dan mendapatkan uang sejumlah "GREEN_E"%s", FormatMoney(pay));
					}
					else return ShowNotifError(playerid, "Kamu harus berada didekat bisnis tujuan!", 10000);
				}
				if(pData[playerid][pMissionVen] > -1)
				{
					if(IsPlayerInRangeOfPoint(playerid, 5.5, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]))
					{
						VehProduct[vehicleid] = 0;
						pData[playerid][pMissionVen] = -1;
						vmData[venid][venProduct] += 10;
						vmData[venid][venMoney] -= 500;

						pData[playerid][pJobTime] = 200;
						pData[playerid][pHunger] -= 5;
						pData[playerid][pEnergy] -= 10;

						Vending_Refresh(venid);
						Vending_Save(venid);

						convert = floatround(pData[playerid][pDistanceMission], floatround_floor);
						pay = convert * 2 + jobtruckerprice;
						GivePlayerMoneyEx(playerid, pay);
						Info(playerid, "Anda kamu berhasil mengstore "RED_E"10 "WHITE_E"product dan mendapatkan uang sejumlah "GREEN_E"%s", FormatMoney(pay));
					}
					else return ShowNotifError(playerid, "Kamu harus berada didekat vending machine tujuan!", 10000);
				}
			}
			else return ShowNotifError(playerid, "Kamu harus mengendarai kendaraan DFT-30/Boxvillie", 10000);
		}
		else return ShowNotifError(playerid, "You dont have mission.", 10000);
	}
	else return ShowNotifError(playerid, "You are not trucker job.", 10000);
	return 1;
}

//GPS
GetBisnisNearest(playerid)
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
	    if(bData[id][bProd] > 0)
	    {
	    	if(GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]) < 1000)
	    	{
     			tmpcount++;
	    	}
		}
	}
	return tmpcount;
}

ReturnBisnisNearestID(playerid, slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
		if(bData[id][bProd] > 0)
		{
		    if(GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]) < 1000)
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

//GPS
GetDealerNearest(playerid)
{
	new tmpcount;
	foreach(new id : Dealer)
	{
		if(drData[id][dStock] > 0)
		{
			if(GetPlayerDistanceFromPoint(playerid, drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]) < 1000)
		    {
	     		tmpcount++;
	     	}
	     }
	}
	return tmpcount;
}

ReturnDealerNearestID(playerid, slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_DEALER) return -1;
	foreach(new id : Dealer)
	{
		if(drData[id][dStock] > 0)
		{
		    if(GetPlayerDistanceFromPoint(playerid, drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]) < 1000)
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

//GPS
GetWorkshopNearest()
{
	new tmpcount;
	foreach(new id : Workshop)
	{
		if(Iter_Contains(Workshop, id))
		{
	     	tmpcount++;
	    }
	}
	return tmpcount;
}

ReturnWorkshopNearestID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_WORKSHOP) return -1;
	foreach(new id : Workshop)
	{
		if(Iter_Contains(Workshop, id))
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

/*

--------------------[ENUM PLAYER]-------------
Float:pDistanceMission,




---------[ONPLAYER ENTER RACE CHECKPOINT]----------------------


	if(pData[playerid][pMission] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		Info(playerid, "Kamu harus menggunakan /unloadbox untuk mengisi stock bisnis.");
	}






----------------[ON DIALOG RESPONSE]------------

	if(dialogid == DIALOG_RESTOCK)
	{
		if(response)
		{
			new id = ReturnRestockBisnisID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pMission] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Product -= 10;
			Server_AddMoney(-10);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s yang berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}

----[ENUM DIALOG]---
	//Trucker
	DIALOG_RESTOCK,
	DIALOG_RESTOCK_FOOD,
	DIALOG_RESTOCK_MARKET,
	DIALOG_RESTOCK_CLOTHES,
	DIALOG_RESTOCK_EQUIPMENT,

	

------[DIALOG]------
	if(dialogid == DIALOG_RESTOCK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetBisnisFastFood() <= 0)
						return Error(playerid, "Mission sedang kosong.");

					new id, count = GetBisnisFastFood(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockFoodID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\tFastfood\t%s\n", itt, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\tFastfood\t%s\n", itt, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_FOOD, DIALOG_STYLE_TABLIST_HEADERS,"Mission",mission,"Start","Cancel");
				}
				case 1:
				{
					if(GetBisnisMarket() <= 0)
						return Error(playerid, "Mission sedang kosong.");

					new id, count = GetBisnisMarket(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockMarketID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\tMarket\t%s\n", itt, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\tMarket\t%s\n", itt, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_MARKET, DIALOG_STYLE_TABLIST_HEADERS,"Mission",mission,"Start","Cancel");
				}
				case 2:
				{
					if(GetBisnisClothes() <= 0)
						return Error(playerid, "Mission sedang kosong.");

					new id, count = GetBisnisClothes(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockClothesID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\tClothes\t%s\n", itt, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\tClothes\t%s\n", itt, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_CLOTHES, DIALOG_STYLE_TABLIST_HEADERS,"Mission",mission,"Start","Cancel");
				}
				case 3:
				{
					if(GetBisnisEquipment() <= 0)
						return Error(playerid, "Mission sedang kosong.");

					new id, count = GetBisnisEquipment(), mission[2024], lstr[3024];
					
					strcat(mission,"NO\tTYPE\tLOCATION\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockEquipmentID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\tEquipment\t%s\n", itt, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\tEquipment\t%s\n", itt, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));	
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_EQUIPMENT, DIALOG_STYLE_TABLIST_HEADERS,"Mission",mission,"Start","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_RESTOCK_FOOD)
	{
		if(response)
		{
			new id = ReturnRestockFoodID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pMission] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Product -= 10;
			Server_AddMoney(-10);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s yang berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}
	if(dialogid == DIALOG_RESTOCK_MARKET)
	{
		if(response)
		{
			new id = ReturnRestockMarketID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pMission] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Product -= 10;
			Server_AddMoney(-10);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s yang berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}
	if(dialogid == DIALOG_RESTOCK_CLOTHES)
	{
		if(response)
		{
			new id = ReturnRestockClothesID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pMission] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Product -= 10;
			Server_AddMoney(-10);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s yang berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}
	if(dialogid == DIALOG_RESTOCK_EQUIPMENT)
	{
		if(response)
		{
			new id = ReturnRestockEquipmentID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			
			if(pData[playerid][pMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pMission] = id;
			pData[playerid][pDistanceMission] = GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]);

			VehProduct[vehicleid] += 10;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += 10;
			}
			Product -= 10;
			Server_AddMoney(-10);
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 7.0);
			Info(playerid, "Kamu akan mengantar menuju bisnis yang berlokasi di %s yang berjarak %0.0fm", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}






*/