codeunit 50120 "Exch. Rate. Mgt. - Bad"
{
    Subtype = Test;

    [Test()]
    procedure "Currency Conversion"()
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Result: Decimal;
    begin
        // This test has more anti-patterns than it has lines of code!
        Result := ExchRateMgt.Convert(10.00, 'EUR', 'HRK');
        Assert.AreEqual(Result, 54.65, 'Currency conversion failed');
    end;
}
