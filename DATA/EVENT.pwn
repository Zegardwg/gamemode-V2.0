// EVENT SYSTEM
new EventCreated = 0, EventStarted = 0;

new LastInterior[MAX_PLAYERS], LastVW[MAX_PLAYERS], Float:LastposX[MAX_PLAYERS], Float:LastposY[MAX_PLAYERS], Float:LastposZ[MAX_PLAYERS];
new Float: RedX, Float: RedY, Float: RedZ, EventInt, EventWorld;
new Float: BlueX, Float: BlueY, Float: BlueZ;
new EventHP = 100, EventArmour = 0, EventLocked = 0;
new EventWeapon1, EventWeapon2, EventWeapon3, EventWeapon4, EventWeapon5;
new BlueTeam = 0, RedTeam = 0;
new IsAtEvent[MAX_PLAYERS];


CMD:createevent(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(EventCreated >= 1)
        return Error(playerid, "Event sudah dibuat");

    Info(playerid, "Event berhasil dibuat, gunakan /setevent");
    SendAdminMessage(COLOR_RED, "%s telah membuat event", pData[playerid][pAdminname]);
    EventCreated = 1;
    EventLocked = 1;
    return 1;
}

CMD:joinevent(playerid, params[])
{
    if(EventCreated < 1)
        return Error(playerid, "Belum ada event yang dibuat");

    if(EventLocked == 1)
        return Error(playerid, "Event belum dibuka");

    if(BlueX == 0.0 && BlueY == 0.0 && BlueZ == 0.0)
        return Error(playerid, "Posisi Tim Biru belum dibuat");

    if(RedX == 0.0 && RedY == 0.0 && RedZ == 0.0)
        return Error(playerid, "Posisi Tim Merah belum dibuat");

    if(IsAtEvent[playerid] == 1)
        return Error(playerid, "Anda sudah berada di Event");

    if(IsPlayerInAnyVehicle(playerid))
        return Error(playerid, "Harap turun dari kendaraan sebelum bergabung kedalam Event");

    if(EventStarted == 1)
        return Error(playerid, "Event Sedang dimulai");

    if(pData[playerid][pSideJob] > 1)
        return Error(playerid, "Selesaikan terlebih dahulu Pekerjaan mu");

    if(pData[playerid][pOnDuty] > 1)
        return Error(playerid, "Harap off duty terlebih dahulu");

    if(pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
        return Error(playerid, "You can't do at this moment.");

    if(IsPlayerInAnyVehicle(playerid))
        RemovePlayerFromVehicle(playerid);

    UpdatePlayerData(playerid);
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y,z);
    LastVW[playerid] = GetPlayerVirtualWorld(playerid);
    LastInterior[playerid] = GetPlayerInterior(playerid);
    LastposX[playerid] = x;
    LastposY[playerid] = y;
    LastposZ[playerid] = z+0.5;

    new rand = random(2);
    if(rand == 0)
    {
        SetPlayerTeam(playerid, 1);
        SetPlayerColor(playerid, COLOR_RED);
        SetPlayerPos(playerid, RedX, RedY, RedZ);
        SetPlayerVirtualWorld(playerid, EventWorld);
        SetPlayerInterior(playerid, EventInt);
        SetPlayerHealthEx(playerid, EventHP);
        SetPlayerArmourEx(playerid, EventArmour);

        ResetPlayerWeapons(playerid);
        GivePlayerWeaponEx(playerid, EventWeapon1, 150);
        GivePlayerWeaponEx(playerid, EventWeapon2, 150);
        GivePlayerWeaponEx(playerid, EventWeapon3, 150);
        GivePlayerWeaponEx(playerid, EventWeapon4, 150);
        GivePlayerWeaponEx(playerid, EventWeapon5, 150);

        Servers(playerid, "Berhasil bergabung kedalam "RED_E"Team Merah"WHITE_E", Harap tunggu Admin memulai Event");
        IsAtEvent[playerid] = 1;
        RedTeam += 1;
    }
    if(rand == 1)
    {
        if(GetPlayerTeam(playerid) == 2)
            return Error(playerid, "Anda sudah bergabung ke Tim ini");

        SetPlayerTeam(playerid, 2);
        SetPlayerColor(playerid, COLOR_BLUE);
        SetPlayerPos(playerid, BlueX, BlueY, BlueZ);
        IsAtEvent[playerid] = 1;
        SetPlayerVirtualWorld(playerid, EventWorld);
        SetPlayerInterior(playerid, EventInt);
        SetPlayerHealthEx(playerid, EventHP);
        SetPlayerArmourEx(playerid, EventArmour);

        ResetPlayerWeapons(playerid);
        GivePlayerWeaponEx(playerid, EventWeapon1, 150);
        GivePlayerWeaponEx(playerid, EventWeapon2, 150);
        GivePlayerWeaponEx(playerid, EventWeapon3, 150);
        GivePlayerWeaponEx(playerid, EventWeapon4, 150);
        GivePlayerWeaponEx(playerid, EventWeapon5, 150);

        Servers(playerid, "Berhasil bergabung kedalam "BLUE_E"Team Biru"WHITE_E", Harap tunggu Admin memulai Event");
        IsAtEvent[playerid] = 1;
        BlueTeam += 1;
    }
    return 1;
}

