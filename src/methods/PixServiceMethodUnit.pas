unit PixServiceMethodUnit;

interface

uses
    ServiceMethodUnit;

type
    TPixServiceMethod = class(TServiceMethod)
    public
        constructor Create(const AGuid, AIdLpu: String);
    end;

implementation

{ TPixServiceMethod }

constructor TPixServiceMethod.Create(const AGuid, AIdLpu: String);
begin
    FEndPoint := 'http://r52-rc.zdrav.netrika.ru/EMK3/PixService.svc';
    inherited Create(AGuid, AIdLpu);
end;

end.
