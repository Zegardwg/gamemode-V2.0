new PaytollAreaid[11];

CreatePaytollAreaid()
{
	PaytollAreaid[0] = CreateDynamicSphere(1811.87, 816.24, 10.80, 10.0, 0); //GERBANG TOL LV 1
	PaytollAreaid[2] = CreateDynamicSphere(1801.70, 816.45, 10.80, 10.0, 0); //GERBANG TOL LV 2
	PaytollAreaid[3] = CreateDynamicSphere(1792.55, 807.30, 10.99, 10.0, 0); //GERBANG TOL LV 3
	PaytollAreaid[4] = CreateDynamicSphere(1784.32, 807.17, 10.99, 10.0, 0); //GERBANG TOL LV 4
	PaytollAreaid[5] = CreateDynamicSphere(47.19, -1523.98, 5.10, 10.0, 0); //GERBANG TOL FLINT 1
	PaytollAreaid[6] = CreateDynamicSphere(59.95, -1539.47, 5.08, 10.0, 0); //GERBANG TOL FLINT 2
	PaytollAreaid[7] = CreateDynamicSphere(-163.65, 369.43, 12.07, 10.0, 0); //GERBANG TOL RED BRIDGE 1
	PaytollAreaid[8] = CreateDynamicSphere(-175.23, 354.51, 12.07, 10.0, 0); //GERBANG TOL RED BRIDGE 2
	PaytollAreaid[9] = CreateDynamicSphere(514.60, 486.95, 18.92, 10.0, 0); //GERBANG TOL RED BRIDGE 3
	PaytollAreaid[10] = CreateDynamicSphere(519.32, 468.13, 18.92, 10.0, 0); //GERBANG TOL RED BRIDGE 4
}

CMD:paytoll(playerid, params[])
{
	OpenPaytoll(playerid);
	return 1;
}

OpenPaytoll(playerid)
{
	if(pData[playerid][pMoney] < 5)
		return Error(playerid, "Kamu harus memiliki uang $5.00 untuk membayar toll");

	if(IsPlayerInRangeOfPoint(playerid, 5.5, 1811.87, 816.24, 10.80)) //GERBANG TOL LV1
	{
		MoveDynamicObject(tolgate[0], 1807.947021, 821.503417, 10.610667, 2.00, 0.000000, 8.099967, 0.000000);
		SetTimerEx("ClosePaytol", 6000, false, "i", 0);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Las Venturas 1 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, 1801.70, 816.45, 10.80)) //GERBANG TOL LV2
	{
		MoveDynamicObject(tolgate[1], 1805.447753, 821.524658, 10.560406, 2.00, 0.000000, -8.999938, -0.000000);
		SetTimerEx("ClosePaytol", 6000, false, "i", 1);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Las Venturas 2 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, 1792.55, 807.30, 10.99)) //GERBANG TOL LV3
	{
		MoveDynamicObject(tolgate[2], 1788.649291, 803.113159, 10.900191, 2.00, 0.000000, 8.999918, -0.099992);
		SetTimerEx("ClosePaytol", 6000, false, "i", 2);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Las Venturas 3 dengan biaya "RED_E"$5,00"); 

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, 1784.32, 807.17, 10.99)) //GERBANG TOL LV4
	{
		MoveDynamicObject(tolgate[3], 1787.745727, 803.114807, 10.881713, 2.00, 0.000000, -16.699935, 0.000000);
		SetTimerEx("ClosePaytol", 6000, false, "i", 3);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Las Venturas 4 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, 47.19, -1523.98, 5.10)) //GERBANG FLINT1
	{
		MoveDynamicObject(tolgate[4], 41.159236, -1526.555419, 5.092907, 2.00, 0.000000, 9.799967, 80.200096);
		SetTimerEx("ClosePaytol", 6000, false, "i", 4);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Flint 1 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, 59.95, -1539.47, 5.08)) //GERBANG FLINT2
	{
		MoveDynamicObject(tolgate[5], 65.120658, -1536.429077, 4.809195, 2.00, 0.000000, -11.799952, 82.400070);
		SetTimerEx("ClosePaytol", 6000, false, "i", 5);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Flint 2 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, -163.65, 369.43, 12.07)) //GERBANG RED BRIDGE1
	{
		MoveDynamicObject(tolgate[6], -165.864074, 374.415924, 11.875398, 2.00, 0.000000, -8.199937, 163.700042);
		SetTimerEx("ClosePaytol", 6000, false, "i", 6);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Red Bridge 1 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, -175.23, 354.51, 12.07)) //GERBANG RED BRIDGE2
	{
		MoveDynamicObject(tolgate[7], -172.951614, 349.509979, 11.878129, 2.00, 0.000000, -10.199941, -15.499999);
		SetTimerEx("ClosePaytol", 6000, false, "i", 7);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Red Bridge 2 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, 514.60, 486.95, 18.92)) //GERBANG GREY BRIDGE1
	{
		MoveDynamicObject(tolgate[8], 509.552917, 488.096923, 18.707580, 2.00, 0.000000, -7.999981, -144.800003);
		SetTimerEx("ClosePaytol", 6000, false, "i", 8);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Grey Bridge 1 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.5, 519.32, 468.13, 18.92)) //GERBANG GREY BRIDGE2
	{
		MoveDynamicObject(tolgate[9], 524.426269, 467.211395, 18.679878, 2.00, 0.000000, -13.800021, 35.199996);
		SetTimerEx("ClosePaytol", 6000, false, "i", 9);

		GivePlayerMoneyEx(playerid, -5);
		Info(playerid, "Kamu telah membuka gerbang Tol Grey Bridge 2 dengan biaya "RED_E"$5,00");

		Server_AddMoney(5);
	}
	else
	{
		Error(playerid, "Kamu tidak berada dipintu toll manapun");
	}
	return 1;
}

