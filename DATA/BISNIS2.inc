//Business
#define MAX_BISNIS2 500

enum bisinfo2
{
	bOwner2[MAX_PLAYER_NAME],
	bOwnerID,
	bName2[128],
	bPrice2,
	bType2,
	bLocked2,
	bMoney2,
	bProd2,
	bP2[10],
	bInt2,
	Float:bExtposX2,
	Float:bExtposY2,
	Float:bExtposZ2,
	Float:bExtposA2,
	Float:bIntposX2,
	Float:bIntposY2,
	Float:bIntposZ2,
	Float:bIntposA2,
	bVisit2,
	bRestock2,
	Float:bPointX2,
	Float:bPointY2,
	Float:bPointZ2,
	//Not Saved
	bPickPoint2,
	Text3D:bLabelPoint2,
	bPickup3,
	bPickup2,
	bCP2,
	bMap2,
	Text3D:bLabel2,
};

new bData2[MAX_BISNIS2][bisinfo2],
	Iterator: Bisnis2<MAX_BISNIS2>;

Bisnis_Save2(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE bisnis2 SET owner='%s', ownerid='%d', name='%s', price='%d', type='%d', locked='%d', money='%d', prod='%d', bprice0='%d', bprice1='%d', bprice2='%d', bprice3='%d', bprice4='%d', bprice5='%d', bprice6='%d', bprice7='%d', bprice8='%d', bprice9='%d', bint='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', intposx='%f', intposy='%f', intposz='%f', intposa='%f', pointx='%f', pointy='%f', pointz='%f', visit='%d', restock='%d' WHERE ID='%d'",
	bData2[id][bOwner2],
	bData2[id][bOwnerID],
	bData2[id][bName2],
	bData2[id][bPrice2],
	bData2[id][bType2],
	bData2[id][bLocked2],
	bData2[id][bMoney2],
	bData2[id][bProd2],
	bData2[id][bP2][0],
	bData2[id][bP2][1],
	bData2[id][bP2][2],
	bData2[id][bP2][3],
	bData2[id][bP2][4],
	bData2[id][bP2][5],
	bData2[id][bP2][6],
	bData2[id][bP2][7],
	bData2[id][bP2][8],
	bData2[id][bP2][9],
	bData2[id][bInt2],
	bData2[id][bExtposX2],
	bData2[id][bExtposY2],
	bData2[id][bExtposZ2],
	bData2[id][bExtposA2],
	bData2[id][bIntposX2],
	bData2[id][bIntposY2],
	bData2[id][bIntposZ2],
	bData2[id][bIntposA2],
	bData2[id][bPointX2],
	bData2[id][bPointY2],
	bData2[id][bPointZ2],
	bData2[id][bVisit2],
	bData2[id][bRestock2],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}
	
Player_OwnsBisnis2(playerid, id)
{
	return (bData2[id][bOwnerID] == pData[playerid][pID]) || (!strcmp(bData2[id][bOwner2], pData[playerid][pName], true));
}

