enum E_PEMOTONG
{
    STREAMER_TAG_MAP_ICON:LockerMap,
    STREAMER_TAG_MAP_ICON:TempatKerja,
    STREAMER_TAG_MAP_ICON:AmbilMap,
    STREAMER_TAG_AREA:AmbilAyam,
    STREAMER_TAG_AREA:AmbilAyamHidup1,
    STREAMER_TAG_AREA:AmbilAyamHidup2,
    STREAMER_TAG_AREA:AmbilAyamHidup3,
    STREAMER_TAG_AREA:AmbilAyamHidup4,
    STREAMER_TAG_AREA:AmbilAyamHidup5,
    STREAMER_TAG_CP:PotongAyam,
    STREAMER_TAG_CP:PotongAyam2,
    STREAMER_TAG_CP:PotongAyam3,
    STREAMER_TAG_CP:PackingAyam,
    STREAMER_TAG_CP:PackingAyam2
}
new PemotongArea[MAX_PLAYERS][E_PEMOTONG];
new ayam1;
new ayam2;
new ayam3;
new ayam4;
new ayam5;

DeletePemotongCP(playerid)
{
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyam]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyam]);
        PemotongArea[playerid][AmbilAyam] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup1]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup1]);
        PemotongArea[playerid][AmbilAyamHidup1] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup2]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup2]);
        PemotongArea[playerid][AmbilAyamHidup2] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup3]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup3]);
        PemotongArea[playerid][AmbilAyamHidup3] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup4]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup4]);
        PemotongArea[playerid][AmbilAyamHidup4] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup5]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup5]);
        PemotongArea[playerid][AmbilAyamHidup5] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicCP(PemotongArea[playerid][PotongAyam]))
    {
        DestroyDynamicCP(PemotongArea[playerid][PotongAyam]);
        PemotongArea[playerid][PotongAyam] = STREAMER_TAG_CP: -1;
    }
    if(IsValidDynamicCP(PemotongArea[playerid][PotongAyam2]))
    {
        DestroyDynamicCP(PemotongArea[playerid][PotongAyam2]);
        PemotongArea[playerid][PotongAyam2] = STREAMER_TAG_CP: -1;
    }
    if(IsValidDynamicCP(PemotongArea[playerid][PotongAyam3]))
    {
        DestroyDynamicCP(PemotongArea[playerid][PotongAyam3]);
        PemotongArea[playerid][PotongAyam3] = STREAMER_TAG_CP: -1;
    }
    if(IsValidDynamicCP(PemotongArea[playerid][PackingAyam]))
    {
        DestroyDynamicCP(PemotongArea[playerid][PackingAyam]);
        PemotongArea[playerid][PackingAyam] = STREAMER_TAG_CP: -1;
    }
    if(IsValidDynamicCP(PemotongArea[playerid][PackingAyam2]))
    {
        DestroyDynamicCP(PemotongArea[playerid][PackingAyam2]);
        PemotongArea[playerid][PackingAyam2] = STREAMER_TAG_CP: -1;
    }
    if(IsValidDynamicMapIcon(PemotongArea[playerid][LockerMap]))
    {
        DestroyDynamicMapIcon(PemotongArea[playerid][LockerMap]);
        PemotongArea[playerid][LockerMap] = STREAMER_TAG_MAP_ICON: -1;
    }
    if(IsValidDynamicMapIcon(PemotongArea[playerid][TempatKerja]))
    {
        DestroyDynamicMapIcon(PemotongArea[playerid][TempatKerja]);
        PemotongArea[playerid][TempatKerja] = STREAMER_TAG_MAP_ICON: -1;
    }
    if(IsValidDynamicMapIcon(PemotongArea[playerid][AmbilMap]))
    {
        DestroyDynamicMapIcon(PemotongArea[playerid][AmbilMap]);
        PemotongArea[playerid][AmbilMap] = STREAMER_TAG_MAP_ICON: -1;
    }
}
destroyayam(playerid)
{
    DestroyDynamicObject(ayam1);
    DestroyDynamicObject(ayam2);
    DestroyDynamicObject(ayam3);
    DestroyDynamicObject(ayam4);
    DestroyDynamicObject(ayam5);
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup1]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup1]);
        PemotongArea[playerid][AmbilAyamHidup1] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup2]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup2]);
        PemotongArea[playerid][AmbilAyamHidup2] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup3]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup3]);
        PemotongArea[playerid][AmbilAyamHidup3] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup4]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup4]);
        PemotongArea[playerid][AmbilAyamHidup4] = STREAMER_TAG_AREA: -1;
    }
    if(IsValidDynamicArea(PemotongArea[playerid][AmbilAyamHidup5]))
    {
        DestroyDynamicArea(PemotongArea[playerid][AmbilAyamHidup5]);
        PemotongArea[playerid][AmbilAyamHidup5] = STREAMER_TAG_AREA: -1;
    }
    return 1;
}
RefreshJobPemotong(playerid)
{
    DeletePemotongCP(playerid);

    if(pData[playerid][pJob] == 24)
    {
        PemotongArea[playerid][AmbilAyam] = CreateDynamicCircle(-1422.421142,-967.581909, 1.0, -1, -1, playerid);
        PemotongArea[playerid][PotongAyam] = CreateDynamicCP(-1113.361328,-1660.300415,76.378242, 2.0, -1, -1, playerid, 30.0);
        PemotongArea[playerid][PotongAyam2] = CreateDynamicCP(-1120.229736,-1660.261108,76.378242, 2.0, -1, -1, playerid, 30.0);
        PemotongArea[playerid][PotongAyam3] = CreateDynamicCP(-1107.819091,-1659.510375,76.378242, 2.0, -1, -1, playerid, 30.0);
        PemotongArea[playerid][PackingAyam] = CreateDynamicCP(-1115.366333,-1653.926269,76.388252, 2.0, -1, -1, playerid, 30.0);
        PemotongArea[playerid][PackingAyam2] = CreateDynamicCP(-1115.089233,-1657.203491,76.388252, 2.0, -1, -1, playerid, 30.0);
        PemotongArea[playerid][AmbilMap] = CreateDynamicMapIcon(-1113.361328,-1660.300415,76.378242, 14, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
        PemotongArea[playerid][TempatKerja] = CreateDynamicMapIcon(-1422.421142,-967.581909,200.775970, 14, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
    }
    return 1;
}
function AyamSpawn(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 24)
    {
        new rand = RandomEx(1,4);
        if(rand == 1)
        {
            pData[playerid][ayamcp] = 1;
            destroyayam(playerid);
            PemotongArea[playerid][AmbilAyamHidup1] = CreateDynamicCircle(-1433.753784,-952.540039, 1.0, -1, -1, playerid);
            ayam1 = CreateDynamicObject(19078, -1426.8801,-949.8837,201.0938-0.8, 0.0, 0.0, 0.0, 0, 0, -1, 50.00, 50.00);
        }
        else if(rand == 2)
        {
            pData[playerid][ayamcp] = 2;
            destroyayam(playerid);
            PemotongArea[playerid][AmbilAyamHidup2] = CreateDynamicCircle(-1424.033203,-953.324096, 1.0, -1, -1, playerid);
            ayam2 = CreateDynamicObject(19078, -1431.3004,-948.3753,201.0938-0.8, 0.0, 0.0, 0.0, 0, 0, -1, 50.00, 50.00);
        }
        else if(rand == 3)
        {
            pData[playerid][ayamcp] = 3;
            destroyayam(playerid);
            PemotongArea[playerid][AmbilAyamHidup3] = CreateDynamicCircle(-1428.262695,-953.159423, 1.0, -1, -1, playerid);
            ayam3 = CreateDynamicObject(19078, -1433.2196,-954.7111,200.9800-0.8, 0.0, 0.0, 0.0, 0, 0, -1, 50.00, 50.00);
        }
        else if(rand == 4)
        {
            pData[playerid][ayamcp] = 4;
            destroyayam(playerid);
            PemotongArea[playerid][AmbilAyamHidup4] = CreateDynamicCircle(-1424.739013,-947.450622, 1.0, -1, -1, playerid);
            ayam4 = CreateDynamicObject(19078, -1424.5692,-949.8381,201.0938-0.8, 0.0, 0.0, 0.0, 0, 0, -1, 50.00, 50.00);
        }
    }
    return 1;
}
CMD:ambilayamdentottrtr(playerid, params[])
{
    if(pData[playerid][pJob] == 24 || pData[playerid][pJob2] == 24)
    {
        if(pData[playerid][pPemotongStatus] == 1) return ErrorMsg(playerid, "Anda Masih Proses Ayam");
        if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
        if(pData[playerid][AmbilAyam] == 10) return ErrorMsg(playerid, "Anda sudah mengambil 10 ayam!!");
        if(pData[playerid][AyamHidup] == 150) return ErrorMsg(playerid, "Anda sudah membawa 150 Ayam Hidup!");
        if(pData[playerid][DutyAmbilAyam] == 0) return ErrorMsg(playerid, "Anda belum izin dengan Jamal!");
        {
            pData[playerid][pPemotongStatus] += 1;
            pData[playerid][ayamcp] = 0;
            ayamjob[playerid] = SetTimerEx("getchicken", 2000, false, "id", playerid);
            ShowProgressbar(playerid, "Mengambil Ayam..", 2);
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
        }
    }
    return 1;
}

CMD:izinayamGen(playerid, params[])
{
    if(pData[playerid][pJob] == 24 || pData[playerid][pJob2] == 24)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -1422.421142,-967.581909,200.775970))
        {
            if(pData[playerid][DutyAmbilAyam] == 1) return ErrorMsg(playerid, "Silahkan selesaikan pekerjaan terlebih dahulu");
            if(pData[playerid][AyamHidup] == 150) return ErrorMsg(playerid, "Anda sudah membawa 150 Ayam Hidup!");
            AyamSpawn(playerid);
            SetPlayerPos(playerid, -1428.316528,-950.212158,201.093750);
            pData[playerid][DutyAmbilAyam] = 1;
            PlayerData[playerid][pPos][0] = -1428.316528,
            PlayerData[playerid][pPos][1] = -950.212158,
            PlayerData[playerid][pPos][2] = 201.093750;
            PlayerData[playerid][pPos][3] = pData[playerid][pPosA];
            InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
            InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
            SetTimerEx("SetPlayerCameraBehindAyam", 2500, false, "i", playerid);
        }
        else return ErrorMsg(playerid, "Kamu Tidak Di Tempat Pengolah Ayam.");
    }
    else ErrorMsg(playerid, "Anda bukan Bekerja Pemotong Ayam.");
    return 1;
}
forward getchicken(playerid);
public getchicken(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 24)
    {
        SuccesMsg(playerid, "Anda telah Mengambil Ayam Hidup.");
        ShowItemBox(playerid, "Ayam Hidup", "Received_1x", 16776, 5);
        pData[playerid][pActivityTime] = 0;
        KillTimer(ayamjob[playerid]);
        pData[playerid][pPemotongStatus] = 0;
        pData[playerid][AyamHidup] += 1;
        pData[playerid][AmbilAyam] += 1;
        pData[playerid][pEnergy] -= 1;
        ClearAnimations(playerid);
        AyamSpawn(playerid);
    }
    return 1;
}

