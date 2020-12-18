codeunit 50130 "Interface Discovery"
{
    EventSubscriberInstance = Manual;

    var
        DefaultConverter: interface "Demo IConverter";
        DefaultPermissionChecker: interface "Demo IPermissionChecker";
        DefaultLogger: interface "Demo ILogger";

    procedure Initialize(Converter: interface "Demo IConverter"; PermissionChecker: interface "Demo IPermissionChecker"; Logger: interface "Demo ILogger")
    begin
        DefaultConverter := Converter;
        DefaultPermissionChecker := PermissionChecker;
        DefaultLogger := Logger;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Demo Dependency Factory", 'OnDiscoverConverter', '', false, false)]
    local procedure OnDiscoverConverter(var Converter: Interface "Demo IConverter"; var Handled: Boolean);
    begin
        Converter := DefaultConverter;
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Demo Dependency Factory", 'OnDiscoverPermissionChecker', '', false, false)]
    local procedure OnDiscoverPermissionChecker(var PermissionChecker: Interface "Demo IPermissionChecker"; var Handled: Boolean);
    begin
        PermissionChecker := DefaultPermissionChecker;
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Demo Dependency Factory", 'OnDiscoverLogger', '', false, false)]
    local procedure OnDiscoverLogger(var Logger: Interface "Demo ILogger"; var Handled: Boolean);
    begin
        Logger := DefaultLogger;
        Handled := true;
    end;
}