Player_BisnisCount2(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Bisnis2)
	{
		if(Player_OwnsBisnis2(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

Bisnis_Reset2(id)
{
	format(bData2[id][bOwner2], MAX_PLAYER_NAME, "-");
	format(bData2[id][bName2], 128, "-");
	bData2[id][bOwnerID] = 0;
	bData2[id][bLocked2] = 1;
    bData2[id][bMoney2] = 0;
	bData2[id][bProd2] = 0;
	bData2[id][bVisit2] = 0;
	bData2[id][bRestock2] = 0;
	bData2[id][bP2][0] = 0;
	bData2[id][bP2][1] = 0;
	bData2[id][bP2][2] = 0;
	bData2[id][bP2][3] = 0;
	bData2[id][bP2][4] = 0;
	bData2[id][bP2][5] = 0;
	bData2[id][bP2][6] = 0;
	bData2[id][bP2][7] = 0;
	bData2[id][bP2][8] = 0;
	bData2[id][bP2][9] = 0;
	Bisnis_Refresh2(id);
}
	
/*GetBisnisOwnerID(id)
{
	foreach(new i : Player)
	{
		if(!strcmp(bData2[id][bOwner], pData[i][pName], true)) return i;
	}
	return INVALID_PLAYER_ID;
}*/

GetOwnedBisnis2(playerid)
{
	new tmpcount;
	foreach(new bid : Bisnis2)
	{
	    if(!strcmp(bData2[bid][bOwner2], pData[playerid][pName], true) || (bData2[bid][bOwnerID] == pData[playerid][pID]))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
ReturnPlayerBisnisID2(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new bid : Bisnis2)
	{
	    if(!strcmp(pData[playerid][pName], bData2[bid][bOwner2], true) || (bData2[bid][bOwnerID] == pData[playerid][pID]))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return bid;
  			}
	    }
	}
	return -1;
}

Bisnis_BuyMenu2(playerid, bizid)
{

    static
        string[512];

    switch(bData2[bizid][bType2])
    {
        case 1:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}Fried Chicken\t{7fff00}%s\n{ffffff}Pizza Stack\t{7fff00}%s\n{ffffff}Patty Burger\t{7fff00}%s\n{ffffff}Sprunk\t{7fff00}%s",
                FormatMoney(bData2[bizid][bP2][0]),
                FormatMoney(bData2[bizid][bP2][1]),
                FormatMoney(bData2[bizid][bP2][2]),
                FormatMoney(bData2[bizid][bP2][3])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD2, DIALOG_STYLE_TABLIST_HEADERS, bData2[bizid][bName2], string, "Buy", "Cancel");
        }
        case 2:
        {
            new MarketHarga[560];
	    	format(MarketHarga,3,"HARGA : %s", FormatMoney(bData2[bizid][bP2][0]));//Water
	    	TextDrawSetString(NoMarket[25], MarketHarga);
	    	format(MarketHarga,25,"HARGA : %s", FormatMoney(bData2[bizid][bP2][1]));//Milx Max
	    	TextDrawSetString(NoMarket[28], MarketHarga);
	    	//format(MarketHarga,1000,"HARGA : %s", FormatMoney(bData2[bizid][bP2][2]));//Kebab
	    //	TextDrawSetString(MarketIndoSans[21], MarketHarga);
	    	format(MarketHarga,5,"HARGA : %s", FormatMoney(bData2[bizid][bP2][3]));//Roti
	    	TextDrawSetString(NoMarket[30], MarketHarga);
	    	format(MarketHarga,7,"HARGA : %s", FormatMoney(bData2[bizid][bP2][4]));//Snack
	    	TextDrawSetString(NoMarket[23], MarketHarga);
	    	format(MarketHarga,1,"HARGA : %s", FormatMoney(bData2[bizid][bP2][5]));//Starling
	    	TextDrawSetString(NoMarket[21], MarketHarga);
	    	format(MarketHarga,1000,"HARGA : %s", FormatMoney(bData2[bizid][bP2][6]));//Cappucino
	    	TextDrawSetString(NoMarket[18], MarketHarga);
            for(new i = 0; i < 32; i++)
			{
				TextDrawShowForPlayer(playerid, NoMarket[i]);
			}
			SelectTextDraw(playerid, COLOR_WHITE);
        }
        case 3:
        {
            TextDrawShowForPlayer(playerid, MENUBAJU[0]);
			TextDrawShowForPlayer(playerid, MENUBAJU[1]);
			TextDrawShowForPlayer(playerid, MENUBAJU[2]);
			TextDrawShowForPlayer(playerid, MENUBAJU[3]);
			TextDrawShowForPlayer(playerid, MENUBAJU[4]);
			TextDrawShowForPlayer(playerid, MENUBAJU[5]);
			TextDrawShowForPlayer(playerid, MENUBAJU[6]);
			TextDrawShowForPlayer(playerid, MENUBAJU[7]);
			SelectTextDraw(playerid, COLOR_YELLOW);//
        }
        case 4:
        {
            format(string, sizeof(string), "Alat\tHarga\n{ffffff}Brass Knuckles\t{7fff00}%s\n{ffffff}Knife\t{7fff00}%s\n{ffffff}Baseball Bat\t{7fff00}%s\n{ffffff}Shovel\t{7fff00}%s\n{ffffff}Chainsaw\t{7fff00}%s\n{ffffff}Cane\t{7fff00}%s\n{ffffff}Fishing Tool\t{7fff00}%s\n{ffffff}Worm\t{7fff00}%s",
                FormatMoney(bData2[bizid][bP2][0]),
                FormatMoney(bData2[bizid][bP2][1]),
                FormatMoney(bData2[bizid][bP2][2]),
                FormatMoney(bData2[bizid][bP2][3]),
				FormatMoney(bData2[bizid][bP2][4]),
				FormatMoney(bData2[bizid][bP2][5]),
				FormatMoney(bData2[bizid][bP2][6]),
				FormatMoney(bData2[bizid][bP2][7])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD2, DIALOG_STYLE_TABLIST_HEADERS, bData2[bizid][bName2], string, "Buy", "Cancel");
        }
		case 5:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}GPS\t{7fff00}%s\n{ffffff}Nomor HP\t{7fff00}%s\n{ffffff}Phone Credit\t{7fff00}%s\n{ffffff}Phone Book\t{7fff00}%s\n{ffffff}Walkie Talkie\t{7fff00}%s\n{ffffff}Kuota 10gb\t{7fff00}%s\n{ffffff}Boombox\t{7fff00}%s\n",
                FormatMoney(bData2[bizid][bP2][0]),
                FormatMoney(bData2[bizid][bP2][1]),
                FormatMoney(bData2[bizid][bP2][2]),
                FormatMoney(bData2[bizid][bP2][3]),
				FormatMoney(bData2[bizid][bP2][4]),
				FormatMoney(bData2[bizid][bP2][5]),
				FormatMoney(bData2[bizid][bP2][6])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD2, DIALOG_STYLE_TABLIST_HEADERS, bData2[bizid][bName2], string, "Buy", "Cancel");
        }
    }
    return 1;
}

