#define MAX_BILLS 4500

enum billing
{
    bilType,
    bilName[230],
    billoName[128],
    billTargetName[128],
    bilTarget,
    bilTime,
    bilPtarget,
    bilammount
}

enum
{
    FA_POLICE = 1,
    FA_MEDIC = 2,
    FA_GOV = 3,
    FA_NEWS = 4,
    FA_CF = 5
}


new bilData[MAX_BILLS][billing],
    Iterator:tagihan<MAX_BILLS>;

function LoadBill()
{
    new rows = cache_num_rows();
    if(rows)
    {
        new oname[128], targetname[128], tagid;
        for(new i; i < rows; i++)
        {
            cache_get_value_name_int(i, "bid", tagid);
            cache_get_value_name_int(i, "type", bilData[tagid][bilType]);
            cache_get_value_name(i, "name", bilData[tagid][bilName], 230);
            cache_get_value_name(i, "oname", oname);
            format(bilData[tagid][billoName], 128, oname);
            cache_get_value_name(i, "targetname", targetname);
            format(bilData[tagid][billTargetName], 128, targetname);
            cache_get_value_name_int(i, "target", bilData[tagid][bilTarget]);
            cache_get_value_name_int(i, "time", bilData[tagid][bilTime]);
            cache_get_value_name_int(i, "phonetarget", bilData[tagid][bilPtarget]);
            cache_get_value_name_int(i, "ammount", bilData[tagid][bilammount]);
            
            Iter_Add(tagihan, tagid);
        }
        printf("[BILL] %d Loaded.", rows);
    }
    if(!rows)
    {
        print("[BILL] 0 Loaded.");
    }
}

stock ReturnFa(playerid)
{
    if(pData[playerid][pFaction] == 1)
    {
        return FA_POLICE;
    }
    else if(pData[playerid][pFaction] == 3)
    {
        return FA_MEDIC;
    }
    else if(pData[playerid][pFaction] == 2)
    {
        return FA_GOV;
    }
    else if(pData[playerid][pFaction] == 4)
    {
        return FA_NEWS;
    }
    else if(pData[playerid][pFaction] == 5)
    {
        return FA_CF;
    }
    else 
    {
        return 0;
    }
}

CMD:giveinvoice(playerid, params[])
{
    if(!pData[playerid][pFaction]) return Error(playerid, "You are not faction");
    new biid = Iter_Free(tagihan);
    new id, ammount, namebil[128];
    if(biid == -1) return Error(playerid, "Kamu tidak bisa memberi tagihan lagi");
    if(sscanf(params, "dds[128]", id, ammount, namebil)) return Usage(playerid, "/giveinvoice <playerid> <ammount> <Nama Invoice>");
    if(ammount < 1 || ammount > 500000) return Error(playerid, "Ammount is only can $1-$500000");
    if(1 > strlen(namebil) < 128) return Error(playerid, "Tidak bisa kurang dari 1 dan lebih dari 128 karakter");

    new bill[3400];
    bilData[biid][bilType] = pData[playerid][pFaction];
    format(bilData[biid][bilName], 128, namebil);
    bilData[biid][bilTarget] = pData[id][pID];
    bilData[biid][billTargetName] = pData[id][pName];
    bilData[biid][bilPtarget] = pData[id][pPhone];
    bilData[biid][bilammount] = ammount;
    format(bilData[biid][billoName], MAX_PLAYER_NAME, ReturnName(playerid));
    format(bilData[biid][billTargetName], MAX_PLAYER_NAME, ReturnName(id));
    bilData[biid][bilTime] = gettime();
    Iter_Add(tagihan, biid);
    mysql_format(g_SQL, bill, sizeof(bill), "INSERT INTO `bill` (`bid`,`type`,`name`,`oname`,`targetname`,`time`,`target`,`ammount`,`phonetarget`) VALUES ('%d','%d','%s','%s','%s','%d','%d','%d','%d')",
    biid,
    bilData[biid][bilType],
    bilData[biid][bilName],
    bilData[biid][billoName],
    bilData[biid][billTargetName],
    bilData[biid][bilTime],
    bilData[biid][bilTarget],
    bilData[biid][bilammount],
    bilData[biid][bilPtarget]);
    mysql_tquery(g_SQL, bill);
    Info(id, "You received an invoice from %s for {00ff00}%s{ffffff}, please check your bill on /phone", ReturnName(playerid), FormatMoney(bilData[biid][bilammount]));
    Info(playerid, "You successfully give %s Bill of {00ff00}%s", ReturnName(id), FormatMoney(bilData[biid][bilammount]));
    return 1;
}

stock ShowInvoiceInfo(playerid)
{
    new str[1012];
    new date[6];
    new bodystr[1012];
    forex(i, MAX_BILLS)
    {
        if(bilData[i][bilType] == ReturnFa(playerid))
        {
            TimestampToDate(bilData[i][bilTime], date[2], date[1], date[0], date[3], date[4], date[5], 7);
            format(bodystr, sizeof(bodystr), "%s%s\t%s\t%s\t%i/%02d/%02d %02d:%02d\n", bodystr, bilData[i][billTargetName], bilData[i][bilName], FormatMoney(bilData[i][bilammount]), date[2], date[0], date[1], date[3], date[4]);
            format(str, sizeof(str), "Name of the person\tName Bill\tBil Ammount\tTime\n%s", bodystr);
        }
    }
    ShowPlayerDialog(playerid, DIALOG_INVOICE, DIALOG_STYLE_TABLIST_HEADERS, "Invoice List", str, "Select", "Back");
    return 1;
}

stock ShowInvoiceDetails(playerid, id)
{
    new date[6];
    TimestampToDate(bilData[id][bilTime], date[2], date[1], date[0], date[3], date[4], date[5], 7);

    new str[712];
    strcat(str, sprintf("Name: %s\n", bilData[id][billTargetName]));
    strcat(str, sprintf("Bill Name: %s\n", bilData[id][bilName]));
    strcat(str, sprintf("Bill Ammount: %s\n", FormatMoney(bilData[id][bilammount])));
    strcat(str, sprintf("Officer Name: %s\n",bilData[id][billoName]));
    strcat(str, sprintf("Bill Time: %02d/%02d\n", date[0], date[1]));
    strcat(str, sprintf("Bill Date: %i/%02d:%02d", date[2], date[3], date[4]));
    ShowPlayerDialog(playerid, DIALOG_INVOICE_RETURN, DIALOG_STYLE_LIST, "Invoice Information", str, "Return", "");
    return 1;
}