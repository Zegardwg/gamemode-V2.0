#include <YSI_Coding\y_hooks>

#define 	BOXCOLOR_GREEN		9109759
#define 	BOXCOLOR_BLUE		1098776575
#define 	BOXCOLOR_RED		-1962934017

#define 	MAX_NOTIFY 		(6)
#define 	MAX_NT_STRING 	(320)
#define 	MAX_NT_TITLE 	(64)
#define 	SECONDS_NT 		(3)

enum ntInfo { ntIcon[32], ntTitle[MAX_NT_TITLE], ntMessage[MAX_NT_STRING], ntLines, ntColor }
static notifyInfo[MAX_PLAYERS][MAX_NOTIFY][ntInfo],
Text:notifyPTD[MAX_NOTIFY * 10],
notifyIndex[MAX_PLAYERS];

#define notify::%0(%1) forward %0(%1); public %0(%1)
#define InternalNotification_show InternalNotification_Show
#define notification.	InternalNotification_

static const TDTextCaracterWidth[] = {
	0,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
	12,12,12,12,12,12,12,13,13,28,28,28,28,8,17,17,30,28,28,12,9,21,28,14,28,28,
	28,28,28,28,28,28,13,13,30,30,30,30,10,25,23,21,24,22,20,24,24,17,20,22,20,
	30,27,27,26,26,24,23,24,31,23,31,24,23,21,28,33,33,14,28,10,11,12,9,11,10,
	10,12,12,7,7,13,5,18,12,10,12,11,10,12,8,13,13,18,17,13,12,30,30,37,35,37,
	25,25,25,25,33,21,24,24,24,24,17,17,17,17,27,27,27,27,31,31,31,31,11,11,11,
	11,11,20,9,10,10,10,10,7,7,7,7,10,10,10,10,13,13,13,13,27,12,30
};

new PlayerText: INFOTD[MAX_PLAYERS][6];
new PlayerText: SUCCESSTD[MAX_PLAYERS][7];
new PlayerText: ERRORTD[MAX_PLAYERS][8];
new PlayerText: SYNTAXTD[MAX_PLAYERS][5];
new PlayerText: WARNINGTD[MAX_PLAYERS][5];

new InfoBar[MAX_PLAYERS];
new InfoTimer[MAX_PLAYERS];
new SuksesBar[MAX_PLAYERS];
new SuksesTimer[MAX_PLAYERS];
new ErrorBar[MAX_PLAYERS];
new ErrorTimer[MAX_PLAYERS];
new SyntaxBar[MAX_PLAYERS];
new SyntaxTimer[MAX_PLAYERS];
new WarningBar[MAX_PLAYERS];
new WarningTimer[MAX_PLAYERS];