Bisnis_ProductMenu2(playerid, bizid)
{
    if(bizid <= -1)
        return 0;

    static
        string[512];

    switch (bData2[bizid][bType2])
    {
        case 1:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}Fried Chicken\t{7fff00}%s\n{ffffff}Pizza Stack\t{7fff00}%s\n{ffffff}Patty Burger\t{7fff00}%s\n{ffffff}Sprunk\t{7fff00}%s",
                FormatMoney(bData2[bizid][bP2][0]),
                FormatMoney(bData2[bizid][bP2][1]),
                FormatMoney(bData2[bizid][bP2][2]),
                FormatMoney(bData2[bizid][bP2][3])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD, DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
        case 2:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}Water\t{7fff00}%s\n{ffffff}Milx Max\t{7fff00}%s\n{ffffff}Kebab\t{7fff00}%s\n{ffffff}Roti\t{7fff00}%s\n{ffffff}Snack\t{7fff00}%s\n{ffffff}Starling\t{7fff00}%s\n{ffffff}Cappucino\t{7fff00}%s",
                FormatMoney(bData2[bizid][bP2][0]),
                FormatMoney(bData2[bizid][bP2][1]),
                FormatMoney(bData2[bizid][bP2][2]),
                FormatMoney(bData2[bizid][bP2][3]),
				FormatMoney(bData2[bizid][bP2][4]),
				FormatMoney(bData2[bizid][bP2][5]),
				FormatMoney(bData2[bizid][bP2][6])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD,DIALOG_STYLE_TABLIST_HEADERS, "Business - Harga Barang", string, "Ubah", "Batal");
        }
        case 3:
        {
            format(string, sizeof(string), "Aksesoris\tHarga\n{ffffff}Clothes\t{7fff00}%s\n{ffffff}Toys\t{7fff00}%s\n{ffffff}Mask\t{7fff00}%s\n{ffffff}Helmet\t{7fff00}%s",
                FormatMoney(bData2[bizid][bP2][0]),
                FormatMoney(bData2[bizid][bP2][1]),
                FormatMoney(bData2[bizid][bP2][2]),
                FormatMoney(bData2[bizid][bP2][3])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD,DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
        case 4:
        {
            format(string, sizeof(string), "Alat\tHarga\n{ffffff}Brass Knuckles\t{7fff00}%s\n{ffffff}Knife\t{7fff00}%s\n{ffffff}Baseball Bat\t{7fff00}%s\n{ffffff}Shovel\t{7fff00}%s\n{ffffff}Chainsaw\t{7fff00}%s\n{ffffff}Cane\t{7fff00}%s\n{ffffff}Fishing Tool\t{7fff00}%s\n{ffffff}Worm\t{7fff00}%s",
                FormatMoney(bData2[bizid][bP2][0]),
                FormatMoney(bData2[bizid][bP2][1]),
                FormatMoney(bData2[bizid][bP2][2]),
                FormatMoney(bData2[bizid][bP2][3]),
				FormatMoney(bData2[bizid][bP2][4]),
				FormatMoney(bData2[bizid][bP2][5]),
				FormatMoney(bData2[bizid][bP2][6]),
				FormatMoney(bData2[bizid][bP2][7])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD,DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
		case 5:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}GPS\t{7fff00}%s\n{ffffff}Nomor Hp\t{7fff00}%s\n{ffffff}Phone Credit\t{7fff00}%s\n{ffffff}Phone Book\t{7fff00}%s\n{ffffff}Walkie Talkie\t{7fff00}%s\n{ffffff}Kuota 10gb\t{7fff00}%s\n{ffffff}Boombox\t{7fff00}%s",
                FormatMoney(bData2[bizid][bP2][0]),
                FormatMoney(bData2[bizid][bP2][1]),
                FormatMoney(bData2[bizid][bP2][2]),
                FormatMoney(bData2[bizid][bP2][3]),
				FormatMoney(bData2[bizid][bP2][4]),
				FormatMoney(bData2[bizid][bP2][5]),
				FormatMoney(bData2[bizid][bP2][6])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD,DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
    }
    return 1;
}

Bisnis_Type2(bisid)
{
	if(bData2[bisid][bType2] == 1) // Fast Food
	{
	    switch(random(2))
		{
			case 0:
			{
				bData2[bisid][bIntposX2] = 363.22;
				bData2[bisid][bIntposY2] = -74.86;
				bData2[bisid][bIntposZ2] = 1001.50;
				bData2[bisid][bIntposA2] = 319.72;
				bData2[bisid][bInt2] = 10;
			}
			case 1:
			{
				bData2[bisid][bIntposX2] = 372.34;
				bData2[bisid][bIntposY2] = -133.25;
				bData2[bisid][bIntposZ2] = 1001.49;
				bData2[bisid][bIntposA2] = 4.80;
				bData2[bisid][bInt2] = 5;
			}
		}
	}
	if(bData2[bisid][bType2] == 2) //Market
	{
	    switch(random(2))
		{
			case 0:
			{
				bData2[bisid][bIntposX2] = 5.73;
				bData2[bisid][bIntposY2] = -31.04;
				bData2[bisid][bIntposZ2] = 1003.54;
				bData2[bisid][bIntposA2] = 355.73;
				bData2[bisid][bInt2] = 10;
			}
			case 1:
			{
				bData2[bisid][bIntposX2] = -26.68;
				bData2[bisid][bIntposY2] = -57.92;
				bData2[bisid][bIntposZ2] = 1003.54;
				bData2[bisid][bIntposA2] = 357.58;
				bData2[bisid][bInt2] = 6;
			}
		}
	}
	if(bData2[bisid][bType2] == 3) //Clothes
	{
	    switch(random(3))
		{
			case 0:
			{
				bData2[bisid][bIntposX2] = 207.55;
				bData2[bisid][bIntposY2] = -110.67;
				bData2[bisid][bIntposZ2] = 1005.13;
				bData2[bisid][bIntposA2] = 0.16;
				bData2[bisid][bInt2] = 15;
			}
			case 1:
			{
				bData2[bisid][bIntposX2] = 204.49;
				bData2[bisid][bIntposY2] = -168.26;
				bData2[bisid][bIntposZ2] = 1000.52;
				bData2[bisid][bIntposA2] = 358.74;
				bData2[bisid][bInt2] = 14;
			}
			case 2:
			{
				bData2[bisid][bIntposX2] = -401.7269;
				bData2[bisid][bIntposY2] = 2227.2236;
				bData2[bisid][bIntposZ2] = 1801.0859;
				bData2[bisid][bIntposA2] = 269.4387;
				bData2[bisid][bInt2] = 19;
			}
		}
	}
	if(bData2[bisid][bType2] == 4) // Equipment
	{
	    switch(random(2))
		{
			case 0:
			{
				bData2[bisid][bIntposX2] = 285.93;
				bData2[bisid][bIntposY2] = -86.00;
				bData2[bisid][bIntposZ2] = 1001.52;
				bData2[bisid][bIntposA2] = 352.95;
				bData2[bisid][bInt2] = 4;
			}
			case 1:
			{
				bData2[bisid][bIntposX2] = 316.34;
				bData2[bisid][bIntposY2] = -169.60;
				bData2[bisid][bIntposZ2] = 999.60;
				bData2[bisid][bIntposA2] =  357.73;
				bData2[bisid][bInt2] = 6;
			}
		}
	}
	if(bData2[bisid][bType2] == 5) // Electronic
	{
		switch(random(2))
		{
			case 0:
			{
				bData2[bisid][bIntposX2] = 1421.95;
				bData2[bisid][bIntposY2] = -1180.97;
				bData2[bisid][bIntposZ2] = 26.00;
				bData2[bisid][bIntposA2] =  176.57;
				bData2[bisid][bInt2] = 1;
			}
			case 1:
			{
				bData2[bisid][bIntposX2] = 1421.95;
				bData2[bisid][bIntposY2] = -1180.97;
				bData2[bisid][bIntposZ2] = 26.00;
				bData2[bisid][bIntposA2] =  176.57;
				bData2[bisid][bInt2] = 2;
			}
		}
	}

	new query[374];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET intposx='%f', intposy='%f', intposz='%f', intposa='%f', bint='%d' WHERE ID='%d'", bData2[bisid][bIntposX2], bData2[bisid][bIntposY2], bData2[bisid][bIntposZ2], bData2[bisid][bIntposA2], bData2[bisid][bInt2], bisid);
	mysql_tquery(g_SQL, query);
}

Bisnis_Refresh2(id)
{
    if(id != -1)
    {
        if(IsValidDynamic3DTextLabel(bData2[id][bLabel2]))
            DestroyDynamic3DTextLabel(bData2[id][bLabel2]);

        if(IsValidDynamicPickup(bData2[id][bPickup3]))
            DestroyDynamicPickup(bData2[id][bPickup3]);

		if(IsValidDynamicPickup(bData2[id][bPickup2]))
            DestroyDynamicPickup(bData2[id][bPickup2]);
			
		if(IsValidDynamic3DTextLabel(bData2[id][bLabelPoint2]))
            DestroyDynamic3DTextLabel(bData2[id][bLabelPoint2]);

        if(IsValidDynamicPickup(bData2[id][bPickPoint2]))
            DestroyDynamicPickup(bData2[id][bPickPoint2]);
		
		if(IsValidDynamicCP(bData2[id][bCP2]))
			DestroyDynamicCP(bData2[id][bCP2]);
			
		DestroyDynamicMapIcon(bData2[id][bMap2]);

        static
        string[255], tstr[128];
		
		new type[128];
		if(bData2[id][bType2] == 1)
		{
			type= "Fast Food";
		}
		else if(bData2[id][bType2] == 2)
		{
			type= "Market";
		}
		else if(bData2[id][bType2] == 3)
		{
			type= "Clothes";
		}
		else if(bData2[id][bType2] == 4)
		{
			type= "Equipment";
		}
		else if(bData2[id][bType2] == 5)
		{
			type= "Electronics";
		}
		else
		{
			type= "Unknown";
		}
        if(strcmp(bData2[id][bOwner2], "-") || bData2[id][bOwnerID] != 0)
		{
			format(tstr, 128, "Owner: {FFFF00}%s\n"WHITE_E"Nama Bisnis: %s\nTekan "LG_E"'ALT' {FFFFFF}Untuk Membeli", bData2[id][bOwner2], bData2[id][bName2]);
			bData2[id][bLabelPoint2] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
   			if(IsValidDynamic3DTextLabel(bData2[id][bLabel2]))
            DestroyDynamic3DTextLabel(bData2[id][bLabel2]);
        }
        else
        {
            format(string, sizeof(string), "Bisnis ini dijual\nHarga: {FFFF00}%s\n{FFFFFF}Type: {FFFF00}%s\n"WHITE_E"Tekan "LG_E"N {FFFFFF}untuk membeli bisnis\n"LG_E"ALT {FFFFFF}Untuk Membeli", FormatMoney(bData2[id][bPrice2]), type);
		}
		bData2[id][bPickPoint2] = CreateDynamicPickup(1274, 23, bData2[id][bPointX2], bData2[id][bPointY2], bData2[id][bPointZ2]+0.2, id, bData2[id][bInt2], _, 8);

		//bData2[id][bCP2] = CreateDynamicCP(bData2[id][bIntposX2], bData2[id][bIntposY2], bData2[id][bIntposZ2], 1.0, id, bData2[id][bInt2], -1, 3.0);
        bData2[id][bLabel2] = CreateDynamic3DTextLabel(string, COLOR_WHITE, bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
		
		if(bData2[id][bType2] == 1)
		{
			bData2[id][bMap2] = CreateDynamicMapIcon(bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2], 50, -1, -1, -1, -1, 700.0);
		}
		else if(bData2[id][bType2] == 2)
		{
			bData2[id][bMap2] = CreateDynamicMapIcon(bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2], 17, -1, -1, -1, -1, 700.0);
		}
		else if(bData2[id][bType2] == 3)
		{
			bData2[id][bMap2] = CreateDynamicMapIcon(bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2], 45, -1, -1, -1, -1, 700.0);
		}
		else if(bData2[id][bType2] == 4)
		{
			bData2[id][bMap2] = CreateDynamicMapIcon(bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2], 25, -1, -1, -1, -1, 700.0);
		}
		else if(bData2[id][bType2] == 5)
		{
			bData2[id][bMap2] = CreateDynamicMapIcon(bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2], 35, -1, -1, -1, -1, 700.0);
		}
		else
		{
			DestroyDynamicMapIcon(bData2[id][bMap2]);
		}
    }
    return 1;
}

