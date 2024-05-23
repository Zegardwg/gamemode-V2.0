SetPlayerToFacePlayer(playerid, targetid)
{
    new
        Float:px,
        Float:py,
        Float:pz,
        Float:tx,
        Float:ty,
        Float:tz;

    GetPlayerPos(targetid, tx, ty, tz);
    GetPlayerPos(playerid, px, py, pz);
    SetPlayerFacingAngle(playerid, 180.0 - atan2(px - tx, py - ty));
}

new gPlayerUsingLoopingAnim[MAX_PLAYERS];
new gPlayerAnimLibsPreloaded[MAX_PLAYERS];

stock ApplyAnimationForPlayer(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
    ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);

    pData[playerid][pApplyAnimation] = true;
    return 1;
}

StopLoopingAnim(playerid)
{
    gPlayerUsingLoopingAnim[playerid] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
}

PreloadAnimLib(playerid, animlib[])
{
    ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0,1);
}

//OnPlayerSpawn
LoadAnims(playerid)
{
    if(!gPlayerAnimLibsPreloaded[playerid])
    {
        PreloadAnimLib(playerid,"AIRPORT");
        PreloadAnimLib(playerid,"Attractors");
        PreloadAnimLib(playerid,"BAR");
        PreloadAnimLib(playerid,"BASEBALL");
        PreloadAnimLib(playerid,"BD_FIRE");
        PreloadAnimLib(playerid,"benchpress");
        PreloadAnimLib(playerid,"BF_injection");
        PreloadAnimLib(playerid,"BIKED");
        PreloadAnimLib(playerid,"BIKEH");
        PreloadAnimLib(playerid,"BIKELEAP");
        PreloadAnimLib(playerid,"BIKES");
        PreloadAnimLib(playerid,"BIKEV");
        PreloadAnimLib(playerid,"BIKE_DBZ");
        PreloadAnimLib(playerid,"BMX");
        PreloadAnimLib(playerid,"BOX");
        PreloadAnimLib(playerid,"BSKTBALL");
        PreloadAnimLib(playerid,"BUDDY");
        PreloadAnimLib(playerid,"BUS");
        PreloadAnimLib(playerid,"CAMERA");
        PreloadAnimLib(playerid,"CAR");
        PreloadAnimLib(playerid,"CAR_CHAT");
        PreloadAnimLib(playerid,"CASINO");
        PreloadAnimLib(playerid,"CHAINSAW");
        PreloadAnimLib(playerid,"CHOPPA");
        PreloadAnimLib(playerid,"CLOTHES");
        PreloadAnimLib(playerid,"COACH");
        PreloadAnimLib(playerid,"COLT45");
        PreloadAnimLib(playerid,"COP_DVBYZ");
        PreloadAnimLib(playerid,"CRIB");
        PreloadAnimLib(playerid,"DAM_JUMP");
        PreloadAnimLib(playerid,"DANCING");
        PreloadAnimLib(playerid,"DILDO");
        PreloadAnimLib(playerid,"DODGE");
        PreloadAnimLib(playerid,"DOZER");
        PreloadAnimLib(playerid,"DRIVEBYS");
        PreloadAnimLib(playerid,"FAT");
        PreloadAnimLib(playerid,"FIGHT_B");
        PreloadAnimLib(playerid,"FIGHT_C");
        PreloadAnimLib(playerid,"FIGHT_D");
        PreloadAnimLib(playerid,"FIGHT_E");
        PreloadAnimLib(playerid,"FINALE");
        PreloadAnimLib(playerid,"FINALE2");
        PreloadAnimLib(playerid,"Flowers");
        PreloadAnimLib(playerid,"FOOD");
        PreloadAnimLib(playerid,"Freeweights");
        PreloadAnimLib(playerid,"GANGS");
        PreloadAnimLib(playerid,"GHANDS");
        PreloadAnimLib(playerid,"GHETTO_DB");
        PreloadAnimLib(playerid,"goggles");
        PreloadAnimLib(playerid,"GRAFFITI");
        PreloadAnimLib(playerid,"GRAVEYARD");
        PreloadAnimLib(playerid,"GRENADE");
        PreloadAnimLib(playerid,"GYMNASIUM");
        PreloadAnimLib(playerid,"HAIRCUTS");
        PreloadAnimLib(playerid,"HEIST9");
        PreloadAnimLib(playerid,"INT_HOUSE");
        PreloadAnimLib(playerid,"INT_OFFICE");
        PreloadAnimLib(playerid,"INT_SHOP");
        PreloadAnimLib(playerid,"JST_BUISNESS");
        PreloadAnimLib(playerid,"KART");
        PreloadAnimLib(playerid,"KISSING");
        PreloadAnimLib(playerid,"KNIFE");
        PreloadAnimLib(playerid,"LAPDAN1");
        PreloadAnimLib(playerid,"LAPDAN2");
        PreloadAnimLib(playerid,"LAPDAN3");
        PreloadAnimLib(playerid,"LOWRIDER");
        PreloadAnimLib(playerid,"MD_CHASE");
        PreloadAnimLib(playerid,"MEDIC");
        PreloadAnimLib(playerid,"MD_END");
        PreloadAnimLib(playerid,"MISC");
        PreloadAnimLib(playerid,"MTB");
        PreloadAnimLib(playerid,"MUSCULAR");
        PreloadAnimLib(playerid,"NEVADA");
        PreloadAnimLib(playerid,"ON_LOOKERS");
        PreloadAnimLib(playerid,"OTB");
        PreloadAnimLib(playerid,"PARACHUTE");
        PreloadAnimLib(playerid,"PARK");
        PreloadAnimLib(playerid,"PAULNMAC");
        PreloadAnimLib(playerid,"PED");
        PreloadAnimLib(playerid,"PLAYER_DVBYS");
        PreloadAnimLib(playerid,"PLAYIDLES");
        PreloadAnimLib(playerid,"POLICE");
        PreloadAnimLib(playerid,"POOL");
        PreloadAnimLib(playerid,"POOR");
        PreloadAnimLib(playerid,"PYTHON");
        PreloadAnimLib(playerid,"QUAD");
        PreloadAnimLib(playerid,"QUAD_DBZ");
        PreloadAnimLib(playerid,"RIFLE");
        PreloadAnimLib(playerid,"RIOT");
        PreloadAnimLib(playerid,"ROB_BANK");
        PreloadAnimLib(playerid,"ROCKET");
        PreloadAnimLib(playerid,"RUSTLER");
        PreloadAnimLib(playerid,"RYDER");
        PreloadAnimLib(playerid,"SCRATCHING");
        PreloadAnimLib(playerid,"SHAMAL");
        PreloadAnimLib(playerid,"SHOTGUN");
        PreloadAnimLib(playerid,"SILENCED");
        PreloadAnimLib(playerid,"SKATE");
        PreloadAnimLib(playerid,"SPRAYCAN");
        PreloadAnimLib(playerid,"STRIP");
        PreloadAnimLib(playerid,"SUNBATHE");
        PreloadAnimLib(playerid,"SWAT");
        PreloadAnimLib(playerid,"SWEET");
        PreloadAnimLib(playerid,"SWIM");
        PreloadAnimLib(playerid,"SWORD");
        PreloadAnimLib(playerid,"TANK");
        PreloadAnimLib(playerid,"TATTOOS");
        PreloadAnimLib(playerid,"TEC");
        PreloadAnimLib(playerid,"TRAIN");
        PreloadAnimLib(playerid,"TRUCK");
        PreloadAnimLib(playerid,"UZI");
        PreloadAnimLib(playerid,"VAN");
        PreloadAnimLib(playerid,"VENDING");
        PreloadAnimLib(playerid,"VORTEX");
        PreloadAnimLib(playerid,"WAYFARER");
        PreloadAnimLib(playerid,"WEAPONS");
        PreloadAnimLib(playerid,"WUZI");
        PreloadAnimLib(playerid,"SNM");
        PreloadAnimLib(playerid,"BLOWJOBZ");
        PreloadAnimLib(playerid,"SEX");
        PreloadAnimLib(playerid,"BOMBER");
        PreloadAnimLib(playerid,"RAPPING");
        PreloadAnimLib(playerid,"SHOP");
        PreloadAnimLib(playerid,"BEACH");
        PreloadAnimLib(playerid,"SMOKING");
        PreloadAnimLib(playerid,"FOOD");
        PreloadAnimLib(playerid,"ON_LOOKERS");
        PreloadAnimLib(playerid,"DEALER");
        PreloadAnimLib(playerid,"CRACK");
        PreloadAnimLib(playerid,"CARRY");
        PreloadAnimLib(playerid,"COP_AMBIENT");
        PreloadAnimLib(playerid,"PARK");
        PreloadAnimLib(playerid,"INT_HOUSE");
        PreloadAnimLib(playerid,"FOOD");
        gPlayerAnimLibsPreloaded[playerid] = 1;
    }
}

