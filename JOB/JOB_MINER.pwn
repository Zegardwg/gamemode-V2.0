CreateJoinMiner()
{
	new strings[128];

	format(strings, sizeof(strings), "Miner Job\n{FFFFFF}/mine - to start mining");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 633.89, 828.29, -41.62, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
}

#define GetVehicleBoot(%0,%1,%2,%3)				GetVehicleOffset((%0),VEHICLE_OFFSET_BOOT,(%1),(%2),(%3))

enum OffsetTypes {
	VEHICLE_OFFSET_BOOT,
	VEHICLE_OFFSET_HOOD,
	VEHICLE_OFFSET_ROOF
};

GetVehicleOffset(vehicleid, OffsetTypes:type,&Float:x,&Float:y,&Float:z)
{
	new Float:fPos[4],Float:fSize[3];

	if(!IsValidVehicle(vehicleid)){
		x = y =	z = 0.0;
		return 0;
	} else {
		GetVehiclePos(vehicleid,fPos[0],fPos[1],fPos[2]);
		GetVehicleZAngle(vehicleid,fPos[3]);
		GetVehicleModelInfo(GetVehicleModel(vehicleid),VEHICLE_MODEL_INFO_SIZE,fSize[0],fSize[1],fSize[2]);

		switch(type){
			case VEHICLE_OFFSET_BOOT: {
				x = fPos[0] - (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3],degrees));
				y = fPos[1] - (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3],degrees));
 				z = fPos[2];
			}
			case VEHICLE_OFFSET_HOOD: {
				x = fPos[0] + (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3],degrees));
				y = fPos[1] + (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3],degrees));
	 			z = fPos[2];
			}
			case VEHICLE_OFFSET_ROOF: {
				x = fPos[0];
				y = fPos[1];
				z = fPos[2] + floatsqroot(fSize[2]);
			}
		}
	}
	return 1;
}

CMD:mine(playerid, params[])
{
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
		if(pData[playerid][pJobTime] > 0) 
			return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);

		if(IsPlayerInRangeOfPoint(playerid, 3.5, 633.89, 828.29, -41.62))
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
				return Error(playerid, "Kamu harus turun dari kendaraan!");

			if(GetPlayerWeapon(playerid) != WEAPON_SHOVEL)
				return Error(playerid, "Kamu harus memegang skop/shovel di tanganmu");

			if(pData[playerid][pActivityTime] > 5) 
				return Error(playerid, "Anda masih memiliki activity progress!");

			TogglePlayerControllable(playerid, 0);
			ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 0, 0, 1);
			
			pData[playerid][pMinerBar] = SetTimerEx("MineProgres", 1000, true, "d", playerid);
			//Showbar(playerid, 20, "MENGAMBIL BATU", "MineProgres");
			ShowProgressbar(playerid, "MENGAMBIL BATU", 20);
		}
		else return Error(playerid, "Kamu tidak berada di point mine");
	}
	else return Error(playerid, "Kamu bukan pekerja miner");
	return 1;
}

function MineProgres(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMinerBar])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, 633.89, 828.29, -41.62))
			{
				KillTimer(pData[playerid][pMinerBar]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				InfoTD_MSG(playerid, 3000, "Mine Succes!");

				ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0, 0, 0, 0, 0, 0, 1);
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pMinerStatus] = 1;

				pData[playerid][pHunger] -= 3;
				pData[playerid][pEnergy] -= 3;

				TogglePlayerControllable(playerid, 1);
				ClearAnimations(playerid);

				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				SetPlayerCheckpoint(playerid, 606.96, 866.46, -40.37, 3.5);
				Info(playerid, "Bawa batu yang kamu angkat menuju checkpoint yang telah ditandai");
				SetPlayerAttachedObject(playerid, 9, 3930, 1, 0.002953, 0.469660, -0.009797, 269.851104, 34.443557, 0.000000, 0.804894, 1.000000, 0.822361);
			}
			else
			{
				KillTimer(pData[playerid][pMinerBar]);
				pData[playerid][pActivityTime] = 0;
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 0, 0, 1);
		}
	}
	return 1;
}