//======== POINT ST MARKET ===========
#define buspointmarket1 1681.87, -1477.14, 12.94
#define buspointmarket2 1660.46, -1466.76, 12.95
#define buspointmarket3 1648.89, -1438.75, 12.95
#define buspointmarket4 1489.50, -1438.17, 12.94
#define buspointmarket5 1423.49, -1433.32, 12.95
#define buspointmarket6 1388.36, -1393.18, 12.94
#define buspointmarket7 1239.60, -1392.87, 12.70
#define buspointmarket8 1206.85, -1379.95, 12.81
#define buspointmarket9 1206.32, -1301.59, 12.95 //POINT
#define buspointmarket10 1189.88, -1278.53, 12.85
#define buspointmarket11 1087.21, -1277.89, 12.97
#define buspointmarket12 1056.00, -1298.03, 13.13
#define buspointmarket13 1042.11, -1318.93, 12.95
#define buspointmarket14 909.58, -1320.01, 13.05
#define buspointmarket15 816.95, -1319.78, 13.04
#define buspointmarket16 795.36, -1345.07, 12.95 //POINT
#define buspointmarket17 794.88, -1378.13, 13.01
#define buspointmarket18 810.91, -1407.56, 12.84
#define buspointmarket19 932.91, -1407.96, 12.81
#define buspointmarket20 1141.86, -1407.74, 13.07
#define buspointmarket21 1299.15, -1408.57,12.79
#define buspointmarket22 1340.03, -1419.14, 12.95
#define buspointmarket23 1301.20, -1531.93, 12.94
#define buspointmarket24 1294.62, -1677.00, 12.94 //POINT
#define buspointmarket25 1294.71, -1834.10, 12.95
#define buspointmarket26 1309.46, -1854.45, 12.94
#define buspointmarket27 1374.98, -1875.04, 12.94
#define buspointmarket28 1391.33, -1861.84, 12.94
#define buspointmarket29 1391.38, -1752.37, 12.93 //POINT
#define buspointmarket30 1405.54, -1734.84, 12.95
#define buspointmarket31 1547.07, -1735.61, 12.95
#define buspointmarket32 1649.04, -1735.15, 12.94
#define buspointmarket33 1692.52, -1718.35, 12.95 //POINT
#define buspointmarket34 1692.16, -1610.02, 12.95
#define buspointmarket35 1677.05, -1589.80, 12.94
#define buspointmarket36 1660.58, -1579.91, 12.96
#define buspointmarket37 1666.83, -1550.15, 12.95
#define buspointmarket38 1687.88, -1550.40, 12.94


//======== POINT ST EL CORONA ===========
#define buspointelcor1 1675.76, -1477.39, 12.95
#define buspointelcor2 1655.73, -1493.60, 12.93
#define buspointelcor3 1655.36, -1574.12, 12.93
#define buspointelcor4 1672.97, -1594.61, 12.93
#define buspointelcor5 1838.24, -1614.89, 12.93
#define buspointelcor6 1939.30, -1663.51, 12.94
#define buspointelcor7 1938.95, -1733.88, 12.95 //POINT
#define buspointelcor8 1951.55, -1754.46, 12.94
#define buspointelcor9 2068.77, -1754.72, 12.95
#define buspointelcor10 2083.96, -1773.06, 12.95 //POINT
#define buspointelcor11 2079.10, -1866.85, 12.93
#define buspointelcor12 2076.31, -1929.46, 12.89
#define buspointelcor13 1871.04, -1929.58, 12.95
#define buspointelcor14 1824.31, -1897.71, 12.92
#define buspointelcor15 1824.52, -1825.42, 12.97 //POINT
#define buspointelcor16 1824.32, -1748.74, 12.95
#define buspointelcor17 1811.02, -1730.77, 12.94
#define buspointelcor18 1762.30, -1729.30, 12.94
#define buspointelcor19 1752.57, -1717.11, 12.93
#define buspointelcor20 1752.70, -1623.06, 12.96
#define buspointelcor21 1734.44, -1594.87, 12.93 //POINT
#define buspointelcor22 1675.01, -1589.44, 12.95
#define buspointelcor23 1661.27, -1581.43, 12.94
#define buspointelcor24 1666.85, -1551.15, 12.95
#define buspointelcor25 1690.34, -1550.41, 12.94

new BusVeh[4];
AddBusVehicle()
{
	BusVeh[0] = AddStaticVehicleEx(431, 1704.87, -1539.68, 13.48+0.5, 0.65, 0, 0, VEHICLE_RESPAWN);
	BusVeh[1] = AddStaticVehicleEx(431, 1704.86, -1522.92, 13.49+0.5, 0.27, 0, 0, VEHICLE_RESPAWN);
	BusVeh[2] = AddStaticVehicleEx(431, 1704.87, -1507.92, 13.48+0.5, 359.92, 0, 0, VEHICLE_RESPAWN);
	BusVeh[3] = AddStaticVehicleEx(431, 1704.90, -1493.37, 13.49+0.5, 359.23, 0, 0, VEHICLE_RESPAWN);
}

IsABusVeh(carid)
{
	for(new v = 0; v < sizeof(BusVeh); v++) {
	    if(carid == BusVeh[v]) return 1;
	}
	return 0;
}