function LoadBisnis2()
{
    static bid;
	
	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for (new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", bid);
			cache_get_value_name(i, "owner", owner);
			format(bData2[bid][bOwner2], 128, owner);
			cache_get_value_name_int(i, "ownerid", bData2[bid][bOwnerID]);
			cache_get_value_name(i, "name", name);
			format(bData2[bid][bName2], 128, name);
			cache_get_value_name_int(i, "type", bData2[bid][bType2]);
			cache_get_value_name_int(i, "price", bData2[bid][bPrice2]);
			cache_get_value_name_float(i, "extposx", bData2[bid][bExtposX2]);
			cache_get_value_name_float(i, "extposy", bData2[bid][bExtposY2]);
			cache_get_value_name_float(i, "extposz", bData2[bid][bExtposZ2]);
			cache_get_value_name_float(i, "extposa", bData2[bid][bExtposA2]);
			cache_get_value_name_float(i, "intposx", bData2[bid][bIntposX2]);
			cache_get_value_name_float(i, "intposy", bData2[bid][bIntposY2]);
			cache_get_value_name_float(i, "intposz", bData2[bid][bIntposZ2]);
			cache_get_value_name_float(i, "intposa", bData2[bid][bIntposA2]);
			cache_get_value_name_int(i, "bint", bData2[bid][bInt2]);
			cache_get_value_name_int(i, "money", bData2[bid][bMoney2]);
			cache_get_value_name_int(i, "locked", bData2[bid][bLocked2]);
			cache_get_value_name_int(i, "prod", bData2[bid][bProd2]);
			cache_get_value_name_int(i, "bprice0", bData2[bid][bP2][0]);
			cache_get_value_name_int(i, "bprice1", bData2[bid][bP2][1]);
			cache_get_value_name_int(i, "bprice2", bData2[bid][bP2][2]);
			cache_get_value_name_int(i, "bprice3", bData2[bid][bP2][3]);
			cache_get_value_name_int(i, "bprice4", bData2[bid][bP2][4]);
			cache_get_value_name_int(i, "bprice5", bData2[bid][bP2][5]);
			cache_get_value_name_int(i, "bprice6", bData2[bid][bP2][6]);
			cache_get_value_name_int(i, "bprice7", bData2[bid][bP2][7]);
			cache_get_value_name_int(i, "bprice8", bData2[bid][bP2][8]);
			cache_get_value_name_int(i, "bprice9", bData2[bid][bP2][9]);
			cache_get_value_name_float(i, "pointx", bData2[bid][bPointX2]);
			cache_get_value_name_float(i, "pointy", bData2[bid][bPointY2]);
			cache_get_value_name_float(i, "pointz", bData2[bid][bPointZ2]);
			cache_get_value_name_int(i, "visit", bData2[bid][bVisit2]);
			cache_get_value_name_int(i, "restock", bData2[bid][bRestock2]);
			Bisnis_Refresh2(bid);
			Iter_Add(Bisnis2, bid);
		}
		printf("[Bisnis Di Kota]: %d Loaded.", rows);
	}
}

