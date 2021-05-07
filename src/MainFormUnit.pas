unit MainFormUnit;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
    Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
    TMainForm = class(TForm)
        AddPatientButton: TBitBtn;
        UpdatePatientButton: TBitBtn;
        RequestMemo: TMemo;
        ResponseMemo: TMemo;
        ServiceGuidEdit: TEdit;
        LpuGuidEdit: TEdit;
        ServiceGuidLabel: TLabel;
        LpuGuidLabel: TLabel;
        GetPatientButton: TBitBtn;
        GetPatientByGlobalIdButton: TBitBtn;
        procedure ProcessEventHandler(Sender: TObject);
    private
        procedure AddPatientMethodHandler;
        procedure UpdatePatientMethodHandler;
        procedure GetPatientMethodHandler;
        procedure GetPatientByGlobalIdMethodHandler;
    public
    end;

var
    MainForm: TMainForm;

implementation

{$R *.dfm}

uses XmlWriterUnit, AddressUnit, BirthPlaceUnit, ContactUnit, DocumentUnit, JobUnit, PrivilegeUnit, PatientUnit,
     AddPatientMethodUnit, UpdatePatientMethodUnit, GetPatientMethodUnit, GetPatientByGlobalIdMethodUnit;

procedure TMainForm.ProcessEventHandler(Sender: TObject);
begin
    if (Sender is TBitBtn)
    then begin
        if (Sender as TBitBtn) = AddPatientButton
        then AddPatientMethodHandler;
        if (Sender as TBitBtn) = UpdatePatientButton
        then UpdatePatientMethodHandler;
        if (Sender as TBitBtn) = GetPatientButton
        then GetPatientMethodHandler;
        if (Sender as TBitBtn) = GetPatientByGlobalIdButton
        then GetPatientByGlobalIdMethodHandler;
    end;
end;

procedure TMainForm.AddPatientMethodHandler;
var
    Patient: TPatientObject;
    Method: TAddPatientMethod;
    Text: TStringList;
begin

    Patient := TPatientObject.Create(
        EncodeDate(2000, 1, 1), TXmlWriter.DATETIME_NULL, 'Фамилия', 'Имя', 'Отчество', TXmlWriter.INTEGER_NULL, 1, 'IdPatientMis', 1, 1, '1.1',
        TBirthPlaceObject.Create('Страна', 'Регион', 'Город'),
        TJobObject.Create('1234567890123', 'Компания', '123', 'Position', EncodeDate(2000, 1, 1), EncodeDate(2010, 1, 1)),
        TPrivilegeObject.Create(10, EncodeDate(2000, 3, 1), EncodeDate(2005, 4, 1)));

    Method := TAddPatientMethod.Create(ServiceGuidEdit.Text, LpuGuidEdit.Text, Patient);

    Text := TStringList.Create;

    try

        Patient.ClearDocuments;
        Patient.AddDocument(TDocumentObject.Create(223, '0000', '123456', TXmlWriter.DATETIME_NULL, EncodeDate(2000, 1, 1), -1, 'ProviderName1', ''));
        Patient.AddDocument(TDocumentObject.Create(224, '', '789456', EncodeDate(2010, 1, 1), EncodeDate(2000, 1, 1), -1, 'ProviderName2', 'CODE'));

        Patient.ClearAddresses;
        Patient.AddAddress(TAddressObject.Create(1, 'Адрес1', 'Street1', 'Building1', 'Город1', 'Appartment1', 100001, 'GeoData1'));
        Patient.AddAddress(TAddressObject.Create(1, 'Адрес2', 'Street2', 'Building2', 'Город2', 'Appartment2', 100002, 'GeoData2'));

        Patient.ClearContacts;
        Patient.AddContact(TContactObject.Create(1, '000-000-00-00'));
        Patient.AddContact(TContactObject.Create(2, '111-111-11-11'));

        Method.Execute;

        Method.RequestStream.SaveToFile('.\AddPatient_request.xml');
        RequestMemo.Lines.LoadFromFile('.\AddPatient_request.xml');
        Method.ResponseStream.SaveToFile('.\AddPatient_response.xml');
        ResponseMemo.Lines.LoadFromFile('.\AddPatient_response.xml');

    finally
        Method.Free;
        Text.Free;
    end;

end;

procedure TMainForm.UpdatePatientMethodHandler;
var
    Patient: TPatientObject;
    Method: TUpdatePatientMethod;
    Text: TStringList;
