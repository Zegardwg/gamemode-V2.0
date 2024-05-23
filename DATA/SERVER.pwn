new ServerMoney, //2255.92, -1747.33, 1014.77
	Material,
	MaterialPrice,
	LumberPrice,
	Component,
	ComponentPrice,
	Product,
	ProductPrice,
	Apotek,
	MedicinePrice,
	MedkitPrice,
	Food,
	FoodPrice,
	SeedPrice,
	PotatoPrice,
	Gandum,
	GandumPrice,
	WheatPrice,
	OrangePrice,
	Marijuana,
	MarijuanaPrice,
	Ephedrine,
	EphedrinePrice,
	Cocaine,
	CocainePrice,
	FishPrice,
	GStationPrice,
    FirstSpawnPrice,
    Daging,
    DagingPrice,
    Susu,
    SusuPrice,
    MilkPrice,
    AyamFill,
	AyamFillPrice,
	BuluAyam,
	BuluAyamPrice;
	
new MoneyPickup,
	Text3D:MoneyText,
	MatPickup,
	Text3D:MatText,
	CompPickup,
	Text3D:CompText,
	ProductPickup[2],
	Text3D:ProductText[2],
	ApotekPickup,
	Text3D:ApotekText,
	FoodPickup,
	Text3D:FoodText,
	MarijuanaPickup,
	Text3D:MarijuanaText,
	EphedrinePickup,
	Text3D:EphedrineText,
	CocainePickup,
	Text3D:CocaineText,
	Text3D:DagingText,
	Text3D:SusuText,
	AyamPickup,
	Text3D:AyamText,
	BuluPickup,
	Text3D:BuluText;

	
