{***************************************************************************************************
* Тип PatientObject
* BirthDate         1..1  Datetime  Дата рождения
* DeathTime         0..1  Datetime  Дата смерти
* FamilyName        1..1  String    Фамилия пациента
* GivenName         1..1  String    Имя пациента
* IdBloodType       0..1  Integer   Код группы крови (OID справочника: 1.2.643.2.69.1.1.1.3)
* IdLivingAreaType  0..1  Integer   Тип места жительства (Классификатор жителя города или села, OID 1.2.643.5.1.13.2.1.1.573)
* IdPatientMIS      1..1  String    Идентификатор пациента в передающей МИС
* MiddleName        0..1  String    Отчество пациента
* Sex               1..1  Integer   Код пола (Классификатор половой принадлежности, OID 1.2.643.5.1.13.2.1.1.156)
* SocialGroup       0..1  Integer   Код социальной группы (OID справочника: 1.2.643.2.69.1.1.1.4)
* SocialStatus      0..1  String    Код социального статуса пациента (OID справочника: 1.2.643.2.69.1.1.1.5)
* Documents         0..*            Документы
* Addresses         0..*            Адреса
* BirthPlace        0..1            Место рождения
* Contacts          0..*            Контактная информация пациента
* Job               0..1            Место работы пациента
* Privilege         0..1            Информация о льготе пациента
***************************************************************************************************}
unit PatientUnit;

interface

uses
    System.SysUtils, System.Generics.Collections, Vcl.Dialogs, Xml.XmlDoc, Xml.XmlIntf, DocumentUnit, AddressUnit, BirthPlaceUnit,
    ContactUnit, JobUnit, PrivilegeUnit;

type
    TPatientObject = class
    private
        FBirthDate: TDateTime;
        FDeathTime: TDateTime;
        FFamilyName: String;
        FGivenName: String;
        FIdBloodType: Integer;
        FIdLivingAreaType: Integer;
        FIdPatientMis: String;
        FMiddleName: String;
        FSex: Integer;
        FSocialGroup: Integer;
        FSocialStatus: String;
        FDocuments: TObjectList<TDocumentObject>;
        FAddresses: TObjectList<TAddressObject>;
        FBirthPlace: TBirthPlaceObject;
        FContacts: TObjectList<TContactObject>;
        FJob: TJobObject;
        FPrivilege: TPrivilegeObject;
    public
        property BirthDate: TDateTime read FBirthDate;
        property DeathTime: TDateTime read FDeathTime;
        property FamilyName: String read FFamilyName;
        property GivenName: String read FGivenName;
        property IdBloodType: Integer read FIdBloodType;
        property IdLivingAreaType: Integer read FIdLivingAreaType;
        property IdPatientMis: String read FIdPatientMis;
        property MiddleName: String read FMiddleName;
        property Sex: Integer read FSex;
        property SocialGroup: Integer read FSocialGroup;
        property SocialStatus: String read FSocialStatus;
        property Documents: TObjectList<TDocumentObject> read FDocuments;
        property Addresses: TObjectList<TAddressObject> read FAddresses;
        property BirthPlace: TBirthPlaceObject read FBirthPlace;
        property Contacts: TObjectList<TContactObject> read FContacts;
        property Job: TJobObject read FJob;
        property Privilege: TPrivilegeObject read FPrivilege;
        constructor Create(const ABirthDate, ADeathTime: TDateTime; const AFamilyName, AGivenName, AMiddleName: String; const AIdBloodType,
            AIdLivingAreaType: Integer; const AIdPatientMis: String; const ASex, ASocialGroup: Integer; const ASocialStatus: String;
            const ABirthPlace: TBirthPlaceObject; const AJob: TJobObject; const APrivilege: TPrivilegeObject); overload;
        constructor Create(const ANode: IXmlNode); overload;
        destructor Destroy; override;
        function AddDocument(const AItem: TDocumentObject): Integer;
        procedure ClearDocuments;
        function AddAddress(const AItem: TAddressObject): Integer;
        procedure ClearAddresses;
        function AddContact(const AItem: TContactObject): Integer;
        procedure ClearContacts;
        procedure SaveToXml(const ANode: IXmlNode; const AFormat: String);
    end;

