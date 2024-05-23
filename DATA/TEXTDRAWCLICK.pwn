public OnPlayerClickDynamicTextdraw(playerid, PlayerText:playertextid)
{
	//BENSIN GENZO
	if(playertextid == MATATD[playerid][1])
	{
		foreach(new gsid : GStation)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]))
			{
				new string[32], vehicleid = GetNearestVehicleToPlayer(playerid, 2.0);
	            //vehid = GetNearestVehicleToPlayer(playerid, 2.0),
	            new fuels = GetVehicleFuel(vehicleid);

	            if(PlayerData[playerid][pFuelCar] == 0)
				{
		            if (IsPlayerInAnyVehicle(playerid))
		                return ErrorMsg(playerid, "Kamu harus turun dari kendaraan!");

		            if (!GetNearestVehicleToPlayer(playerid, 2.0))
		                return ErrorMsg(playerid, "Tidak ada kendaran di dekat mu!");

		            if (!IsEngineVehicle(vehicleid))
		                return ErrorMsg(playerid, "Kendaraan ini tidak memiliki mesin!");

		            if (GetEngineStatus(vehicleid))
		                return ErrorMsg(playerid, "Matikan mesin terlebih dahulu!");

		            if(fuels >= 100)
		            return ErrorMsg(playerid, "Kendaraan Anda tidak perlu mengisi bbm.");

					if(fuels >= 100)
			        {
				    	Stopfill(playerid);
			        }

		            PlayerData[playerid][pFuelCar] = 1;
			     	format(string,sizeof(string), "%d%%", fuels);
				    Update3DTextLabelText(LabelPercentPom[playerid][vehicleid], 0xFFFFFFFF, string);
		            LabelPercentPom[playerid][vehicleid] = Create3DTextLabel(string, COLOR_WHITE, 0.0, 0.0, 0.0, 10.0, 0, 1);
		            Attach3DTextLabelToVehicle(LabelPercentPom[playerid][vehicleid], vehicleid, -0.3, 0.0, 1.0);
					UpdateAndCancel3DTextLabelPom(playerid);
					if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
					SetPlayerAttachedObject(playerid, 9, 19621, 6, 0.067, -0.003, 0.031, 25.800, 46.900, 79.700, 1.0, 1.0, 1.0);
					hidemata(playerid);
				}
			}
		}
	}
	if(playertextid == MATATD[playerid][3])
	{
		foreach(new gsid : GStation)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]))
			{
				Stopfill(playerid);
			}
		}
		hidemata(playerid);
	}
	//Mechanic
	if(playertextid == MATATD[playerid][1])
    {
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1806.4253,-2022.3940,13.5735))
        {
        	SuccesMsg(playerid, "Anda Onduty Mechanic");
			pData[playerid][pMechDuty] = 1;
			SetPlayerSkin(playerid, 268);
			//SetPlayerColor(playerid, COLOR_ORANGE);
        }
        hidemata(playerid);
    }
    if(playertextid == MATATD[playerid][3])
    {
    	if(IsPlayerInRangeOfPoint(playerid, 1.0, 1806.4253,-2022.3940,13.5735))
        {
        	SuccesMsg(playerid, "Anda Offduty Mechanic");
			pData[playerid][pMechDuty] = 0;
			SetPlayerSkin(playerid, pData[playerid][pSkin]);
			//SetPlayerColor(playerid, COLOR_WHITE);
        }
        hidemata(playerid);
    }
	//CALL
	if(playertextid == BatalTelpon[playerid])
	{
        callcmd::offhu(playerid, "");
	}
	if(playertextid == RijekTelpon[playerid])
	{
        callcmd::ofhu(playerid, "");
	}
	if(playertextid == AngkatTelpon[playerid])
	{
        callcmd::angkattelp(playerid, "");
	}
	if(playertextid == AkhiriTelpon[playerid])
	{
        callcmd::endcall(playerid, "");
	}
	//Radial Player
	if(playertextid == PR_PANELSTD[playerid][1])// Panel Buka Smartphone
	{
		HidePanelFullNC(playerid);
        if(pData[playerid][pPhone] == 0) 
			return ShowNotifError(playerid, "Kamu tidak memilik phone!", 10000);

		for(new i = 0; i < 28; i++)
		{
			TextDrawShowForPlayer(playerid, HPLOCKSCREEN[i]);
		}
		PlayerPlaySound(playerid, 3600, 0,0,0);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, ""WHITE_E"ACTION: {D0AEEB}%s Telah membuka handphone miliknya", pData[playerid][pName]);
		Info(playerid, "Gunakan '/cursor'Jika mouse hilang Dari Layar/teksdraw tidak bisa ditekan!");
		SetPlayerAttachedObject(playerid, 9, 18871, 5, 0.056, 0.039, -0.015, -18.100, -108.600, 93.000, 1,1,1);
		ApplyAnimation(playerid,"ped","Jetpack_Idle",4.1, 0, 1, 1, 1, 1, 1); // Not looping
	}
	if(playertextid == PR_PANELSTD[playerid][2])// Panel Buka Identitas
	{
		HidePanelS(playerid);
		for(new i = 0; i < 29; i++)
		{
			PlayerTextDrawShow(playerid, PR_IPANEL[playerid][i]);
		}
	}
	if(playertextid == PR_PANELSTD[playerid][3])// Panel Kendaraan
	{
		HidePanelS(playerid);
		for(new i = 0; i < 50; i++)
		{
			PlayerTextDrawShow(playerid, PR_KPANEL[playerid][i]);
		}
		TextDrawShowForPlayer(playerid, PR_KPANEL1[0]);
	}
	if(playertextid == PR_PANELSTD[playerid][4])// Panel Invoice
	{
		HidePanelFull(playerid);

		new header[1400], count = 0;
	    new bool:status = false;
	    format(header, sizeof(header), "Faction\tFrom\tBill Name\tAmount\n");
	    foreach(new i: tagihan)
	    {
	    	new fac[24];
			if(bilData[i][bilType] == 1)
			{
				fac = "Police";
			}
			else if(bilData[i][bilType] == 2)
			{
				fac = "Goverment";
			}
			else if(bilData[i][bilType] == 3)
			{
				fac = "Medic";
			}
			else if(bilData[i][bilType] == 4)
			{
				fac = "News";
			}
			else if(bilData[i][bilType] == 5)
			{
				fac = "Food Vendor";
			}
	        if(i != -1)
	        {
	            if(bilData[i][bilTarget] == pData[playerid][pID])
	            {
	                format(header, sizeof(header), "%s\t%s\t%s\t%s\t{00ff00}%s\n", header, fac, bilData[i][billoName], bilData[i][bilName], FormatMoney(bilData[i][bilammount]));
	                count++;
	                status = true;
	            }
	        }
	    }
	    if(status)
	    {
	        ShowPlayerDialog(playerid, DIALOG_PAYBILL, DIALOG_STYLE_TABLIST_HEADERS, "My invoice", header, "Pay", "back");
	    }
	    else
	    {
	        Error(playerid, "You have no bills");
	    }
	}
	if(playertextid == PR_PANELSTD[playerid][5])// Panel Dokumen
	{
		HidePanelS(playerid);
		for(new i = 0; i < 47; i++)
		{
			PlayerTextDrawShow(playerid, PR_DPANEL[playerid][i]);
		}
	}
	if(playertextid == PR_PANELSTD[playerid][6])// Panel Pakaian
	{
		HidePanelS(playerid);
		for(new i = 0; i < 28; i++)
		{
			PlayerTextDrawShow(playerid, PR_PPANEL[playerid][i]);
		}
	}
	if(playertextid == PR_PANELSTD[playerid][7])// Panel Inventory
	{
		HidePanelFull(playerid);
		callcmd::i(playerid, "");
	}
	if(playertextid == PR_PANELSTD[playerid][8])// Close Panel
	{
		HidePanelFull(playerid);
	}
	if(playertextid == PR_KPANEL[playerid][1])// Kunci Kendaraan
	{
		static
		carid = -1;

		if((carid = Vehicle_Nearest(playerid)) != -1)
		{
			if(Vehicle_IsOwner(playerid, carid))
			{
				if(!pvData[carid][cLocked])
				{
					pvData[carid][cLocked] = 1;

					new Float:X, Float:Y, Float:Z;
					InfoTD_MSG(playerid, 4000, "Kendaraan ini berhasil ~r~Dikunci!");
					GetPlayerPos(playerid, X, Y, Z);
					SwitchVehicleDoors(pvData[carid][cVeh], true);
				}
				else
				{
					pvData[carid][cLocked] = 0;
					new Float:X, Float:Y, Float:Z;
					InfoTD_MSG(playerid, 4000, "Kendaraan ini berhasil ~g~Terbuka!");
					GetPlayerPos(playerid, X, Y, Z);
					SwitchVehicleDoors(pvData[carid][cVeh], false);
				}
			}
				//else SendErrorMessage(playerid, "You are not in range of anything you can lock.");
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun yang ingin anda kunci.");
	}
	if(playertextid == PR_KPANEL[playerid][2])// Close Panel
	{
		HidePanelK(playerid);

		ShowPanelS(playerid);
	}
	if(playertextid == PR_KPANEL[playerid][4])// Trunk
	{
		new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(vehicleid == INVALID_VEHICLE_ID)
			return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

		switch (GetTrunkStatus(vehicleid))
		{
			case false:
			{
				SwitchVehicleBoot(vehicleid, true);
				InfoTD_MSG(playerid, 4000, "Vehicle Trunk ~g~OPEN");
			}
			case true:
			{
				SwitchVehicleBoot(vehicleid, false);
				InfoTD_MSG(playerid, 4000, "Vehicle Trunk ~g~OPEN");
			}
		}
		return 1;
	}
	if(playertextid == PR_KPANEL[playerid][5])// Hood
	{
		new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(vehicleid == INVALID_VEHICLE_ID)
			return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);

		switch (GetHoodStatus(vehicleid))
		{
			case false:
			{
				SwitchVehicleBonnet(vehicleid, true);
				InfoTD_MSG(playerid, 4000, "Vehicle Hood ~g~OPEN");
			}
			case true:
			{
				SwitchVehicleBonnet(vehicleid, false);
				InfoTD_MSG(playerid, 4000, "Vehicle Hood ~r~CLOSED");
			}
		}
		return 1;
	}
	if(playertextid == PR_KPANEL[playerid][6])// Engine
	{
		//new vehicleid = GetPlayerVehicleID(playerid);

		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::v(playerid, "engine");
		}
		else return Error(playerid, "Anda harus mengendarai kendaraan!");
	}
	if(playertextid == PR_KPANEL[playerid][7])// bagasi
	{
		HidePanelFull(playerid);
		callcmd::vstorage(playerid, "");//
	}
	if(playertextid == PR_KPANEL[playerid][8])// Lampu
	{	
		new
			vehicleid = GetPlayerVehicleID(playerid);

		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(!IsEngineVehicle(vehicleid))
				return Error(playerid, "Kamu tidak berada didalam kendaraan.");

			switch(GetLightStatus(vehicleid))
			{
				case false:
				{
					SwitchVehicleLight(vehicleid, true);
					InfoTD_MSG(playerid, 4000, "Vehicle Light ~g~ON");
				}
				case true:
				{
					SwitchVehicleLight(vehicleid, false);
					InfoTD_MSG(playerid, 4000, "Vehicle Light ~r~OFF");
				}
			}
		}
		else return Error(playerid, "Anda harus mengendarai kendaraan!");
	}
	if(playertextid == PR_IPANEL[playerid][1])// Lihat KTP
	{
		HidePanelFull(playerid);

		callcmd::ktpshow(playerid, "");
	}
	if(playertextid == PR_IPANEL[playerid][2])// Lihat Sim
	{
		HidePanelFull(playerid);

		callcmd::simshow(playerid, "");
	}
	if(playertextid == PR_IPANEL[playerid][3])// Tunjukan Sim
	{
		HidePanelFull(playerid);

		new str[500], count = 0,String[500];
        String="";
		foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
		{
			format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
			SetPlayerListitemValue(playerid, count++, i);
		}
		if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		else ShowPlayerDialog(playerid, DIALOG_SHOWSIM, DIALOG_STYLE_LIST, "ValriseReality - Tunjukan SIM", str, "Pilih", "Tutup");
	}
	if(playertextid == PR_IPANEL[playerid][4])// Tunjukan KTP
	{
		//HidePanelFullNC(playerid);
		HidePanelFull(playerid);

		new str[500], count = 0,String[500];
        String="";
		foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
		{
			format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
			SetPlayerListitemValue(playerid, count++, i);
		}
		if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		else ShowPlayerDialog(playerid, DIALOG_SHOWKTP, DIALOG_STYLE_LIST, "ValriseReality - Tunjukan KTP", str, "Pilih", "Tutup");
	}
	if(playertextid == PR_IPANEL[playerid][5])// Close Panel iden
	{
		for(new i = 0; i < 29; i++)
		{
			PlayerTextDrawHide(playerid, PR_IPANEL[playerid][i]);
		}
		ShowPanelS(playerid);
	}
	if(playertextid == PR_DPANEL[playerid][2])// Close Dokmen
	{
		for(new i = 0; i < 47; i++)
		{
			PlayerTextDrawHide(playerid, PR_DPANEL[playerid][i]);
		}
		ShowPanelS(playerid);
	}
	if(playertextid == PR_DPANEL[playerid][4])// Tunjukan SKCK
	{
		HidePanelFull(playerid);

		new str[500], count = 0,String[500];
        String="";
		foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
		{
			format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
			SetPlayerListitemValue(playerid, count++, i);
		}
		if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		else ShowPlayerDialog(playerid, DIALOG_SHOWSKCK, DIALOG_STYLE_LIST, "ValriseReality - Tunjukan SKCK", str, "Pilih", "Tutup");
	}
	if(playertextid == PR_DPANEL[playerid][5])// Lihat SKCK
	{
		HidePanelFull(playerid);

		callcmd::showskck(playerid, "");
	}
	if(playertextid == PR_DPANEL[playerid][6])// Tunjukan SKS
	{
		HidePanelFull(playerid);

		new str[500], count = 0,String[500];
        String="";
		foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
		{
			format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
			SetPlayerListitemValue(playerid, count++, i);
		}
		if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		else ShowPlayerDialog(playerid, DIALOG_SHOWSKS, DIALOG_STYLE_LIST, "ValriseReality - Tunjukan SKS", str, "Pilih", "Tutup");
	}
	if(playertextid == PR_DPANEL[playerid][7])// Lihat SKS
	{
		HidePanelFull(playerid);

		callcmd::showsks(playerid, "");
	}
	if(playertextid == PR_DPANEL[playerid][1])// Lihat BPJS
	{
		HidePanelFull(playerid);

		callcmd::showbpjs(playerid, "");
	}
	if(playertextid == PR_DPANEL[playerid][8])// Tunjukan BPJS
	{
		HidePanelFull(playerid);

		new str[500], count = 0,String[500];
        String="";
		foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
		{
			format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
			SetPlayerListitemValue(playerid, count++, i);
		}
		if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
		else ShowPlayerDialog(playerid, DIALOG_SHOWBPJS, DIALOG_STYLE_LIST, "ValriseReality - Tunjukan BPJS", str, "Pilih", "Tutup");
	}
	if(playertextid == PR_PPANEL[playerid][1])// Hat Topi
	{
		new name[MAX_PLAYER_NAME];
		new string[42];
		if(pData[playerid][pHelmet] == 0)
		{
			SetPlayerAttachedObject(playerid, 0, 18645, 2, 0.07, 0, 0, 88, 75, 0);
			pData[playerid][pHelmet] = 1;
			GetPlayerName(playerid, name, sizeof(name));
			format(string, sizeof(string), "%s memakai helm nya.", name);
			ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0, 1);
			ProxDetector(15.0, playerid, string,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else  if(pData[playerid][pHelmet] == 1)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) RemovePlayerAttachedObject(playerid, 0);
			pData[playerid][pHelmet] = 0;
			GetPlayerName(playerid, name, sizeof(name));
			format(string, sizeof(string), "%s melepas helm nya.", name);
			ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0, 1);
			ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
	}
	if(playertextid == PR_PPANEL[playerid][2])// Hat Aksesoris
	{
		HidePanelFull(playerid);
		callcmd::toys(playerid);
	}
	if(playertextid == PR_PPANEL[playerid][3])// Hat Tas
	{
		if(pData[playerid][pTas] == 0)
		{
			SuccesMsg(playerid, "Berhasil memakai Tas");
			SetPlayerAttachedObject(playerid, 4, 11745, 1, -0.090000, -0.128999, -0.028999, 90.400016, 1.300006, 26.499988, 0.600000, 0.956999, 0.669000);
		}
		else if(pData[playerid][pTas] == 1)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
			pData[playerid][pTas] = 0;
			SuccesMsg(playerid, "Berhasil melepas Tas");
		}
	}
	if(playertextid == PR_PPANEL[playerid][4])// Hat Kacamata
	{
		if(pData[playerid][pKacamata] == 0)
		{
			SuccesMsg(playerid, "Berhasil memakai Kacamata");
			ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0, 1);
			SetPlayerAttachedObject(playerid, 4, 19008, 2, 0.09,0.04, 0.0, 88, 75, 0, 1, 1, 1);
		}
		else if(pData[playerid][pKacamata] == 1)
		{
			ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0, 1);
			if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
			pData[playerid][pKacamata] = 0;
			SuccesMsg(playerid, "Berhasil melepas Kacamata");
		}
	}
	if(playertextid == PR_PPANEL[playerid][5])// Tutup
	{
		for(new i = 0; i < 28; i++)
		{
			PlayerTextDrawHide(playerid, PR_PPANEL[playerid][i]);
		}
		ShowPanelS(playerid);
	}
	//
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
		if(playertextid == MODELTD[playerid][i])
		{
			if(InventoryData[playerid][i][invExists])
			{
			    MenuStore_UnselectRow(playerid);
				MenuStore_SelectRow(playerid, i);
			    new name[48];
            	strunpack(name, InventoryData[playerid][pData[playerid][pSelectItem]][invItem]);
			}
		}
	}
	if(playertextid == INVINFO[playerid][2])//USE
	{
		new id = pData[playerid][pSelectItem];

		if(id == -1)
		{
		    ShowNotifError(playerid, "Tidak Ada Barang Di Slot Tersebut", 5000);
		}
		else
		{
		    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			new string[64];
		    strunpack(string, InventoryData[playerid][id][invItem]);

		    if(!PlayerHasItem(playerid, string))
		    {
		   		ShowNotifError(playerid, "Kamu Tidak Memiliki Barang Tersebut", 5000);
                Inventory_Show(playerid);
			}
			else
			{
				CallLocalFunction("OnPlayerUseItem", "dds", playerid, id, string);
			}
		}
	}
	else if(playertextid == INVINFO[playerid][4])//DROP
	{
		new id = pData[playerid][pSelectItem];
		if(id == -1)
		{
			ErrorMsg(playerid, "Pilih Barang Terlebih Dahulu");
		}
		else
		{
		    if(pData[playerid][pGiveAmount] < 1)
				return ErrorMsg(playerid, "Masukan Jumlah Terlebih Dahulu!");

			new itemid = pData[playerid][pSelectItem];
			new value = pData[playerid][pGiveAmount];

			CallLocalFunction("DropPlayerItem", "dds[128]d", playerid, itemid, InventoryData[playerid][itemid][invItem], value);
		}
	}
	else if(playertextid == INVINFO[playerid][3])
	{
		new id = pData[playerid][pSelectItem], str[500], count = 0;
		if(id == -1)
		{
			ErrorMsg(playerid,"[Inventory] Pilih Barang Terlebih Dahulu");
		}
		else
		{
		    if (pData[playerid][pGiveAmount] < 1)
				return ErrorMsg(playerid,"[Inventory] Masukan Jumlah Terlebih Dahulu");

            foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
			{
				format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
				SetPlayerListitemValue(playerid, count++, i);
			}
			if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
			else ShowPlayerDialog(playerid, DIALOG_GIVE, DIALOG_STYLE_LIST, "Valrise - Inventory", str, "Pilih", "Tutup");
		}
	}
	else if(playertextid == INVINFO[playerid][1])
	{
		ShowPlayerDialog(playerid, DIALOG_AMOUNT, DIALOG_STYLE_INPUT, "Inventory - Jumlah", "Masukan Jumlah:", "Input", "Batal");
	}
    if(playertextid == INVINFO[playerid][5])//Close
    {
		Inventory_Close(playerid);
	}
	//TD EDIT
	//new fid = PlayerData[playerid][pEditing], vid = PlayerData[playerid][pVehicle], slot = PlayerData[playerid][pListitem];

    /*if (textid == PLUSX[playerid]) {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyPosX][slot] = VehicleData[vid][vToyPosX][slot] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_OFFSET_X, VehicleData[vid][vToyPosX][slot]);
        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) {
                TagData[fid][tagPos][0] = TagData[fid][tagPos][0] + 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_X, TagData[fid][tagPos][0]);
            } else {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furniturePos][0] = FurnitureData[fid][furniturePos][0] + 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_X, FurnitureData[fid][furniturePos][0]);
            }
        }
    }
    if (textid == MINX[playerid]) {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyPosX][slot] = VehicleData[vid][vToyPosX][slot] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_OFFSET_X, VehicleData[vid][vToyPosX][slot]);
        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) {
                TagData[fid][tagPos][0] = TagData[fid][tagPos][0] - 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_X, TagData[fid][tagPos][0]);
            } else {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furniturePos][0] = FurnitureData[fid][furniturePos][0] - 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_X, FurnitureData[fid][furniturePos][0]);
            }
        }
    }
    if (textid == PLUSY[playerid]) {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyPosY][slot] = VehicleData[vid][vToyPosY][slot] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_OFFSET_Y, VehicleData[vid][vToyPosY][slot]);
        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) 
            {
                TagData[fid][tagPos][1] = TagData[fid][tagPos][1] + 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_Y, TagData[fid][tagPos][1]);
            } 
            else {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furniturePos][1] = FurnitureData[fid][furniturePos][1] + 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_Y, FurnitureData[fid][furniturePos][1]);
            }
        }
    }
    if (textid == MINY[playerid]) {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyPosY][slot] = VehicleData[vid][vToyPosY][slot] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_OFFSET_Y, VehicleData[vid][vToyPosY][slot]);

        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) {
                TagData[fid][tagPos][1] = TagData[fid][tagPos][1] - 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_Y, TagData[fid][tagPos][1]);
            } else {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furniturePos][1] = FurnitureData[fid][furniturePos][1] - 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_Y, FurnitureData[fid][furniturePos][1]);
            }
        }
    }
    if (textid == PLUSZ[playerid]) {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyPosZ][slot] = VehicleData[vid][vToyPosZ][slot] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_OFFSET_Z, VehicleData[vid][vToyPosZ][slot]);

        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) {
                TagData[fid][tagPos][2] = TagData[fid][tagPos][2] + 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_Z, TagData[fid][tagPos][2]);
            } else {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furniturePos][2] = FurnitureData[fid][furniturePos][2] + 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_Z, FurnitureData[fid][furniturePos][2]);
            }
        }
    }
    if (textid == MINZ[playerid]) {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyPosZ][slot] = VehicleData[vid][vToyPosZ][slot] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_OFFSET_Z, VehicleData[vid][vToyPosZ][slot]);
        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) {
                TagData[fid][tagPos][2] = TagData[fid][tagPos][2] - 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_Z, TagData[fid][tagPos][2]);
            } else {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furniturePos][2] = FurnitureData[fid][furniturePos][2] - 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_Z, FurnitureData[fid][furniturePos][2]);
            }
        }
    }
    if (textid == PLUSRX[playerid]) {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyRotX][slot] = VehicleData[vid][vToyRotX][slot] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_R_X, VehicleData[vid][vToyRotX][slot]);
        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) 
            {
                TagData[fid][tagPos][3] = TagData[fid][tagPos][3] + 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_X, TagData[fid][tagPos][3]);
            } 
            else {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furnitureRot][0] = FurnitureData[fid][furnitureRot][0] + 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_R_X, FurnitureData[fid][furnitureRot][0]);
            }
        }
    }
    if (textid == MINRX[playerid]) {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyRotX][slot] = VehicleData[vid][vToyRotX][slot] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_R_X, VehicleData[vid][vToyRotX][slot]);
        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) 
            {
                TagData[fid][tagPos][3] = TagData[fid][tagPos][3] - 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_X, TagData[fid][tagPos][3]);
            } 
            else {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furnitureRot][0] = FurnitureData[fid][furnitureRot][0] - 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_R_X, FurnitureData[fid][furnitureRot][0]);
            }
        }
    }
    if (textid == PLUSRY[playerid]) 
    {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyRotY][slot] = VehicleData[vid][vToyRotY][slot] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_R_Y, VehicleData[vid][vToyRotY][slot]);
        } 
        else 
        {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) 
            {
                TagData[fid][tagPos][4] = TagData[fid][tagPos][4] + 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_Y, TagData[fid][tagPos][4]);
            } 
            else 
            {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furnitureRot][1] = FurnitureData[fid][furnitureRot][1] + 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_R_Y, FurnitureData[fid][furnitureRot][1]);
            }
        }
    }
    if (textid == MINRY[playerid]) 
    {
        if (IsPlayerInAnyVehicle(playerid)) {
            VehicleData[vid][vToyRotY][slot] = VehicleData[vid][vToyRotY][slot] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_R_Y, VehicleData[vid][vToyRotY][slot]);
        } else {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) 
            {
                TagData[fid][tagPos][4] = TagData[fid][tagPos][4] - 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_Y, TagData[fid][tagPos][4]);
            } 
            else 
            {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furnitureRot][1] = FurnitureData[fid][furnitureRot][1] - 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_R_Y, FurnitureData[fid][furnitureRot][1]);
            }
        }
    }
    if (textid == PLUSRZ[playerid]) 
    {
        if (IsPlayerInAnyVehicle(playerid)) 
        {
            VehicleData[vid][vToyRotZ][slot] = VehicleData[vid][vToyRotZ][slot] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_R_Z, VehicleData[vid][vToyRotZ][slot]);
        } 
        else 
        {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) 
            {
                TagData[fid][tagPos][5] = TagData[fid][tagPos][5] + 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_Z, TagData[fid][tagPos][5]);
            } 
            else 
            {
                if (House_Inside(playerid) == -1)
                    return SendErrorMessage(playerid, "You are no longer inside your house.");

                FurnitureData[fid][furnitureRot][2] = FurnitureData[fid][furnitureRot][2] - 0.2;

                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FurnitureData[fid][furnitureObject], E_STREAMER_R_Z, FurnitureData[fid][furnitureRot][2]);
            }
        }
    }
    if (textid == MINRZ[playerid]) 
    {
        if (IsPlayerInAnyVehicle(playerid)) 
        {
            VehicleData[vid][vToyRotZ][slot] = VehicleData[vid][vToyRotZ][slot] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleData[vid][vToy][slot], E_STREAMER_ATTACH_R_Z, VehicleData[vid][vToyRotZ][slot]);
        } 
        else 
        {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) 
            {
                TagData[fid][tagPos][5] = TagData[fid][tagPos][5] - 0.2;
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_Z, TagData[fid][tagPos][5]);
            } 
        }
    }*/
    /*new fid = PlayerData[playerid][pEditing];// vid = PlayerData[playerid][pVehicle], slot = PlayerData[playerid][pListitem];
    if (playertextid == PLUSX[playerid])
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
    	{
            TagData[fid][tagPos][0] = TagData[fid][tagPos][0] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_X, TagData[fid][tagPos][0]);
        }
    }
    if (playertextid == MINX[playerid])
    {
		if (PlayerData[playerid][pEditType] == EDIT_TAG) 
		{
            TagData[fid][tagPos][0] = TagData[fid][tagPos][0] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_X, TagData[fid][tagPos][0]);
        }
    }
    if (playertextid == PLUSY[playerid])
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
        {
            TagData[fid][tagPos][1] = TagData[fid][tagPos][1] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_Y, TagData[fid][tagPos][1]);
        } 
    }
    if (playertextid == MINY[playerid]) 
    {
        if (PlayerData[playerid][pEditType] == EDIT_TAG) 
        {
            TagData[fid][tagPos][1] = TagData[fid][tagPos][1] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_Y, TagData[fid][tagPos][1]);
        } 
    }
    if (playertextid == PLUSZ[playerid])
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
    	{
            TagData[fid][tagPos][2] = TagData[fid][tagPos][2] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_Z, TagData[fid][tagPos][2]);
        }
    }
    if (playertextid == MINZ[playerid])
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
    	{
            TagData[fid][tagPos][2] = TagData[fid][tagPos][2] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_Z, TagData[fid][tagPos][2]);
        }
    }
    if (playertextid == PLUSRX[playerid])
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
        {
            TagData[fid][tagPos][3] = TagData[fid][tagPos][3] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_X, TagData[fid][tagPos][3]);
        }
    }
    if (playertextid == MINRX[playerid])
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
        {
            TagData[fid][tagPos][3] = TagData[fid][tagPos][3] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_X, TagData[fid][tagPos][3]);
        }
    }
    if (playertextid == PLUSRY[playerid]) 
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
        {
            TagData[fid][tagPos][4] = TagData[fid][tagPos][4] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_Y, TagData[fid][tagPos][4]);
        }
    }
    if (playertextid == MINRY[playerid]) 
   	{
   		if (PlayerData[playerid][pEditType] == EDIT_TAG) 
        {
            TagData[fid][tagPos][4] = TagData[fid][tagPos][4] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_Y, TagData[fid][tagPos][4]);
        }
   	}
    if (playertextid == PLUSRZ[playerid]) 
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
        {
            TagData[fid][tagPos][5] = TagData[fid][tagPos][5] + 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_Z, TagData[fid][tagPos][5]);
        } 
    }
    if (playertextid == MINRZ[playerid]) 
    {
    	if (PlayerData[playerid][pEditType] == EDIT_TAG) 
        {
            TagData[fid][tagPos][5] = TagData[fid][tagPos][5] - 0.2;
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, TagData[fid][tagObject], E_STREAMER_R_Z, TagData[fid][tagPos][5]);
        }
    }
    if (playertextid == FINISHEDIT[playerid]) 
    {
        if (PlayerData[playerid][pEditing] != -1) 
        {
            if (PlayerData[playerid][pEditType] == EDIT_TAG) 
            {
                Tag_Save(fid);
            }
        }
        PlayerData[playerid][pEditing] = -1;
        PlayerData[playerid][pEditType] = EDIT_NONE;
        HideEditTextDraw(playerid);
    }*/
    return 1;
}