GetAnyBusiness()
{
	new tmpcount;
	foreach(new id : Bisnis2)
	{
     	tmpcount++;
	}
	return tmpcount;
}

ReturnBusinessID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS2) return -1;
	foreach(new id : Bisnis2)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}

//------------[ Bisnis Command ]------------
//Bisnis System
CMD:createbiz2(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		//if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new query[512];
	new bid = Iter_Free(Bisnis2), address[128];
	if(bid == -1) return Error(playerid, "You cant create more door!");
	new price, type;
	if(sscanf(params, "dd", price, type)) return SyntaxMsg(playerid, "/createbusiness [price] [type, 1.Fastfood 2.Market 3.Clothes 4.Equipment 5.Electronics]");
	format(bData2[bid][bOwner2], 128, "-");
	bData2[bid][bOwnerID] = 0;
	GetPlayerPos(playerid, bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2]);
	GetPlayerFacingAngle(playerid, bData2[bid][bExtposA2]);
	bData2[bid][bPrice2] = price;
	bData2[bid][bType2] = type;
	address = GetLocation(bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2]);
	format(bData2[bid][bName2], 128, address);
	bData2[bid][bLocked2] = 1;
	bData2[bid][bMoney2] = 0;
	bData2[bid][bProd2] = 0;
	bData2[bid][bP2][0] = 0;
	bData2[bid][bP2][1] = 0;
	bData2[bid][bP2][2] = 0;
	bData2[bid][bP2][3] = 0;
	bData2[bid][bP2][4] = 0;
	bData2[bid][bP2][5] = 0;
	bData2[bid][bP2][6] = 0;
	bData2[bid][bP2][7] = 0;
	bData2[bid][bP2][8] = 0;
	bData2[bid][bP2][9] = 0;
	bData2[bid][bInt2] = 0;
	bData2[bid][bIntposX2] = 0;
	bData2[bid][bIntposY2] = 0;
	bData2[bid][bIntposZ2] = 0;
	bData2[bid][bIntposA2] = 0;
	bData2[bid][bVisit2] = 0;
	bData2[bid][bRestock2] = 0;

	Iter_Add(Bisnis2, bid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO bisnis2 SET ID='%d', owner='%s', ownerid='%d', price='%d', type='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', name='%s'", bid, bData2[bid][bOwner2], bData2[bid][bOwnerID], bData2[bid][bPrice2], bData2[bid][bType2], bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2], bData2[bid][bExtposA2], bData2[bid][bName2]);
	mysql_tquery(g_SQL, query, "OnBisnisCreated2", "ii", playerid, bid);
	return 1;
}