CMD:anims(playerid, params[])
{
    return callcmd::animhelp(playerid, params);
}

CMD:animhelp(playerid, params[])
{
    new string[2024];
    format(string, sizeof(string), ""YELLOW_E"/dance, /wave, /point, /salute, /laugh, /cry, /deal, /sit, /lay, /fall, /handsup.\n");
    format(string, sizeof(string), "%s/tired, /cower, /crack, /injured, /fishing, /reload, /aim, /bomb, /checktime.\n", string);
    format(string, sizeof(string), "%s/dodge, /stop, /scratch, /what, /wash, /come, /hitch, /cpr, /slapass, /drunk.\n", string);
    format(string, sizeof(string), "%s/vomit, /fucku, /taichi, /shifty, /smoke, /chat, /lean, /wank, /crossarms.\n", string);
    format(string, sizeof(string), "%s/ghands, /rap, /dj, /walk, /fuckme, /bj, /kiss, /piss, /robman, /eat, /stopanim.\n", string);
    ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FF0000}Anim List", string, "Yes", "No");
    return 1;
}

CMD:dance(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    new animid;
    if(sscanf(params, "d", animid))
        return Usage(playerid, "dance [1-10]");

    if(animid < 1 || animid > 10)
        return Usage(playerid, "dance [1-10]"); 

    switch(animid)
    {
        case 1: ApplyAnimation(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimation(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimation(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 0, 0, 1);
        case 7: ApplyAnimation(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 0, 0, 1);
        case 8: ApplyAnimation(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 0, 0, 1);
        case 9: ApplyAnimation(playerid, "DANCING", "dnce_M_d", 4.1, 1, 0, 0, 0, 0, 1);
        case 10: ApplyAnimation(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:wave(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/wave [1-3]");
    }

    return 1;
}

CMD:point(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "ON_LOOKERS", "panic_point", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/point [1-2]");
    }

    return 1;
}

CMD:salute(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:laugh(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:cry(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:deal(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:sit(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "MISC", "SEAT_LR", 4.1, 0, 0, 0, 1, 0);
        case 4: ApplyAnimation(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimation(playerid, "PED", "SEAT_down", 4.1, 0, 0, 0, 1, 0);
        case 6: ApplyAnimation(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 7: ApplyAnimation(playerid, "INT_OFFICE", "OFF_Sit_Read", 4.1, 1, 0, 0, 0, 0, 1);
        case 8: ApplyAnimation(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 0, 0, 1);
        case 9: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat1", 4.1, 1, 0, 0, 0, 0, 1);
        case 10: ApplyAnimation(playerid, "CRIB", "PED_Console_Loop", 4.1, 0, 0, 0, 1, 0);
        default: Usage(playerid,"/sit [1-10]");
    }

    return 1;
}

CMD:camera(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "CAMERA", "camcrch_comeon", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "CAMERA", "camcrch_idleloop", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "CAMERA", "camcrch_stay", 4.1, 0, 0, 0, 1, 0);
        case 4: ApplyAnimation(playerid, "CAMERA", "camcrch_to_camstnd", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimation(playerid, "CAMERA", "camstnd_comeon", 4.1, 0, 0, 0, 1, 0);
        case 6: ApplyAnimation(playerid, "CAMERA", "camstnd_idleloop", 4.1, 1, 0, 0, 0, 0, 1);
        case 7: ApplyAnimation(playerid, "CAMERA", "camstnd_lkabt", 4.1, 1, 0, 0, 0, 0, 1);
        case 8: ApplyAnimation(playerid, "CAMERA", "camstnd_to_camcrch", 4.1, 1, 0, 0, 0, 0, 1);
        case 9: ApplyAnimation(playerid, "CAMERA", "piccrch_in", 4.1, 1, 0, 0, 0, 0, 1);
        case 10: ApplyAnimation(playerid, "CAMERA", "piccrch_out", 4.1, 0, 0, 0, 1, 0);
        case 11: ApplyAnimation(playerid, "CAMERA", "piccrch_take", 4.1, 1, 0, 0, 0, 0, 1);
        case 12: ApplyAnimation(playerid, "CAMERA", "picstnd_in", 4.1, 1, 0, 0, 0, 0, 1);
        case 13: ApplyAnimation(playerid, "CAMERA", "picstnd_out", 4.1, 1, 0, 0, 0, 0, 1);
        case 14: ApplyAnimation(playerid, "CAMERA", "picstnd_take", 4.1, 0, 0, 0, 1, 0);
        default: Usage(playerid,"{ffffff}/camera [1-14]");
    }

    return 1;
}

CMD:lay(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/lay [1-3]");
    }

    return 1;
}

CMD:fall(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0);
        case 2: ApplyAnimation(playerid, "PED", "KO_skid_back", 4.1, 0, 0, 0, 1, 0);
        case 3: ApplyAnimation(playerid, "PED", "KO_shot_face", 4.1, 0, 1, 1, 1, 0, 1);
        case 4: ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 1, 1, 1, 0, 1);
        case 5: ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.1, 0, 1, 1, 1, 0, 1);
        case 6: ApplyAnimation(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 0, 0);
        default: Usage(playerid,"/fall [1-6]");
    }

    return 1;
}

CMD:handsup(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "SHOP", "SHP_HandsUp_Scr", 4.1, 0, 0, 0, 1, 0);
    return 1;
}

