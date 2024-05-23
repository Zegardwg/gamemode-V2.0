//Dealer Bisnis
#define MAX_DEALER 500

enum E_DEALER
{
	dOwner[MAX_PLAYER_NAME],
	dName[128],
	//Pickup Stats
	Float:dPosX,
	Float:dPosY,
	Float:dPosZ,
	Float:dPosA,
	dInt,
	dVW,
	dPrice,
	//Pos Vehicle Stats
	Float:dVehX,
	Float:dVehY,
	Float:dVehZ,
	Float:dVehA,
	dVehInt,
	dVehVW,
	//Dealer Menu
	dLock,
	dType,
	dMoney,
	dStock,
	dP[22],
	dVisit,
	//Temp 
	dPickup,
	dIcon,
	Text3D:dLabel,
	Text3D:dLabelSpawn
}

new drData[MAX_DEALER][E_DEALER],
Iterator:Dealer<MAX_DEALER>;

Dealer_Save(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE dealer SET owner='%s', name='%s', price='%d', type='%d', posx='%f', posy='%f', posz='%f', posa='%f', posint='%d', posvw='%d', vehx='%f', vehy='%f', vehz='%f', veha='%f', vehint='%d', vehvw='%d', locked='%d', money='%d', stock='%d', visit='%d'",
	drData[id][dOwner],
	drData[id][dName],
	drData[id][dPrice],
	drData[id][dType],
	drData[id][dPosX],
	drData[id][dPosY],
	drData[id][dPosZ],
	drData[id][dPosA],
	drData[id][dInt],
	drData[id][dVW],
	drData[id][dVehX],
	drData[id][dVehY],
	drData[id][dVehZ],
	drData[id][dVehA],
	drData[id][dVehInt],
	drData[id][dVehVW],
	drData[id][dLock],
	drData[id][dMoney],
	drData[id][dStock],
	drData[id][dVisit]
	);

	format(cQuery, sizeof(cQuery),"%s, vehprice0='%d', vehprice1='%d', vehprice2='%d', vehprice3='%d', vehprice4='%d', vehprice5='%d', vehprice6='%d', vehprice7='%d', vehprice8='%d', vehprice9='%d', vehprice10='%d', vehprice11='%d', vehprice12='%d', vehprice13='%d', vehprice14='%d', vehprice15='%d', vehprice16='%d', vehprice17='%d', vehprice18='%d', vehprice19='%d', vehprice20='%d', vehprice21='%d' WHERE id='%d'",
	cQuery,
	drData[id][dP][0],
	drData[id][dP][1],
	drData[id][dP][2],
	drData[id][dP][3],
	drData[id][dP][4],
	drData[id][dP][5],
	drData[id][dP][6],
	drData[id][dP][7],
	drData[id][dP][8],
	drData[id][dP][9],
	drData[id][dP][10],
	drData[id][dP][11],
	drData[id][dP][12],
	drData[id][dP][13],
	drData[id][dP][14],
	drData[id][dP][15],
	drData[id][dP][16],
	drData[id][dP][17],
	drData[id][dP][18],
	drData[id][dP][19],
	drData[id][dP][20],
	drData[id][dP][21],
	id);
	return mysql_tquery(g_SQL, cQuery);
}

Dealer_Refresh(id)
{
    if(id != -1)
    {
    	if(IsValidDynamicPickup(drData[id][dPickup]))
    		DestroyDynamicPickup(drData[id][dPickup]);

    	if(IsValidDynamic3DTextLabel(drData[id][dLabel]))
    		DestroyDynamic3DTextLabel(drData[id][dLabel]);
    	
    	if(IsValidDynamicMapIcon(drData[id][dIcon]))
    		DestroyDynamicMapIcon(drData[id][dIcon]);

    	if(IsValidDynamic3DTextLabel(drData[id][dLabelSpawn]))
    		DestroyDynamic3DTextLabel(drData[id][dLabelSpawn]);

    	static
    	string[1024], str[1024];

    	new type[128], statusstock[128], stts[128];
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
    		type = "Jobs Vehicles";
    	}
    	else if(drData[id][dType] == 5)
    	{
    		type = "Rental Jobs";
    	}
    	else
    	{
    		type = "{FF0000}Unknown{FFFFFF}";
    	}
    	if(drData[id][dStock] <= 0)
    	{
    		statusstock = "{FF0000}OUT OF STOCK{FFFFFF}";
    	}
    	else
    	{
    		format(stts, sizeof(stts), "%d", drData[id][dStock]);
    		statusstock = stts;
    	}
    	if(strcmp(drData[id][dOwner], "-"))
		{
			format(string, sizeof(string), "[DEALER ID: %d]\n"WHITE_E"Dealer Stock: "GREEN_LIGHT"%s\n{FF0000}"WHITE_E"Dealer Name: "GREEN_LIGHT"%s\n"WHITE_E"Dealer Type: "GREEN_LIGHT"%s\n"WHITE_E"Dealer Location: "GREEN_LIGHT"%s\n"WHITE_E"Owned by %s\n"WHITE_E"/buyveh - to buy vehicle", id, statusstock, drData[id][dName], type, GetLocation(drData[id][dPosX], drData[id][dPosY], drData[id][dPosZ]), drData[id][dOwner]);
			drData[id][dPickup] = CreateDynamicPickup(1239, 23, drData[id][dPosX], drData[id][dPosY], drData[id][dPosZ], drData[id][dVW], drData[id][dInt], _, 15.0);
		}
		else
		{
			format(string, sizeof(string), "[DEALER ID: %d]\n"WHITE_E"this dealer for sell\n"WHITE_E"Dealer Stock: "GREEN_LIGHT"%s\n"WHITE_E"Dealer Type: "GREEN_LIGHT"%s\n"WHITE_E"Dealer Location: "GREEN_LIGHT"%s\n"WHITE_E"Dealer Price: "GREEN_LIGHT"%s"WHITE_E"\n/buyveh - to buy vehicle\n"WHITE_E"/buy - to buy this dealer", id, statusstock, type, GetLocation(drData[id][dPosX], drData[id][dPosY], drData[id][dPosZ]), FormatMoney(drData[id][dPrice]));
			drData[id][dPickup] = CreateDynamicPickup(1239, 23, drData[id][dPosX], drData[id][dPosY], drData[id][dPosZ], drData[id][dVW], drData[id][dInt], _, 15.0);
		}
		format(str, sizeof(str), "[SPAWN DEALER: %d]\n"WHITE_E"the place where the dealer's vehicle appears", id);
		drData[id][dLabel] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, drData[id][dPosX], drData[id][dPosY], drData[id][dPosZ]+0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, drData[id][dVW], drData[id][dInt]);
		drData[id][dLabelSpawn] = CreateDynamic3DTextLabel(str, COLOR_YELLOW, drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ]+0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, drData[id][dVehVW], drData[id][dVehInt]);
		drData[id][dIcon] = CreateDynamicMapIcon(drData[id][dVehX], drData[id][dVehY], drData[id][dVehZ], 55, -1, -1, -1, -1, 50.0);
    }
    return 1;
}