function OnBisnisCreated2(playerid, bid)
{
	Bisnis_Type2(bid);
    Bisnis_Refresh2(bid);
	Servers(playerid, "Business [%d] berhasil di buat!", bid);
	new str[150];
	format(str,sizeof(str),"[Biz]: %s membuat business id %d!", GetRPName(playerid), bid);
	LogServer("Admin", str);
	return 1;
}

function GetClosestBusiness(playerid, type)
{
	new
	    Float:distance[2] = {99999.0, 0.0},
	    index = -1;

	for(new i = 0; i < MAX_BISNIS2; i ++)
	{
		if((bData2[i][bType2] == type))
		{
			distance[1] = GetPlayerDistanceFromPoint(playerid, bData2[i][bExtposX2], bData2[i][bExtposY2], bData2[i][bExtposZ2]);

			if(distance[0] > distance[1])
			{
			    distance[0] = distance[1];
			    index = i;
			}
		}
	}

	return index;
}

CMD:gotobiz2(playerid, params[])
{
	new bid;
	if(pData[playerid][pAdmin] < 5)
		//if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	if(sscanf(params, "d", bid))
		return SyntaxMsg(playerid, "/gotobiz [id]");
	if(!Iter_Contains(Bisnis2, bid)) return Error(playerid, "The Bisnis you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2], bData2[bid][bExtposA2]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to bisnis id %d", bid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	//pData[playerid][pInFamily] = -1;
	return 1;
}

CMD:editbiz2(playerid, params[])
{
    static
        bid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 5)
		//if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "ds[24]S()[128]", bid, type, string))
    {
        SyntaxMsg(playerid, "/editbiz [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, locked, owner, point, price, type, product, restock, reset");
        return 1;
    }
    if((bid < 0 || bid >= MAX_BISNIS2))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Bisnis2, bid)) return Error(playerid, "The bisnis you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2]);
		GetPlayerFacingAngle(playerid, bData2[bid][bExtposA2]);

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET extposx='%f', extposy='%f', extposz='%f', extposa='%f' WHERE ID='%d'", bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2], bData2[bid][bExtposA2], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the location of bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
    else if(!strcmp(type, "interior", true))
    {
        GetPlayerPos(playerid, bData2[bid][bIntposX2], bData2[bid][bIntposY2], bData2[bid][bIntposZ2]);
		GetPlayerFacingAngle(playerid, bData2[bid][bIntposA2]);
		bData2[bid][bInt2] = GetPlayerInterior(playerid);

		new query[200];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET bint='%d', intposx='%f', intposy='%f', intposz='%f', intposa='%f' WHERE ID='%d'", bData2[bid][bInt2], bData2[bid][bIntposX2], bData2[bid][bIntposY2], bData2[bid][bIntposZ2], bData2[bid][bIntposA2], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the interior spawn of bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
    else if(!strcmp(type, "locked", true))
    {
        new locked;

        if(sscanf(string, "d", locked))
            return SyntaxMsg(playerid, "/editbisnis [id] [locked] [0/1]");

        if(locked < 0 || locked > 1)
            return Error(playerid, "You must specify at least 0 or 1.");

        bData2[bid][bLocked2] = locked;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET locked='%d' WHERE ID='%d'", bData2[bid][bLocked2], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh2(bid);

        if(locked) {
            SendAdminMessage(COLOR_RED, "%s has locked bisnis ID: %d.", pData[playerid][pAdminname], bid);
        }
        else {
            SendAdminMessage(COLOR_RED, "%s has unlocked bisnis ID: %d.", pData[playerid][pAdminname], bid);
        }
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/editbisnis [id] [Price] [Amount]");

        bData2[bid][bPrice2] = price;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET price='%d' WHERE ID='%d'", bData2[bid][bPrice2], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the price of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, price);
    }
	else if(!strcmp(type, "type", true))
    {
        new btype;

        if(sscanf(string, "d", btype))
            return SyntaxMsg(playerid, "/editbisnis [id] [Type] [1.Fastfood 2.Market 3.Clothes 4.Equipment 5.Electronics]");

        bData2[bid][bType2] = btype;

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET type='%d' WHERE ID='%d'", bData2[bid][bType2], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Type2(bid);
		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the type of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, btype);
    }
	else if(!strcmp(type, "product", true))
    {
        new prod;

        if(sscanf(string, "d", prod))
            return SyntaxMsg(playerid, "/editbisnis [id] [product] [Ammount]");

        bData2[bid][bProd2] = prod;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d' WHERE ID='%d'", bData2[bid][bProd2], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the product of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, prod);
    }
	else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return SyntaxMsg(playerid, "/editbisnis [id] [money] [Ammount]");

        bData2[bid][bMoney2] = money;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET money='%d' WHERE ID='%d'", bData2[bid][bMoney2], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the money of bisnis ID: %d to %s.", pData[playerid][pAdminname], bid, FormatMoney(money));
    }
	else if(!strcmp(type, "restock", true))
    {
        new prod;

        if(sscanf(string, "d", prod))
            return SyntaxMsg(playerid, "/editbisnis [id] [restock] [0-1]");
		
		if(prod == 0)
		{
			bData2[bid][bRestock2] = 0;
			
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET restock='%d' WHERE ID='%d'", bData2[bid][bRestock2], bid);
			mysql_tquery(g_SQL, query);

			Bisnis_Refresh2(bid);
			SendAdminMessage(COLOR_RED, "%s has adjusted the restock of bisnis ID: %d to disable.", pData[playerid][pAdminname], bid);
		}
		else if(prod == 1)
		{
			bData2[bid][bRestock2] = 1;
			
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET restock='%d' WHERE ID='%d'", bData2[bid][bRestock2], bid);
			mysql_tquery(g_SQL, query);

			Bisnis_Refresh2(bid);
			SendAdminMessage(COLOR_RED, "%s has adjusted the restock of bisnis ID: %d to enable.", pData[playerid][pAdminname], bid);
		}
		else return Error(playerid, "Hanya id 0-1");
    }
	else if(!strcmp(type, "owner", true))
    {
		new otherid;
        if(sscanf(string, "d", otherid))
            return SyntaxMsg(playerid, "/editbiz [id] [owner] [playerid] (use '-1' to no owner/ reset)");
		if(otherid == -1)
			return format(bData2[bid][bOwner2], MAX_PLAYER_NAME, "-");

        format(bData2[bid][bOwner2], MAX_PLAYER_NAME, pData[otherid][pName]);
		bData2[bid][bOwnerID] = pData[otherid][pID];

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET owner='%s', ownerid='%d' WHERE ID='%d'", bData2[bid][bOwner2], bData2[bid][bOwnerID], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of business ID: %d to %s", pData[playerid][pAdminname], bid, pData[otherid][pName]);
    }
    else if(!strcmp(type, "reset", true))
    {
        Bisnis_Reset2(bid);
		Bisnis_Save2(bid);
		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has reset bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
	else if(!strcmp(type, "point", true))
    {
		new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
		bData2[bid][bPointX2] = x;
		bData2[bid][bPointY2] = y;
		bData2[bid][bPointZ2] = z;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET pointx='%f', pointy='%f', pointz='%f' WHERE ID='%d'", bData2[bid][bPointX2], bData2[bid][bPointY2], bData2[bid][bPointZ2], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh2(bid);
        SendAdminMessage(COLOR_RED, "%s has edit bisnis point ID: %d.", pData[playerid][pAdminname], bid);
    }
	else if(!strcmp(type, "delete", true))
    {
		Bisnis_Reset2(bid);
		
		DestroyDynamic3DTextLabel(bData2[bid][bLabel2]);
        DestroyDynamicPickup(bData2[bid][bPickup3]);
		DestroyDynamicPickup(bData2[bid][bPickup2]);
        DestroyDynamicCP(bData2[bid][bCP2]);
		DestroyDynamicMapIcon(bData2[bid][bMap2]);
		
		bData2[bid][bExtposX2] = 0;
		bData2[bid][bExtposY2] = 0;
		bData2[bid][bExtposZ2] = 0;
		bData2[bid][bExtposA2] = 0;
		bData2[bid][bPrice2] = 0;
		bData2[bid][bInt2] = 0;
		bData2[bid][bIntposX2] = 0;
		bData2[bid][bIntposY2] = 0;
		bData2[bid][bIntposZ2] = 0;
		bData2[bid][bIntposA2] = 0;
		bData2[bid][bLabel2] = Text3D: INVALID_3DTEXT_ID;
		bData2[bid][bPickup3] = -1;
		bData2[bid][bPickup2] = -1;
		
		// //iter_SafeRemove(Bisnis, bid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM bisnis2 WHERE ID=%d", bid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete bisnis ID: %d.", pData[playerid][pAdminname], bid);
		new str[150];
		format(str,sizeof(str),"[Biz]: %s menghapus business id %d!", GetRPName(playerid), bid);
		LogServer("Admin", str);
	}
    return 1;
}

