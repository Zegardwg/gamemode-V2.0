//-------------[HAULING JOB PENGGANTI KURIR]-------------------

IsAHaulingVeh(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
	    case 514, 515, 403: return 1;
	    default: return 0;
	}

	return 0;
}

GetDealerRestock()
{
	new tmpcount;
	foreach(new id : Dealer)
	{
	    if(drData[id][dStock] < 50)
	    {
     		tmpcount++;
	    }
	}
	return tmpcount;
}

ReturnRestockDealerID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_DEALER) return -1;
	foreach(new id : Dealer)
	{
		if(drData[id][dStock] < 50)
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

CMD:starthauling(playerid, params[])
{
	if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8)
	{
		if(pData[playerid][pJobTime] > 0) 
			return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

		new pstate = GetPlayerState(playerid);
		if(pstate != PLAYER_STATE_DRIVER)
			return Error(playerid, "Anda harus menaiki kendaraan Linerunner/Roadtrain/Petrol");

		if(!IsAHaulingVeh(GetPlayerVehicleID(playerid)))
			return Error(playerid, "Anda harus menaiki kendaraan Linerunner/Roadtrain/Petrol");

		new string[1024];
		format(string, sizeof(string), "Gas Station Restock\n");
		format(string, sizeof(string), "%sDealer Restock", string);
		ShowPlayerDialog(playerid, HAULING_DELIVERY, DIALOG_STYLE_LIST, "Hauling Delivery", string, "Yes", "No");
	}
	else return Error(playerid, "Kamu bukan pekerja hauling");
	return 1;
}

CMD:stophauling(playerid, params[])
{
	if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8)
	{
		if(HaulingType[playerid] <= 0)
			return Error(playerid, "Kamu tidak memiliki mission hauling");
		{
			if(IsValidVehicle(VehHauling[playerid]))
				DestroyVehicle(VehHauling[playerid]);

			DisablePlayerCheckpoint(playerid);
			DisablePlayerCheckpoint(playerid);
			HaulingType[playerid] = 0;
			VehHauling[playerid] = -1;
			pData[playerid][pGetDEIDHAULING] = -1;
			Info(playerid, "Kamu telah membatalkan mission hauling");
		}
	}
	else return Error(playerid, "Kamu bukan pekerja hauling");
	return 1;
}

