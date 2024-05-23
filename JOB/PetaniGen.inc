#include <YSI\y_hooks>

#define padipoin1 -121.3385, 98.0134, 3.1172
#define padipoin2 -104.6067, 149.7482, 3.1986
#define padipoin3 -111.3958, 153.1665, 3.4523
#define padipoin4 -129.5415, 100.5149, 3.1172
#define padipoin5 -137.9422, 102.2445, 3.1172
#define padipoin6 -120.3800, 153.9906, 3.6221
#define padipoin7 1239.60, -1392.87, 12.70
#define padipoin8 1206.85, -1379.95, 12.81

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{

    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -52.8912, 96.1338, 3.1172)) 
        {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 22) return Error(playerid, "Kamu bukan seorang petani.");
            ShowPlayerDialog(playerid, DIALOG_JOB_PETANI_MENGOLAHBAHAN, DIALOG_STYLE_TABLIST_HEADERS, "{FF0000}Kota Kami{FFFFFF} - Mengolah Bahan Petani", "Item\t\tRequirements\n{ffffff}Beras\t\tPadi : 4 | Karung Goni : 1\n{ffffff}Sambal\t\tCabai : 4 | Botol Bekas : 1\n{ffffff}Gula\t\tTebu : 4 | Karung Goni : 1\n{ffffff}Garam\t\tGaram Kristal : 4 | Botol Bekas : 1", "Select", "Close");
        }
    }

    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -50.7450, 102.7549, 3.1172)) 
        {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 22) return Error(playerid, "Kamu bukan seorang petani.");
            ShowPlayerDialog(playerid, DIALOG_JOB_PETANI_MENGOLAHBAHAN, DIALOG_STYLE_TABLIST_HEADERS, "{FF0000}Kota Kami{FFFFFF} - Mengolah Bahan Petani", "Item\t\tRequirements\n{ffffff}Beras\t\tPadi : 4 | Karung Goni : 1\n{ffffff}Sambal\t\tCabai : 4 | Botol Bekas : 1\n{ffffff}Gula\t\tTebu : 4 | Karung Goni : 1\n{ffffff}Garam\t\tGaram Kristal : 4 | Botol Bekas : 1", "Select", "Close");
        }
    }

    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -74.0760, 57.0568, 3.0800)) 
        {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 22) return Error(playerid, "Kamu bukan seorang petani.");
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return Error(playerid, "Kamu sedang berada di kendaraan!");
            if (GetPVarInt(playerid, "delayvehpetani") > gettime()) return Error(playerid, "Kamu baru saja mengeluarkan tractor petani tunggu sampai 30 detik!");
            OnPadi[playerid] = true;
            //PadiIndex[playerid] = 1;
            pData[playerid][pVehiclePetaniCabai] = CreateVehicle(531, -74.0760, 57.0568, 3.0800, 67.5466, 1, 1,-1);
            SetVehicleNumberPlate(pData[playerid][pVehiclePetaniCabai], "JOB VEHICLE");
            SetPlayerCheckpoint(playerid, padipoin1, 7.0);
            //SetPlayerRaceCheckpoint(playerid, 0, -121.3385, 98.0134, 3.1172, -104.6067, 149.7482, 3.1986, 5.0);
            PutPlayerInVehicle(playerid, PlayerData[playerid][pVehiclePetaniPadi], 0);
            SetPVarInt(playerid, "delayvehpetani", gettime() + 30);
            SwitchVehicleEngine(GetPlayerVehicleID(playerid), true);
        }
    }

    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -75.3248, 53.7628, 3.1172)) 
        {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 22) return Error(playerid, "Kamu bukan seorang petani.");
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return Error(playerid, "Kamu sedang berada di kendaraan!");
            if (GetPVarInt(playerid, "delayvehpetani") > gettime()) return Error(playerid, "Kamu baru saja mengeluarkan tractor petani tunggu sampai 30 detik!");
            OnCabai[playerid] = true;
            CabaiIndex[playerid] = 1;
            pData[playerid][pVehiclePetaniCabai] = CreateVehicle(531, -75.3248, 53.7628, 3.1172, 67.5466, 1, 1,-1);
            SetVehicleNumberPlate(pData[playerid][pVehiclePetaniCabai], "JOB VEHICLE");
            //PlayerData[playerid][pVehiclePetaniCabai] = CreateVehicle(531, -75.3248, 53.7628, 3.1172, 67.5466, 1, 1, 60000);
            //VehCore[PlayerData[playerid][pVehiclePetaniCabai]][vehFuel] = 20;
            SetPlayerRaceCheckpoint(playerid, 0, -153.9180, 109.0367, 3.2596, -145.8213, 132.7391, 3.7087, 5.0);
            PutPlayerInVehicle(playerid, PlayerData[playerid][pVehiclePetaniCabai], 0);
            SetPVarInt(playerid, "delayvehpetani", gettime() + 30);
            SwitchVehicleEngine(GetPlayerVehicleID(playerid), true);
        }
    }

    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -76.6268, 50.6978, 3.117)) {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 22) return Error(playerid, "Kamu bukan seorang petani.");
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return Error(playerid, "Kamu sedang berada di kendaraan!");
            if (GetPVarInt(playerid, "delayvehpetani") > gettime()) return Error(playerid, "Kamu baru saja mengeluarkan tractor petani tunggu sampai 30 detik!");
            OnTebu[playerid] = true;
            TebuIndex[playerid] = 1;
            pData[playerid][pVehiclePetaniTebu] = CreateVehicle(531, -76.6268, 50.6978, 3.117, 67.5466, 1, 1,-1);
            SetVehicleNumberPlate(pData[playerid][pVehiclePetaniTebu], "JOB VEHICLE");
            //PlayerData[playerid][pVehiclePetaniTebu] = CreateVehicle(531, -76.6268, 50.6978, 3.117, 67.5466, 1, 1, 60000);
            //VehCore[PlayerData[playerid][pVehiclePetaniTebu]][vehFuel] = 20;
            SetPlayerRaceCheckpoint(playerid, 0, -125.9183, 59.3488, 2.6850, -143.5842, 12.2339, 2.6850, 5.0);
            PutPlayerInVehicle(playerid, PlayerData[playerid][pVehiclePetaniTebu], 0);
            SetPVarInt(playerid, "delayvehpetani", gettime() + 30);
            SwitchVehicleEngine(GetPlayerVehicleID(playerid), true);
        }
    }

    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -77.9245, 47.7253, 3.1172)) 
        {
            if (PlayerData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (PlayerData[playerid][pJob] != 22) return Error(playerid, "Kamu bukan seorang petani.");
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return Error(playerid, "Kamu sedang berada di kendaraan!");
            if (GetPVarInt(playerid, "delayvehpetani") > gettime()) return Error(playerid, "Kamu baru saja mengeluarkan tractor petani tunggu sampai 30 detik!");
            OnGaram[playerid] = true;
            GaramIndex[playerid] = 1;
            pData[playerid][pVehiclePetaniTebu] = CreateVehicle(531, -77.9245, 47.7253, 3.1172, 67.5466, 1, 1,-1);
            SetVehicleNumberPlate(pData[playerid][pVehiclePetaniTebu], "JOB VEHICLE");
            SetPlayerRaceCheckpoint(playerid, 0, 133.3274, 137.5928, 2.0258, 163.5747, 140.9785, 2.0322, 5.0);
            PutPlayerInVehicle(playerid, PlayerData[playerid][pVehiclePetaniGaram], 0);
            SetPVarInt(playerid, "delayvehpetani", gettime() + 30);
            SwitchVehicleEngine(GetPlayerVehicleID(playerid), true);
        }
    }
    // Petani Padi
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -120.4719, 100.0535, 3.1172)) 
        {
            if (IsValidPlayerObject(playerid, objpadi[0][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[0][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -113.3886, 121.5473, 3.1172)) 
        {

            if (IsValidPlayerObject(playerid, objpadi[1][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[1][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -104.8806, 147.5743, 3.1247)) 
        {
            if (IsValidPlayerObject(playerid, objpadi[2][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[2][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -113.0978, 149.5568, 3.3532)) 
        {
            if (IsValidPlayerObject(playerid, objpadi[3][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[3][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -120.9507, 125.0645, 3.1172)) 
        {
            if (IsValidPlayerObject(playerid, objpadi[4][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[4][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -129.4480, 102.2350, 3.1172)) 
        {
            if (IsValidPlayerObject(playerid, objpadi[5][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[5][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -137.8015, 105.8149, 3.1172)) 
        {

            if (IsValidPlayerObject(playerid, objpadi[6][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[6][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -130.4068, 127.7735, 3.2353)) 
        {
            if (IsValidPlayerObject(playerid, objpadi[7][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[7][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -122.1953, 152.2816, 3.6405)) 
        {

            if (IsValidPlayerObject(playerid, objpadi[8][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Padi", 4);
                SetTimerEx("Panenpadi", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Padi", 10, "Panenpadi", COLOR_GREEN);
                DestroyPlayerObject(playerid, objpadi[8][playerid]);
            }
        }
        // Petani Cabai
        if ((newkeys & KEY_YES)) 
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -153.9180, 109.0367, 3.2596)) 
            {
                if (IsValidPlayerObject(playerid, objcabai[0][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                    //StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[0][playerid]);
                }
            }
        }
        if ((newkeys & KEY_YES)) {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -145.8213, 132.7391, 3.7087)) 
            {
                if (IsValidPlayerObject(playerid, objcabai[1][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                    //StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[1][playerid]);
                }
            }
        }
        if ((newkeys & KEY_YES)) 
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -163.3328, 139.8901, 4.2464)) 
            {

                if (IsValidPlayerObject(playerid, objcabai[2][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                   // StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[2][playerid]);
                }
            }
        }
        if ((newkeys & KEY_YES)) 
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -155.1666, 161.6306, 5.7901)) 
            {
                if (IsValidPlayerObject(playerid, objcabai[3][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                    //StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[3][playerid]);
                }
            }
        }
        if ((newkeys & KEY_YES)) 
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -154.6342, 137.3800, 3.7941)) 
            {
                if (IsValidPlayerObject(playerid, objcabai[4][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                    //StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[4][playerid]);
                }
            }
        }
        if ((newkeys & KEY_YES)) 
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -162.3345, 113.7469, 3.3464)) 
            {
                if (IsValidPlayerObject(playerid, objcabai[5][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                    //StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[5][playerid]);
                }
            }
        }
        if ((newkeys & KEY_YES)) 
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -170.3694, 116.2744, 3.3921)) 
            {
                if (IsValidPlayerObject(playerid, objcabai[6][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                    //StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[6][playerid]);
                }
            }
        }
        if ((newkeys & KEY_YES)) 
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -137.7154, 157.5168, 4.6476)) 
            {
                if (IsValidPlayerObject(playerid, objcabai[7][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                    //StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[7][playerid]);
                }
            }
        }
        if ((newkeys & KEY_YES)) 
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, -145.3852, 161.9973, 5.3994)) 
            {
                if (IsValidPlayerObject(playerid, objcabai[8][playerid])) 
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                    ShowProgressbar(playerid, "Memanen Cabai", 4);
                    SetTimerEx("Panencabai", 4000, false, "d", playerid);
                    //StartPlayerLoadingBar(playerid, 300, "Memanen Cabai", 10, "Panencabai", COLOR_GREEN);
                    DestroyPlayerObject(playerid, objcabai[8][playerid]);
                }
            }
        }
    }

    // Petani Tebu
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -125.9183, 59.3488, 2.6850)) 
        {
            if (IsValidPlayerObject(playerid, objtebu[0][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Tebu", 10, "Panentebu", COLOR_GREEN);
                DestroyPlayerObject(playerid, objtebu[0][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -143.5842, 12.2339, 2.6850)) 
        {
            if (IsValidPlayerObject(playerid, objtebu[1][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Tebu", 10, "Panentebu", COLOR_GREEN);
                DestroyPlayerObject(playerid, objtebu[1][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -161.5513, -32.5512, 2.6850)) 
        {
            if (IsValidPlayerObject(playerid, objtebu[2][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Tebu", 10, "Panentebu", COLOR_GREEN);
                DestroyPlayerObject(playerid, objtebu[2][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -166.0614, -26.2519, 2.6850)) 
        {
            if (IsValidPlayerObject(playerid, objtebu[3][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Tebu", 10, "Panentebu", COLOR_GREEN);
                DestroyPlayerObject(playerid, objtebu[3][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -153.3865, 7.6404, 2.6850)) 
        {
            if (IsValidPlayerObject(playerid, objtebu[4][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Tebu", 10, "Panentebu", COLOR_GREEN);
                DestroyPlayerObject(playerid, objtebu[4][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -134.6685, 56.9448, 2.6850)) 
        {
            if (IsValidPlayerObject(playerid, objtebu[5][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Tebu", 10, "Panentebu", COLOR_GREEN);
                DestroyPlayerObject(playerid, objtebu[5][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -140.7485, 65.1926, 2.6850)) 
        {

            if (IsValidPlayerObject(playerid, objtebu[6][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Tebu", 10, "Panentebu", COLOR_GREEN);
                DestroyPlayerObject(playerid, objtebu[6][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -153.0560, 29.4733, 2.685)) 
        {
            if (IsValidPlayerObject(playerid, objtebu[7][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Tebu", 10, "Panentebu", COLOR_GREEN);
                DestroyPlayerObject(playerid, objtebu[7][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, -166.8356, -7.0291, 2.6848)) 
        {
        
            if (IsValidPlayerObject(playerid, objtebu[8][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Tebu", 4);
                SetTimerEx("Panentebu", 4000, false, "d", playerid);
                DestroyPlayerObject(playerid, objtebu[8][playerid]);
            }
        }
    }
    // Petani Garam
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 133.3274, 137.5928, 2.0258)) 
        {
            if (IsValidPlayerObject(playerid, objgaram[0][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Garam", 4);
                SetTimerEx("Panengaram", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
                DestroyPlayerObject(playerid, objgaram[0][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 163.5747, 140.9785, 2.0322)) 
        {

            if (IsValidPlayerObject(playerid, objgaram[1][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Garam", 4);
                SetTimerEx("Panengaram", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
                DestroyPlayerObject(playerid, objgaram[1][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 197.4598, 146.5734, 2.0237)) 
        {

            if (IsValidPlayerObject(playerid, objgaram[2][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Garam", 4);
                SetTimerEx("Panengaram", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
                DestroyPlayerObject(playerid, objgaram[2][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 194.9090, 155.4906, 1.2074)) 
        {
            if (IsValidPlayerObject(playerid, objgaram[3][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Garam", 4);
                SetTimerEx("Panengaram", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
                DestroyPlayerObject(playerid, objgaram[3][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) 
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 168.4257, 155.7041, 0.931)) 
        {
            if (IsValidPlayerObject(playerid, objgaram[4][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Garam", 4);
                SetTimerEx("Panengaram", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
                DestroyPlayerObject(playerid, objgaram[4][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 154.6527, 149.4088, 1.0648)) {

            if (IsValidPlayerObject(playerid, objgaram[5][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Garam", 4);
                SetTimerEx("Panengaram", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
                DestroyPlayerObject(playerid, objgaram[5][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 159.3219, 157.3833, 1.1244)) 
        {
            if (IsValidPlayerObject(playerid, objgaram[6][playerid])) 
            {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
                ShowProgressbar(playerid, "Memanen Garam", 4);
                SetTimerEx("Panengaram", 4000, false, "d", playerid);
                //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
                DestroyPlayerObject(playerid, objgaram[6][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 140.5071, 143.9965, 1.3729)) {

            if (IsValidPlayerObject(playerid, objgaram[7][playerid])) {
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
            ShowProgressbar(playerid, "Memanen Garam", 4);
            SetTimerEx("Panengaram", 4000, false, "d", playerid);
            //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
            DestroyPlayerObject(playerid, objgaram[7][playerid]);
            }
        }
    }
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 110.4266, 138.6105, 2.0302)) {

            if (IsValidPlayerObject(playerid, objgaram[8][playerid])) {
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0, 1);
            ShowProgressbar(playerid, "Memanen Garam", 4);
            SetTimerEx("Panengaram", 4000, false, "d", playerid);
            //StartPlayerLoadingBar(playerid, 300, "Memanen Garam", 10, "Panengaram", COLOR_GREEN);
            DestroyPlayerObject(playerid, objgaram[8][playerid]);
            }
        }
    }
    return 1;
}

function Panenpadi(playerid)
{
    ClearAnimations(playerid);
	new randchance = random(2);
    if(randchance == 0)
    {
        ShowItemBox(playerid, "Padi", "Added_1x", 806, 1);
        pData[playerid][pPadi] += 1;
    }
    if(randchance == 1)
    {
        ShowItemBox(playerid, "Padi", "Added_2x", 806, 1);
	    pData[playerid][pPadi] += 2;
    }     
	return 1;
}

function Panencabai(playerid)
{
	ClearAnimations(playerid);
	//TogglePlayerControllable(playerid, 1);
	new randchance = random(2);
    if(randchance == 0)
    {
        ShowItemBox(playerid, "Cabai", "Added_1x", 870, 1);
	    pData[playerid][pCabai] += 2;
    }
    if(randchance == 1)
    {
        ShowItemBox(playerid, "Cabai", "Added_2x", 870, 1);
	    pData[playerid][pCabai] += 2;
    }     
	return 1;
}

function Panentebu(playerid)
{
	ClearAnimations(playerid);
	//TogglePlayerControllable(playerid, 1);
	new randchance = random(2);
    if(randchance == 0)
    {
        ShowItemBox(playerid, "Tebu", "Added_1x", 651, 1);
	    pData[playerid][pTebu] += 1;
    }
    if(randchance == 1)
    {
        ShowItemBox(playerid, "Tebu", "Added_2x", 651, 1);
	    pData[playerid][pTebu] += 2;
    }     

	return 1;
}


function Panengaram(playerid)
{
	ClearAnimations(playerid);
	//TogglePlayerControllable(playerid, 1);
	new randchance = random(2);
    if(randchance == 0)
    {
        ShowItemBox(playerid, "Garam Kristal", "Added_1x", 19177, 2);
	    pData[playerid][pGaramKristal] += 1;
    }
    if(randchance == 1)
    {
        ShowItemBox(playerid, "Garam Kristal", "Added_2x", 19177, 3);
	    pData[playerid][pGaramKristal] += 2;
    }     

	return 1;
}

function Beras(playerid)
{
	ClearAnimations(playerid);
    pData[playerid][pPadi] -= 4;
    pData[playerid][pKarungGoni] -= 1;
	ShowItemBox(playerid, "Padi", "Removed_4x", 806, 2);
	ShowItemBox(playerid, "Karung Goni", "Removed_1x", 2060, 2);
	ShowItemBox(playerid, "Beras", "Added_1x", 19573, 3);
	pData[playerid][pBeras] += 1;
	return 1;
}

function Sambal(playerid)
{
	ClearAnimations(playerid);
    pData[playerid][pCabai] -= 4;
    pData[playerid][pBotolBekas] -= 1;
	ShowItemBox(playerid, "Cabai", "Removed_4x", 870, 2);
	ShowItemBox(playerid, "Botol Bekas", "Removed_1x", 2683, 2);
	ShowItemBox(playerid, "Sambal", "Added_1x", 11722, 3);
	pData[playerid][pSambal] += 1;
	return 1;
}

function Gula(playerid)
{
	ClearAnimations(playerid);
	pData[playerid][pTebu] -= 4;
    pData[playerid][pKarungGoni] -= 1;
	ShowItemBox(playerid, "Tebu", "Removed_4x", 651, 2);
	ShowItemBox(playerid, "Karung Goni", "Removed_1x", 2060, 2);
	ShowItemBox(playerid, "Gula", "Added_1x", 2663, 3);
	pData[playerid][pGula] += 1;

	return 1;
}

function Garam(playerid)
{
	ClearAnimations(playerid);
	pData[playerid][pGaramKristal] -= 4;
    pData[playerid][pBotolBekas] -= 1;
	ShowItemBox(playerid, "Garam Kristal", "Removed_4x", 19177, 2);
	ShowItemBox(playerid, "Botol Bekas", "Removed_1x", 2683, 2);
	ShowItemBox(playerid, "Garam", "Added_1x", 19568, 3);
	pData[playerid][pGaram] += 1;

	return 1;
}