implementation

uses XmlWriterUnit, XmlReaderUnit;

{ TPatientObject }

constructor TPatientObject.Create(const ABirthDate, ADeathTime: TDateTime; const AFamilyName, AGivenName, AMiddleName: String;
    const AIdBloodType, AIdLivingAreaType: Integer; const AIdPatientMis: String; const ASex, ASocialGroup: Integer;
    const ASocialStatus: String; const ABirthPlace: TBirthPlaceObject; const AJob: TJobObject; const APrivilege: TPrivilegeObject);
begin
    FBirthDate := ABirthDate;
    FDeathTime := ADeathTime;
    FFamilyName := AFamilyName;
    FGivenName := AGivenName;
    FMiddleName := AMiddleName;
    FIdBloodType := AIdBloodType;
    FIdLivingAreaType := AIdLivingAreaType;
    FIdPatientMis := AIdPatientMis;
    FSex := ASex;
    FSocialGroup := ASocialGroup;
    FSocialStatus := ASocialStatus;
    FBirthPlace := ABirthPlace;
    FJob := AJob;
    FPrivilege := APrivilege;

    FDocuments := TObjectList<TDocumentObject>.Create(True);
    FAddresses := TObjectList<TAddressObject>.Create(True);
    FContacts := TObjectList<TContactObject>.Create(True);
end;

constructor TPatientObject.Create(const ANode: IXmlNode);
var
    Index, Jndex: Integer;
