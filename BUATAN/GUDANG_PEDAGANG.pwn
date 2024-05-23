#define MAX_PEDAGANG 10
#define MAX_PDG_INT 7000

#include <YSI_Coding\y_hooks>

enum pedaganginfo
{
    pdgType,
    Float:pdgPosX,
    Float:pdgPosY,
    Float:pdgPosZ,
    pdgInt,
    pdgGandum,
    pdgDaging,
    pdgSusuolah,
    pdgBurger,
    pdgRoti,
    pdgSteak,
    pdgMilk,
    Text3D:pdgLabel,
    pdgPickup,
    STREAMER_TAG_OBJECT:pdgObject,
    STREAMER_TAG_AREA:pdgAmbilarea
};

new pdgDATA[MAX_PEDAGANG][pedaganginfo],
    Iterator: Pedagang<MAX_PEDAGANG>;

/*Pedagang_Delete(pid)
{
    if(IsValidDynamic3DTextLabel(pdgDATA[pid][pdgLabel]))
        DestroyDynamic3DTextLabel(pdgDATA[pid][pdgLabel]);

    if(IsValidDynamicPickup(pdgDATA[pid][pdgPickup]))
        DestroyDynamicPickup(pdgDATA[pid][pdgPickup]);

    if(IsValidDynamicObject(pdgDATA[pid][pdgObject]))
        DestroyDynamicObject(pdgDATA[pid][pdgObject]);

    if(IsValidDynamicArea(pdgDATA[pid][pdgAmbilarea]))
        DestroyDynamicArea(pdgDATA[pid][pdgAmbilarea]);
}*/

Pedagang_Refresh(pid)
{
    if(pid != -1)
    {
        if(IsValidDynamic3DTextLabel(pdgDATA[pid][pdgLabel]))
            DestroyDynamic3DTextLabel(pdgDATA[pid][pdgLabel]);

        if(IsValidDynamicPickup(pdgDATA[pid][pdgPickup]))
            DestroyDynamicPickup(pdgDATA[pid][pdgPickup]);

        if(IsValidDynamicObject(pdgDATA[pid][pdgObject]))
            DestroyDynamicObject(pdgDATA[pid][pdgObject]);

        if(IsValidDynamicArea(pdgDATA[pid][pdgAmbilarea]))
            DestroyDynamicArea(pdgDATA[pid][pdgAmbilarea]);

        static
        string[255];
        
        new type[128];
        if(pdgDATA[pid][pdgType] == 1)
        {
            type= "GUDANG PEDAGANG";
        }
        else
        {
            type= "Unknown";
        }

        format(string, sizeof(string), "[ID: %d]\nGunakan Y"WHITE_E"' Untuk Mengakses", pid, type);
        pdgDATA[pid][pdgLabel] = CreateDynamic3DTextLabel(string, COLOR_BLUE, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]+0.5, 2.5);
        pdgDATA[pid][pdgObject] = CreateDynamicObject(1316, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]-1, 0.0, 0.0, 0.0, 0, pdgDATA[pid][pdgInt], -1, 15.00, 15.00);
        SetDynamicObjectMaterial(pdgDATA[pid][pdgObject], 0, 18646, "matcolours", "white", 0x9900FF00);
        //pdgDATA[pid][pdgAmbilarea] = CreateDynamicCircle(pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], 1.0, 0, pdgDATA[pid][pdgInt], -1);
    }
    return 1;
}

/*Pedagang_Refresh(playerid, pid)
{
    if(pid != -1)
    {
        Pedagang_Delete(pid);

        static
        string[255];
        
        new type[128];
        if(pdgDATA[pid][pdgType] == 1)
        {
            type= "GUDANG PEDAGANG";
        }
        else
        {
            type= "Unknown";
        }

        if(pData[playerid][pFaction] == 5)
        {
            if(!pData[playerid][pOndutysacf])
            {
                format(string, sizeof(string), "[ID: %d]", pid, type);
                pdgDATA[pid][pdgLabel] = CreateDynamic3DTextLabel(string, COLOR_BLUE, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]+0.5, 2.5);
                pdgDATA[pid][pdgObject] = CreateDynamicObject(1316, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]-1, 0.0, 0.0, 0.0, 0, pdgDATA[pid][pdgInt], -1, 15.00, 15.00);
                SetDynamicObjectMaterial(pdgDATA[pid][pdgObject], 0, 18646, "matcolours", "white", 0x9900FF00);
                pdgDATA[pid][pdgAmbilarea] = CreateDynamicCircle(pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], 1.0, 0, pdgDATA[pid][pdgInt], -1);
            }
        }
    }
    return 1;
}*/

