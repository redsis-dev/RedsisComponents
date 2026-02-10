unit uFDCMemTable;

interface

uses
  System.Classes, Data.DB, System.SysUtils, uRDConnection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TRDMemTableCustom = class(TFDMemTable)
  private
    FControlarAlteracoes: Boolean;
    FFiltrarAlteracoes: Boolean;
    procedure SetControlarAlteracoes(const Value: Boolean);
    procedure SetFiltrarAlteracoes(const Value: Boolean);
  public
    procedure SetFilterText(const Value: string); override;
  published
    property ControlarAlteracoes: Boolean read FControlarAlteracoes write SetControlarAlteracoes;
    property FiltrarAlteracoes: Boolean read FFiltrarAlteracoes write SetFiltrarAlteracoes;
  end;

implementation

{ TRDMemTableCustom }

procedure TRDMemTableCustom.SetControlarAlteracoes(const Value: Boolean);
begin
  FControlarAlteracoes := Value;
  if FControlarAlteracoes then
  begin
    CachedUpdates := False;
    CachedUpdates := True;
  end;
end;

procedure TRDMemTableCustom.SetFilterText(const Value: string);
begin
  inherited SetFilterText(StringReplace(Value, '"', #39, [rfReplaceAll]));
end;

procedure TRDMemTableCustom.SetFiltrarAlteracoes(const Value: Boolean);
begin
  FFiltrarAlteracoes := Value;
  if FFiltrarAlteracoes then
    FilterChanges := [rtModified]
  else
    FilterChanges := [rtUnmodified, rtModified, rtInserted];
end;

end.