CMD:tired(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/tired [1-2]");
    }

    return 1;
}

CMD:hide(playerid, params[])
{
    return callcmd::cower(playerid, params);
}

CMD:cover(playerid, params[])
{
    return callcmd::cower(playerid, params);
}

CMD:cower(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "PED", "cower", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:crack(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0);
        case 2: ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0);
        case 4: ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0);
        default: Usage(playerid,"/crack [1-4]");
    }

    return 1;
}

CMD:injured(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/injured [1-2]");
    }

    return 1;
}

CMD:fishing(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "SAMP", "FishingIdle", 4.1, 0, 0, 0, 1, 0);
    return 1;
}

CMD:reload(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "RIFLE", "RIFLE_load", 4.1, 0, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/reload [1-4]");
    }

    return 1;
}

CMD:aim(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "SHOP", "ROB_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0);
        default: Usage(playerid,"/aim [1-2]");
    }

    return 1;
}

CMD:bomb(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:checktime(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:dodge(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:stop(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "PED", "endchat_01", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:scratch(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "MISC", "Scratchballs_01", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:what(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:wash(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:come(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "WUZI", "Wuzi_follow", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:hitch(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "MISC", "Hiker_Pose", 4.1, 0, 0, 0, 1, 0);
    return 1;
}

CMD:cpr(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:slapass(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:drunk(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
    return 1;
}

CMD:vomit(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:fucku(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:taichi(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:shifty(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:smoke(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/smoke [1-2]");
    }

    return 1;
}

CMD:chat(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1, 1);
        case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 1, 1, 1, 1, 1, 1);
        case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.1, 1, 1, 1, 1, 1, 1);
        case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkC", 4.1, 1, 1, 1, 1, 1, 1);
        case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.1, 1, 1, 1, 1, 1, 1);
        case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 1, 1, 1, 1, 1, 1);
        case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.1, 1, 1, 1, 1, 1, 1);
        case 8: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.1, 1, 1, 1, 1, 1, 1);
        case 9: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.1, 1, 1, 1, 1, 1, 1);
        default: Usage(playerid,"/chat [1-9]");
    }

    return 1;
}

CMD:lean(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "GANGS", "leanIDLE", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "MISC", "Plyrlean_loop", 4.1, 1, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/lean [1-2]");
    }

    return 1;
}

CMD:wank(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:traffic(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "POLICE", "CopTraf_Stop", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "POLICE", "CopTraf_Come", 4.1, 0, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/traffic [1-2]");
    }

    return 1;
}

CMD:rap(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "RAPPING", "RAP_A_LOOP", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "RAPPING", "RAP_B_LOOP", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "RAPPING", "RAP_C_LOOP", 4.1, 1, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/rap [1-3]");
    }

    return 1;
}

CMD:dj(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "SCRATCHING", "scdldlp", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "SCRATCHING", "scdlulp", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "SCRATCHING", "scdrdlp", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "SCRATCHING", "scdrulp", 4.1, 1, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/dj [1-4]");
    }

    return 1;
}

