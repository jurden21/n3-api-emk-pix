{***************************************************************************************************
* Тип Document
* IdDocumentType  1..1  Integer   Код типа документа (OID справочника: 1.2.643.2.69.1.1.1.6)
* DocS            0..1  String    Серия документа. Не должны использоваться разделители (пробелы, тире и т.д.)
* DocN            1..1  String    Номер документа. Не должны использоваться разделители (пробелы, тире и т.д.)
* ExpiredDate     0..1  DateTime  Дата окончания действия документа
* IssuedDate      0..1  DateTime  Дата выдачи
* IdProvider      0..1  Integer   Код организации, выдавшей документ. Заполняется только для полисов (Реестр страховых медицинских
*                                 организаций (ФОМС), OID справочника: 1.2.643.5.1.13.2.1.1.635)
* ProviderName    1..1  String    Наименование организации, выдавшей документ
* RegionCode      0..1  String    Код территории страхования
***************************************************************************************************}
unit DocumentUnit;

interface

uses
    System.SysUtils, Vcl.Dialogs, Xml.XmlDoc, Xml.XmlIntf;

type
    TDocumentObject = class
    private
        FIdDocumentType: Integer;
        FDocS: String;
        FDocN: String;
        FExpiredDate: TDateTime;
        FIssuedDate: TDateTime;
        FIdProvider: Integer;
        FProviderName: String;
        FRegionCode: String;
    public
        property IdDocumentType: Integer read FIdDocumentType;
        property DocS: String read FDocS;
        property DocN: String read FDocN;
        property ExpiredDate: TDateTime read FExpiredDate;
        property IssuedDate: TDateTime read FIssuedDate;
        property IdProvider: Integer read FIdProvider;
        property ProviderName: String read FProviderName;
        property RegionCode: String read FRegionCode;
        constructor Create(const AIdDocumentType: Integer; const ADocS, ADocN: String; const AExpiredDate, AIssuedDate: TDateTime;
            const AIdProvider: Integer; const AProviderName, ARegionCode: String); overload;
        constructor Create(const ANode: IXmlNode); overload;
        procedure SaveToXml(const ANode: IXmlNode);
    end;

implementation

uses XmlWriterUnit, XmlReaderUnit;

{ TDocumentObject }

constructor TDocumentObject.Create(const AIdDocumentType: Integer; const ADocS, ADocN: String; const AExpiredDate, AIssuedDate: TDateTime;
    const AIdProvider: Integer; const AProviderName, ARegionCode: String);
begin
    FIdDocumentType := AIdDocumentType;
    FDocS := ADocS;
    FDocN := ADocN;
    FExpiredDate := AExpiredDate;
    FIssuedDate := AIssuedDate;
    FIdProvider := AIdProvider;
    FProviderName := AProviderName;
    FRegionCode := ARegionCode;
end;

constructor TDocumentObject.Create(const ANode: IXmlNode);
var
    Index: Integer;
begin
    for Index := 0 to ANode.ChildNodes.Count - 1 do
    begin
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:DocN')
        then FDocN := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:DocS')
        then FDocS := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IdDocumentType')
        then FIdDocumentType := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IdProvider')
        then FIdProvider := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IssuedDate')
        then FIssuedDate := TXmlReader.ReadDateTime(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:ExpiredDate')
        then FExpiredDate := TXmlReader.ReadDateTime(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:ProviderName')
        then FProviderName := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:RegionCode')
        then FRegionCode := TXmlReader.ReadString(ANode.ChildNodes[Index]);
    end;
end;

procedure TDocumentObject.SaveToXml(const ANode: IXmlNode);
begin
    TXmlWriter.WriteString(ANode.AddChild('a:DocN'), DocN);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:DocS'), DocS);
    TXmlWriter.WriteInteger(ANode.AddChild('a:IdDocumentType'), IdDocumentType);
    TXmlWriter.WriteIntegerNullable(ANode.AddChild('a:IdProvider'), IdProvider);
    TXmlWriter.WriteDateNullable(ANode.AddChild('a:IssuedDate'), IssuedDate);
    TXmlWriter.WriteDateNullable(ANode.AddChild('a:ExpiredDate'), ExpiredDate);
    TXmlWriter.WriteString(ANode.AddChild('a:ProviderName'), ProviderName);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:RegionCode'), RegionCode);
end;

end.