begin

    Patient := TPatientObject.Create(
        EncodeDate(2000, 1, 1), TXmlWriter.DATETIME_NULL, 'Фамилия', 'Имя', 'Отчество', TXmlWriter.INTEGER_NULL, 1, 'IdPatientMis', 1, 1, '1.1',
        TBirthPlaceObject.Create('Страна', 'Регион', 'Город'),
        TJobObject.Create('1234567890123', 'Компания', '123', 'Position', EncodeDate(2000, 1, 1), EncodeDate(2010, 1, 1)),
        TPrivilegeObject.Create(10, EncodeDate(2000, 3, 1), EncodeDate(2005, 4, 1)));

    Method := TUpdatePatientMethod.Create(ServiceGuidEdit.Text, LpuGuidEdit.Text, Patient);

    Text := TStringList.Create;

    try

        Patient.ClearDocuments;
        Patient.AddDocument(TDocumentObject.Create(223, '0000', '123456', TXmlWriter.DATETIME_NULL, EncodeDate(2000, 1, 1), -1, 'ProviderName1', ''));
        Patient.AddDocument(TDocumentObject.Create(224, '', '789456', EncodeDate(2010, 1, 1), EncodeDate(2000, 1, 1), -1, 'ProviderName2', 'CODE'));

        Patient.ClearAddresses;
        Patient.AddAddress(TAddressObject.Create(1, 'Адрес1', 'Street1', 'Building1', 'Город1', 'Appartment1', 100001, 'GeoData1'));
        Patient.AddAddress(TAddressObject.Create(1, 'Адрес2', 'Street2', 'Building2', 'Город2', 'Appartment2', 100002, 'GeoData2'));

        Patient.ClearContacts;
        Patient.AddContact(TContactObject.Create(1, '000-000-00-00'));
        Patient.AddContact(TContactObject.Create(2, '111-111-11-11'));

        Method.Execute;

        Method.RequestStream.SaveToFile('.\UpdatePatient_request.xml');
        RequestMemo.Lines.LoadFromFile('.\UpdatePatient_request.xml');
        Method.ResponseStream.SaveToFile('.\UpdatePatient_response.xml');
        ResponseMemo.Lines.LoadFromFile('.\UpdatePatient_response.xml');

    finally
        Method.Free;
        Text.Free;
    end;

end;

procedure TMainForm.GetPatientMethodHandler;
var
    Patient: TPatientObject;
    Method: TGetPatientMethod;
    Text: TStringList;
begin

    Patient := TPatientObject.Create(
        EncodeDate(2000, 1, 1), TXmlWriter.DATETIME_NULL, TXmlWriter.STRING_NULL, TXmlWriter.STRING_NULL, TXmlWriter.STRING_NULL,
        TXmlWriter.INTEGER_NULL, TXmlWriter.INTEGER_NULL, 'IdPatientMis', 1, TXmlWriter.INTEGER_NULL, TXmlWriter.STRING_NULL,
        nil, nil, nil);

    Method := TGetPatientMethod.Create(ServiceGuidEdit.Text, LpuGuidEdit.Text, 'Reg', Patient);

    Text := TStringList.Create;

    try

        Patient.ClearDocuments;
        Patient.ClearAddresses;
        Patient.ClearContacts;

        Method.Execute;

        Method.RequestStream.SaveToFile('.\GetPatient_request.xml');
        RequestMemo.Lines.LoadFromFile('.\GetPatient_request.xml');
        Method.ResponseStream.SaveToFile('.\GetPatient_response.xml');
        ResponseMemo.Lines.LoadFromFile('.\GetPatient_response.xml');

    finally
        Method.Free;
        Text.Free;
    end;

end;

procedure TMainForm.GetPatientByGlobalIdMethodHandler;
var
    Method: TGetPatientByGlobalIdMethod;
    Text: TStringList;
begin

    Method := TGetPatientByGlobalIdMethod.Create(ServiceGuidEdit.Text, LpuGuidEdit.Text, 'IdPatientMis', LpuGuidEdit.Text);

    Text := TStringList.Create;

    try

        Method.Execute;

        Method.RequestStream.SaveToFile('.\GetPatientByGlobalId_request.xml');
        RequestMemo.Lines.LoadFromFile('.\GetPatientByGlobalId_request.xml');
        Method.ResponseStream.SaveToFile('.\GetPatientByGlobalId_response.xml');
        ResponseMemo.Lines.LoadFromFile('.\GetPatientByGlobalId_response.xml');

    finally
        Method.Free;
        Text.Free;
    end;

end;

end.
