ptask PlayerDelay[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == false) return 0;

	if(pData[playerid][pBusTime] > 0)
	{
		pData[playerid][pBusTime]--;
	}
	return 1;
}