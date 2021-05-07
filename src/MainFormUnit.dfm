object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 667
  ClientWidth = 1036
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ServiceGuidLabel: TLabel
    Left = 8
    Top = 12
    Width = 65
    Height = 13
    Caption = 'Service GUID'
  end
  object LpuGuidLabel: TLabel
    Left = 8
    Top = 32
    Width = 49
    Height = 13
    Caption = 'LPU GUID'
  end
  object AddPatientButton: TBitBtn
    Left = 4
    Top = 56
    Width = 177
    Height = 25
    Caption = 'AddPatient'
    TabOrder = 0
    OnClick = ProcessEventHandler
  end
  object UpdatePatientButton: TBitBtn
    Left = 4
    Top = 84
    Width = 177
    Height = 25
    Caption = 'UpdatePatient'
    TabOrder = 1
    OnClick = ProcessEventHandler
  end
  object RequestMemo: TMemo
    Left = 188
    Top = 56
    Width = 841
    Height = 417
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ResponseMemo: TMemo
    Left = 192
    Top = 480
    Width = 841
    Height = 181
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ServiceGuidEdit: TEdit
    Left = 188
    Top = 4
    Width = 841
    Height = 21
    TabOrder = 4
  end
  object LpuGuidEdit: TEdit
    Left = 188
    Top = 28
    Width = 841
    Height = 21
    TabOrder = 5
  end
  object GetPatientButton: TBitBtn
    Left = 4
    Top = 112
    Width = 177
    Height = 25
    Caption = 'GetPatient'
    TabOrder = 6
    OnClick = ProcessEventHandler
  end
  object GetPatientByGlobalIdButton: TBitBtn
    Left = 4
    Top = 140
    Width = 177
    Height = 25
    Caption = 'GetPatientByGlobalId'
    TabOrder = 7
    OnClick = ProcessEventHandler
  end
end
