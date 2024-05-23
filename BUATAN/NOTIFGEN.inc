enum eNotify
{
	NotifyIcon,
	NotifyMessage[300],
	NotifySize
}
new InfoNotify[MAX_PLAYERS][7][eNotify];
new MaxPlayerNotify[MAX_PLAYERS];
new PlayerText:TextDrawNotifikasi[MAX_PLAYERS][7*10];
new PlayerText:TextDrawNotifikasiLoding[MAX_PLAYERS][7*10];
new IndexNotify[MAX_PLAYERS];
new LoadingNotif[MAX_PLAYERS];

function HideNotify(playerid)
{
	if(!IndexNotify[playerid]) return 1;
	--IndexNotify[playerid];
	MaxPlayerNotify[playerid]--;
	for(new i=-1;++i<10;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasi[playerid][(IndexNotify[playerid]*10)+i]);
	for(new i=-1;++i<10;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasiLoding[playerid][(IndexNotify[playerid]*10)+i]);
	return 1;
}
function NotifyLoadingUpdet(playerid)
{
	if(!IndexNotify[playerid]) return 1;
	for(new x=-1; ++x <IndexNotify[playerid];)
	{
		new Float:Value = LoadingNotif[playerid] * 109/110;
		for(new i=-1;++i<9;) PlayerTextDrawTextSize(playerid, TextDrawNotifikasiLoding[playerid][(x*10)+i], Value, -3.0);
		for(new i=-1;++i<9;) PlayerTextDrawShow(playerid, TextDrawNotifikasiLoding[playerid][(x*10)+i]);
	}
	return 1;
}
function NotifyLoading(playerid)
{
    for(new x=-1; ++x <IndexNotify[playerid];)
	{
	    LoadingNotif[x] -= 10;
		NotifyLoadingUpdet(x);
		if(LoadingNotif[x] <= 5)
		{
			LoadingNotif[x] = 109;
		}
	}
	return 1;
}
stock InfoMsg(playerid, pesan[])
{
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	ShowNotify(playerid, pesan, 1);
  	return 1;
}
stock ErrorMsg(playerid, pesan[])
{
	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	ShowNotify(playerid, pesan, 2);
 	return 1;
}
stock SuccesMsg(playerid, pesan[])
{
    if(IsPlayerAndroid(playerid))
	{
		PlayerPlaySound(playerid, 5203, 0.0, 0.0, 0.0);
	}
	else
	{
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	ShowNotify(playerid, pesan, 3);
  	return 1;
}
stock SyntaxMsg(playerid, pesan[])
{
 	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	ShowNotify(playerid, pesan, 4);
  	return 1;
}

stock WarningMsg(playerid, pesan[])
{
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	ShowNotify(playerid, pesan, 5);
  	return 1;
}

stock ShowNotify(const playerid, const string:message[], const icon)
{
	if(MaxPlayerNotify[playerid] == 6) return 1;
	MaxPlayerNotify[playerid]++;
	for(new x=-1; ++x <IndexNotify[playerid];)
	{
		for(new i=-1;++i<9;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasi[playerid][(x*10) + i]);
		for(new i=-1;++i<9;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasiLoding[playerid][(x*10) + i]);
		InfoNotify[playerid][IndexNotify[playerid]-x] = InfoNotify[playerid][(IndexNotify[playerid]-x)-1];
	}
	format(InfoNotify[playerid][0][NotifyMessage], 300, "%s", message);
	InfoNotify[playerid][0][NotifyIcon] = icon;
	InfoNotify[playerid][0][NotifySize] = 3;
	++IndexNotify[playerid];
	new Float:new_x=0.0;
	for(new x=-1;++x<IndexNotify[playerid];)
	{
		CreateNotify(playerid, x, x * 10, new_x);
		new_x += (InfoNotify[playerid][x][NotifySize]*7.25)+20.0;
	}
	SetTimerEx("HideNotify", 10000, false, "d", playerid);
	return 1;
}

stock CreateNotify(const playerid, index, i, const Float:new_x)
{
	new lines = InfoNotify[playerid][index][NotifySize];
	new Float:x = (lines * 10) + new_x;
	new Float:posisibaru = x-55.0;
	if(InfoNotify[playerid][index][NotifyIcon] == 1)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 504.000, 186.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 37.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 507.000, 185.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 13.000, 15.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 186.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.000, 13.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 65535);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 512.000, 187.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.328, 1.098);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 188.000+posisibaru, "INFO");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.216, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1097458175);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 200.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.170, 0.898);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 617.000, 0.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 182.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 4.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 52735);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 2)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 504.000, 186.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 37.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 510.000, 187.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 18.000, 5.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1134995201);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 510.000, 193.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 18.000, 5.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1134995201);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 188.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 5.000, 3.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 194.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 5.000, 3.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 529.000, 188.000+posisibaru, "ERROR");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.218, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1134995201);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 200.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.140, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 616.000, 0.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 182.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 4.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1134995201);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 3)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 504.000, 186.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 37.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 507.000, 185.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 13.000, 15.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 186.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.000, 13.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 555819519);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 513.000, 189.000+posisibaru, "/");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.159, 0.597);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 514.000, 191.000+posisibaru, "/");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], -0.200, 0.296);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 188.000+posisibaru, "SUCCESS");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.217, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 201.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.140, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 617.000, 0.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 182.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 4.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

	}
	if(InfoNotify[playerid][index][NotifyIcon] == 4)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 504.000, 186.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 37.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 507.000, 185.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 13.000, 15.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 186.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.000, 13.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 512.000, 200.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.328, -1.502);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 0.000, -13.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -602653441);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 519.000, 188.000+posisibaru, "SYNTAX");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.216, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -602653441);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 200.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.170, 0.898);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 617.000, 0.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 182.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 4.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -602653441);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 5)//warning
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 504.000, 186.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 37.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 507.000, 185.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 13.000, 15.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 186.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.000, 13.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 876232703);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 512.000, 200.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.328, -1.502);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 0.000, -13.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -626712321);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i]= CreatePlayerTextDraw(playerid, 519.000, 188.000+posisibaru, "WARNING");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][4], 0.216, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][4], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][4], -626712321);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][4], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][4], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][4], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][4], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][4], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 200.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.170, 0.898);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 617.000, 0.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 182.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 115.000, 4.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -626712321);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	return true;
}
