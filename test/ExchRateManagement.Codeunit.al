codeunit 50121 "Exch. Rate. Mgt. - Stub"
{
    Subtype = Test;

    [Test()]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure "Currency Conversion - Stub"()
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
        Rate := 3.141;
        SetUpCurrencyConversionTest(Rate);

        // 2. Run test
        Result := ExchRateMgt.Convert(10.00, FromCurrency, ToCurrency);

        // 3. Validate results
        Assert.AreEqual(Round(Result), Round(10.00 * Rate), 'Currency conversion failed');
    end;

    local procedure SetUpCurrencyConversionTest(Rate: Decimal)
    var
        Setup: Record "Demo Currency Exchange Setup";
        Stub: Codeunit "Stub Converter";
    begin
        // Configuring stub single-instance
        Stub.SetUp(Rate);

        // Binding stub to setup
        if not Setup.Get() then
            Setup.Insert();

        Setup."Currency Converter" := "Demo Currency Converter Type"::Stub;
        Setup.Modify();
    end;
}
