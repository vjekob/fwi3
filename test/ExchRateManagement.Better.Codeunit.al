codeunit 50121 "Exch. Rate. Mgt. - Better"
{
    Subtype = Test;

    [Test()]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure "Currency Conversion - Setup"()
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Result: Decimal;
        FromCurrency: Code[10];
        ToCurrency: Code[10];
        Rate: Decimal;
    begin
        // This one has fewer anti-patterns, but is still not ideal

        // 1. Set up test
        FromCurrency := 'EUR';
        ToCurrency := 'HRK';
        Rate := 0.133333;
        SetUpCurrencyConversionTest(FromCurrency, ToCurrency, Rate);

        // 2. Run test
        Result := ExchRateMgt.ConvertBySetup(10.00, FromCurrency, ToCurrency);

        // 3. Validate results
        Assert.AreEqual(Round(Result), Round(10.00 / Rate), 'Currency conversion failed');
    end;

    [Test()]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure "Currency Conversion - REST"()
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Result: Decimal;
        FromCurrency: Code[10];
        ToCurrency: Code[10];
        Rate: Decimal;
    begin
        // This test actually exposes the problem: the entire test is one big exercise in futility...

        // 1. Set up test
        FromCurrency := 'EUR';
        ToCurrency := 'HRK';
        Rate := GetExchangeRate(FromCurrency, ToCurrency);
        SetUpCurrencyConversionTest(FromCurrency, ToCurrency, Rate); // ... because whatever is happening inside, is practically the same code as the tested function itself

        // 2. Run test
        Result := ExchRateMgt.ConvertByREST(10.00, FromCurrency, ToCurrency);

        // 3. Validate results
        Assert.AreEqual(Round(Result), Round(10.00 * Rate), 'Currency conversion failed');
    end;

    local procedure SetUpCurrencyConversionTest(FromCurrency: Code[10]; ToCurrency: Code[10]; Rate: Decimal)
    var
        ExchRate: Record "Currency Exchange Rate";
    begin
        ExchRate."Currency Code" := FromCurrency;
        ExchRate."Relational Currency Code" := ToCurrency;
        ExchRate."Exchange Rate Amount" := Rate;
        ExchRate."Relational Exch. Rate Amount" := 1;
        ExchRate."Starting Date" := Today();
        ExchRate.Insert();
    end;

    local procedure GetExchangeRate(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]) Rate: Decimal
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Url: Label 'https://api.exchangeratesapi.io/latest?base=%1&symbols=%2', Locked = true;
        Content: JsonObject;
        Token: JsonToken;
        Body: Text;
    begin
        Client.Get(StrSubstNo(Url, FromCurrencyCode, ToCurrencyCode), Response);
        Response.Content.ReadAs(Body);
        Content.ReadFrom(Body);

        if not Response.IsSuccessStatusCode then begin
            Content.Get('error', Token);
            Error('%2 (%1)', Response.HttpStatusCode, Token.AsValue().AsText());
        end;

        Content.SelectToken(StrSubstNo('rates.%1', ToCurrencyCode), Token);
        exit(Token.AsValue().AsDecimal());
    end;
}
