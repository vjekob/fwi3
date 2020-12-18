codeunit 50122 "Stub Converter" implements "Demo IConverter"
{
    var
        Rate: Decimal;

    procedure SetUp(DefaultRate: Decimal)
    begin
        Rate := DefaultRate;
    end;

    procedure Convert(Amount: Decimal; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]): Decimal
    begin
        exit(Amount * Rate);
    end;
}
