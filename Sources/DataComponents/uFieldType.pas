unit uFieldType;

{$I Redsis.inc}

interface

uses
{$IFDEF FDC}
  uFDCFieldType,
{$ENDIF}
{$IFDEF Firedac}
  uFiredacFieldType,
{$ENDIF}
{$IFDEF IBX}
  uIBXFieldType,
{$ENDIF}
//{$IFDEF RDW}
//  uRDWFieldType,
//{$ENDIF}
  Classes;

type
  TRDStringField = class(TRDStringFieldCustom);
  TRDDateTimeField = class(TRDDateTimeFieldCustom);
  TRDStringFieldType = TRDStringFieldCustom;
  TRDDateTimeFieldType = TRDDateTimeFieldCustom;

implementation

end.
