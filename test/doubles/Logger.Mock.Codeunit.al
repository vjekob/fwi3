codeunit 50126 "Mock Logger" implements "Demo ILogger"
{
    var
        Called: Boolean;

    procedure Log(UserID: Text[50]; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; FromAmount: Decimal; ToAmount: Decimal)
    begin
        Called := true;
    end;

    procedure IsCalled(): Boolean
    begin
        exit(Called);
    end;
}
