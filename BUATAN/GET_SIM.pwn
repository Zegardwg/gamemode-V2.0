//Driving School
#define getsimpoint1 1264.33, -1849.23 ,13.26
#define getsimpoint2 1065.22, -1845.44 ,13.28
#define getsimpoint3 920.78, -1765.20 ,13.25
#define getsimpoint4 920.26, -1548.35 ,13.25
#define getsimpoint5 926.70, -1408.57 ,13.13
#define getsimpoint6 1338.93, -1413.55 ,13.25
#define getsimpoint7 1294.91, -1648.33 ,13.25
#define getsimpoint8 1288.89, -1709.03 ,13.25
#define getsimpoint9 1173.90, -1719.54 ,13.52
#define getsimpoint10 1179.24, -1853.98 ,13.27
#define getsimpoint11 1212.57, -1841.86 ,13.25
#define getsimpoint12 1243.83, -1817.86 ,13.29

CreateGetSimPoint()
{
	new strings[128];
	//tempat ambil sim
	CreateDynamicPickup(1239, 23, -2033.43, -117.49, 1035.17, -1);
	format(strings, sizeof(strings), "[DRIVING LICENSE]\n{FFFFFF}/newdrivelic - create new driving license");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -2033.43, -117.49, 1035.17, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Driving Lic
}

new DRIVESIMVehicles[4];

AddDriveSimVehicle()
{
	new strings[128];
	CreateDynamicPickup(1239, 23, -2033.43, -117.49, 1035.17, -1);
	format(strings, sizeof(strings), "MEMEK");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -2033.43, -117.49, 1035.17, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Driving Lic
	//DRIVESIMVehicles[0] = AddStaticVehicleEx(445, 1267.40, -1797.32, 13.28, 180.24, 1, 1, VEHICLE_RESPAWN, 1); //DRIVE SIM
	//DRIVESIMVehicles[1] = AddStaticVehicleEx(445, 1272.94, -1797.22, 13.27, 180.14, 1, 1, VEHICLE_RESPAWN, 1); //DRIVE SIM
	//DRIVESIMVehicles[2] = AddStaticVehicleEx(445, 1278.42, -1797.19, 13.26, 180.11, 1, 1, VEHICLE_RESPAWN, 1); //DRIVE SIM
}

IsDRIVESIMCar(carid)
{
	for(new v = 0; v < sizeof(DRIVESIMVehicles); v++)
	{
	    if(carid == DRIVESIMVehicles[v]) return 1;
	}
	return 0;
}