CreateServerPoint()
{
	if(IsValidDynamic3DTextLabel(MoneyText))
            DestroyDynamic3DTextLabel(MoneyText);

	if(IsValidDynamicPickup(MoneyPickup))
		DestroyDynamicPickup(MoneyPickup);
			
	//Server Money
	new strings[1024];
	MoneyPickup = CreateDynamicPickup(1239, 23, -984.91, 1468.59, 1332.02, -1, -1, -1, 5.0);
	format(strings, sizeof(strings), "[Server Money]\n"WHITE_E"Goverment Money: "LG_E"%s\n"WHITE_E"/robvault - to rob money from vault", FormatMoney(ServerMoney));
	MoneyText = CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -984.91, 1468.59, 1332.02, 5.0);
	
	if(IsValidDynamic3DTextLabel(MatText))
            DestroyDynamic3DTextLabel(MatText);

	if(IsValidDynamicPickup(MatPickup))
		DestroyDynamicPickup(MatPickup);
	
	if(IsValidDynamic3DTextLabel(CompText))
            DestroyDynamic3DTextLabel(CompText);

	if(IsValidDynamicPickup(CompPickup))
		DestroyDynamicPickup(CompPickup);
		
	if(IsValidDynamic3DTextLabel(ProductText[0]))
        DestroyDynamic3DTextLabel(ProductText[0]);
	
    if(IsValidDynamic3DTextLabel(ProductText[1]))
        DestroyDynamic3DTextLabel(ProductText[1]);

	if(IsValidDynamicPickup(ProductPickup[0]))
		DestroyDynamicPickup(ProductPickup[0]);

    if(IsValidDynamicPickup(ProductPickup[1]))
        DestroyDynamicPickup(ProductPickup[1]);

	if(IsValidDynamic3DTextLabel(ApotekText))
        DestroyDynamic3DTextLabel(ApotekText);
		
	if(IsValidDynamicPickup(ApotekPickup))
		DestroyDynamicPickup(ApotekPickup);
	
	if(IsValidDynamic3DTextLabel(FoodText))
            DestroyDynamic3DTextLabel(FoodText);
		
	if(IsValidDynamicPickup(FoodPickup))
		DestroyDynamicPickup(FoodPickup);
		
	if(IsValidDynamic3DTextLabel(MarijuanaText))
            DestroyDynamic3DTextLabel(MarijuanaText);
		
	if(IsValidDynamicPickup(MarijuanaPickup))
		DestroyDynamicPickup(MarijuanaPickup);

	if(IsValidDynamic3DTextLabel(EphedrineText))
           DestroyDynamic3DTextLabel(EphedrineText);
		
	if(IsValidDynamicPickup(EphedrinePickup))
		DestroyDynamicPickup(EphedrinePickup);

	if(IsValidDynamic3DTextLabel(CocaineText))
           DestroyDynamic3DTextLabel(CocaineText);
		
	if(IsValidDynamicPickup(CocainePickup))
		DestroyDynamicPickup(CocainePickup);

	if(IsValidDynamic3DTextLabel(DagingText))
           DestroyDynamic3DTextLabel(DagingText);

    if(IsValidDynamic3DTextLabel(SusuText))
           DestroyDynamic3DTextLabel(SusuText);

    if(IsValidDynamic3DTextLabel(AyamText))
            DestroyDynamic3DTextLabel(AyamText);

	if(IsValidDynamicPickup(AyamPickup))
		DestroyDynamicPickup(AyamPickup);

	if(IsValidDynamic3DTextLabel(BuluText))
            DestroyDynamic3DTextLabel(BuluText);

	if(IsValidDynamicPickup(BuluPickup))
		DestroyDynamicPickup(BuluPickup);

	//JOBS
	MatPickup = CreateDynamicPickup(1239, 23, -258.23, -2189.83, 28.97, -1, -1, -1, 10.0);
	format(strings, sizeof(strings), "[Material]\n"WHITE_E"Material Stock: "LG_E"%d\n\n"WHITE_E"Material Price: "LG_E"%s /item\n\n"WHITE_E"Lumber Price: "LG_E"%s /item\n"LB_E"/buy", Material, FormatMoney(MaterialPrice), FormatMoney(LumberPrice));
	MatText = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -258.23, -2189.83, 28.97+0.5, 10.0); // lumber
	
	CompPickup = CreateDynamicPickup(1239, 23, 601.71, 867.77, -42.96, -1, -1, -1, 5.0);
	format(strings, sizeof(strings), "[Miner]\n"WHITE_E"Component Stock: "LG_E"%d\n\n"WHITE_E"Component Price: "LG_E"%s /item\n"LB_E"/buy", Component, FormatMoney(ComponentPrice));
	CompText = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 601.71, 867.77, -42.96, 5.0); // comp
	
	ProductPickup[0] = CreateDynamicPickup(1239, 23, -280.74, -2149.14, 28.54, -1, -1, -1, 10.0);
	format(strings, sizeof(strings), "[Product]\n"WHITE_E"Product Stock: "LG_E"%d\n"WHITE_E"/sellproduct - sell product", Product);
	ProductText[0] = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -280.74, -2149.14, 28.54+0.3, 10.0); // product original
	
    ProductPickup[1] = CreateDynamicPickup(1239, 23, -62.03, -1121.26, 1.29, -1, -1, -1, 10.0);
    format(strings, sizeof(strings), "[TRUCKER BOX]\n"WHITE_E"/loadbox - load bisnis product to vehicle");
    ProductText[1] = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -62.03, -1121.26, 1.29+0.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0); // product trucker

	ApotekPickup = CreateDynamicPickup(1241, 23, 2856.2964,1250.2919,-64.3797, -1, -1, -1, 5.0);
	format(strings, sizeof(strings), "[GUDANG SAMD]\n"WHITE_E"Gudang Stock: "LG_E"%d\n"LB_E"/buy", Apotek);
	ApotekText = CreateDynamic3DTextLabel(strings, COLOR_PINK, 2856.2964,1250.2919,-64.3797, 5.0); // Apotek hospital
	
	//FoodPickup = CreateDynamicPickup(1239, 23, -382.97, -1426.43, 26.31, -1, -1, -1, 10.0);
	format(strings, sizeof(strings), "[Food]\n"WHITE_E"Food Stock: "LG_E"%d\n"WHITE_E"Food Price: "LG_E"%s /item\n"WHITE_E"Gandum Stock: "LG_E"%d\n"WHITE_E"Gandum Price: "LG_E"%s /item\n\n"WHITE_E"Seed Price: "LG_E"%s /item\n"WHITE_E"Potato Price: "LG_E"%s /kg\n"WHITE_E"Wheat Price: "LG_E"%s /kg\n"WHITE_E"Orange Price: "LG_E"%s /kg",
	Food, FormatMoney(FoodPrice), Gandum, FormatMoney(GandumPrice), FormatMoney(SeedPrice), FormatMoney(PotatoPrice), FormatMoney(WheatPrice), FormatMoney(OrangePrice));
	FoodText = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -382.97, -1426.43, 26.31+1, 10.0); // food*/

	AyamPickup = CreateDynamicPickup(1239, 23, -1101.9401,-1654.8589,76.3672, -1, -1, -1, 50.0);
	format(strings, sizeof(strings), "[GUDANG AYAM]\n"WHITE_E"Ayam Stock: "LG_E"%d\n\n"WHITE_E"Ayam Price: "LG_E"%s \n"LB_E"/buy", AyamFill, FormatMoney(AyamFillPrice));
	AyamText = CreateDynamic3DTextLabel(strings, COLOR_GREY, -1101.9401,-1654.8589,76.3672, 5.0);//ayam

	BuluPickup = CreateDynamicPickup(1239, 23, -1106.8861,-1637.5360,76.3672, -1, -1, -1, 50.0);
	format(strings, sizeof(strings), "[BULU AYAM]\n"WHITE_E"Bulu Stock: "LG_E"%d\n\n"WHITE_E"Bulu Price: "LG_E"%s \n"LB_E"/buy", BuluAyam, FormatMoney(BuluAyamPrice));
	BuluText = CreateDynamic3DTextLabel(strings, COLOR_GREY, -1106.8861,-1637.5360,76.3672, 5.0);//ayam

	/*//SEEDS MARIJUANA
	MarijuanaPickup = CreateDynamicPickup(1578, 23, 321.86, 1117.14, 1083.88, -1);
	format(strings, sizeof(strings), "Marijuana\n"WHITE_E"Stock: %d\nPrice: %s/Item\n/buydrugs [marijuana] [ammount]", Marijuana, FormatMoney(MarijuanaPrice));
	MarijuanaText = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 321.86, 1117.14, 1083.88+0.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); */

	//RAW EPHEDRINE
	EphedrinePickup = CreateDynamicPickup(1577, 23, 323.99, 1117.11, 1083.88, -1);
	format(strings, sizeof(strings), "Raw Ephedrine\n"WHITE_E"Stock: %d\nPrice: %s/Item\n/buydrugs [ephedrine] [ammount]", Ephedrine, FormatMoney(EphedrinePrice));
	EphedrineText = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 323.99, 1117.11, 1083.88+0.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

	//COCAINE
	CocainePickup = CreateDynamicPickup(1575, 23, 330.9419,1129.3291,1083.8828, -1);
	format(strings, sizeof(strings), "Cocaine\n"WHITE_E"Stock: %d\nPrice: %s/Item\n/buydrugs [cocaine] [ammount]", Cocaine, FormatMoney(CocainePrice));
	CocaineText = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 330.9419,1129.3291,1083.8828+0.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

	//STOCK DAGING
	format(strings, sizeof(strings), "[SELL DAGING]\n"WHITE_E"Stock: %d\nPrice: %s/Item\n/buy", Daging, FormatMoney(DagingPrice));
	DagingText = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1996.39, -2065.53, 13.54+0.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	//STOCK SUSU
	format(strings, sizeof(strings), "[BUY/SELL SUSU]\n"WHITE_E"Stock: %d\nPrice: %s/Item", Daging, FormatMoney(DagingPrice));
	SusuText = CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 313.61, 1147.21, 8.58+0.3, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 
}

