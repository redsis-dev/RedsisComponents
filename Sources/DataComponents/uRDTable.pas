unit uRDTable;

{$I Redsis.inc}

interface

uses
{$IFDEF FDC}
  uFDCTable,
{$ENDIF}
{$IFDEF Firedac}
  uFiredacTable,
{$ENDIF}
{$IFDEF IBX}
  uIBXTable,
{$ENDIF}
//{$IFDEF RDW}
//  uRDWMemTable,
//{$ENDIF}
  Classes;

type
  TRDTable = class(TRDTableCustom)
  end;

implementation

{ TRDQuery }

end.