function LoadPedagang()
{
    static pid;
    
    new rows = cache_num_rows();
    if(rows)
    {
        for(new i; i < rows; i++)
        {
            cache_get_value_name_int(i, "id", pid);
            cache_get_value_name_int(i, "type", pdgDATA[pid][pdgType]);
            cache_get_value_name_float(i, "posx", pdgDATA[pid][pdgPosX]);
            cache_get_value_name_float(i, "posy", pdgDATA[pid][pdgPosY]);
            cache_get_value_name_float(i, "posz", pdgDATA[pid][pdgPosZ]);
            cache_get_value_name_int(i, "interior", pdgDATA[pid][pdgInt]);
            cache_get_value_name_int(i, "gandum", pdgDATA[pid][pdgGandum]);
            cache_get_value_name_int(i, "daging", pdgDATA[pid][pdgDaging]);
            cache_get_value_name_int(i, "susuolah", pdgDATA[pid][pdgSusuolah]);
            cache_get_value_name_int(i, "burger", pdgDATA[pid][pdgBurger]);
            cache_get_value_name_int(i, "roti", pdgDATA[pid][pdgRoti]);
            cache_get_value_name_int(i, "steak", pdgDATA[pid][pdgSteak]);
            cache_get_value_name_int(i, "milk", pdgDATA[pid][pdgMilk]);
            Pedagang_Refresh(pid);
            Iter_Add(Pedagang, pid);
        }
        printf("[Dynamic Gudang Pedagang] Number of Loaded: %d.", rows);
    }
}

Pedagang_Save(pid)
{
    new cQuery[512];
    format(cQuery, sizeof(cQuery), "UPDATE pedagang SET type='%d', posx='%f', posy='%f', posz='%f', interior='%d', gandum='%d', daging='%d', susuolah='%d', burger='%d', roti='%d', steak='%d', milk='%d' WHERE id='%d'",
    pdgDATA[pid][pdgType],
    pdgDATA[pid][pdgPosX],
    pdgDATA[pid][pdgPosY],
    pdgDATA[pid][pdgPosZ],
    pdgDATA[pid][pdgInt],
    pdgDATA[pid][pdgGandum],
    pdgDATA[pid][pdgDaging],
    pdgDATA[pid][pdgSusuolah],
    pdgDATA[pid][pdgBurger],
    pdgDATA[pid][pdgRoti],
    pdgDATA[pid][pdgSteak],
    pdgDATA[pid][pdgMilk],
    pid
    );
    return mysql_tquery(g_SQL, cQuery);
}

//Dynamic Locker System
CMD:pedagangcreate(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);
    
    new pid = Iter_Free(Pedagang), query[128];
    if(pid == -1) return Error(playerid, "You cant create more locker!");
    new type;
    if(sscanf(params, "d", type)) return Usage(playerid, "/pedagangcreate [type, 1.SAPEDAGANG]");
    
    if(type < 1 || type > 1) return Error(playerid, "Invapid type.");
    
    GetPlayerPos(playerid, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]);
    pdgDATA[pid][pdgInt] = GetPlayerInterior(playerid);
    pdgDATA[pid][pdgType] = type;
    Pedagang_Refresh(pid);
    Iter_Add(Pedagang, pid);

    mysql_format(g_SQL, query, sizeof(query), "INSERT INTO pedagang SET id='%d', type='%d', posx='%f', posy='%f', posz='%f'", pid, pdgDATA[pid][pdgType], pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]);
    mysql_tquery(g_SQL, query, "OnLockerCreated", "i", pid);
    return 1;
}

function OnPedagangCreated(pid)
{
    Pedagang_Save(pid);
    return 1;
}

CMD:gotogudang(playerid, params[])
{
    new pid;
    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
        
    if(sscanf(params, "d", pid))
        return Usage(playerid, "/gotogudang [id]");
    if(!Iter_Contains(Pedagang, pid)) return Error(playerid, "The locker you specified ID of doesn't exist.");
    SetPlayerPosition(playerid, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ], 2.0);
    SetPlayerInterior(playerid, pdgDATA[pid][pdgInt]);
    SetPlayerVirtualWorld(playerid, 0);
    Servers(playerid, "You has teleport to locker id %d", pid);
    return 1;
}