CreateBarWarn(playerid)
{
	WARNINGTD[playerid][0] = CreatePlayerTextDraw(playerid, 510.000, 303.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, WARNINGTD[playerid][0], 104.000, 38.000);
	PlayerTextDrawAlignment(playerid, WARNINGTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, WARNINGTD[playerid][0], 943210495);
	PlayerTextDrawSetShadow(playerid, WARNINGTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, WARNINGTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, WARNINGTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, WARNINGTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, WARNINGTD[playerid][0], 1);

	WARNINGTD[playerid][1] = CreatePlayerTextDraw(playerid, 520.000, 305.000, "!");
	PlayerTextDrawLetterSize(playerid, WARNINGTD[playerid][1], 0.280, 1.199);
	PlayerTextDrawAlignment(playerid, WARNINGTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, WARNINGTD[playerid][1], -2686721);
	PlayerTextDrawSetShadow(playerid, WARNINGTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, WARNINGTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, WARNINGTD[playerid][1], 150);
	PlayerTextDrawFont(playerid, WARNINGTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, WARNINGTD[playerid][1], 1);

	WARNINGTD[playerid][2] = CreatePlayerTextDraw(playerid, 526.000, 306.000, "WARNING");
	PlayerTextDrawLetterSize(playerid, WARNINGTD[playerid][2], 0.189, 0.999);
	PlayerTextDrawAlignment(playerid, WARNINGTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, WARNINGTD[playerid][2], -2686721);
	PlayerTextDrawSetShadow(playerid, WARNINGTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, WARNINGTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, WARNINGTD[playerid][2], 150);
	PlayerTextDrawFont(playerid, WARNINGTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, WARNINGTD[playerid][2], 1);

	WARNINGTD[playerid][3] = CreatePlayerTextDraw(playerid, 514.000, 316.000, "scriptnya kaga ada mangkanya luwh cek dc aowkaokw asal asalan si");
	PlayerTextDrawLetterSize(playerid, WARNINGTD[playerid][3], 0.133, 0.949);
	PlayerTextDrawTextSize(playerid, WARNINGTD[playerid][3], 610.000, 21.000);
	PlayerTextDrawAlignment(playerid, WARNINGTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, WARNINGTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, WARNINGTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, WARNINGTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, WARNINGTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, WARNINGTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, WARNINGTD[playerid][3], 1);

	WARNINGTD[playerid][4] = CreatePlayerTextDraw(playerid, 510.000, 300.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, WARNINGTD[playerid][4], 104.000, 3.000);
	PlayerTextDrawAlignment(playerid, WARNINGTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, WARNINGTD[playerid][4], -2686721);
	PlayerTextDrawSetShadow(playerid, WARNINGTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, WARNINGTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, WARNINGTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, WARNINGTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, WARNINGTD[playerid][4], 1);

}
CreateBarInfo(playerid)
{
	INFOTD[playerid][0] = CreatePlayerTextDraw(playerid, 510.000, 127.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INFOTD[playerid][0], 104.000, 38.000);
	PlayerTextDrawAlignment(playerid, INFOTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, INFOTD[playerid][0], 943210495);
	PlayerTextDrawSetShadow(playerid, INFOTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, INFOTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, INFOTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, INFOTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, INFOTD[playerid][0], 1);

	INFOTD[playerid][1] = CreatePlayerTextDraw(playerid, 513.000, 127.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, INFOTD[playerid][1], 16.000, 16.000);
	PlayerTextDrawAlignment(playerid, INFOTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, INFOTD[playerid][1], 1300478207);
	PlayerTextDrawSetShadow(playerid, INFOTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, INFOTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, INFOTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, INFOTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, INFOTD[playerid][1], 1);

	INFOTD[playerid][2] = CreatePlayerTextDraw(playerid, 520.000, 129.000, "i");
	PlayerTextDrawLetterSize(playerid, INFOTD[playerid][2], 0.280, 1.199);
	PlayerTextDrawAlignment(playerid, INFOTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, INFOTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, INFOTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, INFOTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, INFOTD[playerid][2], 150);
	PlayerTextDrawFont(playerid, INFOTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, INFOTD[playerid][2], 1);

	INFOTD[playerid][3] = CreatePlayerTextDraw(playerid, 529.000, 130.000, "INFO");
	PlayerTextDrawLetterSize(playerid, INFOTD[playerid][3], 0.189, 0.999);
	PlayerTextDrawAlignment(playerid, INFOTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, INFOTD[playerid][3], 1300478207);
	PlayerTextDrawSetShadow(playerid, INFOTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, INFOTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, INFOTD[playerid][3], 150);
	PlayerTextDrawFont(playerid, INFOTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, INFOTD[playerid][3], 1);

	INFOTD[playerid][4] = CreatePlayerTextDraw(playerid, 514.000, 140.000, "scriptnya kaga ada mangkanya luwh cek dc aowkaokw asal asalan si");
	PlayerTextDrawLetterSize(playerid, INFOTD[playerid][4], 0.133, 0.949);
	PlayerTextDrawTextSize(playerid, INFOTD[playerid][4], 610.000, 21.000);
	PlayerTextDrawAlignment(playerid, INFOTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, INFOTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, INFOTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, INFOTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, INFOTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, INFOTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, INFOTD[playerid][4], 1);

	INFOTD[playerid][5] = CreatePlayerTextDraw(playerid, 510.000, 124.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INFOTD[playerid][5], 104.000, 3.000);
	PlayerTextDrawAlignment(playerid, INFOTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, INFOTD[playerid][5], 1300478207);
	PlayerTextDrawSetShadow(playerid, INFOTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, INFOTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, INFOTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, INFOTD[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, INFOTD[playerid][5], 1);
}
CreateBarSukses(playerid)
{
	SUCCESSTD[playerid][0] = CreatePlayerTextDraw(playerid, 510.000, 171.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, SUCCESSTD[playerid][0], 104.000, 38.000);
	PlayerTextDrawAlignment(playerid, SUCCESSTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, SUCCESSTD[playerid][0], 943210495);
	PlayerTextDrawSetShadow(playerid, SUCCESSTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, SUCCESSTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, SUCCESSTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, SUCCESSTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, SUCCESSTD[playerid][0], 1);

	SUCCESSTD[playerid][1] = CreatePlayerTextDraw(playerid, 513.000, 171.000, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, SUCCESSTD[playerid][1], 16.000, 16.000);
	PlayerTextDrawAlignment(playerid, SUCCESSTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, SUCCESSTD[playerid][1], 1018393087);
	PlayerTextDrawSetShadow(playerid, SUCCESSTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, SUCCESSTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, SUCCESSTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, SUCCESSTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, SUCCESSTD[playerid][1], 1);

	SUCCESSTD[playerid][2] = CreatePlayerTextDraw(playerid, 520.000, 174.000, "/");
	PlayerTextDrawLetterSize(playerid, SUCCESSTD[playerid][2], 0.259, 0.699);
	PlayerTextDrawAlignment(playerid, SUCCESSTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, SUCCESSTD[playerid][2], 1768516095);
	PlayerTextDrawSetShadow(playerid, SUCCESSTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, SUCCESSTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, SUCCESSTD[playerid][2], 150);
	PlayerTextDrawFont(playerid, SUCCESSTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, SUCCESSTD[playerid][2], 1);

	SUCCESSTD[playerid][3] = CreatePlayerTextDraw(playerid, 521.000, 177.000, "/");
	PlayerTextDrawLetterSize(playerid, SUCCESSTD[playerid][3], -0.199, 0.398);
	PlayerTextDrawAlignment(playerid, SUCCESSTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, SUCCESSTD[playerid][3], 1768516095);
	PlayerTextDrawSetShadow(playerid, SUCCESSTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, SUCCESSTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, SUCCESSTD[playerid][3], 150);
	PlayerTextDrawFont(playerid, SUCCESSTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, SUCCESSTD[playerid][3], 1);

	SUCCESSTD[playerid][4] = CreatePlayerTextDraw(playerid, 529.000, 174.000, "SUCCESS");
	PlayerTextDrawLetterSize(playerid, SUCCESSTD[playerid][4], 0.189, 0.999);
	PlayerTextDrawAlignment(playerid, SUCCESSTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, SUCCESSTD[playerid][4], 1018393087);
	PlayerTextDrawSetShadow(playerid, SUCCESSTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, SUCCESSTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, SUCCESSTD[playerid][4], 150);
	PlayerTextDrawFont(playerid, SUCCESSTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, SUCCESSTD[playerid][4], 1);

	SUCCESSTD[playerid][5] = CreatePlayerTextDraw(playerid, 514.000, 184.000, "scriptnya kaga ada mangkanya luwh cek dc aowkaokw asal asalan si");
	PlayerTextDrawLetterSize(playerid, SUCCESSTD[playerid][5], 0.133, 0.949);
	PlayerTextDrawTextSize(playerid, SUCCESSTD[playerid][5], 610.000, 21.000);
	PlayerTextDrawAlignment(playerid, SUCCESSTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, SUCCESSTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, SUCCESSTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, SUCCESSTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, SUCCESSTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, SUCCESSTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, SUCCESSTD[playerid][5], 1);

	SUCCESSTD[playerid][6] = CreatePlayerTextDraw(playerid, 510.000, 168.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, SUCCESSTD[playerid][6], 104.000, 3.000);
	PlayerTextDrawAlignment(playerid, SUCCESSTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, SUCCESSTD[playerid][6], 1018393087);
	PlayerTextDrawSetShadow(playerid, SUCCESSTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, SUCCESSTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, SUCCESSTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, SUCCESSTD[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, SUCCESSTD[playerid][6], 1);
}
CreateBarError(playerid)
{
	ERRORTD[playerid][0] = CreatePlayerTextDraw(playerid, 510.000, 215.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][0], 104.000, 38.000);
	PlayerTextDrawAlignment(playerid, ERRORTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, ERRORTD[playerid][0], 943210495);
	PlayerTextDrawSetShadow(playerid, ERRORTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, ERRORTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, ERRORTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, ERRORTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, ERRORTD[playerid][0], 1);

	ERRORTD[playerid][1] = CreatePlayerTextDraw(playerid, 513.000, 217.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][1], 17.000, 5.000);
	PlayerTextDrawAlignment(playerid, ERRORTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, ERRORTD[playerid][1], -1052226817);
	PlayerTextDrawSetShadow(playerid, ERRORTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, ERRORTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, ERRORTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, ERRORTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, ERRORTD[playerid][1], 1);

	ERRORTD[playerid][2] = CreatePlayerTextDraw(playerid, 513.000, 223.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][2], 17.000, 5.000);
	PlayerTextDrawAlignment(playerid, ERRORTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, ERRORTD[playerid][2], -1052226817);
	PlayerTextDrawSetShadow(playerid, ERRORTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, ERRORTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, ERRORTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, ERRORTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, ERRORTD[playerid][2], 1);

	ERRORTD[playerid][3] = CreatePlayerTextDraw(playerid, 532.000, 218.000, "ERROR");
	PlayerTextDrawLetterSize(playerid, ERRORTD[playerid][3], 0.189, 0.999);
	PlayerTextDrawAlignment(playerid, ERRORTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, ERRORTD[playerid][3], -1052226817);
	PlayerTextDrawSetShadow(playerid, ERRORTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, ERRORTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, ERRORTD[playerid][3], 150);
	PlayerTextDrawFont(playerid, ERRORTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, ERRORTD[playerid][3], 1);

	ERRORTD[playerid][4] = CreatePlayerTextDraw(playerid, 514.000, 228.000, "scriptnya kaga ada mangkanya luwh cek dc aowkaokw asal asalan si");
	PlayerTextDrawLetterSize(playerid, ERRORTD[playerid][4], 0.133, 0.949);
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][4], 610.000, 21.000);
	PlayerTextDrawAlignment(playerid, ERRORTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, ERRORTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, ERRORTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, ERRORTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, ERRORTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, ERRORTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, ERRORTD[playerid][4], 1);

	ERRORTD[playerid][5] = CreatePlayerTextDraw(playerid, 522.000, 218.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][5], 7.000, 3.000);
	PlayerTextDrawAlignment(playerid, ERRORTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, ERRORTD[playerid][5], 943210495);
	PlayerTextDrawSetShadow(playerid, ERRORTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, ERRORTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, ERRORTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, ERRORTD[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, ERRORTD[playerid][5], 1);

	ERRORTD[playerid][6] = CreatePlayerTextDraw(playerid, 522.000, 224.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][6], 7.000, 3.000);
	PlayerTextDrawAlignment(playerid, ERRORTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, ERRORTD[playerid][6], 943210495);
	PlayerTextDrawSetShadow(playerid, ERRORTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, ERRORTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, ERRORTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, ERRORTD[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, ERRORTD[playerid][6], 1);

	ERRORTD[playerid][7] = CreatePlayerTextDraw(playerid, 510.000, 212.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][7], 104.000, 3.000);
	PlayerTextDrawAlignment(playerid, ERRORTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, ERRORTD[playerid][7], -1052226817);
	PlayerTextDrawSetShadow(playerid, ERRORTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, ERRORTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, ERRORTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, ERRORTD[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, ERRORTD[playerid][7], 1);
}