function ClosePaytol(tolid)
{
	switch(tolid)
	{
		case 0:
		{
			MoveDynamicObject(tolgate[0], 1807.947021, 821.503417, 10.610667, 2.00, 0.000000, 89.899971, 0.000000);
		}
		case 1:
		{
			MoveDynamicObject(tolgate[1], 1805.447753, 821.524658, 10.560406, 2.00, 0.000000, -90.299957, -0.000000);
		}
		case 2:
		{
			MoveDynamicObject(tolgate[2], 1788.649291, 803.113159, 10.900191, 2.00, 0.000000, 90.299942, -0.099992);
		}
		case 3:
		{
			MoveDynamicObject(tolgate[3], 1787.745727, 803.114807, 10.881714, 2.00, 0.000000, -90.299926, 0.000000);
		}
		case 4:
		{
			MoveDynamicObject(tolgate[4], 41.159236, -1526.555419, 5.092908, 2.00, 0.000000, 89.999961, 80.200096);
		}
		case 5:
		{
			MoveDynamicObject(tolgate[5], 65.120658, -1536.429077, 4.809195, 2.00, 0.000000, -90.199958, 82.400070);
		}
		case 6:
		{
			MoveDynamicObject(tolgate[6], -165.864074, 374.415924, 11.875398, 2.00, 0.000000, -89.999954, 163.700042);
		}
		case 7:
		{
			MoveDynamicObject(tolgate[7], -172.951614, 349.509979, 11.878129, 2.00, 0.000000, -89.999961, -15.499999);
		}
		case 8:
		{
			MoveDynamicObject(tolgate[8], 509.552917, 488.096923, 18.707580, 2.00, 0.000000, -89.800018, -144.800003);
		}
		case 9:
		{
			MoveDynamicObject(tolgate[9], 524.426269, 467.211395, 18.679878, 2.00, 0.000000, -89.800010, 35.199996);
		}
	}
}

