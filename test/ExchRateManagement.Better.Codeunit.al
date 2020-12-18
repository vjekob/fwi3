codeunit 50121 "Exch. Rate. Mgt. - Better"
{
    Subtype = Test;

    [Test()]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure "Currency Conversion"()
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
        Result := ExchRateMgt.Convert(10.00, FromCurrency, ToCurrency);

        // 3. Validate results
        Assert.AreEqual(Round(Result), Round(10.00 / Rate), 'Currency conversion failed');
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
}