Player_DealerCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Dealer)
	{
		if(Player_OwnsDealer(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

Dealer_SetPrice(id)
{
	if(id != -1)
	{
		if(drData[id][dType] == 1) //Bikes
		{
			drData[id][dP][0] = 450;
			drData[id][dP][1] = 400;
			drData[id][dP][2] = 450;
			drData[id][dP][3] = 550;
			drData[id][dP][4] = 1100;
			drData[id][dP][5] = 1200;
			drData[id][dP][6] = 1275;
			drData[id][dP][7] = 1250;
			drData[id][dP][8] = 1080;
			drData[id][dP][9] = 750;
			drData[id][dP][10] = 0;
			drData[id][dP][11] = 0;
			drData[id][dP][12] = 0;
			drData[id][dP][13] = 0;
			drData[id][dP][14] = 0;
			drData[id][dP][15] = 0;
			drData[id][dP][16] = 0;
			drData[id][dP][17] = 0;
			drData[id][dP][18] = 0;
			drData[id][dP][19] = 0;
			drData[id][dP][20] = 0;
			drData[id][dP][21] = 0;
		}
		else if(drData[id][dType] == 2) //Cars
		{
			drData[id][dP][0] = 1350;
			drData[id][dP][1] =	1300;
			drData[id][dP][2] = 1420;
			drData[id][dP][3] = 1400;
			drData[id][dP][4] = 1380;
			drData[id][dP][5] = 1330;
			drData[id][dP][6] = 2000;
			drData[id][dP][7] = 1320;
			drData[id][dP][8] = 1345;
			drData[id][dP][9] = 2235;
			drData[id][dP][10] = 2250;
			drData[id][dP][11] = 2310;
			drData[id][dP][12] = 2230;
			drData[id][dP][13] = 1350;
			drData[id][dP][14] = 1370;
			drData[id][dP][15] = 2100;
			drData[id][dP][16] = 2700;
			drData[id][dP][17] = 2500;
			drData[id][dP][18] = 2400;
			drData[id][dP][19] = 2000;
			drData[id][dP][20] = 0;
			drData[id][dP][21] = 0;
		}
		else if(drData[id][dType] == 3) //Unique Cars
		{
			drData[id][dP][0] = 2450;
			drData[id][dP][1] = 1450;
			drData[id][dP][2] = 2000;
			drData[id][dP][3] = 4300;
			drData[id][dP][4] = 4500;
			drData[id][dP][5] = 4750;
			drData[id][dP][6] = 3300;
			drData[id][dP][7] = 4650;
			drData[id][dP][8] = 2100;
			drData[id][dP][9] = 2300;
			drData[id][dP][10] = 2350;
			drData[id][dP][11] = 1750;
			drData[id][dP][12] = 0;
			drData[id][dP][13] = 0;
			drData[id][dP][14] = 0;
			drData[id][dP][15] = 0;
			drData[id][dP][16] = 0;
			drData[id][dP][17] = 0;
			drData[id][dP][18] = 0;
			drData[id][dP][19] = 0;
			drData[id][dP][20] = 0;
			drData[id][dP][21] = 0;

		}
		else if(drData[id][dType] == 4) //Job Cars
		{
			drData[id][dP][0] = 1550;
			drData[id][dP][1] = 1500;
			drData[id][dP][2] = 3200;
			drData[id][dP][3] = 1475;
			drData[id][dP][4] = 1456;
			drData[id][dP][5] = 1487;
			drData[id][dP][6] = 1320;
			drData[id][dP][7] = 1980;
			drData[id][dP][8] = 1980;
			drData[id][dP][9] = 1980;
			drData[id][dP][10] = 1476;
			drData[id][dP][11] = 1476;
			drData[id][dP][12] = 1476;
			drData[id][dP][13] = 1476;
			drData[id][dP][14] = 1476;
			drData[id][dP][15] = 1750;
			drData[id][dP][16] = 1476;
			drData[id][dP][17] = 1476;
			drData[id][dP][18] = 1320;
			drData[id][dP][19] = 1320;
			drData[id][dP][20] = 1476;
			drData[id][dP][21] = 0;
		}
		else if(drData[id][dType] == 5) //Rental Jobs
		{
			drData[id][dP][0] = 350;
			drData[id][dP][1] = 350;
			drData[id][dP][2] = 350;
			drData[id][dP][3] = 350;
			drData[id][dP][4] = 350;
			drData[id][dP][5] = 350;
			drData[id][dP][6] = 350;
			drData[id][dP][7] = 350;
			drData[id][dP][8] = 350;
			drData[id][dP][9] = 350;
			drData[id][dP][10] = 350;
			drData[id][dP][11] = 350;
			drData[id][dP][12] = 350;
			drData[id][dP][13] = 350;
			drData[id][dP][14] = 0;
			drData[id][dP][15] = 0;
			drData[id][dP][16] = 0;
			drData[id][dP][17] = 0;
			drData[id][dP][18] = 0;
			drData[id][dP][19] = 0;
			drData[id][dP][20] = 0;
			drData[id][dP][21] = 0;
		}
		else //Invalid Type ID
		{
			drData[id][dP][0] = 0;
			drData[id][dP][1] = 0;
			drData[id][dP][2] = 0;
			drData[id][dP][3] = 0;
			drData[id][dP][4] = 0;
			drData[id][dP][5] = 0;
			drData[id][dP][6] = 0;
			drData[id][dP][7] = 0;
			drData[id][dP][8] = 0;
			drData[id][dP][9] = 0;
			drData[id][dP][10] = 0;
			drData[id][dP][11] = 0;
			drData[id][dP][12] = 0;
			drData[id][dP][13] = 0;
			drData[id][dP][14] = 0;
			drData[id][dP][15] = 0;
			drData[id][dP][16] = 0;
			drData[id][dP][17] = 0;
			drData[id][dP][18] = 0;
			drData[id][dP][19] = 0;
			drData[id][dP][20] = 0;
			drData[id][dP][21] = 0;
		}
	}
	return 1;
}

Dealer_BuyMenu(playerid, deid)
{
    if(deid != -1)
    {
	    switch (drData[deid][dType])
	    {
	        case 1:
	        {
	            if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");

				//Bikes
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
				GetVehicleModelName(481), FormatMoney(drData[deid][dP][0]), 
				GetVehicleModelName(509), FormatMoney(drData[deid][dP][1]),
				GetVehicleModelName(510), FormatMoney(drData[deid][dP][2]),
				GetVehicleModelName(462), FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(586), FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(581), FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(461), FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(521), FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(463), FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(468), FormatMoney(drData[deid][dP][9])
				);
						
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_BIKES, DIALOG_STYLE_LIST, "Bikes", str, "Buy", "Close");
	        }
	        case 2:
	        {
	        	if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");

	           	//Cars
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
				GetVehicleModelName(400), FormatMoney(drData[deid][dP][0]), 
				GetVehicleModelName(412), FormatMoney(drData[deid][dP][1]),
				GetVehicleModelName(419), FormatMoney(drData[deid][dP][2]),
				GetVehicleModelName(426), FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(436), FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(466), FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(467), FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(474), FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(475), FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(480), FormatMoney(drData[deid][dP][9]),
				GetVehicleModelName(603), FormatMoney(drData[deid][dP][10]),
				GetVehicleModelName(421), FormatMoney(drData[deid][dP][11]),
				GetVehicleModelName(602), FormatMoney(drData[deid][dP][12]),
				GetVehicleModelName(492), FormatMoney(drData[deid][dP][13]),
				GetVehicleModelName(545), FormatMoney(drData[deid][dP][14]),
				GetVehicleModelName(489), FormatMoney(drData[deid][dP][15]),
				GetVehicleModelName(405), FormatMoney(drData[deid][dP][16]),
				GetVehicleModelName(445), FormatMoney(drData[deid][dP][17]),
				GetVehicleModelName(579), FormatMoney(drData[deid][dP][18]),
				GetVehicleModelName(507), FormatMoney(drData[deid][dP][19])
				);
						
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CARS, DIALOG_STYLE_LIST, "Cars", str, "Buy", "Close");
	        }
	        case 3:
	        {
	        	if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");

				//Unique Cars
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
				GetVehicleModelName(483), FormatMoney(drData[deid][dP][0]), 
				GetVehicleModelName(535), FormatMoney(drData[deid][dP][1]),
				GetVehicleModelName(536), FormatMoney(drData[deid][dP][2]),
				GetVehicleModelName(558), FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(559), FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(560), FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(561), FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(562), FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(565), FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(567), FormatMoney(drData[deid][dP][9]),
				GetVehicleModelName(575), FormatMoney(drData[deid][dP][10]),
				GetVehicleModelName(576), FormatMoney(drData[deid][dP][11])
				);
				
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_UCARS, DIALOG_STYLE_LIST, "Unique Cars", str, "Buy", "Close");
	        }
	        case 4:
	        {
	        	if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");
				
				//Job Cars
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s", 
				GetVehicleModelName(420), FormatMoney(drData[deid][dP][0]), 
				GetVehicleModelName(438), FormatMoney(drData[deid][dP][1]), 
				GetVehicleModelName(403), FormatMoney(drData[deid][dP][2]), 
				GetVehicleModelName(413), FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(414), FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(422), FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(440), FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(455), FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(456), FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(478), FormatMoney(drData[deid][dP][9]),
				GetVehicleModelName(482), FormatMoney(drData[deid][dP][10]),
				GetVehicleModelName(498), FormatMoney(drData[deid][dP][11]),
				GetVehicleModelName(499), FormatMoney(drData[deid][dP][12]),
				GetVehicleModelName(423), FormatMoney(drData[deid][dP][13]),
				GetVehicleModelName(588), FormatMoney(drData[deid][dP][14]),
				GetVehicleModelName(524), FormatMoney(drData[deid][dP][15]),
				GetVehicleModelName(525), FormatMoney(drData[deid][dP][16]),
				GetVehicleModelName(543), FormatMoney(drData[deid][dP][17]),
				GetVehicleModelName(552), FormatMoney(drData[deid][dP][18]),
				GetVehicleModelName(554), FormatMoney(drData[deid][dP][19]),
				GetVehicleModelName(578), FormatMoney(drData[deid][dP][20]),
				GetVehicleModelName(609), FormatMoney(drData[deid][dP][21])
				//GetVehicleModelName(530), FormatMoney(530)) //fortklift
				);
						
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_JOBCARS, DIALOG_STYLE_LIST, "Job Cars", str, "Buy", "Close");
	        }
	        case 5:
	        {
	        	if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");
				
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days",
				GetVehicleModelName(414),
				FormatMoney(drData[deid][dP][0]),
				GetVehicleModelName(455),
				FormatMoney(drData[deid][dP][1]), 
				GetVehicleModelName(456),
				FormatMoney(drData[deid][dP][2]),
				GetVehicleModelName(498),
				FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(499),
				FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(609),
				FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(478),
				FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(422),
				FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(543),
				FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(554),
				FormatMoney(drData[deid][dP][9]),
				GetVehicleModelName(525),
				FormatMoney(drData[deid][dP][10]),
				GetVehicleModelName(438),
				FormatMoney(drData[deid][dP][11]),
				GetVehicleModelName(420),
				FormatMoney(drData[deid][dP][12]),
				GetVehicleModelName(403),
				FormatMoney(drData[deid][dP][13])
				);
						
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARS, DIALOG_STYLE_LIST, "Rent Job Cars", str, "Rent", "Close");
			}
	    }
	}
    return 1;
}