CMD:editpedagang(playerid, params[])
{
    static
        pid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", pid, type, string))
    {
        Usage(playerid, "/editpedagang [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, type, delete");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} gandum, daging, susuolah, burger, roti, steak, milk");
        return 1;
    }
    if((pid < 0 || pid >= MAX_PEDAGANG))
        return Error(playerid, "You have specified an invapid ID.");
    if(!Iter_Contains(Pedagang, pid)) return Error(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
        GetPlayerPos(playerid, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]);
        pdgDATA[pid][pdgInt] = GetPlayerInterior(playerid);
        Locker_Save(pid);
        Pedagang_Refresh(pid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of locker ID: %d.", pData[playerid][pAdminname], pid);
    }
    else if(!strcmp(type, "type", true))
    {
        new tipe;

        if(sscanf(string, "d", tipe))
            return Usage(playerid, "/editlocker [id] [type] [type, 1.SAPEDAGANG]");

        if(tipe < 1 || tipe > 1)
            return Error(playerid, "You must specify at least 1 - 5.");

        pdgDATA[pid][pdgType] = tipe;
        Locker_Save(pid);
        Pedagang_Refresh(pid);

        SendAdminMessage(COLOR_RED, "%s has set locker ID: %d to type id faction %d.", pData[playerid][pAdminname], pid, tipe);
    }
    else if(!strcmp(type, "delete", true))
    {
        new query[128];
        DestroyDynamic3DTextLabel(pdgDATA[pid][pdgLabel]);
        DestroyDynamicPickup(pdgDATA[pid][pdgPickup]);
        pdgDATA[pid][pdgPosX] = 0;
        pdgDATA[pid][pdgPosY] = 0;
        pdgDATA[pid][pdgPosZ] = 0;
        pdgDATA[pid][pdgInt] = 0;
        pdgDATA[pid][pdgLabel] = Text3D: INVALID_3DTEXT_ID;
        pdgDATA[pid][pdgPickup] = -1;
        Iter_Remove(Pedagang, pid);
        mysql_format(g_SQL, query, sizeof(query), "DELETE FROM pedagang WHERE id=%d", pid);
        mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete locker ID: %d.", pData[playerid][pAdminname], pid);
    }
    else if(!strcmp(type, "gandum", true))
    {
        new stok;

        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/editpedagang [id] [gandum] [Ammount]");

        pdgDATA[pid][pdgGandum] = stok;
        
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "UPDATE pedagang SET gandum='%d' WHERE id='%d'", pdgDATA[pid][pdgGandum], pid);
        mysql_tquery(g_SQL, query);

        //Pedagang_Refresh(pid);
        Pedagang_Refresh(pid);
        SendAdminMessage(COLOR_RED, "%s stock gandum di gudang pedagang: %d to %d.", pData[playerid][pAdminname], pid, stok);
    }
    else if(!strcmp(type, "daging", true))
    {
        new stok;

        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/editpedagang [id] [daging] [Ammount]");

        pdgDATA[pid][pdgDaging] = stok;
        
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "UPDATE pedagang SET daging='%d' WHERE id='%d'", pdgDATA[pid][pdgDaging], pid);
        mysql_tquery(g_SQL, query);

        //Pedagang_Refresh(pid);
        Pedagang_Refresh(pid);
        SendAdminMessage(COLOR_RED, "%s stock daging di gudang pedagang: %d to %d.", pData[playerid][pAdminname], pid, stok);
    }
    else if(!strcmp(type, "susuolah", true))
    {
        new stok;

        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/editpedagang [id] [susuolah] [Ammount]");

        pdgDATA[pid][pdgSusuolah] = stok;
        
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "UPDATE pedagang SET susuolah='%d' WHERE id='%d'", pdgDATA[pid][pdgSusuolah], pid);
        mysql_tquery(g_SQL, query);

        //Pedagang_Refresh(pid);
        Pedagang_Refresh(pid);
        SendAdminMessage(COLOR_RED, "%s stock susuolah di gudang pedagang: %d to %d.", pData[playerid][pAdminname], pid, stok);
    }
    else if(!strcmp(type, "burger", true))
    {
        new stok;

        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/editpedagang [id] [burger] [Ammount]");

        pdgDATA[pid][pdgBurger] = stok;
        
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "UPDATE pedagang SET burger='%d' WHERE id='%d'", pdgDATA[pid][pdgBurger], pid);
        mysql_tquery(g_SQL, query);

        //Pedagang_Refresh(pid);
        Pedagang_Refresh(pid);
        SendAdminMessage(COLOR_RED, "%s stock burger di gudang pedagang: %d to %d.", pData[playerid][pAdminname], pid, stok);
    }
    else if(!strcmp(type, "roti", true))
    {
        new stok;

        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/editpedagang [id] [roti] [Ammount]");

        pdgDATA[pid][pdgRoti] = stok;
        
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "UPDATE pedagang SET roti='%d' WHERE id='%d'", pdgDATA[pid][pdgRoti], pid);
        mysql_tquery(g_SQL, query);

        //Pedagang_Refresh(pid);
        Pedagang_Refresh(pid);
        SendAdminMessage(COLOR_RED, "%s stock roti di gudang pedagang: %d to %d.", pData[playerid][pAdminname], pid, stok);
    }
    else if(!strcmp(type, "steak", true))
    {
        new stok;

        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/editpedagang [id] [steak] [Ammount]");

        pdgDATA[pid][pdgSteak] = stok;
        
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "UPDATE pedagang SET steak='%d' WHERE id='%d'", pdgDATA[pid][pdgSteak], pid);
        mysql_tquery(g_SQL, query);

        //Pedagang_Refresh(pid);
        Pedagang_Refresh(pid);
        SendAdminMessage(COLOR_RED, "%s stock steak di gudang pedagang: %d to %d.", pData[playerid][pAdminname], pid, stok);
    }
    else if(!strcmp(type, "milk", true))
    {
        new stok;

        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/editpedagang [id] [milk] [Ammount]");

        pdgDATA[pid][pdgMilk] = stok;
        
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "UPDATE pedagang SET milk='%d' WHERE id='%d'", pdgDATA[pid][pdgMilk], pid);
        mysql_tquery(g_SQL, query);

        //Pedagang_Refresh(pid);
        Pedagang_Refresh(pid);
        SendAdminMessage(COLOR_RED, "%s stock milk di gudang pedagang: %d to %d.", pData[playerid][pAdminname], pid, stok);
    }
    return 1;
}