Server_Percent(price)
{
    return floatround((float(price) / 100) * 85);
}

Server_AddPercent(price)
{
    new money = (price - Server_Percent(price));
    ServerMoney = ServerMoney + money;
    Server_Save();
}

Server_AddMoney(amount)
{
    ServerMoney = ServerMoney + amount;
    Server_Save();
}

Server_MinMoney(amount)
{
    ServerMoney -= amount;
    Server_Save();
}

Server_Save()
{
    new str[2024];

	CreateServerPoint();
    format(str, sizeof(str), "UPDATE server SET servermoney='%d', material='%d', materialprice='%d', lumberprice='%d', component='%d', componentprice='%d', product='%d', productprice='%d', medicineprice='%d', medkitprice='%d', food='%d', foodprice='%d', seedprice='%d', potatoprice='%d', gandum='%d', gandumprice='%d', wheatprice='%d', orangeprice='%d', marijuana='%d', marijuanaprice='%d', ephedrine='%d', ephedrineprice='%d', cocaine='%d', cocaineprice='%d', fishprice='%d', gstationprice='%d', firstspawnprice='%d', daging='%d', dagingprice='%d', susu='%d', susuprice='%d', milkprice='%d', ayamfill='%d', ayamfillprice='%d', buluayam='%d', buluayamprice='%d' WHERE id=0",
	ServerMoney, Material, MaterialPrice, LumberPrice, Component, ComponentPrice, Product, ProductPrice, MedicinePrice, MedkitPrice, 
	Food, FoodPrice, SeedPrice, PotatoPrice, Gandum, GandumPrice, WheatPrice, OrangePrice, Marijuana, MarijuanaPrice, Ephedrine, EphedrinePrice, Cocaine, CocainePrice, FishPrice, GStationPrice, FirstSpawnPrice, Daging, DagingPrice, Susu, SusuPrice, MilkPrice, AyamFill, AyamFillPrice, BuluAyam, BuluAyamPrice);
    return mysql_tquery(g_SQL, str);
}