Dealer_ProductMenu(playerid, deid)
{
    if(deid != -1)
    {
	    switch (drData[deid][dType])
	    {
	        case 1:
	        {
	            if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");

				//Bikes
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
				GetVehicleModelName(481), FormatMoney(drData[deid][dP][0]), 
				GetVehicleModelName(509), FormatMoney(drData[deid][dP][1]),
				GetVehicleModelName(510), FormatMoney(drData[deid][dP][2]),
				GetVehicleModelName(462), FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(586), FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(581), FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(461), FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(521), FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(463), FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(468), FormatMoney(drData[deid][dP][9])
				);
						
				ShowPlayerDialog(playerid, DEALER_EDITPROD, DIALOG_STYLE_LIST, "Bikes", str, "Buy", "Close");
	        }
	        case 2:
	        {
	        	if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");

	           	//Cars
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
				GetVehicleModelName(400), FormatMoney(drData[deid][dP][0]), 
				GetVehicleModelName(412), FormatMoney(drData[deid][dP][1]),
				GetVehicleModelName(419), FormatMoney(drData[deid][dP][2]),
				GetVehicleModelName(426), FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(436), FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(466), FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(467), FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(474), FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(475), FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(480), FormatMoney(drData[deid][dP][9]),
				GetVehicleModelName(603), FormatMoney(drData[deid][dP][10]),
				GetVehicleModelName(421), FormatMoney(drData[deid][dP][11]),
				GetVehicleModelName(602), FormatMoney(drData[deid][dP][12]),
				GetVehicleModelName(492), FormatMoney(drData[deid][dP][13]),
				GetVehicleModelName(545), FormatMoney(drData[deid][dP][14]),
				GetVehicleModelName(489), FormatMoney(drData[deid][dP][15]),
				GetVehicleModelName(405), FormatMoney(drData[deid][dP][16]),
				GetVehicleModelName(445), FormatMoney(drData[deid][dP][17]),
				GetVehicleModelName(579), FormatMoney(drData[deid][dP][18]),
				GetVehicleModelName(507), FormatMoney(drData[deid][dP][19])
				);
						
				ShowPlayerDialog(playerid, DEALER_EDITPROD, DIALOG_STYLE_LIST, "Cars", str, "Buy", "Close");
	        }
	        case 3:
	        {
	        	if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");

				//Unique Cars
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
				GetVehicleModelName(483), FormatMoney(drData[deid][dP][0]), 
				GetVehicleModelName(535), FormatMoney(drData[deid][dP][1]),
				GetVehicleModelName(536), FormatMoney(drData[deid][dP][2]),
				GetVehicleModelName(558), FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(559), FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(560), FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(561), FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(562), FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(565), FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(567), FormatMoney(drData[deid][dP][9]),
				GetVehicleModelName(575), FormatMoney(drData[deid][dP][10]),
				GetVehicleModelName(576), FormatMoney(drData[deid][dP][11])
				);
				
				ShowPlayerDialog(playerid, DEALER_EDITPROD, DIALOG_STYLE_LIST, "Unique Cars", str, "Buy", "Close");
	        }
	        case 4:
	        {
	        	if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");
				
				//Job Cars
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s", 
				GetVehicleModelName(420), FormatMoney(drData[deid][dP][0]), 
				GetVehicleModelName(438), FormatMoney(drData[deid][dP][1]), 
				GetVehicleModelName(403), FormatMoney(drData[deid][dP][2]), 
				GetVehicleModelName(413), FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(414), FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(422), FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(440), FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(455), FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(456), FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(478), FormatMoney(drData[deid][dP][9]),
				GetVehicleModelName(482), FormatMoney(drData[deid][dP][10]),
				GetVehicleModelName(498), FormatMoney(drData[deid][dP][11]),
				GetVehicleModelName(499), FormatMoney(drData[deid][dP][12]),
				GetVehicleModelName(423), FormatMoney(drData[deid][dP][13]),
				GetVehicleModelName(588), FormatMoney(drData[deid][dP][14]),
				GetVehicleModelName(524), FormatMoney(drData[deid][dP][15]),
				GetVehicleModelName(525), FormatMoney(drData[deid][dP][16]),
				GetVehicleModelName(543), FormatMoney(drData[deid][dP][17]),
				GetVehicleModelName(552), FormatMoney(drData[deid][dP][18]),
				GetVehicleModelName(554), FormatMoney(drData[deid][dP][19]),
				GetVehicleModelName(578), FormatMoney(drData[deid][dP][20]),
				GetVehicleModelName(609), FormatMoney(drData[deid][dP][21])
				//GetVehicleModelName(530), FormatMoney(530)) //fortklift
				);
						
				ShowPlayerDialog(playerid, DEALER_EDITPROD, DIALOG_STYLE_LIST, "Job Cars", str, "Buy", "Close");
	        }
	        case 5:
	        {
	        	if(pData[playerid][pGetDEID] == -1)
					return Error(playerid, "Ada kesalahan penginputan pada data kamu, kamu harus relog.");

				if(drData[deid][dVehX] == 0 && drData[deid][dVehY] == 0 && drData[deid][dVehZ] == 0)
					return Error(playerid, "Dealer ini belum memiliki spawn point kendaraan.");

				if(drData[deid][dStock] <= 0)
					return Error(playerid, "Dealer ini kehabisan stock.");
				
				new str[1024];
				format(str, sizeof(str), ""WHITE_E"%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days\n%s\t"LG_E"%s / one days",
				GetVehicleModelName(414),
				FormatMoney(drData[deid][dP][0]),
				GetVehicleModelName(455),
				FormatMoney(drData[deid][dP][1]), 
				GetVehicleModelName(456),
				FormatMoney(drData[deid][dP][2]),
				GetVehicleModelName(498),
				FormatMoney(drData[deid][dP][3]),
				GetVehicleModelName(499),
				FormatMoney(drData[deid][dP][4]),
				GetVehicleModelName(609),
				FormatMoney(drData[deid][dP][5]),
				GetVehicleModelName(478),
				FormatMoney(drData[deid][dP][6]),
				GetVehicleModelName(422),
				FormatMoney(drData[deid][dP][7]),
				GetVehicleModelName(543),
				FormatMoney(drData[deid][dP][8]),
				GetVehicleModelName(554),
				FormatMoney(drData[deid][dP][9]),
				GetVehicleModelName(525),
				FormatMoney(drData[deid][dP][10]),
				GetVehicleModelName(438),
				FormatMoney(drData[deid][dP][11]),
				GetVehicleModelName(420),
				FormatMoney(drData[deid][dP][12]),
				GetVehicleModelName(403),
				FormatMoney(drData[deid][dP][13])
				);
				ShowPlayerDialog(playerid, DEALER_EDITPROD, DIALOG_STYLE_LIST, "Rent Job Cars", str, "Rent", "Close");
			}
	    }
   	}
    return 1;
}