CMD:crossarms(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/crossarms [1-3]");
    }

    return 1;
}

CMD:ghands(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimation(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0, 1);
        case 5: ApplyAnimation(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0, 1);
        case 6: ApplyAnimation(playerid, "GHANDS", "gsign3LH", 4.1, 0, 0, 0, 0, 0, 1);
        case 7: ApplyAnimation(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0, 1);
        case 8: ApplyAnimation(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0, 1);
        case 9: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
        case 10: ApplyAnimation(playerid, "GHANDS", "gsign5LH", 4.1, 0, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/ghands [1-10]");
    }

    return 1;
}

CMD:walk(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1, 1);
        case 2: ApplyAnimation(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1, 1);
        case 3: ApplyAnimation(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1, 1);
        case 4: ApplyAnimation(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1, 1);
        case 5: ApplyAnimation(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1, 1);
        case 6: ApplyAnimation(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1, 1);
        case 7: ApplyAnimation(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1, 1);
        case 8: ApplyAnimation(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1, 1);
        case 9: ApplyAnimation(playerid, "PED", "WALK_shuffle", 4.1, 1, 1, 1, 1, 1, 1);
        case 10: ApplyAnimation(playerid, "PED", "WALK_Wuzi", 4.1, 1, 1, 1, 1, 1, 1);
        case 11: ApplyAnimation(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1, 1);
        case 12: ApplyAnimation(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1, 1);
        case 13: ApplyAnimation(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1, 1);
        case 14: ApplyAnimation(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1, 1);
        case 15: ApplyAnimation(playerid, "PED", "WOMAN_walkpro", 4.1, 1, 1, 1, 1, 1, 1);
        default: Usage(playerid,"/walk [1-15]");
    }

    return 1;
}

