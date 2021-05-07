program N3APIPix;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  XmlReaderUnit in 'services\XmlReaderUnit.pas',
  XmlWriterUnit in 'services\XmlWriterUnit.pas',
  ServiceMethodUnit in 'services\ServiceMethodUnit.pas',
  AddressUnit in 'objects\AddressUnit.pas',
  BirthPlaceUnit in 'objects\BirthPlaceUnit.pas',
  ContactUnit in 'objects\ContactUnit.pas',
  DocumentUnit in 'objects\DocumentUnit.pas',
  JobUnit in 'objects\JobUnit.pas',
  PrivilegeUnit in 'objects\PrivilegeUnit.pas',
  PatientUnit in 'objects\PatientUnit.pas',
  AddPatientMethodUnit in 'methods\AddPatientMethodUnit.pas',
  PixServiceMethodUnit in 'methods\PixServiceMethodUnit.pas',
  UpdatePatientMethodUnit in 'methods\UpdatePatientMethodUnit.pas',
  GetPatientMethodUnit in 'methods\GetPatientMethodUnit.pas',
  GetPatientByGlobalIdMethodUnit in 'methods\GetPatientByGlobalIdMethodUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
