#include <YSI\y_hooks>

enum e_areajob 
{
    //STREAMER_TAG_AREA:areaMiner[9],
    STREAMER_TAG_AREA:areaTukangkayu[7],
    STREAMER_TAG_CP:KayuCP1,
    STREAMER_TAG_CP:KayuCP2,
    STREAMER_TAG_CP:KayuCP3,
    STREAMER_TAG_CP:KayuCP4,
    STREAMER_TAG_CP:KayuCP5,
    STREAMER_TAG_CP:KayuCP6,
    STREAMER_TAG_CP:KayuCP7,
    STREAMER_TAG_CP:IKEA,
};
new AreaSendJob[e_areajob];

stock LoadAreaJob() 
{
    AreaSendJob[areaTukangkayu][0] = CreateDynamicSphere(-450.1685,-45.4697,59.6945, 2.0);
    AreaSendJob[areaTukangkayu][1] = CreateDynamicSphere(-449.8972,-51.5766,59.6385, 2.0);
    AreaSendJob[areaTukangkayu][2] = CreateDynamicSphere(-443.2688,-51.1891,59.3676, 2.0);
    AreaSendJob[areaTukangkayu][3] = CreateDynamicSphere(-443.3006,-45.8996,59.4077, 2.0);

    AreaSendJob[areaTukangkayu][4] = CreateDynamicSphere(-435.8718,-73.5172,58.8910, 2.0);
    AreaSendJob[areaTukangkayu][5] = CreateDynamicSphere(-435.6222,-76.1013,58.8612, 2.0);
    AreaSendJob[areaTukangkayu][6] = CreateDynamicSphere(-463.5522,-46.0111,59.9552, 2.0);

    AreaSendJob[KayuCP1] = CreateDynamicCP(-450.1685,-45.4697,59.6945, 1.0, -1, -1, -1, 20.0);
    AreaSendJob[KayuCP2] = CreateDynamicCP(-449.8972,-51.5766,59.6385, 1.0, -1, -1, -1, 20.0);
    AreaSendJob[KayuCP3] = CreateDynamicCP(-443.2688,-51.1891,59.3676, 1.0, -1, -1, -1, 20.0);
    AreaSendJob[KayuCP4] = CreateDynamicCP(-443.3006,-45.8996,59.4077, 1.0, -1, -1, -1, 20.0);

    AreaSendJob[KayuCP5] = CreateDynamicCP(-435.8718,-73.5172,58.8910, 1.0, -1, -1, -1, 20.0);
    AreaSendJob[KayuCP6] = CreateDynamicCP(-435.6222,-76.1013,58.8612, 1.0, -1, -1, -1, 20.0);
    AreaSendJob[KayuCP7] = CreateDynamicCP(-463.5522,-46.0111,59.9552, 1.0, -1, -1, -1, 20.0);

    //IKEA = CreateDynamicCP(2357.3823,-1990.5114,13.5469, 3.0, -1, -1, -1, 5.0);
    AreaSendJob[IKEA] = CreateDynamicCP(2357.3823,-1990.5114,13.5469, 1.0, -1, -1, -1, 20.0);

}

