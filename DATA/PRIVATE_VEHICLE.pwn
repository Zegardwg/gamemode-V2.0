
//Private Vehicle Player System Define

#define MAX_PRIVATE_VEHICLE 1000
#define MAX_PLAYER_VEHICLE 3
#define RETURN_INVALID_VEHICLE_ID -1
//new Float: VehicleFuel[MAX_VEHICLES] = 100.0;
new bool:VehicleHealthSecurity[MAX_VEHICLES] = false, Float:VehicleHealthSecurityData[MAX_VEHICLES] = 1000.0;

#define MAX_VEHICLE_STORAGE 8

enum e_TRUNK_FLAGS
{
	e_TRUNK_NOTHING = 0,
	e_TRUNK_WEAPON,
	e_TRUNK_INVENTORY
};

enum pvdata
{
	cID,
	cOwner,
	cModel,
	cName[128],
	cColor1,
	cColor2,
	cPaintJob,
	cNeon,
	cTogNeon,
	cLocked,
	cInsu,
	cClaim,
	cClaimTime,
	cPlate[15],
	cPlateTime,
	cTicket,
	cParkid,
	cPrice,
	Float:cHealth,
	cFuel,
	Float:cPosX,
	Float:cPosY,
	Float:cPosZ,
	Float:cPosA,
	cInt,
	cVw,
	cDamage0,
	cDamage1,
	cDamage2,
	cDamage3,
	cMod[17],
	cLumber,
	cProduct,
	cGun[5],
	cAmmo[5],
	cMoney,
	cComponent,
	cMaterial,
	cSeed,
	cMarijuana,
	cRefleMoney,
	cGasOil,
	cRent,
	cVeh,
	cTrunk,
	bool:cToys,
	bool:LoadedStorage,
	// Trunk Storage
	e_TRUNK_FLAGS:vehTrunkType[MAX_VEHICLE_STORAGE],
};

new pvData[MAX_PRIVATE_VEHICLE][pvdata],
Iterator:PVehicles<MAX_PRIVATE_VEHICLE + 1>;

enum E_VTOYS
{
	vtModelid,
	Float:vtX,
	Float:vtY,
	Float:vtZ,
	Float:vtRX,
	Float:vtRY,
	Float:vtRZ,
	//Temp
	vtObj
}

new vToys[MAX_VEHICLES][6][E_VTOYS];

//Private Vehicle Player System Native
new const g_arrVehicleNames[][] = {
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
	"Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
	"Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
	"Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
	"Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
	"Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
	"Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
	"Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
	"Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
	"FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
	"Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
	"Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
	"Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
	"Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
	"Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
	"Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
	"Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
	"Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Car", "SFPD Car", "LVPD Car",
	"Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
	"Boxville", "Tiller", "Utility Trailer"
};

ReturnPVehiclesID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_PRIVATE_VEHICLE) return -1;
	foreach(new vehid : PVehicles)
	{
		if(pvData[vehid][cClaim] != 1)
		{
			if(pvData[vehid][cOwner] == pData[playerid][pID])
			{
	     		tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return vehid;
		  		}
		  	}
	    }
	}
	return -1;
}  

ReturnPVehiclesLockID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_PRIVATE_VEHICLE) return -1;
	foreach(new vehid : PVehicles)
	{
		if(IsValidVehicle(pvData[vehid][cVeh]))
		{
			if(pvData[vehid][cOwner] == pData[playerid][pID])
			{
	     		tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return vehid;
		  		}
		  	}
	    }
	}
	return -1;
}

ReturnPVehiclesInsuID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_PRIVATE_VEHICLE) return -1;
	foreach(new vehid : PVehicles)
	{
		if(pvData[vehid][cVeh] == 0 && pvData[vehid][cClaim] == 1 && pvData[vehid][cClaimTime] == 0)
		{
			if(pvData[vehid][cOwner] == pData[playerid][pID])
			{
	     		tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return vehid;
		  		}
		  	}
	    }
	}
	return -1;
}

GetVehicleStorage(vehicleid, item)
{
	static const StorageLimit[][] = {
	   //Snack  Sprunk  Medicine  Medkit  Bandage  Seed  Material  Component  Marijuana
	    {30,    30,     50,  	  5,  	  10,  	   500,  500,  	   500, 	 250}
	};

	return StorageLimit[pvData[vehicleid][cTrunk] - 1][item];
}

GetVehiclesInsurance(playerid)
{
	new tmpcount;
	foreach(new vehid : PVehicles)
	{
		if(pvData[vehid][cVeh] == 0 && pvData[vehid][cClaim] == 1 && pvData[vehid][cClaimTime] == 0)
		{
			if(pvData[vehid][cOwner] == pData[playerid][pID])
			{
     			tmpcount++;
     		}
		}
	}
	return tmpcount;
}

GetEngineStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(engine != 1)
		return 0;

	return 1;
}

GetDoorStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(doors != 1)
		return 0;

	return 1;
}

GetLightStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(lights != 1)
		return 0;

	return 1;
}

GetHoodStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(bonnet != 1)
		return 0;

	return 1;
}

GetTrunkStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(boot != 1)
		return 0;

	return 1;
}

SetTrunkStatus(vehicleid, status)
{
    static engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, status, objective);
}

GetVehicleModelByName(const name[])
{
	if(IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611))
		return strval(name);

	for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
	{
		if(strfind(g_arrVehicleNames[i], name, true) != -1)
		{
			return i + 400;
		}
	}
	return 0;
}

Vehicle_Nearest(playerid, Float:range = 3.5)
{
	static
	Float:fX,
	Float:fY,
	Float:fZ;

	foreach(new i:PVehicles)
	{
		if(Iter_Contains(PVehicles, i)) 
		{
			GetVehiclePos(pvData[i][cVeh], fX, fY, fZ);

			if(IsPlayerInRangeOfPoint(playerid, range, fX, fY, fZ)) 
			{
				return i;
			}
		}
	}
	return -1;
}

Vehicle_Nearest2(playerid, Float:range = 6.0)
{
	static
	Float:fX,
	Float:fY,
	Float:fZ;

	for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i)) {
		GetVehiclePos(pvData[i][cVeh], fX, fY, fZ);

		if(IsPlayerInRangeOfPoint(playerid, range, fX, fY, fZ)) {
			return i;
		}
	}
	return -1;
}

Vehicle_IsOwner(playerid, carid)
{
	if(!pData[playerid][IsLoggedIn] || pData[playerid][pID] == -1)
		return 0;

	if((Iter_Contains(PVehicles, carid) && pvData[carid][cOwner] != 0) && pvData[carid][cOwner] == pData[playerid][pID])
		return 1;

	return 0;
}

Vehicle_GetStatus(carid)
{
	GetVehicleDamageStatus(pvData[carid][cVeh], pvData[carid][cDamage0], pvData[carid][cDamage1], pvData[carid][cDamage2], pvData[carid][cDamage3]);

	GetVehicleHealth(pvData[carid][cVeh], pvData[carid][cHealth]);
	pvData[carid][cFuel] = GetVehicleFuel(pvData[carid][cVeh]);
	if(pvData[carid][cOwner])
	{
		GetVehiclePos(pvData[carid][cVeh], pvData[carid][cPosX], pvData[carid][cPosY], pvData[carid][cPosZ]);
		GetVehicleZAngle(pvData[carid][cVeh],pvData[carid][cPosA]);
	}
	return 1;
}

SetValidVehicleHealth(vehicleid, Float:health) {
	VehicleHealthSecurity[vehicleid] = true;
	SetVehicleHealth(vehicleid, health);
	return 1;
}

ValidRepairVehicle(vehicleid) {
	VehicleHealthSecurity[vehicleid] = true;
	RepairVehicle(vehicleid);
	return 1;
}

GetOwnedVeh(playerid)
{
	new tmpcount;
	foreach(new vid : PVehicles)
	{
	    if(pvData[vid][cOwner] == pData[playerid][pID])
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerVehID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_PLAYER_VEHICLE) return -1;
	foreach(new vid : PVehicles)
	{
	    if(pvData[vid][cOwner] == pData[playerid][pID])
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return vid;
  			}
	    }
	}
	return -1;
}

function SuccessRepair(playerid)
{
	new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pRepairTime])) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		SetValidVehicleHealth(vehid, 1000);

		ShowNotifSukses(playerid, "Berhasil memperbaiki kendaraan!", 8000);
		TogglePlayerControllable(playerid, 1);
		KillTimer(pData[playerid][pRepairTime]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pLoading] = false;
		ClearAnimations(playerid);
		pData[playerid][pRepairkit] -= 1;
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
	}
	return 1;
}
//Private Vehicle Player System Function
function OnPlayerVehicleRespawn(i)
{	
	pvData[i][cVeh] = CreateVehicle(pvData[i][cModel], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ], pvData[i][cPosA], pvData[i][cColor1], pvData[i][cColor2], 60000);
	SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
	SetVehicleVirtualWorld(pvData[i][cVeh], pvData[i][cVw]);
	LinkVehicleToInterior(pvData[i][cVeh], pvData[i][cInt]);
	SetVehicleFuel(pvData[i][cVeh], pvData[i][cFuel]);
	if(pvData[i][cHealth] < 350.0)
	{
		SetValidVehicleHealth(pvData[i][cVeh], 350.0);
	}
	else
	{
		SetValidVehicleHealth(pvData[i][cVeh], pvData[i][cHealth]);
	}
	UpdateVehicleDamageStatus(pvData[i][cVeh], pvData[i][cDamage0], pvData[i][cDamage1], pvData[i][cDamage2], pvData[i][cDamage3]);
	if(pvData[i][cVeh] != INVALID_VEHICLE_ID)
	{
		if(pvData[i][cPaintJob] != -1)
		{
			ChangeVehiclePaintjob(pvData[i][cVeh], pvData[i][cPaintJob]);
		}
		for(new z = 0; z < 17; z++)
		{
			if(pvData[i][cMod][z]) AddVehicleComponent(pvData[i][cVeh], pvData[i][cMod][z]);
		}
		if(pvData[i][cLocked] == 1)
		{
			SwitchVehicleDoors(pvData[i][cVeh], true);
		}
		else
		{
			SwitchVehicleDoors(pvData[i][cVeh], false);
		}
	}
	SetTimerEx("OnLoadVehicleStorage", 2000, false, "d", i);
	MySQL_LoadVehicleToys(i);
	MySQL_LoadVehicleStorage(i);
    return 1;
}