Player_OwnsDealer(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(drData[id][dOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

function LoadDealer()
{
    static deid;
	
	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", deid);
			cache_get_value_name(i, "owner", owner);
			format(drData[deid][dOwner], 128, owner);
			cache_get_value_name(i, "name", name);
			format(drData[deid][dName], 128, name);
			cache_get_value_name_int(i, "price", drData[deid][dPrice]);
			cache_get_value_name_int(i, "type", drData[deid][dType]);
			cache_get_value_name_float(i, "posx", drData[deid][dPosX]);
			cache_get_value_name_float(i, "posy", drData[deid][dPosY]);
			cache_get_value_name_float(i, "posz", drData[deid][dPosZ]);
			cache_get_value_name_float(i, "posa", drData[deid][dPosA]);
			cache_get_value_name_int(i, "posint", drData[deid][dInt]);
			cache_get_value_name_int(i, "posvw", drData[deid][dVW]);

			cache_get_value_name_float(i, "vehx", drData[deid][dVehX]);
			cache_get_value_name_float(i, "vehy", drData[deid][dVehY]);
			cache_get_value_name_float(i, "vehz", drData[deid][dVehZ]);
			cache_get_value_name_float(i, "veha", drData[deid][dVehA]);
			cache_get_value_name_int(i, "vehint", drData[deid][dVehInt]);
			cache_get_value_name_int(i, "vehvw", drData[deid][dVehVW]);

			cache_get_value_name_int(i, "locked", drData[deid][dLock]);
			cache_get_value_name_int(i, "money", drData[deid][dMoney]);
			cache_get_value_name_int(i, "stock", drData[deid][dStock]);
			cache_get_value_name_int(i, "visit", drData[deid][dVisit]);

			cache_get_value_name_int(i, "vehprice0", drData[deid][dP][0]);
			cache_get_value_name_int(i, "vehprice1", drData[deid][dP][1]);
			cache_get_value_name_int(i, "vehprice2", drData[deid][dP][2]);
			cache_get_value_name_int(i, "vehprice3", drData[deid][dP][3]);
			cache_get_value_name_int(i, "vehprice4", drData[deid][dP][4]);
			cache_get_value_name_int(i, "vehprice5", drData[deid][dP][5]);
			cache_get_value_name_int(i, "vehprice6", drData[deid][dP][6]);
			cache_get_value_name_int(i, "vehprice7", drData[deid][dP][7]);
			cache_get_value_name_int(i, "vehprice8", drData[deid][dP][8]);
			cache_get_value_name_int(i, "vehprice9", drData[deid][dP][9]);
			cache_get_value_name_int(i, "vehprice10", drData[deid][dP][10]);
			cache_get_value_name_int(i, "vehprice11", drData[deid][dP][11]);
			cache_get_value_name_int(i, "vehprice12", drData[deid][dP][12]);
			cache_get_value_name_int(i, "vehprice13", drData[deid][dP][13]);
			cache_get_value_name_int(i, "vehprice14", drData[deid][dP][14]);
			cache_get_value_name_int(i, "vehprice15", drData[deid][dP][15]);
			cache_get_value_name_int(i, "vehprice16", drData[deid][dP][16]);
			cache_get_value_name_int(i, "vehprice17", drData[deid][dP][17]);
			cache_get_value_name_int(i, "vehprice18", drData[deid][dP][18]);
			cache_get_value_name_int(i, "vehprice19", drData[deid][dP][19]);
			cache_get_value_name_int(i, "vehprice20", drData[deid][dP][20]);
			cache_get_value_name_int(i, "vehprice21", drData[deid][dP][21]);
			Dealer_Refresh(deid);
			Iter_Add(Dealer, deid);
		}
		printf("[Dealer Business] Number of Loaded: %d.", rows);
	}
}

CMD:createdealer(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new query[512];
	new deid = Iter_Free(Dealer);
	if(deid == -1)
		return Error(playerid, "You cant create more dealer!");

	new price, type;
	if(sscanf(params, "dd", price, type))
	{
		Usage(playerid, "/createdealer [price] [type]");
		Names(playerid, "[NAMES]: {ffffff} 1.Bikes 2.Cars 3.Unique Cars 4.Job Cars 5.Rental Jobs");
		return 1;
	}

	format(drData[deid][dOwner], 128, "-");
	format(drData[deid][dName], 128, "No Name");
	GetPlayerPos(playerid, drData[deid][dPosX], drData[deid][dPosY], drData[deid][dPosZ]);
	GetPlayerFacingAngle(playerid, drData[deid][dPosA]);
	drData[deid][dInt] = GetPlayerInterior(playerid);
	drData[deid][dVW] = GetPlayerVirtualWorld(playerid);
	drData[deid][dPrice] = price;
	drData[deid][dType] = type;
	Dealer_SetPrice(deid);
	Dealer_Refresh(deid);
	Iter_Add(Dealer, deid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO dealer SET id='%d', owner='%s', name='%s', type='%d', price='%d'", deid, drData[deid][dOwner], drData[deid][dName], drData[deid][dType], drData[deid][dPrice]);
	mysql_tquery(g_SQL, query, "OnDealerCreated", "i", deid);
	return 1;
}

function OnDealerCreated(deid)
{
	Dealer_Save(deid);
	return 1;
}

Dealer_Reset(id)
{
	format(drData[id][dOwner], MAX_PLAYER_NAME, "-");
	format(drData[id][dName], 128, "No Name");
	drData[id][dMoney] = 0;
    drData[id][dStock] = 0;
    drData[id][dVisit] = 0;
	Dealer_Refresh(id);
}
	

CMD:editdealer(playerid, params[])
{
    static
        deid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", deid, type, string))
    {
        Usage(playerid, "/editdealer [id] [name]");
        Names(playerid, "location, spawnpoint, price, type, owner, prodprice, money, stock, reset, delete");
        return 1;
    }
    if((deid < 0 || deid >= MAX_DEALER))
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Dealer, deid))
		return Error(playerid, "The dealer you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, drData[deid][dPosX], drData[deid][dPosY], drData[deid][dPosZ]);
		GetPlayerFacingAngle(playerid, drData[deid][dPosA]);
		drData[deid][dInt] = GetPlayerInterior(playerid);
		drData[deid][dVW] = GetPlayerVirtualWorld(playerid);
        Dealer_Save(deid);
		Dealer_Refresh(deid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of dealer ID: %d.", pData[playerid][pAdminname], deid);
    }
    else if(!strcmp(type, "spawnpoint",true))
    {
    	GetPlayerPos(playerid, drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]);
    	GetPlayerFacingAngle(playerid, drData[deid][dVehA]);
    	drData[deid][dVehInt] = GetPlayerInterior(playerid);
    	drData[deid][dVehVW] = GetPlayerVirtualWorld(playerid);
    	Dealer_Save(deid);
    	Dealer_Refresh(deid);

    	SendAdminMessage(COLOR_RED, "%s has adjusted the spawn point vehicle of dealer ID: %d.", pData[playerid][pAdminname], deid);
    }
    else if(!strcmp(type, "price",true))
    {
    	new price;
    	if(sscanf(string, "d", price))
    		return Usage(playerid, "/editdealer [id] [price] [ammount]");

    	if(price < 0)
    		return Error(playerid, "Angka tidak boleh dibawah 0!");

    	drData[deid][dPrice] = price;
    	Dealer_Save(deid);
    	Dealer_Refresh(deid);
    	SendAdminMessage(COLOR_RED, "%s has adjusted the price of dealer ID: %d to %s.", pData[playerid][pAdminname], deid, FormatMoney(price));
    }
    else if(!strcmp(type, "owner", true))
    {
        new owners[MAX_PLAYER_NAME];

        if(sscanf(string, "s[32]", owners))
            return Usage(playerid, "/editdealer [id] [owner] [player name] (use '-' to no owner)");

        format(drData[deid][dOwner], MAX_PLAYER_NAME, owners);
  		drData[deid][dVisit] = gettime() + (86400 * 30);

        Dealer_Save(deid);
		Dealer_Refresh(deid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of dealer ID: %d to %s", pData[playerid][pAdminname], deid, owners);
    }
    else if(!strcmp(type, "stock",true))
    {
    	new ammount;
    	if(sscanf(string, "d", ammount))
    		return Usage(playerid, "/editdealer [id] [stock] [ammount]");

    	if(ammount < 0)
    		return Error(playerid, "Angka tidak boleh dibawah 0!");

    	drData[deid][dStock] = ammount;
    	Dealer_Save(deid);
    	Dealer_Refresh(deid);

    	SendAdminMessage(COLOR_RED, "%s has adjusted the stock vehicle of dealer ID: %d to %d.", pData[playerid][pAdminname], deid, ammount);
    }
    else if(!strcmp(type, "type",true))
    {
    	new typeid;
    	if(sscanf(string, "d", typeid))
    	{
    		Usage(playerid, "/editdealer [id] [type] [typeid]");
    		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]: {ffffff} 1.Bikes 2.Cars 3.Unique Cars 4.Job Cars 5.Rental Jobs");
    		return 1;
    	}

    	if(typeid < 1 || typeid > 5)
    		return Error(playerid, "Type dealer only 1 - 5!");

    	drData[deid][dType] = typeid;
    	Dealer_SetPrice(deid);
    	Dealer_Save(deid);
    	Dealer_Refresh(deid);
    	SendAdminMessage(COLOR_RED, "%s has adjusted the type of dealer ID: %d to %d.", pData[playerid][pAdminname], deid, typeid);
    }
    else if(!strcmp(type, "prodprice",true))
    {
    	Dealer_SetPrice(deid);
    	Dealer_Save(deid);
    	Dealer_Refresh(deid);
    	SendAdminMessage(COLOR_RED, "%s has adjusted the product price of dealer ID: %d.", pData[playerid][pAdminname], deid);
    }
    else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return Usage(playerid, "/editdealer [id] [money] [Ammount]");

        if(money < 0)
    		return Error(playerid, "Angka tidak boleh dibawah 0!");

        drData[deid][dMoney] = money;
        Dealer_Save(deid);
		Dealer_Refresh(deid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the money of dealer ID: %d to %s.", pData[playerid][pAdminname], deid, FormatMoney(money));
    }
    else if(!strcmp(type, "reset", true))
    {
        Dealer_Reset(deid);
        Dealer_SetPrice(deid);
		Dealer_Save(deid);
		Dealer_Refresh(deid);
        SendAdminMessage(COLOR_RED, "%s has reset dealer ID: %d.", pData[playerid][pAdminname], deid);
    }
	else if(!strcmp(type, "delete", true))
    {
		Dealer_Reset(deid);
		
		DestroyDynamic3DTextLabel(drData[deid][dLabel]);
		DestroyDynamic3DTextLabel(drData[deid][dLabelSpawn]);
		DestroyDynamicMapIcon(drData[deid][dIcon]);
        DestroyDynamicPickup(drData[deid][dPickup]);
		
		drData[deid][dPrice] = 0;
		drData[deid][dPosX] = 0;
		drData[deid][dPosY] = 0;
		drData[deid][dPosZ] = 0;
		drData[deid][dPosA] = 0;
		drData[deid][dInt] = 0;
		drData[deid][dVW] = 0;

		drData[deid][dVehX] = 0;
		drData[deid][dVehY] = 0;
		drData[deid][dVehZ] = 0;
		drData[deid][dVehA] = 0;
		drData[deid][dVehInt] = 0;
		drData[deid][dVehVW] = 0;

		drData[deid][dLabel] = Text3D: INVALID_3DTEXT_ID;
		drData[deid][dLabelSpawn] = Text3D: INVALID_3DTEXT_ID;
		drData[deid][dPickup] = -1;
		
		Iter_Remove(Dealer, deid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM dealer WHERE id=%d", deid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete dealer ID: %d.", pData[playerid][pAdminname], deid);
	}
    return 1;
}

