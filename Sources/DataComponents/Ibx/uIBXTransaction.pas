unit uIBXTransaction;

{$I Redsis.inc}

interface

uses
  Classes {$IFDEF VER150}, IBDatabase{$ELSE}, IBX.IBDatabase{$ENDIF};

type
  TRDTransactionCustom = class(TIBTransaction)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TRDTransactionCustom }

constructor TRDTransactionCustom.Create(AOwner: TComponent);
begin
  inherited;
  Self.Params.Clear;
  Self.Params.Add('read_committed');
  Self.Params.Add('rec_version');
  Self.Params.Add('nowait');
end;

end.

