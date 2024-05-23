#include <YSI\y_hooks>
/* var */
new PlayerText: PROGRESSBAR[MAX_PLAYERS][4];
new LoadingPlayerBar[MAX_PLAYERS];
new TimerLoading[MAX_PLAYERS];
new ProgressTimer[MAX_PLAYERS][128];
/* Hide TD */
HideProgressBar(playerid)
{
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][0]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][1]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][2]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][3]);
	return 1;
}
/* Create TD */
CreateProgress(playerid)
{
	PROGRESSBAR[playerid][0] = CreatePlayerTextDraw(playerid, 258.000, 351.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][0], 114.000, 30.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][0], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][0], 809733375);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][0], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][0], 1);

	PROGRESSBAR[playerid][1] = CreatePlayerTextDraw(playerid, 260.000, 354.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][1], 110.000, 25.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][1], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][1], -1448498689);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][1], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][1], 1);

	PROGRESSBAR[playerid][2] = CreatePlayerTextDraw(playerid, 260.000, 354.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][2], 110.000, 25.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][2], 1687547391);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][2], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][2], 1);

	PROGRESSBAR[playerid][3] = CreatePlayerTextDraw(playerid, 315.000, 359.000, "Meleburkan Batuan...");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][3], 0.240, 1.399);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][3], 0.000, 105.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][3], 2);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][3], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][3], 1);
	return 1;
}
/* Hook OnPlayerConnect */
hook OnPlayerConnect(playerid)
{
	CreateProgress(playerid);
	return 1;
}
/* Func */
ShowProgressbar(playerid, text[] = "", Times)
{	
	if(pData[playerid][pProgress] > 0) return 1;
	LoadingPlayerBar[playerid] = 0;
	pData[playerid][pProgress] = 1;
	new Float:Value = LoadingPlayerBar[playerid]*110.0/100;
	new Timer = Times*1000/100;
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][2], Value, 25.0);
	PlayerTextDrawSetString(playerid, PROGRESSBAR[playerid][3], text);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][0]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][1]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][2]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][3]);
	TogglePlayerControllable(playerid, 0);
	TimerLoading[playerid] = SetTimerEx("UpdtLoading", Timer, true, "d", playerid);
	return 1;
}

stock UpdateLoading(playerid)
{
	new Float:Value = LoadingPlayerBar[playerid]*110.00/100;
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][2], Value, 25.0);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][2]);
	return 1;
}

forward UpdtLoading(playerid);
public UpdtLoading(playerid)
{
	LoadingPlayerBar[playerid] += 1;
	UpdateLoading(playerid);
	if(LoadingPlayerBar[playerid] >= 100)
	{
		KillTimer(TimerLoading[playerid]);
		LoadingPlayerBar[playerid] = 0;
		pData[playerid][pProgress] = 0;
		HideProgressBar(playerid);
		SetTimerEx(ProgressTimer[playerid], 300, false, "d", playerid);
		TogglePlayerControllable(playerid, 1);
	}
	return 1;
}
CMD:testprog(playerid, params[])
{
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda sedang melakukan activity progress");
	ShowProgressbar(playerid, "Genzo Ganteng", 3);
	return 1;
}