/*

//----------------------[ENUM HAULING JOB]-----------------
//HAULING JOB 8 
new VehHauling[MAX_PLAYERS];
new HaulingType[MAX_PLAYERS];



//-------------------[ON PLAYER ENTER CHECKPOINT]----------------------

{
    new playerState = GetPlayerState(playerid);
    if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //TAKE GAS
    {
    	if(playerState == PLAYER_STATE_DRIVER)
    	{
    		if(HaulingType[playerid] == 1)
    		{
	    		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
		    	{
			    	if(IsPlayerInRangeOfPoint(playerid, 4.5, -1018.91, -677.54, 32.00))
			    	{
			    		new randgas = Iter_Random(GStation);
			    		AttachTrailerToVehicle(VehHauling[playerid], GetPlayerVehicleID(playerid));
			    		DisablePlayerCheckpoint(playerid);
			    		SetPVarInt(playerid, "RandGAS", randgas);
			    		SetPlayerCheckpoint(playerid, gsData[randgas][gsPosX], gsData[randgas][gsPosY], gsData[randgas][gsPosZ], 4.5);
			    		Info(playerid, "Sukses terpasang! jika kamu tidak membawa trailer sampai tujuan, mission akan gagal");
			    	}
		    	}
		    	else return Info(playerid, "Kamu harus memasang trailer untuk melanjutkan pengantaran");
		    }
	    }
	}
    if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //TAKE DEALER
    {
    	if(playerState == PLAYER_STATE_DRIVER)
    	{
    		if(HaulingType[playerid] == 2)
    		{
	    		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
		    	{
			    	if(IsPlayerInRangeOfPoint(playerid, 4.5, -1030.85, -678.24, 32.00))
			    	{
			    		new randdlr =  Iter_Random(Dealer);
			    		AttachTrailerToVehicle(VehHauling[playerid], GetPlayerVehicleID(playerid));
			    		DisablePlayerCheckpoint(playerid);
			    		SetPVarInt(playerid, "RandDEALER", randdlr);
			    		SetPlayerCheckpoint(playerid, drData[randdlr][dVehposX], drData[randdlr][dVehposY], drData[randdlr][dVehposZ], 4.5);
			    		Info(playerid, "Sukses terpasang! jika kamu tidak membawa trailer sampai tujuan, mission akan gagal");
			    	}
		    	}
		    	else return Info(playerid, "Kamu harus memasang trailer untuk melanjutkan pengantaran");
		    }
	    }
	}
    if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //TAKE LAS VENTURAS
    {
    	if(playerState == PLAYER_STATE_DRIVER)
    	{
    		if(HaulingType[playerid] == 3)
    		{
	    		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
		    	{
			    	if(IsPlayerInRangeOfPoint(playerid, 4.5, -1039.64, -676.65, 32.01))
			    	{
			    		AttachTrailerToVehicle(VehHauling[playerid], GetPlayerVehicleID(playerid));
			    		DisablePlayerCheckpoint(playerid);
			    		SetPlayerCheckpoint(playerid, -2028.64, 106.58, 28.03, 4.5);
			    		Info(playerid, "Sukses terpasang! jika kamu tidak membawa trailer sampai tujuan, mission akan gagal");
			    	}
		    	}
		    	else return Info(playerid, "Kamu harus memasang trailer untuk melanjutkan pengantaran");
		    }
	    }
	}
	if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //SAMPAI SELESAI ANTAR GAS
	{
		if(playerState == PLAYER_STATE_DRIVER)
		{
			if(HaulingType[playerid] == 1)
			{
				if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
				{
					new gsrand = GetPVarInt(playerid, "RandGAS");
					if(IsPlayerInRangeOfPoint(playerid, 4.5, gsData[gsrand][gsPosX], gsData[gsrand][gsPosY], gsData[gsrand][gsPosZ]))
					{
						DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));

						if(IsValidVehicle(VehHauling[playerid]))
							DestroyVehicle(VehHauling[playerid]);

						DisablePlayerCheckpoint(playerid);
						GivePlayerMoneyEx(playerid, 150);
						Info(playerid, "Kamu berhasil mengantar trailer sampai tempat tujuan, dan mendapatkan uang sejumlah {00FF00}$150");

						HaulingType[playerid] = 0;
						gsData[gsrand][gsStock] += 5;

						GStation_Save(gsrand);
						GStation_Refresh(gsrand);
					}
				}
				else return Error(playerid, "Kendaraanmu tidak membawa trailer");
			}
		}
	}
	if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //SAMPAI SELESAI ANTAR DEALER
	{
		if(playerState == PLAYER_STATE_DRIVER)
		{
			if(HaulingType[playerid] == 2)
			{
				if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
				{
					new dealerrand = GetPVarInt(playerid, "RandDEALER");
					if(IsPlayerInRangeOfPoint(playerid, 4.5, drData[dealerrand][dVehposX], drData[dealerrand][dVehposY], drData[dealerrand][dVehposZ]))
					{
						DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));

						if(IsValidVehicle(VehHauling[playerid]))
							DestroyVehicle(VehHauling[playerid]);

						DisablePlayerCheckpoint(playerid);
						GivePlayerMoneyEx(playerid, 150);
						Info(playerid, "Kamu berhasil mengantar trailer sampai tempat tujuan, dan mendapatkan uang sejumlah {00FF00}$150");

						HaulingType[playerid] = 0;
						drData[dealerrand][dStock] += 2;

						Dealer_Save(dealerrand);
						Dealer_Refresh(dealerrand);
					}
				}
				else return Error(playerid, "Kendaraanmu tidak membawa trailer");
			}
		}
	}
	if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //SAMPAI SELESAI ANTAR LAS VENTURAS
	{
		if(playerState == PLAYER_STATE_DRIVER)
		{
			if(HaulingType[playerid] == 3)
			{
				if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
				{
					if(IsPlayerInRangeOfPoint(playerid, 4.5, 364.07, 862.98, 20.40))
					{
						DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));

						if(IsValidVehicle(VehHauling[playerid]))
							DestroyVehicle(VehHauling[playerid]);

						HaulingType[playerid] = 0;
						DisablePlayerCheckpoint(playerid);
						GivePlayerMoneyEx(playerid, 250);
						Info(playerid, "Kamu berhasil mengantar trailer sampai tempat tujuan, dan mendapatkan uang sejumlah {00FF00}$250");
					}
				}
				else return Error(playerid, "Kendaraanmu tidak membawa trailer");
			}
		}
	}






	//--------------[ON DIALOG RESPONSE]-------------------
	if(dialogid == HAULING_DELIVERY)
	{
		if(HaulingType[playerid] != 0)
			return Error(playerid, "Kamu memiliki tugas pengantaran yang belum diselesaikan (/cancelhauling jika ingin membatalkan pengantaran)");

		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(IsValidVehicle(VehHauling[playerid]))
						DestroyVehicle(VehHauling[playerid]);

					VehHauling[playerid] = CreateVehicle(584, -1017.83 , -686.28, 32.00+0.2, 6.79, -1, -1, 1);
					HaulingType[playerid] = 1;
					SetPlayerCheckpoint(playerid, -1018.91, -677.54, 32.00, 3.5); //TAKE PETROL
					Info(playerid, "Ikuti checkpoint untuk mengambil trailer yang akan kamu antar menuju gas station");
				}
				case 1:
				{
					if(IsValidVehicle(VehHauling[playerid]))
						DestroyVehicle(VehHauling[playerid]);

					VehHauling[playerid] = CreateVehicle(591, -1030.98, -686.11, 32.00+0.2, 358.75, -1, -1, 1);
					HaulingType[playerid] = 2;
					SetPlayerCheckpoint(playerid, -1030.85, -678.24, 32.00, 3.5); //TAKE DEALER
					Info(playerid, "Ikuti checkpoint untuk mengambil trailer yang akan kamu antar menuju dealer");
				}
				case 2:
				{
					if(IsValidVehicle(VehHauling[playerid]))
						DestroyVehicle(VehHauling[playerid]);

					VehHauling[playerid] = CreateVehicle(450, -1030.98, -686.11, 32.00+0.2, 358.75, -1, -1, 1);
					HaulingType[playerid] = 3;
					SetPlayerCheckpoint(playerid, 364.07, 862.98, 20.40, 3.5); //TAKE MINER
					Info(playerid, "Ikuti checkpoint untuk mengambil trailer yang akan kamu antar menuju las venturas");
				}
			}
		}
	}

	*/