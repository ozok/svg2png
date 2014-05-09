object AboutForm: TAboutForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'About'
  ClientHeight = 94
  ClientWidth = 250
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    250
    94)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 250
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'SVG2PNG v1.1.81'
    ExplicitWidth = 86
  end
  object Label2: TLabel
    Left = 0
    Top = 13
    Width = 250
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = '2014 (C) ozok - ozok26@gmail.com'
    ExplicitWidth = 168
  end
  object Label3: TLabel
    Left = 0
    Top = 26
    Width = 250
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'GPLv2. See gpl.txt.'
    ExplicitWidth = 94
  end
  object Label4: TLabel
    Left = 0
    Top = 39
    Width = 250
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'Batch SVG to PNG converter'
    ExplicitWidth = 135
  end
  object Button1: TButton
    Left = 167
    Top = 61
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 8
    Top = 61
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Homepage'
    TabOrder = 1
    OnClick = Button3Click
  end
end
