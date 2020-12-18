codeunit 50121 "Exch. Rate. Management"
{
    Subtype = Test;

    [Test()]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure "Currency Conversion - Base process flow"()
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Result: Decimal;
        FromCurrency: Code[10];
        ToCurrency: Code[10];
        Rate: Decimal;
        Converter: Codeunit "Stub Converter";
        PermissionChecker: Codeunit "Stub Permission Checker: Allow";
        Logger: Codeunit "Mock Logger";
    begin
        // 1. Set up test
        FromCurrency := 'EUR';
        ToCurrency := 'HRK';
        Rate := 3.141;
        Converter.SetUp(Rate);

        // 2. Run test
        Result := ExchRateMgt.Convert(10.00, FromCurrency, ToCurrency, Converter, PermissionChecker, Logger);

        // 3. Validate results
        Assert.AreEqual(Round(Result), Round(10.00 * Rate), 'Currency conversion failed');
        Assert.AreEqual(true, Logger.IsCalled(), 'Logger was not called');
    end;

    [Test()]
    procedure "Currency Conversion - Security: Allow"()
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Converter: Codeunit "Mock Converter";
        Allow: Codeunit "Stub Permission Checker: Allow";
        Logger: Codeunit "Mock Logger";
    begin
        ExchRateMgt.Convert(0.00, '', '', Converter, Allow, Logger);
        Assert.AreEqual(true, Converter.IsCalled(), 'Converter was not called');
        Assert.AreEqual(true, Logger.IsCalled(), 'Logger was not called');
    end;

    [Test()]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure "Currency Conversion - Security: Deny"()
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Converter: Codeunit "Mock Converter";
        Deny: Codeunit "Stub Permission Checker: Deny";
        Logger: Codeunit "Mock Logger";
    begin
        asserterror ExchRateMgt.Convert(0.00, '', '', Converter, Deny, Logger);
        Assert.AreEqual(false, Converter.IsCalled(), 'Converter was called, and it should not have been');
        Assert.AreEqual(false, Logger.IsCalled(), 'Logger was called, and it should not have been');
    end;

    [Test()]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure "Currency Conversion - Security: Setup"()
    var
        Security: Codeunit "Fake Permission Checker";
    begin
        // Configure security
        Security.Allow(UserId, 'EUR', 'HRK');
        Security.Allow(UserId, 'USD', '');
        Security.Allow(UserId, 'GBP', 'HRK');
        Security.Deny(UserId, 'GBP', '');

        // EUR to HRK must pass
        RunTestWithSecurity('EUR', 'HRK', true, Security);

        // USD to anything must pass
        RunTestWithSecurity('USD', 'HRK', true, Security);
        RunTestWithSecurity('USD', 'GBP', true, Security);

        // GBP to anything must fail, because GBP->'' is denied!
        RunTestWithSecurity('GBP', 'HRK', false, Security);
        RunTestWithSecurity('GBP', 'EUR', false, Security);

        // HRK to anything must fail implicitly, because it's not configured
        RunTestWithSecurity('HRK', 'EUR', false, Security);
        RunTestWithSecurity('HRK', 'USD', false, Security);
    end;

    [Test]
    procedure "Currency Conversion - Page/Discovery"()
    var
        Convert: TestPage "Demo Convert Amount";
        InterfaceDiscovery: Codeunit "Interface Discovery";
        Converter: Codeunit "Stub Converter";
        Allow: Codeunit "Stub Permission Checker: Allow";
        Logger: Codeunit "Mock Logger";
        Assert: Codeunit Assert;
        FromCurrency: Code[10];
        ToCurrency: Code[10];
        Rate: Decimal;
        Result: Decimal;
    begin
        // 1. Set up test

        // Base data
        FromCurrency := 'EUR';
        ToCurrency := 'HRK';
        Rate := 3.141;
        Converter.SetUp(Rate);

        InterfaceDiscovery.Initialize(Converter, Allow, Logger);
        BindSubscription(InterfaceDiscovery);

        // 2. Perform the process
        Convert.OpenEdit();
        Convert.FromAmount.SetValue(10.00);
        Convert.FromCurrencyCode.SetValue(FromCurrency);
        Convert.ToCurrencyCode.SetValue(ToCurrency);

        // 3. Validate results
        Evaluate(Result, Convert.ToAmount.Value);
        Assert.AreEqual(Round(Result), Round(10.00 * Rate), 'Currency conversion failed');
        Assert.AreEqual(true, Logger.IsCalled(), 'Logger was not called');
    end;

    local procedure RunTestWithSecurity(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; PassesSecurity: Boolean; Security: Interface "Demo IPermissionChecker")
    var
        ExchRateMgt: Codeunit "Demo Exchange Rate Management";
        Assert: Codeunit Assert;
        Converter: Codeunit "Mock Converter";
        Logger: Codeunit "Mock Logger";
    begin
        asserterror
        begin
            ExchRateMgt.Convert(0.00, FromCurrencyCode, ToCurrencyCode, Converter, Security, Logger);
            if PassesSecurity then
                Error(''); // Throwing error to satisfy asserterror
        end;

        Assert.AreEqual(PassesSecurity, Converter.IsCalled(), StrSubstNo('Converter call was incorrect at: %1, %2, %3', FromCurrencyCode, ToCurrencyCode, PassesSecurity));
        Assert.AreEqual(PassesSecurity, Logger.IsCalled(), StrSubstNo('Converter call was incorrect at: %1, %2, %3', FromCurrencyCode, ToCurrencyCode, PassesSecurity));
    end;
}