CreateBarSyntax(playerid)
{
	SYNTAXTD[playerid][0] = CreatePlayerTextDraw(playerid, 510.000, 259.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, SYNTAXTD[playerid][0], 104.000, 38.000);
	PlayerTextDrawAlignment(playerid, SYNTAXTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, SYNTAXTD[playerid][0], 943210495);
	PlayerTextDrawSetShadow(playerid, SYNTAXTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, SYNTAXTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, SYNTAXTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, SYNTAXTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, SYNTAXTD[playerid][0], 1);

	SYNTAXTD[playerid][1] = CreatePlayerTextDraw(playerid, 520.000, 261.000, "!");
	PlayerTextDrawLetterSize(playerid, SYNTAXTD[playerid][1], 0.280, 1.199);
	PlayerTextDrawAlignment(playerid, SYNTAXTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, SYNTAXTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, SYNTAXTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, SYNTAXTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, SYNTAXTD[playerid][1], 150);
	PlayerTextDrawFont(playerid, SYNTAXTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, SYNTAXTD[playerid][1], 1);

	SYNTAXTD[playerid][2] = CreatePlayerTextDraw(playerid, 527.000, 262.000, "SYNTAX");
	PlayerTextDrawLetterSize(playerid, SYNTAXTD[playerid][2], 0.189, 0.999);
	PlayerTextDrawAlignment(playerid, SYNTAXTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, SYNTAXTD[playerid][2], -1448498689);
	PlayerTextDrawSetShadow(playerid, SYNTAXTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, SYNTAXTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, SYNTAXTD[playerid][2], 150);
	PlayerTextDrawFont(playerid, SYNTAXTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, SYNTAXTD[playerid][2], 1);

	SYNTAXTD[playerid][3] = CreatePlayerTextDraw(playerid, 514.000, 271.000, "scriptnya kaga ada mangkanya luwh cek dc aowkaokw asal asalan si");
	PlayerTextDrawLetterSize(playerid, SYNTAXTD[playerid][3], 0.133, 0.949);
	PlayerTextDrawTextSize(playerid, SYNTAXTD[playerid][3], 610.000, 21.000);
	PlayerTextDrawAlignment(playerid, SYNTAXTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, SYNTAXTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, SYNTAXTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, SYNTAXTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, SYNTAXTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, SYNTAXTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, SYNTAXTD[playerid][3], 1);

	SYNTAXTD[playerid][4] = CreatePlayerTextDraw(playerid, 510.000, 256.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, SYNTAXTD[playerid][4], 104.000, 3.000);
	PlayerTextDrawAlignment(playerid, SYNTAXTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, SYNTAXTD[playerid][4], -1448498689);
	PlayerTextDrawSetShadow(playerid, SYNTAXTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, SYNTAXTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, SYNTAXTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, SYNTAXTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, SYNTAXTD[playerid][4], 1);
}
HideWARNINGTD(playerid)
{
	for(new txd; txd < 5; txd++)
	{
		PlayerTextDrawHide(playerid, WARNINGTD[playerid][txd]);
	}
	return 1;
}
ShowWARNINGTD(playerid)
{
	for(new txd; txd < 5; txd++)
	{
		PlayerTextDrawShow(playerid, WARNINGTD[playerid][txd]);
	}
	PlayerPlaySound(playerid, 1507, 0.0, 0.0, 0.0);
	return 1;
}
HideERRORTD(playerid)
{
	for(new txd; txd < 8; txd++)
	{
		PlayerTextDrawHide(playerid, ERRORTD[playerid][txd]);
	}
}
ShowERRORTD(playerid)
{
	for(new txd; txd < 8; txd++)
	{
		PlayerTextDrawShow(playerid, ERRORTD[playerid][txd]);
	}
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
}
HideSYNTAXTD(playerid)
{
	for(new txd; txd < 5; txd++)
	{
		PlayerTextDrawHide(playerid, SYNTAXTD[playerid][txd]);
	}
	return 1;
}
ShowSYNTAXTD(playerid)
{
	for(new txd; txd < 5; txd++)
	{
		PlayerTextDrawShow(playerid, SYNTAXTD[playerid][txd]);
	}
	PlayerPlaySound(playerid, 5201, 0.0, 0.0, 0.0);
	return 1;
}
HideINFOTD(playerid)
{
	for(new txd; txd < 6; txd++)
	{
		PlayerTextDrawHide(playerid, INFOTD[playerid][txd]);
	}
	return 1;
}

