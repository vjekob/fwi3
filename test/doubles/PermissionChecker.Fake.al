codeunit 50125 "Fake Permission Checker" implements "Demo IPermissionChecker"
{
    var
        Allowed: Dictionary of [Text, List of [Text]];
        Denied: Dictionary of [Text, List of [Text]];

    local procedure GetKey(UserID: Text[50]; FromCurrencyCode: Code[10]): Text
    begin
        exit(StrSubstNo('%1;%2', UserId, FromCurrencyCode));
    end;

    procedure Allow(UserID: Text[50]; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10])
    var
        PermissionKey: Text;
        AllowedList: List of [Text];
    begin
        PermissionKey := GetKey(UserID, FromCurrencyCode);
        if not Allowed.ContainsKey(PermissionKey) then
            Allowed.Add(PermissionKey, AllowedList)
        else
            AllowedList := Allowed.Get(PermissionKey);

        if not AllowedList.Contains(ToCurrencyCode) then
            AllowedList.Add(ToCurrencyCode);
    end;

    procedure Deny(UserID: Text[50]; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10])
    var
        PermissionKey: Text;
        DeniedList: List of [Text];
    begin
        PermissionKey := GetKey(UserID, FromCurrencyCode);
        if not Denied.ContainsKey(PermissionKey) then
            Denied.Add(PermissionKey, DeniedList)
        else
            DeniedList := Denied.Get(PermissionKey);

        if not DeniedList.Contains(ToCurrencyCode) then
            DeniedList.Add(ToCurrencyCode);
    end;

    procedure CanConvert(UserID: Text[50]; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]): Boolean;
    var
        PermissionKey: Text;
        AllowedList: List of [Text];
        DeniedList: List of [Text];
    begin
        PermissionKey := GetKey(UserID, FromCurrencyCode);

        if (Denied.ContainsKey(PermissionKey)) then begin
            DeniedList := Denied.Get(PermissionKey);
            if DeniedList.Contains('') then
                exit(false);
            if DeniedList.Contains(ToCurrencyCode) then
                exit(false);
        end;

        if (Allowed.ContainsKey(PermissionKey)) then begin
            AllowedList := Allowed.Get(PermissionKey);
            if AllowedList.Contains('') then
                exit(true);
            if AllowedList.Contains(ToCurrencyCode) then
                exit(true);
        end;

        exit(false);
    end;
}
