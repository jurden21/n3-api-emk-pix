unit XmlReaderUnit;

interface

uses
    System.SysUtils, System.Variants, Xml.XmlDoc, Xml.XmlIntf;

type
    TXmlReader = class
    public
        class function ReadString(const ANode: IXmlNode; const ADefault: String = ''): String;
        class function ReadInteger(const ANode: IXmlNode; const ADefault: Integer = 0): Integer;
        class function ReadDateTime(const ANode: IXmlNode; const ADefault: TDateTime = 0): TDateTime;
    end;

implementation

{ TXmlReader }

class function TXmlReader.ReadString(const ANode: IXmlNode; const ADefault: String): String;
begin
    Result := VarToStrDef(ANode.NodeValue, ADefault);
end;

class function TXmlReader.ReadInteger(const ANode: IXmlNode; const ADefault: Integer): Integer;
begin
    Result := StrToIntDef(VarToStrDef(ANode.NodeValue, ''), ADefault);
end;

class function TXmlReader.ReadDateTime(const ANode: IXmlNode; const ADefault: TDateTime): TDateTime;
var
    NodeValue: String;
begin
    NodeValue := ReadString(ANode);
    if NodeValue = ''
    then Result := ADefault
    else Result := EncodeDate(StrToIntDef(Copy(NodeValue, 1, 4), 0), StrToIntDef(Copy(NodeValue, 6, 2), 0), StrToIntDef(Copy(NodeValue, 9, 2), 0));
end;

end.
