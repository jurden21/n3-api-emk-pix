{***************************************************************************************************
* Тип Address
* IdAddressType  1..1  Integer  Идентификатор типа адреса (OID справочника: 1.2.643.2.69.1.1.1.28)
* StringAddress  1..1  String   Адрес строкой
* Street         0..1  String   Код улицы. Значение КЛАДР
* Building       0..1  String   Номер дома
* City           0..1  String   Код города КЛАДР
* Appartment     0..1  String   Номер квартиры
* PostalCode     0..1  Integer  Индекс
* GeoData        0..1  String   Геокоординаты объекта
***************************************************************************************************}
unit AddressUnit;

interface

uses
    System.SysUtils, Xml.XmlDoc, Xml.XmlIntf;

type
    TAddressObject = class
    private
        FIdAddressType: Integer;
        FStringAddress: String;
        FStreet: String;
        FBuilding: String;
        FCity: String;
        FAppartment: String;
        FPostalCode: Integer;
        FGeoData: String;
    public
        property IdAddressType: Integer read FIdAddressType;
        property StringAddress: String read FStringAddress;
        property Street: String read FStreet;
        property Building: String read FBuilding;
        property City: String read FCity;
        property Appartment: String read FAppartment;
        property PostalCode: Integer read FPostalCode;
        property GeoData: String read FGeoData;
        constructor Create(const AIdAddressType: Integer; const AStringAddress, AStreet, ABuilding, ACity, AAppartment: String;
            const APostalCode: Integer; const AGeoData: String); overload;
        constructor Create(const ANode: IXmlNode); overload;
        procedure SaveToXml(const ANode: IXmlNode);
    end;

implementation

uses XmlWriterUnit, XmlReaderUnit;

{ TAddressObject }

constructor TAddressObject.Create(const AIdAddressType: Integer; const AStringAddress, AStreet, ABuilding, ACity, AAppartment: String;
    const APostalCode: Integer; const AGeoData: String);
begin
    FIdAddressType := AIdAddressType;
    FStringAddress := AStringAddress;
    FStreet := AStreet;
    FBuilding := ABuilding;
    FCity := ACity;
    FAppartment := AAppartment;
    FPostalCode := APostalCode;
    FGeoData := AGeoData;
end;

constructor TAddressObject.Create(const ANode: IXmlNode);
var
    Index: Integer;
begin
    for Index := 0 to ANode.ChildNodes.Count - 1 do
    begin
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IdAddressType')
        then FIdAddressType := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:StringAddress')
        then FStringAddress := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Street')
        then FStreet := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Building')
        then FBuilding := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:City')
        then FCity := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Appartment')
        then FAppartment := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:PostalCode')
        then FPostalCode := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:GeoData')
        then FGeoData := TXmlReader.ReadString(ANode.ChildNodes[Index]);
    end;
end;

procedure TAddressObject.SaveToXml(const ANode: IXmlNode);
begin
    TXmlWriter.WriteInteger(ANode.AddChild('a:IdAddressType'), IdAddressType);
    TXmlWriter.WriteString(ANode.AddChild('a:StringAddress'), StringAddress);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:Street'), Street);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:Building'), Building);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:City'), City);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:Appartment'), Appartment);
    TXmlWriter.WriteIntegerNullable(ANode.AddChild('a:PostalCode'), PostalCode);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:GeoData'), GeoData);
end;

end.
