unit uFDCCommand;

interface

uses
  System.Classes, FireDAC.Comp.Client;

type
  TRDCommandCustom = class(TFDCommand)
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoBeforeExecute; override;
  end;

implementation

uses
  System.SysUtils;

{ TRDCommandCustom }

constructor TRDCommandCustom.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TRDCommandCustom.DoBeforeExecute;
begin
  inherited;
  CommandText.Text := StringReplace(CommandText.Text, '"', #39, [rfReplaceAll]);
end;

end.