CMD:potongayamdentotkontol(playerid, params[])
{
    if(pData[playerid][pJob] == 24 || pData[playerid][pJob2] == 24)
    {
        if(pData[playerid][pPemotongStatus] == 1) return ErrorMsg(playerid, "Anda Masih potong Ayam");
        if(pData[playerid][AyamPotong] == 50) return ErrorMsg(playerid, "Anda sudah membawa 50 Ayam Potong!");
        if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
        if(pData[playerid][AyamHidup] < 1) return ErrorMsg(playerid, "Kamu Tidak Mengambil Ayam Hidup.");
        {
            pData[playerid][pPemotongStatus] += 1;

            TogglePlayerControllable(playerid, 0);
            ShowProgressbar(playerid, "Memotong Ayam", 7);
            ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
            ayamjob[playerid] = SetTimerEx("frychicken", 7000, false, "id", playerid);
        }
    }
    else return ErrorMsg(playerid, "anda bukan Tukang Ayam!");
    return 1;
}

forward frychicken(playerid);
public frychicken(playerid)
{
    new randjumlah = RandomEx(1, 10), hasilrand = randjumlah, randchance = random(2);

    if(randchance == 0)
    {
        pData[playerid][AyamPotong] += 5;
        pData[playerid][AyamHidup] -= 1;
        TogglePlayerControllable(playerid, 1);
        ShowItemBox(playerid, "Ayam Hidup", "Removed_1x", 16776, 3);
        ShowItemBox(playerid, "Ayam Potong", "Received_5x", 2804, 3);
    }
    if(randchance == 1)
    {
        pData[playerid][AyamPotong] += 5;
        pData[playerid][AyamHidup] -= 1;
        ShowItemBox(playerid, "Ayam Potong", "Added_5x", 2804, 2);
        ShowItemBox(playerid, "Ayam Hidup", "Removed_1x", 16776, 2);
        pData[playerid][pBulu] += hasilrand;
        new str[500];
        format(str, sizeof(str), "Added_%dx", hasilrand);
        ShowItemBox(playerid, "Bulu", str, 19274, 2);
    }

    SuccesMsg(playerid, "Anda telah berhasil Memotong.");
    TogglePlayerControllable(playerid, 1);
    //ShowItemBox(playerid, "Chicken", "Removed_1x", 16776, 3);
    //ShowItemBox(playerid, "Ayam_Potong", "Received_5x", 2806, 3);
    KillTimer(ayamjob[playerid]);
    pData[playerid][pActivityTime] = 0;
    //pData[playerid][AyamPotong] += 5;
    //pData[playerid][AyamHidup] -= 1;
    pData[playerid][pPemotongStatus] -= 1;
    pData[playerid][pEnergy] -= 2;
    ClearAnimations(playerid);
    return 1;
}