CMD:fuckme(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "SNM", "SPANKING_IDLEW", 4.1, 0, 1, 1, 1, 0, 1);
        case 2: ApplyAnimation(playerid, "SNM", "SPANKING_IDLEP", 4.1, 0, 1, 1, 1, 0, 1);
        case 3: ApplyAnimation(playerid, "SNM", "SPANKINGW", 4.1, 0, 1, 1, 1, 0, 1);
        case 4: ApplyAnimation(playerid, "SNM", "SPANKINGP", 4.1, 0, 1, 1, 1, 0, 1);
        case 5: ApplyAnimation(playerid, "SNM", "SPANKEDW", 4.1, 0, 1, 1, 1, 0, 1);
        case 6: ApplyAnimation(playerid, "SNM", "SPANKEDP", 4.1, 0, 1, 1, 1, 0, 1);
        case 7: ApplyAnimation(playerid, "SNM", "SPANKING_ENDW", 4.1, 0, 1, 1, 1, 0, 1);
        case 8: ApplyAnimation(playerid, "SNM", "SPANKING_ENDP", 4.1, 0, 1, 1, 1, 0, 1);
        default: Usage(playerid,"/fuckme [1-8]");
    }

    return 1;
}

CMD:bj(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_START_P", 4.1, 0, 1, 1, 1, 0, 1);
        case 2: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_START_W", 4.1, 0, 1, 1, 1, 0, 1);
        case 3: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 0, 1, 1, 1, 0, 1);
        case 4: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 0, 1, 1, 1, 0, 1);
        case 5: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_END_P", 4.1, 0, 1, 1, 1, 0, 1);
        case 6: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_END_W", 4.1, 0, 1, 1, 1, 0, 1);
        case 7: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_START_P", 4.1, 0, 1, 1, 1, 0, 1);
        case 8: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_START_W", 4.1, 0, 1, 1, 1, 0, 1);
        case 9: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
        case 10: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
        case 11: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_END_P", 4.1, 0, 1, 1, 1, 0, 1);
        case 12: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_END_W", 4.1, 0, 1, 1, 1, 0, 1);
        default: Usage(playerid,"/bj [1-12]");
    }

    return 1;
}

CMD:kiss(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:robman(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:eat(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
		return Error(playerid, "You can't do at this moment.");

    switch(strval(params))
    {
        case 1: ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 0, 0, 0, 0, 1);
        default: Usage(playerid,"/eat [1-3]");
    }

    return 1;
}

CMD:stopani(playerid, params[])
{
    return callcmd::stopanim(playerid, params);
}

CMD:stopanim(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) 
        return Error(playerid, "You can't do at this moment.");

    if(gettime() - pData[playerid][pLastStuck] < 5)
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 5 seconds.");

    new
        Float:x,
        Float:y,
        Float:z;

    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(playerid, x, y, z + 0.5);

    ClearAnimations(playerid);
    StopLoopingAnim(playerid);
    TogglePlayerControllable(playerid, 1);

    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
    //SendClientMessage(playerid, COLOR_GREY, "You are no longer stuck.");

    pData[playerid][pLastStuck] = gettime();
    return 1;
}