ShowINFOTD(playerid)
{
	for(new txd; txd < 6; txd++)
	{
		PlayerTextDrawShow(playerid, INFOTD[playerid][txd]);
	}
	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	return 1;
}
HideSUCCESSTD(playerid)
{
	for(new txd; txd < 7; txd++)
	{
		PlayerTextDrawHide(playerid, SUCCESSTD[playerid][txd]);
	}
	return 1;
}
ShowSUCCESSTD(playerid)
{
	for(new txd; txd < 7; txd++)
	{
		PlayerTextDrawShow(playerid, SUCCESSTD[playerid][txd]);
	}
	PlayerPlaySound(playerid, 5203, 0.0, 0.0, 0.0);
	return 1;
}

hook OnPlayerConnect(playerid)
{
	CreateBarError(playerid);
	CreateBarInfo(playerid);
	CreateBarSyntax(playerid);
	CreateBarSukses(playerid);
	CreateBarWarn(playerid);
	return 1;
}

ErrorMsg(playerid, text[] = "", Times)
{
	ErrorBar[playerid] = 100;
	new Float: Value = ErrorBar[playerid]*104.0/100;
	new Timer = Times*1000/100;
	ShowERRORTD(playerid);
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][7], Value, 3.0);
	PlayerTextDrawSetString(playerid, ERRORTD[playerid][4], text);
	KillTimer(ErrorTimer[playerid]);
	ErrorTimer[playerid] = SetTimerEx("ErrorUptLoading", Timer, true, "d", playerid);
	SetPVarInt(playerid, "ErrorLoadings", 1);
	return 1;
}
stock ErrorLoadings(playerid)
{
	new onbar, st;
	onbar = GetPVarInt(playerid, "ErrorLoadings");
	if(onbar == 1)
	{
		st = true;
	}
	else if(onbar == 0)
	{
		st = false;
	}
	return st;
}
stock ErrorUpdateLoading(playerid)
{
	new Float: Value = ErrorBar[playerid]*104.0/100;
	PlayerTextDrawTextSize(playerid, ERRORTD[playerid][7], Value, 3.0);
	PlayerTextDrawShow(playerid, ERRORTD[playerid][7]);
	return 1;
}
forward ErrorUptLoading(playerid);
public ErrorUptLoading(playerid)
{
	ErrorBar[playerid] -= 1;
	ErrorUpdateLoading(playerid);
	if(ErrorBar[playerid] <= 0)
	{
		KillTimer(ErrorTimer[playerid]);
		ErrorBar[playerid] = 100;

		SetPVarInt(playerid, "ErrorLoadings", 100);
		HideERRORTD(playerid);
	}
	return 1;
}
WarningMsg(playerid, text[] = "", Times)
{
	WarningBar[playerid] = 100;
	new Float: Value = WarningBar[playerid]*104.0/100;
	new Timer = Times*1000/100;
	ShowWARNINGTD(playerid);
	PlayerTextDrawTextSize(playerid, WARNINGTD[playerid][4], Value, 3.0);
	PlayerTextDrawSetString(playerid, WARNINGTD[playerid][3], text);
	KillTimer(WarningTimer[playerid]);
	WarningTimer[playerid] = SetTimerEx("WarningUptLoading", Timer, true, "d", playerid);
	SetPVarInt(playerid, "WarningLoading", 1);
	return 1;
}
stock WarningLoading(playerid)
{
	new onbar, st;
	onbar = GetPVarInt(playerid, "WarningLoading");
	if(onbar == 1)
	{
		st = true;
	}
	else if(onbar == 0)
	{
		st = false;
	}
	return st;
}
stock WarningUpdateLoading(playerid)
{
	new Float: Value = WarningBar[playerid]*104.0/100;
	PlayerTextDrawTextSize(playerid, WARNINGTD[playerid][4], Value, 3.0);
	PlayerTextDrawShow(playerid, WARNINGTD[playerid][4]);
	return 1;
}
forward WarningUptLoading(playerid);
public WarningUptLoading(playerid)
{
	WarningBar[playerid] -= 1;
	WarningUpdateLoading(playerid);
	if(WarningBar[playerid] <= 0)
	{
		KillTimer(WarningTimer[playerid]);
		WarningBar[playerid] = 100;

		SetPVarInt(playerid, "WarningLoading", 100);
		HideWARNINGTD(playerid);
	}
	return 1;
}