/*hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_YES)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -450.1685,-45.4697,59.6945))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] > 50) return ErrorMsg(playerid, "Anda tidak dapat membawa 50 kayu");
            //pData[playerid][pTukangkayu] = 1;
            ApplyAnimation(playerid, "BD_FIRE", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);
            ShowProgressbar(playerid, "Memotong Kayu..", 5);
            SetTimerEx("kayu1", 5000, false, "d", playerid);
            SetPlayerChainsaw(playerid, true);
        }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -449.8972,-51.5766,59.6385))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] > 50) return ErrorMsg(playerid, "Anda tidak dapat membawa 50 kayu");
            //pData[playerid][pTukangkayu] = 2;
            ApplyAnimation(playerid, "BD_FIRE", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);
            ShowProgressbar(playerid, "Memotong Kayu..", 5);
            SetTimerEx("kayu1", 5000, false, "d", playerid);
            SetPlayerChainsaw(playerid, true);
        }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -443.2688,-51.1891,59.3676))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] > 50) return ErrorMsg(playerid, "Anda tidak dapat membawa 50 kayu");
            //pData[playerid][pTukangkayu] = 3;
            ApplyAnimation(playerid, "BD_FIRE", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);
            ShowProgressbar(playerid, "Memotong Kayu..", 5);
            SetTimerEx("kayu1", 5000, false, "d", playerid);
            SetPlayerChainsaw(playerid, true);
        }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -443.3006,-45.8996,59.4077))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] > 50) return ErrorMsg(playerid, "Anda tidak dapat membawa 50 kayu");
            //pData[playerid][pTukangkayu] = 0;
            ApplyAnimation(playerid, "BD_FIRE", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);
            ShowProgressbar(playerid, "Memotong Kayu..", 5);
            SetTimerEx("kayu1", 5000, false, "d", playerid);
            SetPlayerChainsaw(playerid, true);
        }

        if(IsPlayerInRangeOfPoint(playerid, 1.5, -435.8718,-73.5172,58.8910))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] < 1) return ErrorMsg(playerid, "Kamu tidak memiliki kayu!");
            {
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
                ShowProgressbar(playerid, "Gergaji Kayu..", 5);
                SetTimerEx("kayu2", 5000, false, "d", playerid);
            }
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.5, -435.6222,-76.1013,58.8612))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] < 1) return ErrorMsg(playerid, "Kamu tidak memiliki kayu!");
            {
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
                ShowProgressbar(playerid, "Gergaji Kayu..", 5);
                SetTimerEx("kayu2", 5000, false, "d", playerid);
            }
        }
        if(IsPlayerInRangeOfPoint(playerid, 5.0, -463.5522,-46.0111,59.9552))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayuPotong] < 4) return ErrorMsg(playerid, "Kamu tidak memiliki kayu potongan (Min:4)");
            {
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
                ShowProgressbar(playerid, "Mengemas Kayu..", 5);
                SetTimerEx("kayu3", 5000, false, "d", playerid);
            }
        }

        if(IsPlayerInRangeOfPoint(playerid, 3.0, -463.5522,-46.0111,59.9552))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayuPotong] < 4) return ErrorMsg(playerid, "Kamu tidak memiliki kayu potongan (Min:4)");
            {
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
                ShowProgressbar(playerid, "Mengemas Kayu..", 5);
                SetTimerEx("kayu3", 5000, false, "d", playerid);
            }
        }
    }
    return 1;
}*/

function kayu1(playerid)
{
    ClearAnimations(playerid);   
    new randjumlah = RandomEx(2, 4), hasilrand = randjumlah;

    pData[playerid][pKayu] += hasilrand;

    new str[500];
    format(str, sizeof(str), "Added_%dx", hasilrand);
    ShowItemBox(playerid, "Kayu", str, 19793, 2);
    SetPlayerChainsaw(playerid, false);
    pData[playerid][pApplyAnimation] = false;
    return 1;
}

function kayu2(playerid)
{
    ClearAnimations(playerid);
    pData[playerid][pKayu]--;
    pData[playerid][pKayuPotong] += 4;
    ShowItemBox(playerid, "Kayu", "Removed_1x", 19793, 2);
    ShowItemBox(playerid, "Kayu Potongan", "Added_4x", 831, 2);
    SetPlayerChainsaw(playerid, false);
    pData[playerid][pApplyAnimation] = false;
    return 1;
}

function kayu3(playerid)
{
    ClearAnimations(playerid);
    pData[playerid][pKayuPotong] -= 4;
    pData[playerid][pKayuKemas]++;
    ShowItemBox(playerid, "Kayu Potongan", "Removed_4x", 831, 2);
    ShowItemBox(playerid, "Kayu Kemas", "Added_1x", 1463, 2);
    SetPlayerChainsaw(playerid, false);
    pData[playerid][pApplyAnimation] = false;
    return 1;
}

CMD:jualkayugen(playerid, params[])
{
    new total = pData[playerid][pKayuKemas];
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
    if(pData[playerid][pKayuKemas] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Kayu Kemas");
    ShowProgressbar(playerid, "Menjual KayuKemas..", 4);
    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
    new pay = pData[playerid][pKayuKemas] * 18;
    GivePlayerMoneyEx(playerid, pay);
    pData[playerid][pKayuKemas] -= total;
    new str[500];
    format(str, sizeof(str), "ADD_%dx", pay);
    ShowItemBox(playerid, "Uang", str, 1212, total);
    format(str, sizeof(str), "REMOVED_%dx", total);
    ShowItemBox(playerid, "Kayu Kemas", str, 1463, total);
    Inventory_Update(playerid);
    return 1;
}