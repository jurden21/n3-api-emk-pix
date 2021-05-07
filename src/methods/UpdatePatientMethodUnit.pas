{***************************************************************************************************
* Тип UpdatePatientRequest
* Guid     1..1  Guid  Авторизационный токен
* IdLpu    1..1  Guid  Идентификатор МО
* Patient  1..1        Демографические данные пациента
***************************************************************************************************}
unit UpdatePatientMethodUnit;

interface

uses
    System.Classes, Xml.XmlDoc, Xml.XmlIntf, PixServiceMethodUnit, PatientUnit;

type
    TUpdatePatientMethod = class(TPixServiceMethod)
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

uses XmlWriterUnit;

{ TUpdatePatientMethod }

constructor TUpdatePatientMethod.Create(const AGuid, AIdLpu: String; const APatient: TPatientObject);
begin
    inherited Create(AGuid, AIdLpu);
    FSoapAction := '"http://tempuri.org/IPixService/UpdatePatient"';
    FPatient := APatient;
end;

destructor TUpdatePatientMethod.Destroy;
begin
    FPatient.Free;
    inherited;
end;

procedure TUpdatePatientMethod.CreateRequestStream;
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

        // UPDATEPATIENT
        // <AddPatient xmlns="http://tempuri.org/">
        Node := Node.AddChild('UpdatePatient', 'http://tempuri.org/');
        TXmlWriter.WriteString(Node.AddChild('guid'), FGuid);
        TXmlWriter.WriteString(Node.AddChild('idLPU'), FIdLpu);

        PatientNode := Node.AddChild('patient');
        TXmlWriter.WriteAttrString(PatientNode, 'xmlns:a', 'http://schemas.datacontract.org/2004/07/EMKService.Data.Dto');
        TXmlWriter.WriteAttrString(PatientNode, 'xmlns:i', 'http://www.w3.org/2001/XMLSchema-instance');
        Patient.SaveToXml(PatientNode, 'UpdatePatient');

        XmlDoc.SaveToStream(FRequestStream);

    finally
        XmlDoc := nil;
    end;
end;

end.