CMD:gotodealer(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return PermissionError(playerid);

	new deid, type[128];
	if(sscanf(params, "ds[128]", deid, type))
	{
		Usage(playerid, "/gotodealer [id] [type]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{ffffff} pickup, spawnpoint");
		return 1;
	}

	if(!Iter_Contains(Dealer, deid))
		return Error(playerid, "The Dealer you specified ID of doesn't exist.");
	
	if(!strcmp(type, "pickup", true))
	{
		SetPlayerPos(playerid, drData[deid][dPosX], drData[deid][dPosY], drData[deid][dPosZ]);
		SetPlayerInterior(playerid, drData[deid][dInt]);
		SetPlayerVirtualWorld(playerid, drData[deid][dVW]);
	}
	else if(!strcmp(type, "spawnpoint", true))
	{
		SetPlayerPos(playerid, drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]);
		SetPlayerInterior(playerid, drData[deid][dVehInt]);
		SetPlayerVirtualWorld(playerid, drData[deid][dVehVW]);
	}
	return 1;
}

CMD:dem(playerid, params[])
{
	foreach(new deid : Dealer)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, drData[deid][dPosX], drData[deid][dPosY], drData[deid][dPosZ]))
		{
			if(drData[deid][dLock] >= 1)
				return Error(playerid, "Dealer ini sedang disegel oleh pemerintah");

			pData[playerid][pGetDEID] = deid;
			if(!Player_OwnsDealer(playerid, pData[playerid][pGetDEID]))
				return Error(playerid, "Kamu bukan pemilik dealer ini.");

			new str[128];
			format(str, sizeof(str), "Dealer Menu (ID : %d)", deid);
		    ShowPlayerDialog(playerid, DEALER_MENU, DIALOG_STYLE_LIST, str,"Dealer Info\nChange Name\nDealer Vault\nProduct Menu","Next","Close");
		}
	}
    return 1;
}

