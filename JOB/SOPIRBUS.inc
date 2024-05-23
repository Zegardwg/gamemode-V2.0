//======== Bus ===========
enum E_BUS
{
    STREAMER_TAG_MAP_ICON:BusMap,
	STREAMER_TAG_CP:BusCp,
	STREAMER_TAG_MAP_ICON:BusMapBaru,
	STREAMER_TAG_CP:BusCpBaru,
	STREAMER_TAG_MAP_ICON:BusMap3,
	STREAMER_TAG_CP:BusCp3
}
new BusArea[MAX_PLAYERS][E_BUS];

DeleteBusCP(playerid)
{
	if(IsValidDynamicCP(BusArea[playerid][BusCp]))
	{
		DestroyDynamicCP(BusArea[playerid][BusCp]);
		BusArea[playerid][BusCp] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(BusArea[playerid][BusMap]))
	{
		DestroyDynamicMapIcon(BusArea[playerid][BusMap]);
		BusArea[playerid][BusMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicCP(BusArea[playerid][BusCpBaru]))
	{
		DestroyDynamicCP(BusArea[playerid][BusCpBaru]);
		BusArea[playerid][BusCpBaru] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(BusArea[playerid][BusMapBaru]))
	{
		DestroyDynamicMapIcon(BusArea[playerid][BusMapBaru]);
		BusArea[playerid][BusMapBaru] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicCP(BusArea[playerid][BusCp3]))
	{
		DestroyDynamicCP(BusArea[playerid][BusCp3]);
		BusArea[playerid][BusCp3] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(BusArea[playerid][BusMap3]))
	{
		DestroyDynamicMapIcon(BusArea[playerid][BusMap3]);
		BusArea[playerid][BusMap3] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshJobBus(playerid)
{
	DeleteBusCP(playerid);

	if(pData[playerid][pJob] == 27)
	{
		BusArea[playerid][BusCp] = CreateDynamicCP(-604.5494,-523.3740,25.6222, 2.0, -1, -1, playerid, 30.0);
		BusArea[playerid][BusMap] = CreateDynamicMapIcon(-604.5494,-523.3740,25.6222, 61, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		BusArea[playerid][BusCpBaru] = CreateDynamicCP(-603.7074,-510.1997,25.6245, 2.0, -1, -1, playerid, 30.0);
		BusArea[playerid][BusMapBaru] = CreateDynamicMapIcon(-603.7074,-510.1997,25.6245, 61, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		BusArea[playerid][BusCp3] = CreateDynamicCP(-604.1620,-517.0234,25.6216, 2.0, -1, -1, playerid, 30.0);
		BusArea[playerid][BusMap3] = CreateDynamicMapIcon(-604.1620,-517.0234,25.6216, 61, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
	}
	return 1;
}

#define buspoint1 		-557.1394,-515.4979,25.1791
#define buspoint2 		-479.5997,-605.5638,16.9304
#define buspoint3 		-399.7464,-672.5795,16.1623
#define buspoint4 		-343.7397,-782.2640,30.4623
#define buspoint5 		-268.2225,-885.3994,44.7957
#define buspoint6 		-97.5163,-1025.8119,23.6446
#define buspoint7 		-115.2943,-1159.4506,1.7561
#define buspoint8 		-146.5927,-1427.3439,2.2553
#define buspoint9 		135.8510,-1568.5452,9.8034
#define buspoint10 		197.0582,-1504.0419,12.2148
#define buspoint11 		470.2633,-1312.2339,14.8399
#define buspoint12 		626.1551,-1235.1482,17.4836
#define buspoint13 		652.3132,-1406.6901,12.9567
#define buspoint14 		892.7717,-1405.7152,12.6036
#define buspoint15 		1172.1044,-1405.3931,12.8790
#define buspoint16 		1329.0289,-1404.9050,12.9116
#define buspoint17 		1360.3790,-1272.2819,12.9389
#define buspoint18 		1370.2517,-1022.0395,26.0971
#define buspoint19 		1518.6969,-1002.9564,40.2684
#define buspoint20 		1611.6390,-1243.0491,48.0530
#define buspoint21 		1591.7938,-1439.5529,28.1420
#define buspoint22 		1595.4380,-1732.9148,27.5095
#define buspoint23 		1512.2025,-2114.5305,13.4959
#define buspoint24 		1329.9426,-2290.6936,12.9389
#define buspoint25 		1318.3634,-2434.1541,8.0590
#define buspoint26 		1380.8414,-2466.9199,6.5882
#define buspoint27 		1520.6675,-2311.9570,-2.8625
#define buspoint28		1574.4774,-2308.9734,-3.3062
#define buspoint29		1731.8765,-2319.6948,-3.2946
#define buspoint30		1733.3812,-2264.2278,-3.2948
#define buspoint31		1595.2623,-2253.4094,-3.2950
#define buspoint32 		1531.7661,-2284.7544,-3.4358
#define buspoint33 		1423.8187,-2423.8689,5.5951
#define buspoint34 		1240.4366,-2439.4226,8.5926
#define buspoint35 		1045.7511,-2256.9700,12.4865
#define buspoint36		1061.5620,-1871.2524,12.8650
#define buspoint37 		1291.1639,-1855.0880,12.9393
#define buspoint38 		1313.5973,-1738.4720,12.9384
#define buspoint39 		1495.0299,-1735.6650,12.9389
#define buspoint40 		1532.5594,-1640.8057,12.9389
#define buspoint41		1381.2465,-1583.3474,12.9221
#define buspoint42 		1348.3361,-1474.8810,12.9397
#define buspoint43 		1182.0361,-1392.2271,12.8288
#define buspoint44 		657.4379,-1392.1094,13.0368
#define buspoint45 		627.2910,-1599.4320,15.1807
#define buspoint46 		593.7723,-1724.8248,13.1725
#define buspoint47 		213.4876,-1630.2450,13.4940
#define buspoint48		128.2209,-1541.0873,7.8801
#define buspoint49 		-9.2797,-1517.2645,1.8204
#define buspoint50 		-147.5444,-1331.8433,2.2514
#define buspoint51  	-84.2044,-1106.2207,2.2244
#define buspoint52 		-145.4738,-966.2449,27.2206
#define buspoint53 		-280.3795,-879.2582,45.4417
#define buspoint54      -339.5093,-781.3972,31.1834
#define buspoint55		-404.0324,-659.3582,14.3994
#define buspoint56      -480.8972,-592.8253,17.2806
#define buspoint57      -487.3407,-541.4174,25.1796
#define buspoint58      -521.6788,-517.0588,25.1795//stop ke 3
#define buspoint59      -568.1290,-515.9442,25.1792
#define buspoint60      -583.4730,-485.9557,25.1795

//rute bus 2
#define cpbus1 			-539.2806,-523.2104,25.7253
#define cpbus2 			-476.5073,-609.8909,17.3272
#define cpbus3 			-415.1812,-590.5543,11.1846
#define cpbus4 			-506.5304,-393.9781,16.1062
#define cpbus5 		 	-745.1449,-433.4766,16.0646
#define cpbus6 			-886.3450,-463.4493,23.9646
#define cpbus7 			-961.6530,-334.2141,36.2477
#define cpbus8 			-805.1191,-114.1556,63.6200
#define cpbus9 			-747.6723,-5.7273,53.1510
#define cpbus10			-792.6533,14.2269,33.3707
#define cpbus11			-717.3571,119.0333,15.7373
#define cpbus12			-523.2466,282.3461,2.1802
#define cpbus13			-165.7437,364.8784,12.1787
#define cpbus14			-126.4580,580.5178,2.7789
#define cpbus15			-288.5711,639.5784,16.1828
#define cpbus16			-154.0040,742.2755,22.9539
#define cpbus17			-174.6440,814.0516,22.0599
#define cpbus18			-190.7349,947.6729,16.1827
#define cpbus19			-217.3658,1021.0369,19.6915
#define cpbus20			-272.9776,1115.6296,19.6915
#define cpbus21			-224.6271,1196.1451,19.6950
#define cpbus22			85.4105,1195.3680,18.4908
#define cpbus23			164.0048,1150.3789,14.4663
#define cpbus24			333.4113,1344.2068,8.9199
#define cpbus25			473.6363,1640.8574,15.3603
#define cpbus26			615.5842,1697.0778,7.0947
#define cpbus27			649.4136,1780.5033,5.3463
#define cpbus28			725.2737,1912.1259,5.6434
#define cpbus29			807.5643,1836.6034,3.8919
#define cpbus30			821.2609,1531.5461,17.7272
#define cpbus31			770.3237,1125.1390,28.4193
#define cpbus32			348.2410,1011.1359,28.4536
#define cpbus33			254.7596,913.1982,24.4566
#define cpbus34			479.3594,526.2183,19.0221
#define cpbus35			589.1198,369.5509,19.0410
#define cpbus36			554.4610,273.6255,16.7298
#define cpbus37			517.8661,146.1436,24.0598
#define cpbus38			526.4655,-109.1321,37.2908
#define cpbus39			461.9476,-425.0762,29.2536
#define cpbus40			314.8308,-564.7679,40.4776
#define cpbus41			222.9891,-612.4483,29.5597
#define cpbus42			84.0509,-667.4488,5.3399
#define cpbus43			-14.6675,-756.7159,8.2910
#define cpbus44			-117.7939,-969.9329,24.9792
#define cpbus45			-278.8258,-879.2018,45.9452
#define cpbus46			-283.2650,-822.9532,42.7230
#define cpbus47			-344.4633,-779.8657,30.8549
#define cpbus48			-387.0900,-685.6909,19.0988
#define cpbus49			-475.5967,-618.2720,17.2350
#define cpbus50			-485.2985,-544.7413,25.7223
#define cpbus51			-522.4493,-516.2531,25.7162
#define cpbus52			-547.2876,-515.8419,25.7220
//Rute 3
#define buscp1			-538.8690,-516.8480,25.1795
#define buscp2			-483.4129,-595.5516,17.3002
#define buscp3			-343.3380,-780.7836,30.5175
#define buscp4			-281.9402,-878.5380,45.5282
#define buscp5			-94.1291,-1031.5458,23.7085
#define buscp6			-88.5098,-1502.4246,2.2528
#define buscp7			151.6783,-1561.1425,10.5222
#define buscp8			198.7756,-1503.1976,12.2431 // Stop Bus Pertama
#define buscp9			471.9628,-1311.1918,14.8591
#define buscp10			623.8340,-1360.3447,12.9780 // Stop Bus Kedua
#define buscp11			777.8528,-1407.7585,12.9248
#define buscp12			995.0657,-1408.8447,12.5839
#define buscp13			1181.6935,-1407.1083,12.7921
#define buscp14			1208.1864,-1330.8541,12.9545 // Stop Bus Ketiga
#define buscp15			1320.0668,-1283.7115,12.9396
#define buscp16			1359.8186,-1159.6917,23.2196
#define buscp17			1377.9844,-965.4411,33.2936
#define buscp18			1576.9023,-1070.5953,54.2314
#define buscp19			1593.4678,-1364.6587,28.4016
#define buscp20			1562.2347,-1468.1530,26.0337
#define buscp21			1804.6254,-1520.1663,6.6169
#define buscp22			2169.7104,-1558.3563,1.7617
#define buscp23			2408.1165,-1620.0015,11.0593
#define buscp24			2704.4893,-1624.8037,13.0307
#define buscp25			2825.7917,-1660.3298,10.2517
#define buscp26			2830.9343,-1766.6786,10.4319
#define buscp27			2822.3252,-2023.5198,10.4937
#define buscp28			2626.9556,-2154.9709,10.9860
#define buscp29			2366.1255,-2193.1228,12.9310
#define buscp30			2284.7634,-2303.8457,12.9358
#define buscp31			2231.1816,-2428.2588,12.9313
#define buscp32			2228.9028,-2656.8564,12.9359
#define buscp33			2461.0603,-2663.3271,13.0496
#define buscp34			2486.5044,-2523.4048,13.0738
#define buscp35			2726.0664,-2504.4375,13.0431
#define buscp36			2764.1736,-2448.1216,13.0635
#define buscp37			2681.0044,-2403.9053,13.0480
#define buscp38			2496.2546,-2288.4832,24.3161
#define buscp39			2298.2332,-2091.2871,12.8802
#define buscp40			2190.0852,-2154.4883,12.9393
#define buscp41			1960.2556,-2132.5403,12.9390
#define buscp42			1782.4114,-2164.1331,12.9390
#define buscp43			1532.2587,-1940.2086,17.4975
#define buscp44			1387.1505,-1870.4655,12.9435
#define buscp45			1128.3870,-1850.6742,12.9397
#define buscp46			979.2963,-1785.3818,13.6409
#define buscp47			649.4029,-1737.4253,12.9902
#define buscp48			227.1529,-1651.4077,11.9372
#define buscp49			126.3032,-1585.5298,10.0557
#define buscp50			218.9908,-1734.7703,3.8556
#define buscp51			361.6874,-1775.1991,4.8392
#define buscp52			461.1609,-1735.4956,9.2272
#define buscp53			355.7704,-1699.6305,6.2484
#define buscp54			97.0451,-1530.8501,5.4690
#define buscp55			-85.1381,-1497.5529,2.2514
#define buscp56			-93.4854,-1128.0330,0.6464
#define buscp57			-257.3445,-890.5715,44.0643
#define buscp58			-338.0441,-783.3821,31.3995
#define buscp59			-429.4999,-632.6268,11.3048
#define buscp60			-486.0949,-552.7361,25.1796
#define buscp61			-529.6942,-517.2155,25.1801
#define buscp62			-585.0031,-515.4481,25.1801

/*#define buspoint1 		1280.061767,-2059.221923,59.007038
#define buspoint2 		1406.055297,-2042.139648,54.090114
#define buspoint3 		1388.694702,-1967.259033,36.970306
#define buspoint4 		1274.351928,-1944.078491,29.449188
#define buspoint5 		1314.175903,-1915.889160,23.581806
#define buspoint6 		1428.827514,-1898.697509,13.864680
#define buspoint7 		1486.388183,-1874.732299,13.483360
#define buspoint8 		1527.490722,-1922.029785,15.756288
#define buspoint9 		1529.773315,-2037.733764,30.656585
#define buspoint10 		1611.311889,-2151.531005,26.838613
#define buspoint11 		1789.403564,-2168.911621,13.483464
#define buspoint12 		1935.325927,-2169.052978,13.483065
#define buspoint13 		1964.242919,-2070.636230,13.494494
#define buspoint14 		1964.018798,-1907.571533,13.483125
#define buspoint15 		1965.075073,-1779.868530,13.479113
#define buspoint16 		2060.129394,-1755.007446,13.488880
#define buspoint17 		2160.542480,-1755.085693,13.485799
#define buspoint18 		2198.407714,-1732.569335,13.494822
#define buspoint19 		2216.002197,-1875.839477,13.483457
#define buspoint20 		2216.152343,-2013.465087,13.449681
#define buspoint21 		2339.216552,-2139.990478,15.328786
#define buspoint22 		2464.309570,-2264.988769,25.163112
#define buspoint23 		2563.019287,-2363.141357,15.987734
#define buspoint24 		2670.505859,-2407.984619,13.555817
#define buspoint25 		2758.318359,-2430.743164,13.597185
#define buspoint26 		2763.975097,-2479.834228,13.575368
#define buspoint27 		2659.496582,-2501.279052,13.589831
#define buspoint28		2532.097412,-2501.937988,13.636500
#define buspoint29		2482.001953,-2577.090576,13.606858
#define buspoint30		2409.167968,-2660.492431,13.627305
#define buspoint31		2257.277099,-2661.927734,13.542902
#define buspoint32 		2227.485107,-2538.904296,13.509632
#define buspoint33 		2187.636474,-2492.173828,13.477516
#define buspoint34 		2158.403320,-2569.258544,13.475986
#define buspoint35 		2085.054687,-2665.911376,13.479298
#define buspoint36		1917.729125,-2668.174560,6.034108
#define buspoint37 		1783.769409,-2669.453857,5.979684
#define buspoint38 		1638.428466,-2669.250488,5.967841
#define buspoint39 		1472.686035,-2669.243164,11.927350
#define buspoint40 		1350.609497,-2578.896972,13.475920
#define buspoint41		1348.375732,-2405.036865,13.475702
#define buspoint42 		1361.083129,-2297.251708,13.486678
#define buspoint43 		1470.698364,-2334.642333,13.482721
#define buspoint44 		1559.332519,-2289.056396,13.486524
#define buspoint45 		1661.341674,-2321.407958,13.483482
#define buspoint46 		1735.662109,-2282.550292,13.475940
#define buspoint47 		1697.473754,-2250.877929,13.482275
#define buspoint48		1562.058715,-2283.249267,13.483885
#define buspoint49 		1473.046752,-2237.903320,13.483382
#define buspoint50 		1394.131225,-2282.712158,13.460983
#define buspoint51  	1325.282470,-2386.672119,13.475554
#define buspoint52 		1261.956054,-2444.065429,8.715504
#define buspoint53 		1149.169677,-2391.894531,11.152619
#define buspoint54      1042.016845,-2242.414794,13.042969
#define buspoint55		1051.437133,-2061.033691,13.037005
#define buspoint56      1060.096801,-1859.927856,13.488168
#define buspoint57      1164.005981,-1854.715087,13.497838
#define buspoint58      1235.685913,-1855.510986,13.481544//stop ke 3
#define buspoint59      1356.235473,-1867.938354,13.483355
#define buspoint60      1423.378295,-1903.542480,13.874370
#define buspoint61      1303.339843,-1907.860839,24.613706
#define buspoint62      1307.518798,-1958.998779,29.257463
#define buspoint63  	1426.418212,-1996.640136,50.198066
#define buspoint64      1295.822021,-2053.925292,58.574115
#define buspoint65      1260.515625,-2015.804565,59.541069
#define cpbus1 			1639.3451, -1439.9066, 13.3746
#define cpbus2 			1578.5664, -1297.4679, 17.2882
#define cpbus3 			1366.4038, -1239.3553, 13.3771
#define cpbus4 			1376.0468,  -933.2687, 34.1769
#define cpbus5 		 	 960.3029,  -969.7812, 38.8355
#define cpbus6 			1016.2396, -1146.9741, 23.6474
#define cpbus7 			1449.8273, -1163.9070, 23.6518
#define cpbus8 			1501.6725, -1440.9535, 13.3748
#define cpbus9 			1655.5128, -1481.2784, 13.3828*/
