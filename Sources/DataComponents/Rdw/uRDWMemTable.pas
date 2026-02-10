unit uRDWMemTable;

interface

uses
  uRDWQuery, uDWDataset, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uDWConstsData, uRESTDWPoolerDB, uDWAbout;

type
  TRDMemTableCustom = class(TDWMemtable)
  private
    FFiltrarAlteracoes: Boolean;
    FControlarAlteracoes: Boolean;
    procedure SetControlarAlteracoes(const Value: Boolean);
    procedure SetFiltrarAlteracoes(const Value: Boolean);
  published
    property ControlarAlteracoes: Boolean read FControlarAlteracoes write SetControlarAlteracoes;
    property FiltrarAlteracoes: Boolean read FFiltrarAlteracoes write SetFiltrarAlteracoes;
  end;

implementation

{ TRDMemTableCustom }

procedure TRDMemTableCustom.SetControlarAlteracoes(const Value: Boolean);
begin
  FControlarAlteracoes := Value;
end;

procedure TRDMemTableCustom.SetFiltrarAlteracoes(const Value: Boolean);
begin
  FFiltrarAlteracoes := Value;
end;

end.