CMD:lockbisnis2(playerid, params[])
{
	foreach(new bid : Bisnis2)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2]))
		{
			if(!Player_OwnsBisnis2(playerid, bid)) return Error(playerid, "Kamu tidak memiliki Bisnis ini.");
			if(!bData2[bid][bLocked2])
			{
				bData2[bid][bLocked2] = 1;
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET locked='%d' WHERE ID='%d'", bData2[bid][bLocked2], bid);
				mysql_tquery(g_SQL, query);

				InfoTD_MSG(playerid, 4000, "Bisnis anda berhasil ~r~Dikunci!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				bData2[bid][bLocked2] = 0;
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET locked='%d' WHERE ID='%d'", bData2[bid][bLocked2], bid);
				mysql_tquery(g_SQL, query);

				InfoTD_MSG(playerid, 4000,"Bisnis anda berhasil ~g~Dibuka");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

CMD:sellbusiness(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 918.1131,-1463.2157,2754.3389)) return ErrorMsg(playerid, "Anda harus berada di kantor pemerintah!");
	if(GetOwnedBisnis2(playerid) == -1) return Error(playerid, "Anda tidak memiliki bisnis.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedBisnis2(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerBisnisID2(playerid, itt);
		if(hData[hid][hLocked] == 1)
		{
			lock = "{FF0000}Terbuka";
		
		}
		else
		{
			lock = "{00FF00}Terkunci";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, bData2[hid][bName2], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, bData2[hid][bName2], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_SELL_BISNISS2, DIALOG_STYLE_LIST, "Sell Bisnis", CMDSString, "Sell", "Cancel");
	return 1;
}

CMD:mybis2(playerid)
{
	if(GetOwnedBisnis2(playerid) == -1) return ErrorMsg(playerid, "Anda tidak memiliki bisnis.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedBisnis2(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerBisnisID2(playerid, itt);
		if(hData[hid][hLocked] == 1)
		{
			lock = "{FF0000}Dikunci{ffffff}";
		
		}
		else
		{
			lock = "{00FF00}Dibuka{ffffff}";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), "%d.\t%s   {ffffff}(%s)\n", itt, bData2[hid][bName2], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), "%d.\t%s  {ffffff}(%s)\n", itt, bData2[hid][bName2], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_BISNIS2, DIALOG_STYLE_LIST, "ValriseReality - Bisnis Saya", CMDSString, "Pilih", "Batal");
	return 1;
}

CMD:bm2(playerid, params[])
{
	if(pData[playerid][pInBiz] == -1) return 0;
	if(!Player_OwnsBisnis2(playerid, pData[playerid][pInBiz])) return ErrorMsg(playerid, "Kamu tidak memiliki bisnis ini.");
    ShowPlayerDialog(playerid, BISNIS_MENU2, DIALOG_STYLE_LIST, "ValriseReality - Bisnis Menu","Bisnis Info\nGanti Nama\nPendapatan Bisnis\nHarga Product\nRequest Restock","Pilih","Tutup");
    return 1;
}

CMD:givebusiness2(playerid, params[])
{
	new bid, otherid;
	if(sscanf(params, "ud", otherid, bid)) return SyntaxMsg(playerid, "/givebisnis [playerid/name] [id] | /mybusiness - for show info");
	if(bid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "Player tersebut telah disconnect/tidak berada didekat dirimu.");
	
	if(!Player_OwnsBisnis2(playerid, bid)) return Error(playerid, "Kamu tidak memiliki Bisnis ini.");
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount2(otherid) + 1 > 2) return Error(playerid, "Target Player tidak dapat memiliki bisnis lebih.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount2(otherid) + 1 > 3) return Error(playerid, "Target Player tidak dapat memiliki bisnis lebih.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount2(otherid) + 1 > 4) return Error(playerid, "Target Player tidak dapat memiliki bisnis lebih.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount2(otherid) + 1 > 1) return Error(playerid, "Target Player tidak dapat memiliki bisnis lebih.");
		#endif
	}
	GetPlayerName(otherid, bData2[bid][bOwner2], MAX_PLAYER_NAME);
	bData2[bid][bOwnerID] = pData[otherid][pID];
	bData2[bid][bVisit2] = gettime();
	
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET owner='%s', ownerid='%d', visit='%d' WHERE ID='%d'", bData2[bid][bOwner2], bData2[bid][bOwnerID], bData2[bid][bVisit2], bid);
	mysql_tquery(g_SQL, query);

	Bisnis_Refresh2(bid);
	Info(playerid, "Anda memberikan bisnis id: %d kepada %s", bid, ReturnName(otherid));
	Info(otherid, "%s memberikan bisnis id: %d kepada anda", bid, ReturnName(playerid));
	new str[150];
	format(str,sizeof(str),"[BIZ]: %s memberikan business id %d ke %s!", GetRPName(playerid), bid, GetRPName(otherid));
	LogServer("Property", str);
	return 1;
}