SyntaxMsg(playerid, text[] = "", Times)
{
	SyntaxBar[playerid] = 100;
	new Float: Value = SyntaxBar[playerid]*104.0/100;
	new Timer = Times*1000/100;
	ShowSYNTAXTD(playerid);
	PlayerTextDrawTextSize(playerid, SYNTAXTD[playerid][4], Value, 3.0);
	PlayerTextDrawSetString(playerid, SYNTAXTD[playerid][3], text);
	KillTimer(SyntaxTimer[playerid]);
	SyntaxTimer[playerid] = SetTimerEx("SyntaxUptLoading", Timer, true, "d", playerid);
	SetPVarInt(playerid, "SyntaxLoading", 1);
	return 1;
}
stock SyntaxLoading(playerid)
{
	new onbar, st;
	onbar = GetPVarInt(playerid, "SyntaxLoading");
	if(onbar == 1)
	{
		st = true;
	}
	else if(onbar == 0)
	{
		st = false;
	}
	return st;
}
stock SyntaxUpdateLoading(playerid)
{
	new Float: Value = SyntaxBar[playerid]*104.0/100;
	PlayerTextDrawTextSize(playerid, SYNTAXTD[playerid][4], Value, 3.0);
	PlayerTextDrawShow(playerid, SYNTAXTD[playerid][4]);
	return 1;
}
forward SyntaxUptLoading(playerid);
public SyntaxUptLoading(playerid)
{
	SyntaxBar[playerid] -= 1;
	SyntaxUpdateLoading(playerid);
	if(SyntaxBar[playerid] <= 0)
	{
		KillTimer(SyntaxTimer[playerid]);
		SyntaxBar[playerid] = 100;

		SetPVarInt(playerid, "SyntaxLoading", 100);
		HideSYNTAXTD(playerid);
	}
	return 1;
}

