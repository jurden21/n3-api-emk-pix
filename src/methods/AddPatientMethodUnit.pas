{***************************************************************************************************
* Тип AddPatientRequest
* Guid     1..1  Guid  Авторизационный токен
* IdLpu    1..1  Guid  Идентификатор МО
* Patient  1..1        Демографические данные пациента
***************************************************************************************************}
unit AddPatientMethodUnit;

interface

uses
    System.Classes, Xml.XmlDoc, Xml.XmlIntf, PixServiceMethodUnit, PatientUnit;

type
    TAddPatientMethod = class(TPixServiceMethod)
    private
        FPatient: TPatientObject;
    protected
        procedure CreateRequestStream; override;
    public
        property Patient: TPatientObject read FPatient;
        constructor Create(const AGuid, AIdLpu: String; const APatient: TPatientObject);
        destructor Destroy; override;
    end;

implementation

{ TAddPatientMethod }

uses XmlWriterUnit;

constructor TAddPatientMethod.Create(const AGuid, AIdLpu: String; const APatient: TPatientObject);
begin
    inherited Create(AGuid, AIdLpu);
    FSoapAction := '"http://tempuri.org/IPixService/AddPatient"';
    FPatient := APatient;
end;

destructor TAddPatientMethod.Destroy;
begin
    FPatient.Free;
    inherited;
end;

procedure TAddPatientMethod.CreateRequestStream;
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

        // ADDPATIENT
        // <AddPatient xmlns="http://tempuri.org/">
        Node := Node.AddChild('AddPatient', 'http://tempuri.org/');
        TXmlWriter.WriteString(Node.AddChild('guid'), FGuid);
        TXmlWriter.WriteString(Node.AddChild('idLPU'), FIdLpu);

        PatientNode := Node.AddChild('patient');
        TXmlWriter.WriteAttrString(PatientNode, 'xmlns:a', 'http://schemas.datacontract.org/2004/07/EMKService.Data.Dto');
        TXmlWriter.WriteAttrString(PatientNode, 'xmlns:i', 'http://www.w3.org/2001/XMLSchema-instance');
        Patient.SaveToXml(PatientNode, 'AddPatient');

        XmlDoc.SaveToStream(FRequestStream);

    finally
        XmlDoc := nil;
    end;
end;

end.