function LoadServer()
{
	cache_get_value_name_int(0, "servermoney", ServerMoney);
	cache_get_value_name_int(0, "material", Material);
	cache_get_value_name_int(0, "materialprice", MaterialPrice);
	cache_get_value_name_int(0, "lumberprice", LumberPrice);
	cache_get_value_name_int(0, "component", Component);
	cache_get_value_name_int(0, "componentprice", ComponentPrice);
	cache_get_value_name_int(0, "product", Product);
	cache_get_value_name_int(0, "productprice", ProductPrice);
	cache_get_value_name_int(0, "apotek", Apotek);
	cache_get_value_name_int(0, "medicineprice", MedicinePrice);
	cache_get_value_name_int(0, "medkitprice", MedkitPrice);
	cache_get_value_name_int(0, "food", Food);
	cache_get_value_name_int(0, "foodprice", FoodPrice);
	cache_get_value_name_int(0, "seedprice", SeedPrice);
	cache_get_value_name_int(0, "potatoprice", PotatoPrice);
	cache_get_value_name_int(0, "gandum", Gandum);
	cache_get_value_name_int(0, "gandumprice", GandumPrice);
	cache_get_value_name_int(0, "wheatprice", WheatPrice);
	cache_get_value_name_int(0, "orangeprice", OrangePrice);
	cache_get_value_name_int(0, "marijuana", Marijuana);
	cache_get_value_name_int(0, "marijuanaprice", MarijuanaPrice);
	cache_get_value_name_int(0, "ephedrine", Ephedrine);
	cache_get_value_name_int(0, "ephedrineprice", EphedrinePrice);
	cache_get_value_name_int(0, "cocaine", Cocaine);
	cache_get_value_name_int(0, "cocaineprice", CocainePrice);
	cache_get_value_name_int(0, "fishprice", FishPrice);
	cache_get_value_name_int(0, "gstationprice", GStationPrice);
    cache_get_value_name_int(0, "firstspawnprice", FirstSpawnPrice);
    cache_get_value_name_int(0, "daging", Daging);
    cache_get_value_name_int(0, "dagingprice", DagingPrice);
    cache_get_value_name_int(0, "susu", Susu);
    cache_get_value_name_int(0, "susuprice", SusuPrice);
    cache_get_value_name_int(0, "milkprice", MilkPrice);
    cache_get_value_name_int(0, "ayamfill", AyamFill);
	cache_get_value_name_int(0, "ayamfillprice", AyamFillPrice);
	cache_get_value_name_int(0, "buluayam", BuluAyam);
	cache_get_value_name_int(0, "buluayamprice", BuluAyamPrice);
	//printf("[Server] Number of Loaded Data Server...");
	printf("[Server] Loaded Data Valrise Reality...");
	printf("[Server] Developer By Genzo....");
	printf("[Server] ServerMoney: %d", ServerMoney);
	//printf("[Server] Material: %d", Material);
	//printf("[Server] MaterialPrice: %d", MaterialPrice);
	//printf("[Server] LumberPrice: %d", LumberPrice);
	
	CreateServerPoint();
}