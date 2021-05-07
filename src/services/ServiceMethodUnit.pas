unit ServiceMethodUnit;

interface

uses
    System.SysUtils, System.Classes, Vcl.Dialogs, Xml.XmlDoc, Xml.XmlIntf, IdHTTP;

type
    TServiceMethod = class
    protected
        FEndPoint: String;
        FSoapAction: String;
        FGuid: String;
        FIdLpu: String;
    protected
        FRequestStream: TMemoryStream;
        FResponseStream: TMemoryStream;
        procedure CreateRequestStream; virtual;
        procedure ParseResponseStream; virtual;
    public
        constructor Create(const AGuid, AIdLpu: String);
        destructor Destroy; override;
        property EndPoint: String read FEndPoint;
        property SoapAction: String read FSoapAction;
        property Guid: String read FGuid;
        property IdLpu: String read FIdLpu;
        property RequestStream: TMemoryStream read FRequestStream;
        property ResponseStream: TMemoryStream read FResponseStream;
        procedure Execute;
    end;

implementation

{ TServerMethod }

constructor TServiceMethod.Create(const AGuid, AIdLpu: String);
begin
    FGuid := AGuid;
    FIdLpu := AIdLpu;
    FRequestStream := TMemoryStream.Create;
    FResponseStream := TMemoryStream.Create;
end;

destructor TServiceMethod.Destroy;
begin
    FRequestStream.Free;
    FResponseStream.Free;
    inherited;
end;

procedure TServiceMethod.CreateRequestStream;
begin
    // no actions
end;

procedure TServiceMethod.ParseResponseStream;
begin
    // no actions
end;

procedure TServiceMethod.Execute;
var
    IdHttp: TIdHTTP;
    ErrorStream: TStringStream;
begin
    CreateRequestStream;
    IdHTTP := TIdHTTP.Create(nil);
    try
        try
            IdHttp.HTTPOptions := [];
            IdHttp.Request.Connection := 'keep-alive';
            IdHttp.Request.Accept := '*/*';
            IdHttp.ProtocolVersion := pv1_1;
            IdHttp.Request.ContentType := 'text/xml; charset=utf-8';
            IdHttp.Request.ContentLength := FRequestStream.Size;
            IdHttp.Request.CustomHeaders.Clear;
            IdHttp.Request.CustomHeaders.Add('SOAPAction: ' + FSoapAction);
            IdHttp.Post(FEndPoint, FRequestStream, FResponseStream);
            ParseResponseStream;
        except
            on E: EIdHTTPProtocolException do
            begin
                // There are E.ErrorCode, E.Message, E.ErrorMessage
                ErrorStream := TStringStream.Create(E.ErrorMessage, TEncoding.UTF8);
                try
                    ErrorStream.Position := 0;
                    FResponseStream.LoadFromStream(ErrorStream);
                    FResponseStream.Position := 0;
                    ParseResponseStream;
                finally
                    ErrorStream.Free;
                end;
            end;
        end;
    finally
        IdHTTP.Free;
    end;
end;

end.
