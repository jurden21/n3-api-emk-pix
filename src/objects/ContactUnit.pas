{***************************************************************************************************
* Тип Contact
* IdContactType  1..1  Integer  Идентификатор типа контакта (OID справочника: 1.2.643.2.69.1.1.1.27)
* ContactValue   1..1  String   Содержание контактной информации
***************************************************************************************************}
unit ContactUnit;

interface

uses
    System.SysUtils, Xml.XmlDoc, Xml.XmlIntf;

type
    TContactObject = class
    private
        FIdContactType: Integer;
        FContactValue: String;
    public
        property IdContactType: Integer read FIdContactType;
        property ContactValue: String read FContactValue;
        constructor Create(const AIdContactType: Integer; const AContactValue: String); overload;
        constructor Create(const ANode: IXmlNode); overload;
        procedure SaveToXml(const ANode: IXmlNode);
    end;

implementation

uses XmlWriterUnit, XmlReaderUnit;

{ TContactObject }

constructor TContactObject.Create(const AIdContactType: Integer; const AContactValue: String);
begin
    FIdContactType := AIdContactType;
    FContactValue := AContactValue;
end;

constructor TContactObject.Create(const ANode: IXmlNode);
var
    Index: Integer;
begin
    for Index := 0 to ANode.ChildNodes.Count - 1 do
    begin
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:ContactValue')
        then FContactValue := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IdContactType')
        then FIdContactType := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
    end;
end;

procedure TContactObject.SaveToXml(const ANode: IXmlNode);
begin
    TXmlWriter.WriteString(ANode.AddChild('a:ContactValue'), ContactValue);
    TXmlWriter.WriteInteger(ANode.AddChild('a:IdContactType'), IdContactType);
end;

end.
