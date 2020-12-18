codeunit 50127 "Stub Permission Checker: Allow" implements "Demo IPermissionChecker"
{
    procedure CanConvert(UserID: Text[50]; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]): Boolean;
    begin
        exit(true);
    end;
}
