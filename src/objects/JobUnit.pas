{***************************************************************************************************
* Тип Job
* OgrnCode     0..1  String     Код ОГРН работодателя
* CompanyName  1..1  String     Наименование предприятия
* Sphere       0..1  String     Код наименования отрасли (Общероссийский классификатор видов экономической деятельности, OID 1.2.643.5.1.13.2.1.1.62)
* Position     0..1  String     Наименование должности пациента
* DateStart    0..1  DateTime   Дата начала работы
* DateEnd      0..1  DateTime   Дата окончания работы
***************************************************************************************************}
unit JobUnit;

interface

uses
    System.SysUtils, Xml.XmlDoc, Xml.XmlIntf;

type
    TJobObject = class
    private
        FOgrnCode: String;
        FCompanyName: String;
        FSphere: String;
        FPosition: String;
        FDateStart: TDateTime;
        FDateEnd: TDateTime;
    public
        property OgrnCode: String read FOgrnCode;
        property CompanyName: String read FCompanyName;
        property Sphere: String read FSphere;
        property Position: String read FPosition;
        property DateStart: TDateTime read FDateStart;
        property DateEnd: TDateTime read FDateEnd;
        constructor Create(const AOgrnCode, ACompanyName, ASphere, APosition: String; const ADateStart, ADateEnd: TDateTime); overload;
        constructor Create(const ANode: IXmlNode); overload;
        procedure SaveToXml(const ANode: IXmlNode);
    end;

implementation

uses XmlWriterUnit, XmlReaderUnit;

{ TJobObject }

constructor TJobObject.Create(const AOgrnCode, ACompanyName, ASphere, APosition: String; const ADateStart, ADateEnd: TDateTime);
begin
    FOgrnCode := AOgrnCode;
    FCompanyName := ACompanyName;
    FSphere := ASphere;
    FPosition := APosition;
    FDateStart := ADateStart;
    FDateEnd := ADateEnd;
end;

constructor TJobObject.Create(const ANode: IXmlNode);
var
    Index: Integer;
begin
    for Index := 0 to ANode.ChildNodes.Count - 1 do
    begin
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:CompanyName')
        then FCompanyName := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:DateEnd')
        then FDateEnd := TXmlReader.ReadDateTime(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:DateStart')
        then FDateStart := TXmlReader.ReadDateTime(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:OgrnCode')
        then FOgrnCode := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Position')
        then FPosition := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Sphere')
        then FSphere := TXmlReader.ReadString(ANode.ChildNodes[Index]);
    end;
end;

procedure TJobObject.SaveToXml(const ANode: IXmlNode);
begin
    TXmlWriter.WriteString(ANode.AddChild('a:CompanyName'), CompanyName);
    TXmlWriter.WriteDateNullable(ANode.AddChild('a:DateEnd'), DateEnd);
    TXmlWriter.WriteDateNullable(ANode.AddChild('a:DateStart'), DateStart);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:OgrnCode'), OgrnCode);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:Position'), Position);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:Sphere'), Sphere);
end;

end.
