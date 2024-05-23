

#include <YSI_Coding\y_hooks.inc>
#include <YSI\y_iterate>

#define MAX_ANTICHEAT_WARNINGS   	3

new SilentAimCount[MAX_PLAYERS],ProAimCount[MAX_PLAYERS],TintaApasata[MAX_PLAYERS];

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(weaponid != 38 && weaponid > 18 && weaponid < 34 && hittype == 1)
	{
		new Float:cood[6],Float:DistanceAim;
		GetPlayerPos(hitid, cood[0], cood[1], cood[2]); 
		DistanceAim = GetPlayerDistanceFromPoint(playerid, cood[0], cood[1], cood[2]);
		
		if(GetPlayerTargetPlayer(playerid) == INVALID_PLAYER_ID && DistanceAim > 1 && DistanceAim < 31 && TintaApasata[playerid] == 1)
		{
			SilentAimCount[playerid]++;
			if(SilentAimCount[playerid] == 5)
			{
				SendAdminMessage(COLOR_RED, "%s(%d) possible use Silent Aim cheat with %s (Distance: %i meters)", ReturnName(playerid), playerid, ReturnWeaponName(weaponid), floatround(DistanceAim));
			}
			if(SilentAimCount[playerid] >= 10)
			{
				SilentAimCount[playerid] = 0;
				SendClientMessageToAllEx(COLOR_RED, "BotCmd: %s have been auto kicked for Silent Aim hacks!", pData[playerid][pName]);
			}
			return 1;
		}
		GetPlayerLastShotVectors(playerid, cood[0], cood[1], cood[2], cood[3], cood[4], cood[5]);
		if(!IsPlayerInRangeOfPoint(hitid, 3.0, cood[3], cood[4], cood[5])) 
		{
			ProAimCount[playerid]++;
			if(ProAimCount[playerid] == 3)
			{
				SendAdminMessage(COLOR_RED, "%s(%d) possible use ProAim cheat with: %s (Distance: %i meters)", ReturnName(playerid), playerid, ReturnWeaponName(weaponid), floatround(DistanceAim));
			}
			if(ProAimCount[playerid] >= 5)
			{
				ProAimCount[playerid] = 0;
				SendClientMessageToAllEx(COLOR_RED, "BotCmd: %s have been auto kicked for Pro Aim hacks!", pData[playerid][pName]);
			}
		}
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
	if(newkeys & KEY_HANDBRAKE && !IsPlayerInAnyVehicle(playerid))
	{
		TintaApasata[playerid] = 1;
	}
	else if(oldkeys & KEY_HANDBRAKE)
	{
	 	TintaApasata[playerid] = 0;
	}
	return 1;
}


//=========================[ ANTI CHEAT NEX AC ]
