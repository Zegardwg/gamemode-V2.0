stock matasatu(playerid)
{
    PlayerTextDrawShow(playerid, MATATD[playerid][0]);
	PlayerTextDrawShow(playerid, MATATD[playerid][1]);
	PlayerTextDrawShow(playerid, MATATD[playerid][2]);
    SelectTextDraw(playerid, 0xFF0000FF);
    return 1;
}

stock matadua(playerid)
{
    PlayerTextDrawShow(playerid, MATATD[playerid][0]);
	PlayerTextDrawShow(playerid, MATATD[playerid][1]);
	PlayerTextDrawShow(playerid, MATATD[playerid][2]);
    PlayerTextDrawShow(playerid, MATATD[playerid][3]);
	PlayerTextDrawShow(playerid, MATATD[playerid][4]);
    SelectTextDraw(playerid, 0xFF0000FF);
    return 1;
}

stock matatiga(playerid)
{
    PlayerTextDrawShow(playerid, MATATD[playerid][0]);
	PlayerTextDrawShow(playerid, MATATD[playerid][1]);
	PlayerTextDrawShow(playerid, MATATD[playerid][2]);
    PlayerTextDrawShow(playerid, MATATD[playerid][3]);
	PlayerTextDrawShow(playerid, MATATD[playerid][4]);
    PlayerTextDrawShow(playerid, MATATD[playerid][5]);
	PlayerTextDrawShow(playerid, MATATD[playerid][6]);
    SelectTextDraw(playerid, 0xFF0000FF);
    return 1;
}

stock mataempat(playerid)
{
    PlayerTextDrawShow(playerid, MATATD[playerid][0]);
	PlayerTextDrawShow(playerid, MATATD[playerid][1]);
	PlayerTextDrawShow(playerid, MATATD[playerid][2]);
    PlayerTextDrawShow(playerid, MATATD[playerid][3]);
	PlayerTextDrawShow(playerid, MATATD[playerid][4]);
    PlayerTextDrawShow(playerid, MATATD[playerid][5]);
	PlayerTextDrawShow(playerid, MATATD[playerid][6]);
    PlayerTextDrawShow(playerid, MATATD[playerid][7]);
	PlayerTextDrawShow(playerid, MATATD[playerid][8]);
    SelectTextDraw(playerid, 0xFF0000FF);
    return 1;
}

stock matalima(playerid)
{
    PlayerTextDrawShow(playerid, MATATD[playerid][0]);
	PlayerTextDrawShow(playerid, MATATD[playerid][1]);
	PlayerTextDrawShow(playerid, MATATD[playerid][2]);
	PlayerTextDrawShow(playerid, MATATD[playerid][3]);
	PlayerTextDrawShow(playerid, MATATD[playerid][4]);
	PlayerTextDrawShow(playerid, MATATD[playerid][5]);
	PlayerTextDrawShow(playerid, MATATD[playerid][6]);
	PlayerTextDrawShow(playerid, MATATD[playerid][7]);
	PlayerTextDrawShow(playerid, MATATD[playerid][8]);
	PlayerTextDrawShow(playerid, MATATD[playerid][9]);
	PlayerTextDrawShow(playerid, MATATD[playerid][10]);
	SelectTextDraw(playerid, 0xFF0000FF);
    return 1;
}

stock hidematas(playerid)
{
    PlayerTextDrawHide(playerid, MATATD[playerid][0]);
	PlayerTextDrawHide(playerid, MATATD[playerid][1]);
	PlayerTextDrawHide(playerid, MATATD[playerid][2]);
	PlayerTextDrawHide(playerid, MATATD[playerid][3]);
	PlayerTextDrawHide(playerid, MATATD[playerid][4]);
	PlayerTextDrawHide(playerid, MATATD[playerid][5]);
	PlayerTextDrawHide(playerid, MATATD[playerid][6]);
	PlayerTextDrawHide(playerid, MATATD[playerid][7]);
	PlayerTextDrawHide(playerid, MATATD[playerid][8]);
	PlayerTextDrawHide(playerid, MATATD[playerid][9]);
	PlayerTextDrawHide(playerid, MATATD[playerid][10]);
    return 1;
}

stock hidemata(playerid)
{
    PlayerTextDrawHide(playerid, MATATD[playerid][0]);
	PlayerTextDrawHide(playerid, MATATD[playerid][1]);
	PlayerTextDrawHide(playerid, MATATD[playerid][2]);
	PlayerTextDrawHide(playerid, MATATD[playerid][3]);
	PlayerTextDrawHide(playerid, MATATD[playerid][4]);
	PlayerTextDrawHide(playerid, MATATD[playerid][5]);
	PlayerTextDrawHide(playerid, MATATD[playerid][6]);
	PlayerTextDrawHide(playerid, MATATD[playerid][7]);
	PlayerTextDrawHide(playerid, MATATD[playerid][8]);
	PlayerTextDrawHide(playerid, MATATD[playerid][9]);
	PlayerTextDrawHide(playerid, MATATD[playerid][10]);
    CancelSelectTextDraw(playerid);
    return 1;
}