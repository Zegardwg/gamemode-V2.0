/*

	SYSTEM KEBAKARAN

*/

#include <YSI\y_hooks>

//Pre-Defined
#define INVALID_FIRE_ID -1
#define MAX_DYNAMIC_FIRE 500

//Macros
#define Fire_GetInside(%0)		playerInsideFire[%0]
#define Fire_SetInside(%0,%1)	playerInsideFire[%0]=%1

//Enum
enum E_FIRE
{
    fireID,
    fireObject,
    fireModel,
    fireArea,
    fireInterior,
    fireVirtualWorld,
    Float:fireHealth,

    Float:firePosX,
    Float:firePosY,
    Float:firePosZ
};
new 
    FireData[MAX_DYNAMIC_FIRE][E_FIRE],
    Iterator:Fire<MAX_DYNAMIC_FIRE>;

new playerInsideFire[MAX_PLAYERS] = {INVALID_FIRE_ID, ...};

//FUNCTION

Fire_IsExists(index)
{
	if(Iter_Contains(Fire, index))
		return 1;
	
	return 0;
}

Fire_Create(model, Float:x, Float:y, Float:z, int, vw, Float:health = 1000.0)
{
	static
		index;

	if((index = Iter_Free(Fire)) != cellmin)
	{
		Iter_Add(Fire, index);

        FireData[index][fireModel] = model;
        FireData[index][fireInterior] = int;
        FireData[index][fireVirtualWorld] = vw;
        FireData[index][fireHealth] = health;
		FireData[index][firePosX] = x;
		FireData[index][firePosY] = y;
		FireData[index][firePosZ] = z-2;

		mysql_tquery(g_SQL, sprintf("INSERT INTO `fire` (`fireInt`, `fireWorld`) VALUES ('%d', '%d');", FireData[index][fireInterior], FireData[index][fireVirtualWorld]), "OnFireCreated", "d", index);
		return index;
	}
	return -1;
}

Fire_Delete(index)
{
	if(Fire_IsExists(index))
	{
		Iter_Remove(Fire, index);

		mysql_tquery(g_SQL, sprintf("DELETE FROM `fire` WHERE `fireID`='%d';", FireData[index][fireID]));

		if(IsValidDynamicArea(FireData[index][fireArea]))
			DestroyDynamicArea(FireData[index][fireArea]);

		if(IsValidDynamicObject(FireData[index][fireObject]))
			DestroyDynamicObject(FireData[index][fireObject]);

		new tmp_FireData[E_FIRE];
		FireData[index] = tmp_FireData;

		FireData[index][fireArea] = INVALID_STREAMER_ID;
		FireData[index][fireObject] = INVALID_STREAMER_ID;
		return 1;
	}
	return 0;
}