function OnLoadVehicleStorage(i)
{
	if(IsValidVehicle(pvData[i][cVeh]))
	{
		if(IsAPickup(pvData[i][cVeh]))
		{
			if(pvData[i][cLumber] > -1)
			{
				for(new lid; lid < pvData[i][cLumber]; lid++)
				{
					if(!IsValidDynamicObject(LumberObjects[pvData[i][cVeh]][lid]))
					{
						LumberObjects[pvData[i][cVeh]][lid] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
						AttachDynamicObjectToVehicle(LumberObjects[pvData[i][cVeh]][lid], pvData[i][cVeh], LumberAttachOffsets[lid][0], LumberAttachOffsets[lid][1], LumberAttachOffsets[lid][2], 0.0, 0.0, LumberAttachOffsets[lid][3]);
					}
				}
			}
			else if(pvData[i][cLumber] == -1)
			{
				for(new a; a < LUMBER_LIMIT; a++)
				{
					if(IsValidDynamicObject(LumberObjects[pvData[i][cVeh]][a]))
					{
						DestroyDynamicObject(LumberObjects[pvData[i][cVeh]][a]);
						LumberObjects[pvData[i][cVeh]][a] = -1;
					}
				}
			}
		}
		if(pvData[i][cTogNeon] == 1)
		{
			if(pvData[i][cNeon] != 0)
			{
				SetVehicleNeonLights(pvData[i][cVeh], true, pvData[i][cNeon], 0);
			}
		}
		
		/*if(TruckerVehObject[pvData[i][cVeh]] != 0)
		{
			if(IsValidDynamicObject(TruckerVehObject[pvData[i][cVeh]]))
			{
				DestroyDynamicObject(TruckerVehObject[pvData[i][cVeh]]);
				TruckerVehObject[pvData[i][cVeh]] = 0;
			}
		}*/


		if(pvData[i][cProduct] > 0)
		{
			VehProduct[pvData[i][cVeh]] = pvData[i][cProduct];
		}
		else
		{
			VehProduct[pvData[i][cVeh]] = 0;
		}

		if(pvData[i][cGasOil] > 0)
		{
			VehGasOil[pvData[i][cVeh]] = pvData[i][cGasOil];
		}
		else
		{
			VehGasOil[pvData[i][cVeh]] = 0;
		}
		
		/*if(pvData[i][cMoney] > 0)
		{
			VehMoney[pvData[i][cVeh]] = pvData[i][cMoney];
		}
		else
		{
			VehMoney[pvData[i][cVeh]] = 0;
		}

		if(pvData[i][cComponent] > 0)
		{
			VehComponent[pvData[i][cVeh]] = pvData[i][cComponent];
		}
		else
		{
			VehComponent[pvData[i][cVeh]] = 0;
		}

		if(pvData[i][cMaterial] > 0)
		{
			VehMaterial[pvData[i][cVeh]] = pvData[i][cMaterial];
		}
		else
		{
			VehMaterial[pvData[i][cVeh]] = 0;
		}

		if(pvData[i][cSeed] > 0)
		{
			VehSeed[pvData[i][cVeh]] = pvData[i][cSeed];
		}
		else
		{
			VehSeed[pvData[i][cVeh]] = 0;
		}

		if(pvData[i][cMarijuana] > 0)
		{
			VehMarijuana[pvData[i][cVeh]] = pvData[i][cMarijuana];
		}
		else
		{
			VehMarijuana[pvData[i][cVeh]] = 0;
		}*/

		if(pvData[i][cRefleMoney] > 0)
		{
			VehRefleMoney[pvData[i][cVeh]] = pvData[i][cRefleMoney];
		}
		else
		{
			VehRefleMoney[pvData[i][cVeh]] = 0;
		}
	}
}

function LoadPlayerVehicle(playerid)
{
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `vehicle` WHERE `owner` = %d", pData[playerid][pID]);
	mysql_query(g_SQL, query, true);
	new count = cache_num_rows(), tempString[56], vehname[128];
	if(count > 0)
	{
		for(new z = 0; z < count; z++)
		{
			new i = Iter_Free(PVehicles);
			cache_get_value_name_int(z, "id", pvData[i][cID]);
			//pvData[i][VehicleOwned] = true;
			cache_get_value_name_int(z, "owner", pvData[i][cOwner]);
			cache_get_value_name_int(z, "locked", pvData[i][cLocked]);
			cache_get_value_name_int(z, "insu", pvData[i][cInsu]);
			cache_get_value_name_int(z, "claim", pvData[i][cClaim]);
			cache_get_value_name_int(z, "claim_time", pvData[i][cClaimTime]);
			cache_get_value_name_float(z, "x", pvData[i][cPosX]);
			cache_get_value_name_float(z, "y", pvData[i][cPosY]);
			cache_get_value_name_float(z, "z", pvData[i][cPosZ]);
			cache_get_value_name_float(z, "a", pvData[i][cPosA]);
			cache_get_value_name_float(z, "health", pvData[i][cHealth]);
			cache_get_value_name_int(z, "fuel", pvData[i][cFuel]);
			cache_get_value_name_int(z, "int", pvData[i][cInt]);
			cache_get_value_name_int(z, "vw", pvData[i][cVw]);
			cache_get_value_name_int(z, "damage0", pvData[i][cDamage0]);
			cache_get_value_name_int(z, "damage1", pvData[i][cDamage1]);
			cache_get_value_name_int(z, "damage2", pvData[i][cDamage2]);
			cache_get_value_name_int(z, "damage3", pvData[i][cDamage3]);
			cache_get_value_name_int(z, "color1", pvData[i][cColor1]);
			cache_get_value_name_int(z, "color2", pvData[i][cColor2]);
			cache_get_value_name_int(z, "paintjob", pvData[i][cPaintJob]);
			cache_get_value_name_int(z, "neon", pvData[i][cNeon]);
			pvData[i][cTogNeon] = 0;
			cache_get_value_name_int(z, "price", pvData[i][cPrice]);
			cache_get_value_name_int(z, "model", pvData[i][cModel]);
			cache_get_value_name(z, "name", vehname);
			if(!strcmp(vehname, "None", true))
			{
				format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
			}
			else
			{
				format(pvData[i][cName], 128, vehname);
			}
			cache_get_value_name(z, "plate", tempString);
			format(pvData[i][cPlate], 16, tempString);
			cache_get_value_name_int(z, "plate_time", pvData[i][cPlateTime]);
			cache_get_value_name_int(z, "ticket", pvData[i][cTicket]);
			cache_get_value_name_int(z, "parkid", pvData[i][cParkid]);
			cache_get_value_name_int(z, "mod0", pvData[i][cMod][0]);
			cache_get_value_name_int(z, "mod1", pvData[i][cMod][1]);
			cache_get_value_name_int(z, "mod2", pvData[i][cMod][2]);
			cache_get_value_name_int(z, "mod3", pvData[i][cMod][3]);
			cache_get_value_name_int(z, "mod4", pvData[i][cMod][4]);
			cache_get_value_name_int(z, "mod5", pvData[i][cMod][5]);
			cache_get_value_name_int(z, "mod6", pvData[i][cMod][6]);
			cache_get_value_name_int(z, "mod7", pvData[i][cMod][7]);
			cache_get_value_name_int(z, "mod8", pvData[i][cMod][8]);
			cache_get_value_name_int(z, "mod9", pvData[i][cMod][9]);
			cache_get_value_name_int(z, "mod10", pvData[i][cMod][10]);
			cache_get_value_name_int(z, "mod11", pvData[i][cMod][11]);
			cache_get_value_name_int(z, "mod12", pvData[i][cMod][12]);
			cache_get_value_name_int(z, "mod13", pvData[i][cMod][13]);
			cache_get_value_name_int(z, "mod14", pvData[i][cMod][14]);
			cache_get_value_name_int(z, "mod15", pvData[i][cMod][15]);
			cache_get_value_name_int(z, "mod16", pvData[i][cMod][16]);
			cache_get_value_name_int(z, "lumber", pvData[i][cLumber]);
			cache_get_value_name_int(z, "product", pvData[i][cProduct]);

			cache_get_value_name_int(z, "Weapon1", pvData[i][cGun][0]);
			cache_get_value_name_int(z, "Weapon2", pvData[i][cGun][1]);
			cache_get_value_name_int(z, "Weapon3", pvData[i][cGun][2]);
			cache_get_value_name_int(z, "Weapon4", pvData[i][cGun][3]);
			cache_get_value_name_int(z, "Weapon5", pvData[i][cGun][4]);

			cache_get_value_name_int(z, "Ammo1", pvData[i][cAmmo][0]);
			cache_get_value_name_int(z, "Ammo2", pvData[i][cAmmo][1]);
			cache_get_value_name_int(z, "Ammo3", pvData[i][cAmmo][2]);
			cache_get_value_name_int(z, "Ammo4", pvData[i][cAmmo][3]);
			cache_get_value_name_int(z, "Ammo5", pvData[i][cAmmo][4]);

			cache_get_value_name_int(z, "component", pvData[i][cComponent]);
			cache_get_value_name_int(z, "material", pvData[i][cMaterial]);
			cache_get_value_name_int(z, "seed", pvData[i][cSeed]);
			cache_get_value_name_int(z, "marijuana", pvData[i][cMarijuana]);
			cache_get_value_name_int(z, "money", pvData[i][cMoney]);
			cache_get_value_name_int(z, "gasoil", pvData[i][cGasOil]);
			cache_get_value_name_int(z, "rental", pvData[i][cRent]);
			//cache_get_value_name_int(z, "trunk", pvData[i][cTrunk]);

			Iter_Add(PVehicles, i);
			if(pvData[i][cClaim] == 0 && pvData[i][cParkid] == -1)
			{
				//pvData[i][cTrunk] = 1;
				OnPlayerVehicleRespawn(i);
			}
			else
			{
				pvData[i][cVeh] = 0;
			}
		}
		printf("[P_VEHICLE] Loaded player vehicle from: %s(%d)", pData[playerid][pName], playerid);
	}
	return 1;
}

