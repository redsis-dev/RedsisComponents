unit uRDTransaction;

{$I Redsis.inc}

interface

uses
{$IFDEF FDC}
  uFDCTransaction,
{$ENDIF}
{$IFDEF Firedac}
  uFiredacTransaction,
{$ENDIF}
{$IFDEF IBX}
  uIBXTransaction,
{$ENDIF}
//{$IFDEF RDW}
//  uRDWTransaction,
//{$ENDIF}
  Classes;

type
  TRDTransaction = class(TRDTransactionCustom)
  end;

implementation

{ TRDQuery }

end.
