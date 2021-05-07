{***************************************************************************************************
* Тип Privilege
* IdPrivilegeType  1..1  Integer   Идентификатор категории льготности (OID справочника: 1.2.643.2.69.1.1.1.7)
* DateStart        1..1  DateTime  Дата начала действия льготы
* DateEnd          1..1  DateTime  Дата окончания действия льготы
***************************************************************************************************}
unit PrivilegeUnit;

interface

uses
    System.SysUtils, Xml.XmlDoc, Xml.XmlIntf;

type
    TPrivilegeObject = class
    private
        FIdPrivilegeType: Integer;
        FDateStart: TDateTime;
        FDateEnd: TDateTime;
    public
        property IdPrivilegeType: Integer read FIdPrivilegeType;
        property DateStart: TDateTime read FDateStart;
        property DateEnd: TDateTime read FDateEnd;
        constructor Create(const AIdPrivilegeType: Integer; const ADateStart, ADateEnd: TDateTime); overload;
        constructor Create(const ANode: IXmlNode); overload;
        procedure SaveToXml(const ANode: IXmlNode);
    end;

implementation

uses XmlReaderUnit, XmlWriterUnit;

{ TPrivilegeObject }

constructor TPrivilegeObject.Create(const AIdPrivilegeType: Integer; const ADateStart, ADateEnd: TDateTime);
begin
    FIdPrivilegeType := AIdPrivilegeType;
    FDateStart := ADateStart;
    FDateEnd := ADateEnd;
end;

constructor TPrivilegeObject.Create(const ANode: IXmlNode);
var
    Index: Integer;
begin
    for Index := 0 to ANode.ChildNodes.Count - 1 do
    begin
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IdPrivilegeType')
        then FIdPrivilegeType := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:DateStart')
        then FDateStart := TXmlReader.ReadDateTime(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:DateEnd')
        then FDateEnd := TXmlReader.ReadDateTime(ANode.ChildNodes[Index]);
    end;
end;

procedure TPrivilegeObject.SaveToXml(const ANode: IXmlNode);
begin
    TXmlWriter.WriteDateTime(ANode.AddChild('a:DateEnd'), DateEnd);
    TXmlWriter.WriteDateTime(ANode.AddChild('a:DateStart'), DateStart);
    TXmlWriter.WriteInteger(ANode.AddChild('a:IdPrivilegeType'), IdPrivilegeType);
end;

end.