InfoMsg(playerid, text[] = "", Times)
{
	InfoBar[playerid] = 100;
	new Float: Value = InfoBar[playerid]*104.0/100;
	new Timer = Times*1000/100;
	ShowINFOTD(playerid);
	PlayerTextDrawTextSize(playerid, INFOTD[playerid][5], Value, 3.0);
	PlayerTextDrawSetString(playerid, INFOTD[playerid][4], text);
	KillTimer(InfoTimer[playerid]);
	InfoTimer[playerid] = SetTimerEx("InfoUptLoading", Timer, true, "d", playerid);
	SetPVarInt(playerid, "InfoLoadings", 1);
	return 1;
}
stock InfoLoadings(playerid){
	new info, st;
	info = GetPVarInt(playerid, "InfoLoadings");
	if(info == 1){
		st = true;
	} else if(info == 0){
		st = false;
	}
	return st;
}
stock InfoUpdateLoading(playerid)
{
	new Float:Value = InfoBar[playerid]*104.0/100;
	PlayerTextDrawTextSize(playerid, INFOTD[playerid][5], Value, 3.0);
	PlayerTextDrawShow(playerid, INFOTD[playerid][5]);
	return 1;
}
forward InfoUptLoading(playerid);
public InfoUptLoading(playerid)
{
	InfoBar[playerid] -= 1;
	InfoUpdateLoading(playerid);
	if(InfoBar[playerid] <= 0)
	{
		KillTimer(InfoTimer[playerid]);
		InfoBar[playerid] = 100;

		SetPVarInt(playerid, "InfoLoadings", 100);
		HideINFOTD(playerid);
	}
	return 1;
}

