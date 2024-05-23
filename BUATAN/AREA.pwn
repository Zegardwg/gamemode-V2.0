/*

	AREA

*/
#include <YSI_Coding\y_hooks>

//------[ VARIABEL ]

enum    E_AREA
{
	STREAMER_TAG_AREA:balkot,
	STREAMER_TAG_AREA:centraljob,
	STREAMER_TAG_AREA:farmer,
	STREAMER_TAG_CP:jobfarmer,
	STREAMER_TAG_CP:Buysusu,
	STREAMER_TAG_CP:Crafting,
	STREAMER_TAG_CP:Crafting1,
	STREAMER_TAG_CP:Showroom,
	STREAMER_TAG_CP:balkots,
	STREAMER_TAG_CP:centraljobs,
};

new eaData[MAX_PLAYERS][E_AREA];

//



//

stock LoadArea(playerid)
{
	//==========================[ DYANAMIC CP ]==============================
	//CENTRAL BALKOT
	CreateDynamicCP(1376.4336,1573.7515,17.0003, 2.0, -1, -1, playerid, 30.0);
	//CENTER JOB
	CreateDynamicCP(906.96, 256.46, 1289.98, 2.0, -1, -1, playerid, 30.0);
	eaData[playerid][balkots] = CreateDynamicCP(1376.4336,1573.7515,17.0003, 2.0, -1, -1, playerid, 30.0);
	eaData[playerid][centraljobs] = CreateDynamicCP(906.96, 256.46, 1289.98, 2.0, -1, -1, playerid, 30.0);

	eaData[playerid][Buysusu] = CreateDynamicCP(313.61, 1147.21, 8.58, 2.0, -1, -1, playerid, 30.0);
	eaData[playerid][jobfarmer] = CreateDynamicCP(-382.97, -1426.43, 26.31, 2.0, -1, -1, playerid, 50.0);
	eaData[playerid][Crafting] = CreateDynamicCP(-2056.4873,1787.1152,860.6690, 2.0, -1, -1, playerid, 50.0);
	eaData[playerid][Crafting1] = CreateDynamicCP(-2056.4863,1791.8389,860.6690, 2.0, -1, -1, playerid, 50.0);
	eaData[playerid][Showroom] = CreateDynamicCP(907.71, -1735.62, -55.57-1, 2.0, -1, 11, playerid, 50.0);

	//================================[ DYNAMIC CIRCLE ]============================================

	eaData[playerid][balkot] = CreateDynamicCircle(1376.4336,1573.7515, 2.0, -1, -1, playerid);
	eaData[playerid][centraljob] = CreateDynamicCircle(1376.2773,1576.6027, 2.0, -1, -1, playerid);
	eaData[playerid][farmer] = CreateDynamicCircle(-382.97, -1426.43, 4.0, -1, -1, playerid);
	return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		/*if(IsPlayerInDynamicArea(playerid, eaData[playerid][balkot]))
		{
			if(areaid == eaData[playerid][balkot])
			{
				showinfotombol(playerid, "Untuk Menu pemerintah");
			}
		}
		if(IsPlayerInDynamicArea(playerid, eaData[playerid][centraljob]))
		{
			if(areaid == eaData[playerid][centraljob])
			{
				showinfotombol(playerid, "Mengambil Pekerjaan");
			}
		}*/
		if(IsPlayerInDynamicArea(playerid, eaData[playerid][farmer]))
		{
			if(areaid == eaData[playerid][farmer])
			{
				showinfotombol(playerid, "Untuk Menu Farmer");
			}
		}
	}
	return 1;
}

hook OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(IsPlayerInDynamicCP(playerid, eaData[playerid][Buysusu]))
		{
			if(checkpointid == eaData[playerid][Buysusu])
			{
				Altgenzotd(playerid, "Untuk Beli/Jual Susu", 5);
			}
		}
		else if(IsPlayerInDynamicCP(playerid, eaData[playerid][jobfarmer]))
		{
			if(checkpointid == eaData[playerid][jobfarmer])
			{
				Altgenzotd(playerid, "Untuk Beli/Jual Bahan", 5);
			}
		}
		else if(IsPlayerInDynamicCP(playerid, eaData[playerid][Crafting]))
		{
			if(checkpointid == eaData[playerid][Crafting])
			{
				showinfotombol(playerid, "Untuk Crafting Senjata");
			}
		}
		else if(IsPlayerInDynamicCP(playerid, eaData[playerid][Crafting1]))
		{
			if(checkpointid == eaData[playerid][Crafting1])
			{
				showinfotombol(playerid, "Untuk Crafting");
			}
		}
		else if(IsPlayerInDynamicCP(playerid, eaData[playerid][Showroom]))
		{
			if(checkpointid == eaData[playerid][Showroom])
			{
				Altgenzotd(playerid, "Untuk Beli Kendaraan", 5);
			}
		}
	}
	return 1;
}

hook OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP:checkpointid)
{
	if(checkpointid == eaData[playerid][Buysusu])
	{
		HideInfoTombol(playerid);
	}
	if(checkpointid == eaData[playerid][jobfarmer])
	{
		HideInfoTombol(playerid);
	}
	if(checkpointid == eaData[playerid][Crafting])
	{
		HideInfoTombol(playerid);
	}
	if(checkpointid == eaData[playerid][Crafting1])
	{
		HideInfoTombol(playerid);
	}
	if(checkpointid == eaData[playerid][Showroom])
	{
		HideInfoTombol(playerid);
	}
	return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(areaid == eaData[playerid][balkot])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == eaData[playerid][centraljob])
	{
		HideInfoTombol(playerid);
	}
	if(areaid == eaData[playerid][farmer])
	{
		HideInfoTombol(playerid);
	}
	return 1;
}