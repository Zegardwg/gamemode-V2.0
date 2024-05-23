/*

	VEHICLE SHOWROOM

*/

new vehshoowrom[4];

AddvehShowroom()
{
	vehshoowrom[0] = CreateVehicle(506, 891.785, -1729.401, -55.543, 180.427, -1, -1, -1, 0);
    SetVehicleVirtualWorld(vehshoowrom[0], 0);
    LinkVehicleToInterior(vehshoowrom[0], 11);
    vehshoowrom[1] = CreateVehicle(541, 899.999, -1729.190, -55.543, 177.669, 0, 0, -1, 0);
    SetVehicleVirtualWorld(vehshoowrom[1], 0);
    LinkVehicleToInterior(vehshoowrom[1], 11);
    vehshoowrom[2] = CreateVehicle(560, 900.103, -1741.853, -55.543, 0.738, -1, -1, -1, 0);
    SetVehicleVirtualWorld(vehshoowrom[2], 0);
    LinkVehicleToInterior(vehshoowrom[2], 11);
    vehshoowrom[3] = CreateVehicle(559, 892.004, -1742.835, -55.573, 353.386, -1, -1, -1, 0);
    SetVehicleVirtualWorld(vehshoowrom[3], 0);
    LinkVehicleToInterior(vehshoowrom[3], 11);
}

IsShowroomCar(carid)
{
	for(new v = 0; v < sizeof(vehshoowrom); v++)
	{
	    if(carid == vehshoowrom[v]) return 1;
	}
	return 0;
}