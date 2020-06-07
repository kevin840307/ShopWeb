<%@ WebHandler Language="C#" Class="ClientHandler" %>

using System;
using System.Web;
using System.Data;

public class ClientHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    private ClientRepository g_clientRepository = new ClientRepository();
    private Client g_client = new Client();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        fnReadLoginCookie(context);
        if (context.Session["client_id"] == null)
        {
            string clientId = GetRandClient();
            fnWriteLoginCookie(context, "遊客", clientId, "");
        }
        string sMethod = context.Request.QueryString["method"];
        sMethod = (sMethod == null) ? context.Request.Form["method"] : sMethod;
        if (sMethod != null)
        {
            System.Reflection.MethodInfo methodInfo = this.GetType().GetMethod(sMethod);
            if (methodInfo != null)
            {
                fnInitData(context);
                methodInfo.Invoke(this, new object[] { context });
            }
        }
    }

    private void fnInitData(HttpContext context)
    {
        string sClientId = context.Request.QueryString["client_id"];
        string sPassword = context.Request.QueryString["password"];
        string sEmail = context.Request.QueryString["email"];
        string sName = context.Request.QueryString["name"];
        string sPhone = context.Request.QueryString["phone"];
        string sTel = context.Request.QueryString["tel"];
        string sAddress = context.Request.QueryString["address"];
        string sDescription = context.Request.QueryString["description"];
        string sStatus = context.Request.QueryString["status"];
        string sOrder = context.Request.QueryString["order"];

        g_client.ClientId(sClientId)
                .Password(sPassword)
                .Name(sName)
                .Email(sEmail)
                .Phone(sPhone)
                .Tel(sTel)
                .Address(sAddress)
                .Description(sDescription)
                .Status(sStatus)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);
    }

    #region Client

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_clientRepository.fnSelect(g_client);

        if (dtData.Rows.Count == 1)
        {
            string sPassword = AESEncryption.AESDecryptString(dtData.Rows[0][2].ToString()).Replace("\0", "");
            dtData.Rows[0][2] = sPassword;
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_client);

        if (sMsg == "Y")
        {
            string sEncryptPassword = AESEncryption.AESEncryptString(g_client.password);
            g_client.EncryptPassword(sEncryptPassword);
            sMsg = g_clientRepository.fnInsert(g_client);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"client_id\":\"" + g_client.client_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_client);

        if (sMsg == "Y")
        {
            string sIP = PublicApi.fnRetrieveIP(context.Request);
            string sEncryptPassword = AESEncryption.AESEncryptString(g_client.password);

            g_client.EncryptPassword(sEncryptPassword);
            sMsg = g_clientRepository.fnUpdate(g_client, sIP, g_client.create_id);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnLogin(HttpContext context)
    {

        string sMsg = "Y";
        string sEncryptPassword = AESEncryption.AESEncryptString(g_client.password);

        g_client.EncryptPassword(sEncryptPassword);
        DataTable dtData = g_clientRepository.fnLogin(g_client);

        if (dtData.Rows.Count == 1)
        {
            fnUpdateCart(context, g_client.client_id);
            fnWriteLoginCookie(context
                , dtData.Rows[0][1].ToString()
                , g_client.client_id
                , g_client.password);
        }
        else
        {
            sMsg = "錯誤訊息：帳號密碼錯誤。";
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public bool fnUpdateCart(HttpContext context, string loginClientId)
    {
        string clientId = context.Session["client_id"].ToString();
        if (clientId == null)
        {
            return false;
        }

        string sql = "  UPDATE [dbo].[mndtshop_cart]   " +
                    "  SET    [client_id] = '" + loginClientId + "'   " +
                    "  WHERE  [client_id] = '" + clientId + "'   " +
                    "         AND [product_id] NOT IN (SELECT [cart].[product_id]   " +
                    "                                  FROM   [mndtshop_cart] [cart]   " +
                    "                                  WHERE  [cart].[client_id] = '" + loginClientId + "' AND [cart].type = [mndtshop_cart].type)   " +
                    "    " +
                    "  UPDATE [dbo].[mndtshop_cart]   " +
                    "  SET    [amount] = [amount]   " +
                    "                       + CAST((SELECT TOP 1 [amount]   " +
                    "                          FROM   [mndtshop_cart] [cart]   " +
                    "                          WHERE  [cart].[client_id] = '" + clientId + "'   " +
                    "                                 AND [cart].[product_id] =   " +
                    "                                     [mndtshop_cart].[product_id]  AND [cart].type = [mndtshop_cart].type) AS INT)   " +
                    "  WHERE  [client_id] = '" + loginClientId + "'   " +
                    "         AND [product_id] IN (SELECT [cart].[product_id]   " +
                    "                              FROM   [mndtshop_cart] [cart]   " +
                    "                              WHERE  [cart].[client_id] = '" + clientId + "' AND [cart].type = [mndtshop_cart].type)   " +
                    "  DELETE [dbo].[mndtshop_cart] WHERE  [client_id] = '" + clientId + "' ";
        return PublicApi.fnExecuteSQL(sql, "MNDT") == "Y";
    }

    public void fnWriteLoginCookie(HttpContext context, string sName, string sClientId, string sPassword)
    {
        HttpCookie htCookie = new HttpCookie("client_login");
        htCookie.Values.Add("client_id", sClientId);
        htCookie.Values.Add("password", sPassword);
        htCookie.Values.Add("name", sName);
        htCookie.Expires = DateTime.Now.AddYears(1);
        HttpContext.Current.Response.Cookies.Add(htCookie);
        context.Session["client_id"] = sClientId;
        context.Session["password"] = sPassword;
        context.Session["name"] = sName;
    }

    public static void fnReadLoginCookie(HttpContext context)
    {
        var reData = HttpContext.Current.Request.Cookies["client_login"];
        if (reData != null)
        {
            context.Session["client_id"] = reData["client_id"];
            context.Session["password"] = reData["password"];
            context.Session["name"] = reData["name"];
        }
        else
        {
            context.Session["client_id"] = null;
        }
    }

    public void fnLogout(HttpContext context)
    {
        HttpCookie htCookie = new HttpCookie("client_login");
        htCookie.Expires = DateTime.Now.AddDays(-1);
        HttpContext.Current.Response.Cookies.Add(htCookie);
        context.Session["client_id"] = null;
        context.Session["password"] = null;
        context.Session["name"] = null;
        context.Response.Write("{ \"msg\":\"Y\"}");
    }

    public void fnGetUserData(HttpContext context)
    {
        fnReadLoginCookie(context);
        string clientId = context.Session["client_id"].ToString();
        if (clientId != null && clientId.Length > 0 && clientId[0] != '$')
        {
            g_client.ClientId(clientId);
            DataTable dtData = g_clientRepository.fnSelect(g_client);
            context.Response.Write(PublicApi.fnGetJson(dtData));
            return;
        }
        else
        {
            context.Response.Write("{ \"msg\":\"N\"}");
        }
    }

    private string fnCheckData(Client client)
    {
        string sMsg = "Y";
        if (client.client_id.Length > 15)
        {
            sMsg = "錯誤訊息：帳號長度錯誤。";
        }
        else if (client.password.Length > 15)
        {
            sMsg = "錯誤訊息：密碼長度錯誤。";
        }
        else if (client.name.Length > 10)
        {
            sMsg = "錯誤訊息：名稱長度錯誤。";

        }
        else if (client.phone.Length > 10)
        {
            sMsg = "錯誤訊息：手機長度錯誤。";
        }
        else if (client.address.Length > 50)
        {
            sMsg = "錯誤訊息：地址長度錯誤。";
        }
        return sMsg;
    }
    #endregion

    #region Cart

    public void SelectCart(HttpContext context)
    {
        string type = context.Request.QueryString["type"];
        string sql = " SELECT [product_m].[product_id], " +
                    "       [product_m].[name], " +
                    "       [product_m].[currency], " +
                    "       ISNULL([product_m].[price] * [shopItem].[fold], [product_m].[price]) [price], " +
                    "       [kind_d].[name] [category_name], " +
                    "       [amount] " +
                    " FROM [MNDTshop_cart] [cart] " +
                    " LEFT JOIN [MNDTproduct_master] [product_m] " +
                    " 	ON [cart].[product_id] = [product_m].[product_id] " +
                    "  LEFT JOIN [MNDTshop_item] [shopItem]  " +
                    "       ON   [shopItem].[product_id] = [product_m].[product_id]  " +
                    "  LEFT JOIN [MNDTkind_details] [kind_d]  " +
                    "       ON   [kind_d].[code_id] = [shopItem].[category]  " +
                    "       AND  [kind_d].[kind_id] = 'SIC'  " +
                    " WHERE [client_id] = '" + context.Session["client_id"] + "' " +
                    " 	AND [cart].[type] = '" + type + "' ";
        context.Response.Write(PublicApi.fnGetJson(PublicApi.fnGetDt(sql, "MNDT")));
    }

    public string GetRandClient()
    {
        Random random = new Random();
        string clientId = "$";
        do
        {
            clientId = "$";
            for (int index = 0; index < 14; index++)
            {
                clientId += random.Next(0, 2) == 0 ? (char)(random.Next(48, 58)) : random.Next(0, 2) == 0 ? (char)(random.Next(65, 91)) : (char)(random.Next(97, 123));
            }
        } while (PublicApi.fnGetValue(" SELECT COUNT([client_id]) FROM [MNDTshop_cart] WHERE [client_id] = '" + clientId + "' ", "MNDT") != "0");

        return clientId;
    }

    public void fnAddLove(HttpContext context)
    {

        string msg = "N";
        string productId = context.Request.QueryString["product_id"];
        string sql = " SELECT COUNT([client_id]) FROM [MNDTshop_cart] " +
                    " WHERE [client_id] = '" + context.Session["client_id"] + "' " +
                    " AND [product_id] = '" + productId + "' " +
                    " AND [type] = '2' ";

        if (PublicApi.fnGetValue(sql, "MNDT") == "0")
        {
            sql = "  INSERT INTO [MNDTshop_cart]  " +
                    "             ([client_id]  " +
                    "             ,[product_id]  " +
                    "             ,[type]  " +
                    "             ,[amount]  " +
                    "             ,[create_datetime])  " +
                    "       VALUES  " +
                    "             ('" + context.Session["client_id"] + "'   " +
                    "             ,'" + productId + "'  " +
                    "             ,'2'  " +
                    "             ,'0'  " +
                    "             ,GETDATE())  ";
            msg = PublicApi.fnExecuteSQL(sql, "MNDT");
            context.Response.Write("{ \"msg\":\"" + msg + "\"}");
            return;
        }
        context.Response.Write("{ \"msg\":\"N\"}");
    }

    public void fnDeleteLove(HttpContext context)
    {
        string msg = "N";
        string productId = context.Request.QueryString["product_id"];

        string sql = "  DELETE [MNDTshop_cart]  " +
               "       WHERE [client_id] = '" + context.Session["client_id"] + "' " +
               "             AND [product_id] = '" + productId + "'  " +
               "             AND [type] = '2'  ";
        msg = PublicApi.fnExecuteSQL(sql, "MNDT");
        context.Response.Write("{ \"msg\":\"" + msg + "\" }");
    }

    public void fnAddCart(HttpContext context)
    {
        string msg = "N";
        string type = "1";
        string productId = context.Request.QueryString["product_id"];
        string amount = context.Request.QueryString["amount"];
        string sql = " SELECT COUNT([client_id]) FROM [MNDTshop_cart] " +
                    " WHERE [client_id] = '" + context.Session["client_id"] + "' " +
                    " AND [product_id] = '" + productId + "' " +
                    " AND [type] = '1' ";

        if (PublicApi.fnGetValue(sql, "MNDT") == "0")
        {
            sql = "  INSERT INTO [MNDTshop_cart]  " +
                    "             ([client_id]  " +
                    "             ,[product_id]  " +
                    "             ,[type]  " +
                    "             ,[amount]  " +
                    "             ,[create_datetime])  " +
                    "       VALUES  " +
                    "             ('" + context.Session["client_id"] + "'   " +
                    "             ,'" + productId + "'  " +
                    "             ,'1'  " +
                    "             ,'" + amount + "'  " +
                    "             ,GETDATE())  ";
        }
        else
        {
            sql = "  UPDATE [MNDTshop_cart]  " +
               "        SET [amount] = [amount] + " + amount + "  " +
               "             ,[create_datetime] = GETDATE()  " +
               "       WHERE [client_id] = '" + context.Session["client_id"] + "' " +
               "             AND [product_id] = '" + productId + "'  " +
               "             AND [type] = '1'  ";
            type = "2";
        }
        msg = PublicApi.fnExecuteSQL(sql, "MNDT");
        context.Response.Write("{ \"msg\":\"" + msg + "\", \"type\":\"" + type + "\"}");
    }

    public void fnUpdateCart(HttpContext context)
    {
        string msg = "N";
        fnReadLoginCookie(context);
        if (context.Session["client_id"] == null)
        {
            string clientId = GetRandClient();
            fnWriteLoginCookie(context, "遊客", clientId, "");
        }
        string productId = context.Request.QueryString["product_id"];
        string amount = context.Request.QueryString["amount"];

        string sql = "  UPDATE [MNDTshop_cart]  " +
           "        SET [amount] = " + amount + "  " +
           "             ,[create_datetime] = GETDATE()  " +
           "       WHERE [client_id] = '" + context.Session["client_id"] + "' " +
           "             AND [product_id] = '" + productId + "'  " +
           "             AND [type] = '1'  ";
        msg = PublicApi.fnExecuteSQL(sql, "MNDT");
        context.Response.Write("{ \"msg\":\"" + msg + "\" }");
    }

    public void fnDeleteCart(HttpContext context)
    {
        string msg = "N";
        string productId = context.Request.QueryString["product_id"];

        string sql = "  DELETE [MNDTshop_cart]  " +
               "       WHERE [client_id] = '" + context.Session["client_id"] + "' " +
               "             AND [product_id] = '" + productId + "'  " +
               "             AND [type] = '1'  ";
        msg = PublicApi.fnExecuteSQL(sql, "MNDT");
        context.Response.Write("{ \"msg\":\"" + msg + "\" }");
    }
    #endregion
    public void CartInsert(HttpContext context)
    {
        string msg = "N";
        string[] productId = context.Request.QueryString["product_id"].ToString().Split(',');
        string[] amount = context.Request.QueryString["amount"].ToString().Split(',');
        string[] price = context.Request.QueryString["price"].ToString().Split(',');
        string orderId = "P" + PublicApi.fnGetOrderNum(context, "B01");
        QuotesRepository quotesRepository = new QuotesRepository();
        QuotesM quotesM = new QuotesM();
        QuotesD quotesD = new QuotesD();

        quotesM.OrderId(orderId)
            .Id("1")
            .ClientId(context.Session["client_id"].ToString())
            .Datetime(DateTime.Now.ToString("yyyy/MM/dd"))
            .CreateId(context.Session["client_id"].ToString());
        msg = quotesRepository.fnInsert(quotesM);
        if (msg != "Y")
        {
            context.Response.Write("{ \"msg\":\"" + msg + "\" }");
            return;
        }

        for (int index = 0; index < productId.Length; index++)
        {
            quotesD.OrderId(orderId)
                    .ProductId(productId[index])
                    .Amount(amount[index])
                    .Price(price[index])
                    .CreateId("1");
            quotesRepository.fnInsert(quotesD);
        }
        msg = fnChangeSale(context, quotesM);
        context.Session["order_id"] = orderId;
        context.Response.Write("{ \"msg\":\"" + msg + "\" }");
    }

    public string fnChangeSale(HttpContext context, QuotesM quotesM)
    {
        string msg = "N";
        string sIP = PublicApi.fnRetrieveIP(context.Request);
        QuotesRepository quotesRepository = new QuotesRepository();
        msg = quotesRepository.fnChange(quotesM, sIP);
        if (msg != "Y")
        {
            return msg;
        }

        SalesM salseM = new SalesM();
        salseM.OrderId(quotesM.order_id)
                .CreateId("1");
        msg = fnChangeInsert(salseM);

        return msg;
    }

    public string fnChangeInsert(SalesM salesM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTsales_master]  " +
                        "             ([order_id]  " +
                        "             ,[id]  " +
                        "             ,[pay]  " +
                        "             ,[order_status]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  SELECT TOP 1 [order_id]  " +
                        "             ,'" + salesM.create_id + "'  " +
                        "             ,'01'  " +
                        "             ,'01'  " +
                        "             ,GETDATE()  " +
                        "             ,'N' " +
                        "             ,''  " +
                        "             ,'" + salesM.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "  FROM [MNDTquotes_master]  " +
                        "  WHERE order_id = '" + salesM.order_id + "'  ";
        sSql +=
                        "  INSERT INTO [MNDTsales_details]  " +
                        "             ([seq]  " +
                        "             ,[order_id]  " +
                        "             ,[product_id]  " +
                        "             ,[warehouse_id]  " +
                        "             ,[amount]  " +
                        "             ,[price]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime] " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "  SELECT Row_number() OVER(ORDER BY[product_id] ASC) NUM  " +
                        "        ,[order_id]  " +
                        "        ,[product_id]  " +
                        "        ,'01'  " +
                        "        ,[modify_amount]  " +
                        "        ,[modify_price]  " +
                        "        ,''  " +
                        "        ,'" + salesM.create_id + "'  " +
                        "        ,GETDATE()  " +
                        "        ,'" + salesM.create_id + "'  " +
                        "        ,GETDATE()  " +
                        "  FROM [MNDTquotes_details]  " +
                        "  WHERE order_id = '" + salesM.order_id + "'  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public void ConfirmCart(HttpContext context)
    {
        string orderId = context.Request.QueryString["order_id"].ToString();
        orderId = orderId.Length == 0 ? context.Session["order_id"].ToString() : orderId;
        if (orderId == null)
        {
            context.Response.Write("{ \"msg\":\"N\" }");
            return;
        }
        SalesM salesM = new SalesM();
        SalesD salesD = new SalesD();
        SalesRepository salesRepository = new SalesRepository();
        string sIP = PublicApi.fnRetrieveIP(context.Request);
        string sMsg = "N";
        salesM.OrderId(orderId);
        salesD.OrderId(orderId);
        sMsg = salesRepository.fnChange(salesM, sIP);

        if (sMsg != "Y")
        {
            context.Response.Write("{ \"msg\":\"" + sMsg.Replace("\r\n", "") + "\" }");
            return;
        }
        fnUpdateStock(salesD);
        context.Session["order_id"] = null;
        context.Response.Write("{ \"msg\":\"" + sMsg.Replace("\r\n", "") + "\", \"order_id\":\"" + orderId + "\" }");
    }


    private void fnUpdateStock(SalesD salesD)
    {
        ProductStockRepository productStockRepository = new ProductStockRepository();
        SalesRepository salesRepository = new SalesRepository();
        DataTable dtData = salesRepository.fnSelects(salesD);

        for (int iIndex = 0; iIndex < dtData.Rows.Count; iIndex++)
        {
            ProductStock productStock = new ProductStock();
            productStock.ProductId(dtData.Rows[iIndex]["product_id"].ToString())
                         .WarehouseId(dtData.Rows[iIndex]["warehouse_id"].ToString())
                         .Amount("-" + dtData.Rows[iIndex]["amount"].ToString())
                         .CreateId(salesD.create_id);

            productStockRepository.fnUpdateAmount(productStock);
        }
    }

    public void CancelSale(HttpContext context)
    {
        string msg = "N";
        string orderId = context.Request.QueryString["order_id"].ToString();
        string sql = "  UPDATE [dbo].[MNDTsales_master]  " +
                    "     SET [order_status] = '06'  " +
                    "  WHERE [order_id] = '" + orderId + "' " +
                    "      AND [order_status] IN ('01', '02') " +
                    "      AND '" + context.Session["client_id"].ToString() + "' = " +
                    "      (SELECT [quotes_m].[client_id] FROM [mndtquotes_master] [quotes_m] WHERE [quotes_m].[order_id] = [MNDTsales_master].[order_id])";

        msg = PublicApi.fnExecuteSQL(sql, "MNDT");
        context.Response.Write("{ \"msg\":\"" + msg + "\" }");
    }

    public void GetSaleDatas(HttpContext context)
    {
        string sql = "  SELECT CONVERT(NVARCHAR, [sales_m].[datetime], 111) [date],   " +
                        "         [pay].[name]                                 [pay],   " +
                        "         [sales_m].[order_id],   " +
                        "         [status].[name]                              [status]   " +
                        "  FROM   [mndtsales_master] [sales_m]   " +
                        "         LEFT JOIN [mndtquotes_master] [quotes_m]   " +
                        "                ON [sales_m].[order_id] = [quotes_m].[order_id]   " +
                        "         LEFT JOIN [mndtkind_details] [pay]   " +
                        "                ON [pay].[kind_id] = 'CPAY'   " +
                        "                   AND [sales_m].[pay] = [pay].[code_id]   " +
                        "         LEFT JOIN [mndtkind_details] [status]   " +
                        "                ON [status].[kind_id] = 'OSTA'   " +
                        "                   AND [sales_m].[order_status] = [status].[code_id]   " +
                        "  WHERE  [quotes_m].[client_id] = '" + context.Session["client_id"].ToString() + "'   ";
        DataTable data = PublicApi.fnGetDt(sql, "MNDT");
        context.Response.Write(PublicApi.fnGetJson(data));
    }


    public void GetSaleData(HttpContext context)
    {
        string orderId = context.Request.QueryString["order_id"].ToString();
        string sql = "  SELECT CONVERT(NVARCHAR, [sales_m].[datetime], 111) [date],   " +
                        "         [pay].[name]                                 [pay],   " +
                        "         [status].[name]                              [status]   " +
                        "  FROM   [mndtsales_master] [sales_m]   " +
                        "         LEFT JOIN [mndtquotes_master] [quotes_m]   " +
                        "                ON [sales_m].[order_id] = [quotes_m].[order_id]   " +
                        "         LEFT JOIN [mndtkind_details] [pay]   " +
                        "                ON [pay].[kind_id] = 'CPAY'   " +
                        "                   AND [sales_m].[pay] = [pay].[code_id]   " +
                        "         LEFT JOIN [mndtkind_details] [status]   " +
                        "                ON [status].[kind_id] = 'OSTA'   " +
                        "                   AND [sales_m].[order_status] = [status].[code_id]   " +
                        "  WHERE  [sales_m].[order_id] = '" + orderId + "'   " +
                        "         AND [quotes_m].[client_id] = '" + context.Session["client_id"].ToString() + "'   ";
        DataTable data = PublicApi.fnGetDt(sql, "MNDT");
        context.Response.Write(PublicApi.fnGetJson(data));
    }

    public void GetSaleItemData(HttpContext context)
    {
        string orderId = context.Request.QueryString["order_id"].ToString();
        string sql = "  SELECT [sales_d].[product_id],   " +
                        "         [sales_d].[amount],   " +
                        "         [sales_d].[price] [total],   " +
                        "         [product_m].[name],   " +
                        "         [product_m].[currency],   " +
                        "         [product_m].[price] * [shop].[fold] [price],   " +
                        "         [kind_d].[name] [currency_name]   " +
                        "  FROM   [mndtsales_details] [sales_d]   " +
                        "         LEFT JOIN [mndtproduct_master] [product_m]   " +
                        "                ON [sales_d].[product_id] = [product_m].[product_id]   " +
                        "         LEFT JOIN [mndtquotes_master] [quotes_m]   " +
                        "                ON [sales_d].[order_id] = [quotes_m].[order_id]   " +
                        "         LEFT JOIN [MNDTshop_item] [shop]   " +
                        "                ON [shop].[product_id] = [sales_d].[product_id]   " +
                        "         LEFT JOIN [MNDTkind_details] [kind_d]   " +
                        "                ON [kind_d].[kind_id] = 'SIC'   " +
                        "                   AND [shop].[category] = [kind_d].[code_id]   " +
                        "  WHERE  [sales_d].[order_id] = '" + orderId + "'   " +
                        "         AND [quotes_m].[client_id] = '" + context.Session["client_id"].ToString() + "'   ";
        DataTable data = PublicApi.fnGetDt(sql, "MNDT");
        context.Response.Write(PublicApi.fnGetJson(data));
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}