SuccesMsg(playerid, text[] = "", Times)
{
	SuksesBar[playerid] = 100;
	new Float: Value = SuksesBar[playerid]*104.0/100;
	new Timer = Times*1000/100;
	ShowSUCCESSTD(playerid);
	PlayerTextDrawTextSize(playerid, SUCCESSTD[playerid][6], Value, 3.0);
	PlayerTextDrawSetString(playerid, SUCCESSTD[playerid][5], text);
	KillTimer(SuksesTimer[playerid]);
	SuksesTimer[playerid] = SetTimerEx("SuksesUptLoading", Timer, true, "d", playerid);
	SetPVarInt(playerid, "SuksesLoadings", 1);
	return 1;
}

stock SuksesLoadings(playerid){
	new info, st;
	info = GetPVarInt(playerid, "SuksesLoadings");
	if(info == 1){
		st = true;
	} else if(info == 0){
		st = false;
	}
	return st;
}
stock SuksesUpdateLoading(playerid)
{
	new Float:Value = SuksesBar[playerid]*104.0/100;
	PlayerTextDrawTextSize(playerid, SUCCESSTD[playerid][6], Value, 3.0);
	PlayerTextDrawShow(playerid, SUCCESSTD[playerid][6]);
	return 1;
}
forward SuksesUptLoading(playerid);
public SuksesUptLoading(playerid)
{
	SuksesBar[playerid] -= 1;
	SuksesUpdateLoading(playerid);
	if(SuksesBar[playerid] <= 0)
	{
		KillTimer(SuksesTimer[playerid]);
		SuksesBar[playerid] = 100;

		SetPVarInt(playerid, "SuksesLoadings", 100);
		HideSUCCESSTD(playerid);
	}
	return 1;
}

