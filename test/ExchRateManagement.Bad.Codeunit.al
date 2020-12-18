codeunit 50120 "Exch. Rate. Mgt. - Bad"
{
    Subtype = Test;

    [Test()]
    procedure "Currency Conversion - Setup"()
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Result: Decimal;
    begin
        // This test has more anti-patterns than it has lines of code!
        Result := ExchRateMgt.ConvertBySetup(10.00, 'EUR', 'HRK');
        Assert.AreEqual(Result, 54.65, 'Currency conversion failed');
    end;

    [Test()]
    procedure "Currency Conversion - REST"()
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Result: Decimal;
    begin
        // This test has more anti-patterns than it has lines of code!
        Result := ExchRateMgt.ConvertByREST(10.00, 'EUR', 'HRK');
        Assert.AreEqual(Result, 75.315, 'Currency conversion failed');
    end;
}