CMD:ayampackinggen(playerid, params[])
{
    if(pData[playerid][pJob] == 24 || pData[playerid][pJob2] == 24)
    {
        if(pData[playerid][pPemotongStatus] == 1) return ErrorMsg(playerid, "Anda masih packing ayam");
        if(pData[playerid][AyamPotong] < 1) return ErrorMsg(playerid, "Anda Tidak Punya Ayam Potong.");
        if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
        if(pData[playerid][AyamFillet] == 150) return ErrorMsg(playerid, "Anda sudah membawa 150 Ayam Fillet!");
        {
            pData[playerid][pPemotongStatus] += 1;

            TogglePlayerControllable(playerid, 0);
            ayamjob[playerid] = SetTimerEx("packingchicken", 5000, false, "id", playerid);
            ShowProgressbar(playerid, "Membungkus Ayam..", 5);
            ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
        }
    }
    else return ErrorMsg(playerid, "anda bukan pekerja Pemotong Ayam!");
    return 1;
}
forward packingchicken(playerid);
public packingchicken(playerid)
{
    SuccesMsg(playerid, "Anda telah berhasil membungkus Ayam Potong.");
    TogglePlayerControllable(playerid, 1);
    KillTimer(ayamjob[playerid]);
    pData[playerid][pActivityTime] = 0;
    pData[playerid][AyamFillet] += 1;
    ShowItemBox(playerid, "Ayam Potong", "Removed_3x", 2804, 3);
    ShowItemBox(playerid, "Ayam Kemas", "Received_1x", 2768, 3);
    pData[playerid][AyamPotong] -= 3;
    pData[playerid][pPemotongStatus] -= 1;
    pData[playerid][pEnergy] -= 2;
    ClearAnimations(playerid);
    return 1;
}

