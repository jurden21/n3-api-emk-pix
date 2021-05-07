unit XmlWriterUnit;

interface

uses
    System.SysUtils, System.DateUtils, System.TimeSpan, Xml.XmlDoc, Xml.XmlIntf;

type
    TXmlWriter = class
    public const
        STRING_NULL = '';
        DATETIME_NULL = 0;
        DATETIME_DEFAULT = 1;
        INTEGER_NULL = -1;
        FLOAT_NULL = -1;
    private
    public
        class procedure WriteString(const ANode: IXmlNode; const AValue: String);
        class procedure WriteStringNullable(const ANode: IXmlNode; const AValue: String);
        class procedure WriteInteger(const ANode: IXmlNode; const AValue: Integer);
        class procedure WriteIntegerNullable(const ANode: IXmlNode; const AValue: Integer);
        class procedure WriteDateTime(const ANode: IXmlNode; const AValue: TDateTime);
        class procedure WriteDateTimeNullable(const ANode: IXmlNode; const AValue: TDateTime);
        class procedure WriteDate(const ANode: IXmlNode; const AValue: TDateTime);
        class procedure WriteDateNullable(const ANode: IXmlNode; const AValue: TDateTime);
        class procedure WriteBoolean(const ANode: IXmlNode; const AValue: Boolean);
        class procedure WriteFloat(const ANode: IXmlNode; const AValue: Real);
        class procedure WriteFloatNullable(const ANode: IXmlNode; const AValue: Real);
        class procedure WriteAttrString(const ANode: IXmlNode; const AAttrName: String; const AValue: String);
        class procedure WriteNull(const ANode: IXmlNode);
    end;

implementation

{ TXmlWriter }

class procedure TXmlWriter.WriteString(const ANode: IXmlNode; const AValue: String);
begin
    ANode.NodeValue := AValue;
end;

class procedure TXmlWriter.WriteStringNullable(const ANode: IXmlNode; const AValue: String);
begin
    if AValue <> STRING_NULL
    then WriteString(ANode, AValue)
    else WriteNull(ANode);
end;

class procedure TXmlWriter.WriteInteger(const ANode: IXmlNode; const AValue: Integer);
begin
    ANode.NodeValue := AValue;
end;

class procedure TXmlWriter.WriteIntegerNullable(const ANode: IXmlNode; const AValue: Integer);
begin
    if AValue <> INTEGER_NULL
    then WriteInteger(ANode, AValue)
    else WriteNull(ANode);
end;

class procedure TXmlWriter.WriteDateTime(const ANode: IXmlNode; const AValue: TDateTime);
begin
    ANode.NodeValue := FormatDateTime('YYYY-MM-DD', AValue) + 'T' + FormatFloat('00', HourOf(AValue)) + ':' +
                       FormatFloat('00', MinuteOf(AValue)) + ':' + FormatFloat('00', SecondOf(AValue)); // + GetTimeZone;
end;

class procedure TXmlWriter.WriteDateTimeNullable(const ANode: IXmlNode; const AValue: TDateTime);
begin
    if AValue <> DATETIME_NULL
    then WriteDateTime(ANode, AValue)
    else WriteNull(ANode);
end;

class procedure TXmlWriter.WriteDate(const ANode: IXmlNode; const AValue: TDateTime);
begin
    WriteDateTime(ANode, Trunc(AValue));
end;

class procedure TXmlWriter.WriteDateNullable(const ANode: IXmlNode; const AValue: TDateTime);
begin
    WriteDateTimeNullable(ANode, Trunc(AValue));
end;

class procedure TXmlWriter.WriteBoolean(const ANode: IXmlNode; const AValue: Boolean);
begin
   if AValue
   then WriteString(ANode, 'true')
   else WriteString(ANode, 'false');
end;

class procedure TXmlWriter.WriteFloat(const ANode: IXmlNode; const AValue: Real);
begin
    ANode.NodeValue := AValue;
end;

class procedure TXmlWriter.WriteFloatNullable(const ANode: IXmlNode; const AValue: Real);
begin
    if AValue <> FLOAT_NULL
    then ANode.NodeValue := AValue
    else WriteNull(ANode);
end;

class procedure TXmlWriter.WriteAttrString(const ANode: IXmlNode; const AAttrName, AValue: String);
begin
    ANode.Attributes[AAttrName] := AValue;
end;

class procedure TXmlWriter.WriteNull(const ANode: IXmlNode);
begin
    WriteAttrString(ANode, 'i:nil', 'true');
end;

end.
