unit uRDCommand;

{$I Redsis.inc}

interface

uses
{$IFDEF FDC}
  uFDCCommand,
{$ENDIF}
{$IFDEF IBX}
  uIBXCCommand,
{$ENDIF}
{$IFDEF RDW}
  uRDWCommand,
{$ENDIF}
  Classes;

type
  TRDCommand = class(TRDCommandCustom)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TRDCustomCommand = TRDCommandCustom;

implementation

{ TRDQuery }

constructor TRDCommand.Create(AOwner: TComponent);
begin
  inherited;
end;

end.
