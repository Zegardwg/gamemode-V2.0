
new sjforklift,
    sjmower,
    sjsweeper,
    sjbus,
    sjtrashmaster,
    jobpizzaprice,
    jobbutcherprice,
    jobpemerahprice,
    jobreflenishprice,
    jobtruckerprice,
    drugdealerprice1,
    drugdealerprice2,
    drugdealerprice3,
    jobminerprice,
    productprice1,
    productprice2,
    productprice3,
    haulingprice1,
    haulingprice2,
    haulingprice3,
    factionprice;

function LoadJobPrice()
{
    cache_get_value_name_int(0, "sjforklift", sjforklift);
    cache_get_value_name_int(0, "sjmower", sjmower);
    cache_get_value_name_int(0, "sjsweeper", sjsweeper);
    cache_get_value_name_int(0, "sjbus", sjbus);
    cache_get_value_name_int(0, "sjtrashmaster", sjtrashmaster);
    cache_get_value_name_int(0, "jobpizza", jobpizzaprice);
    cache_get_value_name_int(0, "jobbutcher", jobbutcherprice);
    cache_get_value_name_int(0, "jobpemerassusu",jobpemerahprice);
    cache_get_value_name_int(0, "jobreflenish", jobreflenishprice);
    cache_get_value_name_int(0, "jobtrucker", jobtruckerprice);
    cache_get_value_name_int(0, "drugdealer1", drugdealerprice1);
    cache_get_value_name_int(0, "drugdealer2", drugdealerprice2);
    cache_get_value_name_int(0, "drugdealer3", drugdealerprice3);
    cache_get_value_name_int(0, "jobminer", jobminerprice);
    cache_get_value_name_int(0, "production1", productprice1);
    cache_get_value_name_int(0, "production2", productprice2);
    cache_get_value_name_int(0, "production3", productprice3);
    cache_get_value_name_int(0, "hauling1", haulingprice1);
    cache_get_value_name_int(0, "hauling2", haulingprice2);
    cache_get_value_name_int(0, "hauling3", haulingprice3);
    cache_get_value_name_int(0, "factionprice", factionprice);
    printf("[Jobs Price] Number of Loaded Data Server...");
}

JobPrice_Save()
{
    new str[3048];

    format(str, sizeof(str), "UPDATE jobprice SET sjforklift='%d', sjmower='%d', sjsweeper='%d', sjbus='%d', sjtrashmaster='%d', jobpizza='%d', jobbutcher='%d', jobpemerassusu='%d', jobreflenish='%d', jobtrucker='%d', drugdealer1='%d', drugdealer2='%d', drugdealer3='%d', jobminer='%d', production1='%d', production2='%d', production3='%d', hauling1='%d', hauling2='%d', hauling3='%d', factionprice='%d' WHERE id=0",
    sjforklift,
    sjmower, 
    sjsweeper, 
    sjbus,
    sjtrashmaster,
    jobpizzaprice, 
    jobbutcherprice, 
    jobpemerahprice,
    jobreflenishprice,
    jobtruckerprice, 
    drugdealerprice1,
    drugdealerprice2,
    drugdealerprice3,
    jobminerprice,
    productprice1, 
    productprice2, 
    productprice3,
    haulingprice1,
    haulingprice2,
    haulingprice3,
    factionprice
    );

    return mysql_tquery(g_SQL, str);
}

