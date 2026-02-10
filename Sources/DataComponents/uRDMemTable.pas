unit uRDMemTable;

{$I Redsis.inc}

interface

uses
{$IFDEF FDC}
  uFDCMemTable,
{$ENDIF}
{$IFDEF Firedac}
  uFiredacMemTable,
{$ENDIF}
{$IFDEF IBX}
  uIBXTable,
{$ENDIF}
//{$IFDEF RDW}
//  uRDWMemTable,
//{$ENDIF}
  Classes;

type
  TRDMemTable = class(TRDMemTableCustom)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TRDCustomMemTable = TRDMemTableCustom;

implementation

{ TRDMemTable }

constructor TRDMemTable.Create(AOwner: TComponent);
begin
  inherited;
end;

end.