/*

	//TOL LV
	tolgate[0] = CreateDynamicObject(968, 1807.947021, 821.503417, 10.610667, 0.000000, 89.899971, 0.000000, -1, -1, -1, 200.00, 200.00); //TOLL LV1 23
	tolgate[1] = CreateDynamicObject(968, 1805.447753, 821.524658, 10.560406, 0.000000, -90.299957, -0.000000, -1, -1, -1, 200.00, 200.00); //TOL LV2 25
	tolgate[2] = CreateDynamicObject(968, 1788.649291, 803.113159, 10.900191, 0.000000, 90.299942, -0.099992, -1, -1, -1, 200.00, 200.00); //TOLL LV3 28
	tolgate[3] = CreateDynamicObject(968, 1787.745727, 803.114807, 10.881714, 0.000000, -90.299926, 0.000000, -1, -1, -1, 200.00, 200.00); //TOLL LV4 29

	//TOL FLINT
	tolgate[4] = CreateDynamicObject(968, 41.159236, -1526.555419, 5.092908, 0.000000, 89.999961, 80.200096, -1, -1, -1, 200.00, 200.00); //TOLL FLINT1 92
	tolgate[5] = CreateDynamicObject(968, 65.120658, -1536.429077, 4.809195, 0.000000, -90.199958, 82.400070, -1, -1, -1, 200.00, 200.00); //TOLL FLINT2 91

	//TOL RED BRIDGE
	tolgate[6] = CreateDynamicObject(968, -165.864074, 374.415924, 11.875398, 0.000000, -89.999954, 163.700042, -1, -1, -1, 200.00, 200.00); //TOLL RED BRIDGE1 112
	tolgate[7] = CreateDynamicObject(968, -172.951614, 349.509979, 11.878129, 0.000000, -89.999961, -15.499999, -1, -1, -1, 200.00, 200.00); //TOLL RED BRIDGE2 109

	//TOL GREY BRIDGE
	tolgate[8] = CreateDynamicObject(968, 509.552917, 488.096923, 18.707580, 0.000000, -89.800018, -144.800003, -1, -1, -1, 200.00, 200.00); //TOLL GREY BRIDGE 122
	tolgate[9] = CreateDynamicObject(968, 524.426269, 467.211395, 18.679878, 0.000000, -89.800010, 35.199996, -1, -1, -1, 200.00, 200.00); //TOLL GREY BRIDGE 121










	RemoveBuildingForPlayer(playerid, 3516, 1811.739, 822.929, 12.920, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, 1796.348, 789.234, 16.670, 0.250);

	tmpobjid = CreateDynamicObject(19482, 1787.837890, 705.057617, 16.601911, 0.000000, 0.000000, 260.100097, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_trans_concr", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF} TOL AREA", 120, "Ariel", 30, 1, 0x0000000A, 0x00000000, 1);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(962, 43.708053, -1527.023071, 5.206861, 90.000000, -10.800004, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 58.946342, -1529.971435, 4.209060, 0.000000, 0.000000, -10.299991, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(962, 62.275424, -1535.811767, 5.026858, 90.000000, -8.799999, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 60.178791, -1535.342651, 4.209060, 0.000000, 0.000000, 172.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 65.667732, -1536.166015, 4.209060, 0.000000, 0.000000, 171.400024, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 53.976722, -1534.493164, 4.209060, 0.000000, 0.000000, 172.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 47.784561, -1533.645629, 4.209060, 0.000000, 0.000000, 172.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 52.773815, -1528.870483, 4.209060, 0.000000, 0.000000, -10.299991, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 65.862136, -1534.428955, 4.224365, 0.000000, 0.000000, 83.300056, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 46.612926, -1527.760620, 4.209060, 0.000000, 0.000000, -10.299990, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 40.672943, -1526.721679, 4.209060, 0.000000, 0.000000, -10.299991, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 65.649620, -1536.236450, 4.224365, 0.000000, 0.000000, 83.300056, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 40.093574, -1532.648193, 4.224365, 0.000000, 0.000000, 83.300056, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 40.415576, -1529.906982, 4.224365, 0.000000, 0.000000, 83.300056, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 63.124008, -1533.333129, 4.804821, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 56.764091, -1532.332275, 4.804821, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 51.134124, -1531.381347, 4.804821, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 43.094272, -1529.990844, 4.804821, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, 1787.665039, 803.114929, 10.092336, 0.000000, 0.000000, 1440.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(9623, 1797.560668, 812.981994, 12.681771, -0.999997, 0.000000, -0.799996, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1795.878540, 817.228637, 9.954407, 0.000000, 1.499999, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, 1808.055175, 821.515563, 9.742329, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, 1805.395019, 821.515563, 9.742329, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1798.449707, 817.207092, 9.954407, 0.000000, 1.499999, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, 1788.764404, 803.114746, 10.032346, 0.000000, 0.000000, 900.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1787.167236, 805.582946, 9.954408, 0.000000, 0.000000, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1796.509887, 817.338684, 14.015692, 270.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1797.720092, 817.338684, 14.015692, 270.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1788.997558, 817.338684, 13.945693, 270.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1787.876953, 817.338684, 13.955693, 270.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1806.043090, 817.338684, 13.895689, 270.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1807.204101, 817.338684, 13.895689, 270.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1796.437988, 808.634887, 14.118531, 90.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1797.538696, 808.634887, 14.118531, 90.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1805.939941, 808.634887, 14.118531, 90.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1806.939941, 808.634887, 14.118531, 90.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1788.817382, 808.634887, 14.118531, 90.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1215, 1787.867309, 808.634887, 14.118531, 90.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(970, 1797.044311, 809.540893, 11.439000, 0.000000, 0.000000, 88.300010, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(970, 1796.920166, 805.383056, 11.439000, 0.000000, 0.000000, 88.300010, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1798.229248, 805.488281, 9.954407, 0.000000, 0.000000, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1779.511718, 803.077941, 10.661895, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1778.911743, 803.077941, 10.661895, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1778.291137, 803.077941, 10.661895, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1816.126342, 821.495727, 10.389159, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1815.295776, 821.495422, 10.339156, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1797.168334, 824.819274, 10.201880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1797.168334, 825.869445, 10.201880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1797.168334, 826.960144, 10.201880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, 41.168598, -1526.442016, 4.243725, 0.000000, 0.000000, -99.899894, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, 65.124282, -1536.542968, 4.002585, 0.000000, 0.000000, 82.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 62.614517, -1546.267700, 4.107775, 0.000000, 0.000000, 60.599987, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 62.614517, -1546.267700, 5.037777, 0.000000, 0.000000, 60.599987, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 40.415576, -1529.906982, 5.234364, 0.000000, 0.000000, 83.300056, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 40.094734, -1532.637939, 5.234373, 0.000000, 0.000000, 83.300056, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1797.168334, 823.778686, 10.201880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1777.670532, 803.077941, 10.661895, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1795.669067, 805.510192, 9.954407, 0.000000, 0.000000, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1787.247924, 817.303527, 9.954407, 0.000000, 1.499999, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1789.698486, 817.281982, 9.954407, 0.000000, 1.499999, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1807.680053, 805.406921, 9.954407, 0.000000, 0.000000, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1805.110473, 805.428833, 9.954407, 0.000000, 0.000000, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19980, 1787.880859, 705.084838, 13.967308, 0.000000, 0.000000, -10.200000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19959, 1789.201416, 705.010253, 13.904817, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19989, 1786.529663, 705.413574, 13.957222, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1789.467773, 805.564025, 9.954408, 0.000000, 0.000000, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1805.349487, 817.147338, 9.954408, 0.000000, 1.499999, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1807.799682, 817.125671, 9.954408, 0.000000, 1.499999, 89.499984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19124, 1780.182373, 803.077941, 10.661895, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.986694, 823.091430, 10.174776, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 42.374771, -1519.566040, 4.193522, 0.000000, 0.000000, 41.299961, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 40.672943, -1526.721679, 5.239066, 0.000000, 0.000000, -10.299990, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 46.612926, -1527.760620, 5.239071, 0.000000, 0.000000, -10.299990, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 52.773815, -1528.870483, 5.229064, 0.000000, 0.000000, -10.299990, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 42.374771, -1519.566040, 5.123528, 0.000000, 0.000000, 41.299961, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 58.946342, -1529.971435, 5.229063, 0.000000, 0.000000, -10.299990, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 65.862136, -1534.429443, 5.204369, 0.000000, 0.000000, 83.300056, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 65.667732, -1536.166015, 5.209065, 0.000000, 0.000000, 171.400024, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 65.649620, -1536.236450, 5.204370, 0.000000, 0.000000, 83.300056, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 46.258831, -1533.437011, 4.209060, 0.000000, 0.000000, 172.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 53.976722, -1534.493164, 5.239058, 0.000000, 0.000000, 172.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 47.784561, -1533.645629, 5.229060, 0.000000, 0.000000, 172.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 60.178791, -1535.342651, 5.209065, 0.000000, 0.000000, 172.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(638, 53.741695, -1531.820190, 5.046823, 0.000000, 0.000000, 80.499992, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(638, 46.912685, -1530.629516, 5.046823, 0.000000, 0.000000, 78.200027, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(638, 60.207881, -1532.864257, 5.046823, 0.000000, 0.000000, 81.199981, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.936767, 819.895874, 10.331097, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.886962, 816.700073, 10.487414, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(970, 1796.279907, 803.320922, 10.186036, 360.000000, 90.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(970, 1797.470458, 803.320922, 10.186036, 360.000000, 90.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.837036, 813.524353, 10.642757, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.786621, 810.328735, 10.799072, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.735107, 807.123229, 10.955879, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.684326, 803.917541, 11.112686, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.634033, 800.742004, 11.268021, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.583496, 797.536437, 11.424835, 0.000000, -2.799999, -90.899902, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, -165.773544, 374.389495, 11.078125, 0.000000, 0.000000, 163.700042, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, -166.259399, 374.020172, 11.148120, 0.000000, 0.000000, -104.700004, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, -171.057876, 355.729156, 11.148120, 0.000000, 0.000000, -104.700004, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, -167.863143, 367.907012, 11.148120, 0.000000, 0.000000, -104.700004, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, -169.464294, 361.803558, 11.148120, 0.000000, 0.000000, -104.700004, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, -173.042266, 349.531158, 11.078125, 0.000000, 0.000000, -15.199942, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19966, -173.031234, 348.253723, 11.028120, 0.000000, 0.000000, -15.200012, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19966, -165.766662, 375.792846, 11.028120, 0.000000, 0.000000, 164.799987, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19126, -180.185119, 351.525695, 12.148119, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19126, -158.659133, 372.320281, 12.341259, 0.000000, 0.000000, -16.099992, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 520.554138, 472.501647, 17.999679, 0.000000, 0.000000, 124.599906, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, 524.333618, 467.146148, 17.929687, 0.000000, 0.000000, 35.199996, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(966, 509.652923, 488.167327, 17.929687, 0.000000, 0.000000, -144.800003, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 516.985168, 477.644744, 17.999679, 0.000000, 0.000000, 124.999900, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 513.388427, 482.792999, 17.999679, 0.199999, 0.000000, 124.799903, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 524.192321, 467.381683, 17.999679, 0.000000, 0.000000, 125.299896, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19966, 508.551788, 489.728149, 18.009683, 0.000000, 0.000000, -144.800003, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19966, 525.165710, 465.983154, 17.829681, 0.000000, 0.000000, 35.199996, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19126, 515.540161, 492.309783, 18.689687, 0.000000, 0.000000, 34.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19126, 518.374450, 463.069427, 18.712814, 0.000000, 0.000000, 35.000003, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.513427, 794.351379, 11.580665, 0.000000, -2.799999, -91.799888, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1816.413208, 791.209289, 11.735510, 0.000000, -0.700001, -93.099868, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.716918, 820.014587, 9.997275, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.644897, 816.869689, 10.167615, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.573974, 813.745178, 10.336875, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.502563, 810.571228, 10.508844, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.430541, 807.407287, 10.680274, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.358886, 804.253112, 10.851161, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.286865, 801.068725, 11.023673, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.214965, 797.894470, 11.195642, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.143798, 794.769775, 11.364907, 0.000000, 3.099998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.071899, 791.623168, 11.495300, 0.000000, 2.799998, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(997, 1777.000122, 788.466125, 11.609685, 0.000000, 2.099999, 88.700019, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 46.258831, -1533.437011, 5.229069, 0.000000, 0.000000, 172.200073, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 60.117115, -1530.185058, 4.209060, 0.000000, 0.000000, -10.299990, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 60.117115, -1530.185058, 5.229066, 0.000000, 0.000000, -10.299990, -1, -1, -1, 200.00, 200.00); 

*/