GetOwnedDealer(playerid)
{
	new tmpcount;
	foreach(new deid : Dealer)
	{
	    if(!strcmp(drData[deid][dOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
ReturnPlayerDealerID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new deid : Dealer)
	{
	    if(!strcmp(pData[playerid][pName], drData[deid][dOwner], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return deid;
  			}
	    }
	}
	return -1;
}

CMD:selldealer(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 910.90, 256.46, 1289.98)) return Error(playerid, "Anda harus berada di City Hall!");
	if(GetOwnedDealer(playerid) == 0) return Error(playerid, "Anda tidak memiliki Dealer.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new deid, _tmpstring[128], count = GetOwnedDealer(playerid), CMDSString[512];
	CMDSString = "";
	Loop(itt, (count + 1), 1)
	{
	    deid = ReturnPlayerDealerID(playerid, itt);
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, drData[deid][dName], GetLocation(drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]));
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, drData[deid][dName], GetLocation(drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]));
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_SELL_DEALER, DIALOG_STYLE_LIST, "Sell Dealer", CMDSString, "Sell", "Cancel");
	return 1;
}

CMD:mydealer(playerid)
{
	if(GetOwnedDealer(playerid) == 0) return Error(playerid, "Anda tidak memiliki bisnis dealer.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new deid, _tmpstring[128], count = GetOwnedDealer(playerid), CMDSString[512];
	CMDSString = "";
	Loop(itt, (count + 1), 1)
	{
	    deid = ReturnPlayerDealerID(playerid, itt);
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   {ffffff}(%s)\n", itt, drData[deid][dName], GetLocation(drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]));
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  {ffffff}(%s)\n", itt, drData[deid][dName], GetLocation(drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]));
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_DEALER, DIALOG_STYLE_LIST, "{FF0000}GloryPeace {0000FF}Dealer", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:givedealer(playerid, params[])
{
	new deid, otherid;
	if(sscanf(params, "ud", otherid, deid)) return Usage(playerid, "/givedealer [playerid/name] [id] | /mydealer - for show info");
	if(deid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "Player tersebut telah disconnect/tidak berada didekat dirimu.");
	
	if(!Player_OwnsDealer(playerid, deid)) return Error(playerid, "Kamu tidak memiliki Dealer ini.");
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_DealerCount(otherid) + 1 > 2) return Error(playerid, "Target Player tidak dapat memiliki dealer lebih.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_DealerCount(otherid) + 1 > 3) return Error(playerid, "Target Player tidak dapat memiliki dealer lebih.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_DealerCount(otherid) + 1 > 4) return Error(playerid, "Target Player tidak dapat memiliki dealer lebih.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_DealerCount(otherid) + 1 > 1) return Error(playerid, "Target Player tidak dapat memiliki dealer lebih.");
		#endif
	}
	GetPlayerName(otherid, drData[deid][dOwner], MAX_PLAYER_NAME);
	
	Dealer_Refresh(deid);
	Dealer_Save(deid);
	Info(playerid, "Anda memberikan dealer id: %d kepada %s", deid, ReturnName(otherid));
	Info(otherid, "%s memberikan dealer id: %d kepada anda", ReturnName(playerid), deid);
	return 1;
}

CMD:belikendarran(playerid, params[])
{
	new count = 0;
	foreach(new deid : Dealer)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, drData[deid][dPosX], drData[deid][dPosY], drData[deid][dPosZ]))
		{
			if(drData[deid][dLock] >= 1)
				return Error(playerid, "Dealer ini sedang disegel oleh pemerintah");

			count++;
			pData[playerid][pGetDEID] = deid;
			Dealer_BuyMenu(playerid, pData[playerid][pGetDEID]);
		}
	}

	if(count < 1)
		return Error(playerid, "Kamu harus berada didekat buy point dealer");
	
	return 1;
}

