unit GetPatientMethodUnit;

interface

uses
    System.Classes, System.SysUtils, Vcl.Dialogs, Xml.XmlDoc, Xml.XmlIntf, PixServiceMethodUnit, PatientUnit;

type
    TGetPatientResponse = class
    private
        FPatient: TPatientObject;
    public
        property Patient: TPatientObject read FPatient;
        constructor Create(const AResponseStream: TMemoryStream);
        destructor Destroy; override;
    end;

    TGetPatientMethod = class(TPixServiceMethod)
    private
        FIdSourse: String;
        FPatient: TPatientObject;
        FResponse: TGetPatientResponse;
    protected
        procedure CreateRequestStream; override;
        procedure ParseResponseStream; override;
    public
        property IdSource: String read FIdSourse;
        property Patient: TPatientObject read FPatient;
        constructor Create(const AGuid, AIdLpu, AIdSource: String; const APatient: TPatientObject);
        destructor Destroy; override;
    end;

implementation

uses XmlWriterUnit;

{ TGetPatientResponse }

constructor TGetPatientResponse.Create(const AResponseStream: TMemoryStream);
var
    XmlDoc: IXmlDocument;
    Node: IXmlNode;
begin
    XmlDoc := TXmlDocument.Create(nil);
    try
        XmlDoc.LoadFromStream(AResponseStream);
        XmlDoc.Active := True;
        Node := XmlDoc.DocumentElement.ChildNodes.FindNode('s:Body');

        // OK and ERROR texts
        if Node.ChildNodes[0].NodeName = 'GetPatientResponse'
        then FPatient := TPatientObject.Create(Node.ChildNodes[0].ChildNodes[0].ChildNodes[0])
        else FPatient := nil;

    except
        on E: Exception do
            ShowMessage(E.Message);
    end;
end;

destructor TGetPatientResponse.Destroy;
begin
    FPatient.Free;
    inherited;
end;

{ TGetPatientMethod }

constructor TGetPatientMethod.Create(const AGuid, AIdLpu, AIdSource: String; const APatient: TPatientObject);
begin
    inherited Create(AGuid, AIdLpu);
    FSoapAction := '"http://tempuri.org/IPixService/GetPatient"';
    FIdSourse := AIdSource;
    FPatient := APatient;
    FResponse := nil;
end;

destructor TGetPatientMethod.Destroy;
begin
    FPatient.Free;
    FResponse.Free;
    inherited;
end;

procedure TGetPatientMethod.ParseResponseStream;
begin
    FResponse := TGetPatientResponse.Create(ResponseStream);
end;

procedure TGetPatientMethod.CreateRequestStream;
var
    XmlDoc: IXMLDocument;
    Root: IXmlNode;
    Node: IXmlNode;
    PatientNode: IXmlNode;
begin
    XmlDoc := TXmlDocument.Create(nil);
    try
        XmlDoc.Active := True;
        XmlDoc.Version := '1.0';
        XmlDoc.Encoding := 'utf-8';

        // ENVELOPE
        // <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:emk="http://schemas.datacontract.org/2004/07/EMKService.Data.Dto">
        Root := XmlDoc.AddChild('soapenv:Envelope');
        TXmlWriter.WriteAttrString(Root, 'xmlns:soapenv', 'http://schemas.xmlsoap.org/soap/envelope/');
        TXmlWriter.WriteAttrString(Root, 'xmlns:tem', 'http://tempuri.org/');
        TXmlWriter.WriteAttrString(Root, 'xmlns:emk', 'http://schemas.datacontract.org/2004/07/EMKService.Data.Dto');

        // HEADER
        Node := Root.AddChild('soapenv:Header');

        // BODY
        // <soapenv:Body>
        Node := Root.AddChild('soapenv:Body');

        // GETPATIENT
        // <AddPatient xmlns="http://tempuri.org/">
        Node := Node.AddChild('GetPatient', 'http://tempuri.org/');
        TXmlWriter.WriteString(Node.AddChild('guid'), FGuid);
        TXmlWriter.WriteString(Node.AddChild('idLPU'), FIdLpu);

        PatientNode := Node.AddChild('patient');
        TXmlWriter.WriteAttrString(PatientNode, 'xmlns:a', 'http://schemas.datacontract.org/2004/07/EMKService.Data.Dto');
        TXmlWriter.WriteAttrString(PatientNode, 'xmlns:i', 'http://www.w3.org/2001/XMLSchema-instance');
        Patient.SaveToXml(PatientNode, 'GetPatient');

        TXmlWriter.WriteString(Node.AddChild('idSource'), FIdSourse);

        XmlDoc.SaveToStream(FRequestStream);

    finally
        XmlDoc := nil;
    end;
end;

end.