CMD:info(playerid, params[])
{
	InfoMsg(playerid, "info", 4);
	return 1;
}
CMD:sukses(playerid, params[])
{
	SuccesMsg(playerid, "success", 4);
	return 1;
}
CMD:error(playerid, params[])
{
	ErrorMsg(playerid, "error", 4);
	return 1;
}
CMD:syntax(playerid, params[])
{
	SyntaxMsg(playerid, "syntax", 4);
	return 1;
}
CMD:warning(playerid, params[])
{
	WarningMsg(playerid, "warning", 4);
	return 1;
}

stock getSizeMessage(const string:message[], maxWidth=500) {
	new size = 0, lines=1, i=-1, lastPoint = 0;

	while(message[++i]) {
		size += TDTextCaracterWidth[message[i]];

		switch(message[i]) {
			case ' ':
				lastPoint = i;

			default:
				if(size >= maxWidth)
					++lines,
					size -= maxWidth,
					size += i - lastPoint;
		}
	}
	return lines;
}

stock ShowUI(const playerid, const string:message[], boxcolor)
{
	for(new x=-1;++x<notifyIndex[playerid];) {
		for(new i=-1;++i<10;) TextDrawHideForPlayer(playerid, notifyPTD[(x*10) + i]);
		notifyInfo[playerid][notifyIndex[playerid]-x] = notifyInfo[playerid][(notifyIndex[playerid]-x)-1];
	}

	strmid(notifyInfo[playerid][0][ntMessage], message, 0, MAX_NT_STRING);
	notifyInfo[playerid][0][ntColor] = boxcolor;
	notifyInfo[playerid][0][ntLines] = getSizeMessage(message);

	++notifyIndex[playerid];

	new Float:static_x=0.0;
	for(new x=-1;++x<notifyIndex[playerid];) {
		createNotifyTD(playerid, x, x * 6, static_x);
		static_x+=(notifyInfo[playerid][x][ntLines] * -5.0) + 8.0;
	}

	SetTimerEx(#destroy_notify, SECONDS_NT * 1000, false, #i, playerid);
	return 1;
}

notify::destroy_notify(playerid) {
	if(!notifyIndex[playerid]) return 1;
	--notifyIndex[playerid];
	for(new i=-1;++i<10;) TextDrawHideForPlayer(playerid, notifyPTD[(notifyIndex[playerid]*10) + i]);
	return 1;
}

stock createNotifyTD(const playerid, index, i, const Float:static_x) {
	new lines = notifyInfo[playerid][index][ntLines],Float:x = (lines * -5.0) + static_x;
    new Float:posisibaru = x+1.0;
    
	notifyPTD[++i] = TextDrawCreate(406.000, 5.300+posisibaru, "LD_BEAT:chit");
	TextDrawTextSize(notifyPTD[i], 19.000, 22.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(522.000, 5.300+posisibaru, "LD_BEAT:chit");
	TextDrawTextSize(notifyPTD[i], 19.000, 22.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(415.000, 8.000+posisibaru, "LD_BUM:blkdot");
	TextDrawTextSize(notifyPTD[i], 117.000, 15.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(415.000, 12.000+posisibaru, "LD_BUM:blkdot");
	TextDrawTextSize(notifyPTD[i], 116.000, 12.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(469.000, 11.000+posisibaru, notifyInfo[playerid][index][ntMessage]);
	TextDrawLetterSize(notifyPTD[i], 0.200, 0.999);
	TextDrawAlignment(notifyPTD[i], 2);
	TextDrawColor(notifyPTD[i], -1);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 150);
	TextDrawFont(notifyPTD[i], 1);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(406.000, 4.300+posisibaru, "LD_BEAT:chit");
	TextDrawTextSize(notifyPTD[i], 19.000, 22.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(522.000, 4.300+posisibaru, "LD_BEAT:chit");
	TextDrawTextSize(notifyPTD[i], 19.000, 22.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	return true;
}

public OnPlayerConnect(playerid)
{

	notifyIndex[playerid] = 0;

	#if defined NT_OnPlayerConnect
		return NT_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect NT_OnPlayerConnect
#if defined NT_OnPlayerConnect
	forward NT_OnPlayerConnect(playerid);
#endif
