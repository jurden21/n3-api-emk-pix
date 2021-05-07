unit GetPatientByGlobalIdMethodUnit;

interface

uses
    System.Classes, Xml.XmlDoc, Xml.XmlIntf, PixServiceMethodUnit;

type
    TGetPatientByGlobalIdMethod = class(TPixServiceMethod)
    private
        FPatientId: String;
        FIdLpuTarget: String;
    protected
        procedure CreateRequestStream; override;
    public
        property PatientId: String read FPatientId;
        property IdLpuTarget: String read FIdLpuTarget;
        constructor Create(const AGuid, AIdLpu, APatientId, AIdLpuTarget: String);
    end;

implementation

uses XmlWriterUnit;

{ TGetPatientByGlobalIdMethod }

constructor TGetPatientByGlobalIdMethod.Create(const AGuid, AIdLpu, APatientId, AIdLpuTarget: String);
begin
    inherited Create(AGuid, AIdLpu);
    FSoapAction := '"http://tempuri.org/IPixService/GetPatientByGlobalId"';
    FPatientId := APatientId;
    FIdLpuTarget := AIdLpuTarget;
end;

procedure TGetPatientByGlobalIdMethod.CreateRequestStream;
var
    XmlDoc: IXMLDocument;
    Root: IXmlNode;
    Node: IXmlNode;
begin
    XmlDoc := TXmlDocument.Create(nil);
    try
        XmlDoc.Active := True;
        XmlDoc.Version := '1.0';
        XmlDoc.Encoding := 'utf-8';

        // ENVELOPE
        // <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        Root := XmlDoc.AddChild('soapenv:Envelope');
        TXmlWriter.WriteAttrString(Root, 'xmlns:soapenv', 'http://schemas.xmlsoap.org/soap/envelope/');
        TXmlWriter.WriteAttrString(Root, 'xmlns:tem', 'http://tempuri.org/');
        // TXmlWriter.WriteAttrString(Root, 'xmlns:emk', 'http://schemas.datacontract.org/2004/07/EMKService.Data.Dto');

        // HEADER
        Node := Root.AddChild('soapenv:Header');

        // BODY
        // <soapenv:Body>
        Node := Root.AddChild('soapenv:Body');

        // GETPATIENTBYEXTERNALMISID
        // <tem:GetPatientByExternalMisId">
        Node := Node.AddChild('tem:GetPatientByGlobalId');
        TXmlWriter.WriteString(Node.AddChild('tem:guid'), FGuid);
        TXmlWriter.WriteString(Node.AddChild('tem:idLpu'), FIdLpu);
        TXmlWriter.WriteString(Node.AddChild('tem:idLpuTarget'), FIdLpuTarget);
        TXmlWriter.WriteString(Node.AddChild('tem:patientId'), FPatientId);

        XmlDoc.SaveToStream(FRequestStream);

    finally
        XmlDoc := nil;
    end;
end;

end.
