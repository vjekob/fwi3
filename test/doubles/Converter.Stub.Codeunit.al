codeunit 50122 "Stub Converter" implements "Demo IConverter"
{
    // Unfortunately, because AL does not allow controlling the instantiation of enum-bound codeunits, this must be single-instance
    SingleInstance = true;

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