function EngineStatuss(playerid, vehicleid)
{
	if(!GetEngineStatus(vehicleid))
	{
		foreach(new ii : PVehicles)
		{
			if(vehicleid == pvData[ii][cVeh])
			{
				if(pvData[ii][cTicket] >= 1)
					return Error(playerid, "Kendaraan ini telah ditilang oleh Polisi! /v my - untuk memeriksa");
			}
		}
		new Float: f_vHealth;
		GetVehicleHealth(vehicleid, f_vHealth);
		if(f_vHealth < 350.0) return Error(playerid, "Kendaraan tidak dapat Menyala, Sudah rusak!");
		if(GetVehicleFuel(vehicleid) <= 0.0) return Error(playerid, "Kendaraan tidak dapat Menyala, Bensin habis!");

		SwitchVehicleEngine(vehicleid, true);
		SendNearbyMessage(playerid, 0.0, COLOR_WHITE, "ACTION: {D0AEEB}Mesin berhasil dinyalakan.");
		InfoTD_MSG(playerid, 4000, "Engine ~g~START");
	}
	return 1;
}

function EngineStatus(playerid, vehicleid)
{
	new count = 0;
	foreach(new ii : PVehicles)
	{
		if(vehicleid == pvData[ii][cVeh])
		{
			if(!GetEngineStatus(pvData[ii][cVeh]))
			{
				count++;
				if(pvData[ii][cTicket] >= 1)
					return Error(playerid, "Kendaraan ini telah ditilang oleh Polisi! /v my - untuk memeriksa");

				new Float: f_vHealth;
				GetVehicleHealth(pvData[ii][cVeh], f_vHealth);
				if(f_vHealth < 350.0) 
					return Error(playerid, "Kendaraan tidak dapat Menyala, Sudah rusak!");

				if(GetVehicleFuel(pvData[ii][cVeh]) <= 0.0) 
					return Error(playerid, "Kendaraan tidak dapat Menyala, Bensin habis!");

				SwitchVehicleEngine(pvData[ii][cVeh], true);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s menyalakan mesin kendaraan %s.", ReturnName(playerid), pvData[ii][cName]);
				InfoTD_MSG(playerid, 4000, "Engine ~g~START");
				ShowNotifSukses(playerid, "Kamu berhasil menyalakan mesin kendaraan", 5000);
			}
			else
			{
				//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mematikan mesin kendaraan %s.", ReturnName(playerid, 0), GetVehicleNameByVehicle(GetPlayerVehicleID(playerid)));
				SwitchVehicleEngine(pvData[ii][cVeh], false);
				//Info(playerid, "Engine turn off..");
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mematikan mematikan kendaraan %s.", ReturnName(playerid), pvData[ii][cName]);
				InfoTD_MSG(playerid, 4000, "Engine ~r~OFF");
				ShowNotifSukses(playerid, "Kamu berhasil mematikan mesin kendaraan", 5000);
				return 1;
			}
		}
	}

	if(count < 1)
	{	
		if(!GetEngineStatus(vehicleid))
		{
			new Float: f_vHealth;
			GetVehicleHealth(vehicleid, f_vHealth);
			if(f_vHealth < 350.0) 
				return Error(playerid, "Kendaraan tidak dapat Menyala, Sudah rusak!");

			if(GetVehicleFuel(vehicleid) <= 0.0) 
				return Error(playerid, "Kendaraan tidak dapat Menyala, Bensin habis!");

			//Info(playerid, "Mesin kendaraan tidak dapat menyala, silahkan coba lagi!");
			SwitchVehicleEngine(vehicleid, true);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s menyalakan mesin kendaraan %s.", ReturnName(playerid), GetVehicleName(vehicleid));
			InfoTD_MSG(playerid, 4000, "Engine ~g~START");
			//GameTextForPlayer(playerid, "~w~ENGINE ~r~CAN'T START", 1000, 3);
		}
		else
		{
			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mematikan mesin kendaraan %s.", ReturnName(playerid, 0), GetVehicleNameByVehicle(GetPlayerVehicleID(playerid)));
			SwitchVehicleEngine(vehicleid, false);
			//Info(playerid, "Engine turn off..");
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mematikan mematikan kendaraan %s.", ReturnName(playerid), GetVehicleName(vehicleid));
			InfoTD_MSG(playerid, 4000, "Engine ~r~OFF");
		}
	}
	return 1;
}