CMD:spdealerall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
	
	new type, price;
	if(sscanf(params, "dd", type, price))
	{
		Usage(playerid, "/spdealerall [type] [price]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]: {ffffff} 1.Bikes 2.Cars 3.Unique Cars 4.Job Cars 5.Rental Jobs");
		return 1;
	}

	if(type < 1 || type > 5)
		return Error(playerid, "Dealer type only 1-5");

	new count = 0;
	foreach(new deid : Dealer)
	{
		if(drData[deid][dType] == type)
		{
			drData[deid][dPrice] = price;
			Dealer_Refresh(deid);
			Dealer_Save(deid);
		}
		count++;
	}
	SendStaffMessage(COLOR_RED, "Staff %s telah mengeset harga semua dealer type %d menjadi %s.", pData[playerid][pAdminname], type, FormatMoney(price));
	return 1;
}

CMD:sipdealerall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
	
	new type;
	if(sscanf(params, "dd", type))
	{
		Usage(playerid, "/sipdealerall [type] [1.Bikes 2.Cars 3.Unique Cars 4.Job Cars 5.Rental Jobs]");
		return 1;
	}

	if(type < 1 || type > 5)
		return Error(playerid, "Dealer type only 1-5");
	new count = 0;
	foreach(new deid : Dealer)
	{
		if(drData[deid][dType] == type)
		{
			Dealer_SetPrice(deid);
			Dealer_Refresh(deid);
			Dealer_Save(deid);
		}
		count++;
	}	
	SendStaffMessage(COLOR_RED, "Staff %s telah mengeset Semua harga Kendaraan di dealer %d.", pData[playerid][pAdminname], type);
	return 1;
}