CMD:jualbulunya(playerid, params[])
{
    new total = pData[playerid][pBulu];
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih memiliki activity progress!");
    if(pData[playerid][pBulu] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Bulu Yang Akan Dijual");
    ShowProgressbar(playerid, "Menjual Bulu..", 5);
    ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
    new pay = pData[playerid][pBulu] * 12;
    GivePlayerMoneyEx(playerid, pay);
    pData[playerid][pBulu] -= total;
    BuluAyam += total;
    Server_MinMoney(pay);
    new str[500];
    format(str, sizeof(str), "ADD_%dx", pay);
    ShowItemBox(playerid, "Uang", str, 1212, total);
    format(str, sizeof(str), "REMOVED_%dx", total);
    ShowItemBox(playerid, "Bulu", str, 19274, total);
    Inventory_Update(playerid);
    return 1;
}

CMD:jualayamgen(playerid, params[])
{
    if(pData[playerid][pVip] > 0)
    {
        if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
        if(pData[playerid][AyamFillet] < 1) return ErrorMsg(playerid, "Anda tidak memiliki 1 paket ayam!");
        new pay = pData[playerid][AyamFillet] * 40;
        new total = pData[playerid][AyamFillet];
        GivePlayerMoneyEx(playerid, pay);
        new str[500];
        format(str, sizeof(str), "Received_%dx", pay);
        ShowItemBox(playerid, "Uang", str, 1212, total);
        format(str, sizeof(str), "Removed_%dx", total);
        ShowItemBox(playerid, "Ayam Kemas", str, 2768, total);
        AyamFill += total;
        Server_MinMoney(pay);
        pData[playerid][AyamFillet] = 0;
        ShowProgressbar(playerid, "Menjual Ayam Kemas..", 5);
        ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    }
    else
    {
        if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
        if(pData[playerid][AyamFillet] < 1) return ErrorMsg(playerid, "Anda tidak memiliki 1 paket ayam!");
        new pay = pData[playerid][AyamFillet] * 20;
        new total = pData[playerid][AyamFillet];
        GivePlayerMoneyEx(playerid, pay);
        new str[500];
        format(str, sizeof(str), "Received_%dx", pay);
        ShowItemBox(playerid, "Uang", str, 1212, total);
        format(str, sizeof(str), "Removed_%dx", total);
        ShowItemBox(playerid, "Ayam Kemas", str, 2768, total);
        AyamFill += total;
        Server_MinMoney(pay);
        pData[playerid][AyamFillet] = 0;
        ShowProgressbar(playerid, "Menjual Ayam Kemas..", 5);
        ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    }
    return 1;
}