function RemovePlayerVehicle(playerid)
{
	foreach(new i : PVehicles)
	{
		if(pvData[i][cParkid] == -1)
		{
			Vehicle_GetStatus(i);
		}
		if(pvData[i][cOwner] == pData[playerid][pID])
		{
			new cQuery[2248]/*, color1, color2, paintjob*/;
			pvData[i][cOwner] = -1;
			//GetVehicleColor(pvData[i][cVeh], color1, color2);
			//paintjob = GetVehiclePaintjob(pvData[i][cVeh]);
			//pvData[i][VehicleOwned] = false;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE `vehicle` SET ");
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`x`='%f', ", cQuery, pvData[i][cPosX]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`y`='%f', ", cQuery, pvData[i][cPosY]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`z`='%f', ", cQuery, pvData[i][cPosZ]+0.1);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`a`='%f', ", cQuery, pvData[i][cPosA]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`health`='%f', ", cQuery, pvData[i][cHealth]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`fuel`=%d, ", cQuery, pvData[i][cFuel]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`int`=%d, ", cQuery, pvData[i][cInt]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`price`=%d, ", cQuery, pvData[i][cPrice]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`vw`=%d, ", cQuery, pvData[i][cVw]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`model`=%d, ", cQuery, pvData[i][cModel]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`name`='%s', ", cQuery, pvData[i][cName]);
			if(pvData[i][cLocked] == 1)
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`locked`=1, ", cQuery);
			else
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`locked`=0, ", cQuery);
			/*if(pvData[i][VehicleAlarm])
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`alarm` = 1, ", cQuery);
			else
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`alarm` = 0, ", cQuery);*/
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`insu`='%d', ", cQuery, pvData[i][cInsu]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`claim`='%d', ", cQuery, pvData[i][cClaim]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`claim_time`='%d', ", cQuery, pvData[i][cClaimTime]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`plate`='%e', ", cQuery, pvData[i][cPlate]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`plate_time`='%d', ", cQuery, pvData[i][cPlateTime]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`ticket`='%d', ", cQuery, pvData[i][cTicket]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`parkid`='%d', ", cQuery, pvData[i][cParkid]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`color1`=%d, ", cQuery, pvData[i][cColor1]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`color2`=%d, ", cQuery, pvData[i][cColor2]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`paintjob`=%d, ", cQuery, pvData[i][cPaintJob]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`neon`=%d, ", cQuery, pvData[i][cNeon]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`damage0`=%d, ", cQuery, pvData[i][cDamage0]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`damage1`=%d, ", cQuery, pvData[i][cDamage1]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`damage2`=%d, ", cQuery, pvData[i][cDamage2]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`damage3`=%d, ", cQuery, pvData[i][cDamage3]);
			new tempString[56];
			for(new z = 0; z < 17; z++)
			{
				format(tempString, sizeof(tempString), "mod%d", z);
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`%s`=%d, ", cQuery, tempString, pvData[i][cMod][z]);
			}
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`lumber`=%d, ", cQuery, pvData[i][cLumber]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`product`=%d,", cQuery, pvData[i][cProduct]);
			for(new gun = 0; gun < 5; gun ++) 
			{
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Weapon%d`=%d, `Ammo%d`=%d,", cQuery, gun + 1, pvData[i][cGun][gun], gun + 1, pvData[i][cAmmo][gun]);
		    }
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`component`=%d,", cQuery, pvData[i][cComponent]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`material`=%d,", cQuery, pvData[i][cMaterial]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`seed`=%d,", cQuery, pvData[i][cSeed]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`marijuana`=%d,", cQuery, pvData[i][cMarijuana]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`money`=%d,", cQuery, pvData[i][cMoney]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`gasoil`=%d,", cQuery, pvData[i][cGasOil]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`rental`=%d ", cQuery, pvData[i][cRent]);
			//mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`trunk`=%d ", cQuery, pvData[i][cTrunk]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%sWHERE `id` = %d", cQuery, pvData[i][cID]);
			mysql_query(g_SQL, cQuery, true);

			if(pvData[i][cNeon] != 0)
			{
				SetVehicleNeonLights(pvData[i][cVeh], false, pvData[i][cNeon], 0);
			}
			
			RemoveVehicleToys(pvData[i][cVeh]);
			if(pvData[i][cVeh] != 0)
			{
				if(IsValidVehicle(pvData[i][cVeh])) 
					DestroyVehicle(pvData[i][cVeh]);

				pvData[i][cVeh] = 0;
			}
			Iter_SafeRemove(PVehicles, i, i);
		}
	}
	return 1;
}

function OnVehStarterPack(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = GetPlayerInterior(playerid);
	pvData[i][cVw] = GetPlayerVirtualWorld(playerid);
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = rental;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Kamu telah berhasil mengclaim starterpack berupa uang "GREEN_LIGHT"$80"WHITE_E", snack, sprunk dan kendaraan sepeda 1 days");
	return 1;
}

function OnVehCreated(playerid, oid, pid, model, color1, color2, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	new price = GetVehicleCost(model);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = price;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = 0;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membuat kendaraan kepada %s dengan (model=%d, color1=%d, color2=%d)", pData[oid][pName], model, color1, color2);
	return 1;
}

function OnVehBuyPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);

	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = 0;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}

	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan seharga %s dengan model %s(%d)", FormatMoney(GetVehicleCost(model)), GetVehicleModelName(model), model);
	SetPlayerPosition(playerid, 1283.73, -1300.59, 13.38, 84.92, 0);
	pData[playerid][pBuyPvModel] = 0;
	return 1;
}

function OnVehBuyVIPPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = 0;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}

	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan VIP seharga %d gold dengan model %s(%d)", GetVipVehicleCost(model), GetVehicleModelName(model), model);
	SetPlayerPosition(playerid, 1283.73, -1300.59, 13.38, 84.92, 0);
	return 1;
}

function OnVehRentPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = rental;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}

	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah menyewa kendaraan seharga $500 / one days dengan model %s(%d)", GetVehicleModelName(model), model);
	SetPlayerPosition(playerid, 1283.73, -1300.59, 13.38, 84.92, 0);
	pData[playerid][pBuyPvModel] = 0;
	return 1;
}

/*function OnVehBuyPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	new deid = pData[playerid][pGetDEID];

	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = drData[deid][dVehInt];
	pvData[i][cVw] = drData[deid][dVehVW];
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = 0;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan seharga %s dengan model %s(%d)", FormatMoney(pData[playerid][pGetDEIDPRICE]), GetVehicleModelName(model), model);
	SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
	Info(playerid, "Pergi menuju checkpoint untuk mengambil kendaraan yang sudah dibeli");
	
	new Float:PX, Float:PY, Float:PZ;
	GetPlayerPos(playerid, PX, PY, PZ);
	SetPlayerPos(playerid, PX, PY, PZ+0.5);
	
	drData[deid][dStock] -= 1;
	drData[deid][dMoney] += pData[playerid][pGetDEIDPRICE];
	Dealer_Save(deid);
	Dealer_Refresh(deid);

	pData[playerid][pGetDEID] = -1;
	pData[playerid][pBuyPvModel] = 0;
	pData[playerid][pGetDEIDPRICE] = 0;
	return 1;
}

function OnVehBuyVIPPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = 0;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan VIP seharga %d gold dengan model %s(%d)", GetVipVehicleCost(model), GetVehicleModelName(model), model);
	SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
	Info(playerid, "Pergi menuju checkpoint untuk mengambil kendaraan yang sudah dibeli");

	new Float:PX, Float:PY, Float:PZ;
	GetPlayerPos(playerid, PX, PY, PZ);
	SetPlayerPos(playerid, PX, PY, PZ);
	
	pData[playerid][pGetDEID] = -1;
	pData[playerid][pBuyPvModel] = 0;
	return 1;
}

function OnVehRentPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	new deid = pData[playerid][pGetDEID];
	
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = drData[deid][dVehInt];
	pvData[i][cVw] = drData[deid][dVehVW];
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = rental;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah menyewa kendaraan selama 1 hari dengan harga %s model %s(%d)", FormatMoney(pData[playerid][pGetDEIDPRICE]), GetVehicleModelName(model), model);
	SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
	Info(playerid, "Pergi menuju checkpoint untuk mengambil kendaraan yang sudah disewa");

	new Float:PX, Float:PY, Float:PZ;
	GetPlayerPos(playerid, PX, PY, PZ);
	SetPlayerPos(playerid, PX, PY, PZ+0.5);
	
	drData[deid][dStock] -= 1;
	drData[deid][dMoney] += pData[playerid][pGetDEIDPRICE];
	Dealer_Save(deid);
	Dealer_Refresh(deid);

	pData[playerid][pGetDEID] = -1;
	pData[playerid][pBuyPvModel] = 0;
	pData[playerid][pGetDEIDPRICE] = 0;
	return 1;
}*/



function OnVehRenidPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	new renid = pData[playerid][pGetRENID];
	
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cParkid] = -1;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "None");
	format(pvData[i][cName], 128, GetVehicleModelName(pvData[i][cModel]));
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cProduct] = 0;
	pvData[i][cComponent] = 0;
	pvData[i][cMaterial] = 0;
	pvData[i][cSeed] = 0;
	pvData[i][cMarijuana] = 0;
	pvData[i][cMoney] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cRent] = rental;

	for(new j = 0; j < 17; j++)
	{
		pvData[i][cMod][j] = 0;
	}
	for(new s = 0; s < 5; s++)
	{
		pvData[i][cGun][s] = 0;
		pvData[i][cAmmo][s] = 0;
	}	
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);

	SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
	Info(playerid, "Anda telah menyewa kendaraan selama 1 hari dengan harga %s model %s(%d)", FormatMoney(rnData[renid][rPrice]), GetVehicleModelName(model), model);
	Info(playerid, "Pergi menuju checkpoint untuk mengambil kendaraan yang sudah disewa");

	new Float:PX, Float:PY, Float:PZ;
	GetPlayerPos(playerid, PX, PY, PZ);
	SetPlayerPos(playerid, PX, PY, PZ+0.5);

	pData[playerid][pGetRENID] = -1;
	return 1;
}



function RespawnPV(vehicleid)
{
	SetVehicleToRespawn(vehicleid);
	SetValidVehicleHealth(vehicleid, 2000);
	SetVehicleFuel(vehicleid, 100);
	return 1;
}

// Private Vehicle Player System Commands

CMD:aeject(playerid, params[])
{
	if(pData[playerid][pAdmin] > 1)
		return Error(playerid, "Anda bukan Admin!");

	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/aeject [playerid id/name]");

		if(IsPlayerInVehicle(otherid, vehicleid))
		{
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah menendang %s dari kendaraannya.", ReturnName(playerid));
			Servers(otherid, "{ff0000}%s {ffffff}telah menendang anda dari kendaraan", pData[playerid][pAdminname]);
			RemovePlayerFromVehicle(otherid);
		}
		else
		{
			Error(otherid, "Player/Target tidak berada didalam Kendaraan");
		}
	}
	else
	{
		Error(playerid, "Anda tidak berada didalam kendaraan");
	}
	return 1;
}

CMD:eject(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/eject [playerid id/name]");

		if(IsPlayerInVehicle(otherid, vehicleid))
		{
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah menendang %s dari kendaraannya.", ReturnName(playerid), ReturnName(otherid));
			Servers(otherid, "%s telah menendang anda dari kendaraan", pData[playerid][pName]);
			RemovePlayerFromVehicle(otherid);
		}
		else
		{
			Error(otherid, "Player/Target tidak berada didalam Kendaraan");
		}
	}
	else
	{
		Error(playerid, "Anda tidak berada didalam kendaraan");
	}
	return 1;
}

CMD:createpv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new model, color1, color2, otherid;
	if(sscanf(params, "uddd", otherid, model, color1, color2)) return Usage(playerid, "/createpv [name/playerid] [model] [color1] [color2]");

	if(color1 < 0 || color1 > 255) { Error(playerid, "Color Number can't be below 0 or above 255 !"); return 1; }
	if(color2 < 0 || color2 > 255) { Error(playerid, "Color Number can't be below 0 or above 255 !"); return 1; }
	if(model < 400 || model > 611) { Error(playerid, "Vehicle Number can't be below 400 or above 611 !"); return 1; }
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid player ID!");
	new count = 0, limit = MAX_PLAYER_VEHICLE + pData[otherid][pVip];
	foreach(new ii : PVehicles)
	{
		if(pvData[ii][cOwner] == pData[otherid][pID])
			count++;
	}
	if(count >= limit)
	{
		Error(playerid, "This player have too many vehicles, sell a vehicle first!");
		return 1;
	}
	new cQuery[1024];
	new Float:x,Float:y,Float:z, Float:a;
	GetPlayerPos(otherid,x,y,z);
	GetPlayerFacingAngle(otherid,a);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[otherid][pID], model, color1, color2, x, y, z, a);
	mysql_tquery(g_SQL, cQuery, "OnVehCreated", "ddddddffff", playerid, otherid, pData[otherid][pID], model, color1, color2, x, y, z, a);
	return 1;
}

CMD:deletepv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new vehid;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/deletepv [vehid] | /apv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

	foreach(new i : PVehicles)			
	{
		if(vehid == pvData[i][cVeh])
		{
			Servers(playerid, "Your deleted private vehicle id %d (database id: %d).", vehid, pvData[i][cID]);

			new query[128], xuery[128];
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
			mysql_tquery(g_SQL, query);

			mysql_format(g_SQL, xuery, sizeof(xuery), "DELETE FROM vstorage WHERE owner = '%d'", pvData[i][cID]);
			mysql_tquery(g_SQL, xuery);
			pvData[pvData[i][cVeh]][LoadedStorage] = false;

			MySQL_ResetVehicleToys(i);
			if(IsValidVehicle(pvData[i][cVeh])) 
				DestroyVehicle(pvData[i][cVeh]);
			
			Iter_SafeRemove(PVehicles, i, i);
		}
	}
	return 1;
}

/*CMD:deletepv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new otherid;
	if(sscanf(params, "u", otherid)) return Usage(playerid, "/gotopv [name/playerid]");
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid playerid");
	
	new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tLocation\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[otherid][pID])
		{
			GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
			format(msg2, sizeof(msg2), "%s%d\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), GetLocation(fx, fy, fz));
			found = true;
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_DELETEVEH, DIALOG_STYLE_TABLIST_HEADERS, "Delete Vehicles", msg2, "Delete", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player ini tidak memeliki kendaraan", "Close", "");
			
	return 1;
}

CMD:gotopv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new otherid;
	if(sscanf(params, "u", otherid)) return Usage(playerid, "/gotopv [name/playerid]");
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid playerid");
	
	new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tLocation\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[otherid][pID])
		{
			GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
			format(msg2, sizeof(msg2), "%s%d\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), GetLocation(fx, fy, fz));
			found = true;
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_GOTOVEH, DIALOG_STYLE_TABLIST_HEADERS, "Goto Vehicles", msg2, "Goto", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player ini tidak memeliki kendaraan", "Close", "");
			
	return 1;
}

CMD:getpv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new otherid;
	if(sscanf(params, "u", otherid)) return Usage(playerid, "/getpv [name/playerid]");
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid playerid");
	
	new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tLocation\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[otherid][pID])
		{
			GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
			format(msg2, sizeof(msg2), "%s%d\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), GetLocation(fx, fy, fz));
			found = true;
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_GETVEH, DIALOG_STYLE_TABLIST_HEADERS, "Get Vehicles", msg2, "Get", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player ini tidak memeliki kendaraan", "Close", "");
			
	return 1;
}*/

CMD:pvlist(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new count = 0, created = 0;
	foreach(new i : PVehicles)
	{
		count++;
		if(IsValidVehicle(pvData[i][cVeh]))
		{
			created++;
		}
	}
	Info(playerid, "Foreach total: %d, Created: %d", count, created);
	return 1;
}

CMD:ainsu(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new otherid;
	if(sscanf(params, "u", otherid)) return Usage(playerid, "/ainsu [name/playerid]");
	if(otherid == INVALID_PLAYER_ID || !IsPlayerConnected(otherid)) return Error(playerid, "Invalid playerid");

	new bool:found = false, msg2[512];
	format(msg2, sizeof(msg2), "ID\tInsurance\tClaim Time\tTicket\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cVeh] == 0 && pvData[i][cClaim] == 1 || pvData[i][cTicket] >= 1)
		{
			if(pvData[i][cOwner] == pData[otherid][pID])
			{
				new statusticket[128];
				if(pvData[i][cTicket] == 0)
				{
					statusticket = "{00ff00}No{ffffff}";
				}
				else
				{
					statusticket = "{ff0000}Yes{ffffff}";
				}
				if(pvData[i][cClaimTime] != 0)
				{
					format(msg2, sizeof(msg2), "%s%d\t%s\t%s\t"RED_E"%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), ReturnTimelapse(gettime(), pvData[i][cClaimTime]), statusticket);
					found = true;
				}
				else
				{
					format(msg2, sizeof(msg2), "%s%d\t%s\tClaimed\t"RED_E"%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), statusticket);
					found = true;
				}
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Insurance Vehicles", msg2, "Close", "");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player tidak memeliki kendaraan", "Close", "");
	return 1;
}

CMD:apv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new otherid;
	if(sscanf(params, "u", otherid)) return Usage(playerid, "/apv [name/playerid]");
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid playerid");

	new bool:found = false, msg2[512];
	format(msg2, sizeof(msg2), "ID\tModel\tPlate Time\tRental\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cClaim] != 1)
		{
			if(pvData[i][cOwner] == pData[otherid][pID])
			{
				if(strcmp(pvData[i][cPlate], "None"))
				{
					if(pvData[i][cRent] != 0)
					{
						format(msg2, sizeof(msg2), "%s%d\t%s\t%s(%s)\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]), ReturnTimelapse(gettime(), pvData[i][cRent]));
						found = true;
					}
					else
					{
						format(msg2, sizeof(msg2), "%s%d\t%s\t%s(%s)\tOwned\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
						found = true;
					}
				}
				else
				{
					if(pvData[i][cRent] != 0)
					{
						format(msg2, sizeof(msg2), "%s%d\t%s\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cRent]));
						found = true;
					}
					else
					{
						format(msg2, sizeof(msg2), "%s%d\t%s\t%s\tOwned\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate]);
						found = true;
					}
				}
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Player Vehicles", msg2, "Close", "");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player ini tidak memeliki kendaraan", "Close", "");

	/*new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tPlate\tPlate Time\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[otherid][pID])
		{
			if(strcmp(pvData[i][cPlate], "None"))
			{
				GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
				format(msg2, sizeof(msg2), "%s%d\t%s(id: %d)\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				found = true;
			}
			else
			{
				GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
				format(msg2, sizeof(msg2), "%s%d\t%s(id: %d)\t%s\tNone\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate]);
				found = true;
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Vehicles Plate", msg2, "Close", "");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles Plate", "Anda tidak memeliki kendaraan", "Close", "");*/
	return 1;
}

CMD:aveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);

	if(vehicleid == INVALID_VEHICLE_ID)
		return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
	
	Servers(playerid, "Vehicle ID near on you id: %d (Model: %s(%d))", vehicleid, GetVehicleName(vehicleid), GetVehicleModel(vehicleid));
	return 1;
}

CMD:sendveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	
	new otherid, vehid, Float:x, Float:y, Float:z;
	if(sscanf(params, "ud", otherid, vehid)) return Usage(playerid, "/sendveh [playerid/name] [vehid] | /apv - for find vehid");
	
	if(!IsPlayerConnected(otherid)) return Error(playerid, "Player id not online!");
	if(!IsValidVehicle(vehid)) return Error(playerid, "Invalid veh id");
	
	GetPlayerPos(otherid, x, y, z);
	SetVehiclePos(vehid, x, y, z+0.5);
	SetVehicleVirtualWorld(vehid, GetPlayerVirtualWorld(otherid));
	LinkVehicleToInterior(vehid, GetPlayerInterior(otherid));
	Servers(playerid, "Your has send vehicle id %d to player %s(%d) | Location: %s.", vehid, pData[otherid][pName], otherid, GetLocation(x, y, z));
	return 1;
}

CMD:getveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new vehid, Float:posisiX, Float:posisiY, Float:posisiZ;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/getveh [vehid] | /apv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");
	if(!IsValidVehicle(vehid)) return Error(playerid, "Invalid veh id");
	GetPlayerPos(playerid, posisiX, posisiY, posisiZ);
	Servers(playerid, "Your get spawn vehicle to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), vehid);
	SetVehiclePos(vehid, posisiX, posisiY, posisiZ+0.5);
	SetVehicleVirtualWorld(vehid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehid, GetPlayerInterior(playerid));
	return 1;
}

CMD:gotoveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new vehid, Float:posisiX, Float:posisiY, Float:posisiZ;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/gotoveh [vehid] | /apv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");
	if(!IsValidVehicle(vehid)) return Error(playerid, "Invalid id");
	
	GetVehiclePos(vehid, posisiX, posisiY, posisiZ);
	Servers(playerid, "Your teleport to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), vehid);
	SetPlayerPosition(playerid, posisiX, posisiY, posisiZ+3.0, 4.0, 0);
	return 1;
}

Vehicle_WeaponStorage(playerid, vehicleid)
{
    if(vehicleid == -1)
        return 0;

    static
        string[1024];

    string[0] = 0;
    foreach(new i : PVehicles)
    {
    	if(vehicleid == pvData[i][cVeh])
    	{
    		if(pvData[i][cOwner] == pData[playerid][pID])
    		{
			    for(new z = 0; z < 5; z ++)
			    {
			        if(!pvData[i][cGun][z])
			            format(string, sizeof(string), "%sSlot Kosong\n", string);

			        else
			            format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(pvData[i][cGun][z]), pvData[i][cAmmo][z]);
			    }
			    ShowPlayerDialog(playerid, VEHICLE_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
			}
			else return Error(playerid, "kendaraan ini bukan milikmu.");
		}
	}
    return 1;
}

/*Vehicle_TrunknStorage(playerid, vehicleid)
{
    if(vehicleid == -1)
        return 0;

	new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
			    new items[1], string[10 * 32];

			    for (new z = 0; z < 5; z ++) if(pvData[i][cGun][z]) 
				{
			        items[0]++;
			    }
		    	format(string, sizeof(string), "Weapon Storage (%d/5)\n", items[0]);
		    	format(string, sizeof(string), "%sMoney Storage ({00ff00}%s{ffffff}/{00ff00}$100.000)\n", string, FormatMoney(pvData[i][cMoney]));
			    format(string, sizeof(string), "%sComponent Storage (%d/2500)\n", string, pvData[i][cComponent]);
			    format(string, sizeof(string), "%sMaterial Storage (%d/2500)\n", string, pvData[i][cMaterial]);
			    format(string, sizeof(string), "%sSeed Storage (%d/1000)\n", string, pvData[i][cSeed]);
			    format(string, sizeof(string), "%s"RED_E"Marijuana Storage (%dkg/100kg)"WHITE_E"\n", string, pvData[i][cMarijuana]);
			    ShowPlayerDialog(playerid, VEHICLE_STORAGE, DIALOG_STYLE_LIST, "Vehicle Storage", string, "Select", "Cancel");
			}
			else return Error(playerid, "kendaraan ini bukan milikmu.");
		}
	}
	return 1;
}*/

CMD:light(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{	
		if(!IsEngineVehicle(vehicleid))
			return ErrorMsg(playerid, "Kamu tidak berada didalam kendaraan.");
		
		switch(GetLightStatus(vehicleid))
		{
			case false:
			{
				SwitchVehicleLight(vehicleid, true);
			}
			case true:
			{
				SwitchVehicleLight(vehicleid, false);
			}
		}
	}
	else return ErrorMsg(playerid, "Anda harus mengendarai kendaraan!");
	return 1;
}

CMD:hood(playerid, params[])
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
       		SuccesMsg(playerid, "Vehicle Hood ~g~OPEN");
       	}
       	case true:
       	{
       		SwitchVehicleBonnet(vehicleid, false);
       		SuccesMsg(playerid, "Vehicle Hood ~r~CLOSED");
       	}
    }
	return 1;
}
CMD:trunk(playerid, params[])
{
  	new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

   	if(vehicleid == INVALID_VEHICLE_ID)
   		return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

   	switch (GetTrunkStatus(vehicleid))
   	{
   		case false:
   		{
   			SwitchVehicleBoot(vehicleid, true);
   			SuccesMsg(playerid, "Vehicle Bagasi ~g~OPEN");
   		}
   		case true:
   		{
   			SwitchVehicleBoot(vehicleid, false);
   			SuccesMsg(playerid, "Vehicle Bagasi ~g~OPEN");
   		}
   	}
	return 1;
}
CMD:lock(playerid, params[])
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
				SuccesMsg(playerid, "Kendaraan anda telah Dikunci");
				GetPlayerPos(playerid, X, Y, Z);
				SwitchVehicleDoors(pvData[carid][cVeh], true);
			}
			else
			{
				pvData[carid][cLocked] = 0;
				new Float:X, Float:Y, Float:Z;
				SuccesMsg(playerid, "Kendaraan anda telah Dibuka");
				GetPlayerPos(playerid, X, Y, Z);
				SwitchVehicleDoors(pvData[carid][cVeh], false);
			}
		}
			//else SendErrorMessage(playerid, "You are not in range of anything you can lock.");
	}
	else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun yang ingin anda kunci.");
}

CMD:vpanel(playerid, params[])
{
	for(new i = 0; i < 54; i++)
	{
		PlayerTextDrawShow(playerid, PR_PANELSTD[playerid][i]);
	}
	SelectTextDraw(playerid, COLOR_LBLUE);
	return 1;
}

CMD:vrm(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_VRM, DIALOG_STYLE_LIST, "ValriseReality - Menu Kendaraan", "Kunci\nLampu\nBagasi\nBuka/Tutup Hood\nBuka/Tutup Trunk", "Pilih", "Batal");
}

CMD:v(playerid, params[])
{
	static
	type[20],
	string[225],
	vehicleid;

	if(sscanf(params, "s[20]S()[128]", type, string))
	{
		SendClientMessage(playerid,COLOR_BLUE,"|__________________ Vehicle Command __________________|");
		SendClientMessage(playerid,COLOR_WHITE,"VEHICLE: /v [(en)gine(Y)] [(li)ghts(N)] [hood] [boot] [tow] [untow]");
		SendClientMessage(playerid,COLOR_WHITE,"VEHICLE: /v [my] [lock] [park] [storage] [repair]");
		return 1;
	}
	else if(!strcmp(type, "engine", true))
	{
		vehicleid = GetPlayerVehicleID(playerid);
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{	
			if(!IsEngineVehicle(vehicleid))
				return ShowNotifError(playerid, "Kamu tidak berada didalam kendaraan.", 5000);
			
			if(GetEngineStatus(vehicleid))
			{
				EngineStatus(playerid, vehicleid);
			}
			else
			{
				ShowNotifInfo(playerid, "Anda mencoba menyalakan mesin kendaraan..", 5000);
				InfoTD_MSG(playerid, 4000, "Start Engine...");
				SetTimerEx("EngineStatus", 2000, false, "id", playerid, vehicleid);
			}
		}
		else return ShowNotifError(playerid, "Anda harus mengendarai kendaraan!", 5000);
	}
	else if(!strcmp(type,"lights",true))
	{
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
				}
				case true:
				{
					SwitchVehicleLight(vehicleid, false);
				}
			}
		}
		else return Error(playerid, "Anda harus mengendarai kendaraan!");
	}
	else if(!strcmp(type,"hood",true))
	{
        if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Kamu harus keluar dari kendaraan.");

        vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

        if(vehicleid == INVALID_VEHICLE_ID)
        	return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        switch (GetHoodStatus(vehicleid))
        {
        	case false:
        	{
        		SwitchVehicleBonnet(vehicleid, true);
        		InfoTD_MSG(playerid, 4000, "Vehicle Hood ~g~Dibuka");
        	}
        	case true:
        	{
        		SwitchVehicleBonnet(vehicleid, false);
        		InfoTD_MSG(playerid, 4000, "Vehicle Hood ~r~Ditutup");
        	}
        }
    }
    else if(!strcmp(type,"boot",true))
    {
    	if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Kamu harus keluar dari kendaraan.");

    	vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

    	if(vehicleid == INVALID_VEHICLE_ID)
    		return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

    	switch (GetTrunkStatus(vehicleid))
    	{
    		case false:
    		{
    			SwitchVehicleBoot(vehicleid, true);
    			Info(playerid, "Vehicle boot "GREEN_E"dibuka.");
    		}
    		case true:
    		{
    			SwitchVehicleBoot(vehicleid, false);
    			Info(playerid, "Vehicle boot "RED_E"ditutup.");
    		}
    	}
    }
    else if(!strcmp(type,"lock",true))
    {
		return callcmd::kunci(playerid, params);
	}
    else if(!strcmp(type,"park",true))
    {
    	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    		return Error(playerid, "Kamu harus menaiki kendaraan");

    	new vehid = GetPlayerVehicleID(playerid);
    	foreach(new ii : PVehicles)
    	{
    		if(vehid == pvData[ii][cVeh])
    		{
    			if(pvData[ii][cOwner] == pData[playerid][pID])
    			{
    				Vehicle_GetStatus(ii);
    				if(IsValidVehicle(pvData[ii][cVeh]))
    					DestroyVehicle(pvData[ii][cVeh]);

    				pvData[ii][cVeh] = 0;

					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					OnPlayerVehicleRespawn(ii);
					InfoTD_MSG(playerid, 4000, "Kamu telah ~g~Memparkirkan~w~ Kendaraan ini!");
					SetPlayerArmedWeapon(playerid, 0);
					PutPlayerInVehicle(playerid, pvData[ii][cVeh], 0);
    			}
    			else return Error(playerid, "Kamu harus menaikan kendaraan pribadimu");
    		}
    	}
	}
	else if(!strcmp(type,"my",true))
	{
		if(!GetOwnedVeh(playerid)) return Error(playerid, "You don't have any Vehicle.");
		new vid, _tmpstring[128], count = GetOwnedVeh(playerid), CMDSString[512], status[30], status1[30];
		CMDSString = "";
		strcat(CMDSString,"No\tName\tPlate\tStatus\n",sizeof(CMDSString));
		Loop(itt, (count + 1), 1)
		{
			vid = ReturnPlayerVehID(playerid, itt);
			if(pvData[vid][cParkid] != -1)
			{
				status = "{3BBD44}Garkot";
			}
			else if(pvData[vid][cClaim] != 0)
			{
				status = "{D2D2AB}Insurance";
			}
			else
			{
				status = "{FFFF00}Spawned";
			}

			if(pvData[vid][cRent] != 0)
			{
				status1 = "{BABABA}(Rental)";
			}
			else 
			{
				status1 = "";
			}

			if(itt == count)
			{
				format(_tmpstring, sizeof(_tmpstring), "{ffffff}%d.\t%s%s{ffffff}\t%s\t%s\n", itt, GetVehicleModelName(pvData[vid][cModel]), status1, pvData[vid][cPlate], status);
			}
			else format(_tmpstring, sizeof(_tmpstring), "{ffffff}%d.\t%s%s{ffffff}\t%s\t%s\n", itt, GetVehicleModelName(pvData[vid][cModel]), status1, pvData[vid][cPlate], status);
			strcat(CMDSString, _tmpstring);
		}
		ShowPlayerDialog(playerid, DIALOG_MYVEH, DIALOG_STYLE_TABLIST_HEADERS, "My Vehicle", CMDSString, "Select", "Cancel");
	}
	else if(!strcmp(type,"insu",true))
	{
		new bool:found = false, msg2[512];
		format(msg2, sizeof(msg2), "ID\tInsurance\tClaim Time\tTicket\n");
		foreach(new i : PVehicles)
		{
			if(pvData[i][cVeh] == 0 && pvData[i][cClaim] == 1)
			{
				if(pvData[i][cOwner] == pData[playerid][pID])
				{
					new statusticket[128];
					if(pvData[i][cTicket] == 0)
					{
						statusticket = "{00ff00}No{ffffff}";
					}
					else
					{
						statusticket = "{ff0000}Yes{ffffff}";
					}

					if(pvData[i][cClaimTime] != 0)
					{
						format(msg2, sizeof(msg2), "%s%d\t%s\t%s\t"RED_E"%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), ReturnTimelapse(gettime(), pvData[i][cClaimTime]), statusticket);
						found = true;
					}
					else
					{
						format(msg2, sizeof(msg2), "%s%d\t%s\tClaimed\t"RED_E"%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), statusticket);
						found = true;
					}
				}
			}
		}
		if(found)
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Vehicles Insurance", msg2, "Close", "");
		else
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles Insurance", "Anda tidak memeliki kendaraan yang berada di insu", "Close", "");
	}
	else if(!strcmp(type,"neon",true))
	{
		vehicleid = GetPlayerVehicleID(playerid);
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(!IsEngineVehicle(vehicleid))
				return Error(playerid, "Kamu tidak berada didalam kendaraan.");
			
			new carid = -1;
			if((carid = Vehicle_Nearest(playerid)) != -1)
			{
				if(Vehicle_IsOwner(playerid, carid))
				{
					if(pvData[carid][cTogNeon] == 0)
					{
						if(pvData[carid][cNeon] != 0)
						{
							SetVehicleNeonLights(pvData[carid][cVeh], true, pvData[carid][cNeon], 0);
							InfoTD_MSG(playerid, 4000, "Neon ~g~ON");
							pvData[carid][cTogNeon] = 1;
						}
						else
						{
							SetVehicleNeonLights(pvData[carid][cVeh], false, pvData[carid][cNeon], 0);
							pvData[carid][cTogNeon] = 0;
						}
					}
					else
					{
						SetVehicleNeonLights(pvData[carid][cVeh], false, pvData[carid][cNeon], 0);
						InfoTD_MSG(playerid, 4000, "Neon ~r~OFF");
						pvData[carid][cTogNeon] = 0;
					}
				}
			}
		}
		else return Error(playerid, "Anda harus mengendarai kendaraan!");
	}
	else if(!strcmp(type, "storage", true))
	{
		if(IsPlayerInAnyVehicle(playerid)) 
			return Error(playerid, "You must exit from the vehicle.");

		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		static
		carid = -1;

		if((carid = Vehicle_Nearest(playerid)) != -1)
		{
			if(pvData[carid][cLocked] != 0) return Error(playerid, "Bagasi terkunci");
			if(IsAVehicleStorage(x))
			{
				if(Vehicle_IsOwner(playerid, carid) || pData[playerid][pFaction] == 1)
				{
					new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
					foreach(new i : PVehicles)
					{
						if(vehid == pvData[i][cVeh])
						{
							if(pvData[i][cOwner] == pData[playerid][pID])
							{
								if(GetVehicleModel(vehid) == 509 || GetVehicleModel(vehid) == 510 || GetVehicleModel(vehid) == 481)
									return Error(playerid, "Kendaraan ini tidak memiliki storage untuk menyimpan barang");
								{
									if(!GetTrunkStatus(vehid))
										return Error(playerid, "Kamu harus membuka trunk kendaraanmu untuk membuka storage");
									{
										ShowPlayerDialog(playerid, DIALOG_BAGASI, DIALOG_STYLE_LIST, "BAGASI", "Storage Weapons\nStorage [1]\nstorage [2]", "Select", "<<<");
									}
								}
							}
						}
					}
				}
			}
		}
	}
	else if(!strcmp(type,"tow",true))
	{
		return callcmd::tow(playerid, params);
	}
	else if(!strcmp(type,"untow",true))
	{
		return callcmd::untow(playerid, params);
	}
	else if(!strcmp(type, "repair", true))
	{
		if(pData[playerid][pRepairkit] < 1)
			return Error(playerid, "Kamu tidak memiliki repairkit");

		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return Error(playerid, "Kamu harus berada di dalam kendaraan");

		SetValidVehicleHealth(GetPlayerVehicleID(playerid), 2000);
		ValidRepairVehicle(GetPlayerVehicleID(playerid));
	    Servers(playerid, "Vehicle Fixed!");
	    pData[playerid][pRepairkit] -= 1;
	}
	return 1;
}

CMD:speedlimit(playerid, params[])
{
	new speed;
	if(sscanf(params, "i", speed)) return Usage(playerid, "/speedlimit [Max MPH] - /speedlimit 0 -  untuk menonaktifkan");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return Error(playerid, "Kamu harus mengendarai kendaraan!");

	if(speed < 0 || speed > 500) return Error(playerid, "Limit speed tidak bisa kurang dari 0 dan lebih dari 500!");
	LimitSpeed[playerid] = speed;
	if(speed == 0) Info(playerid, "Kamu telah menonaktifkan limit speed.");
    else Info(playerid, "kamu merubah limit speed kendaraanmu menjadi {ff0000}%d{ffffff}/Mph (termasuk jika kamu berpindah kendaraan)", speed);
	return 1;
}

/*SetPrivateVehiclePark(playerid, vehicleid, Float:newx, Float:newy, Float:newz, Float:newangle, Float:health, fuel)
{
	foreach(new ii : PVehicles)
	{
		if(vehicleid == pvData[ii][cVeh])
		{
			new Float:oldx, Float:oldy, Float:oldz;
			oldx = pvData[ii][cPosX];
			oldy = pvData[ii][cPosY];
			oldz = pvData[ii][cPosZ];
			 
			if(oldx == newx && oldy == newy && oldz == newz) return 0;
			 
			pvData[ii][cPosX] = newx;
			pvData[ii][cPosY] = newy;
			pvData[ii][cPosZ] = newz;
			pvData[ii][cPosA] = newangle;
			GetVehicleDamageStatus(pvData[ii][cVeh], pvData[ii][cDamage][0], pvData[ii][cDamage][1], pvData[ii][cDamage][2], pvData[ii][cDamage][4]);
			 
			DestroyVehicle(pvData[ii][cVeh]);
			
			pvData[ii][cVeh] = CreateVehicle(pvData[i][cModel], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ], pvData[i][cPosA], pvData[i][cColor1], pvData[i][cColor2], -1);
			SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
			SetVehicleVirtualWorld(pvData[i][cVeh], pvData[i][cVw]);
			LinkVehicleToInterior(pvData[i][cVeh], pvData[i][cInt]);
			SetVehicleFuel(pvData[i][cVeh], pvData[i][cFuel]);
			SetValidVehicleHealth(pvData[i][cVeh], pvData[i][cHealth]);
			UpdateVehicleDamageStatus(pvData[i][cVeh], pvData[i][cDamage][0], pvData[i][cDamage][1], pvData[i][cDamage][2], pvData[i][cDamage][3]);
			 
        }
	}
	return 0;
}*/

CMD:unrentpv(playerid, params[])
{		
	new vehid;
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -77.4220,-1136.6021,1.0781)) return Error(playerid, "Kamu harus berada di Asuransi!");
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/unrentpv [vehid] | /mypv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

	foreach(new i : PVehicles)			
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(pvData[i][cRent] != 0)
				{
					Info(playerid, "You has unrental the vehicle id %d (database id: %d).", vehid, pvData[i][cID]);
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
					Iter_SafeRemove(PVehicles, i, i);
				}
				else return Error(playerid, "This is not rental vehicle! use /sellpv for sell owned vehicle.");
			}
			else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:agivepv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new vehid, otherid;
	if(sscanf(params, "ud", otherid, vehid)) return Usage(playerid, "/agivepv [playerid/name] [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
		return Error(playerid, "The specified player is disconnected or not near you.");

	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				new nearid = GetNearestVehicleToPlayer(playerid, 5.0, false);
				if(vehid == nearid)
				{
					if(pvData[i][cRent] != 0) return Error(playerid, "You can't give rental vehicle!");
					Info(playerid, "Anda memberikan kendaraan %s(%d) anda kepada %s.", GetVehicleName(vehid), GetVehicleModel(vehid), ReturnName(otherid));
					Info(otherid, "%s Telah memberikan kendaraan %s(%d) kepada anda.(/mypv)", ReturnName(playerid), GetVehicleName(vehid), GetVehicleModel(vehid));
					pvData[i][cOwner] = pData[otherid][pID];
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "UPDATE vehicle SET owner='%d' WHERE id='%d'", pData[otherid][pID], pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					return 1;
				}
				else return Error(playerid, "Anda harus berada di dekat kendaraan yang anda jual!");
			}
			else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:givepv(playerid, params[])
{
	new vehid, otherid;
	if(sscanf(params, "ud", otherid, vehid)) return Usage(playerid, "/givepv [playerid/name] [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
		return Error(playerid, "The specified player is disconnected or not near you.");

	new count = 0, limit = MAX_PLAYER_VEHICLE + pData[otherid][pVip];
	foreach(new ii : PVehicles)
	{
		if(pvData[ii][cOwner] == pData[otherid][pID])
			count++;
	}
	if(count >= limit)
	{
		Error(playerid, "This player have too many vehicles, sell a vehicle first!");
		return 1;
	}
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				new nearid = GetNearestVehicleToPlayer(playerid, 5.0, false);
				if(vehid == nearid)
				{
					if(pvData[i][cRent] != 0) return Error(playerid, "You can't give rental vehicle!");
					Info(playerid, "Anda memberikan kendaraan %s(%d) anda kepada %s.", GetVehicleName(vehid), GetVehicleModel(vehid), ReturnName(otherid));
					Info(otherid, "%s Telah memberikan kendaraan %s(%d) kepada anda.(/mypv)", ReturnName(playerid), GetVehicleName(vehid), GetVehicleModel(vehid));
					pvData[i][cOwner] = pData[otherid][pID];
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "UPDATE vehicle SET owner='%d' WHERE id='%d'", pData[otherid][pID], pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					return 1;
				}
				else return Error(playerid, "Anda harus berada di dekat kendaraan yang anda jual!");
			}
			else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

GetDistanceToCar(playerid, veh, Float: posX = 0.0, Float: posY = 0.0, Float: posZ = 0.0) {

	new
	Float: Floats[2][3];

	if(posX == 0.0 && posY == 0.0 && posZ == 0.0) {
		if(!IsPlayerInAnyVehicle(playerid)) GetPlayerPos(playerid, Floats[0][0], Floats[0][1], Floats[0][2]);
		else GetVehiclePos(GetPlayerVehicleID(playerid), Floats[0][0], Floats[0][1], Floats[0][2]);
	}
	else {
		Floats[0][0] = posX;
		Floats[0][1] = posY;
		Floats[0][2] = posZ;
	}
	GetVehiclePos(veh, Floats[1][0], Floats[1][1], Floats[1][2]);
	return floatround(floatsqroot((Floats[1][0] - Floats[0][0]) * (Floats[1][0] - Floats[0][0]) + (Floats[1][1] - Floats[0][1]) * (Floats[1][1] - Floats[0][1]) + (Floats[1][2] - Floats[0][2]) * (Floats[1][2] - Floats[0][2])));
}

GetClosestCar(playerid, exception = INVALID_VEHICLE_ID) 
{

	new
	Float: Distance,
	target = -1,
	Float: vPos[3];

	if(!IsPlayerInAnyVehicle(playerid)) GetPlayerPos(playerid, vPos[0], vPos[1], vPos[2]);
	else GetVehiclePos(GetPlayerVehicleID(playerid), vPos[0], vPos[1], vPos[2]);

	for(new v; v < MAX_VEHICLES; v++) if(GetVehicleModel(v) >= 400) 
	{
		if(v != exception && (target < 0 || Distance > GetDistanceToCar(playerid, v, vPos[0], vPos[1], vPos[2]))) 
		{
			target = v;
            Distance = GetDistanceToCar(playerid, v, vPos[0], vPos[1], vPos[2]); // Before the rewrite, we'd be running GetPlayerPos 2000 times...
        }
    }
    return target;
}

CMD:tow(playerid, params[]) 
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		new carid = GetPlayerVehicleID(playerid);
		if(IsATowTruck(carid))
		{
			new closestcar = GetClosestCar(playerid, carid);

			if(GetDistanceToCar(playerid, closestcar) <= 8 && !IsTrailerAttachedToVehicle(carid)) 
			{
				Info(playerid, "You has towed the vehicle in trailer.");
				AttachTrailerToVehicle(closestcar, carid);
				return 1;
			}
		}
		else
		{
			Error(playerid, "Anda harus mengendarai Tow truck.");
			return 1;
		}
	}
	else
	{
		Error(playerid, "Anda harus mengendarai Tow truck.");
		return 1;
	}
	return 1;
}

CMD:untow(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
		{
			ShowNotifInfo(playerid, "You has untowed the vehicle trailer.", 5000);
			DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
		}
		else
		{
			ShowNotifError(playerid, "Tow penderek kosong!", 5000);
		}
	}
	else
	{
		ShowNotifError(playerid, "Anda harus mengendarai Tow truck.", 5000);
		return 1;
	}
	return 1;
}

/*CMD:vmenu(playerid, params[])
{
	new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

   	if(vehicleid == INVALID_VEHICLE_ID) ShowNotifError(playerid, "Kamu tidak berada didekat Kendaraan apapun.", 5000);
   	{
   		ShowPlayerDialog(playerid, DIALOG_VMENU, DIALOG_STYLE_LIST, "Vehicle Menu", "Mesin\nKunci\nBagasi\nBuka/Tutup Hood\nBuka/Tutup Trunk\nOn/Off Neon", "Pilih", "Batal");
   	}
   	return 1;
}*/

cmd:kunci(playerid, params[])
{
	new bool:found = false, msg2[512], locked[128];
	format(msg2, sizeof(msg2), "Model\tStatus\n");
	format(msg2, sizeof(msg2), "%s{7fffd4}Nearest Vehicles"WHITE_E"\t\n", msg2);
	foreach(new i : PVehicles)
	{
		if(IsValidVehicle(pvData[i][cVeh]))
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(pvData[i][cLocked] == 1)
				{
					locked = ""RED_E"Locked"WHITE_E"";
					PlayAudioStreamForPlayer(playerid, "https://cdn.discordapp.com/attachments/955329178885042186/1052091263312216114/car-lock-sound-effect.mp3", 5.0, 5.0, 5.0, 5.0);
				}
				else if(pvData[i][cLocked] == 0)
				{
					locked = ""GREEN_LIGHT"Unlocked"WHITE_E"";
					PlayAudioStreamForPlayer(playerid, "https://cdn.discordapp.com/attachments/955329178885042186/1052091263312216114/car-lock-sound-effect.mp3", 5.0, 5.0, 5.0, 5.0);
				}
				if(strcmp(pvData[i][cPlate], "None"))
				{
					if(pvData[i][cRent] != 0)
					{
						format(msg2, sizeof(msg2), "%s%s (ID: %d)\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], locked);
						found = true;
					}
					else
					{
						format(msg2, sizeof(msg2), "%s%s (ID: %d)\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], locked);
						found = true;
					}
				}
				else
				{
					if(pvData[i][cRent] != 0)
					{
						format(msg2, sizeof(msg2), "%s%s (ID: %d)\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], locked);
						found = true;
					}
					else
					{
						format(msg2, sizeof(msg2), "%s%s (ID: %d)\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], locked);
						found = true;
					}
				}
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_PVEHLOCKED, DIALOG_STYLE_TABLIST_HEADERS, "(Unlock/Lock) Vehicles", msg2, "Select", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Anda tidak memeliki kendaraan", "Close", "");

	return 1;
}

CMD:vstorage(playerid, params[])
{
	static
   	carid = -1;

	if(IsPlayerInAnyVehicle(playerid)) 
		return ErrorMsg(playerid, "Anda harus berada di luar kendaraan!");

	new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

	if(!GetTrunkStatus(x) && !IsABike(x)) return ErrorMsg(playerid,"Buka bagasi terlebih dahulu");

	if((carid = Vehicle_Nearest(playerid)) != -1)
	{
		if(IsAVehicleStorage(x))
		{
			if(Vehicle_IsOwner(playerid, carid) || pData[playerid][pFaction] == 1)
			{
				foreach(new i: PVehicles)
				if(x == pvData[i][cVeh])
				{
					new vehid = pvData[i][cVeh];

					if(pvData[vehid][LoadedStorage] == false)
					{
						new cQuery[600];

						mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT * FROM `vstorage` WHERE `owner`='%d'", pvData[i][cID]);
						mysql_tquery(g_SQL, cQuery, "CheckVehicleStorageStatus", "iii", playerid, vehid, i);
					}
					else
					{
						new cQuery[600];

						mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT * FROM `vstorage` WHERE `owner`='%d'", pvData[i][cID]);
						mysql_tquery(g_SQL, cQuery, "CheckVehicleStorageStatus", "iii", playerid, vehid, i);
					}

					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
			else ErrorMsg(playerid, "Kendaraan ini bukan milik anda!");
		}	
		else ErrorMsg(playerid, "Kendaraan tidak mempunyai penyimpanan/ bagasi!");
	}
	else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
	return 1;
}