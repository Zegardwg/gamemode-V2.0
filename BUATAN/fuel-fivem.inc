new Text3D:LabelPercentPom[MAX_PLAYERS][MAX_VEHICLES];
new PlayerText3D:Label3DTextPom[MAX_PLAYERS][10];

/*stock Load3DTextLabelPom(playerid)
{
	Label3DTextPom[playerid][0] = CreatePlayer3DTextLabel(playerid, "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm", -1, 1940.7306, -1767.3239, 13.3906, 1.5);
	Label3DTextPom[playerid][1] = CreatePlayer3DTextLabel(playerid, "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm", -1, 1942.6417,- 1767.2101, 13.3906, 1.5);
	Label3DTextPom[playerid][2] = CreatePlayer3DTextLabel(playerid, "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm", -1, 1940.7266, -1771.3771, 13.3906, 1.5);
	Label3DTextPom[playerid][3] = CreatePlayer3DTextLabel(playerid, "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm", -1, 1942.6047, -1771.3789, 13.3906, 1.5);
	Label3DTextPom[playerid][4] = CreatePlayer3DTextLabel(playerid, "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm", -1, 1940.7307, -1774.3478, 13.3906, 1.5);
	Label3DTextPom[playerid][5] = CreatePlayer3DTextLabel(playerid, "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm", -1, 1942.6052, -1774.3477, 13.3906, 1.5);
	Label3DTextPom[playerid][6] = CreatePlayer3DTextLabel(playerid, "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm", -1, 1940.7308, -1778.4882, 13.3906, 1.5);
	Label3DTextPom[playerid][7] = CreatePlayer3DTextLabel(playerid, "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm", -1, 1942.6050, -1778.4884, 13.3906, 1.5);
}*/

stock UpdateAndCancel3DTextLabelPom(playerid)
{
	new strpom[124];
	for(new i = 0; i < 7; i ++)
	{
		format(strpom,sizeof(strpom), "{FFFFFF}Tekan "LG_E"Y {FFFFFF} untuk membatalkan mengisi bbm\nHarga : "LG_E"$%d", PlayerData[playerid][pFuelMoney]);
		UpdatePlayer3DTextLabelText(playerid, Label3DTextPom[playerid][i], 0xFFFFFFFF, strpom);
	}

}

stock Update3DTextLabelPom(playerid)
{
	new strpom[124];
	for(new i = 0; i < 7; i ++)
	{
		format(strpom,sizeof(strpom), "{FFFFFF}Tekan "LG_E"Y {FFFFFF}untuk mengisi bbm");
		UpdatePlayer3DTextLabelText(playerid, Label3DTextPom[playerid][i], 0xFFFFFFFF, strpom);
	}
}

/*GetNearbyPom(playerid)
{
	for(new i = 0; i < 10; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 1.5, 1940.7306, -1767.3239, 13.3906))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1942.6417,- 1767.2101, 13.3906))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1940.7266, -1771.3771 , 13.3906))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1942.6047, -1771.3789, 13.3906))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1940.7307, -1774.3478, 13.3906))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1942.6052, -1774.3477, 13.3906))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1940.7308, -1778.4882, 13.3906))
	    {
	        return i;
	    }
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1940.7308, -1778.4882, 13.3906))
	    {
	        return i;
	    }
	}
	return -1;
}*/

stock Stopfill(playerid)
{
	{
		new PayFuel = PlayerData[playerid][pFuelMoney];
		new vehicleid = GetNearestVehicleToPlayer(playerid, 2.5);

        PlayerData[playerid][pFuelCar] = 0;
		PlayerData[playerid][pFuelMoney] = 0;
        Delete3DTextLabel(LabelPercentPom[playerid][vehicleid]);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
        ClearAnimations(playerid, 1);
		PlayerData[playerid][pApplyAnimation] = false;
		GiveMoney(playerid, -PayFuel);
		new str[500];
        format(str, sizeof(str), "Removed_%dx", PayFuel);
        ShowItemBox(playerid, "Uang", str, 1212, 2);
		Update3DTextLabelPom(playerid);
	}
	return 1;
}

ptask UpdateFuel[1000](playerid)
{
    if(PlayerData[playerid][pFuelCar] == 1)
	{
        
		//new vehid = GetNearestVehicleToPlayer(playerid, 2.5);
        new veh = GetNearestVehicleToPlayer(playerid, 2.5);
        new vehicleid = GetNearestVehicleToPlayer(playerid, 2.5);
		new fuels = GetVehicleFuel(veh);
        new string[32];

		if (GetMoney(playerid) < 1) 
		{
	        ErrorMsg(playerid, "Kamu tidak memiliki cukup uang!");
	        PlayerData[playerid][pFuelCar] = 0;
			PlayerData[playerid][pFuelMoney] = 0;
	        Delete3DTextLabel(LabelPercentPom[playerid][vehicleid]);
			if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
	        ClearAnimations(playerid, 1);
			PlayerData[playerid][pApplyAnimation] = false;
	        Update3DTextLabelPom(playerid);
	    }
        else 
        {
		
			SetVehicleFuel(veh, fuels+1);
			PlayerPlaySound(playerid, 4202, 0.0, 0.0, 0.0);
			//ApplyAnimationForPlayer(playerid, "CAMERA", "camstnd_idleloop", 4.1, 0, 0, 0, 1, 0, 1);
			ApplyAnimation(playerid, "CAMERA", "camstnd_idleloop", 4.1, 0, 0, 0, 1, 0, 1);
			format(string,sizeof(string), "%d%%", fuels);
			Update3DTextLabelText(LabelPercentPom[playerid][vehicleid], 0xFFFFFFFF, string);
			Attach3DTextLabelToVehicle(LabelPercentPom[playerid][vehicleid], vehicleid, -0.3, 0.0, 1.0);
		}
	    if(fuels >= 100)
	    {
			SetVehicleFuel(veh, 100);
			Stopfill(playerid);
	    }
	}
    return 1;
}

ptask UpdatePayFuel[2500](playerid)
{
    if(PlayerData[playerid][pFuelCar] == 1)
    {
		PlayerData[playerid][pFuelMoney] += 1;
        UpdateAndCancel3DTextLabelPom(playerid);
    }
    return 1;
}