Fire_Sync(index)
{
	if(Fire_IsExists(index))
	{
		if(IsValidDynamicObject(FireData[index][fireObject]))
		{
            Streamer_SetIntData(STREAMER_TYPE_OBJECT, FireData[index][fireObject], E_STREAMER_MODEL_ID, FireData[index][fireModel]);

			Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FireData[index][fireObject], E_STREAMER_X, FireData[index][firePosX]);
			Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FireData[index][fireObject], E_STREAMER_Y, FireData[index][firePosY]);
			Streamer_SetFloatData(STREAMER_TYPE_OBJECT, FireData[index][fireObject], E_STREAMER_Z, FireData[index][firePosZ] - 0.4);

			Streamer_SetIntData(STREAMER_TYPE_OBJECT, FireData[index][fireObject], E_STREAMER_INTERIOR_ID, FireData[index][fireInterior]);
			Streamer_SetIntData(STREAMER_TYPE_OBJECT, FireData[index][fireObject], E_STREAMER_WORLD_ID, FireData[index][fireVirtualWorld]);

        }
		else 
        {
            FireData[index][fireObject] = CreateDynamicObject(FireData[index][fireModel], FireData[index][firePosX], FireData[index][firePosY], FireData[index][firePosZ] - 0.4, 0.0, 0.0, 0.0, FireData[index][fireVirtualWorld], FireData[index][fireInterior], -1, 50, 50);
        }

		if(IsValidDynamicArea(FireData[index][fireArea]))
		{
			Streamer_SetFloatData(STREAMER_TYPE_AREA, FireData[index][fireArea], E_STREAMER_X, FireData[index][firePosX]);
			Streamer_SetFloatData(STREAMER_TYPE_AREA, FireData[index][fireArea], E_STREAMER_Y, FireData[index][firePosY]);
			Streamer_SetFloatData(STREAMER_TYPE_AREA, FireData[index][fireArea], E_STREAMER_MIN_Z, FireData[index][firePosZ] - 1.0);
			Streamer_SetFloatData(STREAMER_TYPE_AREA, FireData[index][fireArea], E_STREAMER_MAX_Z, FireData[index][firePosZ] + 3.0);

			Streamer_SetIntData(STREAMER_TYPE_AREA, FireData[index][fireArea], E_STREAMER_INTERIOR_ID, FireData[index][fireInterior]);
			Streamer_SetIntData(STREAMER_TYPE_AREA, FireData[index][fireArea], E_STREAMER_WORLD_ID, FireData[index][fireVirtualWorld]);
		}
		else
		{			
			FireData[index][fireArea] = CreateDynamicCylinder(FireData[index][firePosX], FireData[index][firePosY], FireData[index][firePosZ] - 1.0, FireData[index][firePosZ] + 3.0, 20.0, FireData[index][fireVirtualWorld], FireData[index][fireInterior]);
			new Fire_Streamer_Info[2]; 

			Fire_Streamer_Info[0] = FIRE_AREA_INDEX;
			Fire_Streamer_Info[1] = index;
			Streamer_SetArrayData(STREAMER_TYPE_AREA, FireData[index][fireArea], E_STREAMER_EXTRA_ID, Fire_Streamer_Info);
		}
	}
	return 1;
}

CreateExplosionEx(Float:x, Float:y, Float:z)
{
    CreateExplosion(x, y, z, 13, 100.0);
    CreateExplosion(x, y, z, 13, 100.0);
    CreateExplosion(x, y, z+10.0, 13, 100.0);
    CreateExplosion(x+random(10)-5, y+random(10)-5, z+random(10)-5, 13, 100.0);
    return 1;
}

Fire_Nearest(playerid)
{
	foreach(new i : Fire) if(IsPlayerInRangeOfPoint(playerid, 10.0, FireData[i][firePosX], FireData[i][firePosY], FireData[i][firePosZ]))
	{
		if(GetPlayerInterior(playerid) == FireData[i][fireInterior] && GetPlayerVirtualWorld(playerid) == FireData[i][fireVirtualWorld])
			return i;
	}
	return -1;
}
Fire_Skin(skinid)
{
    if(skinid == 277 || skinid == 278 || skinid == 279)
        return 1;

    return 0;
}
/*SetBusinessOnFire(playerid, bid)
{
    if(FactionMember_GetCount(3, true) > 0)
    { 
        new Float:x, Float:y, Float:z, int, vw;

        GetPlayerPos(playerid, x, y, z);
        vw = GetPlayerVirtualWorld(playerid);
        int = GetPlayerInterior(playerid);
        CreateExplosionEx(x, y, z);
        CreateExplosionEx(bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]);

        Fire_Create(18690, x, y, z, int, vw);
        Fire_Create(18690, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0, 0);

        SendFactionMessage(3, COLOR_HOSPITAL, "{00FFFF}[ALARM] {FFFFFF}%s Business alarm is triggered, business is on fire", bData[bid][bName]);

        Servers(playerid, "This business exploded and on fire while they cooking your food, alarm has been triggered!");
    }
    return 1;
}*/
IsValidFireVehicle(vehicleid)
{
    if(IsFourWheelVehicle(vehicleid) || IsABike(vehicleid) || IsSportBike(vehicleid))
        return 1;

    return 0;
}

IsPlayerInFirePoint(playerid, fireid, Float:range = 5.0)
{
    if(Fire_IsExists(fireid))
    {
        if(IsPlayerInRangeOfPoint(playerid, range, FireData[fireid][firePosX], FireData[fireid][firePosY], FireData[fireid][firePosZ]))
        {
            return 1;
        }
        return 0;
    }
    return 0;
}


