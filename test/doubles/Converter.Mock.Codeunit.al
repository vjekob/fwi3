codeunit 50128 "Mock Converter" implements "Demo IConverter"
{
    var
        Called: Boolean;

    procedure Convert(Amount: Decimal; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]): Decimal
    begin
        Called := true;
    end;

    procedure IsCalled(): Boolean
    begin
        exit(Called);
    end;
}