CMD:setjobprice(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
        
    new name[64], string[128];
    if(sscanf(params, "s[2048]S()[1024]", name, string))
    {
        Usage(playerid, "/setjobprice [name] [price]");
        Names(playerid, "sjforklift, sjmower, sjsweeper, sjbus, sjtrashmaster, jobpizza, jobbutcher, jobpemerassusu, jobreflenish, jobtrucker, jobminer, factionprice");
        Names(playerid, "drugdealer1, drugdealer2, drugdealer3, production1, production2, production3, hauling1, hauling2, hauling3, list");
        return 1;
    }
    if(!strcmp(name, "sjforklift", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [sjforklift] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        sjforklift = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji sidejob forklift menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "sjmower", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [sjmower] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        sjmower = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji sidejob mower menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "sjsweeper", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [sjsweeper] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        sjsweeper = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji sidejob sweeper menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "sjbus", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [sjbus] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        sjbus = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji sidejob bus menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "sjtrashmaster", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [sjtrashmaster] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        sjtrashmaster = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah perkalian gaji sidejob Trash Master menjadi %d.", pData[playerid][pAdminname], price);
    }
    else if(!strcmp(name, "jobpizza", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [jobpizza] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        jobpizzaprice = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji job pizza menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "jobbutcher", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [jobbutcher] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        jobbutcherprice = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji job butcher menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "jobpemerassusu", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [jobpemerasusu] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        jobpemerahprice = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji job pemeras susu sapi menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "jobreflenish", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [jobreflenish] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        jobreflenishprice = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji job reflenish menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "jobtrucker", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [jobtrucker] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        jobtruckerprice = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji job trucker menjadi %s.", pData[playerid][pAdminname],FormatMoney(price));
    }
    else if(!strcmp(name, "drugdealer1", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [drugdealer1] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        drugdealerprice1 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji Drug Dealer (Antar Marijuana) menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "drugdealer2", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [drugdealer2] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        drugdealerprice2 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji Drug Dealer (Antar Raw Ephedrine) menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "drugdealer3", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [drugdealer3] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        drugdealerprice3 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji Drug Dealer (Antar Cocaine) menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "jobminer", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [jobminer] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        jobminerprice = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji Job miner menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "production1", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [production1] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        productprice1 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah harga jual production 1 menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "production2", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [production2] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        productprice2 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah harga jual production 2 menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "production3", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [production3] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        productprice3 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah harga jual production 3 menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "hauling1", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [hauling1] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        haulingprice1 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji antar hauling (dealer) menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "hauling2", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [hauling2] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        haulingprice2 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji antar hauling (gas station) menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "hauling3", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [hauling3] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        haulingprice3 = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji antar hauling (Miner) menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "factionprice", true))
    {
        new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setjobprice [factionprice] [price]");

        if(price < 0 || price > 1000000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000000.");

        factionprice = price;
        JobPrice_Save();
        SendAdminMessage(COLOR_RED, "%s merubah gaji faction duty perjam menjadi %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "list", true))
    {
        new str[3500];
        format(str, sizeof(str), ""WHITE_E"SIDE JOB FORKLIFT: {00ff00}%s\n", FormatMoney(sjforklift));
        format(str, sizeof(str), "%s"WHITE_E"SIDE JOB MOWER: {00ff00}%s\n", str, FormatMoney(sjmower));
        format(str, sizeof(str), "%s"WHITE_E"SIDE JOB SWEEPER: {00ff00}%s\n", str, FormatMoney(sjsweeper));
        format(str, sizeof(str), "%s"WHITE_E"SIDE JOB BUS: {00ff00}%s\n", str, FormatMoney(sjbus));
        format(str, sizeof(str), "%s"WHITE_E"SIDE JOB TRASH MASTER: {00ff00}5 sampah (full slot) x %d total gaji %s\n\n", str, sjtrashmaster, FormatMoney(sjtrashmaster * 5));
        format(str, sizeof(str), "%s"WHITE_E"JOB PIZZA: {00ff00}%s\n", str, FormatMoney(jobpizzaprice));
        format(str, sizeof(str), "%s"WHITE_E"JOB BUTCHER: {00ff00}%s\n", str, FormatMoney(jobbutcherprice));
        format(str, sizeof(str), "%s"WHITE_E"JOB REFLENISH: {00ff00}%s\n", str, FormatMoney(jobreflenishprice));

        format(str, sizeof(str), "%s"WHITE_E"JOB TRUCKER: {00ff00} JARAK x 2 + %s \n", str, FormatMoney(jobtruckerprice));
        format(str, sizeof(str), "%s"WHITE_E"JOB MINER: {00ff00}%s\n", str, FormatMoney(jobminerprice));
        format(str, sizeof(str), "%s"WHITE_E"JOB LUMBER: {00ff00}(%s/Full 10 Kayu) (%s/item)\n\n", str, FormatMoney(LumberPrice*10), FormatMoney(LumberPrice));

        format(str, sizeof(str), "%s"WHITE_E"JOB DRUG DEALER1: {00ff00}%s (Antar Marijuana)\n", str, FormatMoney(drugdealerprice1));
        format(str, sizeof(str), "%s"WHITE_E"JOB DRUG DEALER2: {00ff00}%s (Antar Ephedrine)\n", str, FormatMoney(drugdealerprice2));
        format(str, sizeof(str), "%s"WHITE_E"JOB DRUG DEALER3: {00ff00}%s (Antar Cocaine)\n\n", str, FormatMoney(drugdealerprice3));

        format(str, sizeof(str), "%s"WHITE_E"JOB PRODUCTION: {00ff00}%s (Harga Jual Production 1)\n", str, FormatMoney(productprice1));
        format(str, sizeof(str), "%s"WHITE_E"JOB PRODUCTION: {00ff00}%s (Harga Jual Production 2)\n", str, FormatMoney(productprice2));
        format(str, sizeof(str), "%s"WHITE_E"JOB PRODUCTION: {00ff00}%s (Harga Jual Production 3)\n\n", str, FormatMoney(productprice3));

        format(str, sizeof(str), "%s"WHITE_E"JOB HAULING: {00ff00}%s (Harga Antar Dealer)\n", str, FormatMoney(haulingprice1));
        format(str, sizeof(str), "%s"WHITE_E"JOB HAULING: {00ff00}%s (Harga Antar Gas Stations)\n", str, FormatMoney(haulingprice2));
        format(str, sizeof(str), "%s"WHITE_E"JOB HAULING: {00ff00}%s (Harga Antar Miner)\n\n", str, FormatMoney(haulingprice3));
        format(str, sizeof(str), "%s"WHITE_E"GAJI ALL FACTION: {00ff00}%s/Hours\n", str, FormatMoney(factionprice));
        ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"LIST PRICE JOB (VR:RP)", str, "Close", "");
    }
    return 1;
}