/*SetHouseOnFire(playerid, hid)
{
    if(FactionMember_GetCount(3, true) > 3)
    { 
        new Float:x, Float:y, Float:z,
            vw, int;

        GetPlayerPos(playerid, x, y, z);
        vw = GetPlayerVirtualWorld(playerid);
        int = GetPlayerInterior(playerid);
        CreateExplosionEx(x, y, z);
        CreateExplosionEx(hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]);
        Fire_Create(18690, x, y, z, int, vw);
        Fire_Create(18690, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], 0, 0);
    }
    return 1;
}*/



IsPlayerInFireTruck(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(GetVehicleModel(vehicleid) == 407)
        {
            return 1;
        }
    }
    return 0;
}

ptask Player_FireExhausting[500](playerid)
{
    if(!pData[playerid][IsLoggedIn])
        return 0;

    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);
    if((keys & KEY_FIRE))
    {
        new fireid = Fire_GetInside(playerid);
        if(fireid != INVALID_FIRE_ID)
        {
            if(GetPlayerWeapon(playerid) == 42 && IsPlayerInFirePoint(playerid, fireid, 5.0))
            {
                if(FireData[fireid][fireHealth] > 0) 
                {
                    FireData[fireid][fireHealth] -= 10.0;
                }
                else if(FireData[fireid][fireHealth] <= 0)
                {
                    FireData[fireid][fireHealth] = 0;
                    Fire_Delete(fireid);
                }
            }
            else if(IsPlayerInFireTruck(playerid) && IsPlayerInFirePoint(playerid, fireid, 15.0))
            {
                if(FireData[fireid][fireHealth] > 0) 
                {
                    FireData[fireid][fireHealth] -= 25.0;
                }
                else if(FireData[fireid][fireHealth] <= 0)
                {
                    FireData[fireid][fireHealth] = 0;
                    Fire_Delete(fireid);
                }
            }
        }
    }
    return 1;
}
ptask Player_NearFire[1000](playerid)
{
    new fireid;
    if((fireid = Fire_GetInside(playerid)) != INVALID_FIRE_ID)
    {
        if(IsPlayerInFirePoint(playerid, fireid, 3.0))
        {
            new skinid = GetPlayerSkin(playerid);
            if(!Fire_Skin(skinid))
            {
                new Float:health;
                GetPlayerHealth(playerid, health);
                SetPlayerHealthEx(playerid, health-30);
            }
        }
    }
    return 1;
}

// Callback
function OnFireCreated(index)
{
	FireData[index][fireID] = cache_insert_id();

	Fire_Sync(index);
	return 1;
}

function Fire_Load()
{
	if(cache_num_rows())
	{
		for(new i = 0; i != cache_num_rows(); i++)
		{
			Iter_Add(Fire, i);

			cache_get_value_name_int(i, "fireID", FireData[i][fireID]);
			cache_get_value_name_int(i, "fireModel", FireData[i][fireModel]);

	        cache_get_value_name_int(i, "fireInt", FireData[i][fireInterior]);
	        cache_get_value_name_int(i, "fireWorld", FireData[i][fireVirtualWorld]);
	        cache_get_value_name_float(i, "fireHealth", FireData[i][fireHealth]);

	        cache_get_value_name_float(i, "fireX", FireData[i][firePosX]);
            cache_get_value_name_float(i, "fireY", FireData[i][firePosY]);
            cache_get_value_name_float(i, "fireZ", FireData[i][firePosZ]);

			Fire_Sync(i);
		}
		printf("*** Loaded %d Active Fire's", cache_num_rows());
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
	Fire_SetInside(playerid, INVALID_FIRE_ID);
}


hook OnPlayerEnterDynArea(playerid, areaid)
{
	new Fire_Streamer_Info[2];
    Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, Fire_Streamer_Info);

    if(Fire_Streamer_Info[0] == FIRE_AREA_INDEX)
    {
        new index = Fire_Streamer_Info[1];

        if(Fire_IsExists(index)) {
        	Fire_SetInside(playerid, index);
            PlayerPlaySound(playerid, 3401, 0.0, 0.0, 0.0);
        }
    }
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
	new Fire_Streamer_Info[1];
    Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, Fire_Streamer_Info);

    if(Fire_Streamer_Info[0] == FIRE_AREA_INDEX) {
    	Fire_SetInside(playerid, INVALID_FIRE_ID);
        PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
    }
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(HOLDING(KEY_FIRE))
    {
        new fireid = Fire_GetInside(playerid);
        if(fireid != INVALID_FIRE_ID)
        {
            if(GetPlayerWeapon(playerid) == 42 && IsPlayerInFirePoint(playerid, fireid, 5.0))
            {
                if(FireData[fireid][fireHealth] > 0) 
                {
                    FireData[fireid][fireHealth] -= 10.0;
                }
                else if(FireData[fireid][fireHealth] <= 0)
                {
                    FireData[fireid][fireHealth] = 0;
                    Fire_Delete(fireid);
                }
            }
            else if(IsPlayerInFireTruck(playerid) && IsPlayerInFirePoint(playerid, fireid, 20.0))
            {
                if(FireData[fireid][fireHealth] > 0) 
                {
                    FireData[fireid][fireHealth] -= 25.0;
                }
                else if(FireData[fireid][fireHealth] <= 0)
                {
                    FireData[fireid][fireHealth] = 0;
                    Fire_Delete(fireid);
                }
            }
        }
    }
}