begin
    FDocuments := TObjectList<TDocumentObject>.Create(True);
    FAddresses := TObjectList<TAddressObject>.Create(True);
    FContacts := TObjectList<TContactObject>.Create(True);

    for Index := 0 to ANode.ChildNodes.Count - 1 do
    begin
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:BirthDate')
        then FBirthDate := TXmlReader.ReadDateTime(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:DeathTime')
        then FDeathTime := TXmlReader.ReadDateTime(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:FamilyName')
        then FFamilyName := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:GivenName')
        then FGivenName := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:MiddleName')
        then FMiddleName := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IdBloodType')
        then FIdBloodType := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IdLivingAreaType')
        then FIdLivingAreaType := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:IdPatientMis')
        then FIdPatientMis := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Sex')
        then FSex := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:SocialGroup')
        then FSocialGroup := TXmlReader.ReadInteger(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:SocialStatus')
        then FSocialStatus := TXmlReader.ReadString(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:BirthPlace')
        then FBirthPlace := TBirthPlaceObject.Create(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Job')
        then FJob := TJobObject.Create(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Privilege')
        then FPrivilege := TPrivilegeObject.Create(ANode.ChildNodes[Index]);
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Documents')
        then begin
            for Jndex := 0 to ANode.ChildNodes[Index].ChildNodes.Count - 1 do
                FDocuments.Add(TDocumentObject.Create(ANode.ChildNodes[Index].ChildNodes[Jndex]));
        end;
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Addresses')
        then begin
            for Jndex := 0 to ANode.ChildNodes[Index].ChildNodes.Count - 1 do
                FAddresses.Add(TAddressObject.Create(ANode.ChildNodes[Index].ChildNodes[Jndex]));
        end;
        if LowerCase(ANode.ChildNodes[Index].NodeName) = LowerCase('a:Contacts')
        then begin
            for Jndex := 0 to ANode.ChildNodes[Index].ChildNodes.Count - 1 do
                FContacts.Add(TContactObject.Create(ANode.ChildNodes[Index].ChildNodes[Jndex]));
        end;
    end;
end;

destructor TPatientObject.Destroy;
begin
    FBirthPlace.Free;
    FJob.Free;
    FPrivilege.Free;
    FContacts.Free;
    FAddresses.Free;
    FDocuments.Free;
    inherited;
end;

function TPatientObject.AddDocument(const AItem: TDocumentObject): Integer;
begin
    Result := Documents.Add(AItem);
end;

procedure TPatientObject.ClearDocuments;
begin
    Documents.Clear;
end;

function TPatientObject.AddAddress(const AItem: TAddressObject): Integer;
begin
    Result := Addresses.Add(AItem);
end;

procedure TPatientObject.ClearAddresses;
begin
    Addresses.Clear;
end;

function TPatientObject.AddContact(const AItem: TContactObject): Integer;
begin
    Result := Contacts.Add(AItem);
end;

procedure TPatientObject.ClearContacts;
begin
    Contacts.Clear;
end;

procedure TPatientObject.SaveToXml(const ANode: IXmlNode; const AFormat: String);
var
    Node: IXmlNode;
    Index: Integer;
begin

    Node := ANode.AddChild('a:Addresses');
    if Addresses.Count = 0
    then TXmlWriter.WriteNull(Node)
    else begin
        for Index := 0 to Addresses.Count - 1 do
            Addresses[Index].SaveToXml(Node.AddChild('a:AddressDto'));
    end;

    TXmlWriter.WriteDate(ANode.AddChild('a:BirthDate'), BirthDate);

    Node := ANode.AddChild('a:BirthPlace');
    if BirthPlace = nil
    then TXmlWriter.WriteNull(Node)
    else BirthPlace.SaveToXml(Node);


    Node := ANode.AddChild('a:Contacts');
    if Contacts.Count = 0
    then TXmlWriter.WriteNull(Node)
    else begin
        for Index := 0 to Contacts.Count - 1 do
            Contacts[Index].SaveToXml(Node.AddChild('a:ContactDto'));
    end;

    TXmlWriter.WriteDateTimeNullable(ANode.AddChild('a:DeathTime'), DeathTime);

    Node := ANode.AddChild('a:Documents');
    if Documents.Count = 0
    then TXmlWriter.WriteNull(Node)
    else begin
        for Index := 0 to Documents.Count - 1 do
            Documents[Index].SaveToXml(Node.AddChild('a:DocumentDto'));
    end;

    if (AFormat = 'AddPatient') or (AFormat = 'UpdatePatient')
    then TXmlWriter.WriteString(ANode.AddChild('a:FamilyName'), FamilyName)
    else TXmlWriter.WriteStringNullable(ANode.AddChild('a:FamilyName'), FamilyName);
    if (AFormat = 'AddPatient') or (AFormat = 'UpdatePatient')
    then TXmlWriter.WriteString(ANode.AddChild('a:GivenName'), GivenName)
    else TXmlWriter.WriteStringNullable(ANode.AddChild('a:GivenName'), GivenName);
    TXmlWriter.WriteIntegerNullable(ANode.AddChild('a:IdBloodType'), IdBloodType);
    TXmlWriter.WriteIntegerNullable(ANode.AddChild('a:IdLivingAreaType'), IdLivingAreaType);
    TXmlWriter.WriteString(ANode.AddChild('a:IdPatientMIS'), IdPatientMis);

    Node := ANode.AddChild('a:Job');
    if Job = nil
    then TXmlWriter.WriteNull(Node)
    else Job.SaveToXml(Node);

    TXmlWriter.WriteStringNullable(ANode.AddChild('a:MiddleName'), MiddleName);

    Node := ANode.AddChild('a:Privilege');
    if Privilege = nil
    then TXmlWriter.WriteNull(Node)
    else Privilege.SaveToXml(Node);

    TXmlWriter.WriteInteger(ANode.AddChild('a:Sex'), Sex);
    TXmlWriter.WriteIntegerNullable(ANode.AddChild('a:SocialGroup'), SocialGroup);
    TXmlWriter.WriteStringNullable(ANode.AddChild('a:SocialStatus'), SocialStatus);
end;

end.
