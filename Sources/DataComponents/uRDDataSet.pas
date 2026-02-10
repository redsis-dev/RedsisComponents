unit uRDDataSet;

{$I Redsis.inc}

interface

uses
{$IFDEF FDC}
  uFDCDataSet,
{$ENDIF}
{$IFDEF Firedac}
  uFiredacDataSet,
{$ENDIF}
{$IFDEF IBX}
  uIBXDataSet,
{$ENDIF}
//{$IFDEF RDW}
//  uRDWDataSet,
//{$ENDIF}
  Classes, uRDTransaction, uRDConnection;

type
  TRDDataSet = class(TRDDataSetCustom)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TRDDataSet }

constructor TRDDataSet.Create(AOwner: TComponent);
begin
  inherited;
end;

end.