hook OnVehicleDeath(vehicleid, killerid)
{
    new index,
        Float:vx,
        Float:vy,
        Float:vz,
        vw,
        int,
        Float:fHealth;

    if((index = IsValidVehicle(vehicleid)) != -1)
    {
		GetVehicleHealth(vehicleid, fHealth);
        if(IsValidFireVehicle(pvData[index][cVeh]) && fHealth <= 350.0)
        {
            if(FactionMember_GetCount(3, true) > 0)
            { 
                GetVehiclePos(pvData[index][cVeh], vx, vy, vz);
                vw = GetVehicleVirtualWorld(pvData[index][cVeh]);
                int = GetVehicleInterior(pvData[index][cVeh]);
                Fire_Create(18690, vx, vy, vz, int, vw);
            }
        }
    }
}

CMD:bakar(playerid, params[])
{
    new userid;

    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

    if(sscanf(params, "u", userid))
        return Servers(playerid, "/bakar [playerid/PartOfName]");

    if(userid == INVALID_PLAYER_ID)
        return Error(playerid, "You have specified an invalid player.");

    new Float:x, Float:y, Float:z, vw, int;
    GetPlayerPos(userid, x, y, z);
    vw = GetPlayerVirtualWorld(userid);
    int = GetPlayerInterior(userid);
    SetPlayerHealthEx(userid, 0);
    CreateExplosionEx(x, y, z);
    Fire_Create(18690, x, y, z, int, vw);
    return 1;
}
CMD:nearestfire(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

    new
        id = -1;

    if((id = Fire_Nearest(playerid)) != -1) Servers(playerid, "You are standing near fire ID: %d.", id);
    else Servers(playerid, "Kamu tidak berada didekat api apapun!");
    return 1;
}

CMD:destroyfire(playerid, params[])
{
    static
        id;

    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

    if(sscanf(params, "d", id))
       return Servers(playerid, "/destroyfire [fireid]");

    if(!Fire_IsExists(id))
        return Error(playerid, "ID Fire yang kamu input tidak terdaftar!");

    Fire_Delete(id);
    Servers(playerid, "You remove fire id %d", id);
    return 1;
}

CMD:bakarbizz(playerid, params[])
{
    static
        bid;

    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);

    if(sscanf(params, "d", bid))
        return Usage(playerid, "/bakarbizz [bizzid]");

    if((bid < 0 || bid >= MAX_BISNIS))
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Bisnis, bid)) return Error(playerid, "The bisnis you specified ID of doesn't exist.");

    CreateExplosionEx(bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]);
    Fire_Create(18690, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0, 0);

    SendFactionMessage(3, COLOR_HOSPITAL, "{00FFFF}[ALARM] {FFFFFF}%s Business alarm is triggered, business is on fire", bData[bid][bName]);
    return 1;
}