CMD:leaveevent(playerid, params[])
{
    if(IsAtEvent[playerid] == 0)
        return Error(playerid, "Anda tidak berada di Event");

    if(IsAtEvent[playerid] == 1 && EventStarted == 1)
        return Error(playerid, "Anda tidak dapat keluar saat Match Dimulai");

    Info(playerid, "Harap tunggu 3 detik untuk keluar dari event");
    LeaveEvent(playerid);
    return 1;
}

CMD:setevent(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(EventCreated < 1)
        return Error(playerid, "Belum ada Event yang dibuat");
        
    static
     name[64],
      string[128];

    if(sscanf(params, "s[64]S()[128]", name, string))
    {
        Usage(playerid, "/setevent [name] [id/amount]");
        Names(playerid, "[health], [armor], [redpos], [bluepos], [lock], [announ], [start], [end]");
        Names(playerid, "[weapon1], [weapon2], [weapon3], [weapon4], [weapon5]");
        return 1;
    }
    if(!strcmp(name, "health", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new health;
        if(sscanf(string, "d", health))
            return Usage(playerid, "/setevent [health] [amount]");

        if(health < 0 || health > 95)
            return Error(playerid, "Health amount only 0 - 95");
        
        EventHP = health;
        SendAdminMessage(COLOR_RED, "%s set Health tdm to %d.", pData[playerid][pAdminname], health);
    }
    if(!strcmp(name, "armor", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new armor;
        if(sscanf(string, "d", armor))
            return Usage(playerid, "/setevent [armor] [amount]");

        if(armor < 0 || armor > 95)
            return Error(playerid, "Armor amount only 0 - 95");

        EventArmour = armor;
        SendAdminMessage(COLOR_RED, "%s set Armour tdm to %d.", pData[playerid][pAdminname], armor);
    }
    if(!strcmp(name, "redpos", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        RedX = x;
        RedY = y;
        RedZ = z+0.5;
        EventInt = GetPlayerInterior(playerid);
        EventWorld = GetPlayerVirtualWorld(playerid);
        SendAdminMessage(COLOR_RED, "%s set red pos to %0.2f %0.2f %0.2f .", pData[playerid][pAdminname], RedX, RedY, RedZ);
    }
    if(!strcmp(name, "bluepos", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        BlueX = x;
        BlueY = y;
        BlueZ = z+0.5;
        EventInt = GetPlayerInterior(playerid);
        EventWorld = GetPlayerVirtualWorld(playerid);
        SendAdminMessage(COLOR_RED, "%s set blue pos to %0.2f %0.2f %0.2f .", pData[playerid][pAdminname], BlueX, BlueY, BlueZ);
    }
    if(!strcmp(name, "lock", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        if(EventStarted == 1)
            return Error(playerid, "Event sudah dimulai dan otomatis terkunci");

        if(EventLocked == 1)
        {
            EventLocked = 0;
            Servers(playerid, "Event berhasil dibuka!");
            SendAdminMessage(COLOR_RED, "%s telah membuka kunci event");
        }
        else
        {
            EventLocked = 1;
            Servers(playerid, "Event berhasil dikunci!");
            SendAdminMessage(COLOR_RED, "%s telah mengunci event");
        }
    }
    if(!strcmp(name, "announ", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        if(BlueX == 0.0 && BlueY == 0.0 && BlueZ == 0.0)
            return Error(playerid, "Posisi Tim Biru belum dibuat");

        if(RedX == 0.0 && RedY == 0.0 && RedZ == 0.0)
            return Error(playerid, "Posisi Tim Merah belum dibuat");

        if(EventLocked == 1)
            return Error(playerid, "Kamu harus membuka kunci event terlebih dahulu");

        if(EventStarted == 1)
            return Error(playerid, "Event sudah dimulai");

        SendClientMessageToAll(-1, ""YELLOW_E"[EVENT]{ffffff} Event dibuka! /joinevent untuk masuk!");
    }
    if(!strcmp(name, "start", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        if(EventStarted == 1)
            return Error(playerid, "Event sudah dimulai");

        Count = 6;
        countTimer = SetTimer("pCountDown", 1000, 1);
        EventStarted = 1;
        EventLocked = 1;

        foreach(new ii : Player)
        {
            if(IsAtEvent[ii] == 1)
            {
                showCD[ii] = 1;
            }
        }
    }
    if(!strcmp(name, "end", true))
    {
        if(EventCreated <= 0)
            return Error(playerid, "Belum ada Event yang dibuat");

        EventStarted = 0;
        EventInt = 0;
        EventWorld = 0;
        EventHP = 100;
        EventArmour = 0;
        EventLocked = 1;
        EventWeapon1 = 0;
        EventWeapon2 = 0;
        EventWeapon3 = 0;
        EventWeapon4 = 0;
        EventWeapon5 = 0;
        BlueX = 0;
        BlueY = 0;
        BlueZ = 0;
        RedX = 0;
        RedY = 0;
        RedZ = 0;
        RedTeam = 0;
        BlueTeam = 0;
        EventCreated = 0;
        SendAdminMessage(COLOR_RED, "%s telah megakhiri event", pData[playerid][pAdminname]);
        foreach(new ii : Player)
        {
            if(IsAtEvent[ii] == 1)
            {
                ResetPlayerWeaponsEx(ii);
                SetPlayerPos(ii, LastposX[ii], LastposY[ii], LastposZ[ii]);
                SetPlayerInterior(ii, LastInterior[ii]);
                SetPlayerVirtualWorld(ii, LastVW[ii]);
                SetPlayerColor(ii, COLOR_WHITE);
                SetPlayerTeam(ii, 0);
                IsAtEvent[ii] = 0;
            }
        }
        Servers(playerid, "Berhasil mengakhiri Event");
    }
    if(!strcmp(name, "weapon1", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/setevent [weapon1] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon1 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 1 tdm to %s.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    if(!strcmp(name, "weapon2", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/setevent [weapon2] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon2 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 2 tdm to %s.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    if(!strcmp(name, "weapon3", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/setevent [weapon3] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon3 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 3 tdm to %s.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    if(!strcmp(name, "weapon4", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/setevent [weapon4] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon4 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 4 tdm to %s.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    if(!strcmp(name, "weapon5", true))
    {
        if(EventCreated < 1)
            return Error(playerid, "Belum ada Event yang dibuat");

        new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/setevent [weapon5] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon5 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 5 tdm to %s.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    return 1;
}

LeaveEvent(playerid)
{
    IsAtEvent[playerid] = 0;
    pData[playerid][pInjured] = 0;
    pData[playerid][pHospital] = 0;

    SetPlayerTeam(playerid, 0);
    SetPlayerColor(playerid, COLOR_WHITE);
    SetPlayerVirtualWorld(playerid, LastVW[playerid]);
    SetPlayerInterior(playerid, LastInterior[playerid]);
    SetPlayerHealthEx(playerid, 100.0);

    ResetPlayerWeaponsEx(playerid);
    ClearAnimations(playerid);

    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
    SetTimerEx("LastPosEvent", 2000, false, "i", playerid);
    return 1;
}

function LastPosEvent(playerid)
{
    Servers(playerid, "Kamu telah keluar dari event");
    SetPlayerPos(playerid, LastposX[playerid], LastposY[playerid]+5.0, LastposZ[playerid]);
}
/*
-------[ENUM EVENT]--------



// EVENT SYSTEM
new EventCreated = 0, EventStarted = 0;

new LastInterior[MAX_PLAYERS], LastVW[MAX_PLAYERS], Float:LastposX[MAX_PLAYERS], Float:LastposY[MAX_PLAYERS], Float:LastposZ[MAX_PLAYERS];
new Float: RedX, Float: RedY, Float: RedZ, EventInt, EventWorld;
new Float: BlueX, Float: BlueY, Float: BlueZ;

new EventHP = 100, EventArmour = 0, EventLocked = 0;
new EventWeapon1, EventWeapon2, EventWeapon3, EventWeapon4, EventWeapon5;

new BlueTeam = 0, RedTeam = 0;
new IsAtEvent[MAX_PLAYERS];






--------[ONPLAYER DISCONNECT]-------------


        if(IsAtEvent[playerid] == 1)
        {
            SetPlayerPos(playerid, LastposX[playerid], LastposY[playerid], LastposZ[playerid]);
            SetPlayerVirtualWorld(playerid, LastVW[playerid]);
            SetPlayerInterior(playerid, LastInterior[playerid]);
            SetPlayerHealthEx(playerid, 100.0);

            pData[playerid][pInjured] = 0;
            pData[playerid][pHospital] = 0;
            pData[playerid][pSick] = 0;
            IsAtEvent[playerid] = 0;

            pData[playerid][pPosX] = LastposX[playerid];
            pData[playerid][pPosY] = LastposY[playerid];
            pData[playerid][pPosZ] = LastposZ[playerid];
            pData[playerid][pInt] = LastInterior[playerid];
            pData[playerid][pWorld] = LastVW[playerid];

            SetPlayerTeam(playerid, 0);
            SetPlayerColor(playerid, COLOR_WHITE);
            ResetPlayerWeaponsEx(playerid);
            ClearAnimations(playerid);
        }



-------[ONPLAYER DEATH]---------


    if(IsAtEvent[playerid] >= 1)
    {
        LeaveEvent(playerid);
    }

*/