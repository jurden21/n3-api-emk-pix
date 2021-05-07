{***************************************************************************************************
* Тип BirthPlace
* Country  1..1  String  Страна
* Region   1..1  String  Регион
* City     1..1  String  Населенный пункт
***************************************************************************************************}
unit BirthPlaceUnit;

interface

uses
    System.SysUtils, Xml.XmlDoc, Xml.XmlIntf;

type
    TBirthPlaceObject = class
    private
        FCountry: String;
        FRegion: String;
        FCity: String;
    public
        property Country: String read FCountry;
        property Region: String read FRegion;
        property City: String read FCity;
        constructor Create(const ACountry, ARegion, ACity: String); overload;
        constructor Create(const ANode: IXmlNode); overload;
        procedure SaveToXml(const ANode: IXmlNode);
    end;

implementation

uses XmlWriterUnit, XmlReaderUnit;

{ TBirthPlaceObject }

constructor TBirthPlaceObject.Create(const ACountry, ARegion, ACity: String);
begin
    FCountry := ACountry;
    FRegion := ARegion;
    FCity := ACity;
end;

constructor TBirthPlaceObject.Create(const ANode: IXmlNode);
var
    Index: Integer;
begin
    for Index := 0 to ANode.ChildNodes.Count - 1 do
    begin
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:City')
        then FCity := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Country')
        then FCountry := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Region')
        then FRegion := TXmlReader.ReadString(ANode.ChildNodes[Index]);
    end;
end;

procedure TBirthPlaceObject.SaveToXml(const ANode: IXmlNode);
begin
    TXmlWriter.WriteString(ANode.AddChild('a:City'), City);
    TXmlWriter.WriteString(ANode.AddChild('a:Country'), Country);
    TXmlWriter.WriteString(ANode.AddChild('a:Region'), Region);
end;

end.