/*
	//--------- [ENUM PLAYER]--------
	//DEALER
	pGetDEID,
	pGetDEIDPRICE,

	//---------[ENUM DIALOG]-----------
	//DEALER SYSTEM
	DIALOG_RENTBOAT,
	DIALOG_RENTBOAT_CONFIRM,
	DIALOG_RENT_BIKECONFIRM,
	DEALER_MENU,
	DEALER_NAME,
	DEALER_VAULT,
	DEALER_WITHDRAW,
	DEALER_DEPOSIT,
	DEALER_EDITPROD,
	DEALER_SETPRICE,



	//----------[ DEALER DIALOG ] -------------
	if(dialogid == DEALER_MENU)
	{
		new deid = pData[playerid][pGetDEID];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new mstr[248], lstr[512];
					format(mstr,sizeof(mstr),"Dealer ID %d", deid);
					format(lstr,sizeof(lstr),"Dealer Name:\t%s\nDealer Product:\t%d\nDealer Money Vault:\t%s", drData[deid][dName], drData[deid][dStock], FormatMoney(drData[deid][dMoney]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, mstr, lstr,"Back","Close");
				}
				case 1:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Nama sebelumnya: %s\n\nMasukkan nama dealer yang kamu inginkan\nMaksimal 32 karakter untuk nama bisnis", drData[deid][dName]);
					ShowPlayerDialog(playerid, DEALER_NAME, DIALOG_STYLE_INPUT,"Dealer Name", mstr,"Done","Back");
				}
				case 2: ShowPlayerDialog(playerid, DEALER_VAULT, DIALOG_STYLE_LIST,"Dealer Vault","Deposit\nWithdraw","Next","Back");
				case 3:
				{
					Dealer_ProductMenu(playerid, deid);
				}
				case 4:
				{
					if(drData[deid][dStock] > 50)
						return Error(playerid, "Dealer ini masih memiliki cukup produck.");

					if(drData[deid][dMoney] < 5000)
						return Error(playerid, "Setidaknya anda mempunyai uang dalam dealer anda senilai $50.00 untuk merestock product.");

					drData[deid][dRestock] = 1;
					Dealer_Save(deid);
					Info(playerid, "Anda berhasil request untuk mengisi stock dealer kepada pekerja hauling, harap tunggu sampai pekerja hauling melayani.");
				}
			}
		}
		return 1;
	}
	if(dialogid == DEALER_NAME)
	{
		if(response)
		{
			new deid = pData[playerid][pGetDEID];

			if(!Player_OwnsDealer(playerid, pData[playerid][pGetDEID])) return Error(playerid, "You don't own this dealer.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Dealer tidak di perbolehkan kosong!\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", drData[deid][dName]);
				ShowPlayerDialog(playerid, DEALER_NAME, DIALOG_STYLE_INPUT,"Dealer Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Dealer harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", drData[deid][dName]);
				ShowPlayerDialog(playerid, DEALER_NAME, DIALOG_STYLE_INPUT,"Dealer Name", mstr,"Done","Back");
				return 1;
			}
			format(drData[deid][dName], 32, ColouredText(inputtext));

			Dealer_Refresh(deid);
			Dealer_Save(deid);

			Servers(playerid, "Dealer name set to: \"%s\".", drData[deid][dName]);
		}
		else return callcmd::dem(playerid, "\0");
		return 1;
	}
	if(dialogid == DEALER_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam dealer ini", FormatMoney(pData[playerid][pMoney]));
					ShowPlayerDialog(playerid, DEALER_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Dealer Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam dealer ini", FormatMoney(drData[pData[playerid][pGetDEID]][dMoney]));
					ShowPlayerDialog(playerid, DEALER_WITHDRAW, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == DEALER_WITHDRAW)
	{
		if(response)
		{
			new deid = pData[playerid][pGetDEID];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > drData[deid][dMoney])
				return Error(playerid, "Invalid amount specified!");

			drData[deid][dMoney] -= amount;
			Dealer_Save(deid);

			GivePlayerMoneyEx(playerid, amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"DEALER: "WHITE_E"You have withdrawn "GREEN_E"%s "WHITE_E"from the dealer vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DEALER_VAULT, DIALOG_STYLE_LIST,"Dealer Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == DEALER_DEPOSIT)
	{
		if(response)
		{
			new deid = pData[playerid][pGetDEID];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > pData[playerid][pMoney])
				return Error(playerid, "Invalid amount specified!");

			drData[deid][dMoney] += amount;
			Dealer_Save(deid);

			GivePlayerMoneyEx(playerid, -amount);
			
			SendClientMessageEx(playerid, COLOR_LBLUE,"DEALER: "WHITE_E"You have deposit "GREEN_E"%s "WHITE_E"into the dealer vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DEALER_VAULT, DIALOG_STYLE_LIST,"Dealer Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == DEALER_EDITPROD)
	{
		if(Player_OwnsDealer(playerid, pData[playerid][pGetDEID]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, DEALER_SETPRICE, DIALOG_STYLE_INPUT, "Dealer: Set Price", str, "Modify", "Back");
			}
			else
				return callcmd::dem(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == DEALER_SETPRICE)
	{
		static
        item[40];
		new deid = pData[playerid][pGetDEID];
		if(Player_OwnsDealer(playerid, pData[playerid][pGetDEID]))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, DEALER_SETPRICE, DIALOG_STYLE_INPUT, "Dealer: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 500000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5000.00):", item);
					ShowPlayerDialog(playerid, DEALER_SETPRICE, DIALOG_STYLE_INPUT, "Dealer: Set Price", str, "Modify", "Back");
					return 1;
				}
				drData[deid][dP][pData[playerid][pProductModify]] = strval(inputtext);
				Dealer_Save(deid);

				Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				Dealer_ProductMenu(playerid, deid);
			}
			else
			{
				Dealer_ProductMenu(playerid, deid);
			}
		}
		return 1;
	}


--------------[CMD PLAYER]--------------
	//Buy Dealer
	foreach(new deid : Dealer)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, drData[deid][dPosX], drData[deid][dPosY], drData[deid][dPosZ]))
		{
			if(drData[deid][dPrice] > pData[playerid][pMoney]) return Error(playerid, "Not enough money, you can't afford this dealer.");
			if(strcmp(drData[deid][dOwner], "-")) return Error(playerid, "Someone already owns this dealer.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 2) return Error(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 3) return Error(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 4) return Error(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 1) return Error(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -drData[deid][dPrice]);
			Server_AddMoney(-drData[deid][dPrice]);
			GetPlayerName(playerid, drData[deid][dOwner], MAX_PLAYER_NAME);
			
			Dealer_Refresh(deid);
			Dealer_Save(deid);
		}
	}
*/