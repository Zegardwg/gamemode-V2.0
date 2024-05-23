//======== Sweper ===========
#define sweperpoint1 2216.0010, -1956.93, 13.03
#define sweperpoint2 2218.7676, -1817.02, 12.86
#define sweperpoint3 2225.2803, -1735.86, 13.05
#define sweperpoint4 2331.8809, -1735.14, 13.05
#define sweperpoint5 2410.7786, -1743.49, 13.05
#define sweperpoint6 2410.7288, -1937.48, 13.05
#define sweperpoint7 2399.2109, -1969.50, 13.05
#define sweperpoint8 2291.4946, -1969.96, 13.07
#define sweperpoint9 2219.3618, -1971.37, 13.00
#define sweperpoint10 2196.5674, -1977.65, 13.22

new SweepVeh[5];

AddSweeperVehicle()
{
	SweepVeh[0] = AddStaticVehicleEx(574, 2187.22, -1976.31, 13.27, 178.09, 1, 1, VEHICLE_RESPAWN);
	SweepVeh[1] = AddStaticVehicleEx(574, 2182.69, -1976.26, 13.27, 178.80, 1, 1, VEHICLE_RESPAWN);
	SweepVeh[2] = AddStaticVehicleEx(574, 2178.35, -1976.27, 13.27, 179.50, 1, 1, VEHICLE_RESPAWN);
	SweepVeh[3] = AddStaticVehicleEx(574, 2173.67, -1976.09, 13.28, 179.10, 1, 1, VEHICLE_RESPAWN);
	//SweepVeh[3] = AddStaticVehicleEx(574, 1295.0103, -1878.3979, 14.0000, 0.0000, 1, 1, VEHICLE_RESPAWN);
	//SweepVeh[4] = AddStaticVehicleEx(574, 1291.9260, -1878.4087, 14.0000, 0.0000, 1, 1, VEHICLE_RESPAWN);
}

IsASweeperVeh(carid)
{
	for(new v = 0; v < sizeof(SweepVeh); v++) {
	    if(carid == SweepVeh[v]) return 1;
	}
	return 0;
}
